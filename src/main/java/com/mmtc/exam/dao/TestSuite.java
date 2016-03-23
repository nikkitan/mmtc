// Copyright (c) 2016 Mendez Master Training Center
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

package com.mmtc.exam.dao;

public class TestSuite {
	private String name;
	private Boolean isQuestionRandom;
	private Boolean isChoiceRandom;

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

	public Boolean getIsQuestionRandom() {
		return isQuestionRandom;
	}

	public void setIsQuestionRandom(Boolean isQuestionRandom) {
		this.isQuestionRandom = isQuestionRandom;
	}

	public Boolean getIsChoiceRandom() {
		return isChoiceRandom;
	}

	public void setIsChoiceRandom(Boolean isChoiceRandom) {
		this.isChoiceRandom = isChoiceRandom;
	}
}
