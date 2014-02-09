/* init script for all other javaScript functions ... 
	 */


// load a certain js file or use it from cache ...
// sample call: ('display.js', 'script'); ... possible resources: script and style

function IncludeResFile(name, res_type) {
	// try to get cached version, otherwise load content
	var a_load_res = new cCheckAndLoadResourceFile();
	
	if (name == '') {return false;}
	
	if (CachedVersionExists(name) == true) {
		InsertResIntoHead(ReturnCachedVersion(name), res_type);
		} else {
			
			a_load_res.name = name;
			a_load_res.res_type = res_type;
			a_load_res.doLoad();
			}
	}
	
function cCheckAndLoadResourceFile() {
	this.a_http_object;
	this.name = '';
	this.path = '';
	this.url = '';
	this.res_type = '';
	
	var _self = this;

	if (window.XMLHttpRequest) {
		this.a_http_object = new XMLHttpRequest();
		} else if (window.ActiveXObject) {
			this.a_http_object = new ActiveXObject("Microsoft.XMLHTTP");
			}
	
	// function to load JS (synchronous!)
	this.doLoad = function() {		
		_self.url = _self.name;
		_self.a_http_object.open("GET", _self.url, false);
		_self.a_http_object.send(null);
		InsertResIntoHead(_self.a_http_object.responseText, _self.res_type);
		}
	}
	
// try to get bottom frame ...
function GetCacheBottomFrame() {
	var obj1 = null;
	
	// best way: simple bottom frame ...
	try	{ 	obj1 = parent.framebottom;
		
			if (obj1) { return obj1; }
		} 	catch (e)	{  }

	// second ... no frames, but has opener
	if ((parent.location.href == self.location.href) && (window.opener)) {
		try	{ 	obj1 = window.opener.parent.framebottom;
			
				if (obj1) { return obj1; }
			} 	catch (e)	{ }
			
		// opened from iframe ...
		try	{ 	obj1 = window.opener.parent.parent.framebottom;
			
				if (obj1) { return obj1; }
			} 	catch (e)	{  }
		}
	
	// third ... parent, maybe iframe
	try	{ 	obj1 = parent.parent.framebottom;
			
				if (obj1) { return obj1; }
			} 	catch (e)	{  }
			
	return obj1;
	}
	
// check if a cached version exists
function CachedVersionExists(name) {
	var areturn = false;
	var aCacheFrame = GetCacheBottomFrame();
	
	if (aCacheFrame == null) {return false;}
	
	if (aCacheFrame.GetCachedScriptExists == undefined) {return false;}
		
	return GetCacheBottomFrame().GetCachedScriptExists(name);
	}
	
function ReturnCachedVersion(name) {
	var a_str_script = GetCacheBottomFrame().GetCachedScript(name);
	return a_str_script;
	}
	
// insert javascript into header ...
function InsertResIntoHead(str, res_type) {
	var head = document.getElementsByTagName('head').item(0);
	var head_obj;
   	var head_obj = document.createElement(res_type);
   	
   	if (res_type == 'script') {
   		head_obj.type = 'text/javascript';
   		head_obj.text = str;
   		}
   		
   	if (res_type == 'style') {
		head_obj.setAttribute("type", "text/css");
		head_obj.setAttribute("media", "all"); 
		
		if(head_obj.styleSheet){// IE
			head_obj.styleSheet.cssText = str;
			} else {// w3c
			var newStyle = document.createTextNode(str); 
			head_obj.appendChild(newStyle);
			}
   		}
   	
   	head.appendChild(head_obj);
	}