package controller;

import java.sql.Connection;

import annotation.AnnotationController;
import annotation.AnnotationGetMapping;
import annotation.AnnotationModelAttribute;
import annotation.AnnotationPostMapping;
import annotation.AnnotationURL;
import database.Database;
import model.Admin;
import modelview.ModelView;
import service.AdminService;
import session.Session;
import validation.Valid;

@AnnotationController(name = "auth_controller")
public class AuthController {
    
    private Session session;

    @AnnotationGetMapping
    @AnnotationURL("/auth_form")
    public ModelView authForm() {
        ModelView mv = new ModelView("auth.jsp");
        return mv;
    }

    @AnnotationPostMapping
    @AnnotationURL("/admin_login")
    public ModelView adminLogin(@Valid @AnnotationModelAttribute("admin") Admin admin) {

        try {
            Connection connection = new Database().getConnection();
            boolean auth = AdminService.auth(connection, admin);
            
            if (auth) {
                ModelView mv = new ModelView("views/back-office/main.jsp");

                // set admin session 
                session.login(Admin.class);
                return mv;
            }

            else {
                ModelView mv = new ModelView("views/errors/error-login.jsp");
                mv.add("message", "Please verify your admin credentials!");

                return mv;
            }
        } 
        
        catch (Exception e) {
            // TODO: handle exception
            e.printStackTrace();
        }

        return null;
    }

    @AnnotationGetMapping
    @AnnotationURL("/logout")
    public ModelView logout() {
        // clear login session
        session.logout();
        return new ModelView("index.jsp");
    }
}