package com.example.realestate.model;

import com.fasterxml.jackson.annotation.JsonAlias;
import jakarta.persistence.*;

@Entity
@Table(name = "projects")
public class Project {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "owner_id")
    private Long ownerId;

    @JsonAlias({"landId", "land_id"})
    @Column(name = "land_id")
    private Long landId;

    @JsonAlias({"projectName", "title"})
    @Column(name = "project_name", nullable = false)
    private String projectName;

    @Column(nullable = false)
    private String location;

    @JsonAlias({"landSize", "land_size"})
    @Column(name = "land_size", nullable = false)
    private double landSize = 0.0;

    @JsonAlias({"investmentRequired", "capitalRequired", "capital_required"})
    @Column(name = "investment_required", nullable = false)
    private double investmentRequired = 0.0;

    @JsonAlias({"expectedROI", "projectedGrowth", "expected_roi"})
    @Column(name = "expected_roi", nullable = false)
    private double expectedROI = 0.0;

    @JsonAlias({"expectedIRR", "irr", "expected_irr"})
    @Column(name = "expected_irr", nullable = false)
    private double expectedIRR = 0.0;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ProjectStage stage;

    // Tourism classification
    @Column(name = "state_category")
    private String stateCategory;

    private String destination;

    // Investment analytics (tourism real estate)
    @JsonAlias({"rentalYield", "rental_yield"})
    @Column(name = "rental_yield")
    private double rentalYield = 0.0;

    @JsonAlias({"occupancyRate", "occupancy_rate"})
    @Column(name = "occupancy_rate")
    private double occupancyRate = 0.0;

    @JsonAlias({"estimatedMonthlyIncome", "estimated_monthly_income"})
    @Column(name = "estimated_monthly_income")
    private Double estimatedMonthlyIncome;

    @JsonAlias({"projectedAnnualIncome", "projected_annual_income"})
    @Column(name = "projected_annual_income")
    private double projectedAnnualIncome = 0.0;

    @JsonAlias({"breakEvenYears", "break_even_years"})
    @Column(name = "break_even_years")
    private double breakEvenYears = 0.0;

    @JsonAlias({"capitalAppreciation5Year", "capital_appreciation_5y"})
    @Column(name = "capital_appreciation_5y")
    private double capitalAppreciation5Year = 0.0;

    @JsonAlias({"peakSeasonOccupancy", "peak_season_occupancy"})
    @Column(name = "peak_season_occupancy")
    private double peakSeasonOccupancy = 0.0;

    @JsonAlias({"seasonalDemand", "seasonal_demand"})
    @Column(name = "seasonal_demand")
    private String seasonalDemand = "MEDIUM";

    @JsonAlias({"averageDailyRate", "average_daily_rate", "adr"})
    @Column(name = "average_daily_rate")
    private double averageDailyRate = 0.0;

    @JsonAlias({"monthlyCashFlow", "monthly_cash_flow"})
    @Column(name = "monthly_cash_flow")
    private double monthlyCashFlow = 0.0;

    @JsonAlias({"netOperatingIncome", "net_operating_income", "noi"})
    @Column(name = "net_operating_income")
    private double netOperatingIncome = 0.0;

    // NEW ANALYTICS FIELDS
    private Double capitalAppreciation;
    private Double averageOccupancy;
    private Double peakOccupancy;
    private Double adr;
    private Double noi;

    public Project() {
    }

    @PrePersist
    public void ensureDefaultStage() {
        if (this.stage == null) this.stage = ProjectStage.LAND_APPROVED;
        if (this.seasonalDemand == null || this.seasonalDemand.isBlank()) {
            this.seasonalDemand = "MEDIUM";
        }
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(Long ownerId) {
        this.ownerId = ownerId;
    }

    public Long getLandId() {
        return landId;
    }

    public void setLandId(Long landId) {
        this.landId = landId;
    }

    public String getProjectName() {
        return projectName;
    }

    public void setProjectName(String projectName) {
        this.projectName = projectName;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public double getLandSize() {
        return landSize;
    }

    public void setLandSize(double landSize) {
        this.landSize = landSize;
    }

    public double getInvestmentRequired() {
        return investmentRequired;
    }

    public void setInvestmentRequired(double investmentRequired) {
        this.investmentRequired = investmentRequired;
    }

    public double getExpectedROI() {
        return expectedROI;
    }

    public void setExpectedROI(double expectedROI) {
        this.expectedROI = expectedROI;
    }

    public double getExpectedIRR() {
        return expectedIRR;
    }

    public void setExpectedIRR(double expectedIRR) {
        this.expectedIRR = expectedIRR;
    }

    public ProjectStage getStage() {
        return stage;
    }

    public void setStage(ProjectStage stage) {
        this.stage = stage;
    }

    public String getStateCategory() {
        return stateCategory;
    }

    public void setStateCategory(String stateCategory) {
        this.stateCategory = stateCategory;
    }

    public String getDestination() {
        return destination;
    }

    public void setDestination(String destination) {
        this.destination = destination;
    }

    public double getRentalYield() {
        return rentalYield;
    }

    public void setRentalYield(double rentalYield) {
        this.rentalYield = rentalYield;
    }

    public double getOccupancyRate() {
        return occupancyRate;
    }

    public void setOccupancyRate(double occupancyRate) {
        this.occupancyRate = occupancyRate;
    }

    public Double getEstimatedMonthlyIncome() {
        return estimatedMonthlyIncome;
    }

    public void setEstimatedMonthlyIncome(Double estimatedMonthlyIncome) {
        this.estimatedMonthlyIncome = estimatedMonthlyIncome;
    }

    public double getProjectedAnnualIncome() {
        return projectedAnnualIncome;
    }

    public void setProjectedAnnualIncome(double projectedAnnualIncome) {
        this.projectedAnnualIncome = projectedAnnualIncome;
    }

    public double getBreakEvenYears() {
        return breakEvenYears;
    }

    public void setBreakEvenYears(double breakEvenYears) {
        this.breakEvenYears = breakEvenYears;
    }

    public double getCapitalAppreciation5Year() {
        return capitalAppreciation5Year;
    }

    public void setCapitalAppreciation5Year(double capitalAppreciation5Year) {
        this.capitalAppreciation5Year = capitalAppreciation5Year;
    }

    public double getPeakSeasonOccupancy() {
        return peakSeasonOccupancy;
    }

    public void setPeakSeasonOccupancy(double peakSeasonOccupancy) {
        this.peakSeasonOccupancy = peakSeasonOccupancy;
    }

    public String getSeasonalDemand() {
        return seasonalDemand;
    }

    public void setSeasonalDemand(String seasonalDemand) {
        this.seasonalDemand = seasonalDemand;
    }

    public double getAverageDailyRate() {
        return averageDailyRate;
    }

    public void setAverageDailyRate(double averageDailyRate) {
        this.averageDailyRate = averageDailyRate;
    }

    public double getMonthlyCashFlow() {
        return monthlyCashFlow;
    }

    public void setMonthlyCashFlow(double monthlyCashFlow) {
        this.monthlyCashFlow = monthlyCashFlow;
    }

    public double getNetOperatingIncome() {
        return netOperatingIncome;
    }

    public void setNetOperatingIncome(double netOperatingIncome) {
        this.netOperatingIncome = netOperatingIncome;
    }

    public Double getCapitalAppreciation() {
        return capitalAppreciation;
    }

    public void setCapitalAppreciation(Double capitalAppreciation) {
        this.capitalAppreciation = capitalAppreciation;
    }

    public Double getAverageOccupancy() {
        return averageOccupancy;
    }

    public void setAverageOccupancy(Double averageOccupancy) {
        this.averageOccupancy = averageOccupancy;
    }

    public Double getPeakOccupancy() {
        return peakOccupancy;
    }

    public void setPeakOccupancy(Double peakOccupancy) {
        this.peakOccupancy = peakOccupancy;
    }

    public Double getAdr() {
        return adr;
    }

    public void setAdr(Double adr) {
        this.adr = adr;
    }

    public Double getNoi() {
        return noi;
    }

    public void setNoi(Double noi) {
        this.noi = noi;
    }
}
