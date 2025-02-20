package model;

import mg.jwe.orm.annotations.*;
import mg.jwe.orm.base.BaseModel;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.sql.Timestamp;

@Table(name = "reservations")
public class Reservation extends BaseModel {

    @Id
    @Column(name = "id")
    private Integer id;

    @ForeignKey(table = "clients", column = "id", lazy = false)
    private Client client;

    @ForeignKey(table = "flights", column = "id", lazy = false)
    private Flight flight;

    @Column(name = "seat_category")
    private String seatCategory;

    @Column(name = "is_promotional")
    private Boolean isPromotional;

    @Column(name = "price_paid")
    private BigDecimal pricePaid;

    @Column(name = "reservation_time")
    private Timestamp reservationTime;

    @Column(name = "is_cancelled")
    private Boolean isCancelled;

    @Column(name = "cancellation_time")
    private Timestamp cancellationTime;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Client getClient() {
        return client;
    }

    public void setClient(Client client) {
        this.client = client;
    }

    public Flight getFlight() {
        return flight;
    }

    public void setFlight(Flight flight) {
        this.flight = flight;
    }

    public String getSeatCategory() {
        return seatCategory;
    }

    public void setSeatCategory(String seatCategory) {
        this.seatCategory = seatCategory;
    }

    public Boolean getIsPromotional() {
        return isPromotional;
    }

    public void setIsPromotional(Boolean isPromotional) {
        this.isPromotional = isPromotional;
    }

    public BigDecimal getPricePaid() {
        return pricePaid;
    }

    public void setPricePaid(BigDecimal pricePaid) {
        this.pricePaid = pricePaid;
    }

    public Timestamp getReservationTime() {
        return reservationTime;
    }

    public void setReservationTime(Timestamp reservationTime) {
        this.reservationTime = reservationTime;
    }

    public Boolean getIsCancelled() {
        return isCancelled;
    }

    public void setIsCancelled(Boolean isCancelled) {
        this.isCancelled = isCancelled;
    }

    public Timestamp getCancellationTime() {
        return cancellationTime;
    }

    public void setCancellationTime(Timestamp cancellationTime) {
        this.cancellationTime = cancellationTime;
    }    
}