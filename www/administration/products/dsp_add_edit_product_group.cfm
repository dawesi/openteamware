<!--- //
	Module:            administration (products)
	Action:            addproductgroup (subaction)
	Description:       Show page for creating/editing product group (using forms engine)
		
// --->
<cfparam name="url.entrykey" type="string" default=""/>
<cfparam name="url.companykey" type="string" default=""/>

<cfset a_str_product_action = 'create'/>
<cfset q_select_product_group = QueryNew('')/>

<!--- if updating then load the values from database --->
<cfif Len(url.entrykey) GT 0 > 
	<cfset a_str_product_action = 'edit'/>

    <cfset a_struct_filter = StructNew()/>
    <cfset a_struct_filter.entrykey = url.entrykey/>
	<cfinvoke component="#application.components.cmp_products#" method="FindProductGroups" returnvariable="stReturn">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		<cfinvokeargument name="filter" value="#a_struct_filter#">
	</cfinvoke>

	<cfif NOT stReturn.result>
		<cflocation url="index.cfm?action=productadministration&ibxerrorno=#stReturn.error#">
	</cfif>

	<cfset q_select_product_group = stReturn.q_select_product_groups/>
</cfif>


<!--- prepare the data for parent group select --->
<cfset a_struct_filter = StructNew()/>
<cfset a_struct_filter.companykey = url.companykey/>
<cfinvoke component="#application.components.cmp_products#" method="FindProductGroups" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#"/>
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#"/>
	<cfinvokeargument name="filter" value="#a_struct_filter#"/>
</cfinvoke>

<cfset a_struct_force_options_replace = StructNew()/>
<cfset a_struct_force_options_replace.parentproductgroupentrykey = ArrayNew(1)/>
<cfset a_struct_force_options_replace.parentproductgroupentrykey = application.components.cmp_forms.AddItemToArrayOfOptions(a_struct_force_options_replace.parentproductgroupentrykey, "", "")/>
<cfloop query="stReturn.q_select_product_groups">
    <cfset a_struct_force_options_replace.parentproductgroupentrykey = application.components.cmp_forms.AddItemToArrayOfOptions(a_struct_force_options_replace.parentproductgroupentrykey, stReturn.q_select_product_groups.productgroupname, stReturn.q_select_product_groups.entrykey)/>
</cfloop>


<!--- display the form --->
<cfset a_str_form = application.components.cmp_forms.DisplaySavedForm(
                        action = a_str_product_action,
						securitycontext = request.stSecurityContext,
						usersettings = request.stUserSettings,
						query = q_select_product_group,
						entrykey = '8A40857D-9DAE-CF24-C0CFFE0DF0D03DF2',
                        force_options_replace = a_struct_force_options_replace)/>
<cfoutput>#a_str_form#</cfoutput>

