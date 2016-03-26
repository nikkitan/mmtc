// Copyright (c) 2016 Mendez Master Training Center
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

package com.mmtc.exam;

import java.io.File;
import java.util.concurrent.Future;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.AsyncResult;
import org.springframework.stereotype.Service;

import com.amazonaws.auth.InstanceProfileCredentialsProvider;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectResult;

@Service
public class S3Service {
	private static final Logger logger = LoggerFactory.getLogger(S3Service.class);
	public S3Service(){
		
	}
	
	
	@Async
	public Future<PutObjectResult> upload(File file){
		logger.info("[S3Service] upload()!");
		AmazonS3 s3Client = new AmazonS3Client(new InstanceProfileCredentialsProvider());
		ObjectMetadata metadata = new ObjectMetadata();
		metadata.setContentType("image/png");
		PutObjectResult pr = s3Client.putObject("mmtctestpic",file.getName(),file);
		return new AsyncResult<PutObjectResult>(pr);	
	}
}
