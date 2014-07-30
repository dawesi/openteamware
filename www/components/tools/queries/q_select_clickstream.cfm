



<cfquery name="q_select_clickstream">
SELECT
	href,pagename,servicekey
FROM
	clickstream
WHERE
	(userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectClickStreamRequest.userkey#">)
ORDER BY
	dt_click DESC
LIMIT #SelectClickStreamRequest.maxrows#
;
</cfquery>



<!--- array of structures erstellen und inserten ... --->



<!---<cfset a_arr_path = ArrayNew(1)>



<cfset ArraySet(a_arr_path, 1, q_select_clickstream.recordcount, StructNew())>



<cfloop query="q_select_clickstream">

	<cfset a_arr_path[q_select_clickstream.recordcount - q_select_clickstream.currentrow +1].href = q_select_clickstream.href>

	<cfset a_arr_path[q_select_clickstream.recordcount - q_select_clickstream.currentrow +1].pagename = q_select_clickstream.pagename>

</cfloop>--->



<!---<cfquery name="q_select_clickstream" dbtype="query">

SELECT href,pagename FROM q_select_clickstream

ORDER BY dt_click;

</cfquery>--->