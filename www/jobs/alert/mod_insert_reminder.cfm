<!--- //



	create entry for the  reminder

	

	// --->

<cfparam name="attributes.userid" type="numeric" default="0">

<cfparam name="attributes.lastfrom" type="string" default="">

<cfparam name="attributes.lastsubject" type="string" default="">



<cfinclude template="/common/scripts/script_utils.cfm">

	

<cfquery name="q_select_entry_exists" datasource="#request.a_str_db_tools#">

SELECT userid FROM reminderalerts

WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.userid#">;

</cfquery>



<!--- if no item exists, insert now ... --->

<cfif q_select_entry_exists.recordcount is 0>



	<cfquery name="q_select_entry_exists" datasource="#request.a_str_db_tools#">

	INSERT INTO reminderalerts

	(userid,dt_insert,newmailcount,lastfrom,lastsubject)

	VALUES

	(<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.userid#">,

	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(GetUTCTime(now()))#">,

	1,

	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Mid(attributes.lastfrom, 1, 250)#" maxlength="250">,

	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Mid(attributes.lastsubject, 1, 250)#" maxlength="250">

	);

	</cfquery>

<cfelse>

	<!--- execute an update ... --->

	<cfquery name="q_update" datasource="#request.a_str_db_tools#">

	UPDATE reminderalerts

	SET newmailcount = newmailcount + 1,

	lastfrom = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mid(attributes.lastfrom, 1, 250)#" maxlength="250">,

	lastsubject = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mid(attributes.lastsubject, 1, 250)#" maxlength="250">,

	dt_insert = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(GetUTCTime(now()))#">

	WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.userid#">;

	</cfquery>	

</cfif>