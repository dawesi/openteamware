<cfparam name="form.frmuserkey" type="string">
<cfparam name="form.frmsecretarykey" type="string">

<cfif CompareNoCase(form.frmsecretarykey, form.frmuserkey) IS 0>
	Secreatary and managed user must be differnt users!
	<cfabort>
</cfif>

<cfinvoke component="/components/management/workgroups/cmp_secretary" method="CreateSecretaryEntry" returnvariable="a_bol_return">
	<cfinvokeargument name="userkey" value="#form.frmuserkey#">
	<cfinvokeargument name="secretarykey" value="#form.frmsecretarykey#">
	<cfinvokeargument name="companykey" value="#form.frmcompanykey#">
	<cfinvokeargument name="createdbyuserkey" value="#request.stSecurityContext.myuserkey#">				
	<cfinvokeargument name="permission" value="#form.frmcb_permission#">
</cfinvoke>

<!--- write emails to the users ... --->


<cflocation addtoken="no" url="../default.cfm?action=workgroups#writeurltagsfromform()#">