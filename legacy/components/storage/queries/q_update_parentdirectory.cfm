<!---

created:         2004-02-01
author:      $Author: hansjp $
header:      
changed:     $Date: 2006/10/04 14:38:43 $
modul name:      Storage
description: Update the parentdirectory of a file (=Move)


<io>
<in>
<param name="entrykey" scope="arguments" type="string">
<description>
The Entrykey of the Directory
</description>
</param>
<param name="destination_directorykey" scope="arguments" type="string">
<description>
The New Directory
</description>
</param>
</in>
<out>
</out>
</io> 

--->
<cfquery name="q_update_parentdirectory" datasource="#request.a_str_db_tools#">

UPDATE

	storagefiles

SET 

	parentdirectorykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.destination_directorykey#">,
	dt_lastmodified = current_timestamp

WHERE

	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">

</cfquery>

