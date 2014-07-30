<!--- //

	Component:	SQL
	Function:	InsertRecord
	Description:call the insert SQL command


// --->

<cfquery name="q_insert_data">
INSERT INTO
	#arguments.table#
	(
	<cfloop from="1" to="#ArrayLen(a_arr_data)#" index="ii">
		#a_arr_data[ii].fieldname#
		<cfif ii LT ArrayLen(a_arr_data)>,</cfif>
	</cfloop>
	)
VALUES
	(
	<cfloop from="1" to="#ArrayLen(a_arr_data)#" index="ii">
		<cfqueryparam cfsqltype="#a_arr_data[ii].cfmxtype#" value="#a_arr_data[ii].data#">
		<cfif ii LT ArrayLen(a_arr_data)>,</cfif>
	</cfloop>
	)
;
</cfquery>

