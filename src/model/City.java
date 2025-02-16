package model;

import mg.jwe.orm.annotations.*;
import mg.jwe.orm.base.BaseModel;

@Table(name = "cities")
public class City extends BaseModel {

    @Id
    @Column(name = "id")
    private Integer id;

    @Column(name = "city_name")
    private String cityName;

    @Column(name = "country")
    private String country;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getCityName() {
        return cityName;
    }

    public void setCityName(String cityName) {
        this.cityName = cityName;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }    
}