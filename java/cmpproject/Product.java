package cmpproject;

public class Product {
	private int id;
    private String title;
    private String image;
    private double price;
    
    public Product() {
    	this.id = 0;
    	this.title = "";
    	this.image = "";
    	this.price = 0.0;
    }
    
    public Product(int _id, String t, String img, Double p) {
    	this.id = _id;
    	this.title = t;
    	this.image = img;
    	this.price = p;
    }
    
    public int getId() {
    	return id;
    }
    public String getTitle() {
    	return title;
    }
    public String getImage() {
    	return image;
    }
    public double getPrice() {
    	return price;
    }
    
    public void setId(int _id) {
    	this.id = _id;
    }
    public void setTitle(String t) {
    	this.title = t;
    }
    public void setImage(String i) {
    	this.image = i;
    }
    public void setPrice(Double p) {
    	this.price = p;
    }
}
