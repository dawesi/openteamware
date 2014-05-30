<!--- read the file and add ... --->

<cffile action="readbinary" file="#arguments.filename_on_disk#" variable="a_str_bin_file">

<cfquery name="q_insert_newsletter_attachment">
INSERT INTO
	newsletter_attachments
	(
	entrykey,
	filekey,
	filename,
	contenttype,
	issuekey,
	filecontent
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#sReturn#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filekey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filename#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contenttype#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.issuekey#">,
	'#ToBase64(a_str_bin_file)#'
	)
;
</cfquery>