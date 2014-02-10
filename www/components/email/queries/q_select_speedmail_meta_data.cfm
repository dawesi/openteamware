<!--- //

	Module:		Select data from mailspeed table
	Action:		
	Description:	
	

// --->
<cftransaction isolation="read_committed">
<cfquery name="q_select_speedmail_meta_data" datasource="#request.a_str_db_email#">
<!---SET ENABLE_SEQSCAN TO OFF;--->
SELECT
	folderdata.account AS account,
	folderdata.account AS username,
	folderdata.userid,
	folderdata.afrom,
	folderdata.ato,
	'' AS body_short,
	folderdata.acc AS cc,
	folderdata.contenttype,
	folderdata.foldername,
	folderdata.uid AS id,
	folderdata.messageid,
	folderdata.messagesize AS asize,
	folderdata.priority,
	folderdata.flagged,
	folderdata.subject,
	folderdata.dt_local AS date_local,
	folderdata.dt_local AS date_sender,
	'' AS afromemailaddressonly,
	folderdata.answered,
	(folderdata.seen + 1) AS unread,
	folderdata.attachments,
	(text(folderdata.uid) || '_'::text) || folderdata.foldername::text AS prim_key,
	to_char(folderdata.dt_local, 'YYYYMMDD'::text) AS dt_local_number,
	date_part('day'::text, now() - folderdata.dt_local) AS message_age_days
FROM
	folderdata
WHERE
	folderdata.folderid = <cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_speedmail_folder_sync_status.id#">
ORDER BY
	folderdata.id DESC
;
<!---SET ENABLE_SEQSCAN TO ON;--->
</cfquery>
</cftransaction>

<cfloop query="q_select_speedmail_meta_data">
	<cfset QuerySetCell(q_select_speedmail_meta_data, 'afromemailaddressonly', ExtractEmailAdr(q_select_speedmail_meta_data.afrom), q_select_speedmail_meta_data.currentrow) />
</cfloop>
