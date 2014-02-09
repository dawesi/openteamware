<cfinclude template="/login/check_logged_in.cfm">

<cfparam name="url.servicekey" type="string" default="">
<cfparam name="url.objectkey" type="string" default="">
<cfparam name="url.userkey" type="string" default="">

<cfinvoke component="#request.a_str_component_assigned_items#" method="DeleteAssignment" returnvariable="a_bol_return">
	<cfinvokeargument name="servicekey" value="#url.servicekey#">
	<cfinvokeargument name="objectkey" value="#url.objectkey#">
	<cfinvokeargument name="userkey" value="#url.userkey#">
</cfinvoke>		

<cflocation addtoken="no" url="#ReturnRedirectURL()#">