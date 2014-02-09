<!--- //

	update a status
	
	// --->
	
<cfinclude template="../login/check_logged_in.cfm">

<cfparam name="url.entrykey" type="string" default="">
<cfparam name="url.status" type="numeric" default="0">

<cfset stUpdate = StructNew()>
<cfset stUpdate.status = url.status>

<cfinvoke component="#application.components.cmp_tasks#" method="UpdateTask" returnvariable="a_bol_return">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
	<cfinvokeargument name="newvalues" value="#stUpdate#">
</cfinvoke>

<cfif NOT a_bol_return>

	<!--- inform owner that user wanted to set this task to done ... --->
	<cfinvoke component="#application.components.cmp_tasks#" method="GetTask" returnvariable="stReturn">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		<cfinvokeargument name="entrykey" value="#url.entrykey#">
	</cfinvoke>
	
	<cfset a_str_userkey = stReturn.q_select_task.userkey>
	<cfset a_str_title = stReturn.q_select_task.title>
	
	<!--- load userdata ... --->
	<cfset a_str_username = application.components.cmp_user.GetUsernamebyentrykey(a_str_userkey)>
	
<cfset a_str_mail_subject = GetLangVal('tsk_ph_mail_task_done')>
<cfset a_str_mail_subject = ReplaceNoCase(a_str_mail_subject, '%TITLE%', a_str_title)>
<cftry>
<cfset a_str_mail_body = GetLangVal('tsk_ph_mail_task_done_body')>
<cfset a_str_mail_body = ReplaceNoCase(a_str_mail_body, '%TITLE%', a_str_title)>
<cfset a_str_mail_body = ReplaceNoCase(a_str_mail_body, '%ENTRYKEY%', urlencodedformat(url.entrykey))>
<cfset a_str_mail_body = ReplaceNoCase(a_str_mail_body, '%USER%', request.a_struct_personal_properties.myfirstname&' '&request.a_struct_personal_properties.mysurname)>

<cfmail from="#request.stSecurityContext.myusername#" to="#a_str_username#" subject="#htmleditformat(a_str_mail_subject)#">
#a_str_mail_body#
</cfmail>
<cfcatch type="any"> </cfcatch></cftry>

	<html>
		<head></head>
		<body>
			
		
			<script type="text/javascript">
				alert('<cfoutput>#JsStringformat(GetLangVal('tsk_ph_hint_creator_informed'))#</cfoutput>');
				history.go(-1);
			</script>
		</body>
	</html>
	<cfabort>
</cfif>


<cflocation addtoken="no" url="#ReturnRedirectURL()#">