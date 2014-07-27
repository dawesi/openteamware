<!--- //

	Module:		CRM
	Action:		productadmin
	Description: Productamdin 
	

// --->


<cfset SetHeaderTopInfoString(GetLangVal('crm_wd_product_admin')) />
<cfset stReturn = '' />		
		
<cfset a_struct_filter = StructNew() />
<cfset a_struct_filter.companykey = request.stSecurityContext.mycompanykey />
<cfset a_struct_filter.enabled = 1 />
		
<cfinvoke component="#application.components.cmp_products#" method="FindProductsQuantity" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
</cfinvoke>
									
<cfif stReturn.q_select_productquantity.recordcount IS 0>
	<cfexit method="exittemplate">
</cfif>

<cfsavecontent variable="a_str_products_table">
<table class="table table-hover">
	<cfoutput>
	  <tr class="tbl_overview_header">
		<td width="25%">
			#GetLangVal('crm_wd_product_title')#
		</td>
		
		<td width="25%">
			#GetLangVal('crm_wd_product_aq')#
		</td>
		<td width="25%">
			#GetLangVal('crm_wd_product_categories')#
		</td>
		<td></td>
	  </tr>
    </cfoutput>
	<cfoutput query="stReturn.q_select_productquantity">
	  <tr>
        <td>
           <img src="/images/si/basket.png" class="si_img" /> #htmleditformat(stReturn.q_select_productquantity.title)#
			<cfif Len(stReturn.q_select_productquantity.internalid) GT 0>
				(#stReturn.q_select_productquantity.internalid#)
			</cfif>
			<br />
		   <img src="/images/space_1_1.gif" class="si_img" alt="" /> #htmleditformat(stReturn.q_select_productquantity.description)#
        </td>
        <td>
            #htmleditformat(stReturn.q_select_productquantity.quantity)#
        </td>
        <td>
            #htmleditformat(ListAppend(stReturn.q_select_productquantity.category1, stReturn.q_select_productquantity.category2))#
        </td>
		
		<td align="right">
	            <a href="/crm/index.cfm?action=setAvailableQuantity&productkey=#stReturn.q_select_productquantity.entrykey#&productquantitykey=#stReturn.q_select_productquantity.productquantitykey#&quantity=#stReturn.q_select_productquantity.quantity#&title=#stReturn.q_select_productquantity.title#">
	                <img src="/images/si/pencil.png" class="si_img" />
	            </a>
	        </td>
	  </tr> 
	</cfoutput> 
</table>
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('crm_wd_product_admin'), '', a_str_products_table)#</cfoutput>


