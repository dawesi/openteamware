<!--- //

	Module:		CRMsales
	Function:	BuildCRMFilterStruct
	Description: 
	

	
	
	select search criteria
	divide by type
	
// --->

<cfquery name="q_select_filter_criteria" datasource="#request.a_str_db_tools#">
SELECT
	entrykey,
	dt_created,
	servicekey,
	userkey,
	viewkey,
	area,
	displayname,
	internalfieldname,
	internaldatatype,
	connector,
	operator,
	comparevalue
FROM
	crmfiltersearchsettings  
WHERE
	(userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">)
	AND
	(viewkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.viewkey#">)
	AND
	(itemtype = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.itemttype#">)
;
</cfquery>

