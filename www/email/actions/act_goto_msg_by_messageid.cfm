<!--- //

	Module:		Email
	Action:		GotoMessageByMessageID
	Description:Open a message by it's message ID
	

	
	
	Try to use mailspeed if possible
	
// --->

<cfparam name="url.messageid" type="string" default="">

<cfset url.messageid = ReplaceNoCase(url.messageid, '<', '') />
<cfset url.messageid = ReplaceNoCase(url.messageid, '>', '') />

<cfif Val(request.appsettings.properties.mailspeedenabled) IS 1>

	<cfquery name="q_select_email_data" datasource="#request.a_str_db_email#">
	SELECT
		foldername,uid
	FROM
		folderdata
	WHERE
		userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">
		AND
		messageid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.messageid#">
	;
	</cfquery>
	
	<cfif q_select_email_data.recordcount GT 0>
		<cflocation addtoken="no" url="/email/default.cfm?action=showmessage&id=#q_select_email_data.uid#&mailbox=#htmleditformat(q_select_email_data.foldername)#&popup=1">
	<cfelse>
		This messages does not exist on the server any more.
		<br />
		<a href="javascript:window.close();">Close Window</a>
	</cfif>
<cfelse>

	<!--- execute search operation ... --->
	
	<!--- TODO hp ... --->

</cfif>

