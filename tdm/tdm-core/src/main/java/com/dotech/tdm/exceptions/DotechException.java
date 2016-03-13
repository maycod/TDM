package com.dotech.tdm.exceptions;

public class DotechException extends Exception{
	public DotechException(Throwable th) {
		super(th);
	}

	public DotechException(String msg) {
		super(msg);
	}
}
