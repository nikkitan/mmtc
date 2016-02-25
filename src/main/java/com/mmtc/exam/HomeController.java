package com.mmtc.exam;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
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
import java.util.Date;
import java.util.Iterator;
import java.util.Locale;
import java.util.Properties;
import java.util.concurrent.Future;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.codec.binary.Base64;
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
import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.AsyncResult;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.provisioning.JdbcUserDetailsManager;
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

import com.amazonaws.auth.InstanceProfileCredentialsProvider;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectResult;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.reflect.TypeToken;
import com.mmtc.exam.auth.MMTCJdbcUserDetailsMgr;
import com.mmtc.exam.dao.MMTCUser;
import com.mmtc.exam.dao.Test;
import com.mmtc.exam.dao.TestSuite;

//http://springinpractice.com/2010/07/06/spring-security-database-schemas-for-mysql
//http://www.jsptut.com/
//http://docs.spring.io/spring/docs/current/spring-framework-reference/html/spring-form-tld.html
//http://danielkvist.net/wiki/spring-mvc-fundamentals
//http://www.ibm.com/developerworks/library/ws-springjava/
/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	@Autowired
	ServletContext servletCtx;
	@Autowired
	private JndiObjectFactoryBean jndiObjFactoryBean;
	@Autowired
	private MMTCJdbcUserDetailsMgr jdbcDaoMgr;
	
	@Autowired
	private JavaMailSenderImpl mailSender;
	
	@Autowired
	private SimpleMailMessage emailRegMsgTemplate;
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	private static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");	
    private final int AES_KEYLENGTH = 128;	// change this as desired for the security level you want
	 
	@RequestMapping(value = {"/","/index"}, method = RequestMethod.GET)
	public @ResponseBody ModelAndView root(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		ModelAndView view = new ModelAndView();
		view.setViewName("index");
		return view;

	}
	@RequestMapping(value = {"/home"}, method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		DataSource dataSource = (DataSource) jndiObjFactoryBean.getObject();

		int i = dataSource.getPoolSize();
		logger.info("Pool size: " + i);
		
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
	@RequestMapping(value="/adduser", method=RequestMethod.GET)
    public @ResponseBody ModelAndView addUserGET(
			HttpServletRequest request, 
			HttpServletResponse response){
		logger.info(request.getRequestURL().toString());
		MMTCUser user = new MMTCUser();
		ModelAndView view = new ModelAndView();
		view.setViewName("newuser");
		view.addObject("us", user);
        return view;
	}
	
	@RequestMapping(value="/adduser", method=RequestMethod.POST)
    public @ResponseBody ModelAndView addUserPOST(
    		@ModelAttribute("us") MMTCUser user,
			HttpServletRequest request, 
			HttpServletResponse response){
		logger.info(request.getRequestURL().toString());
		boolean hasError = false;
		ArrayList<SimpleGrantedAuthority> authorities = new ArrayList<SimpleGrantedAuthority>();
		authorities.add(new SimpleGrantedAuthority("STU"));
		try {
			jdbcDaoMgr.createMMTCUser(new MMTCUser(user.getUsername(),user.getPassword(), authorities));
		} catch (SQLException e) {
			e.printStackTrace();
			logger.error("[adduser] FAILED create NEW user!!!!");
			hasError = true;
		}
		
		//Send confirmation email.
		Properties props = new Properties();
		props.put("mail.smtp.starttls.enable", "true");
		mailSender.setJavaMailProperties(props);
        SimpleMailMessage msg = new SimpleMailMessage(this.emailRegMsgTemplate);
        msg.setTo(user.getEmail());
        msg.setText(
            "Dear " + user.getUsername()
                + ", thank you for registering with MMTC! Your user name is your email. ");
        try{
            this.mailSender.send(msg);
        }
        catch (MailException ex) {
            // simply log it and go on...
            logger.error(ex.getMessage());
            hasError = true;
        }
        
		ModelAndView view = new ModelAndView();
		view.setViewName("result");
		if(hasError == false)
			view.addObject("result", "New user added successfully. Please check you email for confirmation!");
		else
			view.addObject("result", "Failed adding new user. Please try again.");
        return view;
	}
	
	
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
		//ArrayList<String> suites = getTestSuites();	
		
        return new ModelAndView("listtest","tests",getTestsForSuite(ts.getName()));
	}

	@RequestMapping(value = "/edittest/{tid}", method = RequestMethod.GET)
	public @ResponseBody ModelAndView editTestGET(
			Locale locale, 
			Model model,
			HttpSession session,
			HttpServletRequest request, 
			HttpServletResponse response,
			@PathVariable String tid) {
		logger.info(request.getRequestURL().toString());
	    Authentication auth = SecurityContextHolder.getContext().getAuthentication();
	    String curUser = auth.getName();
		String suiteAndTest = decryptTestID(curUser + "MendezMasterTrainingCenter6454",tid);
		logger.info("[DEcrypted] " + suiteAndTest);
		Test ts = new Test();
		String[] s_t = suiteAndTest.split("-");
		ArrayList<Test> tests = getTestBySuiteAndID(s_t[0],s_t[1]);	
		if(tests.size() > 1){
			//TODO:No good.....duplicated test records. => Delete all of them and keep only 1?
			String err = new Throwable().getStackTrace()[0].getMethodName();
			err += " => Duplicated test records of suite {} test {}!!!";
			logger.error(err,s_t[0],s_t[1]);
		}
		if(tests.isEmpty() == true){
			String msg = "No test found for suite " + s_t[0];
			msg += " and test " + s_t[1];
			return new ModelAndView("result","result",msg);
		}
		ModelAndView resultView = new ModelAndView();
		resultView.setViewName("edittest");
		Test found = tests.get(0);
		resultView.addObject("ts", ts);
		resultView.addObject("id",tid);
		resultView.addObject("ste",found.getSuite());
		resultView.addObject("sn",found.getSerialNo());
		resultView.addObject("q",found.getQuestion());
		resultView.addObject("ans",found.getAnswers());
		resultView.addObject("opt",found.getOptions());
		resultView.addObject("kwd", found.getKeywords());
		
		String parentDir = File.separator;
		parentDir += "mmtcexam";
		parentDir += File.separator;
		parentDir += "resources" + File.separator;
		parentDir += "pic";
		parentDir += File.separator;
		String pic = found.getPic();
		resultView.addObject("pic",pic);
		session.setAttribute("uploadFile", parentDir + pic + ".png");
		return resultView;
	}

	@RequestMapping(value = "/getmg/{imgid}", method = RequestMethod.GET)
	public @ResponseBody byte[] getImgGET(
			Locale locale,
			Model model,
			HttpSession session,
			HttpServletRequest request, 
			HttpServletResponse response,
			@PathVariable String imgid){
		byte[] rawImg = null;
		
		return rawImg;
	}
	
	@RequestMapping(value = "/newuser", 
			method = RequestMethod.GET,
			produces = "application/json; charset=utf-8")
	public @ResponseBody ModelAndView newUserGET(
			Locale locale,
			Model model,
			HttpSession session,
			HttpServletRequest request, 
			HttpServletResponse response){
		ModelAndView view = new ModelAndView("newuser");
		
		return view;
	}
	
	@Async
	public Future<PutObjectResult> uploadS3(File file){
		AmazonS3 s3Client = new AmazonS3Client(new InstanceProfileCredentialsProvider());
		ObjectMetadata metadata = new ObjectMetadata();
		metadata.setContentType("image/png");
		PutObjectResult pr = s3Client.putObject("mmtctestpic",file.getName(),file);
		return new AsyncResult<PutObjectResult>(pr);	
	}
	//http://www.jayway.com/2014/09/09/asynchronous-spring-service/
	//http://docs.aws.amazon.com/AWSSdkDocsJava/latest/DeveloperGuide/java-dg-roles.html
	@RequestMapping(value = "/edittest/{tid}", method = RequestMethod.POST)
	public @ResponseBody ModelAndView editTestPOST(
			Locale locale,
			Model model,
			HttpSession session,
			HttpServletRequest request, 
			HttpServletResponse response,
			@PathVariable String tid,
			@RequestParam("file") MultipartFile file) {
		logger.info(request.getRequestURL().toString());

		
		if(file.getSize() > 0){			
			
		    Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		    String curUser = auth.getName();
			String suiteAndTest = decryptTestID(curUser + "MendezMasterTrainingCenter6454",tid);
			logger.info("[DEcrypted] " + suiteAndTest);
			//Save image locally.			
			String destDir = request.getSession().getServletContext().getRealPath("/");//servletCtx.getRealPath("/");
			destDir += "resources";
			destDir += File.separator;
			destDir += "pic";
			destDir += File.separator;
			logger.info("[2_save_img_2] " + destDir);
			String encFileName = encrypt(curUser + "MendezMasterTrainingCenter6454_testpickey",suiteAndTest);			
			FileInputStream in = null;
			try {
				in = (FileInputStream) file.getInputStream();
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
				return new ModelAndView("result","result","Failed getting INPUT STREAM.");

			}
			FileOutputStream out = null;
			try {
				out = new FileOutputStream(destDir+encFileName+".png");
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				File f = new File(destDir);
				if(f.mkdir() == false){
					logger.error("[VERY BAD] Failed creating picture folder in CATALINA_HOME.");
				}
				return new ModelAndView("result","result","Failed getting OUTPUT STREAM.");
			}
			
			int readBytes = 0;
			byte[] buffer = new byte[8192];
			try {
				while ((readBytes = in.read(buffer, 0, 8192)) != -1) {
					logger.info("===ddd=======");
					out.write(buffer, 0, readBytes);
				}
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			} 
			logger.info("[DONE_SAVING_IMG]");
			try {
				in.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			try {
				out.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			//Save pic dir info to SQL.
			DataSource dataSource = (DataSource) jndiObjFactoryBean.getObject();
			Connection conn = null;
    		PreparedStatement preparedSql = null;
    		String sql = "UPDATE test SET pic=? WHERE testsuite_pk IN (SELECT pk FROM testsuite WHERE name = ?) AND serial = ?";
    		String[] s_t = suiteAndTest.split("-");
    		try {
    			conn = dataSource.getConnection();					
    			preparedSql = conn.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS);
    			preparedSql.setString(1, encFileName);
    			preparedSql.setString(2,s_t[0]);
    			preparedSql.setInt(3, Integer.valueOf(s_t[1]));
    			preparedSql.executeUpdate();
    			ResultSet r = preparedSql.getGeneratedKeys();
    			r.next();
    			//rowID = r.getLong(1);
    		} catch (SQLException e) {
    			e.printStackTrace();
    			String err = new Throwable().getStackTrace()[0].getMethodName();
    			err += " => ";
    			err += e.getMessage();
    			logger.error(err);
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
    		
    		String parentDir = File.separator;
    		parentDir += "mmtcexam";
    		parentDir += File.separator;
    		parentDir += "resources" + File.separator;
    		parentDir += "pic";
    		parentDir += File.separator;
			session.setAttribute("uploadFile", parentDir + encFileName + ".png");
			
			//Prepare file to S3.
			File outFile = new File(destDir+encFileName); 
			if(!outFile.exists()){
				logger.error(destDir+encFileName + " doesn't exists.");
			}else{
				uploadS3(outFile);
			}
		}else{
			return new ModelAndView("result","result","Empty file uploaded.");
		}
		return new ModelAndView("picuploadindex");
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
    		int r  = 0;
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
                conn = dataSource.getConnection();
                sql =  "INSERT INTO test (question, serial, answer, keywords, options, testsuite_pk, " + 
                		"createdat, updatedat) VALUES (?,?,?,?,?,?,NOW(),NOW())";
    			preparedSql = conn.prepareStatement(sql);
                while(rItor.hasNext()){
                   	if(r % 4 == 0){
                		if(isQuestion == false){
                			isQuestion = true;
                			preparedSql.setLong(6, rowID);
                            preparedSql.addBatch();
                            logger.info("[Done_prepared_batch].");
                		}
                	}else{
                		if(isQuestion == true){
                			isQuestion = false;
                		}
                	}
                	Row row = rItor.next();//Row row = sheet1.getRow(i);
                	if(row.getPhysicalNumberOfCells() > 0){
                	++pI;
                	//logger.info("[pI]: " + pI.toString());
                	//For each row, iterate through all the columns
                    Iterator<Cell> cellIterator = row.cellIterator();                	
                    cellloop: while (cellIterator.hasNext())
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
                            	curValue = cell.getStringCellValue();
                            	logger.info("{},",curValue);
                            	if(isQuestion == true){                            	
                            		int dotPos = curValue.indexOf('.');
                            		if(dotPos != -1){
                            			curTestSerial = curValue.substring(0, dotPos);
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
                            			throw new Exception("Missing serial number and '.' in front of question after question " + curTestSerial);
                            		}
                            		break cellloop;//We only allow 1 cell for question.
                            	}else{
                                	if(jArr == null)
                                		jArr = new  JsonArray();
                            		jArr.add(cell.getStringCellValue());
                            	}
                                break;
                            case Cell.CELL_TYPE_BLANK:
                            	logger.info("[CELL_TYPE_BLANK]!");
                            default:
                            	logger.error("[UNKnown cell type]!!");
                            	break;
                            
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
                    r++;
                	}else{
                		logger.info("[EMPTY_ROW]");
                	}
                }
               	if(r % 4 == 0){
            		if(isQuestion == false){
            			preparedSql.setLong(6, rowID);
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
    			//Delete test suite record and any tests already inserted.
    			try {
					preparedSql.clearBatch();
				} catch (SQLException e1) {
					e1.printStackTrace();
					preparedSql = null;
					logger.error("[uploadtestsuite] Exception when clearBatch() of preparedSql.");
				}
    			
    			String sql2 = "DELETE FROM testsuite WHERE pk = " + rowID;
    			try {
					conn.createStatement().executeUpdate(sql2);
				} catch (SQLException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
					logger.error("[uploadtestsuite] Failed deleting testsuite record " + rowID);
					error += ". Serious error, PLZ contact nikki.";
				} 			
                return new ModelAndView("result","result",error);
            } 
            
        	try {
				parser.close();
			} catch (IOException e1) {
				e1.printStackTrace();
			} finally{
				parser = null;
			}
            try {
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
            
            return new ModelAndView("result","result","Successfully uploaded test suite " + suitename);

        } else {
            return new ModelAndView("result","result","Server didn't get file.");
        }
        
        
        
		
    }
	
	/*
	 * {
  "suite" : "A",
  "tests": [
    {
      "q":"",
      "opt":[],
      "ans":[],
      "kwd":[],
      "p":"",
      "cursel":""
    },
    {
      "q":"",
      "opt":[],
      "ans":[],
      "kwd":[],
      "p":"",
      "cursel":""     
    }
  ]
}
	 * */
	@RequestMapping(value = "/runsuite/{s}", method = RequestMethod.GET)
	public @ResponseBody ModelAndView runSuiteGET(
			Locale locale, 
			Model model,
			HttpSession session,
			HttpServletRequest request, 
			HttpServletResponse response,
			@PathVariable String s) {
		logger.info(request.getRequestURL().toString());
		TestSuite ts = new TestSuite();
		ModelAndView resultView = new ModelAndView("preexecsuite");
		resultView.addObject("ts", ts);
		resultView.addObject("su", s);
		return resultView;
	}
	
	@RequestMapping(value = "/runsuite/{s}", method = RequestMethod.POST)
	public @ResponseBody ModelAndView runSuitePOST(
			Locale locale, 
			Model model,
			HttpSession session,
			HttpServletRequest request, 
			HttpServletResponse response,
			@PathVariable String s,
			@ModelAttribute("ts") TestSuite suite) {
		logger.info(request.getRequestURL().toString());
		ArrayList<Test> tests = getTestsForSuite(s);
		JsonObject jSuite = new JsonObject();
		jSuite.addProperty("suite", s);
		Gson gson = new Gson();
		JsonArray jTests = (JsonArray)gson.toJsonTree(tests, new TypeToken<ArrayList<Test>>(){}.getType());
		jSuite.add("tests", jTests);
		request.setAttribute("tests",gson.toJson(jSuite));
		return new ModelAndView("exectest");
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
	private ArrayList<Test> getTestBySuiteAndID(String suite, String testsn){
		DataSource dataSource = (DataSource) jndiObjFactoryBean.getObject();
		ArrayList<Test> tests = new ArrayList<Test>();
		String sql = "SELECT serial, pic ,updatedat, question, options,answer,keywords FROM test "
				+"WHERE testsuite_pk IN (SELECT pk FROM testsuite WHERE name=?)"
				+" AND serial = ?";
		PreparedStatement preparedSql = null;
		Connection conn = null;
	    Authentication auth = SecurityContextHolder.getContext().getAuthentication();
	    String curUser = auth.getName();
		try{
			conn = dataSource.getConnection();
			preparedSql = conn.prepareStatement(sql);
			preparedSql.setString(1, suite);
			preparedSql.setString(2, testsn);
			ResultSet s = preparedSql.executeQuery();
			String serial = null;			
			JsonParser jp = new JsonParser();
			Gson gs = new Gson();

			while(s.next()){
				Test found = new Test();
				JsonElement elem = jp.parse(s.getString("answer"));
				JsonArray jsonArr = elem.getAsJsonArray();
				//found.setAnsJsonArr(jsonArr);
				found.setAnswers(gs.fromJson(jsonArr, new TypeToken<ArrayList<String>>(){}.getType()));
				//found.setAnswer(s.getString("answer"));

				elem = jp.parse(s.getString("options"));
				jsonArr = elem.getAsJsonArray();
				//found.setOptJsonArr(jsonArr);
				found.setOptions(gs.fromJson(jsonArr, new TypeToken<ArrayList<String>>(){}.getType()));
				
				elem = jp.parse(s.getString("keywords"));
				jsonArr = elem.getAsJsonArray();
				//found.setKwdJsonArr(jsonArr);
				found.setKeywords(gs.fromJson(jsonArr, new TypeToken<ArrayList<String>>(){}.getType()));

				//found.setOptions(s.getString("options"));
				serial = Integer.toString(s.getInt("serial"));
				found.setQuestion(serial + "." + s.getString("question"));
				found.setPic(s.getString("pic"));
				found.setId(encrypt(curUser + "MendezMasterTrainingCenter6454",suite + "-" + serial));
				found.setSuite(suite);
				found.setSerialNo(Integer.valueOf(testsn));
				tests.add(found);
			}
			conn.close();
		}catch(Exception e){
			e.printStackTrace();
			logger.error("[getTestBySuiteAndID()] " + e.getMessage());			
		}
		return tests;
	}
	private ArrayList<Test> getTestsForSuiteAsJSON(String suite){
		
		
		return null;
		
	}
	private ArrayList<Test> getTestsForSuite(String suite){
		logger.info("getTestForSuite()!");
		DataSource dataSource = (DataSource) jndiObjFactoryBean.getObject();
		ArrayList<Test> tests = new ArrayList<Test>();
		String sql = "SELECT serial, updatedat, question, options,answer,keywords,pic FROM test WHERE testsuite_pk IN (SELECT pk FROM testsuite WHERE name=?)  ";
		PreparedStatement preparedSql = null;
		Connection conn = null;
	    Authentication auth = SecurityContextHolder.getContext().getAuthentication();
	    String curUser = auth.getName();
		try{
			conn = dataSource.getConnection();
			preparedSql = conn.prepareStatement(sql);
			preparedSql.setString(1, suite);
			ResultSet s = preparedSql.executeQuery();
			String serial = null;
			JsonParser jp = new JsonParser();
			Gson gs = new Gson();
			while(s.next()){
				Test found = new Test();
				serial = Integer.toString(s.getInt("serial"));
				found.setQuestion(serial + "." + s.getString("question"));
				
				JsonElement elem = jp.parse(s.getString("answer"));
				JsonArray jsonArr = elem.getAsJsonArray();
				//found.setAnsJsonArr(jsonArr);
				found.setAnswers(gs.fromJson(jsonArr, new TypeToken<ArrayList<String>>(){}.getType()));

				elem = jp.parse(s.getString("options"));
				jsonArr = elem.getAsJsonArray();
				//found.setOptJsonArr(jsonArr);
				found.setOptions(gs.fromJson(jsonArr, new TypeToken<ArrayList<String>>(){}.getType()));
				
				elem = jp.parse(s.getString("keywords"));
				jsonArr = elem.getAsJsonArray();
				//found.setKwdJsonArr(jsonArr);
				found.setKeywords(gs.fromJson(jsonArr, new TypeToken<ArrayList<String>>(){}.getType()));				
				
				found.setPic(s.getString("pic"));
				found.setId(encrypt(curUser + "MendezMasterTrainingCenter6454",suite + "-" + serial));
				found.setSuite(suite);
				found.setSerialNo(Integer.valueOf(serial));	
				tests.add(found);
			}
			conn.close();
		}catch(Exception e){
			e.printStackTrace();
			logger.error("[testsuite] " + e.getMessage());			
		}
		return tests;
		
	}
	//https://www.owasp.org/index.php/Using_the_Java_Cryptographic_Extensions
	private String encrypt(String key, String secret2Encrypt){
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
	    String curUser = auth.getName();
	    MessageDigest md = null;
		byte[] iv = new byte[AES_KEYLENGTH / 8];	// Save the IV bytes or send it in plaintext with the encrypted data so you can decrypt the data later
	    try {
			md = MessageDigest.getInstance("SHA");
		} catch (NoSuchAlgorithmException e1) {
			e1.printStackTrace();
			logger.error("[DEADLy] SHA not found in security algorithms!!!");
			return null;
		}		
	    md.update(key.getBytes());
		byte[] aesKey = md.digest();
		aesKey = Arrays.copyOf(aesKey, 16);
		String strKey = new String(aesKey);
		//logger.info("[KEY1] " + strKey);
		SecretKeySpec keySpec = new SecretKeySpec(aesKey,"AES");
		SecureRandom prng = new SecureRandom();
		prng.nextBytes(iv);
		Cipher aesCipherForEncryption = null;
		try {
			aesCipherForEncryption = Cipher.getInstance("AES/CBC/PKCS5PADDING");
		} catch (NoSuchAlgorithmException | NoSuchPaddingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
		try {
			aesCipherForEncryption.init(Cipher.ENCRYPT_MODE, keySpec, new IvParameterSpec(iv));
		} catch (InvalidKeyException | InvalidAlgorithmParameterException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
		String strIv = new String(iv);//The first 16 bits is iv, followed by suite + serial.
		byte[] byteDataToEncrypt = secret2Encrypt.getBytes();
		byte[] byteCipherText = null;
		try {
			byteCipherText = aesCipherForEncryption.doFinal(byteDataToEncrypt);
		} catch (IllegalBlockSizeException | BadPaddingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
		int l = iv.length + byteCipherText.length;
		int delta = iv.length;
		byte[] finalCipherText = new byte[iv.length + byteCipherText.length];
		System.arraycopy(iv, 0, finalCipherText, 0, iv.length);
		System.arraycopy(byteCipherText, 0, finalCipherText, iv.length, byteCipherText.length);
		String strFinalCipherText = new String(Base64.encodeBase64(finalCipherText,false,true));//BASE64Encoder().encode(byteCipherText);		
		return strFinalCipherText;
	}
	
	private String decryptTestID(String key, String encryptedData){
		byte [] decodeCipherText = Base64.decodeBase64(encryptedData);//16 bit iv + suite + serial.
		byte [] iv = Arrays.copyOfRange(decodeCipherText, 0, AES_KEYLENGTH / 8);
		byte [] realDecodeCipherText = Arrays.copyOfRange(decodeCipherText, AES_KEYLENGTH / 8, decodeCipherText.length);
		Cipher aesCipherForDecryption = null;
		try {
			aesCipherForDecryption = Cipher.getInstance("AES/CBC/PKCS5PADDING");
		} catch (NoSuchAlgorithmException | NoSuchPaddingException e) {
			e.printStackTrace();
			return null;
		}				
	    Authentication auth = SecurityContextHolder.getContext().getAuthentication();
	    String curUser = auth.getName();		
	    MessageDigest md = null;
	    try {
			md = MessageDigest.getInstance("SHA");
		} catch (NoSuchAlgorithmException e1) {
			e1.printStackTrace();
			logger.error("[DEADLy] SHA not found in security algorithms!!!");
			return null;
		}
		md.update(key.getBytes());
		byte[] aesKey = md.digest();
		aesKey = Arrays.copyOf(aesKey, 16);
		String strKey = new String(aesKey);
		//logger.info("[KEY2] " + strKey);
		//logger.info("[iv len] " + String.valueOf(iv.length));

		SecretKeySpec keySpec = new SecretKeySpec(aesKey,"AES");
		
		try {
			aesCipherForDecryption.init(Cipher.DECRYPT_MODE, keySpec,new IvParameterSpec(iv));
		} catch (InvalidKeyException | InvalidAlgorithmParameterException e) {
			e.printStackTrace();
			return null;
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
		logger.info(" Decrypted Text message is " + strDecryptedText + "/" + encryptedData);
		return strDecryptedText;
		
	}
}
