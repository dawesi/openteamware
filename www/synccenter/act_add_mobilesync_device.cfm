<cfinclude template="../login/check_logged_in.cfm">

<!--- create a device ... --->

<cfif Len(form.frmname) IS 0>
	<h1>Empty name NOT permitted.</h1>
	<cfabort>
</cfif>

<cfif Len(form.frmimei) IS 0>
	<h1>Empty IMEI NOT permitted.</h1>
	<cfabort>
</cfif>

<cfif Len(form.frm_manufactor_model) IS 0>
	<h1>empty manufactor/model</h1>
	<cfabort>
</cfif>

<cfinvoke component="#request.a_str_component_mobilesync#" method="AddDevice" returnvariable="stReturn">
	<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
	<cfinvokeargument name="name" value="#form.frmname#">
	<cfinvokeargument name="description" value="#form.frmdescription#">
	<cfinvokeargument name="deviceid" value="#form.frmimei#">
	<cfinvokeargument name="manufactor_model" value="#form.frm_manufactor_model#">
	<cfinvokeargument name="encoding" value="#form.frmencoding#">
</cfinvoke>

<cfif stReturn.error IS 0>
	<cflocation addtoken="no" url="default.cfm?action=enablemobilesync&deviceid=#urlencodedformat(stReturn.deviceid)#">
<cfelse>
	<h4>Error: <cfoutput>#stReturn.errormessage#</cfoutput>
	</h4>
</cfif>