<cfparam name="url.salesprojectkey" type="string" default="">
<cfparam name="url.type" type="numeric" default="-1">

<cfinvoke component="#request.a_str_component_crm_sales#" method="GetSalesProject" returnvariable="a_struct_sales_project">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="entrykey" value="#url.salesprojectkey#">
</cfinvoke>

<cfset q_select_sales_project = a_struct_sales_project.q_select_sales_project>
<cfset q_select_contacts_assigned_to_sales_project = a_struct_sales_project.q_select_contacts_assigned_to_sales_project>
<cfset q_select_sales_project_stage_trends = a_struct_sales_project.q_select_sales_project_stage_trends>

<cfif q_select_sales_project.recordcount IS 0>
	No data found.
	<cfexit method="exittemplate">
</cfif>



<cfif url.type IS -1>

	<form action="index.cfm" method="get">
	<input type="hidden" name="action" value="AssignNewContactToSalesProject">
	<input type="hidden" name="salesprojectkey" value="<cfoutput>#htmleditformat(url.salesprojectkey)#</cfoutput>">
	<table border="0" cellspacing="0" cellpadding="4">
	  <tr>
		<td>
			<input checked class="noborder" type="radio" name="type" value="0">
		</td>
		<td>
			Kontakt aus dem Adressbuch auswählen (Allgemein)
		</td>
	  </tr>
	  <tr>
		<td>
			<input class="noborder" type="radio" name="type" value="2">
		</td>
		<td>
			Interner Mitarbeiter
		</td>
	  </tr>
	  <tr>
		<td></td>
		<td>
			<input type="submit" value="Weiter ..." class="btn">
		</td>
	  </tr>
	</table>
	</form>
	
</cfif>


<cfif url.type GT -1>
	
	<!--- which type
	
		addressbook or internal user
		
		--->
	<cfswitch expression="#url.type#">
		
		<cfcase value="0">
			<!--- // from address book // --->
			<cfinclude template="dsp_inc_assign_user_addressbook.cfm">

		</cfcase>
		
		<cfcase value="1">
			<!--- // internal user // --->
			
			
		</cfcase>
	
	</cfswitch>
		

</cfif>