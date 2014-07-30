<!--- //

	Component:	Apsettings
	Function:	LoadAvailableSecurityActionsOfServices
	Description:Load available actions from .xml and insert into database
	

// --->

<cffile action="read" charset="utf-8" file="#a_str_xml_file#" variable="a_str_actions">

<cfset q_select_actions = application.components.cmp_datatypeconvert.xmltoquery(xmlObj = XmlParse(a_str_actions))>

<cfquery name="q_delete_old_items">
DELETE FROM
	avaliableactions
;
</cfquery>

<cfloop query="q_select_actions">
	
	<cfquery name="q_insert_action">
	INSERT INTO
		avaliableactions
		(
		servicekey,
		actionname,
		entrykey,
		parentkey
		)
	VALUES
		(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_actions.servicekey#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_actions.actionname#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_actions.entrykey#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_actions.parentkey#">		
		)
	;
	</cfquery>
	
</cfloop>

