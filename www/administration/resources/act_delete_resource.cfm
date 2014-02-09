<!--- //

	Module:		Admintool
	Action:		action.resource.delete
	Description: 
	
// --->

<cfparam name="url.entrykey" type="string" default="">

<cfinclude template="../dsp_inc_select_company.cfm">

<cfinvoke component="#request.a_str_component_resources#" method="DeleteResource">
	<cfinvokeargument name="securitycontext" value="#session.stSecurityContext#">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

<cflocation addtoken="false" url="#ReturnRedirectURL()#">
