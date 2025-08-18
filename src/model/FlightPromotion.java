package model;

import java.math.BigDecimal;

import mg.jwe.orm.annotations.Column;
import mg.jwe.orm.annotations.ForeignKey;
import mg.jwe.orm.annotations.Id;
import mg.jwe.orm.annotations.Table;
import mg.jwe.orm.base.BaseModel;

@Table(name = "flight_promotions")
public class FlightPromotion extends BaseModel {

    @Id
    @Column(name = "id")
    private Integer id;

    @ForeignKey(table = "flights", column = "id", lazy = false)
    private Flight flight;

    @Column(name = "category")
    private String category;

    @Column(name = "discount_percentage")
    private BigDecimal discountPercentage;

    @Column(name = "seats_available")
    private Integer seatsAvailable;

    @Column(name = "date_promotion")
    private java.sql.Date datePromotion;

    public java.sql.Date getDatePromotion() {
        return datePromotion;
    }

    public void setDatePromotion(java.sql.Date datePromotion) {
        this.datePromotion = datePromotion;
    }


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

    public BigDecimal getDiscountPercentage() {
        return discountPercentage;
    }

    public void setDiscountPercentage(BigDecimal discountPercentage) {
        this.discountPercentage = discountPercentage;
    }

    public Integer getSeatsAvailable() {
        return seatsAvailable;
    }

    public void setSeatsAvailable(Integer seatsAvailable) {
        this.seatsAvailable = seatsAvailable;
    }
}