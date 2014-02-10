<!--- //

	Module:		
	Action:		Select the folders
	Description:	
	

// --->
<cfquery name="q_select_mailspeed_folders" datasource="#request.a_str_db_email#">
SELECT
	folders.foldername AS fullfoldername,
	'' AS foldername,
	folders.messagecount AS messagescount,
	folders.unreadmessagecount AS unreadmessagescount,
	'' AS fullparentfoldername,
	'' AS parentfoldername,
	folders.listlen_foldername AS level
FROM
	folders
WHERE
	folders.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(a_int_userid)#">
ORDER BY
	UPPER(folders.foldername)
;
</cfquery>

<!--- manipulate query in order to make it the same as the IMAP query --->
<cfloop query="q_select_mailspeed_folders">

	<cfset a_int_listlen_foldername = q_select_mailspeed_folders.level />
	
	<cfif Compare(q_select_mailspeed_folders.level, 1) IS 0>
		<!--- this is the INBOX folder --->
		<cfset a_str_foldername = 'INBOX' />
		<cfset a_str_parentfoldername = '' />
		<cfset a_str_fullparentfoldername = '' />
	<cfelse>
		<cfset a_str_foldername = ListGetAt(q_select_mailspeed_folders.fullfoldername, a_int_listlen_foldername, '.') />
		<cfset a_str_parentfoldername = ListGetAt(q_select_mailspeed_folders.fullfoldername, (a_int_listlen_foldername - 1), '.') />
		<cfset a_str_fullparentfoldername = Replace(q_select_mailspeed_folders.fullfoldername, '.'&a_str_foldername, '') />
	</cfif>
	

	<!--- set data --->
	<cfset QuerySetCell(q_select_mailspeed_folders, 'foldername', Returnfriendlyfoldername(a_str_foldername), q_select_mailspeed_folders.currentrow) />
	<cfset QuerySetCell(q_select_mailspeed_folders, 'parentfoldername', a_str_parentfoldername, q_select_mailspeed_folders.currentrow) />
	<cfset QuerySetCell(q_select_mailspeed_folders, 'fullparentfoldername', a_str_fullparentfoldername, q_select_mailspeed_folders.currentrow) />
</cfloop>

