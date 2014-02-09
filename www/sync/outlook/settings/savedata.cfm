<?xml version="1.0" encoding="utf-8"?>
<!--- 

	

	receive the uploaded csv table in gzipped format

	

	<io>

		<in>

		<param scope="form" name="program_id" type="string" default="">

				<description>

				the program id ... (unique id)

				</description>

		</param>

		<param scope="form" name="datatype" type="numeric" default="0">

				<description>

				the tabletype

				1 folders ... the folders

				2 ibccitems ... the known openTeamWare items

				3 ignoreitems ... items to ignore

				4 outlookitems ... items in outlook created from openTeamWare			

				</description>

		</param>				

		</in>

	</io>

	

	--->
<cfparam name="form.program_id" default="" type="string">
<cfparam name="form.datatype" default="" type="string">

<cfif NOT StructKeyExists(session, 'stSecurityContext')>
	<cfabort>
</cfif>

<!---
	
	old value ... replace now with local temp directory
	<cfset sFilename_Destination = request.a_str_temp_dir_outlooksync_settings & CreateUUID()&".gz">

--->

<cfset sFilename_destination = request.a_str_temp_directory_local & CreateUUID()&".gz">

<!--- get file --->
<cffile action="upload" filefield="filename" destination="#sFilename_destination#" nameconflict="makeunique">

<!--- read file --->
<cffile action="readbinary" file="#sFilename_destination#" variable="a_str_data">

<cfset a_int_datatype = val(form.datatype)>

<!--- delete old and insert new ... --->
<cfquery datasource="#request.a_str_db_tools#" name="q_delete_old_data">
DELETE FROM
	outlooksettings
WHERE
	(userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.stSecurityContext.myuserkey#">)
	AND
	(program_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.program_id#">)
	AND
	(datatype = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_datatype#">)
; 
</cfquery>

<cfquery name="q_insert_data" datasource="#request.a_str_db_tools#">
INSERT INTO
	outlooksettings
	(
	userkey,username,filedata,dt_created,dt_lastrequested,datatype,program_id
	) 
	VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.stSecurityContext.myuserkey#">, 
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.stSecurityContext.myuserid#">,
	'#tobase64(a_str_data)#', 
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())#">, 
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())#">, 
	<cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_datatype#">, 
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.program_id#">
	)
; 
</cfquery>
<result/>