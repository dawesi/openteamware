<cfquery name="q_insert" datasource="#request.a_str_db_tools#">
INSERT INTO
	scenarioseen
(
	userid,
	pagesection,
	pagename,
	timesseen,
	lastvisit
	,firstvisit
	) 
VALUES
(
<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.userid#">
, 
<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.section#">
, 
<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.page#">
,
1,
current_timestamp,
current_timestamp
)
; 
</cfquery>