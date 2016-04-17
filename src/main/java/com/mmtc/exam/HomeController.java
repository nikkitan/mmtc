package com.mmtc.exam;

import java.io.ByteArrayInputStream;
import static com.mmtc.exam.BuildConfig.DEBUG;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.file.Files;
import java.nio.file.Paths;
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
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Locale;
import java.util.Properties;
import java.util.Random;
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
import org.springframework.security.core.authority.SimpleGrantedAuthority;
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
import com.google.gson.JsonPrimitive;
import com.google.gson.reflect.TypeToken;
import com.mmtc.exam.auth.MMTCJdbcUserDetailsMgr;
import com.mmtc.exam.dao.MMTCUser;
import com.mmtc.exam.dao.Test;
import com.mmtc.exam.dao.TestSuite;
import com.mmtc.exam.dao.TestTaking;

import net.spy.memcached.AddrUtil;
import net.spy.memcached.BinaryConnectionFactory;
import net.spy.memcached.ClientMode;
import net.spy.memcached.MemcachedClient;
//http://stackoverflow.com/questions/11271449/how-can-i-have-list-of-all-users-logged-in-via-spring-secuirty-my-web-applicat
//http://springinpractice.com/2010/07/06/spring-security-database-schemas-for-mysql
//http://www.jsptut.com/
//http://docs.spring.io/spring/docs/current/spring-framework-reference/html/spring-form-tld.html
//http://danielkvist.net/wiki/spring-mvc-fundamentals
//http://www.ibm.com/developerworks/library/ws-springjava/
//https://docs.spring.io/spring-security/site/docs/current/reference/html/csrf.html#csrf-include-csrf-token-in-action
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
	private MemcachedClient memcachedClient;
	
	@Autowired
	private JavaMailSenderImpl mailSender;
	
	@Autowired
	private SimpleMailMessage emailRegMsgTemplate;
	
	private final int DataRows = 5;//Index of last row(tips).
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	private static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");	
    private final int AES_KEYLENGTH = 128;//change this as desired for the security level.
	 
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

		int p = dataSource.getPoolSize();
		int i = dataSource.getIdle();
		int a = dataSource.getActive();
		logger.info("Pool size: " + p);
		logger.info("Idle size: " + i);
		logger.info("Active size: " + a);
		
		return "home";
	}	
	@RequestMapping(value = {"/error"}, method = RequestMethod.GET)
	public @ResponseBody ModelAndView errorGET(
			Locale locale, 
			Model model,
			@RequestParam(required=false) String msg) {
		ModelAndView view = new ModelAndView();
		view.setViewName("result");
		if(msg!=null && msg.length() > 0){
			view.addObject("result", msg);
		}else{
			view.addObject("result","Oooops! Something went wrong and please try again later.");
		}
		return view;

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
	@RequestMapping(value="/emptysuite", method=RequestMethod.GET)
    public String emptySuiteGET(Locale locale, Model model,
			HttpServletRequest request, 
			HttpServletResponse response){
		logger.debug(request.getRequestURL().toString());
		return "addsuite";
	}
	@RequestMapping(value="/delsuite", method=RequestMethod.GET)
    public @ResponseBody ModelAndView deleteSuiteGET(Locale locale, Model model,
			HttpServletRequest request, 
			HttpServletResponse response){
		logger.debug(request.getRequestURL().toString());
		TestSuite ts = new TestSuite(null);
		ModelAndView v = new ModelAndView();
		v.setViewName("delsuite");
		v.addObject("ts", ts);
		ArrayList<String> suites = getTestSuites();	
		v.addObject("suites", suites);
		return v;
	}
	@RequestMapping(value="/delsuite", method=RequestMethod.POST)
    public @ResponseBody ModelAndView deleteSuitePOST(Locale locale, Model model,
			HttpServletRequest request, 
			HttpServletResponse response,
			@ModelAttribute("ts") TestSuite ts){
		logger.debug(request.getRequestURL().toString());
		ModelAndView v = new ModelAndView();
		v.setViewName("result");
		if(deleteSuite(ts.getName(),-1L) == false){
			v.addObject("result", "Failed deleting suite of " + ts.getName());
			return v;
		}
		v.addObject("result", "Deletion of suite of " + ts.getName() + " is successful!");
		return v;
	}
	@RequestMapping(value="/postemptysuite", method=RequestMethod.POST)
    public @ResponseBody ModelAndView postEmptySuitePOST(
			HttpServletRequest request, 
			HttpServletResponse response,
			@RequestParam ("suite") String suite){
		logger.info(request.getRequestURL().toString());
		ModelAndView v = new ModelAndView();
		v.setViewName("result");
		if(addEmptySuite(suite) == -1L){
			v.addObject("result", "Failed creating new suite of " + suite);
			return v;
		}
		
		v.addObject("result", "New suite of " + suite + " is created successfully!");
		
		return v;
	}
	@RequestMapping(value="/uploadtestsuite", method=RequestMethod.GET)
    public String addTestSuiteGET(Locale locale, Model model,
			HttpServletRequest request, 
			HttpServletResponse response){
		logger.debug(request.getRequestURL().toString());
		return "uploadsuite";
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
    		//@ModelAttribute("us") MMTCUser user,
			HttpServletRequest request, 
			HttpServletResponse response,
			@RequestParam(required=true,value="firstname") String firstName,
			@RequestParam(required=true,value="firstname") String lastName,
			@RequestParam(required=true,value="email") String email,
			@RequestParam(required=true,value="pwd") String pwd,
			@RequestParam(required=false,value="emailpwd") String emailPWD){
		logger.info(request.getRequestURL().toString());
		boolean hasError = false;
		ArrayList<SimpleGrantedAuthority> authorities = new ArrayList<SimpleGrantedAuthority>();
		authorities.add(new SimpleGrantedAuthority("STU"));
		try {
			jdbcDaoMgr.createMMTCUser(new MMTCUser(email,pwd, email, firstName, lastName, authorities));
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
        msg.setTo(email);
        msg.setText(
            "Dear " + firstName + " " + lastName
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
		ArrayList<Test> tests = getTestsForDisplayForSuite(ts.getName());
		JsonObject jSuite = new JsonObject();
		jSuite.addProperty("suite", ts.getName());
		Gson gson = new Gson();
		JsonArray jTests = (JsonArray)gson.toJsonTree(tests, new TypeToken<ArrayList<Test>>(){}.getType());
		jSuite.add("tests", jTests);
		String strJ = gson.toJson(jSuite).replace("\\", "\\\\");
		request.setAttribute("tests",strJ);
		return new ModelAndView("execedit","debug",DEBUG);
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
	
	private Boolean updateTest(String suite, Test test){
		if(suite.length() == 0 || test.getSerialNo() == null)
			return false;
		DataSource dataSource = (DataSource) jndiObjFactoryBean.getObject();
		String sql = "SELECT pk FROM testsuite WHERE name=?";
		long suitePK = -1L;
		try {
			Connection conn = dataSource.getConnection();
			PreparedStatement prepStmt = conn.prepareStatement(sql);
			prepStmt.setString(1, suite);
			ResultSet rs = prepStmt.executeQuery();
			if(rs != null && rs.next()){
				suitePK = rs.getLong("pk");
			}else{
				logger.error("[saveTest]: Could not find suite of " + suite + " !");
				rs.close();
				prepStmt.close();
				conn.close();
				return false;
			}
			rs.close();
			prepStmt.close();

			sql = "UPDATE test SET ";
			String sqlSuffix = "updatedat=NOW() WHERE testsuite_pk = ? AND serial=?";
			HashMap<String,String> columns = new HashMap<String,String>();
			if(test.getQuestion() != null){
				JsonArray quesArr = test.getQuestion();
				for(int i = 0; i < quesArr.size(); ++i){
					String cur = quesArr.get(i).getAsString();
					if(cur.indexOf(".") != -1){
						cur = cur.substring(cur.indexOf(".") + 1);
					}
					quesArr.set(i, new JsonPrimitive(cur));
					
				}
				
				columns.put("question", quesArr.toString());
			}
			if(test.getOptions() != null){
				columns.put("options", test.getOptions().toString());
			}		
			if(test.getAnswers() != null){
				columns.put("answer", test.getAnswers().toString());			
			}
		
			if(test.getKeywords() != null){
				columns.put("keywords", test.getKeywords().toString());			
			}			
			if(test.getPic() != null){
				columns.put("pic", test.getPic().toString());						
			}else{
				columns.put("pic", null);
			}
			if(test.getWatchword() != null){
				columns.put("watchword", test.getWatchword().toString());						
			}
			if(test.getTips() != null){
				columns.put("tips", test.getTips().toString());						
			}
			
			if(columns.size() > 0){
				for(String key:columns.keySet()){
					sql += key;
					sql += "=";
					sql += "?,";
				}
				sql += "testsuite_pk=?,";
			}
			sql += sqlSuffix;
			prepStmt = conn.prepareStatement(sql);	
			int i = 1;
			for(String key:columns.keySet()){
				prepStmt.setNString(i, columns.get(key));
				++i;
			}
			prepStmt.setLong(i, suitePK);
			++i;
			prepStmt.setLong(i, suitePK);
			++i;
			prepStmt.setInt(i, test.getSerialNo());
			logger.debug("[finalPrepStmt]: " + prepStmt.toString());
			prepStmt.executeUpdate();
			prepStmt.close();
			conn.close();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			
		}
		
		return true;
	}
	
	private Boolean addTest(String suite, Test test){		
		ArrayList<Test> tests = getTestsForSuite(suite);
		int i = 0;
		for(; i < tests.size(); ++i){
			if(tests.get(i).getSerialNo().equals(test.getSerialNo())){
				//We'll insert new test before n-th test.
				break;
			}
		}
		if(i == tests.size()){
			//Not found, we'll append new test at end.
			tests.add(test);
		}else{
			tests.add(i, test);
			++i;
			for(; i < tests.size(); ++i){
				tests.get(i).setSerialNo(i+1);
			}
		}
		
		//Put tests back to db.
		return addTests(suite,tests);
	}
	private Boolean deleteSuite(String suite, long suitePK){
		Boolean result = true;
		String sql = null;
		DataSource dataSource = (DataSource) jndiObjFactoryBean.getObject();
		Connection conn = null;
		PreparedStatement prepStmt = null;

		if(suitePK == -1L){
			sql = "SELECT pk FROM testsuite WHERE name = ?";
			try {
				conn = dataSource.getConnection();
				prepStmt = conn.prepareStatement(sql);
				prepStmt.setString(1, suite);
				ResultSet rs = prepStmt.executeQuery();
				if(rs != null && rs.next() == true){
					suitePK = rs.getLong(1);
				}
				prepStmt.close();
				conn.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				logger.error("[deleteSuite]: Failed getting PK from testsuite for suite " + suite + ", " + e.toString());
				return false;
			}
			
		}
		sql = "DELETE FROM test_taking WHERE testsuite_name = ?";
		try {
			conn = dataSource.getConnection();
			prepStmt = conn.prepareStatement(sql);
			prepStmt.setString(1, suite);
			//prepStmt.setString(2, user);
			prepStmt.executeUpdate();
			prepStmt.close();
			conn.close();
			
		} catch (SQLException e1) {
			// TODO Auto-generated catch block
			logger.error("[deleteSuite]:Failed deleting test_taking for suite  " + suite +  ", " + e1.toString());
			e1.printStackTrace();
			result = false;			
		}
		sql = "DELETE FROM testsuite WHERE pk = ?";

		try {
			conn = dataSource.getConnection();
			prepStmt = conn.prepareStatement(sql);
			prepStmt.setLong(1, suitePK);
			prepStmt.executeUpdate();
			prepStmt.close();
			conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			logger.error("[deleteSuite]: " + e.toString());
			result = false;
			e.printStackTrace();
		}
		
		
		return result;
	}
	private Boolean addTests(String suite, ArrayList<Test> tests){
		DataSource dataSource = (DataSource) jndiObjFactoryBean.getObject();
		String sql = "SELECT pk FROM testsuite WHERE name=?";
		long suitePK = -1L;
		Connection conn = null;
		try {
			conn = dataSource.getConnection();
			PreparedStatement prepStmt = conn.prepareStatement(sql);
			prepStmt.setString(1, suite);
			ResultSet rs = prepStmt.executeQuery();
			if(rs != null && rs.next()){
				suitePK = rs.getLong("pk");
				deleteSuite(suite,suitePK);
				suitePK = addEmptySuite(suite);
			}else{
				//suite doesn't exist.
				prepStmt.close();
				conn.close();
				suitePK = addEmptySuite(suite);
			}
			if(suitePK == -1L){
				logger.error("[addTests]: CANNOT FIND suite PK: " + suite);
			}else{
				sql="INSERT INTO test (testsuite_pk,question,options,answer,"
					+ "keywords,pic,serial,watchword,tips,createdat,updatedat)"
					+ " VALUES (?,?,?,?,?,?,?,?,?,NOW(),NOW())";
				prepStmt = conn.prepareStatement(sql);
				conn.setAutoCommit(false);
				for(Test t: tests){
					prepStmt.setLong(1, suitePK);
					prepStmt.setString(2, t.getQuestion().toString());
					prepStmt.setString(3, t.getOptions().toString());
					prepStmt.setString(4, t.getAnswers().toString());
					if(t.getKeywords() == null){
						prepStmt.setNString(5, null);//prepStmt.setNull(5, sqlType);
					}else{
						prepStmt.setNString(5, t.getKeywords().toString());
					}
					prepStmt.setString(6, t.getPic());
					prepStmt.setInt(7, t.getSerialNo());
					if(t.getWatchword() == null){
						prepStmt.setNString(8, null);
					}else{
						prepStmt.setNString(8, t.getWatchword().toString());						
					}
					if(t.getTips() == null){
						prepStmt.setNString(9, null);						
					}else{
						prepStmt.setNString(9, t.getTips().toString());
					}
					prepStmt.addBatch();
				}	
				prepStmt.executeBatch();
				conn.commit();
				conn.setAutoCommit(true);
				prepStmt.clearBatch();
				prepStmt.close();
				conn.close();
				
			}
		}catch(SQLException e){
			logger.error("[addTests]: " + e.toString());
			try {
				conn.rollback();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				logger.error("[addTests]: " + e1.toString());
				e1.printStackTrace();
			}
			return false;
		}
		return true;
	}
	private Long addEmptySuite(String name){
		long newSuitePK = -1L;
		DataSource dataSource = (DataSource) jndiObjFactoryBean.getObject();
		String sql = "INSERT INTO testsuite (name) VALUES (?)";
		try {
			Connection conn = dataSource.getConnection();
			PreparedStatement prepStmt = conn.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS);
			prepStmt.setString(1, name);
			prepStmt.executeUpdate();
			ResultSet rs = prepStmt.getGeneratedKeys();
			if(rs != null && rs.next()){
				newSuitePK = rs.getLong(1);
			}else{
				logger.error("[saveTest]: Could not get PK of new suite of " + name + " !");
				prepStmt.close();
				conn.close();
 			}
			prepStmt.close();
			conn.close();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			
		}		
		return newSuitePK;
	}
	@RequestMapping(value = "/oneedit", method = RequestMethod.POST)
	public @ResponseBody String oneEditPOST(
			Locale locale,
			Model model,
			HttpSession session,
			HttpServletRequest request, 
			HttpServletResponse response,
			@RequestParam ("suite") String suite,
			@RequestParam ("test") String test) {
		logger.info(request.getRequestURL().toString());

		JsonParser jp = new JsonParser();
		JsonObject testObj = jp.parse(test).getAsJsonObject();
		Test t = new Test();
	    if(testObj.get("pic") != null
	    	&& testObj.get("pic").isJsonNull() == false){
	    	if(testObj.get("newpic") != null
	    	&& testObj.get("newpic").isJsonNull() == false
	    	&& testObj.get("newpic").getAsBoolean() == true){
				String destDir = request.getSession().getServletContext().getRealPath("/");
				destDir += "resources";
				destDir += File.separator;
				destDir += "pic";
				destDir += File.separator;
				logger.info("[2_save_img_2] " + destDir);
			    Authentication auth = SecurityContextHolder.getContext().getAuthentication();
			    String curUser = auth.getName();
			    String encFileName = null;
				String strB64Pic = testObj.get("pic").getAsString();
				encFileName = encrypt(curUser + "MendezMasterTrainingCenter6454_testpickey",suite + "-" + testObj.get("serialNo").getAsString());			
				strB64Pic = strB64Pic.substring(strB64Pic.indexOf(",")+1);
				byte[] rawPicBytes = Base64.decodeBase64(strB64Pic);
				logger.debug("[pic_enc_name]: " + encFileName);
				try {
					FileOutputStream out = new FileOutputStream(destDir+encFileName);
					out.write(rawPicBytes);
					out.close();
				} catch (FileNotFoundException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				t.setPic(encFileName);
				//Upload to S3.
				if(DEBUG == false){
					File outFile = new File(destDir+encFileName); 
					uploadS3(outFile);
				}
			}else{
				String pic = testObj.get("pic").getAsString();
				pic = pic.substring(pic.lastIndexOf("pic/")+4);
				if(testObj.get("delpic") != null
					&& testObj.get("delpic").getAsBoolean() == true){
					String destDir = request.getSession().getServletContext().getRealPath("/");
					destDir += "resources";
					destDir += File.separator;
					destDir += "pic";
					destDir += File.separator;
					final String file2Del = destDir + pic;
					//launch separate thread to delete local picture file.
					new Thread(){
						public void run(){
							try {
								Files.delete(Paths.get(file2Del));
							} catch (IOException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
								logger.error("[oneeditPOST]: Failed deleting local pic, " + e.toString());
							}
						}
					}.start();
				}else{
					//Prepare file-name-only to return back to client if pic was not edited.
					t.setPic(pic);
				}
			}
			

	    }

		t.setAnswers(testObj.get("answers").getAsJsonArray());
		if(testObj.get("kwds") != null){
			t.setKeywords(testObj.get("kwds").getAsJsonArray());
		}
		t.setOptions(testObj.get("options").getAsJsonArray());
		
		JsonArray quesJArr = testObj.get("question").getAsJsonArray();
		JsonElement quesPrefixedBySerial = quesJArr.get(0);
		int dotPos = quesJArr.get(0).getAsString().indexOf(".");
		if(dotPos != -1){
			quesJArr.set(0, new JsonPrimitive(quesJArr.get(0).getAsString().substring(dotPos+1)));
		}		
		t.setQuestion(quesJArr);
		if(testObj.get("serialNo") != null){
			t.setSerialNo(testObj.get("serialNo").getAsInt());
		}
		t.setSuite(suite);
		JsonElement elm = testObj.get("tips");
		if(elm != null){
			if(elm.isJsonArray() == true){
				t.setTips(testObj.get("tips").getAsJsonArray());
			}else{
				if(elm.getAsString().length() > 0){
					JsonArray tipArr = new JsonArray();
					tipArr.add(elm);
					t.setTips(tipArr);
				}
			}
		}
		elm = testObj.get("watchword");
		if(elm != null){
			if(elm.isJsonArray() == true){
				t.setTips(testObj.get("watchword").getAsJsonArray());
			}else{
				if(elm.getAsString().length() > 0){
					JsonArray tipArr = new JsonArray();
					tipArr.add(elm);
					t.setWatchword(tipArr);
				}
			}
		}	
		JsonObject result = new JsonObject();
		if(testObj.get("isnew") != null && testObj.get("isnew").getAsBoolean() == true){
			logger.info("[oneedit]: Add new test.");
			result.add("result", new JsonPrimitive(addTest(suite,t)));
		}else{
			result.add("result", new JsonPrimitive(updateTest(suite,t)));		
		}
		
		Gson gson = new Gson();
		t.getQuestion().set(0, quesPrefixedBySerial);
		result.add("test", gson.toJsonTree(t));
		String strJ = gson.toJson(result).replace("\\", "\\\\");	
		return strJ;
	}
	@RequestMapping(value = "/submitedit", method = RequestMethod.POST)
	public @ResponseBody ModelAndView submitEditPOST(
			Locale locale,
			Model model,
			HttpSession session,
			HttpServletRequest request, 
			HttpServletResponse response,
			@RequestParam("testdata") String tests) {
		ModelAndView v = new ModelAndView();
		logger.info(request.getRequestURL().toString());
		JsonParser jsonParser = new JsonParser();
		JsonObject jsonTestSuite = jsonParser.parse(tests).getAsJsonObject();
		//Check if test editor is authenticated user.
		String user = null;
		if(request.getUserPrincipal().getName().equals(jsonTestSuite.get("user").getAsString()) == false){
			v.setViewName("result");
			v.addObject("result","Editing failed: Test taker and logged-in user are different.");
			return v;
		}else{
			user = request.getUserPrincipal().getName();
		}

		//Check for deleted tests and update to database.
		String suite = jsonTestSuite.get("suite").getAsString();
		ArrayList<Test> curTests = getTestsForSuite(suite);
		JsonArray jsonTests = jsonTestSuite.get("tests").getAsJsonArray();
		Boolean hasDeletedTest = false;
		for(int i = jsonTests.size() - 1; i > -1; --i){
			JsonObject t = jsonTests.get(i).getAsJsonObject();
			if(t.get("del") != null && t.get("del").getAsBoolean() == true){
				hasDeletedTest = true;
				int sn = t.get("serialNo").getAsInt();
				curTests.remove(sn-1);
			}
		}
		//Adjust test serial numbers.
		for(int j = 0; j < curTests.size(); ++j){
			curTests.get(j).setSerialNo(j+1);
		}
		//Update to DB.
		if(hasDeletedTest == true){
			if(curTests.size() > 0){
				addTests(suite,curTests);
			}else{
				//remove suite.
				deleteSuite(suite,-1L);
			}
		}
		return new ModelAndView("home");
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
    		Integer pI = 1;
    		int r  = 0;
    		int jArrLen = 0;
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
                Boolean isBadQuestion = false;
                Boolean isFirstCell = true;
                conn = dataSource.getConnection();
                sql =  "INSERT INTO test (serial, question, answer, keywords, options, watchword, tips, testsuite_pk, " + 
                		"createdat, updatedat) VALUES (?,?,?,?,?,?,?,?,NOW(),NOW())";
    			preparedSql = conn.prepareStatement(sql);
                while(rItor.hasNext()){
                	Row row = rItor.next();//Row row = sheet1.getRow(i);
                	if(row.getPhysicalNumberOfCells() > 0){
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
	                                curValue = String.valueOf(cell.getNumericCellValue());
                                	if(jArr == null)
                                		jArr = new  JsonArray();
                            		jArr.add(curValue);	                                
	                                break;
	                            case Cell.CELL_TYPE_STRING:
	                            	curValue = cell.getStringCellValue();
	                            	logger.info("{}",curValue);
	                            	if(isBadQuestion == false){
	                            		if(isQuestion == true){
	                            			//boolean isEnglish = curValue.matches("[\\w\\s\\.\\?]+");
	                            			//if(isEnglish == true){
	                            			if(isFirstCell == true){
	                            				isFirstCell = false;
	                            				int dotPos = curValue.indexOf('.');
	    	                            		if(dotPos != -1){
	    	                            			curTestSerial = curValue.substring(0, dotPos);
	    	                            			curValue = curValue.substring(dotPos+1);
	    	                            			if(curValue.equals("NOQUESTION")){
	    	                            				isBadQuestion = true;
	    	                            				break cellloop;
	    	                            			}
	    	                            			Integer c = Integer.parseInt(curTestSerial);
	    	                            			Integer p = Integer.parseInt(prevTestSerial);
	    	                            			if(c-p > 1)
	    	                            				c-=1;
	    	                            			preparedSql.setInt(pI, c);
	    	                            			pI++;
	    	                            			prevTestSerial = c.toString();
	    		                            		if(jArr == null)
	    		                                		jArr = new  JsonArray();
	    		                            		jArr.add(curValue);	
	    	                            		}                           				
	                            			}else{
		                            			//Error: Question doesn't begin with serial number followed by '.'.
		                            			//Check if this cell has chinese translation of question.
	                            				//Chinese.
			                            		if(jArr == null)
			                                		jArr = new  JsonArray();
			                            		jArr.add(curValue);	                            				
		                            			
		                            		}                            		
		                            		//break cellloop;//We only allow 1 cell for question.
		                            	}else{
		                                	if(jArr == null)
		                                		jArr = new  JsonArray();
		                            		jArr.add(cell.getStringCellValue());
		                            	}	                            		
	                            	}
	                            	
	                                break;
	                            case Cell.CELL_TYPE_BLANK:
	                            	logger.info("[CELL_TYPE_BLANK]!");
	                            	break;
	                            default:
	                            	logger.error("[UNKnown cell type]!!");
	                            	break;
	                            
	                        }
	                    }
	                    /*
	                    if(jArr != null && isQuestion == false){
	                    	curValue = jArr.toString();
	                    	preparedSql.setNString(pI, curValue);
	                    	if(pI == 5)
	                    		pI = 0;
	                    	jArr = null;
	                    }
	                    */
	                    logger.info("[END_ROW]");
                	}else{
                		logger.info("[EMPTY_ROW]");
                	}
                	
                	if(jArr != null){
	                	if(r != 0 && r % DataRows == 0){
	                   		r=0;
	                		if(isQuestion == false){
	                			isQuestion = true;
	                			isBadQuestion = false;
	                			isFirstCell = true;
		                    	curValue = jArr.toString();
		                    	preparedSql.setNString(pI, curValue);
		                    	++pI;
	                			preparedSql.setLong(pI, rowID);
		                    	if(pI == 8){
		                    		//logger.info("[ROTATE pI].");
		                    		pI = 1;
		                    	}
	                            preparedSql.addBatch();
	                            jArr.remove(0);
	                            jArr = null;
	                            logger.info("[Done_prepared_batch]: " + preparedSql.toString());
	                		}
	                	}else{ 
	                		if(isQuestion == true){
		                    	curValue = jArr.toString();
		                    	preparedSql.setNString(pI, curValue);
		                    	++pI;
		                    	jArr = null;               			
	                			isQuestion = false;
	                		}else{
		                    	curValue = jArr.toString();
		                    	preparedSql.setNString(pI, curValue);
		                    	++pI;
		                    	jArr = null;              			
	                		}
	                		++r;
	                		
	                	}
                	}else{
                		if(isBadQuestion == true){
	                		if(r != 0 && r % 5 == 0){
	                			r = 0;
	                			isQuestion = true;
	                			isBadQuestion = false;
	                			isFirstCell = true;
	                		}else{
	                			++r;
	                		}
                		}	
                	}
                	
                }
                //Scoop up last item.
               	if(jArr != null){
	                curValue = jArr.toString();
	            	preparedSql.setNString(pI, curValue);
	            	/*++pI;
	            	jArrLen = jArr.size();
	            	for(int i = 0; i < jArrLen; ++i){
	            		jArr.remove(0);
	            	}
	            	
	            	jArr.add("NOHIGHLIGHT");
	    			preparedSql.setNString(pI, jArr.toString());
	            	
	    			jArr.remove(0);
	    			jArr.add("NOTIPS");
	            	++pI;
	            	preparedSql.setNString(pI, jArr.toString());
	            	++pI;
	    			preparedSql.setLong(pI, rowID);
	            	if(pI == 8){
	            		logger.info("[ROTATE pI].");
	            		pI = 1;
	            	}*/
	                preparedSql.addBatch();
        			preparedSql.setLong(8, rowID);
                    preparedSql.addBatch();
                    logger.info("[Done_LAST_prepared_batch].");
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
		ArrayList<Test> tests = getTestsForDisplayForSuite(s);
		Random random = new Random();
		if(suite.getIsQuestionRandom() != null){
			Test lastUnStruck = null;
			Test randomPickTest = null;
			String fullQues = null;
			int dotPos = 0;
			//Randomize.
			 int r = 0;
			 int i = tests.size() - 1;
			 for(; i >= 1; --i){
				 r = random.nextInt(i);
				 lastUnStruck = tests.get(i);
				 randomPickTest = tests.get(r);
				 JsonArray jArrQuestion = randomPickTest.getQuestion();
				 fullQues = jArrQuestion.get(0).getAsString();
				 dotPos = fullQues.indexOf(".");
				 if(dotPos != -1){
					 String ques = fullQues.substring(dotPos);
					 fullQues = String.valueOf(i+1) + ques;
				 }else{
					 logger.error("[runSuitePOST]: Found question not beginning with serial!");
					 //Make it right: random + "." + question.
					 fullQues = String.valueOf(i+1) + "." + fullQues;					 
				 }		
				 jArrQuestion.set(0, new JsonPrimitive(fullQues));
				 randomPickTest.setQuestion(jArrQuestion);
				 
				 tests.set(i, randomPickTest);
				 tests.set(r, lastUnStruck);
				 
			 }
			 
			 //We updated new random picks before, and always
			 //have to update last i-th item after the loop.
			 JsonArray jArrQuestion = tests.get(i).getQuestion();
			 fullQues = jArrQuestion.get(0).getAsString();
			 dotPos = fullQues.indexOf(".");
			 if(dotPos != -1){
				 String ques = fullQues.substring(dotPos);
				 fullQues = String.valueOf(i+1) + ques;
			 }else{
				 logger.error("[runSuitePOST]: Found question not beginning with serial!");
				 //Make it right: random + "." + question.
				 fullQues = String.valueOf(i+1) + "." + fullQues;					 
			 }	
			 jArrQuestion.set(0, new JsonPrimitive(fullQues));
			 tests.get(i).setQuestion(jArrQuestion);
		}
		if(suite.getIsChoiceRandom() != null){			
			int r = 0;
			int dotPos = -1;
			String strTemp1;
			JsonElement jElemTemp;
			JsonElement jElemRandom;
			for(int i = 0; i < tests.size(); ++i){
				Test curTest = tests.get(i);
				JsonArray curOptions = curTest.getOptions();
				JsonArray randomOptions = curOptions;
				int len = randomOptions.size();

				int j = len - 1;
				for(; j >= 1; --j){
					r = random.nextInt(j);		
					jElemTemp = randomOptions.get(j);
					jElemRandom = randomOptions.get(r);
					strTemp1 = jElemRandom.getAsString();
					dotPos = strTemp1.indexOf(".");
					if(dotPos != -1){
						strTemp1 = String.valueOf((char)(j+65)) + strTemp1.substring(dotPos);
					}else{
						logger.error("[runSuitePOST]: Found bad formatted option without dot between A|B|C|D and rest!Test[" + String.valueOf(i) + "], Option[" + strTemp1 + "]");
						strTemp1 = String.valueOf((char)(j+65)) + "." + strTemp1;
					}
					randomOptions.set(j, new JsonPrimitive(strTemp1));
					randomOptions.set(r, jElemTemp);
				}
				
				//Adjust A|B|C|D after randomization for j-th value.
				strTemp1 = randomOptions.get(j).getAsString();
				dotPos = strTemp1.indexOf(".");
				if(dotPos != -1){
					strTemp1 = String.valueOf((char)(j+65)) + strTemp1.substring(dotPos);
				}else{
					logger.error("[runSuitePOST]: Found bad formatted option without dot between A|B|C|D and rest! Test[" + String.valueOf(i) + "], Option[" + strTemp1 + "]");
					strTemp1 = String.valueOf((char)(j+65)) + "." + strTemp1;
				}
				randomOptions.set(j, new JsonPrimitive(strTemp1));				
				
				curTest.setOptions(randomOptions);
			}
			
		}
		
		
		JsonObject jSuite = new JsonObject();
		jSuite.addProperty("suite", s);
		Gson gson = new Gson();
		JsonArray jTests = (JsonArray)gson.toJsonTree(tests, new TypeToken<ArrayList<Test>>(){}.getType());
		jSuite.add("tests", jTests);
		//String strJ = gson.toJson(jSuite);
		String strJ = gson.toJson(jSuite).replace("\\", "\\\\");
		request.setAttribute("tests",strJ);
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
		String sql = "SELECT serial, pic ,updatedat, question, options,answer,keywords,watchword,tips FROM test "
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
			String temp;
			JsonElement elem = null;
			JsonArray jsonArr = null;
			Test found = null;
			while(s.next()){
				found = new Test();
				if(s.getString("question").equals("[\"NOQUESTION\"]") == false){
					elem = jp.parse(s.getString("question"));
					jsonArr = elem.getAsJsonArray();
					temp = jsonArr.get(0).getAsString();
					temp = serial + "." + temp;
					jsonArr.set(0, new JsonPrimitive(temp));
					found.setQuestion(jsonArr);
				}else{
					//Really odd...
					logger.error("[getTestBySuiteAndID]: NOQUESTION found!! " + suite + "::" + testsn);
					continue;
				}

				if(s.getString("watchword").equals("[\"NOHIGHLIGHT\"]") == false){
					elem = jp.parse(s.getString("watchword"));
					jsonArr = elem.getAsJsonArray();
					found.setWatchword(jsonArr);				
				}
				
				if(s.getString("answer").equals("[\"NOANSWER\"]") == false
						&& s.getString("answer").equals("[\"NOANS\"]") == false){
					elem = jp.parse(s.getString("answer"));
					jsonArr = elem.getAsJsonArray();
					found.setAnswers(jsonArr);
				}

				if(s.getString("options").equals("[\"NOOPT\"]") == false){
					elem = jp.parse(s.getString("options"));
					jsonArr = elem.getAsJsonArray();
					found.setOptions(jsonArr);
				}
				
				if(s.getString("keywords").equals("[\"NOKEYWORD\"]") == false){
					elem = jp.parse(s.getString("keywords"));
					jsonArr = elem.getAsJsonArray();
					found.setKeywords(jsonArr);
				}

				//found.setOptions(s.getString("options"));
				serial = Integer.toString(s.getInt("serial"));
				found.setPic(s.getString("pic"));
				if(s.getString("tips").equals("[\"NOTIPS\"]") == false){
					elem = jp.parse(s.getString("tips"));
					jsonArr = elem.getAsJsonArray();
					found.setTips(jsonArr);
				}
				found.setId(encrypt(curUser + "MendezMasterTrainingCenter6454",suite + "-" + serial));
				if(DEBUG == true){
					found.setSuite(suite);
				}
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
	private ArrayList<Test> getTestsForSuite(String suite){
		logger.info("getTestsForSuite()!");
		DataSource dataSource = (DataSource) jndiObjFactoryBean.getObject();
		ArrayList<Test> tests = new ArrayList<Test>();
		String sql = "SELECT serial, updatedat, question, options,answer,keywords,pic,tips,watchword FROM test WHERE testsuite_pk IN (SELECT pk FROM testsuite WHERE name=?) ORDER BY serial";
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
			String temp;
			Test found = null;
			JsonElement elem = null;
			JsonArray jsonArr = null;
			while(s.next()){
				found = new Test();
				serial = Integer.toString(s.getInt("serial"));
				if(s.getString("question").equals("[\"NOQUESTION\"]") == false){
					//logger.info("[getTestsForDisplayForSuite_Q]: " + s.getString("question"));
					elem = jp.parse(s.getString("question"));
					jsonArr = elem.getAsJsonArray();
					found.setQuestion(jsonArr);
				}else{
					//Really odd, ought have been filtered out in uploadtestsuite.
					logger.error("[getTestsForDisplayForSuite] NOQUESTION found!! TestSuite[" + suite + "][" + serial + "]");
					continue;
				}
				
				
				if(s.getString("watchword") != null 
					&& s.getString("watchword").equals("[\"NOHIGHLIGHT\"]") == false){
					elem = jp.parse(s.getString("watchword"));
					jsonArr = elem.getAsJsonArray();
					found.setWatchword(jsonArr);
				}
				
				if(s.getString("answer").equals("[\"NOANSWER\"]") == false
						&& s.getString("answer").equals("[\"NOANS\"]") == false){
					elem = jp.parse(s.getString("answer"));
					jsonArr = elem.getAsJsonArray();
					found.setAnswers(jsonArr);
				}

				if(s.getString("options").equals("[\"NOOPT\"]") == false){
					elem = jp.parse(s.getString("options"));
					jsonArr = elem.getAsJsonArray();
					found.setOptions(jsonArr);
				}
				
				if(s.getString("keywords") != null
					&& s.getString("keywords").equals("[\"NOKEYWORD\"]") == false){
					elem = jp.parse(s.getString("keywords"));
					jsonArr = elem.getAsJsonArray();
					found.setKeywords(jsonArr);
				}
				
				found.setPic(s.getString("pic"));
				if(s.getString("tips") != null && s.getString("tips").equals("[\"NOTIPS\"]") == false){
					elem = jp.parse(s.getString("tips"));
					jsonArr = elem.getAsJsonArray();
					found.setTips(jsonArr);					
				}
				found.setId(encrypt(curUser + "MendezMasterTrainingCenter6454",suite + "-" + serial));
				if(DEBUG == true){
					found.setSuite(suite);
				}
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
	private ArrayList<Test> getTestsForDisplayForSuite(String suite){
		logger.info("getTestsForDisplayForSuite()!");
		DataSource dataSource = (DataSource) jndiObjFactoryBean.getObject();
		ArrayList<Test> tests = new ArrayList<Test>();
		String sql = "SELECT serial, updatedat, question, options,answer,keywords,pic,tips,watchword FROM test WHERE testsuite_pk IN (SELECT pk FROM testsuite WHERE name=?) ORDER BY serial";
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
			String temp;
			Test found = null;
			JsonElement elem = null;
			JsonArray jsonArr = null;
			while(s.next()){
				found = new Test();
				serial = Integer.toString(s.getInt("serial"));
				if(s.getString("question").equals("[\"NOQUESTION\"]") == false){
					//logger.info("[getTestsForDisplayForSuite_Q]: " + s.getString("question"));
					elem = jp.parse(s.getString("question"));
					jsonArr = elem.getAsJsonArray();
					temp = jsonArr.get(0).getAsString();
					temp = serial + "." + temp;
					jsonArr.set(0, new JsonPrimitive(temp));
					found.setQuestion(jsonArr);
				}else{
					//Really odd, ought have been filtered out in uploadtestsuite.
					logger.error("[getTestsForDisplayForSuite] NOQUESTION found!! TestSuite[" + suite + "][" + serial + "]");
					continue;
				}
				
				
				if(s.getString("watchword") != null 
					&& s.getString("watchword").equals("[\"NOHIGHLIGHT\"]") == false){
					elem = jp.parse(s.getString("watchword"));
					jsonArr = elem.getAsJsonArray();
					found.setWatchword(jsonArr);
				}
				
				if(s.getString("answer").equals("[\"NOANSWER\"]") == false
						&& s.getString("answer").equals("[\"NOANS\"]") == false){
					elem = jp.parse(s.getString("answer"));
					jsonArr = elem.getAsJsonArray();
					found.setAnswers(jsonArr);
				}

				if(s.getString("options").equals("[\"NOOPT\"]") == false){
					elem = jp.parse(s.getString("options"));
					jsonArr = elem.getAsJsonArray();
					found.setOptions(jsonArr);
				}
				
				if(s.getString("keywords") != null
					&& s.getString("keywords").equals("[\"NOKEYWORD\"]") == false){
					elem = jp.parse(s.getString("keywords"));
					jsonArr = elem.getAsJsonArray();
					found.setKeywords(jsonArr);
				}
				
				found.setPic(s.getString("pic"));
				if(s.getString("tips") != null && s.getString("tips").equals("[\"NOTIPS\"]") == false){
					elem = jp.parse(s.getString("tips"));
					jsonArr = elem.getAsJsonArray();
					found.setTips(jsonArr);					
				}
				found.setId(encrypt(curUser + "MendezMasterTrainingCenter6454",suite + "-" + serial));
				if(DEBUG == true){
					found.setSuite(suite);
				}
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
		String strFinalCipherText = new String(Base64.encodeBase64(finalCipherText,false,true));
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
	@RequestMapping(value = "/execans", method = RequestMethod.GET)
	public @ResponseBody ModelAndView execAnsGET(
			Locale locale,
			Model model,
			HttpSession session,
			HttpServletRequest request, 
			HttpServletResponse response,
			@RequestParam("su") String suite,
			@RequestParam("u") String user,
			@RequestParam("st") Long st,
			@RequestParam("et") Long et){
		ModelAndView v = new ModelAndView();
		logger.info(request.getRequestURL().toString());
		JsonParser jp = new JsonParser();
		//Check cache.
		String cacheKey = user+suite+st.toString()+et.toString();
		Object testTakingCache = memcachedClient.get(cacheKey);
		JsonObject cache = null;

		if(testTakingCache != null){
			logger.debug("[execans]: Fetch cache: " + testTakingCache.toString());
			cache = jp.parse(testTakingCache.toString()).getAsJsonObject();
		}else{
			logger.debug("[execans]: Cache miss: " + cacheKey);
		}	
		String strJ = null;
		if(cache == null){
			
		
			String sql = "SELECT pk FROM test_taking WHERE user_username=? "
					+ "AND start_time = ? AND end_time=? AND testsuite_name=?";
			
			DataSource dataSource = (DataSource) jndiObjFactoryBean.getObject();
			Connection conn = null;
			PreparedStatement prepStmt = null;
			ArrayList<Test> tests = null;
			ArrayList<Test> reorderedTests = null;
			try{
				long testTakingPK = 0L;			
				TestTaking taking = null;
				JsonArray options = null;
				String strOptions;
				int serial = 0;
				conn = dataSource.getConnection();
				prepStmt = conn.prepareStatement(sql);			
				prepStmt.setString(1, user);
				prepStmt.setTimestamp(2, new Timestamp(st));
				prepStmt.setTimestamp(3, new Timestamp(et));
				prepStmt.setString(4, suite);
				ResultSet rs = prepStmt.executeQuery();
				if(rs != null && rs.next()){
					testTakingPK = rs.getLong(1);
				}
				rs.close();			
				prepStmt.close();
				
				tests = getTestsForDisplayForSuite(suite);
				
				
				sql = "SELECT stuans, test_taking_serial,orig_test_serial, test_taking_options "
						+ "FROM test_taking_snapshot WHERE test_taking_pk = ? ORDER BY test_taking_serial";
				
				prepStmt = conn.prepareStatement(sql);
				prepStmt.setString(1, String.valueOf(testTakingPK));
				rs = prepStmt.executeQuery();
				if(rs != null){
					if(reorderedTests == null){
						reorderedTests = new ArrayList<Test>(tests.size());
					}
					String strQuestion;
					JsonArray questionArr = null;
					Test temp = null;
					int testTakingSerial = 0;
					int origTestSerial = 0;
					while(rs.next()){
						taking = null;
						taking = new TestTaking();					
						taking.setStuAns(rs.getString("stuans"));
						testTakingSerial = rs.getInt("test_taking_serial");
						taking.setSerial(String.valueOf(testTakingSerial));
						strOptions = rs.getString("test_taking_options");
						JsonElement elem = jp.parse(rs.getString("test_taking_options"));
						options = elem.getAsJsonArray();
						taking.setOptions(options);
						origTestSerial = rs.getInt("orig_test_serial");
						temp = tests.get(origTestSerial-1);
						questionArr = temp.getQuestion();
						strQuestion = questionArr.get(0).getAsString();
						strQuestion = String.valueOf(testTakingSerial) + strQuestion.substring(strQuestion.indexOf("."));
						questionArr.set(0, new JsonPrimitive(strQuestion));
						//temp.setQuestion(questionArr);
						temp.setTaking(taking);
						
						reorderedTests.add(temp);
					}
				}	
				rs.close();
				prepStmt.close();
				conn.close();
			}catch(Exception e){
				e.printStackTrace();
				logger.error("[execans] " + e.getMessage());	
				//Say the testsuite student took was deleted by our editor....
				v.setViewName("execans");
				return v;
			}
			
			JsonObject jSuite = new JsonObject();
			jSuite.addProperty("suite", suite);
			Gson gson = new Gson();
			JsonArray jTests = (JsonArray)gson.toJsonTree(reorderedTests, new TypeToken<ArrayList<Test>>(){}.getType());
			jSuite.add("tests", jTests);
			strJ = gson.toJson(jSuite).replace("\\", "\\\\");
		}else{
			JsonObject jSuite = new JsonObject();
			jSuite.addProperty("suite", cache.get("suite").getAsString());
			Gson gson = new Gson();
			jSuite.add("tests", cache.get("tests").getAsJsonArray());
			strJ = gson.toJson(jSuite).replace("\\", "\\\\");
		}

		request.setAttribute("tests",strJ);		
		
		v.setViewName("execans");
		return v;
	}
	@RequestMapping(value = "/submitans", method = RequestMethod.POST)
	public @ResponseBody ModelAndView submitAnsPOST(
			Locale locale,
			Model model,
			HttpSession session,
			HttpServletRequest request, 
			HttpServletResponse response){
		ModelAndView v = new ModelAndView();
		logger.info(request.getRequestURL().toString());
		JsonParser jsonParser = new JsonParser();
		JsonObject jsonTestSuite = jsonParser.parse(request.getParameter("tests")).getAsJsonObject();
		//Check if test taker is authed user.
		String user = null;
		if(request.getUserPrincipal().getName().equals(jsonTestSuite.get("user").getAsString()) == false){
			v.setViewName("result");
			v.addObject("result","Test taker and logged-in user are different.");
			return v;
		}else
			user = request.getUserPrincipal().getName();
		//Calculate grade.
		JsonArray jArrTests = jsonTestSuite.getAsJsonArray("tests");
		Iterator<JsonElement> itor = jArrTests.iterator();
		String stuAns;
		String correctAns;
		Integer grade = 0;
		while(itor.hasNext()){
			JsonElement cur = itor.next();
			if(cur.getAsJsonObject().get("taking") != null){
				if(cur.getAsJsonObject().get("taking").getAsJsonObject().get("stuans") != null){
					stuAns = cur.getAsJsonObject().get("taking").getAsJsonObject().get("stuans").getAsString();
					//TODO: change this if in the future they start to use multi-selection questions.
					correctAns = cur.getAsJsonObject().getAsJsonArray("answers").get(0).getAsString();
					if(stuAns.equals(correctAns)){
						grade += 1;
					}
				}
			}
		}
		SimpleDateFormat ymdFmt = new SimpleDateFormat("yyyy-MM-dd");		
		SimpleDateFormat hmFmt = new SimpleDateFormat("HH:mm aaa");		

		long startTime = jsonTestSuite.get("beg").getAsLong();
		long endTime = jsonTestSuite.get("end").getAsLong();
		Date sdt = new Date(startTime);
		Date edt = new Date(endTime);
		String tt = null;
		Timestamp stmp = new Timestamp(startTime);
		Timestamp etmp = new Timestamp(endTime);
		//Integer dur = jsonTestSuite.get("testdur").getAsInt();
		JsonObject tempTest = jArrTests.get(0).getAsJsonObject();
		String suiteAndTest = decryptTestID(user + "MendezMasterTrainingCenter6454",tempTest.get("id").getAsString());
		String[] s_t = suiteAndTest.split("-");
		
		//Cache test data.
	 	String cacheKey = user+s_t[0]+String.valueOf(startTime)+String.valueOf(endTime);
	 	Object testTakingCache = memcachedClient.get(cacheKey);
		if(testTakingCache == null){
			logger.debug("[submitans]: Caching " + cacheKey);
			memcachedClient.set(cacheKey, 3600, jsonTestSuite.toString());
		}	
		
		DataSource dataSource = (DataSource) jndiObjFactoryBean.getObject();
		String sql = "INSERT INTO test_taking " 
				+ "(user_username, grade, start_time, end_time, duration_in_sec,testsuite_name) " 
				+ "VALUES (?,?,?,?,?,"
				+ "(SELECT name FROM testsuite WHERE name = '"+ s_t[0] +"'))";
		PreparedStatement prepStmt = null;
		JsonObject t = null;
		long newRowID = -1L;
		Boolean isTestTakingInserted = true;
		try{
			Connection conn = dataSource.getConnection();
			tt = sdf.format(sdt);
			prepStmt = conn.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS);			
			prepStmt.setString(1, user);
			prepStmt.setInt(2, grade);
			prepStmt.setTimestamp(3, stmp);
			prepStmt.setTimestamp(4, etmp);
			prepStmt.setInt(5,((Long)((endTime - startTime)/1000)).intValue());
			prepStmt.executeUpdate();
			ResultSet rs = prepStmt.getGeneratedKeys();
			if(rs != null && rs.next()){
				newRowID = rs.getLong(1);
			}
			conn.close();
		}catch(Exception e){
			e.printStackTrace();
			logger.error("[submitans] " + e.getMessage());	
			isTestTakingInserted = false;
		}
		

		
		
		if(isTestTakingInserted == true){
			//Insertion test_taking failed, so we don't insert details of this test taking.
			if(jArrTests.size() > 10){
				ArrayList<JsonArray> testSplits = splitJsonArray(3,jArrTests);
				for(int i = 0; i < testSplits.size(); ++i){
					InsertTestAnsThread insertThread = new InsertTestAnsThread(dataSource,testSplits.get(i), newRowID);
					insertThread.start();
				}
			}else{
				InsertTestAnsThread insertThread = new InsertTestAnsThread(dataSource,jArrTests, newRowID);
				insertThread.start();			
			}
		}
		v.setViewName("review");
		v.addObject("participant", user);
		String ymd = ymdFmt.format(sdt);
		String hm = hmFmt.format(sdt);
		//v.addObject("date",ymd);
		v.addObject("starttime",startTime);//sdt.toString());
		v.addObject("endtime",endTime);//edt.toString());
		String strElapsedTime;
		long elapsedSec = (endTime - startTime);///1000;
		String days = String.valueOf(Math.floor(elapsedSec/(1000*60*60*24)));
		String hours = String.valueOf(Math.floor((elapsedSec/(1000*60*60)) % 24));
		String mins = String.valueOf(Math.floor((elapsedSec/1000/60) % 60));
		String seconds = String.valueOf(Math.floor((elapsedSec/1000) % 60));
		strElapsedTime = days;
		strElapsedTime += " days ";
		strElapsedTime += hours;
		strElapsedTime += " hours ";
		strElapsedTime += mins;
		strElapsedTime += " mins ";
		strElapsedTime += seconds;
		strElapsedTime += " seconds";
		v.addObject("elaptime", strElapsedTime);
		v.addObject("passscore","630/900");
		v.addObject("urscore", String.valueOf(grade * 10) + "/1000");
		if(grade >= 70){
			v.addObject("grade","Pass");
		}else{
			v.addObject("grade","Fail");
		}
		//http://hdnrnzk.me/2012/07/04/creating-a-bar-graph-using-d3js/
		JsonArray scoreRange = new JsonArray();
		scoreRange.add(grade*10);
		scoreRange.add(700);
		scoreRange.add(1000);
		v.addObject("scores",scoreRange.toString());
		v.addObject("suite",s_t[0]);
		return v;
	}	
	private class InsertTestAnsThread extends Thread{
		private DataSource dataSource = null;
		private JsonArray tests = null;
		private Long testTakingPK = null;
		public InsertTestAnsThread(
				DataSource datasource,
				JsonArray tests,
				Long testTakingPk){
			this.dataSource = datasource;
			this.tests = tests;
			this.testTakingPK = testTakingPk;
		}
		
		@Override
		public void run(){
			Iterator<JsonElement> itor = tests.iterator();
			JsonObject test = null;
			String sql = "INSERT INTO test_taking_snapshot (stuans, test_taking_serial,test_taking_options,test_taking_pk,orig_test_serial,marked)" 
					+ " VALUES (?,?,?," + testTakingPK.toString() + ",?,?)";
			PreparedStatement prepStmt = null;
			Connection conn = null;
			try {
				Integer serial = null;
				String strSerial;
				String strQuestion;
				String testOptions;
				conn = dataSource.getConnection();
				prepStmt = conn.prepareStatement(sql);
				conn.setAutoCommit(false);

				for(int i = 0; i < tests.size(); ++i){
					/*if(conn == null && prepStmt == null){
						conn = dataSource.getConnection();
						prepStmt = conn.prepareStatement(sql);
						conn.setAutoCommit(false);
					}*/
					test = tests.get(i).getAsJsonObject(); 
					if(test.get("taking") != null
						&& test.get("taking").getAsJsonObject().get("stuans") != null){
						prepStmt.setString(1, test.get("taking").getAsJsonObject().get("stuans").getAsString());
					}else{
						prepStmt.setString(1,"");
					}
					strQuestion = test.getAsJsonArray("question").get(0).getAsString();
					strSerial = strQuestion.substring(0, strQuestion.indexOf("."));
					prepStmt.setInt(2, Integer.valueOf(strSerial));
					testOptions = test.getAsJsonArray("options").toString();
					prepStmt.setString(3, testOptions);	
					prepStmt.setInt(4, test.get("serialNo").getAsInt());
					if(test.get("marked") != null){
						prepStmt.setInt(5, test.get("marked").getAsBoolean() == true?1:0);
					}else{
						prepStmt.setInt(5, 0);						
					}
					prepStmt.addBatch();
					
					/*if(i!=0 && i%10 == 0){
						prepStmt.executeBatch();
						conn.commit();
						//conn.setAutoCommit(true);
						//conn.close();						
						prepStmt.clearBatch();
						//prepStmt.close();
						//prepStmt = null;
						//conn = null;
					}*/					
				}	
				//if(prepStmt != null
				//		&& prepStmt.isClosed() == false){
					prepStmt.executeBatch();
					conn.commit();
				//}
				prepStmt.clearBatch();
				conn.setAutoCommit(true);
				prepStmt.close();
				conn.close();
				
			} catch (SQLException e) {
				e.printStackTrace();
				try {
					conn.rollback();
				} catch (SQLException e1) {
					e1.printStackTrace();
					logger.error("ROLLBACK of test taking data failed!");
					try {
						conn.close();
					} catch (SQLException e2) {
						e2.printStackTrace();
						logger.error("Closing connection failed!");

					}
				}
			}
			
			
			
						
		}
	}
	
	private ArrayList<JsonArray> splitJsonArray(int splitCount, JsonArray arr){
		if(arr.size() == 0)
			return null;
		ArrayList<JsonArray> resultArray = new ArrayList<JsonArray>();		
		int splitLength = arr.size() / splitCount;
		int remainder = arr.size() % splitCount;
		JsonArray newSubArr = null;
		int i = 0;
		for(; i < arr.size(); ++i){
			if(i == 0){				
				newSubArr = new JsonArray();
			}else if(i % splitLength == 0){
				resultArray.add(newSubArr);
				newSubArr = new JsonArray();
			}
			newSubArr.add(arr.get(i));
		}
		
		if(remainder > 0 || i % splitLength == 0){
			resultArray.add(newSubArr);
		}
		
		
		return resultArray;
	}
}
