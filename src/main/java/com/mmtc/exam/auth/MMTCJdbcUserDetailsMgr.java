package com.mmtc.exam.auth;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

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
import org.springframework.security.provisioning.JdbcUserDetailsManager;
import org.springframework.web.servlet.ModelAndView;

import com.mmtc.exam.HomeController;
import com.mmtc.exam.dao.MMTCUser;

public class MMTCJdbcUserDetailsMgr implements UserDetailsService {
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
			String username = r.getString("username");
			String password = r.getString("password");
			Boolean enabled = r.getBoolean("enabled");
			ArrayList<SimpleGrantedAuthority> authoList = loadUserAuthorities(username);
			user = new MMTCUser(username, password,enabled,true,true,true,authoList);
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
		return null;
	}
	
	public ArrayList<SimpleGrantedAuthority> loadUserAuthorities(String username) throws AuthorityNotFoundException {
		DataSource dataSource = (DataSource) jndiObjFactoryBean.getObject();
		String sql = "SELECT authority FROM authorities WHERE username=?";
		PreparedStatement preparedSql = null;
		Connection conn = null;
		ArrayList<SimpleGrantedAuthority> authoList = new ArrayList<SimpleGrantedAuthority>();
		try {
			conn = dataSource.getConnection();					
			preparedSql = conn.prepareStatement(sql);
			preparedSql.setString(1, username);
			ResultSet r = preparedSql.executeQuery();
			String autho = r.getString("authority");
			authoList.add(new SimpleGrantedAuthority(autho));
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
		return null;
		
	}

}
