<!--- //

	Module:		Exec once a day
	Description: 
	

// --->

<cfquery name="q_update_traffic_limits" datasource="#request.a_str_db_tools#">
UPDATE
	trafficlimits
SET
	kbused = 0
;
</cfquery>

