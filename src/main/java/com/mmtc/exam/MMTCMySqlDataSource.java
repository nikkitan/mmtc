// Copyright (c) 2016 Mendez Master Training Center
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

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
