<!---<cfset a_tc_begin = GetTickCount()>

<cflog text="UPDATE folderdata fields" type="Information" log="Application" file="ib_mailspeed">
--->

<cfquery name="q_update_speedmail_status" datasource="#request.a_str_db_email#">
UPDATE
	folderdata
SET
<cfswitch expression="#arguments.status#">
	<cfcase value="2">
		seen = 1
	</cfcase>
	<cfcase value="3">
		flagged = 1
	</cfcase>
	<cfcase value="1">
		answered = 1
	</cfcase>
	<cfcase value="20">
		seen = 0
	</cfcase>
	<cfcase value="30">
		flagged = 0
	</cfcase>
	<cfcase value="10">
		answered = 0
	</cfcase>	
	<cfdefaultcase>
		afrom = afrom
	</cfdefaultcase>
</cfswitch>
WHERE
	uid IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.uid#" list="yes">)
	AND
	foldername = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.foldername#">
	AND
	account = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">
;
</cfquery>

<cfquery name="q_select_dummy" datasource="#request.a_str_db_email#">
SELECT
	flagged,answered,seen
FROM
	folderdata
WHERE
	uid IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.uid#" list="yes">)
	AND
	foldername = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.foldername#">
	AND
	account = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">
FOR UPDATE
;
</cfquery>

<!---
<cflog text="UPDATE folderdata fields #(GetTickCount() - a_tc_begin)#" type="Information" log="Application" file="ib_mailspeed">
--->

<!---<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="edit status #arguments.username# #arguments.uid#" type="html">
	<cfdump var="#arguments#">
	<cfdump var="#q_select_dummy#">
</cfmail>--->
