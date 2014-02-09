

<cfparam name="GetNumberofcustomersRequest.companykey" type="string" default="">

<cfquery name="q_select_number_of_customers" datasource="#request.a_Str_db_users#">
SELECT COUNT(userid) AS count_id FROM users
WHERE companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GetNumberofcustomersRequest.companykey#">;
</cfquery>