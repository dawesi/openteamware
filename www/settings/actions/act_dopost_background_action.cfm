<!--- //

	Module:		Preferences
	Action:		doPostBackgroundAction
	Description:Various background operations
	

// --->

<!--- the desired action ... --->
<cfparam name="form.FRMACTION" type="string" default="">

<!--- the XML document containing the request ... --->
<cfparam name="form.FRMREQUEST" type="string" default="">

<cfset a_struct_parse = application.components.cmp_tools.ParseBackgroundOperationRequest(form.frmrequest) />

<!--- output error ... --->
<cfif NOT a_struct_parse.result>
	<script type="text/javascript">
		OpenErrorMessagePopup('<cfoutput>#Val(a_struct_parse.error)#</cfoutput>');
	</script>
	<cfexit method="exittemplate">
</cfif>

<cfset a_struct_data = a_struct_parse.data />

<cfswitch expression="#form.frmaction#">
	<cfcase value="SetPersonalPreference">
		
	<!--- save personal preference ... --->	
	<cfmodule template="/common/person/saveuserpref.cfm"
		entrysection = "#a_struct_data.section#"
		entryname = "#a_struct_data.name#"
		entryvalue1 = "#a_struct_data.value#">
	
	</cfcase>
</cfswitch>

