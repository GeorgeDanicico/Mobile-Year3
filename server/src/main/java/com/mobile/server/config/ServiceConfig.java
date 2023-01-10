package com.mobile.server.config;

import com.mobile.server.service.ProductService;
import com.mobile.server.service.impl.ProductServiceImpl;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ServiceConfig {
    @Bean
    public ProductService productService() {
        return new ProductServiceImpl();
    }
}
