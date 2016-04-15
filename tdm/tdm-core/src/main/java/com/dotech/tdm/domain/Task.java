package com.dotech.tdm.domain;


public class Task extends DotechDomain{
	private String taskName;
	private String taskDesc;
	private String observations;
	private Integer taskTypeId;
	private Integer parentTaskId;
	private Integer level;
	private Long responsibleId;
	
	public String getTaskName() {
		return taskName;
	}
	public void setTaskName(String taskName) {
		this.taskName = taskName;
	}
	public String getTaskDesc() {
		return taskDesc;
	}
	public void setTaskDesc(String taskDesc) {
		this.taskDesc = taskDesc;
	}
	public String getObservations() {
		return observations;
	}
	public void setObservations(String observations) {
		this.observations = observations;
	}
	public Integer getTaskTypeId() {
		return taskTypeId;
	}
	public void setTaskTypeId(Integer taskTypeId) {
		this.taskTypeId = taskTypeId;
	}
	public Integer getParentTaskId() {
		return parentTaskId;
	}
	public void setParentTaskId(Integer parentTaskId) {
		this.parentTaskId = parentTaskId;
	}
	public Integer getLevel() {
		return level;
	}
	public void setLevel(Integer level) {
		this.level = level;
	}
	public Long getResponsibleId() {
		return responsibleId;
	}
	public void setResponsibleId(Long responsibleId) {
		this.responsibleId = responsibleId;
	}
	
	
}
