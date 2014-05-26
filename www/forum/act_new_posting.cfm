
<cfinclude template="../login/check_logged_in.cfm">

<cfparam name="form.frmcb_alert_on_change" type="numeric" default="0">
<cfparam name="form.frmpostingkey" type="string" default="">

<cfif cgi.REQUEST_METHOD NEQ 'POST'>
	<cflocation addtoken="no" url="#ReturnRedirectURL()#">
</cfif>

<cfif Len(trim(form.frmbody)) IS 0>
	<cflocation addtoken="no" url="#ReturnRedirectURL()#">
</cfif>

<cfset a_cmp_forum = CreateObject('component', request.a_str_component_forum)>

<cfif Len(form.frmpostingkey) IS 0>
	<!--- new posting --->
	<cfinvoke component="#a_cmp_forum#" method="CreatePosting" returnvariable="a_bol_return">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		<cfinvokeargument name="forumkey" value="#form.frmforumkey#">
		<cfinvokeargument name="entrykey" value="#form.frmentrykey#">
		<cfinvokeargument name="subject" value="#form.frmsubject#">
		<cfinvokeargument name="body" value="#form.frmbody#">
		<cfinvokeargument name="parentpostingkey" value="#form.frmreplytopostingkey#">
		<cfinvokeargument name="priority" value="3">
	</cfinvoke>
	
	<cfif form.frmcb_alert_on_change IS 1>
	
		<cfif Len(form.frmreplytopostingkey) GT 0>
			<cfset a_str_threadkey = form.frmreplytopostingkey>
		<cfelse>
			<cfset a_str_threadkey = form.frmentrykey>
		</cfif>
		
		<cfinvoke component="#a_cmp_forum#" method="CreateOnChangeAlert" returnvariable="a_bol_return_2">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="forumkey" value="#form.frmforumkey#">
			<cfinvokeargument name="threadkey" value="#a_str_threadkey#">
		</cfinvoke>
	</cfif>
<cfelse>
	<!--- editing posting ... --->
	<cfinvoke component="#a_cmp_forum#" method="UpdatePosting" returnvariable="a_bol_return">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		<cfinvokeargument name="forumkey" value="#form.frmforumkey#">
		<cfinvokeargument name="entrykey" value="#form.frmpostingkey#">
		<cfinvokeargument name="body" value="#form.frmbody#">
	</cfinvoke>
</cfif>

<!--- redirect --->
<cfif Len(form.frmreplytopostingkey) GT 0>
	<cflocation addtoken="no" url="index.cfm?action=ShowThread&forumkey=#form.frmforumkey#&entrykey=#urlencodedformat(form.frmreplytopostingkey)#">
<cfelse>
	<cflocation addtoken="no" url="index.cfm?action=ShowForum&forumkey=#form.frmforumkey#&entrykey=#urlencodedformat(form.frmforumkey)#">
</cfif>