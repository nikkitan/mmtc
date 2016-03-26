// Copyright (c) 2016 Mendez Master Training Center
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.
package com.mmtc.exam.auth;

import org.springframework.security.core.AuthenticationException;

public class AuthorityNotFoundException extends AuthenticationException {

	public AuthorityNotFoundException(String msg, Throwable t) {
		super(msg, t);
		// TODO Auto-generated constructor stub
	}

	/**
	 * 
	 */
	private static final long serialVersionUID = -2333361515285433522L;

	public AuthorityNotFoundException(String msg) {
		super(msg);
		// TODO Auto-generated constructor stub
	}

}
