<!--- //

	Module:		Newsletter
	Description:generate list of subscribers for sending out the newsletter
	
	

// --->


<cfsetting requesttimeout="20000">

<!--- //

	
	
	// --->

<cfinclude template="/common/scripts/script_utils.cfm">

<!--- //

	do we have to prepare a special newsletter?
	
	this is very important for test sendings where we only send
	the first three newsletters to the given addresses in order to
	test if everythings works well
	
	In this case url.isTestSendingCall has to be true and
	url.TestSendingIssueEntrykey has to contain the entrykey of the
	issue to send
	
	// --->
	
<cfparam name="url.isTestSendingCall" type="boolean" default="false">
<cfparam name="url.TestSendingIssueEntrykey" type="string" default="">

<cfquery name="q_select_nl_approved" datasource="#request.a_str_db_crm#" maxrows="1">
SELECT
	*
FROM
	newsletter_issues
WHERE
	(hidden_issue = 0)
	AND

<cfif url.isTestSendingCall AND Len(url.TestSendingIssueEntrykey) GT 0>
	<!--- use the given newsletter issue ... --->
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.TestSendingIssueEntrykey#">
<cfelse>
	<!--- default ... only approved and so on ... --->
	approved = 1
	AND
	prepare_done = 0
	AND
	dt_send < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">
</cfif>
;
</cfquery>

<cfset a_cmp_users = application.components.cmp_user />
<cfset a_cmp_nl = CreateObject('component', request.a_str_component_newsletter) />

<cfif url.isTestSendingCall>
	<!--- test sending ... just return three subscribers --->
	<cfset a_int_max_number_2_return = 3 />
<cfelse>
	<!--- return all subscribers --->
	<cfset a_int_max_number_2_return = 0 />
</cfif>

a_int_max_number_2_return: <cfoutput>#a_int_max_number_2_return#</cfoutput>
<hr size="1" />

<cfoutput query="q_select_nl_approved">

	<!--- get securitycontext and usersettings of user creating the newsletter ... --->
	<cfinvoke component="#application.components.cmp_security#" method="GetSecurityContextStructure" returnvariable="stReturn">
		<cfinvokeargument name="userkey" value="#q_select_nl_approved.createdbyuserkey#">
	</cfinvoke>
	
	<cfset variables.stSecurityContext_nl = stReturn />
	
	<cfinvoke component="#a_cmp_users#" method="GetUsersettings" returnvariable="a_struct_settings">
		<cfinvokeargument name="userkey" value="#q_select_nl_approved.createdbyuserkey#">
	</cfinvoke>
	
	<cfset variables.stUserSettings = a_struct_settings />
	
	<!--- get profile --->
	<cfset q_select_profile = a_cmp_nl.GetNewsletterprofile(securitycontext = variables.stSecurityContext_nl,
											usersettings = variables.stUserSettings,
											entrykey = q_select_nl_approved.listkey) />
	
	<!--- <cfdump var="#q_select_profile#" label="q_select_profile"> --->

	<!--- a) get subscribers ... in test case only the first 3 --->	
	<cfset q_select_subscribers = a_cmp_nl.GetSubscribers(securitycontext = variables.stSecurityContext_nl,
											usersettings = variables.stUserSettings,
											listkey = q_select_nl_approved.listkey,
											maxnumber = a_int_max_number_2_return,
											testrun = url.isTestSendingCall) />
											
	<!--- <cfdump var="#q_select_subscribers#"> --->

	<!--- to be sure ... select only the needed number --->
	<cfif a_int_max_number_2_return GT 0>
		<cfquery maxrows="#a_int_max_number_2_return#" name="q_select_subscribers" dbtype="query">
		SELECT
			*
		FROM
			q_select_subscribers
		;
		</cfquery>
	</cfif>
	<!--- is it a newsletter with dynamic elements / contacts from the addressbook? if true, load contacts now ... --->
	
	<!--- load additional field information ... --->
	<cfswitch expression="#q_select_profile.listtype#">
		<cfcase value="0,2">
			<!--- from address book, load fields of additionaldata - table --->
			<cfinvoke component="#application.components.cmp_crmsales#" method="GetCRMSalesBinding" returnvariable="a_struct_crmsales_bindings">
				<cfinvokeargument name="companykey" value="#variables.stSecurityContext_nl.mycompanykey#">
			</cfinvoke>
			
			
			<!--- create dummy info table --->
			<cfset q_table_fields = QueryNew('fieldname,showname')>
			
		</cfcase>
		<cfcase value="1">
			<!--- simple version ... ignore right now --->
			<cfset q_table_fields = QueryNew('fieldname,showname')>
		</cfcase>
	</cfswitch>
	
	<!--- <cfdump var="#q_select_subscribers#" label="subscribers"> --->
	
	
	<!--- b) generate emails --->
	<cfinclude template="utils/inc_prepare_mail.cfm">
	
	<!--- if no test run, set prepared = true --->
	<cfif NOT url.isTestSendingCall>
		<cfquery name="q_update_prepare_done" datasource="#request.a_str_db_crm#">
		UPDATE
			newsletter_issues
		SET
			prepare_done = 1
		WHERE
			entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_nl_approved.entrykey#">
		;
		</cfquery>
	</cfif>
	
</cfoutput>

