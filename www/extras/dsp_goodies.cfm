<!--- //

	display various goodies
	
	// --->
	



<cfsavecontent variable="a_str_js">
	function addEngine()
	{
	  if ((typeof window.sidebar == 'object') && (typeof window.sidebar.addSearchEngine == 'function'))
	  {
	    window.sidebar.addSearchEngine(
	      'http://www.openTeamWare.com/download/files/goodies/mozilla/searchplugin/inboxcc.src',
	      'http://www.openTeamWare.com/download/files/goodies/mozilla/searchplugin/inboxcc.png',
	      'openTeamWare',
	      'Business' );
	  }
	  else
	  {
	    alert("Die Suchoption konnte leider nicht installiert werden - bitte updaten Sie auf eine aktuelle Firefox Version."); //
	  }
	}
</cfsavecontent>

<cfscript>
	AddJSToExecuteAfterPageLoad('', a_str_js);
</cfscript>

<cfinvoke component="#application.components.cmp_lang#" method="GetTemplateIncludePath" returnvariable="a_str_page_include">
	<cfinvokeargument name="section" value="extras">
	<cfinvokeargument name="langno" value="#client.langno#">
	<cfinvokeargument name="template_name" value="goodies_overview">
</cfinvoke>

<cfinclude template="#a_str_page_include#">