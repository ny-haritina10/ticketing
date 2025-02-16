package controller;

import annotation.AnnotationController;
import annotation.AnnotationGetMapping;
import annotation.AnnotationModelAttribute;
import annotation.AnnotationPostMapping;
import annotation.AnnotationURL;
import model.Admin;
import modelview.ModelView;
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

    // @AnnotationPostMapping
    // @AnnotationURL("/admin_login")
    // public ModelView adminLogin(@Valid @AnnotationModelAttribute("admin") Admin admin) {
    //     try {
    //         // hardcoded value 
    //         String email = "admin@gmail.com";
    //         String password = "admin";

    //         if (admin.getEmail().equals(email) && admin.getPassword().equals(password)) {
    //             ModelView mv = new ModelView("success-admin.jsp");
    //             mv.add("role", "Admin");

    //             // set admin as session
    //             session.login(Admin.class);

    //             return mv;
    //         }

    //         else {
    //             ModelView mv = new ModelView("error-login.jsp");
    //             mv.add("message", "Error login credentials");

    //             return mv;
    //         }
    //     } 
        
    //     catch (Exception e) {
    //         e.printStackTrace();
    //         return null;
    //     }
    // }

    @AnnotationGetMapping
    @AnnotationURL("/logout")
    public ModelView logout() {
        session.logout();
        return new ModelView("index.jsp");
    }
}