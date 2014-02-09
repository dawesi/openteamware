<!--- //

	Module:		EMail
	Action:		DisplayBottomShortInfo
	Description:Display short info about new emails in bottom frame ...
	

// --->

<!--- get folders with unread messages ... --->
<cfquery name="q_select_unread_mbox" dbtype="query">
SELECT
	*
FROM
	request.q_select_folders
WHERE
	UNREADMESSAGESCOUNT > 0
	AND
	fullfoldername = 'INBOX'
;			
</cfquery>

<cfif q_select_unread_mbox.recordcount IS 0>
	<cfexit method="exittemplate">
</cfif>

<a href="/email/?action=ShowMailbox&Mailbox=INBOX"><img src="/images/si/email.png" class="si_img" alt="" /> (<cfoutput>#q_select_unread_mbox.unreadmessagescount#</cfoutput>)</a> |


