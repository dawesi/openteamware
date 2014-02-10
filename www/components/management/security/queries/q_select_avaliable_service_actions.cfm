	<!--- //

	Module:		Security
	Description: load avaliable service actions ...
	

// --->
	
<cfparam name="SelectavaliabelServiceActions.entrykey" type="string" default="">


<cfquery name="q_select_avaliable_service_actions" datasource="#request.a_str_db_users#" cachedwithin="#CreateTimeSpan(0,1,0,0)#">
SELECT
	servicekey,actionname,entrykey,parentkey
FROM
	avaliableactions

	<cfif len(SelectavaliabelServiceActions.entrykey) gt 0>
	WHERE
		servicekey = '#SelectavaliabelServiceActions.entrykey#'
	</cfif>
;
</cfquery>

