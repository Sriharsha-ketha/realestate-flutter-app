package com.example.realestate.model;

import jakarta.persistence.*;

@Entity
@Table(name = "projects")
public class Project {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String title;
    private String location;
    private Double irr;
    private Double capitalRequired;
    private Double capitalRaised;
    private String stage;
    private String imageUrl;

    public Project() {}

    public Project(Long id, String title, String location, Double irr, Double capitalRequired, Double capitalRaised, String stage, String imageUrl) {
        this.id = id;
        this.title = title;
        this.location = location;
        this.irr = irr;
        this.capitalRequired = capitalRequired;
        this.capitalRaised = capitalRaised;
        this.stage = stage;
        this.imageUrl = imageUrl;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

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
}
