<!--- //

	Module:		E-Mail
	Action:		ShowMailBoxContent
	Description: 
	

// --->


<cfparam name="url.order" default="received" type="string">
<cfparam name="url.desc" default="1" type="numeric">
<cfparam name="url.restrict" default="" type="string">

<cfset a_int_original_recordcount = q_select_mailbox.recordcount>

<cfif url.desc is "1">
  <cfset a_str_desc_link = "&desc=0">
  <cfelse>
  <cfset a_str_desc_link = "&desc=1">
</cfif>

<cfif isdefined("url.debugmode")>
  <cfdump var="#q_select_mailbox#">
</cfif>

<cfset a_str_restrict = url.restrict>

<cfset a_str_restrict_param = "">

<!--- check if a parameter is included ... --->
<cfif FindNoCase("-", a_str_restrict) gt 0>
  <cfset a_str_restrict = Mid(url.restrict, 1, findnocase("-", url.restrict)-1)>
  <cfset a_str_restrict_param = Mid(url.restrict, findnocase("-", url.restrict)+1, len(url.restrict))>
</cfif>


	<cftry>
	<cfquery name="q_select_mailbox" dbtype="query">
	SELECT
		afrom,ato,date_local,flagged,subject,id,asize,account,contenttype,priority, 
		unread,attachments,answered,foldername,prim_key,
		afromemailaddressonly
		<cfif ListFindNoCase(q_select_mailbox.columnlist, 'message_age_days') GT 0>
		,message_age_days
		</cfif>
		<cfif ListFindNoCase(q_select_mailbox.columnlist, 'shortbody') GT 0>
		,shortbody
		</cfif>
		
	FROM
		q_select_mailbox 
	<cfswitch expression="#a_str_restrict#">
	  <cfcase value="fromknownpersons">
	  <!--- only from known persons ... --->
		<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#request.stUserSettings#">	
		</cfinvoke>
		
		<cfset q_select_contacts = stReturn.q_select_contacts>
	  WHERE
		(upper(afromemailaddressonly) IN (
			<cfoutput query="q_select_contacts">
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(q_select_contacts.email_prim)#">,
			</cfoutput>
			'#request.stSecurityContext.myusername#')) 
	  </cfcase>
	  <cfcase value="fromunknownpersons">
	  <!--- only from known persons ... --->
	 <cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#request.stUserSettings#">	
		</cfinvoke>
		
		<cfset q_select_contacts = stReturn.q_select_contacts>
		
	  WHERE NOT
		(upper(afromemailaddressonly) IN (
			<cfoutput query="q_select_contacts">
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(q_select_contacts.email_prim)#">,
			</cfoutput>
			'#request.stSecurityContext.myusername#')) 
	  </cfcase>
	  <cfcase value="recent">
	  <!--- recent messages --->
	  <cfset a_dt_recent = DateAdd("d", -5, now())>
	  WHERE (dt_local_number > 
	  <cfqueryparam cfsqltype="cf_sql_integer" value="#dateformat(a_dt_recent, "yyyymmdd")#">
	  ) 
	  </cfcase>
	  <cfcase value="unread">
	  <!--- unread messages only --->
	  WHERE (unread = 1) 
	  </cfcase>
	  <cfcase value="flagged">
	  <!--- flagged messages --->
	  WHERE (flagged = 1) 
	  </cfcase>
	  <cfcase value="withattachments">
	  <!--- with attachments ... --->
	  WHERE (attachments > 0) 
	  </cfcase>
	  <cfcase value="junkmail">
	  WHERE (subject IS NOT NULL) AND (subject LIKE '**** Spam%') 
	  </cfcase>
	  <cfcase value="account">
	  <!--- restrict by original account ... --->
	  WHERE (account IS NOT NULL) AND (account = '#a_str_restrict_param#') 
	  </cfcase>
	</cfswitch>
	ORDER BY 
	<cfswitch expression="#url.order#">
	  <cfcase value="size">
	  asize 
	  </cfcase>
	  <cfcase value="from">
	  afrom 
	  </cfcase>
	  <cfcase value="to">
	  ato 
	  </cfcase>
	  <cfcase value="subject">
	  subject 
	  </cfcase>
	  <cfdefaultcase>
	  date_local 
	  </cfdefaultcase>
	</cfswitch>
	<cfif url.desc is 1>
	  DESC
	</cfif>
	; 
	</cfquery>
	
	<!---<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="display mbox" type="html">
		<cfdump var="#url#">
	</cfmail>--->
	
	<cfcatch type="any">
	<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="mbox restrict select error" type="html">
	#a_str_restrict#
	<cfdump var="#cfcatch#">
	<cfdump var="#q_select_mailbox#">
	<cfdump var="#request#">
	<cfdump var="#cgi#">
	</cfmail>
	</cfcatch>
	</cftry>


