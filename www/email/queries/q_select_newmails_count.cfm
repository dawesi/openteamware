<!--- // select total count of unread emails in the inbox folder // --->

<cfquery name="q_select_count_newmail" dbtype="query">
SELECT unreadmessagescount AS count_newmail_unread FROM request.q_select_folders
WHERE fullfoldername = 'INBOX';
</cfquery>

<cfset request.q_select_count_newmail = q_select_count_newmail>