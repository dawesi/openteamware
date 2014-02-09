<cfdump var="#form#">

<!---
	0 = default
	1 = partner
	2 = mitbewerb
	--->
	
<cfparam name="form.frmtype" type="numeric" default="0">
<cfparam name="form.frmrole" type="numeric" default="0">
<!--- entrykey of user or contact --->
<cfparam name="form.frmentrykey" type="string" default="">
<cfparam name="form.frminternaluser" type="numeric" default="0">
<cfparam name="form.frmsalesprojectkey" type="string" default="">
<cfparam name="form.frmcomment" type="string" default="">

<cfinvoke component="#application.components.cmp_crmsales#" method="AddContactToSalesProject" returnvariable="ab">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="comment" value="#form.frmcomment#">
	<cfinvokeargument name="role" value="#form.frmrole#">
	<cfinvokeargument name="type" value="#form.frmtype#">
	<cfinvokeargument name="contact_entrykey" value="#form.frmentrykey#">
	<cfinvokeargument name="internal_user" value="#val(form.frminternaluser)#">
	<cfinvokeargument name="salesprojectkey" value="#form.frmsalesprojectkey#">
</cfinvoke>