<!--- //
	Module:            CRM / products
	Action:            setAvailableQuantity
	Description:       Displays a form where user can change available quantity of selected product
// --->

<cfparam name="url.productkey" type="string" />
<cfparam name="url.quantity" type="string" default="" />
<cfparam name="url.title" type="string" />
<cfparam name="url.productquantitykey" type="string" />

<cfset tmp = SetHeaderTopInfoString('Set available quantity') />

<cfset a_str_product_action = 'edit'/>

<cfif Compare(url.quantity, "") IS 0>
	<cfset url.quantity = '0'/>
</cfif>

 <!--- render form --->
<form action="index.cfm?action=doSetAvailableQuantity" method="post">
<cfsavecontent variable="a_str_table">
 <table class="table_details table_edit_form">
	<cfoutput>
		  <tr>
	        <td class="field_name">
	            #GetLangVal('crm_wd_product')# 
	        </td>
	        <td>
		       	#htmleditformat(url.title)#
	        </td>
		  </tr> 
		  <tr>
	        <td class="field_name">
	            #GetLangVal('crm_wd_product_aq')#
	        </td>
	        <td>
	            <input type="text" size="4" name="frmproduct_q" value="#htmleditformat(url.quantity)#"/>
	        </td>
		  </tr> 
		  <tr>
	        <td class="field_name"></td>
	        <td>
	            <input type="submit" value="<cfoutput>#GetLangVal('cm_wd_add')#</cfoutput>" class="btn btn-primary" />
	        </td>
		  </tr></table> </cfoutput> 
</cfsavecontent>	

<cfoutput>
		<input type="hidden" name="frmproductkey" value="#url.productkey#" />
        <input type="hidden" name="frmproducttitle" value="#htmleditformat(url.title)#" />
		<input type="hidden" name="frmproductquantitykey" value="#url.productquantitykey#" />
        #WriteNewContentBox('Set number of available quantity', '', a_str_table)#
    </form>
</cfoutput>
