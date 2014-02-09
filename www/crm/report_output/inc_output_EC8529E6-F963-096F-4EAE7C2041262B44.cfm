<!---<cfdump var="#stReturn#" expand="no">--->


<!--- forward to table output ... --->
<cflocation addtoken="no" url="../database/default.cfm?action=ViewTable&table_entrykey=#stReturn.tablekey_of_report_output#">

<!---

<cfinvoke component="/components/crmsales/crm_reports" method="GenerateStandardReportOutput" returnvariable="stReturn_output">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="reportkey" value="#q_select_output.reportkey#">
	<cfinvokeargument name="query" value="#stReturn.q_select_contacts#">
	<cfinvokeargument name="fieldnameinformation" value="#stReturn.stReturn_CONTACTS.q_select_table_fields#">
	<cfinvokeargument name="fieldstodisplay" value="#q_select_output.includefields#">
	<cfinvokeargument name="format" value="html">
	<cfinvokeargument name="orderby" value="dt_lastcontact">
	<cfinvokeargument name="fieldtypeinformation" value="#stReturn.a_struct_column_datatypes#">
</cfinvoke>
options,,desc


<cfoutput>#stReturn_output.content#</cfoutput>

--->