<!--- //

	load saved settings and create the URL
	
	// --->
	
<cfset a_str_url = "?">
	
<cfmodule template="../../common/person/getuserpref.cfm"
	entrysection = "tasks"
	entryname = "tasks.filtertimeframe"
	userparameter = "url.filtertimeframe"
	defaultvalue1 = ""
	setcallervariable1 = "a_str_filter_timeframe">
	
<cfset a_str_url = a_str_url & "&filtertimeframe="&a_str_filter_timeframe>

<cfmodule template="../../common/person/getuserpref.cfm"
	entrysection = "tasks"
	entryname = "tasks.filterworkgroup"
	userparameter = "url.filterworkgroup"
	defaultvalue1 = ""
	setcallervariable1 = "a_str_filter_workgroup">
	
<cfset a_str_url = a_str_url & "&filterworkgroup="&a_str_filter_workgroup>
	
<cfmodule template="../../common/person/getuserpref.cfm"
	entrysection = "tasks"
	entryname = "tasks.filterstatus"
	userparameter = "url.filterstatus"
	defaultvalue1 = "open"
	setcallervariable1 = "a_str_filter_status">
	
<cfset a_str_url = a_str_url & "&filterstatus="&a_str_filter_status>	
	
<cfmodule template="../../common/person/getuserpref.cfm"
	entrysection = "tasks"
	entryname = "tasks.filterpriority"
	userparameter = "url.filterpriority"
	defaultvalue1 = ""
	setcallervariable1 = "a_str_filter_priority">
	
<cfset a_str_url = a_str_url & "&filterpriority="&a_str_filter_priority>	
	
<cfmodule template="../../common/person/getuserpref.cfm"
	entrysection = "tasks"
	entryname = "tasks.filtercategory"
	userparameter = "url.filtercategory"
	defaultvalue1 = ""
	setcallervariable1 = "a_str_filter_category">
	
<cfset a_str_url = a_str_url & "&filtercategory="&a_str_filter_category>	
	
<cfmodule template="../../common/person/getuserpref.cfm"
	entrysection = "tasks"
	entryname = "tasks.display.orderby"
	userparameter = "url.order"
	defaultvalue1 = "dt_lastmodified"
	setcallervariable1 = "sOrderBy">
	
<cfset a_str_url = a_str_url & "&order="&sOrderBy>	
	
<cfmodule template="../../common/person/getuserpref.cfm"
	entrysection = "tasks"
	entryname = "tasks.display.sortorder"
	userparameter = "url.sortorder"
	defaultvalue1 = ""
	setcallervariable1 = "a_str_sortorder">
	
<cfset a_str_url = a_str_url & "&sortorder="&a_str_sortorder>

<cfquery name="q_insert_view">
INSERT INTO
	savedtaskviews 
	(entrykey,userkey,href,dt_created,viewname)
	VALUES
	(<cfqueryparam cfsqltype="cf_sql_varchar" value="#createuuid()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_url#" maxlength="255">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmname#" maxlength="255">
	)
;
</cfquery>