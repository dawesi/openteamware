<!--- Routine for delivering file downloads --->

<cfparam name="url.filename" type="string" default="">
<cfparam name="url.contenttype" type="string" default="">
<cfparam name="url.source" type="string" default="">
<cfparam name="url.local" type="boolean" default="false">
<cfparam name="url.dl_entrykey" type="string" default="">

<cfset a_str_lb = Chr(13) & Chr(10) />

<!--- replace all invalid chars in filename ... --->
<cfset sFilename = ReReplaceNoCase(url.filename, '[^a-z,ä,ö,ü,0-9,.,_, ,\-,!,"]*', '', 'ALL') />

<cfif Len(url.contenttype) IS 0>
	<cfset a_str_contenttype = 'binary/unknown' />
<cfelse>
	<cfset a_str_contenttype = url.contenttype />
</cfif>

<cfif Len(sFilename) IS 0>
	<cfset sFilename = 'file' />
</cfif>

<cfif Len(url.dl_entrykey) GT 0>

	<cfquery name="q_select_dl_link">
	SELECT
		filelocation
	FROM
		download_links
	WHERE
		entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.dl_entrykey#">
	;
	</cfquery>

	<cfheader name="Content-disposition" value="attachment;filename=""#sFilename#""">

	<cfcontent type="#a_str_contenttype#"
			   file="#q_select_dl_link.filelocation#"
			   deletefile="No">
<cfelse>

	<cfif url.local>
		<!--- local temp directory --->
		<cfset sSourceFile = request.a_str_temp_directory_local & request.a_str_dir_separator & url.source />
	<cfelse>
		<!--- global temp directory --->
		<cfset sSourceFile = request.a_str_temp_directory & request.a_str_dir_separator & url.source />
	</cfif>

	<cfif NOT FileExists(sSourceFile)>
		<h1>file does not exist</h1>
		<cfabort>
	</cfif>

	<cfheader name="Content-disposition" value="attachment;filename=""#sFilename#""">

	<cfcontent type="#url.contenttype#"
			   file="#sSourceFile#"
			   deletefile="Yes">

</cfif>
