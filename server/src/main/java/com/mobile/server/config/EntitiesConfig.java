package com.mobile.server.config;

import com.mobile.server.model.JPAEntitiesPackageIndicator;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@EntityScan(basePackageClasses = { JPAEntitiesPackageIndicator.class })
@EnableJpaRepositories(basePackages = "com.mobile.server.repository")
public class EntitiesConfig {
}