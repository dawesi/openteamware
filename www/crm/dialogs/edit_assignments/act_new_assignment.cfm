<cfinclude template="/login/check_logged_in.cfm">

<cfif Len(form.FRMUSERKEY) IS 0>
	<h4>no user selected</h4>
	<cfabort>
</cfif>

<cfinvoke component="#request.a_str_component_assigned_items#" method="AddAssignment" returnvariable="a_bol_return">
	<cfinvokeargument name="servicekey" value="#form.frmservicekey#">
	<cfinvokeargument name="objectkey" value="#form.frmentrykeys#">
	<cfinvokeargument name="userkey" value="#form.frmuserkey#">
	<cfinvokeargument name="createdbyuserkey" value="#request.stSecurityContext.myuserkey#">
	<cfinvokeargument name="comment" value="#form.frmcomment#">
</cfinvoke>

<!--- send notification? --->
<cflocation addtoken="no" url="#ReturnRedirectURL()#">