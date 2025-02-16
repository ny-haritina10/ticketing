package model;

import mg.jwe.orm.annotations.*;
import mg.jwe.orm.base.BaseModel;

@Table(name = "admins")
public class Admin extends BaseModel {

    @Id
    @Column(name = "id")
    private Integer id;

    @Column(name = "email")
    private String email;

    @Column(name = "password_hash")
    private String password;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }    
}