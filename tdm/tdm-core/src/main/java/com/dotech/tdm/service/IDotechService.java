package com.dotech.tdm.service;

import java.util.List;

import com.dotech.tdm.exceptions.DotechException;


public interface IDotechService {

	
	public List buscar(Object params) throws DotechException;
	
	
	public Object agregar(Object params) throws DotechException;
	
	
	public Object actualizar(Object params) throws DotechException;
	
	
	public Object eliminar(Object params) throws DotechException;
	
}
