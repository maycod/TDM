package com.dotech.tdm.dao.impl;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.dotech.tdm.TdmConstants;
import com.dotech.tdm.DotechConstants;
import com.dotech.tdm.dao.IUsersDao;
import com.dotech.tdm.domain.DotechDomain;
import com.dotech.tdm.domain.User;
import com.dotech.tdm.exceptions.DotechException;

import oracle.jdbc.OracleTypes;


public class UsersDao extends DotechDaoSupport implements IUsersDao{
	
	public Object getRow(ResultSet rs, int arg1, String procName, Map inParams) throws SQLException {
		User user = null;
		try {
			user = new User();
			
			if(DotechConstants.SP_CONSULTAR.equals(procName)){
				user.setId(new Long (rs.getLong("ID_USUARIO")));
				user.setUsername(rs.getString("CVE_USUARIO"));
				user.setProfileId(new Long (rs.getLong("ID_TIPO_USUARIO")));
				user.setProfileDesc(rs.getString("DESC_TIPO_USUARIO"));
				user.setCreationDate(rs.getString("FECHA_CREACION"));
			}else if(TdmConstants.SP_GET_USER_BY_ID.equals(procName)){
				user.setId(new Long (rs.getLong("ID_USUARIO")));
				user.setUsername(rs.getString("CVE_USUARIO"));
				user.setProfileId(new Long (rs.getLong("ID_TIPO_USUARIO")));
				user.setProfileDesc(rs.getString("DESC_TIPO_USUARIO"));
				user.setCreationDate(rs.getString("FECHA_CREACION"));
			}if(TdmConstants.SP_VALIDATE_USER.equals(procName)){
				user.setProfileDesc(rs.getString("DESC_TIPO_USUARIO"));
			}else if(DotechConstants.SP_GRABAR.equals(procName) || DotechConstants.SP_MODIFICAR.equals(procName)|| DotechConstants.SP_ELIMINAR.equals(procName) || TdmConstants.SP_UPDATE_USER_PASSWORD.equals(procName)){
				//
			}
		} catch (Exception e) {								
			e.printStackTrace();
			throw new SQLException(e.getMessage());
		}
       				      					     
		return user;
	}


	public Map getSPMap(){
		Map procedures = new HashMap();
		
		DotechSPDef sspdefc = new DotechSPDef();
		sspdefc.setName(DotechConstants.PACKAGE_NAME + TdmConstants.SP_GET_LIST_USERS);
		sspdefc.setReturnsCursor(true);
		sspdefc.addOutParam("c_resultados", OracleTypes.CURSOR);
		
		procedures.put(DotechConstants.SP_CONSULTAR, sspdefc);
		
		DotechSPDef sspdefc1 = new DotechSPDef();
		sspdefc1.setName(DotechConstants.PACKAGE_NAME + TdmConstants.SP_GET_USER_BY_ID);
		sspdefc1.addInParam("userId", OracleTypes.NUMBER);
		sspdefc1.setReturnsCursor(true);
		sspdefc1.addOutParam("c_resultados", OracleTypes.CURSOR);

		procedures.put(TdmConstants.SP_GET_USER_BY_ID, sspdefc1);
		
		DotechSPDef sspdefc2 = new DotechSPDef();
		sspdefc2.setName(DotechConstants.PACKAGE_NAME + TdmConstants.SP_VALIDATE_USER);
		sspdefc2.addInParam("username", OracleTypes.VARCHAR);
		sspdefc2.addInParam("password", OracleTypes.VARCHAR);
		sspdefc2.setReturnsCursor(true);
		sspdefc2.addOutParam("c_resultados", OracleTypes.CURSOR);

		procedures.put(TdmConstants.SP_VALIDATE_USER, sspdefc2);
		
		DotechSPDef sspdefa = new DotechSPDef();
		sspdefa.setName(DotechConstants.PACKAGE_NAME + TdmConstants.SP_ADD_USER);	
		sspdefa.addInParam("userId", OracleTypes.NUMBER);
		sspdefa.addInParam("username", OracleTypes.VARCHAR);
		sspdefa.addInParam("profileId", OracleTypes.NUMBER);
		sspdefa.addInParam("userModify", OracleTypes.VARCHAR);
		sspdefa.setReturnsCursor(false);
		
		procedures.put(DotechConstants.SP_GRABAR, sspdefa);
		procedures.put(DotechConstants.SP_MODIFICAR, sspdefa);
		
		DotechSPDef sspdefa1 = new DotechSPDef();
		sspdefa1.setName(DotechConstants.PACKAGE_NAME + TdmConstants.SP_UPDATE_USER_PASSWORD);	
		sspdefa1.addInParam("username", OracleTypes.VARCHAR);
		sspdefa1.addInParam("password", OracleTypes.VARCHAR);
		sspdefa1.setReturnsCursor(false);
		
		procedures.put(TdmConstants.SP_UPDATE_USER_PASSWORD, sspdefa1);
		
		
		DotechSPDef sspdefe = new DotechSPDef();
		sspdefe.setName(DotechConstants.PACKAGE_NAME + TdmConstants.SP_DEL_USER);
		sspdefe.addInParam("userId", OracleTypes.NUMBER);
		sspdefe.addInParam("userModify", OracleTypes.VARCHAR);
		sspdefe.setReturnsCursor(false);
		
		procedures.put(DotechConstants.SP_ELIMINAR, sspdefe);
		

		

		return procedures;
	}


	public List buscar(Object params) throws DotechException {
		Map result = null;
		DotechDomain sd = (DotechDomain)params;
		 try {
			 if(sd.getConsulta() == null){
				 result = executeProcedure(DotechConstants.SP_CONSULTAR, ((DotechDomain)params));
			 }else if(sd.getConsulta().equals("C1")){
				 result = executeProcedure(TdmConstants.SP_GET_USER_BY_ID, ((DotechDomain)params));
			 }else if(sd.getConsulta().equals("C2")){
				 result = executeProcedure(TdmConstants.SP_VALIDATE_USER, ((DotechDomain)params));
			 }else if(sd.getConsulta().equals("C3")){
				 result = executeProcedure(TdmConstants.SP_UPDATE_USER_PASSWORD, ((DotechDomain)params));
			 }else if(sd.getConsulta().equals("DEL")){
				 result = executeProcedure(DotechConstants.SP_ELIMINAR, ((DotechDomain)params));
			 }
			 
		} catch (DotechException e) {			
			e.printStackTrace();
			throw new DotechException(e);
		}
		 return (List) result.get("c_resultados");	    
	}	
	
	
	public Map preProcess(DotechDomain domain, String procName) {
		Map inParams = new HashMap();
		User u = (User)domain;
		//note: remove nulls once the bug is fixed
		if(DotechConstants.SP_GRABAR.equals(procName) || DotechConstants.SP_MODIFICAR.equals(procName)){
			inParams.put("userId", u.getId());
			inParams.put("username", u.getUsername());
			inParams.put("profileId", u.getProfileId());
			inParams.put("userModify",null);
		}else if(DotechConstants.SP_CONSULTAR.equals(procName)){
			
		}else if(DotechConstants.SP_ELIMINAR.equals(procName)){			
			inParams.put("userId", u.getId());
			inParams.put("userModify",null);
		}else if(TdmConstants.SP_GET_USER_BY_ID.equals(procName)){			
			inParams.put("userId", u.getId());
		}else if(TdmConstants.SP_VALIDATE_USER.equals(procName)){			
			inParams.put("username", u.getUsername());
			inParams.put("password", u.getPassword());
		}else if(TdmConstants.SP_UPDATE_USER_PASSWORD.equals(procName)){			
			inParams.put("username", u.getUsername());
			inParams.put("password", u.getPassword());
		}

		return inParams;
	}

	
	public Map postProcess(Map results, String procName) {	
		return results;
	}

}
