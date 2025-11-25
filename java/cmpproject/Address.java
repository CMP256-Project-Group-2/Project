package cmpproject;

public class Address {
	private int id;
    private String fullName;
    private String phone;
    private String addressLine;
    private String city;
    private String state;
    private String zip;
    
    public Address() {
    	this.id = 0;
    	this.fullName = "";
    	this.phone = "";
    	this.addressLine = "";
    	this.city = "";
    	this.state = "";
    	this.zip = "";
    }
    
    public Address(int i, String fn, String num, String ad, String c, String s, String z) {
    	this.id = i;
    	this.fullName = fn;
    	this.phone = num;
    	this.addressLine = ad;
    	this.city = c;
    	this.state = s;
    	this.zip = z;
    }
    
    public int getId() {
    	return id; 
    }
    public String getFullName() {
    	return fullName;
    }
    public String getPhone() {
    	return phone;
    }
    public String getAddressLine() {
    	return addressLine;
    }
    public String getCity() {
    	return city;
    }
    public String getState() {
    	return state;
    }
    public String getZip() {
    	return zip;
    }
    
    //setters aren't being used but they are here anyways.
    
    public void setId(int i) {
    	this.id = i;
    }
    public void setFullName(String fn) {
    	this.fullName = fn;
    }
    public void setPhone(String p) {
    	this.phone = p;
    }
    public void setAddressLine(String a) {
    	this.addressLine = a;
    }
    public void setCity(String c) {
    	this.city = c;
    }
    public void setState(String s) {
    	this.state = s;
    }
    public void setZip(String z) {
    	this.zip = z;
    }
}
