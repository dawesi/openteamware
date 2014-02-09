<!--- //
	Module:            administration (products)
	Action:            addproduct (subaction)
	Description:       <description>
		
// --->
<cfparam name="url.entrykey" type="string" default=""/>
<cfparam name="url.companykey" type="string" default=""/>


<cfset a_str_product_action = 'create'/>
<cfset q_select_product = QueryNew('')/>

<!--- if updating then load the values from database --->
<cfif Len(url.entrykey) GT 0 > 
	<cfset a_str_product_action = 'edit'/>

    <cfset a_struct_filter = StructNew()/>
    <cfset a_struct_filter.entrykey = url.entrykey/>
	<cfinvoke component="#application.components.cmp_products#" method="FindProducts" returnvariable="stReturn">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#"/>
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#"/>
		<cfinvokeargument name="filter" value="#a_struct_filter#"/>
	</cfinvoke>

	<cfif NOT stReturn.result>
		<cflocation url="default.cfm?action=productadministration&ibxerrorno=#stReturn.error#"/>
	</cfif>

	<cfset q_select_product = stReturn.q_select_products/>
</cfif>


<!--- prepare the data for productgroup select --->
<cfset a_struct_filter = StructNew()/>
<cfset a_struct_filter.companykey = url.companykey/>
<cfinvoke component="#application.components.cmp_products#" method="FindProductGroups" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#"/>
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#"/>
	<cfinvokeargument name="filter" value="#a_struct_filter#"/>
</cfinvoke>

<cfset a_struct_force_options_replace = StructNew()/>
<cfset a_struct_force_options_replace.productgroupkey = ArrayNew(1)/>
<cfloop query="stReturn.q_select_product_groups">
    <cfset a_struct_force_options_replace.productgroupkey = application.components.cmp_forms.AddItemToArrayOfOptions(a_struct_force_options_replace.productgroupkey, stReturn.q_select_product_groups.productgroupname, stReturn.q_select_product_groups.entrykey)/>
</cfloop>


<!--- display the form --->
<cfset a_str_form = application.components.cmp_forms.DisplaySavedForm(
                        action = a_str_product_action,
						securitycontext = request.stSecurityContext,
						usersettings = request.stUserSettings,
						query = q_select_product,
						entrykey = '95027218-957A-CA40-96183465710B6D14',
                        force_options_replace = a_struct_force_options_replace)/>
<cfoutput>#a_str_form#</cfoutput>

