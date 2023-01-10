package com.example.myapplication.service;

import com.example.myapplication.model.Product;

import java.util.List;

public interface ProductService {
    List<Product> getAllProducts();
    Boolean addProduct(Product product);
    Boolean deleteProduct(String serialNumber);
    Boolean editProduct(Product product);
}
