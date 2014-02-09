
<cfinclude template="../login/check_logged_in.cfm">

<cfparam name="form.frmcbtasks" type="string" default="">
<cfparam name="form.frmsetstatus" type="string" default="done">

<cfif Len(form.frmcbtasks) IS 0>
	<cflocation addtoken="no" url="default.cfm">
</cfif>

<cfif IsDefined("form.frmsubmitdelete")>
	<!--- delete ... --->
	
	<cfloop list="#form.frmcbtasks#" delimiters="," index="sEntrykey">
	
		<cfinvoke component="#application.components.cmp_tasks#" method="DeleteTask" returnvariable="a_bol_return">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
			<cfinvokeargument name="entrykey" value="#sEntrykey#">
		</cfinvoke>
	</cfloop>
	
	<cflocation addtoken="no" url="#ReturnRedirectURL()#">
	
</cfif>

<cfif IsDefined('form.frmprintversion')>
	
	<cflocation addtoken="no" url="default.cfm?action=printversion&entrykeys=#urlencodedformat(form.frmcbtasks)#">
</cfif>

<cfif IsDefined("form.frmsubmitsetstatus")>
	<!--- set status --->
	
	<cfswitch expression="#form.frmsetstatus#">
		<cfcase value="done">
			<cfset a_str_new_status = 0>
		</cfcase>
		<cfdefaultcase>
			<cfset a_str_new_status = 1>
		</cfdefaultcase>
	</cfswitch>
	
	<cfset stUpdate = StructNew()>
	<cfset stUpdate.status = a_str_new_status>
	
	<cfloop list="#form.frmcbtasks#" delimiters="," index="sEntrykey">
		
		<cfinvoke component="#application.components.cmp_tasks#" method="UpdateTask" returnvariable="a_bol_return">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="entrykey" value="#sEntrykey#">
			<cfinvokeargument name="newvalues" value="#stUpdate#">
		</cfinvoke>
		
	</cfloop>
	
	<cflocation addtoken="no" url="#ReturnRedirectURL()#">
</cfif>