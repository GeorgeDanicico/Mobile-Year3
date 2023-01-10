package com.mobile.server.controller;

import com.mobile.server.converter.ProductConverter;
import com.mobile.server.dto.MessageDTO;
import com.mobile.server.dto.ProductDTO;
import com.mobile.server.model.Product;
import com.mobile.server.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api")
public class Controller {
    @Autowired
    private ProductService productService;

    @GetMapping("/all")
    public ResponseEntity<?> getProducts() {

        List<Product> products = productService.getProducts();
        List<ProductDTO> productsDto = ProductConverter.convertModelsToDtos(products);

        if (productsDto == null) {
            return new ResponseEntity("An error has occurred", HttpStatus.BAD_REQUEST);
        }

        return new ResponseEntity(productsDto, HttpStatus.ACCEPTED);
    }

    @PostMapping("/add")
    public ResponseEntity<?> addProduct(@RequestBody ProductDTO productDTO) {
        Product product = null;

        try {
            product = productService.addProduct(ProductConverter.convertDTOtoModel(productDTO));
        } catch (RuntimeException e) {
            return new ResponseEntity(new MessageDTO(404, e.getMessage(), null), HttpStatus.BAD_REQUEST);
        }

        if (product == null) {
            return new ResponseEntity(new MessageDTO(404, "An error has occured", null), HttpStatus.BAD_REQUEST);
        }

        return new ResponseEntity(
                new MessageDTO(201, "Product added successfully", ProductConverter.convertModelToDTO(product)), HttpStatus.ACCEPTED);
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<?> deleteProduct(@PathVariable Long id) {

        try {
            productService.deleteProduct(id);
        } catch (RuntimeException e) {
            return new ResponseEntity(new MessageDTO(404, e.getMessage(), null), HttpStatus.BAD_REQUEST);
        }

        return new ResponseEntity(
                new MessageDTO(200, "Product deleted successfully", null), HttpStatus.ACCEPTED);
    }

    @PutMapping("/edit")
    public ResponseEntity<?> editProduct(@RequestBody ProductDTO productDTO) {
        Product product = null;

        try {
            product = productService.editProduct(ProductConverter.convertDTOtoModel(productDTO));
        } catch (RuntimeException e) {
            return new ResponseEntity(new MessageDTO(404, e.getMessage(), null), HttpStatus.BAD_REQUEST);

        }

        if (product == null) {
            return new ResponseEntity(new MessageDTO(404, "An error has occured", null), HttpStatus.BAD_REQUEST);
        }

        return new ResponseEntity(
                new MessageDTO(201, "Product edited successfully", ProductConverter.convertModelToDTO(product)), HttpStatus.ACCEPTED);
    }
}
