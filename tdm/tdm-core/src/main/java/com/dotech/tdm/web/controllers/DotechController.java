package com.dotech.tdm.web.controllers;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.beanutils.BeanUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import org.springframework.web.servlet.mvc.multiaction.InternalPathMethodNameResolver;
import org.springframework.web.servlet.mvc.multiaction.MethodNameResolver;

import com.dotech.tdm.domain.DotechDomain;
import com.dotech.tdm.exceptions.DotechException;
import com.dotech.tdm.service.IDotechService;



public abstract class DotechController extends AbstractCommandController{

	private MethodNameResolver methodNameResolver = new InternalPathMethodNameResolver();

	protected IDotechService service;

	public DotechController() {
		super();
		String supported[] = {"GET","POST","PUT","HEAD","DELETE"};
		setSupportedMethods(supported);
		
	}
	
	public ModelAndView handle(HttpServletRequest request, HttpServletResponse response, 
			Object command, BindException errors) throws Exception {

		DotechDomain domain = (DotechDomain) command;
		
		String method = request.getMethod();
		response.setHeader("Content-Type", "application/json; charset=utf-8");
		
		if(method.equals("GET")){
			return get(request, response, command);
		}else if(method.equals("POST")){			
			command = encode(request);
			return post(request, response, command);
		}else if(method.equals("PUT")){
			command = encode(request); 			
			return put(request, response, command);
		}else if(method.equals("DELETE")){
			command = encode(request);			
			return delete(request, response, command);
		}
		
		return null;
	}

	
	protected Object encode(HttpServletRequest request) throws Exception{
		
		  StringBuffer jb = new StringBuffer();
		  JSONObject jsonObject = null;
		  JSONArray jsonArray = null;
		  Object command = null;
		  List commandList = null;
		  String line = null;
		  try {
		    BufferedReader reader = request.getReader();
		    while ((line = reader.readLine()) != null)
		      jb.append(line);
		  } catch (Exception e) { logger.error("Error " + e.getMessage());}
		  
		  //System.out.println(jb.toString());
		  try {
			  Object tmp = JSONValue.parseWithException(jb.toString());
			  if(tmp instanceof JSONObject){
			    jsonObject = (JSONObject) JSONValue.parseWithException(jb.toString());
			    command = getManagedBean().newInstance();
			    BeanUtils.populate(command, jsonObject);
			    //TODO
			    HttpSession session = request.getSession(true);
			    String username = session.getAttribute("username").toString();
			    ((DotechDomain) command).setUsuario(username);
			    
			    return command;
			  }else if(tmp instanceof JSONArray){
				    jsonArray = (JSONArray) JSONValue.parseWithException(jb.toString());
				    commandList = new ArrayList();
				    
				    for(int i = 0; i < jsonArray.size(); i++){
					    command = getManagedBean().newInstance();					    
					    BeanUtils.populate(command, (JSONObject)jsonArray.get(i));
					    //TODO
					    HttpSession session = request.getSession(true);
					    String username = session.getAttribute("username").toString();
					    ((DotechDomain) command).setUsuario(username);
					    commandList.add(command);
				    }
				    
				    return commandList;
				  }
		  } catch (Exception e) {			    
		    throw e;
		  }
		
		return null;
		
	}
	
	public ModelAndView get(HttpServletRequest request, HttpServletResponse response, Object command) throws ServletException, IOException{
		
		List resultados = new ArrayList();
		DotechDomain sd = (DotechDomain) command;
		
		
			
			try {
			    HttpSession session = request.getSession(true);
			    String username = session.getAttribute("username").toString();
			    ((DotechDomain) command).setUsuario(username);
				resultados = service.buscar(sd);
				response.getWriter().write(JSONArray.toJSONString(resultados));
			} catch (DotechException e) {
				logger.error(e);
			}
		     
		
	    return null;
	}

	
public ModelAndView delete(HttpServletRequest request, HttpServletResponse response, Object command) throws ServletException, IOException{
		
	DotechDomain sd = null;
	try {
			sd = (DotechDomain) service.eliminar(command);
			response.getWriter().write(sd.toJSONString());
		} catch (DotechException e) { 
			logger.error(e);
		}
		 
		return null;

		
	}

	

	public ModelAndView post(HttpServletRequest request, HttpServletResponse response, Object command) throws ServletException, IOException{
	
		DotechDomain sd = null;
		try {
			sd = (DotechDomain) service.agregar(command);
			
			response.getWriter().write(sd.toJSONString());
		} catch (DotechException e) { 
			logger.error(e);
		}
		 
		return null;
		
	}

	public ModelAndView put(HttpServletRequest request, HttpServletResponse response, Object command) throws ServletException, IOException{
		DotechDomain sd = null;
		try {
			
			Object obj = service.actualizar(command);
			
			if(obj instanceof List){				
				response.getWriter().write(JSONArray.toJSONString((List) obj));
			}else{
				sd = (DotechDomain)obj;				
				response.getWriter().write(sd.toJSONString());	
			}
			
			
		} catch (DotechException e) { 
			logger.error(e);
		}
		 
		return null;

		
	}

	public abstract Class getManagedBean();

	public final void setMethodNameResolver(MethodNameResolver methodNameResolver) {
		this.methodNameResolver = methodNameResolver;
	}
	
	public final MethodNameResolver getMethodNameResolver() {
		return this.methodNameResolver;
	}

	public IDotechService getService() {
		return service;
	}

	public void setService(IDotechService service) {
		this.service = service;
	}
	
	
	
}
