package com.example.realestate.controller;

import com.example.realestate.model.Project;

public class ProjectResponse {
    private Long id;
    private Long landId;
    private String projectName;
    private String location;
    private double landSize;
    private double investmentRequired;
    private double expectedROI;
    private double expectedIRR;
    private String stage;
    private int progress;
    private String stateCategory;
    private String destination;

    private Double rentalYield;
    private Double projectedAnnualIncome;
    private Double capitalAppreciation;
    private Double averageOccupancy;
    private Double peakOccupancy;
    private String seasonalDemand;
    private Double adr;
    private Double monthlyCashFlow;
    private Double noi;

    public ProjectResponse() {
    }

    public static ProjectResponse from(Project project, int progress) {
        ProjectResponse r = new ProjectResponse();
        r.setId(project.getId());
        r.setLandId(project.getLandId());
        r.setProjectName(project.getProjectName());
        r.setLocation(project.getLocation());
        r.setLandSize(project.getLandSize());
        r.setInvestmentRequired(project.getInvestmentRequired());
        r.setExpectedROI(project.getExpectedROI());
        r.setExpectedIRR(project.getExpectedIRR());
        r.setStage(project.getStage() != null ? project.getStage().name() : null);
        r.setProgress(progress);
        r.setStateCategory(project.getStateCategory());
        r.setDestination(project.getDestination());
        r.setRentalYield(project.getRentalYield());
        r.setProjectedAnnualIncome(project.getProjectedAnnualIncome());
        r.setCapitalAppreciation(project.getCapitalAppreciation());
        r.setAverageOccupancy(project.getAverageOccupancy());
        r.setPeakOccupancy(project.getPeakOccupancy());
        r.setSeasonalDemand(project.getSeasonalDemand());
        r.setAdr(project.getAdr());
        r.setMonthlyCashFlow(project.getMonthlyCashFlow());
        r.setNoi(project.getNoi());
        return r;
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getLandId() { return landId; }
    public void setLandId(Long landId) { this.landId = landId; }
    public String getProjectName() { return projectName; }
    public void setProjectName(String projectName) { this.projectName = projectName; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public double getLandSize() { return landSize; }
    public void setLandSize(double landSize) { this.landSize = landSize; }
    public double getInvestmentRequired() { return investmentRequired; }
    public void setInvestmentRequired(double investmentRequired) { this.investmentRequired = investmentRequired; }
    public double getExpectedROI() { return expectedROI; }
    public void setExpectedROI(double expectedROI) { this.expectedROI = expectedROI; }
    public double getExpectedIRR() { return expectedIRR; }
    public void setExpectedIRR(double expectedIRR) { this.expectedIRR = expectedIRR; }
    public String getStage() { return stage; }
    public void setStage(String stage) { this.stage = stage; }
    public int getProgress() { return progress; }
    public void setProgress(int progress) { this.progress = progress; }
    public String getStateCategory() { return stateCategory; }
    public void setStateCategory(String stateCategory) { this.stateCategory = stateCategory; }
    public String getDestination() { return destination; }
    public void setDestination(String destination) { this.destination = destination; }
    public Double getRentalYield() { return rentalYield; }
    public void setRentalYield(Double rentalYield) { this.rentalYield = rentalYield; }
    public Double getProjectedAnnualIncome() { return projectedAnnualIncome; }
    public void setProjectedAnnualIncome(Double projectedAnnualIncome) { this.projectedAnnualIncome = projectedAnnualIncome; }
    public Double getCapitalAppreciation() { return capitalAppreciation; }
    public void setCapitalAppreciation(Double capitalAppreciation) { this.capitalAppreciation = capitalAppreciation; }
    public Double getAverageOccupancy() { return averageOccupancy; }
    public void setAverageOccupancy(Double averageOccupancy) { this.averageOccupancy = averageOccupancy; }
    public Double getPeakOccupancy() { return peakOccupancy; }
    public void setPeakOccupancy(Double peakOccupancy) { this.peakOccupancy = peakOccupancy; }
    public String getSeasonalDemand() { return seasonalDemand; }
    public void setSeasonalDemand(String seasonalDemand) { this.seasonalDemand = seasonalDemand; }
    public Double getAdr() { return adr; }
    public void setAdr(Double adr) { this.adr = adr; }
    public Double getMonthlyCashFlow() { return monthlyCashFlow; }
    public void setMonthlyCashFlow(Double monthlyCashFlow) { this.monthlyCashFlow = monthlyCashFlow; }
    public Double getNoi() { return noi; }
    public void setNoi(Double noi) { this.noi = noi; }
}
