package com.mobile.server.service;

import com.mobile.server.model.Product;

import java.util.List;

public interface ProductService {
    Product addProduct(Product product);
    boolean deleteProduct(Long productId);
    Product editProduct(Product newProduct);
    List<Product> getProducts();
}
