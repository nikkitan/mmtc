package com.mmtc.exam;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.servlet.ServletContextEvent;

import org.apache.tomcat.jdbc.pool.DataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.jndi.JndiObjectFactoryBean;
import org.springframework.web.context.ContextLoaderListener;
import org.springframework.web.servlet.ModelAndView;

import com.amazonaws.auth.InstanceProfileCredentialsProvider;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.S3Object;
import com.amazonaws.services.s3.model.S3ObjectInputStream;

public class MMTCCtxListener extends ContextLoaderListener {

	private static final Logger logger = LoggerFactory.getLogger(MMTCCtxListener.class);
	@Autowired
	private JndiObjectFactoryBean jndiObjFactoryBean;		
	
	private class S3DownloadThread extends Thread{
		
		private String obj;
		private String ctxRealPath;
		public S3DownloadThread(String pic, String dir){
			obj = pic;
			ctxRealPath = dir;
		}
		@Override
		public void run(){
			AmazonS3 s3Client = new AmazonS3Client(new InstanceProfileCredentialsProvider());
			S3Object dlObj = null;
			try{
				dlObj = s3Client.getObject("mmtctestpic", obj);
			}catch(Exception e){
				e.printStackTrace();
				logger.error("[S3DoWNload] " + obj);
			}
			if(dlObj == null){
				logger.info("[S3DoWNload] NULL=> " + obj);
			}else{
				//save to /resources/pic.
				
				S3ObjectInputStream dlStream = dlObj.getObjectContent();
                int totalBytesRead = 0;
                Long blen = dlObj.getObjectMetadata().getContentLength();
                blen += 1L;
				byte[] buffer =
							new byte[(int)(long)blen];
				logger.info("[S3DoWNload] buffer len: " + blen.toString() + " / " + String.valueOf(buffer.length));

		        int bytesRead = -1;
		        //Save locally.
				FileOutputStream out = null;
				String dir2Save = ctxRealPath;
				dir2Save += "resources";
				dir2Save += File.separator;
				dir2Save += "pic";
				dir2Save += File.separator;	
				dir2Save += dlObj.getKey();
				dir2Save += ".png";
				try {
					out = new FileOutputStream(dir2Save);
				} catch (FileNotFoundException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}		
		        while (true) {
		                try {
							bytesRead = dlStream.read(
							                buffer,
							                totalBytesRead,
							                buffer.length - totalBytesRead);
						} catch (IOException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
							logger.error("[S3DoWNload] failed reading S3ObjectInputStream: " + obj);
							break;
						}
		                if (bytesRead == -1) {
		                        break;
		                } else {
		                        
								logger.info("[S3DoWNload] totalRead: " + String.valueOf(totalBytesRead));
								logger.info("[S3DoWNload] bytesRead: " + String.valueOf(bytesRead));
								try {
									out.write(buffer,totalBytesRead,bytesRead);
								} catch (IOException e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
									logger.error("[S3DoWNload] FileOutputStream failed writing S3ObjectInputStream: " + obj);
								}
								totalBytesRead += bytesRead;

		                }
		        }

				
				try {
					dlStream.close();
				} catch (IOException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
					logger.error("[S3DoWNload] S3ObjectInputStream.close() failed: " + obj );
				}
				try {
					dlObj.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					logger.error("[S3DoWNload] S3Object.close() failed: " + obj );
				}
			}
			
		}
	}
	public MMTCCtxListener(){
		logger.info("[MMTCCtxListner_CTOR]!");
	}
	
	@Override
	public void contextInitialized(ServletContextEvent event){
		super.contextInitialized(event);
		DriverManagerDataSource dataSource = 
				new DriverManagerDataSource(
						"jdbc:mysql://mmtc-db-dev.cjmff6hkiqpv.us-west-2.rds.amazonaws.com:3306/mmtc?autoReconnect=true",
						"root","mysqlmmtc(6454)");

		ArrayList<String> pics = null;
		try {
			Connection conn = dataSource.getConnection();
			String sql = "SELECT DISTINCT pic FROM test";
			String p = null;
			ResultSet rs = conn.createStatement().executeQuery(sql);
			while(rs.next()){
				if(pics == null)
					pics = new ArrayList<String>();
				p = rs.getString("pic");
				if(p != null
					&& p.length() > 0
					&& p.equals("null") == false){
					pics.add(rs.getString("pic"));
				}
			}
			
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
			logger.error("[Ctx_Listener]: Failed select pics from test!");
		} 
		
		for(String pic : pics){
			S3DownloadThread dl = new S3DownloadThread(pic,event.getServletContext().getRealPath("/"));
			dl.start();
		}		
		
	}
	
	@Override
	public void contextDestroyed(ServletContextEvent event){
		super.contextDestroyed(event);
	}
}
