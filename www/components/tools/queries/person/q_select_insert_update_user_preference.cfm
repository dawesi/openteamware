<!--- //

	Component:	Person
	Function:	SaveUserPreference
	Description:Save user perferences to database
	
				Insert or update
	
// --->

<cftransaction action="begin">

<cfquery name="q_select_userpref_item_exists" datasource="#request.a_str_db_tools#">
SELECT
	COUNT(id) AS count_id
FROM
	userpreferences
WHERE
	(userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#">)
	AND
	(entrysection = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.section#">)
	AND
	(entryname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">)
;
</cfquery>

<cfif q_select_userpref_item_exists.count_id IS 0>
	<!--- insert ... --->
	 <cfquery name="q_insert_person_entry" datasource="#request.a_str_db_tools#">
	  INSERT INTO
		userpreferences
		(
		userid,
		entrysection,
		entryname,
		entryvalue1,
		md5_section_entryname
		) 
	  VALUES
		(
		<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.section#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.value#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_hash_id#">
		)
	  ; 
	  </cfquery>
<cfelse>
	<!--- update ... --->
 	<cfquery name="q_update_userpref_item" datasource="#request.a_str_db_tools#">
  	UPDATE
		userpreferences
	SET
		entryvalue1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.value#">
	WHERE
		(userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#">)
		AND
		(entrysection = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.section#">)
		AND
		(entryname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">)
	;
	</cfquery>
</cfif>

</cftransaction>
	
