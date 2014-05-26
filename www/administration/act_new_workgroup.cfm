<!--- //

	create the new workgroup ...
	
	// --->
<cfparam name="form.frmname" type="string" default="">
<cfparam name="form.frmshortname" type="string" default="">
<cfparam name="form.frmcolour" type="string" default="white">

<cfif Len(form.frmshortname) IS 0>
	<cfset form.frmshortname = form.frmname>
</cfif>
	
<cfif len(form.frmname) lte 3>
	<cflocation addtoken="no" url="index.cfm?action=newworkgroup&error=tooshortname#WriteURLTagsfromForm()#">
</cfif>

<!--- check the workgroup name ... only a-z; 0-9 --->

<!--- create now ... --->

<cfinvoke component="/components/management/workgroups/cmp_workgroup" method="CreateWorkgroup" returnvariable="stReturn">
	<cfinvokeargument name="groupname" value="#form.frmname#">
	<cfinvokeargument name="shortname" value="#form.frmshortname#">
	<cfinvokeargument name="description" value="#form.frmdescription#">
	<cfinvokeargument name="createdbyuserkey" value="#request.stSecurityContext.myuserkey#">
	<cfinvokeargument name="companykey" value="#form.frmcompanykey#">
	<cfinvokeargument name="parentgroupkey" value="#form.frmparentgroupkey#">
	<cfinvokeargument name="createstandardroles" value="true">
	<cfinvokeargument name="colour" value="#form.frmcolour#">
</cfinvoke>


<cflocation addtoken="no" url="index.cfm?action=workgroups#WriteUrlTagsFromForm()#">