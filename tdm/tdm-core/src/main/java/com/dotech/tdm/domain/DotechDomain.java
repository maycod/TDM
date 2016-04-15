package com.dotech.tdm.domain;

import java.lang.reflect.InvocationTargetException;
import java.sql.ResultSet;
import java.util.Iterator;
import java.util.Map;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.beanutils.ConvertUtils;
import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.beanutils.converters.AbstractConverter;
import org.json.simple.JSONAware;
import org.json.simple.JSONObject;

import com.dotech.tdm.exceptions.DotechException;








public abstract class DotechDomain implements JSONAware{

	private Long id;
	private String usuario;
	private String consulta;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	
	public String getConsulta() {
		return consulta;
	}

	public void setConsulta(String consulta) {
		this.consulta = consulta;
	}

	public String getUsuario(){
		return this.usuario;
	}
	
	public void setUsuario(String usuario){
		this.usuario = usuario;
	}
	
	public DotechDomain(){
		try{
			Map map = PropertyUtils.describe(this);
			
			Class cls = Class.forName(map.get("class").toString().replaceAll("class ", ""));
			ConvertUtils.register(new AbstractConverter() {
				
			
				protected Class getDefaultType() {				
					return JSONObject.class;
				}
				
				
				protected Object convertToType(Class type, Object value) throws Throwable {
					Object obj = type.newInstance();
					BeanUtils.populate(obj,((JSONObject)value));
					return obj;
				} 
			}, cls);
		}catch(Exception e){
			e.printStackTrace();
		}
	}

	public String toJSONString(){
		try {
			 Map map = PropertyUtils.describe(this);
			 
			 map.remove("class");
			return JSONObject.toJSONString(map );
		} catch (Exception e) {
			return null;			
		}
		
	}
	

	
	public Map toMap() throws DotechException{
		try {
			return PropertyUtils.describe(this);
		} catch (Exception e) {
			e.printStackTrace();
			throw new DotechException(e);		
		}
	}
	
	public Object fromResultSet(ResultSet rs) throws IllegalAccessException, InvocationTargetException {

		Map properties = null;
		try {
			properties = PropertyUtils.describe(this);
			
			Iterator it = properties.keySet().iterator();
			String key = null;
			while(it.hasNext()){
				key = it.next().toString();
				if("class".equals(key) || "beanName".equals(key)){
					continue;
				}
				
				Class type = PropertyUtils.getPropertyType(this, key);
				
				if(type.toString().equals(Integer.class.toString())){
					properties.put(key, new Integer(rs.getInt(key)));
				}else
					if(type.toString().equals(String.class.toString())){
						properties.put(key, rs.getString(key));
					}
				
				
			}
		
		
		} catch (Exception e) {		
			e.printStackTrace();
		} 
	    
		BeanUtils.populate(this, properties);
		return this;
	}
}
