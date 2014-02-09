<cfparam name="form.frmcompany_news" type="numeric" default="0">
<cfparam name="form.frm_admin_post_only" type="numeric" default="0">

<cfif Len(form.frmname) IS 0>
	Enter a name.
	<cfabort>
</cfif>

<cfdump var="#form#">

<cfinvoke component="#request.a_str_component_forum#" method="CreateForum" returnvariable="a_bol_return">
	<cfinvokeargument name="name" value="#form.frmname#">
	<cfinvokeargument name="description" value="#form.frmdescription#">
	<cfinvokeargument name="entrykey" value="#createuuid()#">
	<cfinvokeargument name="companykey" value="#form.frmcompanykey#">
	<cfinvokeargument name="createdbyuserkey" value="#request.stSecurityContext.myuserkey#">
	<cfinvokeargument name="workgroupkeys" value="#form.frmworkgroupkeys#">
	<cfinvokeargument name="companynews_forum" value="#form.frmcompany_news#">
	<cfinvokeargument name="admin_post_only" value="#form.frm_admin_post_only#">
</cfinvoke>

<cflocation addtoken="false" url="../default.cfm?action=forum">