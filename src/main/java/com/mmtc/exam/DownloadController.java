package com.mmtc.exam;

import java.util.ArrayList;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.tomcat.jdbc.pool.DataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jndi.JndiObjectFactoryBean;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.mmtc.exam.dao.Test;

@Controller
public class DownloadController {
	@Autowired
	private JndiObjectFactoryBean jndiObjFactoryBean;
	public DownloadController() {
		// TODO Auto-generated constructor stub
	}
	@RequestMapping(value = {"/downloads"}, method = RequestMethod.GET)
	public @ResponseBody ModelAndView downloads(Locale locale, Model model) {
		ModelAndView view = new ModelAndView();
		view.setViewName("downloads");
		return view;

	}
	
	@RequestMapping(value = {"/dlsuite"}, method = RequestMethod.GET)
	public @ResponseBody ModelAndView downloadSuite(
			Locale locale,
			Model model,
			HttpServletRequest request, 
			HttpServletResponse response) {
		Test t = new Test();
		ModelAndView view = new ModelAndView();
		view.setViewName("dlsuite");
		ArrayList<String> suites = getTestSuites();	
		v.addObject("suites", suites);
		return view;

	}
	
	@RequestMapping(value = {"/dls/{suite}"}, method = RequestMethod.GET)
	public @ResponseBody ModelAndView dls(
			Locale locale, 
			Model model,
			HttpSession session,
			HttpServletRequest request, 
			HttpServletResponse response,
			@PathVariable String suite) {
		DataSource dataSource = (DataSource) jndiObjFactoryBean.getObject();
 
		ModelAndView view = new ModelAndView();
		view.setViewName("dlsuite");
		return view;

	}
}
