package com.example.realestate.model;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "projects")
public class Project {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String title;
    private String location;
    private String theme; // New: e.g., "Eco-Luxury", "Wellness", "Beachfront"
    private String description;
    private Double irr;
    private Double capitalRequired;
    private Double capitalRaised;
    private String stage;
    private String imageUrl;
    
    // Analytics fields
    private Double projectedGrowth; // e.g., 12.5%
    private Integer demandIndex; // 1-10
    private String riskProfile; // Low, Medium, High

    public Project() {}

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public String getTheme() { return theme; }
    public void setTheme(String theme) { this.theme = theme; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public Double getIrr() { return irr; }
    public void setIrr(Double irr) { this.irr = irr; }
    public Double getCapitalRequired() { return capitalRequired; }
    public void setCapitalRequired(Double capitalRequired) { this.capitalRequired = capitalRequired; }
    public Double getCapitalRaised() { return capitalRaised; }
    public void setCapitalRaised(Double capitalRaised) { this.capitalRaised = capitalRaised; }
    public String getStage() { return stage; }
    public void setStage(String stage) { this.stage = stage; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public Double getProjectedGrowth() { return projectedGrowth; }
    public void setProjectedGrowth(Double projectedGrowth) { this.projectedGrowth = projectedGrowth; }
    public Integer getDemandIndex() { return demandIndex; }
    public void setDemandIndex(Integer demandIndex) { this.demandIndex = demandIndex; }
    public String getRiskProfile() { return riskProfile; }
    public void setRiskProfile(String riskProfile) { this.riskProfile = riskProfile; }
}
