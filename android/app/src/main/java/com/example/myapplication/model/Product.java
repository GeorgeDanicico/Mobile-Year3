package com.example.myapplication.model;

import java.io.Serializable;

public class Product implements Serializable {
    private static int id = 0;
    synchronized int getNextFreeId() {
        return id++;
    }

    private String productName;
    private String serialNumber;
    private Integer quantity;
    private Double price;
    private String aisle;


    public Product(String productName, String serialNumber, Integer quantity, Double price, String aisle) {
        this.productName = productName;
        this.serialNumber = serialNumber;
        this.quantity = quantity;
        this.price = price;
        this.aisle = aisle;
        this.id = getNextFreeId();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getSerialNumber() {
        return serialNumber;
    }

    public void setSerialNumber(String serialNumber) {
        this.serialNumber = serialNumber;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public String getAisle() {
        return aisle;
    }

    public void setAisle(String aisle) {
        this.aisle = aisle;
    }

    @Override
    public String toString() {
        return "Quantity: " + quantity + " | Price: " + price + " Aisle: " + aisle;
    }
}
