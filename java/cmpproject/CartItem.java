package cmpproject;

public class CartItem {
    private int id;
    private String title;
    private String image;
    private double price;
    private int quantity;
    private String size;

    public CartItem(int id, String title, String image, double price, int quantity, String size) {
        this.id = id;
        this.title = title;
        this.image = image;
        this.price = price;
        this.quantity = quantity;
        this.size = size;
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
    public int getQuantity() {
    	return quantity;
    }
    public String getSize() {
    	return size;
    }
    
    public double getTotal() {
    	if (price * quantity < 0) {
    		return 0.0;
    	}
    	else {
    		return price * quantity; 
    	}
    }
}