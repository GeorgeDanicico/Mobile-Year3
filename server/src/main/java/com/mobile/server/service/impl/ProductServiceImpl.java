package com.mobile.server.service.impl;

import com.mobile.server.model.Product;
import com.mobile.server.repository.ProductRepository;
import com.mobile.server.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

public class ProductServiceImpl implements ProductService {
    @Autowired
    private ProductRepository productRepository;

    @Override
    public Product addProduct(Product product) {
        Product p = productRepository.findBySerialNumber(product.getSerialNumber()).orElse(null);

        if (p != null) {
            throw new  RuntimeException("Invalid serial number!");
        }

        return productRepository.save(product);
    }

    @Override
    public boolean deleteProduct(Long productId) {

        Product product = productRepository.findById(productId).orElseThrow(() -> new RuntimeException("Invalid ID!"));

        productRepository.delete(product);

        return true;
    }

    @Override
    public Product editProduct(Product newProduct) {

        Product product = productRepository.findById(newProduct.getId()).orElseThrow(
                () -> new RuntimeException("Invalid new product!"));

        Product oldProduct = productRepository.findBySerialNumber(newProduct.getSerialNumber()).orElse(null);
        if (oldProduct != null && !oldProduct.getId().equals(newProduct.getId())) {
            throw new RuntimeException("Invalid serial number!");
        }

        return productRepository.save(newProduct);
    }

    @Override
    public List<Product> getProducts() {
        return productRepository.findAll();
    }
}
