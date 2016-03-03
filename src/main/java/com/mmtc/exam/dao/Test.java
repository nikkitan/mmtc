package com.mmtc.exam.dao;

import java.util.ArrayList;

import com.google.gson.JsonArray;

public class Test {
	public Test(){}
	
	public JsonArray getQuestion() {
		return question;
	}
	public void setQuestion(JsonArray question) {
		this.question = question;
	}

	public Integer getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(Integer serialNo) {
		this.serialNo = serialNo;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public long getLastUpdateTimestamp() {
		return lastUpdateTimestamp;
	}

	public void setLastUpdateTimestamp(long lastUpdateTimestamp) {
		this.lastUpdateTimestamp = lastUpdateTimestamp;
	}

	public String getPic() {
		return pic;
	}

	public void setPic(String pic) {
		this.pic = pic;
	}

	public String getSuite() {
		return suite;
	}

	public void setSuite(String suite) {
		this.suite = suite;
	}

	/*public JsonArray getAnsJsonArr() {
		return ansJsonArr;
	}

	public void setAnsJsonArr(JsonArray ansJsonArr) {
		this.ansJsonArr = ansJsonArr;
	}

	public JsonArray getOptJsonArr() {
		return optJsonArr;
	}

	public void setOptJsonArr(JsonArray optJsonArr) {
		this.optJsonArr = optJsonArr;
	}
	
	public JsonArray getKwdJsonArr() {
		return kwdJsonArr;
	}

	public void setKwdJsonArr(JsonArray kwdJsonArr) {
		this.kwdJsonArr = kwdJsonArr;
	}
	*/

	public JsonArray getAnswers() {
		return answers;
	}

	public void setAnswers(JsonArray ansArrayList) {
		this.answers = ansArrayList;
	}

	public JsonArray getOptions() {
		return options;
	}

	public void setOptions(JsonArray optArrayList) {
		this.options = optArrayList;
	}

	public JsonArray getKeywords() {
		return kwds;
	}

	public void setKeywords(JsonArray kwdArrayList) {
		this.kwds = kwdArrayList;
	}
	
	public JsonArray getWatchword() {
		return watchword;
	}

	public void setWatchword(JsonArray watchword) {
		this.watchword = watchword;
	}

	public JsonArray getTips() {
		return tips;
	}

	public void setTips(JsonArray tips) {
		this.tips = tips;
	}

	private JsonArray tips;
	private JsonArray watchword;
	private JsonArray question;
	private JsonArray answers;
	private JsonArray options;
	//private ArrayList<String> answers;
	//private ArrayList<String> options;
	private JsonArray kwds;
	//private ArrayList<String> kwds;
	private String suite;
	private Integer serialNo;
	private String pic;//picture file name.
	private String id;//AES encryption for publicly usage in web pages.
	private long lastUpdateTimestamp;
}
