<!--- 

	

	send the gzipped version of a csv table back to the client

	

	we do not use session management here because it is possible that

	the user is not logged in on the frontend

	

	the only identifier is the program_id

	

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
<cfparam name="form.datatype" default="0" type="numeric">

<cfif NOT DirectoryExists(request.a_str_temp_dir_outlooksync_settings)>
  <cfdirectory directory="#request.a_str_temp_dir_outlooksync_settings#" action="create">
</cfif>

<cfset a_int_datatype = val(form.datatype)>

<cfset sFilename_Destination = request.a_str_temp_dir_outlooksync_settings&"dl_"&CreateUUID()&".gz">

<cfquery datasource="#request.a_str_db_tools#" name="q_select_data">
SELECT
	filedata
FROM
	outlooksettings
WHERE 
	(program_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.program_id#">)
	AND
	(datatype = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_datatype#">)
	AND
	(userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.stSecurityContext.myuserkey#">)
; 
</cfquery>

<cfset a_str_filedata = q_select_data.filedata>

<!--- write file ... --->
<cffile action="write" file="#sFilename_Destination#" output="#ToBinary(a_str_filedata)#" addnewline="no">

<!--- and deliver ... --->
<cfcontent type="application/x-gzip-compressed" file="#sFilename_Destination#" deletefile="yes">