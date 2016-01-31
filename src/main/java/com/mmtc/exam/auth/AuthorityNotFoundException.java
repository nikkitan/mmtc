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
