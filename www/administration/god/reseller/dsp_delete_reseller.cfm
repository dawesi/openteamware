<cfparam name="url.entrykey" type="string">
<cfparam name="url.confirmed" type="boolean" default="false">

<cfquery name="q_select_reseller" datasource="#request.a_str_db_users#">
SELECT
	*
FROM
	reseller
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.entrykey#">
;
</cfquery>

<cfif q_select_reseller.recordcount IS 0>
	#404
	<cfabort>
</cfif>

<h4>Reseller: <cfoutput>#q_select_reseller.companyname#</cfoutput></h4>

<cfif url.confirmed>
	<!--- delete --->
	
	<cfwddx action="cfml2wddx" input="#q_select_reseller#" output="a_str_wddx">
		
	<cfquery name="q_insert_old_resellers" datasource="#request.a_str_db_users#">
	INSERT INTO
		oldresellers 
		(
		createdbyuserkey,
		companyname,
		dt_created,
		wddx,
		entrykey
		)
	VALUES
		(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_reseller.companyname#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
		<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#a_str_Wddx#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_reseller.entrykey#">
		)
	;
	</cfquery>
	
	<cfquery name="q_delete_reseller" datasource="#request.a_str_Db_users#">
	DELETE FROM
		reseller
	WHERE
		entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.entrykey#">
	;
	</cfquery>
	
	deleted.

<cfelse>

	<cfquery name="q_Select_customers" datasource="#request.a_str_db_users#">
	SELECT
		companyname,customerid
	FROM
		companies
	WHERE
		resellerkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.entrykey#">
	;
	</cfquery>
	
	<fieldset>
		<legend>Customers (<cfoutput>#q_Select_customers.recordcount#</cfoutput>)</legend>
		<cfoutput query="q_Select_customers">
			#q_Select_customers.companyname# (#q_Select_customers.customerid#)
		</cfoutput>
		
		<cfif q_Select_customers.recordcount GT 0>
			<br><br>
			still customers!!
			<br><br>
			Cannot delete!!
			<cfabort>
		<cfelse>
			&nbsp;
		</cfif>		
	</fieldset>
	

	<br><br>
	<!--- query --->
	<fieldset>
	<legend>Frage</legend>
	Are you sure that you want to delete this reseller?
	<br><br><br>
	<a href="<cfoutput>#cgi.SCRIPT_NAME#?#cgi.QUERY_STRING#&confirmed=true</cfoutput>">Yes, I am sure</a>
	&nbsp;&nbsp;|&nbsp;&nbsp;
	<a href="<cfoutput>#cgi.HTTP_REFERER#</cfoutput>">No</a>
	<br><br><br>
	</fieldset>
</cfif>
