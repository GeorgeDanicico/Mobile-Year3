package com.mobile.server.model;

import jakarta.persistence.*;
import lombok.*;

import java.io.Serializable;

@Entity(name = "Product")
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Table(name = "product")
public class Product implements Serializable {
    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "serial_number", unique = true)
    private String serialNumber;

    @Column(name = "product_name")
    private String productName;

    @Column(name = "aisle")
    private String aisle;

    @Column(name = "price")
    private Double price;

    @Column(name = "quantity")
    private Integer quantity;

    @Override
    public String toString() {
        return this.getSerialNumber() + ", " + this.getProductName() + ", "
                + this.getAisle() + ", " + this.getPrice() + ", " + this.getQuantity();
    }
}