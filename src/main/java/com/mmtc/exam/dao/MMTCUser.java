package com.mmtc.exam.dao;

public class MMTCUser {
	
	public MMTCUser(){}
	
	private String username;
	private String password;
	private String email;
	private String emailpw;
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getEmailpw() {
		return emailpw;
	}
	public void setEmailpw(String emailpw) {
		this.emailpw = emailpw;
	}
}
