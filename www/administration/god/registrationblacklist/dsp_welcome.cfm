<cfquery name="q_select_items" datasource="#request.a_str_db_users#">
SELECT
	*
FROM
	registrationblacklist
;
</cfquery>

<cfdump var="#q_select_items#">

<form action="default.cfm?action=add" method="post">
Adresse (oder Teil): <input type="text" name="frmaddress" size="25"> <input type="submit" value="Add">
</form>