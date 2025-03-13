package model;

import mg.jwe.orm.annotations.*;
import mg.jwe.orm.base.BaseModel;
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

    @Column(name = "reservation_time")
    private Timestamp reservationTime;

    @Column(name = "nbr_billet_total")
    private Integer nbrBilletTotal;

    @Column(name = "nbr_billet_enfant")
    private Integer nbrBilletEnfant;

    @Column(name = "nbr_billet_adulte")
    private Integer nbrBilletAdulte;

    // Getters and Setters
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

    public Timestamp getReservationTime() {
        return reservationTime;
    }

    public void setReservationTime(Timestamp reservationTime) {
        this.reservationTime = reservationTime;
    }

    public Integer getNbrBilletTotal() {
        return nbrBilletTotal;
    }

    public void setNbrBilletTotal(Integer nbrBilletTotal) {
        this.nbrBilletTotal = nbrBilletTotal;
    }

    public Integer getNbrBilletEnfant() {
        return nbrBilletEnfant;
    }

    public void setNbrBilletEnfant(Integer nbrBilletEnfant) {
        this.nbrBilletEnfant = nbrBilletEnfant;
    }

    public Integer getNbrBilletAdulte() {
        return nbrBilletAdulte;
    }

    public void setNbrBilletAdulte(Integer nbrBilletAdulte) {
        this.nbrBilletAdulte = nbrBilletAdulte;
    }
}