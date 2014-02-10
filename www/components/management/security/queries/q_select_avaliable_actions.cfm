<!--- //
	select the avaliabel actions
	// --->


<cfparam name="SelectAvaliableAciontions.Serviceid" type="string" default="5220B02E-0133-5B37-F5E6B92CC3B3FC47">

<cfquery name="q_select_avaliable_actions" datasource="#request.a_str_db_users#" cachedwithin="#createtimespan(0,12,0,0)#">
SELECT
	actionname
FROM
	avaliableactions
WHERE
	servicekey = '#SelectAvaliableAciontions.Serviceid#'
;
</cfquery>