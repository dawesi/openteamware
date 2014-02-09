<!---

	crm ...
	
	--->
	
<cfset variables.a_cmp_crm = application.components.cmp_crmsales>

<cfinvoke component="#variables.a_cmp_crm#" method="GetCRMSalesBinding" returnvariable="a_struct_crmsales_bindings">
	<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
</cfinvoke>				

	<tr>
    	<td>
		
		<cfinclude template="dsp_inc_show_contact_data_ex.cfm">
		<br>
		<cfinclude template="dsp_inc_history.cfm">
				
				
		<!--- tarus! --->
		<cfif request.stSecurityContext.mycompanykey IS 'D6576B72-AA82-49BC-BDF4F792DD41EF91'>
			<fieldset class="default_fieldset">
				<legend class="addinfotext">
					<b><img height="9" width="9" src="/images/arrows/img_indent_small.png" align="absmiddle" border="0" vspace="2" hspace="2"> <cfoutput>#GetLangVal('cm_wd_misc')#</cfoutput></b>
				</legend>
				<cfinclude template="dsp_inc_misc_tarus.cfm">
			</fieldset>
		</cfif>
		
			
		</td>
	</tr>