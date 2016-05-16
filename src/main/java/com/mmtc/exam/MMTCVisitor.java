package com.mmtc.exam;

public class MMTCVisitor {

	public MMTCVisitor() {
		// TODO Auto-generated constructor stub
	}
	
	public String getFirstName() {
		return firstName;
	}
	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}

	public String getWebLead() {
		return webLead;
	}

	public void setWebLead(String webLead) {
		this.webLead = webLead;
	}

	public Boolean getIsAltWebLead() {
		return isAltWebLead;
	}

	public void setIsAltWebLead(Boolean alternativeWebLead) {
		this.isAltWebLead = alternativeWebLead;
	}

	public String getAltWebLead() {
		return altWebLead;
	}

	public void setAltWebLead(String altWebLead) {
		this.altWebLead = altWebLead;
	}

	private String firstName;
	private String lastName;
	private String email;
	private String msg;
	private String webLead;
	private Boolean isAltWebLead;
	private String altWebLead;

}
