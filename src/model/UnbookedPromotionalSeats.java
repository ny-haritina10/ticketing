package model;

import mg.jwe.orm.annotations.Column;
import mg.jwe.orm.annotations.ForeignKey;
import mg.jwe.orm.annotations.Id;
import mg.jwe.orm.annotations.Table;
import mg.jwe.orm.base.BaseModel;

@Table(name = "unbooked_promotional_seats")
public class UnbookedPromotionalSeats extends BaseModel {

    @Id
    @Column(name = "id")
    private Integer id;

    @ForeignKey(table = "flights", column = "id", lazy = false)
    private Flight flight;

    @Column(name = "category")
    private String category;

    @Column(name = "seats_count")
    private Integer seatsCount;

    @Column(name = "original_promotion_date")
    private java.sql.Date originalPromotionDate;

    @Column(name = "created_at")
    private java.sql.Timestamp createdAt;

    // Constructors
    public UnbookedPromotionalSeats() {}

    public UnbookedPromotionalSeats(Flight flight, String category, Integer seatsCount, java.sql.Date originalPromotionDate) {
        this.flight = flight;
        this.category = category;
        this.seatsCount = seatsCount;
        this.originalPromotionDate = originalPromotionDate;
    }

    // Getters and Setters
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Flight getFlight() {
        return flight;
    }

    public void setFlight(Flight flight) {
        this.flight = flight;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public Integer getSeatsCount() {
        return seatsCount;
    }

    public void setSeatsCount(Integer seatsCount) {
        this.seatsCount = seatsCount;
    }

    public java.sql.Date getOriginalPromotionDate() {
        return originalPromotionDate;
    }

    public void setOriginalPromotionDate(java.sql.Date originalPromotionDate) {
        this.originalPromotionDate = originalPromotionDate;
    }

    public java.sql.Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(java.sql.Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}