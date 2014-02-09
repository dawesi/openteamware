<cfinclude template="/login/check_logged_in.cfm">

<cfparam name="url.directory" type="string" default="/">

<cfinvoke   		
	component = "#application.components.cmp_storage#"   		
	method = "path2uuid"
	path="#url.directory#"
	returnvariable="a_arr_uuids"
	securitycontext="#request.stSecurityContext#"		
	usersettings="#request.stUserSettings#">  
</cfinvoke>
	
<cfset sDirectorykey = a_arr_uuids.uuids[ArrayLen(a_arr_uuids.uuids)]>

<cflocation addtoken="no" url="/storage/default.cfm?action=ShowFiles&directorykey=#sDirectorykey#">