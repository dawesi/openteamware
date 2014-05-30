<!--- //
	Module:            CRM / products
	Action:            showProductsOfContact
	Description:       Display the list of products assigned to contacts
// --->

<cfparam name="url.contactkey" default="" type="string"/>
<cfparam name="url.editmode" default="false" type="boolean"/>

<cfsavecontent variable="a_str_js">
    function ConfirmRemoveProductsOfContact(entrykey, productname) {
    	var url = '/crm/index.cfm?action=removeProductFromContact&contactkey=<cfoutput>#url.contactkey#</cfoutput>&entrykey=' + escape(entrykey) + '&productname=' + escape(productname);
		ShowSimpleConfirmationDialog(url);
    }
</cfsavecontent>
<cfset tmp = AddJSToExecuteAfterPageLoad('', a_str_js) />


<cfinvoke component="#application.components.cmp_products#" method="DisplayProductsOfContact" returnvariable="a_str_products_of_contact">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="contactkey" value="#url.contactkey#">
	<cfinvokeargument name="editmode" value="#url.editmode#">
</cfinvoke>

<cfif Len(Trim(a_str_products_of_contact)) IS 0>
	<cfexit method="exittemplate">
</cfif>

<cfsavecontent variable="a_str_buttons">
	<input onclick="GotoLocHref('/crm/index.cfm?action=addProductToContact&contactkey=<cfoutput>#url.contactkey#</cfoutput>');" type="button" value="<cfoutput>#GetLangVal('cm_wd_new')#</cfoutput>" class="btn btn-primary" />
	<input onclick="GotoLocHref('/crm/index.cfm?action=addMultipleProductsToContact&contactkey=<cfoutput>#url.contactkey#</cfoutput>');" type="button" value="<cfoutput>#GetLangVal('cm_wd_new_multiple')#</cfoutput>" class="btn btn-primary" />
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('crm_ph_products'), a_str_buttons, a_str_products_of_contact)#</cfoutput>


<!--- render the history table --->
<cfset a_struct_filter = StructNew()/>
<cfset a_struct_filter.contactkey = url.contactkey />
<cfinvoke component="#application.components.cmp_products#" method="FindProductAssignmentHistory" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
</cfinvoke>

<cfsavecontent variable="a_str_history_table">
<table class="table table-hover">
	<cfoutput>
	  <tr class="tbl_overview_header">
		<td width="25%">
			#GetLangVal('cm_wd_date')#
		</td>
		<td width="25%">
			#GetLangVal('crm_wd_product') & '/' & GetLangVal('crm_wd_product_group')#
		</td>
		<td width="25%">
			#GetLangVal('crm_wd_product_quantity')#
		</td>
		<td width="25%">
			#GetLangVal('cm_ph_created_by')#
		</td>
	  </tr>
    </cfoutput>
    <cfset a_str_lastDate = ''/>
	<cfoutput query="stReturn.q_select_productassignment_history">
	  <tr>
        <td>
           <cfset a_str_date = DateFormat(stReturn.q_select_productassignment_history.dt_created) />
           <cfif COMPARE(a_str_lastDate, a_str_date) NEQ 0 >
               #htmleditformat(a_str_date)#
           </cfif>
           <cfset a_str_lastDate = a_str_date />
        </td>
        <td>
            #htmleditformat(stReturn.q_select_productassignment_history.title & '/' & stReturn.q_select_productassignment_history.productgroupname)#
        </td>
        <td>
            #htmleditformat(stReturn.q_select_productassignment_history.quantity)#
        </td>
        <td>
            <cfinvoke component="#application.components.cmp_user#" method="GetUsernamebyentrykey" returnvariable="a_str_username">
                <cfinvokeargument name="entrykey" value="#stReturn.q_select_productassignment_history.createdbyuserkey#">
            </cfinvoke>
            #htmleditformat(a_str_username)#
        </td>
	  </tr> 
	</cfoutput> 
</table>
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('crm_ph_products_history'), '', a_str_history_table)#</cfoutput>

