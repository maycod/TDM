package com.dotech.tdm.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.context.support.ApplicationObjectSupport;

import com.dotech.tdm.dao.IDotechDAO;
import com.dotech.tdm.exceptions.DotechException;
import com.dotech.tdm.service.IDotechService;

public abstract class DotechService extends ApplicationObjectSupport implements IDotechService{

	private IDotechDAO dao;

	public IDotechDAO getDao() {
		return dao;
	}

	public void setDao(IDotechDAO dao) {
		this.dao = dao;
	}
	
	
	public Object actualizar(Object params) throws DotechException {
		
		if(params instanceof List){
			List results = new ArrayList();
			for(int i = 0; i < ((List)params).size(); i++){
				//logger.debug("Actualizando: " + ((DotechDomain)((List)params).get(i)).toJSONString());
				results.add(getDao().actualizar(((List)params).get(i)));			
			}
			
			return results;
		}else{
			//logger.debug("Actualizando: " + (DotechDomain)params);
			return getDao().actualizar(params);
		}
	}

	public Object agregar(Object params) throws DotechException {
		return getDao().agregar(params);
	}

	public List buscar(Object params) throws DotechException {			
			return getDao().buscar(params);
	}

	public Object eliminar(Object params) throws DotechException {
		return getDao().eliminar(params);
	}

	
}
