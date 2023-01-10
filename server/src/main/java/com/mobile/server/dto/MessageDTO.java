package com.mobile.server.dto;

public class MessageDTO {
    private int status;
    private String message;
    private ProductDTO productDTO;

    public MessageDTO(int status, String message, ProductDTO productDTO) {
        this.status = status;
        this.message = message;
        this.productDTO = productDTO;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public ProductDTO getProductDTO() {
        return productDTO;
    }

    public void setProductDTO(ProductDTO productDTO) {
        this.productDTO = productDTO;
    }
}
