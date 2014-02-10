
<cffile action="readbinary" file="#arguments.filename#" variable="a_str_data">

<!--- delete old photo --->
<cfquery name="q_delete_old_photo" datasource="#request.a_str_db_tools#">
DELETE FROM
	faxlogo   
WHERE
	(userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">)
;
</cfquery>

<cfquery name="q_insert_data" datasource="#request.a_str_db_tools#">
INSERT INTO faxlogo 
(imagedata,userkey,contenttype)
VALUES
('#tobase64(a_str_data)#',
<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contenttype#">);
</cfquery>