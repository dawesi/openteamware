<!---

created:         2004-02-01
author:      $Author: hansjp $
header:      
changed:     $Date: 2006/10/04 14:38:43 $
modul name:      Storage
description: Retreive all Public Dirs.


<io>
<in>
</in>
<out>
<query q_select_subdirectories_publicshared />
</out>
</io> 

--->

<cfquery name="q_select_subdirectories_publicshared" datasource="#request.a_str_db_tools#">

SELECT 

	'directory' as filetype,entrykey,directoryname as name ,description,

		categories,0 as filesize,'' as contenttype,directories.userkey,

		filescount,0 as specialtype,publicshares.password,
		0 as shared,dt_lastmodified

FROM

	directories,publicshares

WHERE

	publicshares.directorykey = directories.entrykey 

ORDER BY

	filetype,name





;

</cfquery>