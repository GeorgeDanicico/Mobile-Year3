package com.mobile.server.converter;

import com.mobile.server.dto.ProductDTO;
import com.mobile.server.model.Product;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

public class ProductConverter {
    public static Product convertDTOtoModel(ProductDTO productDTO) {
        return Product.builder()
                .id(productDTO.getId())
                .quantity(productDTO.getQuantity())
                .price(productDTO.getPrice())
                .aisle(productDTO.getAisle())
                .serialNumber(productDTO.getSerialNumber())
                .productName(productDTO.getProductName())
                .build();
    }

    public static ProductDTO convertModelToDTO(Product product) {
        return new ProductDTO(product.getId(), product.getSerialNumber(), product.getProductName(),
                product.getAisle(), product.getPrice(), product.getQuantity());
    }

    public static List<ProductDTO> convertModelsToDtos(List<Product> products) {
        return products.parallelStream()
                .map(ProductConverter::convertModelToDTO)
                .collect(Collectors.toList());
    }
}
