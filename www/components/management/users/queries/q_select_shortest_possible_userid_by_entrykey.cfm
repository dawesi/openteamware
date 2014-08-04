<!--- //

	Component:	User
	Functino:	GetShortestPossibleUserIDByEntrykey
	Description:Return shortest possible id (id code or username without domain)


// --->

<cfquery name="q_select_shortest_possible_userid_by_entrykey">
SELECT
	username
FROM
	users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>

<cfif q_select_shortest_possible_userid_by_entrykey.recordcount IS 0>
	<cfset sReturn = '' />
	<cfexit method="exittemplate">
</cfif>

<cfset sReturn = Mid(q_select_shortest_possible_userid_by_entrykey.username, 1, FindNoCase('@', q_select_shortest_possible_userid_by_entrykey.username)-1)>


