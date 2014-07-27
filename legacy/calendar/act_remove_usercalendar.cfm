<!--- 

	remove userkey
	
	--->
	
<cfinclude template="../login/check_logged_in.cfm">

<cfparam name="url.userkey" type="string" default="">


<!--- load values ... --->

<!--- session timeout? --->
<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "calendar"
	entryname = "display.includeusercalendars"
	defaultvalue1 = "">	


<!--- remove userkey ... --->
<cfset a_str_person_entryvalue1 = ReplaceNoCase(a_str_person_entryvalue1, url.userkey, '', 'ALL')>

<!--- set new values ... --->
<cfmodule template="../common/person/saveuserpref.cfm"
	entrysection = "calendar"
	entryname = "display.includeusercalendars"
	entryvalue1 = #a_str_person_entryvalue1#>

<cflocation addtoken="no" url="#ReturnRedirectURL()#">