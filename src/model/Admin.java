package model;

import validation.NotNull;
import validation.Size;
import validation.Valid;

@Valid
public class Admin {
    
    @NotNull
    @Size(min = 2, max = 50, message = "Email must be between 2 and 50 characters")
    private String email;

    @NotNull
    private String password;

    public Admin()
    { }

    public Admin(String email, String password) {
        this.setEmail(email);
        this.setPassword(password);
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