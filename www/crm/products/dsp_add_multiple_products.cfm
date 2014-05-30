<!--- //
	Module:            CRM / products
	Action:            addMultipleProductsToContact
	Description:       Displays a form where user can add multiple products to a contact
// --->

<cfparam name="url.contactkey" type="string" />

<!--- 
prepare list of products:
a) Are products already assigned to customer? Display these
b) No products assigned? Display most used products (assigned to other customers) - top 10
--->
<cfset q_select_products = QueryNew('entrykey,title,retail_price,purchase_price,comment')/>

<cfinvoke component="#application.components.cmp_products#" method="FindProductsOfContact" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#"/>
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#"/>
	<cfinvokeargument name="contactkey" value="#url.contactkey#"/>
	<cfinvokeargument name="orderBy" value="pa.dt_created desc"/>
</cfinvoke>
<cfset q_select_products = stReturn.q_select_products_of_contact />


<cfset sEntrykeys_p = ValueList(q_select_products.projectkey, ",") />

	<cfset a_struct_filter_q = StructNew()/>
	<cfset a_struct_filter_q.productkeys = sEntrykeys_p />

<!--- products with available quantity --->

<cfinvoke component="#application.components.cmp_products#" method="FindProductsQuantity" returnvariable="stReturn_q_products">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="filter" value="#a_struct_filter_q#">
</cfinvoke>
<cfset q_select_productquantity = stReturn_q_products.q_select_productquantity />



<cfif stReturn.q_select_products_of_contact.recordcount EQ 0>
    <!--- there are not products assigned to this contact yet so use most used products --->
	<cfset a_struct_filter = StructNew()/>
	<cfset a_struct_filter.companykey = request.stSecurityContext.mycompanykey/>
	<cfset a_struct_filter.enabled = 1/>

	<cfinvoke component="#application.components.cmp_products#" method="FindProducts" returnvariable="stReturn">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#"/>
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#"/>
		<cfinvokeargument name="filter" value="#a_struct_filter#"/>
        <cfinvokeargument name="orderBy" value="usedTimes desc"/>
	</cfinvoke>
    <cfset q_select_products = stReturn.q_select_products />
</cfif>

<cfset a_str_productkeys = '' />

<cfsavecontent variable="a_str_table">
<table class="table table-hover">
	<cfoutput>
	  <tr class="tbl_overview_header">
		<td width="10%">
			#GetLangVal('crm_wd_product_quantity')#
		</td>
		<td width="20%">
			#GetLangVal('crm_wd_product')#
		</td>
		<td width="10%">
			#GetLangVal('crm_wd_product_available')#
		</td>
		<td width="15%">
			#GetLangVal('crm_wd_product_retail_price')#
		</td>
		<td width="15%">
			#GetLangVal('crm_wd_product_purchase_price')#
		</td>
		<td width="30%">
			#GetLangVal('crm_wd_product_comment')#
		</td>
	  </tr>
    </cfoutput>
	<cfoutput query="q_select_products">
      <cfset productkey = q_select_products.entrykey />
      <cfif StructKeyExists(q_select_products, 'projectkey')>
          <cfset productkey = q_select_products.projectkey />
      </cfif>
      
      <!--- render only distinct products --->
      <cfif ListFind(a_str_productkeys, productkey) EQ 0> 
	      <cfset a_str_productkeys = ListAppend(a_str_productkeys, productkey) />
		  <tr>
	        <td>
	           <input type="text" size="4" name="frm#productkey#.quantity" value="0"/>
	        </td>
	        <td>
	            #htmleditformat(q_select_products.title)#
	        </td>
	        <td>
		        <cfset q_single_row = GetSingleRowFromQuery(q_select_productquantity, "ENTRYKEY", q_select_products.projectkey) />
	            #htmleditformat(q_single_row.quantity)#
	         
	        </td>
	        <td>
	            <input type="text" size="8" name="frm#productkey#.retail_price" value="#htmleditformat(q_select_products.retail_price)#"/>
	        </td>
	        <td>
	            <input type="text" size="8" name="frm#productkey#.purchase_price" value="#htmleditformat(q_select_products.purchase_price)#"/>
	        </td>
			<td>
	            <input type="text" size="40" name="frm#productkey#.comment" <cfif StructKeyExists(q_select_products, 'comment')> value="#htmleditformat(q_select_products.comment)#" </cfif> />
			</td>
		  </tr> 
      </cfif>
	</cfoutput> 
      <tr>
          <td colspan="6" class="table table-hover">
              <cfoutput>#GetLangVal('crm_wd_product_date')#: 
              <input type="text" size="20" name="frmdt_added" value="#LSDateFormat(Now())#">
              </cfoutput>
          </td>
      </tr>
      <tr>
          <td colspan="6" class="table table-hover">
        	  <input type="submit" value="<cfoutput>#GetLangVal('cm_wd_add')#</cfoutput>" class="btn btn-primary" />
          </td>
      </tr>
</table>
</cfsavecontent>

<cfoutput>
    <form action="index.cfm?action=doAddMultipleProductsToContact" method="post">
        <input type="hidden" name="frmcontactkey" value="#url.contactkey#" />
        <input type="hidden" name="frmproductkeys" value="#a_str_productkeys#" />
        #WriteNewContentBox(GetLangVal('crm_ph_add_products'), '', a_str_table)#
    </form>
</cfoutput>


