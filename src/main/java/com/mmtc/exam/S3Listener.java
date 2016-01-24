package com.mmtc.exam;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.event.ContextClosedEvent;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.context.event.ContextStartedEvent;
import org.springframework.context.event.ContextStoppedEvent;
import org.springframework.context.event.EventListener;
import org.springframework.jndi.JndiObjectFactoryBean;
import org.springframework.stereotype.Component;

@Component
public class S3Listener {
	@Autowired
	private JndiObjectFactoryBean jndiObjFactoryBean;		
	
	private static final Logger logger = LoggerFactory.getLogger(S3Listener.class);
	
    @EventListener
    public void handleContextStarted(ContextStartedEvent event) {
    	logger.info("[S3]: Conext Started!");
    }
    
    @EventListener
    public void handleContextRefresh(ContextRefreshedEvent event) {
    	logger.info("[S3]: Conext Refreshed!");
    }
    
    @EventListener
    public void handleContextStopped(ContextStoppedEvent event) {
    	logger.info("[S3]: Conext Stopped!");
    }
    
    @EventListener
    public void handleContextClosed(ContextClosedEvent event) {
    	logger.info("[S3]: Conext Closed!");
    }
}
