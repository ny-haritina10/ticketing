package model;

import mg.jwe.orm.annotations.*;
import mg.jwe.orm.base.BaseModel;

@Table(name = "seat_configurations")
public class SeatConfiguration extends BaseModel {

    @Id
    @Column(name = "id")
    private Integer id;

    @ForeignKey(table = "planes", column = "id", lazy = false)
    private Plane plane;

    @Column(name = "category")
    private String category;

    @Column(name = "number_of_seats")
    private Integer numberOfSeats;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Plane getPlane() {
        return plane;
    }

    public void setPlane(Plane plane) {
        this.plane = plane;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public Integer getNumberOfSeats() {
        return numberOfSeats;
    }

    public void setNumberOfSeats(Integer numberOfSeats) {
        this.numberOfSeats = numberOfSeats;
    }    
}