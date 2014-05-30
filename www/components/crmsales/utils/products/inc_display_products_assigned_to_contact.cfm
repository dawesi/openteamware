<!--- //

	Component:	Products
	Function:	DisplayProductsOfContact
	Description: 
	

// --->


<cfset stReturn = FindProductsOfContact(securitycontext = arguments.securitycontext,
									usersettings = arguments.usersettings,
									contactkey = arguments.contactkey,
									filter = arguments.filter) />
									
<cfif stReturn.q_select_products_of_contact.recordcount IS 0>
	<cfexit method="exittemplate">
</cfif>

<cfquery name="stReturn.q_select_products_of_contact" dbtype="query">
SELECT
	*
FROM
	stReturn.q_select_products_of_contact
ORDER BY
	dt_created DESC,
	productgroupname
</cfquery>

<cfsavecontent variable="sReturn">
	
<!--- 	<cfdump var="#stReturn.q_select_products_of_contact#"> --->
<table class="table table-hover">
	<cfoutput>
	  <tr class="tbl_overview_header">
		<td width="25%">
			#GetLangVal('crm_wd_product_title')# (#GetLangVal('crm_wd_product_quantity')#)
		</td>
		<td width="20%">
			#GetLangVal('crm_wd_product_group')#
		</td>
		<td width="20%">
			Preis
		</td>
		<td width="15%">
			#GetLangVal('cm_wd_created')#
		</td>
		<!--- <td width="25%">
			#GetLangVal('crm_wd_product_categories')#
		</td> --->
		<cfif arguments.editmode>
	        <td style="width: 5%"> 
	            &nbsp;
	        </td>
	        <td style="width: 5%">
	            &nbsp;
	        </td>
		</cfif>
	  </tr>
    </cfoutput>
	<cfoutput query="stReturn.q_select_products_of_contact">
		
	  <tr>
        <td>
           #si_img( 'note' )# #htmleditformat(stReturn.q_select_products_of_contact.title)#
		
			<cfif Len(stReturn.q_select_products_of_contact.internalid) GT 0>
				(#htmleditformat(stReturn.q_select_products_of_contact.internalid)#)
			</cfif>
		
			(#htmleditformat(stReturn.q_select_products_of_contact.quantity)#x)
			
			<cfif Len(stReturn.q_select_products_of_contact.comment) GT 0>
				(#htmleditformat(stReturn.q_select_products_of_contact.comment)#)
			</cfif>
        </td>
        <td>
            #htmleditformat(stReturn.q_select_products_of_contact.productgroupname)#
        </td>
		<td>
			#htmleditformat(DecimalFormat(Val(stReturn.q_select_products_of_contact.PURCHASE_PRICE)))#
		</td>
        <td>
            #FormatDateTimeAccordingToUserSettings(stReturn.q_select_products_of_contact.dt_created)#
        </td>
        <!--- <td>
            #htmleditformat(ListAppend(stReturn.q_select_products_of_contact.category1, stReturn.q_select_products_of_contact.category2))#
        </td> --->
		<cfif arguments.editmode>
	        <td>
	            <a href="/crm/index.cfm?action=addProductToContact&contactkey=#arguments.contactkey#&entrykey=#stReturn.q_select_products_of_contact.entrykey#">
	                <img src="/images/si/pencil.png" class="si_img" />
	            </a>
	        </td>
	        <td>
				<a href="##" onclick="ConfirmRemoveProductsOfContact('#jsstringformat(stReturn.q_select_products_of_contact.entrykey)#', '#jsstringformat(stReturn.q_select_products_of_contact.title)#');return false;">
	                <img src="/images/si/delete.png" class="si_img" />
	            </a>
	        </td>
        </cfif>
	  </tr> 
	</cfoutput> 
</table>
</cfsavecontent>

