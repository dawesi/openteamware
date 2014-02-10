<!--- //

	Component:	User
	Functino:	GetShortestPossibleUserIDByEntrykey
	Description:Return shortest possible id (id code or username without domain)
	

// --->

<cfquery name="q_select_shortest_possible_userid_by_entrykey" datasource="#request.a_Str_db_users#">
SELECT
	username,identificationcode
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

<cfif Len(q_select_shortest_possible_userid_by_entrykey.identificationcode) GT 0>
	<cfset sReturn = q_select_shortest_possible_userid_by_entrykey.identificationcode>
<cfelse>
	<cfset sReturn = Mid(q_select_shortest_possible_userid_by_entrykey.username, 1, FindNoCase('@', q_select_shortest_possible_userid_by_entrykey.username)-1)>
</cfif>


