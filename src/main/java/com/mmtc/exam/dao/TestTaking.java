package com.mmtc.exam.dao;

import com.google.gson.JsonArray;

//Representing data of each test-taking by different student.
public class TestTaking {
	public TestTaking(){
		stuAns = null;
	}
	
	public String getStuAns() {
		return stuAns;
	}

	public void setStuAns(String stuAns) {
		this.stuAns = stuAns;
	}

	public String getSerial() {
		return serial;
	}

	public void setSerial(String serial) {
		this.serial = serial;
	}

	public JsonArray getOptions() {
		return options;
	}

	public void setOptions(JsonArray options) {
		this.options = options;
	}

	private String stuAns;//Student answer.
	private String serial;//Result of randomization to test order.
	private JsonArray options;//Randomization to option order.
}
