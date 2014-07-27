<!---

created:         2004-02-01
author:      $Author: hansjp $
header:      
changed:     $Date: 2007-06-24 10:02:20 $
modul name:      Storage
description: Update the Traffic Table

--->

<cfquery name="q_select_traffic" datasource="#request.a_str_db_tools#">
SELECT 
	kbused,
	kblimit
FROM 
	trafficlimits
WHERE 
	userkey = <cfqueryparam value="#UpdateTraffic.userkey#" cfsqltype="cf_sql_varchar">
;
</cfquery>

<cfif q_select_traffic.recordcount LTE 0>
	
	<cfquery name="q_insert_traffic" datasource="#request.a_str_db_tools#">
	INSERT INTO 
		trafficlimits
		
		(userkey,kblimit,kbused)
	VALUES
		(<cfqueryparam value="#UpdateTraffic.userkey#" cfsqltype="cf_sql_varchar">,
		<cfqueryparam value="#a_int_storage_max_traffic#" cfsqltype="cf_sql_bigint">,
		<cfqueryparam value="0" cfsqltype="cf_sql_bigint">
		)
	;
	</cfquery>
	
</cfif>


<cfquery name="q_update_traffic" datasource="#request.a_str_db_tools#">
UPDATE
	trafficlimits
SET
	kbused = kbused + <cfqueryparam value="#UpdateTraffic.kbused#" cfsqltype="cf_sql_bigint">
WHERE 
	userkey = <cfqueryparam value="#UpdateTraffic.userkey#" cfsqltype="cf_sql_varchar">
;
</cfquery>

<!---
	$Log: q_update_traffic.cfm,v $
	Revision 1.3  2007-06-24 10:02:20  hansjp
	new default comment

	--->
