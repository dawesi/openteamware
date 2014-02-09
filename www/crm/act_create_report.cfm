<cfinclude template="/login/check_logged_in.cfm">

<cfdump var="#form#">

<cfset a_dt_start = ParseDateTime(form.frm_dt_start)>
<cfset a_dt_end = ParseDateTime(form.frm_dt_end)>

<cfinvoke component="/components/crmsales/crm_reports" method="CreateReport" returnvariable="a_bol_return">
	<cfinvokeargument name="reportname" value="#form.FRMREPORTNAME#">
	<cfinvokeargument name="description" value="#form.FRMDESCRIPTION#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="entrykey" value="#createuuid()#">
	<cfinvokeargument name="tablekey" value="#form.frmtablekey#">
	<cfinvokeargument name="crmfilterkey" value="#form.FRMCRMFILTERKEY#">
	<cfinvokeargument name="dt_start" value="#CreateODBCDateTime(a_dt_start)#">
	<cfinvokeargument name="dt_end" value="#CreateODBCDateTime(a_dt_end)#">
	<cfinvokeargument name="date_field" value="#form.FRM_DT_FIELD#">
	<cfinvokeargument name="displayfields" value="#form.FRM_DISPLAY_FIELDS#">
	<cfinvokeargument name="interval" value="#form.frm_interval#">

</cfinvoke>