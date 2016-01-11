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

	public String getOptions() {
		return options;
	}

	public void setOptions(String options) {
		this.options = options;
	}

	public String getAnswer() {
		return answer;
	}

	public void setAnswer(String answer) {
		this.answer = answer;
	}

	public String getKeywords() {
		return keywords;
	}

	public void setKeywords(String keywords) {
		this.keywords = keywords;
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

	public JsonArray getAnsJsonArr() {
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

	public ArrayList<String> getAnsArrayList() {
		return ansArrayList;
	}

	public void setAnsArrayList(ArrayList<String> ansArrayList) {
		this.ansArrayList = ansArrayList;
	}

	public ArrayList<String> getOptArrayList() {
		return optArrayList;
	}

	public void setOptArrayList(ArrayList<String> optArrayList) {
		this.optArrayList = optArrayList;
	}

	public JsonArray getKwdJsonArr() {
		return kwdJsonArr;
	}

	public void setKwdJsonArr(JsonArray kwdJsonArr) {
		this.kwdJsonArr = kwdJsonArr;
	}

	public ArrayList<String> getKwdArrayList() {
		return kwdArrayList;
	}

	public void setKwdArrayList(ArrayList<String> kwdArrayList) {
		this.kwdArrayList = kwdArrayList;
	}

	private JsonArray ansJsonArr;
	private JsonArray optJsonArr;
	private ArrayList<String> ansArrayList;
	private ArrayList<String> optArrayList;
	private JsonArray kwdJsonArr;
	private ArrayList<String> kwdArrayList;
	private String suite;
	private String question;
	private Integer serialNo;
	private String options;//Stringified JSON array.
	private String answer;//Stringified JSON array.
	private String keywords;//Stringified JSON array.
	private String pic;//picture file name.
	private String id;//AES encryption for publicly usage in web pages.
	private long lastUpdateTimestamp;
}
