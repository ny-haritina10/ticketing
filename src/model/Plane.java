package model;

import mg.jwe.orm.annotations.*;
import mg.jwe.orm.base.BaseModel;
import java.sql.Date;

@Table(name = "planes")
public class Plane extends BaseModel {

    @Id
    @Column(name = "id")
    private Integer id;

    @Column(name = "model_name")
    private String modelName;

    @Column(name = "fabrication_date")
    private Date fabricationDate;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getModelName() {
        return modelName;
    }

    public void setModelName(String modelName) {
        this.modelName = modelName;
    }

    public Date getFabricationDate() {
        return fabricationDate;
    }

    public void setFabricationDate(Date fabricationDate) {
        this.fabricationDate = fabricationDate;
    }
}