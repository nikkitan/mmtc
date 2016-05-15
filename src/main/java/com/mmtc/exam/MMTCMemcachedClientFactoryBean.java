package com.mmtc.exam;

import java.net.InetSocketAddress;
import java.util.concurrent.TimeUnit;

import org.springframework.beans.factory.config.AbstractFactoryBean;
import static com.mmtc.exam.BuildConfig.DEBUG;
import net.spy.memcached.AddrUtil;
import net.spy.memcached.BinaryConnectionFactory;
import net.spy.memcached.ClientMode;
import net.spy.memcached.MemcachedClient;

public class MMTCMemcachedClientFactoryBean extends AbstractFactoryBean<MemcachedClient> {
	private String servers;
	private MemcachedClient mc;
	
	public MMTCMemcachedClientFactoryBean() {
	}

	@Override
	public Class<?> getObjectType() {
		return MemcachedClient.class;
	}

	@Override
	public boolean isSingleton() {
		return true;
	}
	
	
	public void setServers(final String s){
		this.servers = s;
	}

	@Override
	public void destroy() throws Exception {
		logger.debug("[destory]: Shutting down Memcached connection....");
		mc.shutdown(5000,TimeUnit.MILLISECONDS);
	}

	@Override
	protected MemcachedClient createInstance() throws Exception {
		logger.debug("[createInstance]: Memcached connecting....");
		if(DEBUG == false){
			mc = new MemcachedClient(new BinaryConnectionFactory(ClientMode.Dynamic),
					AddrUtil.getAddresses(servers));
		}else{
			mc = new MemcachedClient(new InetSocketAddress("localhost",11211));			
		}
		return mc;
	}

}
