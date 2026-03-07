package com.example.realestate.model;

import jakarta.persistence.*;

@Entity
@Table(name = "lands")
public class Land {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String name;
    private String location;
    private Double size;
    private String zoning;
    private String stage;

    public Land() {}

    public Land(Long id, String name, String location, Double size, String zoning, String stage) {
        this.id = id;
        this.name = name;
        this.location = location;
        this.size = size;
        this.zoning = zoning;
        this.stage = stage;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public Double getSize() { return size; }
    public void setSize(Double size) { this.size = size; }

    public String getZoning() { return zoning; }
    public void setZoning(String zoning) { this.zoning = zoning; }

    public String getStage() { return stage; }
    public void setStage(String stage) { this.stage = stage; }
}
