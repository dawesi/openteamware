<cfsetting enablecfoutputonly="yes">
<!---

load a requested template and replace the values ...

further step: save as application variable so that we do not have to reload the whole
thing again and again

<io>
		<in>
			<param name="entrykey" scope="attributes" type="string" default="">
				<description>
				the entryid of the application
				</description>
			</param>

			<param name="pagename" scope="attributes" type="string" default="">
				<description>
				the filename of the requested page
				</description>
			</param>	

			<param name="include_type" scope="attributes" type="string" default="page">
				<description>
				type of include object
				
				- pages ... directory pages
				- css ... directory css
				- xml ... directory xml
				
				</description>
			</param>	

			<param name="output" scope="attributes" type="boolean" default="true">
				<description>
				output the page or just save it to a caller.pagecontent variable?
				</description>
			</param>	
			<param name="dynamicpageinclude" scope="attributes" type="boolean" default="false">
				<description>
				do we have a page that needs to be "included" or just "outputted"?
				
				coldfusion pages have to be included ... the others just outputted
				
				on the template base, this distinction is made by checking if we've got
				a coldfusion (cfm) file ...
				</description>
			</param>	

			<param name="nocache" scope="attributes" type="boolean" default="false">
				<description>
				no caching ... default = no
				</description>
			</param>	
		</in>							
	</io>

--->
<cfparam name="attributes.entrykey" type="string" default="">
<cfparam name="attributes.pagename" type="string" default="">
<cfparam name="attributes.output" type="boolean" default="true">
<cfparam name="attributes.include_type" type="string" default="pages">
<cfparam name="attributes.dynamicpageinclude" type="boolean" default="false">
<cfparam name="attributes.nocache" type="boolean" default="false">

<cfif len(attributes.pagename) is 0>
	<!--- if no filename has been provided (f.e. because no include template
		  has been specified ... exit! --->
	<cfexit method="exittemplate">
</cfif>

<cfscript>
/**
 * Returns extension defined by all characters following last period.
 * v2 by Ray Camden
 * 
 * @param name 	 File name to use. (Required)
 * @return Returns a string. 
 * @author Alexander Sicular (as867@columbia.edu) 
 * @version 2, May 9, 2003 
 */
function getExtension(name) {  
    if(find(".",name)) return listLast(name,".");
    else return "";
}
/* return the full physical filename of the include template ... */
function getFullIncludeFilename()
	{
	return GetDirectoryFromPath(GetCurrentTemplatePath())&attributes.entrykey&request.a_str_dir_separator&attributes.include_type&request.a_str_dir_separator&attributes.pagename;
	}
</cfscript>

<!--- check the entrykey ... if it is provided ok, otherwise take the default value
	from the request scope --->
<cfif (len(attributes.entrykey) is 0) AND
	  (StructKeyExists(request.appsettings, "entrykey") is true)>
	  <cfset attributes.entrykey = request.appsettings.entrykey>	
<cfelse>
	  <!--- use default entry key for openTeamWare.com --->
	  <cfset attributes.entrykey = "576FCC20-D206-4FB1-AD2215D7C03A709C">
</cfif>

<cfif getExtension(attributes.pagename) is "cfm">
	<!--- dynamic request ... --->
	<cftry>
		<cfoutput>
		<cfinclude template="#attributes.entrykey#/#attributes.include_type#/#attributes.pagename#">
		</cfoutput>
	<cfcatch type="any"></cfcatch>
	</cftry>
	
	<!--- exit ... --->
	<cfexit method="exittemplate">
</cfif>

<!--- // static content ... // --->

<!--- generate the hash value (used for storing this value in the request scope) ... --->
<cfset a_str_hash_value = Hash(attributes.entrykey&attributes.pagename)>

<!--- has this file already been stored in the application scope (request.appsettings ...) ? --->
<cfset a_bol_file_loaded = StructKeyExists(request.appsettings.cached_templates, "include_template_hash_"&a_str_hash_value)>

<!--- the variable holding the page content ... --->
<cfset a_str_pagecontent = "">

<cfif (a_bol_file_loaded is false) OR (attributes.nocache is true)>
	<!--- load the page from sratch ... --->
	<cfset sFilename = getFullIncludeFilename()>
	
	<cfif FileExists(sFilename)>
		<!--- load file --->
		<cffile action="read" file="#sFilename#" variable="a_str_pagecontent">
	</cfif>
	
	<!--- save content in the application scope (copied afterwards to the request scope) --->
	<cflock name="lck_set_app_variable_pagecontent" timeout="3" type="exclusive">
		<cfset "application.a_struct_appsettings.cached_templates.include_template_hash_#a_str_hash_value#" = a_str_pagecontent>
	</cflock>
	
<cfelse>
	<!--- load from memory and set variable ... --->
	<cfset a_str_pagecontent = request.appsettings.cached_templates["include_template_hash_"&a_str_hash_value]>
</cfif>

<!--- replace values ... --->
<cfif CheckSimpleLoggedIn()>
	<cfset a_str_pagecontent = ReplaceNoCase(a_str_pagecontent, "%STATUS%", "Eingeloggt als <b>"&request.stSecurityContext.myusername&"</b>")>
</cfif>

<cfset a_str_pagecontent = Replacenocase(a_str_pagecontent, "%COMMON_LINKS%", "<a href=""/settings/"">Einstellungen</a>")>
<cfset a_str_pagecontent = ReplaceNoCase(a_str_pagecontent, "%CURRENTDATETIME%", dateformat(now(), "dd.mm.yy")&" "&timeformat(now(), "HH:mm"))>
<cfset a_str_pagecontent = ReplaceNoCase(a_str_pagecontent, "%ADMINISTRATORCONTACT%", request.appsettings.description)>
	
<cfif attributes.output is true>
	<cfoutput>#a_str_pagecontent#</cfoutput>
<cfelse>
	<cfset caller.pagecontent = a_str_pagecontent>
</cfif>

<cfsetting enablecfoutputonly="no">