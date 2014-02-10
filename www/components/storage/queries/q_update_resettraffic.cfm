<!---

created:         2004-02-01
author:      $Author: hansjp $
header:      
changed:     $Date: 2006/10/04 14:38:43 $
modul name:      Storage
description: Reset the Traffic Table


<io>
<in>
</in>
<out>
</out>
</io> 

--->


<cfquery name="q_update_traffic" datasource="#request.a_str_db_tools#">
	UPDATE
		trafficlimits
	SET
		kbused = 0
	;
</cfquery>
