<!---

	create a resource
	
	--->
	
<cfparam name="form.frmworkgroupkeys" type="string" default="">
	
<cfinvoke component="/components/tools/cmp_resources" method="CreateResource" returnvariable="a_bol_return">
	<cfinvokeargument name="title" value="#form.frmtitle#">
	<cfinvokeargument name="description" value="#form.frmdescription#">
	<cfinvokeargument name="createdbyuserkey" value="#request.stSecurityContext.myuserkey#">
	<cfinvokeargument name="companykey" value="#form.frmcompanykey#">
	<cfinvokeargument name="workgroupkeys" value="#form.frmworkgroupkeys#">
</cfinvoke>


<cflocation addtoken="no" url="../default.cfm?action=resources#WriteURLTagsfromForm()#">