


<!--- load entrykey of additional data table and activities table ... --->
<cfinvoke component="#application.components.cmp_crmsales#" method="GetCRMSalesBinding" returnvariable="a_struct_crmsales_bindings">
	<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
</cfinvoke>

<!---<cfdump var="#a_struct_crmsales_bindings#">--->

<!--- a) additional data ... --->

<cfif Len(a_struct_crmsales_bindings.ADDITIONALDATA_TABLEKEY) GT 0>
	<!--- hit ... display --->
	<cfinclude template="dsp_inc_show_additional_data.cfm">
</cfif>

<cfif Len(a_struct_crmsales_bindings.activities_tablekey) GT 0>
	<!--- hit ... display --->
	<cfinclude template="dsp_inc_show_activities_data.cfm">
</cfif>