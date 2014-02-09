	<cfquery name="q_select_resellerkey" datasource="#request.a_str_db_users#">
	SELECT
		resellerkey,customerid
	FROM
		companies
	WHERE
		entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcompanykey#">
	;
	</cfquery>
	
	<cfquery name="q_select_reseller" datasource="#request.a_str_db_users#">
	SELECT
		companyname,street,zipcode,city,telephone,emailadr,customercontact
	FROM
		reseller
	WHERE
		entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_resellerkey.resellerkey#">
	;
	</cfquery>
	
	
<cftry>
<cfmail from="#request.stSecurityContext.myusername#" to="#q_select_reseller.emailadr#" subject="Anfrage von #cgi.HTTP_HOST#">
Date/Time: #Now()#

Customer-ID: #q_select_resellerkey.customerid#

Subject: #form.frmsubject#

Text: #form.frmbody#

Link to the customer: https://#cgi.HTTP_HOST#/administration/
</cfmail>
<cfcatch type="any">
<cfmail from="#request.stSecurityContext.myusername#" to="feedback@openTeamWare.com" subject="Anfrage von #cgi.HTTP_HOST#">
Date/Time: #Now()#

Customer-ID: #q_select_resellerkey.customerid#

Subject: #form.frmsubject#

Text: #form.frmbody#

Link to the customer: https://#cgi.HTTP_HOST#/administration/
</cfmail>
</cfcatch>
</cftry>

<cflocation addtoken="no" url="#ReturnRedirectURL()#&sent=1">