package com.dotech.tdm.dao;

import java.util.List;

import com.dotech.tdm.exceptions.DotechException;


public interface IDotechDAO {

	
	public List buscar(Object params) throws DotechException;
	
	
	public Object agregar(Object params) throws DotechException;
	
	
	public Object actualizar(Object params) throws DotechException;
	
	
	public Object eliminar(Object params) throws DotechException;
}
