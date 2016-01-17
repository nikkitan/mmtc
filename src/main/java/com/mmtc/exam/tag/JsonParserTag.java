package com.mmtc.exam.tag;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.SimpleTagSupport;

public class JsonParserTag extends SimpleTagSupport {
	  public void doTag() throws JspException, IOException {
		  PageContext pageContext = (PageContext) getJspContext();
		  HttpServletRequest request = (HttpServletRequest)pageContext.getRequest();
	  }
}
