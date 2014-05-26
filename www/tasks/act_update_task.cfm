<!--- updaten und zur�ckkehren --->
<cfinclude template="../common/scripts/script_utils.cfm">


<cfparam name="form.frmworkgroupkey" type="string" default="">

<cfinclude template="queries/q_update_task.cfm">

<!--- calculate redirect url --->
<cfif Len(form.frmReturnURL) is 0>
	<cfset a_str_redirect_url = "index.cfm?action=ShowTask&id="&val(form.frmID)>
<cfelse>
	<cfset a_str_redirect_url = urldecode(form.frmReturnURL)>
</cfif>

<!--- redirect --->
<cflocation addtoken="No" url="#a_str_redirect_url#">