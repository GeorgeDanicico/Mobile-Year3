package com.mobile.server.dto;

import java.io.Serializable;

public class ProductDTO implements Serializable {
    private Long id;
    private String serialNumber;
    private String productName;
    private String aisle;
    private Double price;
    private int quantity;

    public ProductDTO(Long id, String serialNumber, String productName, String aisle, Double price, int quantity) {
        this.id = id;
        this.serialNumber = serialNumber;
        this.productName = productName;
        this.aisle = aisle;
        this.price = price;
        this.quantity = quantity;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getSerialNumber() {
        return serialNumber;
    }

    public void setSerialNumber(String serialNumber) {
        this.serialNumber = serialNumber;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getAisle() {
        return aisle;
    }

    public void setAisle(String aisle) {
        this.aisle = aisle;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}
