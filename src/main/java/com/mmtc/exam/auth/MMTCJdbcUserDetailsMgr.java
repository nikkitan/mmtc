package com.mmtc.exam.auth;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import org.apache.tomcat.jdbc.pool.DataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jndi.JndiObjectFactoryBean;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.provisioning.UserDetailsManager;

import com.mmtc.exam.dao.MMTCUser;

public class MMTCJdbcUserDetailsMgr 
implements UserDetailsService, UserDetailsManager  {
	@Autowired
	private JndiObjectFactoryBean jndiObjFactoryBean;
	private static final Logger logger = LoggerFactory.getLogger(MMTCJdbcUserDetailsMgr.class);

	public MMTCJdbcUserDetailsMgr(){
		super();
	}

	@Override
	public UserDetails loadUserByUsername(String name)
			throws UsernameNotFoundException,
			AuthorityNotFoundException {
		logger.info("[loadUserByUsername] :" + name);
		DataSource dataSource = (DataSource) jndiObjFactoryBean.getObject();
		String sql = "SELECT username, password, enabled FROM users WHERE username=?";
		PreparedStatement preparedSql = null;
		Connection conn = null;
		MMTCUser user = null;
		try {
			conn = dataSource.getConnection();					
			preparedSql = conn.prepareStatement(sql);
			preparedSql.setString(1, name);
			ResultSet r = preparedSql.executeQuery();
			if(r.next()){
				String username = r.getString("username");
				String password = r.getString("password");
				Boolean enabled = r.getBoolean("enabled");
				ArrayList<SimpleGrantedAuthority> authoList = loadUserAuthorities(username);
				user = new MMTCUser(username, password,enabled,true,true,true,authoList);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			logger.error("[loadUserByUsername] " + e.getMessage());
			throw new UsernameNotFoundException(name + " not found.");
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
		logger.info("[MMTCUser] " + user.toString());
		return user;
	}
	
	public ArrayList<SimpleGrantedAuthority> loadUserAuthorities(String username) throws AuthorityNotFoundException {
		logger.info("[loadUserAuthorities]");
		DataSource dataSource = (DataSource) jndiObjFactoryBean.getObject();
		String sql = "SELECT authority FROM authorities WHERE username=?";
		PreparedStatement preparedSql = null;
		Connection conn = null;
		ArrayList<SimpleGrantedAuthority> authoList = null;
		try {
			conn = dataSource.getConnection();					
			preparedSql = conn.prepareStatement(sql);
			preparedSql.setString(1, username);
			ResultSet r = preparedSql.executeQuery();
			while(r.next()){
				authoList = new ArrayList<SimpleGrantedAuthority>();
				String autho = "ROLE_";
				autho += r.getString("authority");
				
				authoList.add(new SimpleGrantedAuthority(autho));
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
			logger.error("[loadUserAuthorities] " + e.getMessage());
			throw new AuthorityNotFoundException(username + "'s authorities not found.");
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
		return authoList;
		
	}

	@Override
	public void changePassword(String arg0, String arg1) {
		// TODO Auto-generated method stub
		
	}

	private void insertUserAuthorities(UserDetails userDetail) throws SQLException{
		logger.info("[insertUserAuthorities]");
		MMTCUser mmtcUser = (MMTCUser)userDetail;
		DataSource dataSource = (DataSource) jndiObjFactoryBean.getObject();
		String sql = "INSERT INTO authorities (authority,username) VALUES (?,?)";
		Connection conn = dataSource.getConnection();					
		PreparedStatement preparedSql = null;
		for(GrantedAuthority autho : mmtcUser.getAuthorities()){
			SimpleGrantedAuthority simpleAuth = (SimpleGrantedAuthority)autho;
			preparedSql = conn.prepareStatement(sql);
			preparedSql.setString(1, simpleAuth.getAuthority());
			preparedSql.addBatch();
			
		}
		if(preparedSql != null){
			conn.setAutoCommit(false);
			preparedSql.executeBatch();
			conn.setAutoCommit(true);
		}
		preparedSql.close();
		conn.close();
		dataSource.close(); 
	}
	
	public void createMMTCUser(MMTCUser newUser) throws SQLException{
		logger.info("[createMMTCUser]!");
		DataSource dataSource = (DataSource) jndiObjFactoryBean.getObject();
		String sql = "INSERT INTO users (username, password, email, emailpw, enabled) VALUES (?,?,?,?,?)";
		PreparedStatement preparedSql = null;
		Connection conn = null;		
		conn = dataSource.getConnection();					
		preparedSql = conn.prepareStatement(sql);
		preparedSql.setString(1, newUser.getUsername());
		preparedSql.setString(2, newUser.getPassword());
		preparedSql.setString(3, newUser.getEmail());
		preparedSql.setString(4, newUser.getEmailpw());
		preparedSql.setInt(5, 1);
		preparedSql.executeUpdate();
		preparedSql.close();
		conn.close();
		dataSource.close();
		logger.info("[createMMTCUser] New user: " + newUser.toString());		
		
	}
	@Override
	public void createUser(UserDetails userDetail) {
		logger.info("[createUser] DO NOT USE THIS FUNCTION. ABANDONED!!!");
	}

	@Override
	public void deleteUser(String username) {
		logger.info("[deleteUser]");
		DataSource dataSource = (DataSource) jndiObjFactoryBean.getObject();
		String sql = "DELETE FROM users WHERE username=?";
		PreparedStatement preparedSql = null;
		Connection conn = null;
		try {
			conn = dataSource.getConnection();					
			preparedSql = conn.prepareStatement(sql);
			preparedSql.setString(1, username);
			preparedSql.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			logger.error("[deleteUser] Deletion Failed: " + e.getMessage());
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
			dataSource.close();
		}			
	}

	@Override
	public void updateUser(UserDetails userDetail) {
		logger.info("[updateUser]");
		DataSource dataSource = (DataSource) jndiObjFactoryBean.getObject();
		String sql = "UPDATE users ";
		PreparedStatement preparedSql = null;
		Connection conn = null;
		MMTCUser mmtcUser = (MMTCUser)userDetail;
		String newUserName = mmtcUser.getUsername();
		String newEmail = mmtcUser.getEmail();
		String newEmailPW = mmtcUser.getEmailpw();
		if(newUserName != null && newUserName.length() > 0){
		 	sql += "SET username = ? ";
		}
		if(newEmail != null && newEmail.length() > 0
				&& newEmailPW != null && newEmailPW.length() > 0){
			sql += "SET email = ? ";
			sql += "SET emailpw = ? ";
		}
		Boolean isEnabled = Boolean.valueOf(mmtcUser.isEnabled());
		if(isEnabled != null){
			sql += "SET enabled=? ";
		}
		try {
			conn = dataSource.getConnection();					
			preparedSql = conn.prepareStatement(sql);
			if(newUserName != null && newUserName.length() > 0){
			 	preparedSql.setString(1, newUserName);
			}
			if(newEmail != null && newEmail.length() > 0
					&& newEmailPW != null && newEmailPW.length() > 0){
				preparedSql.setString(2, newEmail);
				preparedSql.setString(3, newEmailPW);
			}
			if(isEnabled != null){
				int e =  mmtcUser.isEnabled() == true ? 1:0;
				preparedSql.setInt(3,e);
			}
			preparedSql.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			logger.error("[updateUser] Update Failed: " + e.getMessage());
		} finally{
    		sql = null;
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
			dataSource.close();
		}					
	}

	@Override
	public boolean userExists(String username) {
		logger.info("[userExists]");
		boolean found = true;
		DataSource dataSource = (DataSource) jndiObjFactoryBean.getObject();
		String sql = "SELECT username FROM users WHERE username = ?";
		PreparedStatement preparedSql = null;
		Connection conn = null;
		try {
			conn = dataSource.getConnection();					
			preparedSql = conn.prepareStatement(sql);
			preparedSql.setString(1, username);
			ResultSet r = preparedSql.executeQuery();
			if(!r.next()){
				found = false;
			}
		} catch (SQLException e) {
			e.printStackTrace();
			logger.error("[userExists] Check Failed: " + e.getMessage());
			found = false;
		} finally{
    		sql = null;
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
			dataSource.close();
		}
		return found;
	}

}
