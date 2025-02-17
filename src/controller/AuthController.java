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

    @AnnotationPostMapping
    @AnnotationURL("/admin_login")
    public ModelView adminLogin(@Valid @AnnotationModelAttribute("admin") Admin admin) {

        try (Connection connection = new Database().getConnection()){
            boolean auth = AdminService.auth(connection, admin);
            
            if (auth) {
                ModelView mv = new ModelView("main.jsp");

                // Add template parameters
                mv.add("activePage", "dashboard");
                mv.add("contentPage", "dashboard.jsp");
                mv.add("pageTitle", "Dashboard");

                // set admin session 
                session.login(Admin.class);
                return mv;
            }

            else {
                ModelView mv = new ModelView("error-login.jsp");
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

    @AnnotationGetMapping
    @AnnotationURL("/admin")
    public ModelView dashboard() {
        ModelView mv = new ModelView("main.jsp");

        mv.add("activePage", "dashboard");
        mv.add("contentPage", "dashboard.jsp");
        mv.add("pageTitle", "Dashboard");

        return mv;
    }
}