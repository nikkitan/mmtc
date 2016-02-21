package com.mmtc.exam;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jndi.JndiObjectFactoryBean;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class LoginController {
	@Autowired
	private JndiObjectFactoryBean jndiObjFactoryBean;		
	
	private static final Logger logger = LoggerFactory.getLogger(LoginController.class);
	
	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public ModelAndView login(
			HttpServletRequest request, 
			HttpServletResponse response) {
		logger.info("[login]! " + request.getRequestedSessionId());
		ModelAndView view = new ModelAndView();
		view.setViewName("login");
		return view;
	
	}
	
	@RequestMapping(value = "/logout", method = RequestMethod.GET)
	public ModelAndView logout(
			HttpServletRequest request, 
			HttpServletResponse response) {
		logger.info("[logout]! " + request.getRequestedSessionId());
		logger.info("[logout]! " + request.getSession().getId());
		request.getSession().invalidate();
		SecurityContextHolder.getContext().setAuthentication(null);
		ModelAndView view = new ModelAndView();
		view.setViewName("login");
		return view;
	}
	
	@RequestMapping(value = "/login", method = RequestMethod.POST)
	public ModelAndView loginPOST(Locale locale,
			Model model,
			@RequestParam(value = "error", required = false) String error,
			@RequestParam(value = "logout", required = false) String logout) {
		logger.info("[login_POST]!");
		ModelAndView resultModel = new ModelAndView();
		if (error != null) {
			resultModel.addObject("error", "Invalid username and password!");
		}

		if (logout != null) {
			resultModel.addObject("msg", "You've been logged out successfully.");
		}
		resultModel.setViewName("login");
		return resultModel;
	}
}
