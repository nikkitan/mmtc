package com.mmtc.exam;

import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
//import org.apache.tomcat.dbcp.dbcp2.BasicDataSource;
import org.apache.tomcat.jdbc.pool.DataSource;
//import javax.sql.DataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jndi.JndiObjectFactoryBean;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.JsonArray;
import com.mmtc.exam.dao.Test;
import com.mmtc.exam.dao.TestSuite;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

//http://springinpractice.com/2010/07/06/spring-security-database-schemas-for-mysql
/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	@Autowired
	private JndiObjectFactoryBean jndiObjFactoryBean;		
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	private static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");	
    private final int AES_KEYLENGTH = 128;	// change this as desired for the security level you want
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		DataSource dataSource = (DataSource) jndiObjFactoryBean.getObject();

		int i = dataSource.getPoolSize();
		logger.info("Pool size: " + i);		
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		
		model.addAttribute("serverTime", formattedDate );
		
		return "home";
	}
	@RequestMapping(value = "/testsuite", method = RequestMethod.GET)
	public @ResponseBody ModelAndView examGET(Locale locale, Model model,
			HttpServletRequest request, 
			HttpServletResponse response) {
		logger.info(request.getRequestURL().toString());
		DataSource dataSource = (DataSource) jndiObjFactoryBean.getObject();
		ModelAndView resultView = new ModelAndView();
		ArrayList<String> suites = new ArrayList<String>();
		String sql = "SELECT name FROM testsuite";
		try{
			Connection conn = dataSource.getConnection();
			ResultSet s = conn.createStatement().executeQuery(sql);
			while(s.next()){
				suites.add(s.getString("name"));
			}
			conn.close();
		}catch(Exception e){
			e.printStackTrace();
			logger.error("[testsuite] " + e.getMessage());			
		}
		resultView.setViewName("testsuite");
		resultView.addObject("suites", suites);
        //Map<String, Object> resultModel = new HashMap<String, Object>();
        //resultModel.put("suites", suites);
		//return new ModelAndView("testsuite");//,"model",resultModel);
		return resultView;
	}
	@RequestMapping(value="/addtestsuite", method=RequestMethod.GET)
    public String addTestSuiteGET(Locale locale, Model model,
			HttpServletRequest request, 
			HttpServletResponse response){
		logger.debug(request.getRequestURL().toString());
		return "addsuite";
	}
	//http://www.codejava.net/frameworks/spring/spring-mvc-form-handling-tutorial-and-example
	@RequestMapping(value="/edittests", method=RequestMethod.GET)
    public @ResponseBody ModelAndView editTestSuiteGET(
			HttpServletRequest request, 
			HttpServletResponse response){
		logger.info(request.getRequestURL().toString());
		DataSource dataSource = (DataSource) jndiObjFactoryBean.getObject();
		TestSuite ts = new TestSuite(null);
		ModelAndView resultView = new ModelAndView();
		resultView.setViewName("editsuite");
		resultView.addObject("ts", ts);
		ArrayList<String> suites = getTestSuites();	
		resultView.addObject("suites", suites);
        return resultView;
	}
	
	@RequestMapping(value="/listtest", method=RequestMethod.POST)
    public @ResponseBody ModelAndView editTestPOST(
    		@ModelAttribute("ts") TestSuite ts,
			HttpServletRequest request, 
			HttpServletResponse response){
		logger.info(request.getRequestURL().toString());
		logger.info("[GOT_TS] " + ts.getName());
		ArrayList<String> suites = getTestSuites();	
		
        return new ModelAndView("listtest","tests",getTests(ts.getName()));
	}
	
	@RequestMapping(value="/uploadtestsuite", method=RequestMethod.POST)
    public @ResponseBody ModelAndView uploadTestSuitePOST(
    		@RequestParam("name") String suitename,
			HttpServletRequest request, 
			HttpServletResponse response,
    		@RequestParam("file") MultipartFile file){
		logger.info(request.getRequestURL().toString());
		if(suitename == null || suitename.length() == 0)
            return new ModelAndView("result","result","Error: Missing testsuite name.");

        if (!file.isEmpty()) {            
            DataSource dataSource = (DataSource) jndiObjFactoryBean.getObject();
    		String sqlTemplate = null;
    		String sql = "INSERT INTO testsuite (`name`) VALUES (?)";
    		PreparedStatement preparedSql = null;
    		Long rowID = null;
    		Connection conn = null;
    		try {
    			conn = dataSource.getConnection();					
    			preparedSql = conn.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS);
    			preparedSql.setNString(1, suitename);
    			preparedSql.executeUpdate();
    			ResultSet r = preparedSql.getGeneratedKeys();
    			r.next();
    			rowID = r.getLong(1);
    		} catch (SQLException e) {
    			e.printStackTrace();
    			logger.error("[uploadtestsuite] " + e.getMessage());
    			return new ModelAndView("result","result","Error: " + e.getMessage());
    		} finally{
        		sql = null;
    			try {
					preparedSql.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} finally{
					preparedSql = null;
				}
    			try {
					conn.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} finally{
					conn = null;
				}   			
    		}
    		Integer pI = 0;
    		String prevTestSerial = "0";
    		String curTestSerial = "0";
    		XSSFWorkbook parser = null;
            try {
            	
                byte[] bytes = file.getBytes();
                //String decoded = new String(bytes,"UTF-8");
                //logger.info("CSV: {}",decoded);
                parser = new XSSFWorkbook(new ByteArrayInputStream(bytes));
                XSSFSheet sheet1 = parser.getSheetAt(0);
                Iterator<Row> rItor = sheet1.iterator();
                Boolean isQuestion = true;
                String curValue = null;
                JsonArray jArr = null;
                int i = 0;
                conn = dataSource.getConnection();
                sql =  "INSERT INTO test (question, serial, answer, keywords, options, testsuite_pk, " + 
                		"createdat, updatedat) VALUES (?,?,?,?,?,?,NOW(),NOW())";
    			preparedSql = conn.prepareStatement(sql);
                while(rItor.hasNext()){
                   	if(i % 4 == 0){
                		if(isQuestion == false){
                			isQuestion = true;
                			//preparedSql.setString(6, UUID.randomUUID().toString().replaceAll("-", ""));
                			preparedSql.setLong(6, rowID);
                			/*java.util.Date dt = new java.util.Date();
                			String currentTime = sdf.format(dt);
            				preparedSql.setDate(8, new java.sql.Date(Calendar.getInstance().getTimeInMillis()));
            				preparedSql.setDate(9, new java.sql.Date(Calendar.getInstance().getTimeInMillis()));*/
                            preparedSql.addBatch();
                            logger.info("[Done_prepared_batch].");
                		}
                	}else{
                		if(isQuestion == true){
                			isQuestion = false;
                		}
                	}
                	Row row = rItor.next();//Row row = sheet1.getRow(i);
                	++pI;
                	//logger.info("[pI]: " + pI.toString());
                	//For each row, iterate through all the columns
                    Iterator<Cell> cellIterator = row.cellIterator();                	
                    while (cellIterator.hasNext())
                    {
                        Cell cell = cellIterator.next();
                        //Check the cell type and format accordingly
                        switch (cell.getCellType())
                        {
                            case Cell.CELL_TYPE_NUMERIC:
                            	logger.info("[CELL_TYPE_NUMERIC]!");                           	
                                System.out.print(cell.getNumericCellValue() + ",");
                                break;
                            case Cell.CELL_TYPE_STRING:
                            	if(isQuestion == true){
                            		curValue = cell.getStringCellValue();
                            		int dotPos = curValue.indexOf('.');
                            		if(dotPos != -1){
                            			curTestSerial = curValue.substring(0, dotPos);
                            			/*if(preparedSql == null || preparedSql.isClosed() == true){
                                			conn = dataSource.getConnection();
                                            sql =  "INSERT INTO test (question, serial, answer, keywords, options, uuid, testsuite_pk, " + 
                                            		"createdat, updatedat) VALUES (?,?,?,?,?,?,?,?,?)";
                                			preparedSql = conn.prepareStatement(sql);
                                		}*/
                                		preparedSql.setNString(pI, curValue.substring(dotPos+1));
                            			pI++;
                            			Integer c = Integer.parseInt(curTestSerial);
                            			Integer p = Integer.parseInt(prevTestSerial);
                            			if(c-p > 1)
                            				c-=1;
                            			preparedSql.setInt(pI, c);           
                            			prevTestSerial = c.toString();//curTestSerial;
                            		}else{
                            			//Error: Question doesn't begin with serial number followed by '.'.
                            			throw new Exception("Missing serial number and '.' in front of question!");
                            		}          		
                            	}else{
                                	if(jArr == null)
                                		jArr = new  JsonArray();
                            		jArr.add(cell.getStringCellValue());
                            	}
                                System.out.print(cell.getStringCellValue() + ",");
                                break;
                            case Cell.CELL_TYPE_BLANK:
                            	logger.info("[CELL_TYPE_BLANK]!");
                            
                        }
                    }
                    if(jArr != null){
                    	curValue = jArr.toString();
                    	preparedSql.setNString(pI, curValue);
                    	if(pI == 5)
                    		pI = 0;
                    	jArr = null;
                    }

                    logger.info("[END_ROW]");
                    ++i;
 
                }
               	if(i % 4 == 0){
            		if(isQuestion == false){
            			//preparedSql.setString(6, UUID.randomUUID().toString().replaceAll("-", ""));
            			preparedSql.setLong(6, rowID);
        				//preparedSql.setDate(8, new java.sql.Date(Calendar.getInstance().getTimeInMillis()));
        				//preparedSql.setDate(9, new java.sql.Date(Calendar.getInstance().getTimeInMillis()));
                        preparedSql.addBatch();
                        logger.info("[Done_LAST_prepared_batch].");
            		}
            	}
                
                
            } catch (Exception e) {
    			e.printStackTrace();
    			String error = null;
    			if(curTestSerial != null && curTestSerial.length() > 0)
    				error = "You failed uploading test suite " + suitename + " because of test " + curTestSerial + " after test " + prevTestSerial;
    			else
    				error = "You failed uploading test suite " + suitename;
    			logger.error(e.getMessage());
                return new ModelAndView("result","result",error);
            } finally{
            	try {
					parser.close();
				} catch (IOException e1) {
					e1.printStackTrace();
				} finally{
					parser = null;
				}
	            try {
	            	if(conn == null)
	            		conn = dataSource.getConnection();
		            conn.setAutoCommit(false);
		            preparedSql.executeBatch();
		            conn.commit();
		            conn.setAutoCommit(true);
	            } catch (SQLException e) {
	    			e.printStackTrace();
	    			logger.error("[uploadtestsuite] " + e.getMessage());
	    			new ModelAndView("result","result","Error: " + e.getMessage());
	    		} finally{
		            try {
						preparedSql.close();
					} catch (SQLException e) {
						e.printStackTrace();
					} finally{
						preparedSql = null;
					}
		            try {
						conn.close();
					} catch (SQLException e) {
						e.printStackTrace();
					} finally{
						conn = null;
					}
	    		}
            }
            return new ModelAndView("result","result","Successfully uploaded test suite " + suitename);

        } else {
            return new ModelAndView("result","result","Server didn't get file.");
        }
        
        
        
		
    }
	
	@RequestMapping(value = "/edittest/{tid}", method = RequestMethod.GET)
	public @ResponseBody ModelAndView editTestPOST(Locale locale, Model model,
			HttpServletRequest request, 
			HttpServletResponse response,
			@PathVariable String tid) {
		logger.info(request.getRequestURL().toString());
		DataSource dataSource = (DataSource) jndiObjFactoryBean.getObject();
		byte [] decodeCipherText = Base64.decodeBase64(tid);//16 bit iv + suite + serial.
		byte [] iv = Arrays.copyOfRange(decodeCipherText, 0, AES_KEYLENGTH / 8);
		byte [] realDecodeCipherText = Arrays.copyOfRange(decodeCipherText, AES_KEYLENGTH / 8, decodeCipherText.length);
		Cipher aesCipherForDecryption = null;
		try {
			aesCipherForDecryption = Cipher.getInstance("AES/CBC/PKCS5PADDING");
		} catch (NoSuchAlgorithmException | NoSuchPaddingException e) {
			e.printStackTrace();
			return new ModelAndView("result","result","[ERROR] " + e.getMessage());
		}				
	    Authentication auth = SecurityContextHolder.getContext().getAuthentication();
	    String curUser = auth.getName();		
		String key = curUser;// + "MendezMasterTrainingCenter6454";//TODO: move string literal to config file.
	    MessageDigest md = null;
	    try {
			md = MessageDigest.getInstance("SHA");
		} catch (NoSuchAlgorithmException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			logger.error("[DEADLy] SHA not found in security algorithms!!!");
			return null;
		}
		md.update(key.getBytes());
		byte[] aesKey = md.digest();
		aesKey = Arrays.copyOf(aesKey, 16);
		String strKey = new String(aesKey);
		logger.info("[KEY2] " + strKey);
		logger.info("[iv len] " + String.valueOf(iv.length));

		SecretKeySpec keySpec = new SecretKeySpec(aesKey,"AES");
		
		try {
			aesCipherForDecryption.init(Cipher.DECRYPT_MODE, keySpec,new IvParameterSpec(iv));
		} catch (InvalidKeyException | InvalidAlgorithmParameterException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return new ModelAndView("result","result","[ERROR] " + e.getMessage());			
		}
		
		byte[] byteDecryptedText = null;
		try {
			byteDecryptedText = aesCipherForDecryption.doFinal(realDecodeCipherText);
		} catch (IllegalBlockSizeException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (BadPaddingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		String strDecryptedText = new String(byteDecryptedText);
		logger.info(" Decrypted Text message is " + strDecryptedText + "/" + tid);
		
		//request.getSession().setAttribute("totalNumberOfQuizQuestions",);
		request.getSession().setAttribute("quizDuration",5);
		return new ModelAndView("result","result","");
	}
	
	@RequestMapping(value = "/exam/{examname}", method = RequestMethod.GET)
	public @ResponseBody ModelAndView examPOST(Locale locale, Model model,
			HttpServletRequest request, 
			HttpServletResponse response,
			@PathVariable String examname) {
		logger.info(request.getRequestURL().toString());
		DataSource dataSource = (DataSource) jndiObjFactoryBean.getObject();
		//request.getSession().setAttribute("totalNumberOfQuizQuestions",);
		request.getSession().setAttribute("quizDuration",5);
		return new ModelAndView("result","result",examname);
	}
	
	@RequestMapping(value = "/timeout", method = RequestMethod.GET)
	public @ResponseBody ModelAndView timeoutGET(Locale locale, Model model,
			HttpServletRequest request, 
			HttpServletResponse response) {
		logger.info(request.getRequestURL().toString());
		DataSource dataSource = (DataSource) jndiObjFactoryBean.getObject();
		return new ModelAndView("result","result","Time out!");
	}

	private ArrayList<String> getTestSuites(){
		logger.info("showTestSuites()!");
		DataSource dataSource = (DataSource) jndiObjFactoryBean.getObject();
		ArrayList<String> suites = new ArrayList<String>();
		String sql = "SELECT `name` FROM testsuite";
		try{
			Connection conn = dataSource.getConnection();
			ResultSet s = conn.createStatement().executeQuery(sql);
			while(s.next()){
				suites.add(s.getString("name"));
			}
			conn.close();
		}catch(Exception e){
			e.printStackTrace();
			logger.error("[testsuite] " + e.getMessage());			
		}
		return suites;
		
	}
	
	private ArrayList<Test> getTests(String suite){
		logger.info("getTests()!");
		DataSource dataSource = (DataSource) jndiObjFactoryBean.getObject();
		ArrayList<Test> tests = new ArrayList<Test>();
		String sql = "SELECT serial, updatedat, question, options,answer FROM test WHERE testsuite_pk IN (SELECT pk FROM testsuite WHERE name=?)";
		PreparedStatement preparedSql = null;
		Connection conn = null;
	    Authentication auth = SecurityContextHolder.getContext().getAuthentication();
	    String curUser = auth.getName();
	    MessageDigest md = null;
		byte[] iv = new byte[AES_KEYLENGTH / 8];	// Save the IV bytes or send it in plaintext with the encrypted data so you can decrypt the data later
	    try {
			md = MessageDigest.getInstance("SHA");
		} catch (NoSuchAlgorithmException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			logger.error("[DEADLy] SHA not found in security algorithms!!!");
			return null;
		}
		try{
			conn = dataSource.getConnection();
			preparedSql = conn.prepareStatement(sql);
			preparedSql.setString(1, suite);
			ResultSet s = preparedSql.executeQuery();
			String serial = null;
			while(s.next()){
				Test found = new Test();
				found.setAnswer(s.getString("answer"));
				serial = Integer.toString(s.getInt("serial"));
				found.setQuestion(serial + "." + s.getString("question"));
				found.setOptions(s.getString("options"));
				String key = curUser;// + "MendezMasterTrainingCenter6454";//TODO: move string literal to config file.
				md.update(key.getBytes());
				byte[] aesKey = md.digest();
				aesKey = Arrays.copyOf(aesKey, 16);
				String strKey = new String(aesKey);
				logger.info("[KEY1] " + strKey);
				SecretKeySpec keySpec = new SecretKeySpec(aesKey,"AES");
				SecureRandom prng = new SecureRandom();
				prng.nextBytes(iv);
				Cipher aesCipherForEncryption = Cipher.getInstance("AES/CBC/PKCS5PADDING");
				aesCipherForEncryption.init(Cipher.ENCRYPT_MODE, keySpec, new IvParameterSpec(iv));
				String strIv = new String(iv);//The first 16 bits is iv, followed by suite + serial.
				byte[] byteDataToEncrypt = (suite + "-" + serial).getBytes();
				byte[] byteCipherText = aesCipherForEncryption.doFinal(byteDataToEncrypt);
				int l = iv.length + byteCipherText.length;
				int delta = iv.length;
				byte[] finalCipherText = new byte[iv.length + byteCipherText.length];
				System.arraycopy(iv, 0, finalCipherText, 0, iv.length);
				System.arraycopy(byteCipherText, 0, finalCipherText, iv.length, byteCipherText.length);
				String strFinalCipherText = new String(Base64.encodeBase64(finalCipherText,false,true));//BASE64Encoder().encode(byteCipherText);
				found.setId(strFinalCipherText);
				tests.add(found);
			}
			conn.close();
		}catch(Exception e){
			e.printStackTrace();
			logger.error("[testsuite] " + e.getMessage());			
		}
		return tests;
		
	}
}
