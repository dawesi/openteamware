<!--- insert a new task --->

<cfinclude template="../common/scripts/script_utils.cfm">



<cfparam name="form.FRMWORKGROUP_ID" type="numeric" default="0">

<cfparam name="form.frmworkgroupkey" type="string" default="">
<cfparam name="form.frmcategory" type="string" default="">



<cfinclude template="queries/q_insert_task.cfm">



<cfif isdefined("form.frmSubmitAddAnother")>

	<cflocation addtoken="No" url="default.cfm?action=NewTask">

<cfelse>

	<cflocation addtoken="No" url="default.cfm">

</cfif>