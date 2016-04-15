package com.dotech.tdm.web.controllers;

import com.dotech.tdm.domain.Task;

 
public class TasksController extends DotechController {
 

	public Class getManagedBean() {		
		return Task.class;
	}
	
	
}
