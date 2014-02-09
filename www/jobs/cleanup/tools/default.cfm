<!---

	cleanup tools database

--->

<cfquery name="q_delete_dl_links" datasource="#request.a_str_db_tools#">
DELETE FROM
	download_links
;
</cfquery>