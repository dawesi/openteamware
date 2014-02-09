<cfparam name="url.jobkey" type="string" default="">

<cfquery name="q_select_status" datasource="#request.a_str_db_tools#">
SELECT
	hostsignerror,hotsigninfomsg,hotsignxml
FROM
	securemail_jobinfo
WHERE
	jobkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.jobkey#">
;
</cfquery>

<cfif q_select_status.recordcount IS 0>
<result>
	<hotsignresponsenumber>-1</hotsignresponsenumber>
	<hotsignmsg>in Bearbeitung ...</hotsignmsg>
	<hotsignxml></hotsignxml>
	<signcert></signcert>
</result>
<cfelse>
<result>
	<hotsignresponsenumber><cfoutput>#q_select_status.hostsignerror#</cfoutput></hotsignresponsenumber>
	<hotsignmsg><cfoutput>#xmlformat(q_select_status.hotsigninfomsg)#</cfoutput></hotsignmsg>
	<hotsignxml><cfoutput>#xmlformat(q_select_status.hotsignxml)#</cfoutput></hotsignxml>
	<signcert></signcert>
</result>
</cfif>