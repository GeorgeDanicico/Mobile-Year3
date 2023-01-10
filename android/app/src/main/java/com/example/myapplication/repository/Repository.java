package com.example.myapplication.repository;

import com.example.myapplication.model.Product;

import java.util.ArrayList;
import java.util.List;

public class Repository {
    private List<Product> productList;

    public Repository() {
        this.productList = new ArrayList<>();
        this.productList.add(new Product("iPhone XS", "123411xs", 2, 1000.99, "Tech"));
        this.productList.add(new Product("iPhone 14", "1258547s", 2, 1400.99, "Tech"));
        this.productList.add(new Product("MacBook Pro 14", "1234393i2o", 2, 2100.99, "Tech"));
        this.productList.add(new Product("Desktop I7 32 Gb ram", "1854191023", 2, 3000.99, "Tech"));

    }

    public void add(Product product) {
        this.productList.add(product);
    }

    public void add(Product product, Integer position) {
        this.productList.add(position, product);
    }

    public void delete(Product product) {
        this.productList.remove(product);
    }

    public void edit(Product product) {
        this.productList.add(product);
    }

    public Product getProductBySerialNumber(String serialNumber) {
        for (Product product : productList) {
            if (product.getSerialNumber().equals(serialNumber)) {
                return product;
            }
        }

        return null;
    }

    public List<Product> getProductList() {
        return productList;
    }

    public void setProductList(List<Product> productList) {
        this.productList = productList;
    }
}
