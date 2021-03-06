package com.dotech.tdm.dao.impl;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.dotech.tdm.TdmConstants;
import com.dotech.tdm.DotechConstants;
import com.dotech.tdm.dao.ITasksDao;
import com.dotech.tdm.domain.DotechDomain;
import com.dotech.tdm.domain.Task;
import com.dotech.tdm.exceptions.DotechException;

import oracle.jdbc.OracleTypes;


public class TasksDao extends DotechDaoSupport implements ITasksDao{
	
	public Object getRow(ResultSet rs, int arg1, String procName, Map inParams) throws SQLException {
		Task task = null;
		try {
			task = new Task();
			
			if(DotechConstants.SP_CONSULTAR.equals(procName)){
				task.setId(new Long (rs.getLong("ID_TAREA")));
				task.setTaskName(rs.getString("CVE_TAREA"));
				task.setTaskDesc(rs.getString("DESC_TAREA"));
				task.setParentTaskId(new Integer(rs.getInt("ID_TAREA_PADRE")));
				task.setStatus(new Integer(rs.getInt("ESTATUS")));
				task.setLevel(new Integer(rs.getInt("NIVEL")));

			
			}else if(TdmConstants.SP_GET_LIST_TASKS_BY_USER.equals(procName)){
				task.setId(new Long (rs.getLong("ID_TAREA")));
				task.setTaskName(rs.getString("CVE_TAREA"));
				task.setTaskDesc(rs.getString("DESC_TAREA"));
				task.setTaskTypeId(new Integer(rs.getInt("ID_TIPO_TAREA")));
				task.setParentTaskId(new Integer(rs.getInt("ID_TAREA_PADRE")));
				task.setLevel(new Integer(rs.getInt("NIVEL")));
				
			}else if(TdmConstants.SP_GET_TASK_BY_ID.equals(procName)){
				task.setId(new Long (rs.getLong("ID_TAREA")));
				task.setParentTaskId(new Integer (rs.getInt("ID_TAREA_PADRE")));
				task.setTaskName(rs.getString("CVE_TAREA"));
				task.setTaskDesc(rs.getString("DESC_TAREA"));
				task.setObservations(rs.getString("OBSERVACIONES"));
				task.setResponsibleId(new Long (rs.getLong("ID_RESPONSABLE")));
				task.setResponsibleName(rs.getString("NOMBRE_RESPONSABLE"));
				task.setTimeBudget(new Integer(rs.getInt("HORAS_PRESUPUESTO")));
				task.setStatus(new Integer(rs.getInt("ESTATUS")));
				boolean active = rs.getInt("ACTIVO")==1;
				task.setActive(new Boolean(active));
				
			}if(TdmConstants.SP_VALIDATE_TASK.equals(procName)){
				task.setId(new Long (rs.getLong("VALOR")));
			}else if(DotechConstants.SP_GRABAR.equals(procName) || DotechConstants.SP_MODIFICAR.equals(procName)
					|| DotechConstants.SP_ELIMINAR.equals(procName) || TdmConstants.SP_UPDATE_USER_PASSWORD.equals(procName)
					|| TdmConstants.SP_ADD_REL_ASG_TASKS.equals(procName) || TdmConstants.SP_DEL_REL_ASG_TASKS.equals(procName)){
				//
			}
		} catch (Exception e) {								
			e.printStackTrace();
			throw new SQLException(e.getMessage());
		}
       				      					     
		return task;
	}


	public Map getSPMap(){
		Map procedures = new HashMap();
		
		DotechSPDef sspdefc = new DotechSPDef();
		sspdefc.setName(DotechConstants.PACKAGE_NAME + TdmConstants.SP_GET_LIST_TASKS);
		sspdefc.setReturnsCursor(true);
		sspdefc.addOutParam("c_resultados", OracleTypes.CURSOR);
		
		procedures.put(DotechConstants.SP_CONSULTAR, sspdefc);
		
		DotechSPDef sspdefc1 = new DotechSPDef();
		sspdefc1.setName(DotechConstants.PACKAGE_NAME + TdmConstants.SP_GET_LIST_TASKS_BY_USER);
		sspdefc1.addInParam("responsibleId", OracleTypes.NUMBER);
		sspdefc1.setReturnsCursor(true);
		sspdefc1.addOutParam("c_resultados", OracleTypes.CURSOR);

		procedures.put(TdmConstants.SP_GET_LIST_TASKS_BY_USER, sspdefc1);
		
		DotechSPDef sspdefc2 = new DotechSPDef();
		sspdefc2.setName(DotechConstants.PACKAGE_NAME + TdmConstants.SP_GET_TASK_BY_ID);
		sspdefc2.addInParam("taskId", OracleTypes.NUMBER);
		sspdefc2.setReturnsCursor(true);
		sspdefc2.addOutParam("c_resultados", OracleTypes.CURSOR);

		procedures.put(TdmConstants.SP_GET_TASK_BY_ID, sspdefc2);
		
		DotechSPDef sspdefc3 = new DotechSPDef();
		sspdefc3.setName(DotechConstants.PACKAGE_NAME + TdmConstants.SP_VALIDATE_TASK);
		sspdefc3.addInParam("taskId", OracleTypes.NUMBER);
		sspdefc3.setReturnsCursor(true);
		sspdefc3.addOutParam("c_resultados", OracleTypes.CURSOR);

		procedures.put(TdmConstants.SP_VALIDATE_TASK, sspdefc3);
		
		DotechSPDef sspdefa = new DotechSPDef();
		sspdefa.setName(DotechConstants.PACKAGE_NAME + TdmConstants.SP_ADD_TASK);	
		sspdefa.addInParam("taskId", OracleTypes.NUMBER);
		sspdefa.addInParam("taskName", OracleTypes.VARCHAR);
		sspdefa.addInParam("taskDesc", OracleTypes.VARCHAR);
		sspdefa.addInParam("observations", OracleTypes.VARCHAR);
		sspdefa.addInParam("parentTaskId", OracleTypes.NUMBER);
		sspdefa.addInParam("responsibleId", OracleTypes.NUMBER);
		sspdefa.addInParam("timeBudget", OracleTypes.NUMBER);
		sspdefa.addInParam("status", OracleTypes.NUMBER);
		sspdefa.addInParam("active", OracleTypes.NUMBER);
		sspdefa.addInParam("userModify", OracleTypes.VARCHAR);
		sspdefa.setReturnsCursor(false);
		
		procedures.put(DotechConstants.SP_GRABAR, sspdefa);
		procedures.put(DotechConstants.SP_MODIFICAR, sspdefa);
				
		DotechSPDef sspdefa1 = new DotechSPDef();
		sspdefa1.setName(DotechConstants.PACKAGE_NAME + TdmConstants.SP_ADD_REL_ASG_TASKS);	
		sspdefa1.addInParam("userId", OracleTypes.NUMBER);
		sspdefa1.addInParam("taskId", OracleTypes.NUMBER);
		sspdefa1.addInParam("userModify", OracleTypes.VARCHAR);
		sspdefa1.setReturnsCursor(false);
		
		procedures.put(TdmConstants.SP_ADD_REL_ASG_TASKS, sspdefa1);
		
		DotechSPDef sspdefe = new DotechSPDef();
		sspdefe.setName(DotechConstants.PACKAGE_NAME + TdmConstants.SP_DEL_TASK);
		sspdefe.addInParam("taskId", OracleTypes.NUMBER);
		sspdefe.addInParam("userModify", OracleTypes.VARCHAR);
		sspdefe.setReturnsCursor(false);
		
		procedures.put(DotechConstants.SP_ELIMINAR, sspdefe);
		
		DotechSPDef sspdefe1 = new DotechSPDef();
		sspdefe1.setName(DotechConstants.PACKAGE_NAME + TdmConstants.SP_DEL_REL_ASG_TASKS);
		sspdefe1.addInParam("userId", OracleTypes.NUMBER);
		sspdefe1.addInParam("taskId", OracleTypes.NUMBER);
		sspdefe1.addInParam("userModify", OracleTypes.VARCHAR);
		sspdefe1.setReturnsCursor(false);
		
		procedures.put(TdmConstants.SP_DEL_REL_ASG_TASKS, sspdefe1);
		

		

		return procedures;
	}
	public Object agregar(Object params) throws DotechException {
		Map result = null;
		DotechDomain sd = (DotechDomain)params;
		
		 try {		
			if(sd.getConsulta() == null){
				result = executeProcedure(DotechConstants.SP_GRABAR, ((DotechDomain)params));		
			}else if(sd.getConsulta().equals("C1")){
				result = executeProcedure(TdmConstants.SP_ADD_REL_ASG_TASKS, ((DotechDomain)params));
			}
		} catch (DotechException e) {			
			e.printStackTrace();
			throw new DotechException(e);
		}
		 
		 return result.get("c_resultados") != null?((List) result.get("c_resultados")).get(0):params;

	}


	public List buscar(Object params) throws DotechException {
		Map result = null;
		DotechDomain sd = (DotechDomain)params;
		 try {
			 if(sd.getConsulta() == null){
				 result = executeProcedure(DotechConstants.SP_CONSULTAR, ((DotechDomain)params));
			 }else if(sd.getConsulta().equals("C1")){
				 result = executeProcedure(TdmConstants.SP_GET_LIST_TASKS_BY_USER, ((DotechDomain)params));
			 }else if(sd.getConsulta().equals("C2")){
				 result = executeProcedure(TdmConstants.SP_GET_TASK_BY_ID, ((DotechDomain)params));
			 }else if(sd.getConsulta().equals("DEL")){
				 result = executeProcedure(DotechConstants.SP_ELIMINAR, ((DotechDomain)params));
			 }else if(sd.getConsulta().equals("DEL2")){
				 result = executeProcedure(TdmConstants.SP_DEL_REL_ASG_TASKS, ((DotechDomain)params));
			 }
			 
		} catch (DotechException e) {			
			e.printStackTrace();
			throw new DotechException(e);
		}
		 return (List) result.get("c_resultados");	    
	}	
	
	
	public Map preProcess(DotechDomain domain, String procName) {
		Map inParams = new HashMap();
		Task t = (Task)domain;
		
		if(DotechConstants.SP_GRABAR.equals(procName) || DotechConstants.SP_MODIFICAR.equals(procName)){
			inParams.put("taskId", t.getId());
			inParams.put("taskName", t.getTaskName());
			inParams.put("taskDesc", t.getTaskDesc());
			inParams.put("observations", t.getObservations());
			inParams.put("parentTaskId", t.getParentTaskId());
			inParams.put("responsibleId", t.getResponsibleId());
			inParams.put("timeBudget", t.getTimeBudget());
			inParams.put("status", t.getStatus());
			int activeVal = 0; 
			if(t.getActive()!=null){
				if (t.getActive().booleanValue()){
					activeVal=1;
				}					
			}
			inParams.put("active",new Integer(activeVal));
			inParams.put("userModify", t.getUsuario());
		}else if(TdmConstants.SP_ADD_REL_ASG_TASKS.equals(procName)){			
			inParams.put("userId", t.getResponsibleId());
			inParams.put("taskId", t.getId());
			inParams.put("userModify", t.getUsuario());

		}else if(TdmConstants.SP_DEL_REL_ASG_TASKS.equals(procName)){			
			inParams.put("userId", t.getResponsibleId());
			inParams.put("taskId", t.getId());
			inParams.put("userModify", t.getUsuario());

		}else if(DotechConstants.SP_CONSULTAR.equals(procName)){
			
		}else if(DotechConstants.SP_ELIMINAR.equals(procName)){			
			inParams.put("taskId", t.getId());
			inParams.put("userModify", t.getUsuario());
		}else if(TdmConstants.SP_GET_LIST_TASKS_BY_USER.equals(procName)){			
			inParams.put("responsibleId", t.getResponsibleId());
		}else if(TdmConstants.SP_GET_TASK_BY_ID.equals(procName)){			
			inParams.put("taskId", t.getId());
		}else if(TdmConstants.SP_VALIDATE_USER.equals(procName)){			
			inParams.put("taskId", t.getId());
		}
		return inParams;
	}

	
	public Map postProcess(Map results, String procName) {	
		return results;
	}

}
