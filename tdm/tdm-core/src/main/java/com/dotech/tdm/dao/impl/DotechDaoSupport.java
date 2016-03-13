package com.dotech.tdm.dao.impl;

import java.sql.SQLException;
import java.sql.Types;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.commons.beanutils.PropertyUtils;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.SqlOutParameter;
import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.core.support.JdbcDaoSupport;
import org.springframework.jdbc.object.StoredProcedure;

import com.dotech.tdm.DotechConstants;
import com.dotech.tdm.domain.DotechDomain;
import com.dotech.tdm.exceptions.DotechException;




public abstract class DotechDaoSupport extends JdbcDaoSupport {


	
	public abstract Object getRow(java.sql.ResultSet rs, int arg1, String procName, Map inParams) throws SQLException;
	
	public abstract Map getSPMap();
	
	public abstract Map preProcess(DotechDomain domain, String procName);
	
	public abstract Map postProcess(Map results, String procName);
	
	public Map executeProcedure(String procName, DotechDomain domain)  throws DotechException{	
		
		
		Map inParams = preProcess(domain, procName);
		
		Map procDefs = getSPMap();
		
		
		DotechSPDef sspd = (DotechSPDef)procDefs.get(procName);
		
		if(sspd == null){
			throw new DotechException("No existe la definicion para el procedure " + procName);
		}
		
		SevenStoredProcedure sp = new SevenStoredProcedure(getJdbcTemplate().getDataSource(), sspd, inParams, procName);
		Map results = sp.execute(getInParams(inParams));
		
		results = postProcess(results, procName);
			
		return results;
	}
	
	private Map getInParams(Map inParams) {
		Map tmpInParams = new HashMap();
		
		Iterator it = null; 
		
		it = inParams.keySet().iterator();
		
		String key = null;
		while(it.hasNext()){
			key = it.next().toString();
			tmpInParams.put(getProcedureParamPrefix() + key, inParams.get(key));
		}
		
		return tmpInParams;
	}

	protected  String getProcedureParamPrefix(){
		return DotechConstants.PROCEDURE_PARAM_PREFIX;
	}

	private class SevenStoredProcedure extends StoredProcedure { 
		 
		public SevenStoredProcedure(DataSource datasource, DotechSPDef procDefinition, final Map inParams, final String procName) throws DotechException{ 
			super(datasource, procDefinition.getName());				
			
			try{
				
				Iterator it = null;
				String key = null;
				if(procDefinition.getInParams().size() > 0){
					it = procDefinition.getInParams().keySet().iterator();
					
					Integer type = null;
					
					while(it.hasNext()){
						key = it.next().toString();
						type = (Integer) procDefinition.getInParams().get(key);
																				
						declareParameter( new SqlParameter(getProcedureParamPrefix() + key, type.intValue()));													
					}
					
				}else{
					it = inParams.keySet().iterator();
					
					key = null;
					while(it.hasNext()){
						key = it.next().toString();
						
						if("class".equals(key) || "beanName".equals(key)){
							continue;
						}
						
						Class type = PropertyUtils.getPropertyType(((Class)inParams.get("class")).newInstance(), key);
						
						
						if(type.toString().equals(Integer.class.toString())){
							declareParameter( new SqlParameter(DotechConstants.PROCEDURE_PARAM_PREFIX + key, Types.INTEGER) );							
						}else
							if(type.toString().equals(String.class.toString())){
								declareParameter( new SqlParameter(DotechConstants.PROCEDURE_PARAM_PREFIX + key, Types.VARCHAR) );
							}
						
						
					
					}
				}
				
		
				
				
								
				if(procDefinition.getOutParams().size() > 0){
					it = procDefinition.getOutParams().keySet().iterator();
					
					Integer	type = null;
					key = null;
					while(it.hasNext()){
						key = it.next().toString();
						type = (Integer) procDefinition.getOutParams().get(key);
						
						declareParameter( new SqlOutParameter(key, type.intValue(), new RowMapper(){
							
							public Object mapRow(java.sql.ResultSet rs, int arg1) throws java.sql.SQLException {
									
								 	return getRow(rs, arg1, procName, inParams);
							}
					 						
						}
					)
					);
					}
				}else{
					//declaring sql out parameter
					if(procDefinition.isReturnsCursor()){
						declareParameter( new SqlOutParameter( procDefinition.getCursorName(), oracle.jdbc.OracleTypes.CURSOR, new RowMapper(){
							
								public Object mapRow(java.sql.ResultSet rs, int arg1) throws java.sql.SQLException {
										
									 	return getRow(rs, arg1, procName, inParams);
								}
						 						
							}
						)
						);
					}else if(procDefinition.isReturnsId()){
						
						declareParameter( new SqlOutParameter( procDefinition.getGeneratedIdName(), oracle.jdbc.OracleTypes.NUMBER, new RowMapper(){
							
								public Object mapRow(java.sql.ResultSet rs, int arg1) throws java.sql.SQLException {
										
									 	return getRow(rs, arg1, procName, inParams);
								}
						 						
							}
						)
						);
						}
				}

					 						
					
					compile();
			}catch(Exception e){
				throw new DotechException(e);
			}
		} 
		
		
			public Map execute(Map inParams){				
				Map results = super.execute(inParams);							
				return results; 
			}
		
	}
	
	
	
	public List buscar(Object params) throws DotechException {
	Map result = null;
	 try {
		result = executeProcedure(DotechConstants.SP_CONSULTAR, ((DotechDomain)params));
	} catch (DotechException e) {			
		e.printStackTrace();
		throw new DotechException(e);
	}
	 return (List) result.get("c_resultados");
    
}



public Object actualizar(Object params) throws DotechException {
	Map result = null;
	 try {
		result = executeProcedure(DotechConstants.SP_MODIFICAR, ((DotechDomain)params));
	} catch (DotechException e) {			
		e.printStackTrace();
		throw new DotechException(e);
	}
	 return result.get("c_resultados") != null?((List) result.get("c_resultados")).get(0):params;
}


public Object agregar(Object params) throws DotechException {
	Map result = null;
	
	 try {			 
		result = executeProcedure(DotechConstants.SP_GRABAR, ((DotechDomain)params));		
	} catch (DotechException e) {			
		e.printStackTrace();
		throw new DotechException(e);
	}
	 
	 return result.get("c_resultados") != null?((List) result.get("c_resultados")).get(0):params;

}




public Object eliminar(Object params) throws DotechException {
	Map result = null;
	 try {
		result = executeProcedure(DotechConstants.SP_ELIMINAR, ((DotechDomain)params));
	} catch (DotechException e) {			
		e.printStackTrace();
		throw new DotechException(e);
	}
	 return result.get("c_resultados") != null?((List) result.get("c_resultados")).get(0):params;
}


}
