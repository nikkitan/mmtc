package com.mmtc.exam.dao;

import java.util.ArrayList;

import com.google.gson.JsonArray;

public class Test {
	public Test(){}
	
	public String getQuestion() {
		return question;
	}
	public void setQuestion(String question) {
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

	public ArrayList<String> getAnswers() {
		return answers;
	}

	public void setAnswers(ArrayList<String> ansArrayList) {
		this.answers = ansArrayList;
	}

	public ArrayList<String> getOptions() {
		return options;
	}

	public void setOptions(ArrayList<String> optArrayList) {
		this.options = optArrayList;
	}

	public ArrayList<String> getKeywords() {
		return kwds;
	}

	public void setKeywords(ArrayList<String> kwdArrayList) {
		this.kwds = kwdArrayList;
	}

	//private JsonArray ansJsonArr;
	//private JsonArray optJsonArr;
	private ArrayList<String> answers;
	private ArrayList<String> options;
	//private JsonArray kwdJsonArr;
	private ArrayList<String> kwds;
	private String suite;
	private String question;
	private Integer serialNo;
	private String pic;//picture file name.
	private String id;//AES encryption for publicly usage in web pages.
	private long lastUpdateTimestamp;
}
