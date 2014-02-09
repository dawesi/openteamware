<!--- //

	Description:   Inserts new record in to inbox_smtp_pl that is read by pearl deamon
	

// --->

<cfparam name="a_str_rcf822_filename" type="string" default=""/>

<cfset a_str_key = CreateUUID() />

<cfquery name="q_insert_new_mail" datasource="#request.a_str_db_mailusers#">
INSERT INTO
	inbox_smtp_pl
	(
	RFC822_FILENAME,
	ENTRYKEY
	)
VALUES
	(
	<cfqueryparam cfsqltype="RFC822_FILENAME" value="#a_str_rcf822_filename#">,
	<cfqueryparam cfsqltype="ENTRYKEY" value="#a_str_key#">

	)

</cfquery>

