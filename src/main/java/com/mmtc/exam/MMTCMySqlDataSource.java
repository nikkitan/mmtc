package com.mmtc.exam;

import org.springframework.jndi.JndiObjectFactoryBean;

public class MMTCMySqlDataSource extends JndiObjectFactoryBean {
	public MMTCMySqlDataSource(){
		super();
	}
	public void setJndiName(String jndiName){
		super.setJndiName(jndiName);
	}
}
