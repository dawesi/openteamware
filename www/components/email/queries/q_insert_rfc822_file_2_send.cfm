<!--- //

	Module:		Email
	Function:	
	Description: 
	

// --->

<cfquery name="q_insert_rfc822_file_2_send" datasource="#request.a_str_db_mailusers#">
INSERT INTO
	inbox_smtp_pl
	(
	RFC822_FILENAME,
	ENTRYKEY
	)
VALUES
	(
	<cfqueryparam cfsqltype="RFC822_FILENAME" value="#GetFileFromPath(arguments.filename)#">,
	<cfqueryparam cfsqltype="ENTRYKEY" value="#a_str_key#">

	)
;
</cfquery>

