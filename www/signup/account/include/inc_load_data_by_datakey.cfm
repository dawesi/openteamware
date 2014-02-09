<cfquery name="q_select_saved_data" datasource="#request.a_str_db_users#">
SELECT
	firstname,
	surname,
	street,
	zipcode,
	city,
	email,
	telnr,
	resellerkey
FROM
	signup_saved_data
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.datakey#">
;
</cfquery>

<cfset session.a_struct_data.firstname = q_select_saved_data.firstname>
<cfset session.a_struct_data.surname = q_select_saved_data.surname>
<cfset session.a_struct_data.street = q_select_saved_data.street>
<cfset session.a_struct_data.zipcode = q_select_saved_data.zipcode>
<cfset session.a_struct_data.city = q_select_saved_data.city>
<cfset session.a_struct_data.telephone = q_select_saved_data.telnr>
<cfset session.a_struct_data.external_email = q_select_saved_data.email>
<cfset session.a_struct_data.source = 'a1_signup'>

<!--- set the resellerkey --->
<cfif Len(q_select_saved_data.resellerkey) GT 0>
	<cfset request.a_str_resellerkey = q_select_saved_data.resellerkey>
	<cfset cookie.IB_AFFLIATE_KEY = q_select_saved_data.resellerkey>
</cfif>