package com.mmtc.exam.dao;

public class TestSuite {
	private String name;

	public TestSuite(){
	}
	
	public TestSuite(String n){
		name = n;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
}
