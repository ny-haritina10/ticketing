package model;

import mg.jwe.orm.annotations.*;
import mg.jwe.orm.base.BaseModel;

@Table(name = "flight_reservation")
public class FlightReservation extends BaseModel {

    @Id
    @Column(name = "id")
    private Integer id;

    @ForeignKey(table = "flights", column = "id", lazy = false)
    private Flight flight;

    @Column(name = "reservation_hour_allowed")
    private Integer reservationHourAllowed;

    @Column(name = "annulation_hour_allowed")
    private Integer annulationHourAllowed;

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

    public Integer getReservationHourAllowed() {
        return reservationHourAllowed;
    }

    public void setReservationHourAllowed(Integer reservationHourAllowed) {
        this.reservationHourAllowed = reservationHourAllowed;
    }

    public Integer getAnnulationHourAllowed() {
        return annulationHourAllowed;
    }

    public void setAnnulationHourAllowed(Integer annulationHourAllowed) {
        this.annulationHourAllowed = annulationHourAllowed;
    }
}