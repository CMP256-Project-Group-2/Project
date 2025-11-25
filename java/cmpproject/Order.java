package cmpproject;
import java.sql.Timestamp;

public class Order {
    private int id;
    private Timestamp date;
    private String status;
    private double total;

    public Order() {
    	this.id = 0;
    	this.date = null;
    	this.status = "";
    	this.total = 0.0;
    }
    
    public Order(int id, Timestamp date, String status, double total) {
        this.id = id;
        this.date = date;
        this.status = status;
        this.total = total;
    }
    
    public int getId() {
    	return id;
    }
    public Timestamp getDate() {
    	return date;
    }
    public String getStatus() {
    	return status;
    }
    public double getTotal() {
    	return total;
    }
}