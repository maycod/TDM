package com.dotech.tdm;

import java.io.IOException;  
import java.io.PrintWriter;  
  
import javax.servlet.ServletException;  
import javax.servlet.http.HttpServlet;  
import javax.servlet.http.HttpServletRequest;  
import javax.servlet.http.HttpServletResponse;  
import javax.servlet.http.HttpSession;

import com.dotech.tdm.dao.impl.UsersDao;
import com.dotech.tdm.domain.User;

import com.dotech.tdm.exceptions.DotechException;

import oracle.jdbc.OracleTypes;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;

import javax.net.ssl.HttpsURLConnection;

public class LoginServlet extends HttpServlet { 
	ResourceBundle connData = ResourceBundle.getBundle("Connections");
    String ipServer = connData.getString("ipServer");
    String portServer = connData.getString("portServer");
    String dbNameServer = connData.getString("dbNameServer");
    String usernameServer = connData.getString("usernameServer");
    String passwordServer = connData.getString("passwordServer");
	
	public String validateUser(String username, String password) throws DotechException, ClassNotFoundException, SQLException{
		ResultSet rs = null;
		
		Class.forName("oracle.jdbc.driver.OracleDriver");
        
        // Se establece conexion a la BD Central
        Connection connectionOra = null;
        connectionOra = DriverManager
                .getConnection("jdbc:oracle:thin:@"+ ipServer +":"+portServer+":"+
                    dbNameServer, usernameServer, passwordServer);

        //Se insertan parametros de entrada al SP pertinente.
        String spCall = "TDMADM.PKG_TO_DO_MANAGER.SP_VALIDATE_USER(?,?,?)";

        //Se inicializa un CallableStatement para realizar la llamada al SP pertinente con sus respectivos parametros de entrada.
        CallableStatement staOra = connectionOra.prepareCall("{call "+spCall+"}", ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        
        //Se registran parametros de entrada.
        staOra.setString(1, username);
        staOra.setString(2, password);
        staOra.registerOutParameter(3, OracleTypes.CURSOR);
        //Se ejecuta el SP
        staOra.execute();
        
        rs = (ResultSet) staOra.getObject(3);
        
        String profile = null;
        if (rs.next())
        {
        	profile = rs.getString("DESC_TIPO_USUARIO");
        }
		
        return profile;
	}

    protected void doPost(HttpServletRequest request, HttpServletResponse response)  
                    throws ServletException, IOException {  
        try {
            response.setContentType("text/html");  
            PrintWriter out=response.getWriter();  
            
            //request.getRequestDispatcher("link.html").include(request, response);  
              
            String username=request.getParameter("inputUsername");  
            String password=request.getParameter("inputPassword");  
            HttpSession session=request.getSession();
			validateUser(username, password);
			String profile = validateUser(username, password);
	        
	        if(profile != null){
	        	response.sendRedirect("jsp/index.jsp");
		        session.setAttribute("username",username);
		        session.setAttribute("profile",profile);
		        session.setAttribute("mensajeError","");
	        }  
	        else{  
	            response.sendRedirect("login.jsp");
	            session.setAttribute("mensajeError","Credenciales incorrectas. Favor de intentar nuevamente.");
	            //request.getRequestDispatcher("login.jsp").include(request, response);  
	        }  
	        out.close();  
        }catch (ClassNotFoundException e) {
        	response.sendRedirect("login.jsp");
        	HttpSession session=request.getSession();
            session.setAttribute("mensajeError","Error de conexión. Favor de intentar mas tarde.");
			e.printStackTrace();
		} catch (SQLException e) {
			response.sendRedirect("login.jsp");
        	HttpSession session=request.getSession();
            session.setAttribute("mensajeError","Error de conexión. Favor de intentar mas tarde.");
			e.printStackTrace();
			e.printStackTrace();
		} catch (DotechException e) {
			response.sendRedirect("login.jsp");
        	HttpSession session=request.getSession();
            session.setAttribute("mensajeError","Error de conexión. Favor de intentar mas tarde.");
			e.printStackTrace();
			e.printStackTrace();
		}
        
    }  
}  