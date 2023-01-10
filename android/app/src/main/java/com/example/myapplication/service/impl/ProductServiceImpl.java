package com.example.myapplication.service.impl;

import com.example.myapplication.model.Product;
import com.example.myapplication.repository.Repository;
import com.example.myapplication.service.ProductService;

import java.util.List;

public class ProductServiceImpl implements ProductService {
    private Repository repository;

    public ProductServiceImpl() {
        this.repository = new Repository();
    }

    @Override
    public List<Product> getAllProducts() {
        return repository.getProductList();
    }

    @Override
    // Adds a product to the list
    // @param : product -> the product we want to add
    // @returns true if the product was added / false otherwise
    public Boolean addProduct(Product product) {
        List<Product> products = this.repository.getProductList();

        for (Product p : products) {
            if (p.getSerialNumber().equals(product.getSerialNumber()))
                return false;
        }

        this.repository.add(product);

        return true;
    }

    @Override
    // Deletes a product from the list
    // @param serialNumber: String -> the serial number of the product we want to delete
    // @returns true if the product was deleted / false otherwise
    public Boolean deleteProduct(String serialNumber) {
        List<Product> products = this.repository.getProductList();

        for (Product p : products) {
            if (p.getSerialNumber().equals(serialNumber)) {
                this.repository.delete(p);
                return true;
            }
        }

        return false;
    }

    @Override
    // Edits a product in the list
    // @param product: Product -> the new product
    // @returns true if the product was edited / false otherwise
    public Boolean editProduct(Product product) {
        List<Product> products = this.repository.getProductList();

        int pos = 0;
        for (Product p : products) {
            if (p.getSerialNumber().equals(product.getSerialNumber())) {
                this.repository.delete(p);
                this.repository.add(product, pos);
                return true;
            }


            pos ++;
        }


        return false;
    }
}
