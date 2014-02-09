<!--- //

	Module:		E-Mail
	Description:Load contacts ...
	

// --->
﻿<cfif NOT StructKeyExists(request, 'stSecurityContext')>
	<cfabort>
</cfif>

<cfcontent type="text/html; charset=utf-8">
<cfprocessingdirective pageencoding="utf-8">
<html>
<head>
	<script type="text/javascript" src="/common/js/wddx.js"></script>
	
	<script type="text/javascript">
	function UpdateComposeWindow() {
		parent.q_select_contacts_wddx = q_record_set;
		}
	</script>
	
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body onLoad="UpdateComposeWindow()">


<cfset a_struct_loadoptions = StructNew() />
<cfset a_struct_loadoptions.maxrows = 500 />
<cfset a_struct_loadoptions.fieldstoselect = 'dt_lastcontact,entrykey,firstname,surname,email_prim,company' />

<cfset a_struct_filter = StructNew() />
<cfset a_struct_filter.NoArchiveItems = true />

<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">	
	<cfinvokeargument name="loadoptions" value="#a_struct_loadoptions#">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
	<cfinvokeargument name="orderby" value="-dt_lastcontact">
</cfinvoke>

<cfquery name="q_select_contacts" dbtype="query">
SELECT
	firstname,surname,email_prim,company
FROM
	stReturn.q_select_contacts
WHERE
	NOT email_prim = ''
ORDER BY
	dt_lastcontact DESC
;
</cfquery>

<script type="text/javascript">
<cfwddx action="cfml2js" input="#q_select_contacts#" TOPLEVELVARIABLE='q_record_set'>
</script>
</body>
</html>

