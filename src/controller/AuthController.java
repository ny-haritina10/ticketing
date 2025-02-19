package controller;

import java.sql.Connection;

import annotation.AnnotationController;
import annotation.AnnotationGetMapping;
import annotation.AnnotationModelAttribute;
import annotation.AnnotationPostMapping;
import annotation.AnnotationURL;
import database.Database;
import mg.jwe.orm.criteria.Criterion;
import model.Admin;
import model.Client;
import modelview.ModelView;
import service.AdminService;
import service.ClientService;
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

    @AnnotationGetMapping
    @AnnotationURL("/login_client")
    public ModelView loginClient() {
        ModelView mv = new ModelView("front-office.jsp");
        return mv;
    }

    @AnnotationPostMapping
    @AnnotationURL("/client_login")
    public ModelView authLogin(@AnnotationModelAttribute(value = "client") Client client) {
        try (Connection connection = new Database().getConnection()){
            boolean auth = ClientService.auth(connection, client);
            
            if (auth) {
                ModelView mv = new ModelView("main-1.jsp");

                Client cl = Client.findByCriteria(
                    connection, 
                    Client.class, 
                    new Criterion("email", "=", client.getEmail())
                )[0];

                // set admin session 
                session.login(Client.class);
                session.add("connected_client", cl.getId());
                
                return mv;
            }

            else {
                ModelView mv = new ModelView("error-login.jsp");
                mv.add("message", "Please verify your client credentials!");

                return mv;
            }
        } 
        
        catch (Exception e) {
            // TODO: handle exception
            e.printStackTrace();
            return null;
        }
    }
}