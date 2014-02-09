<!--- //

	Service:	Project
	Action:		DoCreateProject
	Function:	Function
	Description:
	
	Header:	

// --->

<cfparam name="form.frmpercentdone" type="numeric" default="0">
<cfparam name="form.frmparentprojectkey" type="string" default="">
<cfparam name="form.frmcategories" type="string" default="">
<cfdump var="#form#">

<cfinvoke component="#request.a_str_component_project#" method="CreateProject" returnvariable="a_bol_return">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="projecttype" value="0">
	<cfinvokeargument name="title" value="#form.frmtitle#">
	<cfinvokeargument name="description" value="#form.frmcomment#">
	<cfinvokeargument name="categories" value="#form.frmcategories#">
	<cfinvokeargument name="percentdone" value="#val(form.frmpercentdone)#">
	<cfinvokeargument name="entrykey" value="#form.frmentrykey#">
	<cfinvokeargument name="parentprojectkey" value="#form.frmparentprojectkey#">
</cfinvoke>

<!---
<cfif IsDate(form.frmclosingdate)>
	<cfset a_dt_closing_date = LsParseDateTime(form.frmclosingdate)>
<cfelse>
	<cfset a_dt_closing_date = DateAdd('d', 30, Now())>
</cfif>

<cfinvoke component="#application.components.cmp_crmsales#" method="CreateSalesProject" returnvariable="ab">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="entrykey" value="#form.frmentrykey#">
	<cfinvokeargument name="title" value="#form.frmtitle#">
	<cfinvokeargument name="comment" value="#form.frmcomment#">
	<cfinvokeargument name="sales" value="#val(form.frmsales)#">
	<cfinvokeargument name="currency" value="#form.frmcurrency#">
	<cfinvokeargument name="probability" value="#val(form.frmprobability)#">
	<cfinvokeargument name="stage" value="#form.frmstage#">
	<cfinvokeargument name="project_type" value="#val(form.frmproject_type)#">
	<cfinvokeargument name="lead_source" value="#val(form.frmleadsource)#">
	<cfinvokeargument name="responsibleuserkey" value="#form.frmresponsibleuserkey#">
	<cfinvokeargument name="contactkey" value="#form.frmcontactkey#">
	<cfinvokeargument name="closing_date" value="#a_dt_closing_date#">
</cfinvoke>
--->

