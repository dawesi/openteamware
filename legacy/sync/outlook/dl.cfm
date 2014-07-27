<cfabort>

<!--- just a test --->


<cfquery name="q_select_data" datasource="#request.a_Str_db_sync#">
SELECT
	filedata
FROM
	outlooksettings
WHERE
	id = 113056
;
</cfquery>


<cfset a_str_filedata = q_select_data.filedata>

<cfset sFilename_Destination = request.a_str_temp_dir_outlooksync_settings&"dl_"&CreateUUID()&".gz">

<!--- write file ... --->
<cffile action="write" file="#sFilename_Destination#" output="#ToBinary(a_str_filedata)#" addnewline="no">

<!--- and deliver ... --->
<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="sFilename_Destination" type="html" mimeattach="#sFilename_Destination#">
123
</cfmail>