package model;

import mg.jwe.orm.annotations.*;
import mg.jwe.orm.base.BaseModel;
import validation.NotNull;
import validation.Valid;

import java.sql.Timestamp;

@Table(name = "flights")
@Valid
public class Flight extends BaseModel {

    @Id
    @Column(name = "id")
    private Integer id;

    @Column(name = "flight_number")
    @NotNull(message = "Flight number can't be null")
    private String flightNumber;

    @ForeignKey(table = "planes", column = "id", lazy = false)
    private Plane plane;

    @ForeignKey(table = "cities", column = "id", lazy = false)
    private City originCity;

    @ForeignKey(table = "cities", column = "id", lazy = false)
    private City destinationCity;

    @Column(name = "departure_time")
    @NotNull(message = "Departure time can't be null")
    private Timestamp departureTime;

    @Column(name = "arrival_time")
    private Timestamp arrivalTime;

    @Column(name = "reservation_deadline_hours")
    private Integer reservationDeadlineHours;

    @Column(name = "cancellation_deadline_hours")
    private Integer cancellationDeadlineHours;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getFlightNumber() {
        return flightNumber;
    }

    public void setFlightNumber(String flightNumber) {
        this.flightNumber = flightNumber;
    }

    public Plane getPlane() {
        return plane;
    }

    public void setPlane(Plane plane) {
        this.plane = plane;
    }

    public City getOriginCity() {
        return originCity;
    }

    public void setOriginCity(City originCity) {
        this.originCity = originCity;
    }

    public City getDestinationCity() {
        return destinationCity;
    }

    public void setDestinationCity(City destinationCity) {
        this.destinationCity = destinationCity;
    }

    public Timestamp getDepartureTime() {
        return departureTime;
    }

    public void setDepartureTime(Timestamp departureTime) {
        this.departureTime = departureTime;
    }

    public Timestamp getArrivalTime() {
        return arrivalTime;
    }

    public void setArrivalTime(Timestamp arrivalTime) {
        this.arrivalTime = arrivalTime;
    }

    public Integer getReservationDeadlineHours() {
        return reservationDeadlineHours;
    }

    public void setReservationDeadlineHours(Integer reservationDeadlineHours) {
        this.reservationDeadlineHours = reservationDeadlineHours;
    }

    public Integer getCancellationDeadlineHours() {
        return cancellationDeadlineHours;
    }

    public void setCancellationDeadlineHours(Integer cancellationDeadlineHours) {
        this.cancellationDeadlineHours = cancellationDeadlineHours;
    }    

    
    @Override
    public String toString() {
        return "Flight{" +
            "id=" + id +
            ", flightNumber='" + flightNumber + '\'' +
            ", plane=" + (plane != null ? plane.getModelName().toString() : "null") +
            ", originCity=" + (originCity != null ? originCity.getCityName().toString() : "null") +
            ", destinationCity=" + (destinationCity != null ? destinationCity.getCityName().toString() : "null") +
            ", departureTime=" + departureTime +
            ", arrivalTime=" + arrivalTime +
            ", reservationDeadlineHours=" + reservationDeadlineHours +
            ", cancellationDeadlineHours=" + cancellationDeadlineHours +
        '}';
    }
}