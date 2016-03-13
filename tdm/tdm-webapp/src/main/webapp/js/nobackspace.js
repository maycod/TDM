/**
 * 
 */

document.onkeydown = function(event) {

	if (!event) { /* This will happen in IE */
		event = window.event;
	}

	var keyCode = event.keyCode;

	if (keyCode == 8
			&& ((event.target || event.srcElement).tagName != "TEXTAREA")
			&& 
			(
					((event.target || event.srcElement).tagName != "INPUT")
					|| (((event.target || event.srcElement).tagName == "INPUT")
					&& $('input[type=checkbox]:focus').size() > 0)
			)
		) {

		if (navigator.userAgent.toLowerCase().indexOf("msie") == -1) {
			event.stopPropagation();
		} else {
			//alert("prevented");
			event.returnValue = false;
		}

		return false;
	}
};