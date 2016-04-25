package com.mmtc.exam.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.util.ArrayList;

import org.apache.tomcat.jdbc.pool.DataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class TestIO {
	private static final Logger logger = LoggerFactory.getLogger(TestIO.class);
	public TestIO() {
		// TODO Auto-generated constructor stub
	}

	public static ArrayList<String> getTestSuites(DataSource ds){
		logger.info("getTestSuites()!");
		ArrayList<String> suites = new ArrayList<String>();
		String sql = "SELECT `name` FROM testsuite";
		try{
			Connection conn = ds.getConnection();
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
}
