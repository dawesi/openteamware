<!--- //
	Module:            CRM / products
	Action:            addProductToContact
	Description:       Displays a form where user can add product to a contact
// --->

<cfparam name="url.entrykey" type="string" default="" />
<cfparam name="url.contactkey" type="string" />

<cfset SetHeaderTopInfoString(GetLangVal('crm_ph_assign_product')) />

<cfset a_str_product_action = 'create'/>
<cfset q_select_products_of_contact = QueryNew('') />

<!--- if updating then load the values from database --->
<cfif Len(url.entrykey) GT 0 > 
	<cfset a_str_product_action = 'edit'/>

    <cfset a_struct_filter = StructNew()/>
    <cfset a_struct_filter.entrykey = url.entrykey/>
	<cfinvoke component="#application.components.cmp_products#" method="FindProductsOfContact" returnvariable="stReturn">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#"/>
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#"/>
		<cfinvokeargument name="contactkey" value="#url.contactkey#"/>
		<cfinvokeargument name="filter" value="#a_struct_filter#"/>
	</cfinvoke>

	<cfif NOT stReturn.result>
		<cflocation url="/crm/index.cfm?action=showProductsOfContact&contactkey=#url.contactkey#&ibxerrorno=#stReturn.error#"/>
	</cfif>

	<cfset q_select_products_of_contact = stReturn.q_select_products_of_contact/>
</cfif>


<!--- prepare the data for products select --->
<cfset a_struct_filter = StructNew()/>
<cfset a_struct_filter.companykey = request.stSecurityContext.mycompanykey/>
<cfset a_struct_filter.enabled = 1/>

<cfinvoke component="#application.components.cmp_products#" method="FindProducts" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#"/>
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#"/>
	<cfinvokeargument name="filter" value="#a_struct_filter#"/>
</cfinvoke>

<cfset a_struct_force_options_replace = StructNew()/>
<cfset a_struct_force_options_replace.projectkey = ArrayNew(1)/>

<cfif stReturn.q_select_products.recordcount IS 0>
	<cfoutput>#GetLangVal('crm_ph_no_products_found_create_one')#</cfoutput>
	<br />
	<a href="/administration/" target="_blank"><cfoutput>#GetLangVal('prf_ph_launch_admintool')#</cfoutput></a> 
	<cfexit method="exittemplate">
</cfif>

<cfloop query="stReturn.q_select_products">
	
	<cfset a_str_title = stReturn.q_select_products.title />
	
	<cfif Len(stReturn.q_select_products.internalid) GT 0>
		<cfset a_str_title = a_str_title & ' (' & stReturn.q_select_products.internalid & ')' />
	</cfif>
	
    <cfset a_struct_force_options_replace.projectkey = application.components.cmp_forms.AddItemToArrayOfOptions(a_struct_force_options_replace.projectkey, a_str_title, stReturn.q_select_products.entrykey)/>
</cfloop>

<cfoutput>
<div class="b_all">
<a href="##" onclick="GotoLocHref('/crm/index.cfm?action=addMultipleProductsToContact&contactkey=#url.contactkey#');"><img src="/images/si/package_add.png" class="si_img" /> #GetLangVal('cm_wd_new_multiple')#</a>
</div>
</br>
</cfoutput>

<!--- display the form --->
<cfset a_str_form = application.components.cmp_forms.DisplaySavedForm(
                        action = a_str_product_action,
						securitycontext = request.stSecurityContext,
						usersettings = request.stUserSettings,
						query = q_select_products_of_contact,
						entrykey = 'C2666138-DD0C-8898-2BF91C0FAF72AA9D',
                        force_options_replace = a_struct_force_options_replace) />
						
<cfoutput>#a_str_form#</cfoutput>



