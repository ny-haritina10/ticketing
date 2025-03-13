package model;

import mg.jwe.orm.annotations.*;
import mg.jwe.orm.base.BaseModel;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

@Table(name = "reservations_details")
public class ReservationDetail extends BaseModel {

    @Id
    @Column(name = "id")
    private Integer id;

    @ForeignKey(table = "reservations", column = "id", lazy = false)
    private Reservation reservation;

    @Column(name = "seat_category")
    private String seatCategory;

    @Column(name = "name_voyageur")
    private String nameVoyageur;

    @Column(name = "dtn_voyageur")
    private Date dtnVoyageur;

    @Column(name = "passport_image")
    private String passportImage;

    @Column(name = "price")
    private BigDecimal price;

    @Column(name = "is_promotional")
    private Boolean isPromotional;

    @Column(name = "is_cancel")
    private Boolean isCancel;

    @Column(name = "cancellation_time")
    private Timestamp cancellationTime;

    // Getters and Setters
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Reservation getReservation() {
        return reservation;
    }

    public void setReservation(Reservation reservation) {
        this.reservation = reservation;
    }

    public String getSeatCategory() {
        return seatCategory;
    }

    public void setSeatCategory(String seatCategory) {
        this.seatCategory = seatCategory;
    }

    public String getNameVoyageur() {
        return nameVoyageur;
    }

    public void setNameVoyageur(String nameVoyageur) {
        this.nameVoyageur = nameVoyageur;
    }

    public Date getDtnVoyageur() {
        return dtnVoyageur;
    }

    public void setDtnVoyageur(Date dtnVoyageur) {
        this.dtnVoyageur = dtnVoyageur;
    }

    public String getPassportImage() {
        return passportImage;
    }

    public void setPassportImage(String passportImage) {
        this.passportImage = passportImage;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public Boolean getIsPromotional() {
        return isPromotional;
    }

    public void setIsPromotional(Boolean isPromotional) {
        this.isPromotional = isPromotional;
    }

    public Boolean getIsCancel() {
        return isCancel;
    }

    public void setIsCancel(Boolean isCancel) {
        this.isCancel = isCancel;
    }

    public Timestamp getCancellationTime() {
        return cancellationTime;
    }

    public void setCancellationTime(Timestamp cancellationTime) {
        this.cancellationTime = cancellationTime;
    }
}