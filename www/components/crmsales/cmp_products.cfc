<!--- //

	Module:		Products
	Description:Product component
	

// --->

<cfcomponent output="false">

	<cfinclude template="/common/scripts/script_utils.cfm">
	<cfinclude template="/common/app/app_global.cfm">
	
    <cfset sServiceKey = "94B39162-C7B4-5158-7A8C67BCF820D9E5" />
     
    <!--- ################################# --->
    <!--- functions for PRODUCTGROUP entity --->

	<cffunction access="public" name="CreateUpdateProductGroup" returntype="struct" output="false">
		<cfargument name="securitycontext" type="struct" required="true"/>
		<cfargument name="usersettings" type="struct" required="true"/>
		<cfargument name="action_type" type="string" required="true" hint="create, edit or other"/>
		<cfargument name="database_values" type="struct" required="true" hint="structure with values for database"/>
		<cfargument name="all_values" type="struct" required="true" hint="all values posted by the user"/>
		
		<cfset var stReturn = GenerateReturnStruct()/>
        <cfset var q_insert_product_group = 0 />
        <cfset var q_update_product_group = 0 />
		
		<cfif action_type IS 'Create'>
			<cfinclude template="queries/products/q_insert_product_group.cfm"/>
		<cfelse>
			<cfinclude template="queries/products/q_update_product_group.cfm"/>
		</cfif>
		<cfreturn SetReturnStructSuccessCode(stReturn)/>
	</cffunction>
    
	<cffunction access="public" name="FindProductGroups" output="false" returntype="struct">
		<cfargument name="securitycontext" type="struct" required="true"/>
		<cfargument name="usersettings" type="struct" required="true"/>
		<cfargument name="filter" type="struct" default="#StructNew()#" required="false"
			hint="filter for e.g. companykey of a certain parentproductcategoryentrykey, entrykey and so on "/>
			
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var q_select_product_groups = 0/>
		<cfinclude template="queries/products/q_select_product_groups.cfm"/>
		
		<cfset stReturn.q_select_product_groups = q_select_product_groups />
		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>
    
	<cffunction access="public" name="DeleteProductGroup" output="false" returntype="struct">
		<cfargument name="securitycontext" type="struct" required="true"/>
		<cfargument name="usersettings" type="struct" required="true"/>
		<cfargument name="entrykey" type="string" required="true"/>

		<cfset var stReturn = GenerateReturnStruct()/>
        <cfset var q_delete_product_group = 0/>
		<cfset var a_struct_filter = StructNew()/>
		<cfset var stReturn_products = 0 />
        
        <!--- check if the is company admin --->
        <cfif NOT(arguments.securitycontext.iscompanyadmin)>
			<cfreturn SetReturnStructErrorCode(stReturn, 13501) />
        </cfif>

        <!--- check if there are still products assigned to this group --->
		
		<cfset a_struct_filter.productgroupkey = arguments.entrykey/>
		<cfinvoke component="#application.components.cmp_products#" method="FindProducts" returnvariable="stReturn_products">
			<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#"/>
			<cfinvokeargument name="usersettings" value="#arguments.usersettings#"/>
			<cfinvokeargument name="filter" value="#a_struct_filter#"/>
		</cfinvoke>
		
		<cfif stReturn_products.q_select_products.recordcount GT 0>
			<cfreturn SetReturnStructErrorCode(stReturn, 13502) />
        </cfif>
        
        <!--- delete the product group --->
        <cfinclude template="queries/products/q_delete_product_group.cfm"/>
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>
    

    <!--- ############################ --->
    <!--- functions for PRODUCT entity --->    
    
	<cffunction access="public" name="CreateUpdateProduct" returntype="struct" output="false">
		<cfargument name="securitycontext" type="struct" required="true"/>
		<cfargument name="usersettings" type="struct" required="true"/>
		<cfargument name="action_type" type="string" required="true" hint="create, edit or other"/>
		<cfargument name="database_values" type="struct" required="true" hint="structure with values for database"/>
		<cfargument name="all_values" type="struct" required="true" hint="all values posted by the user"/>
		
		<cfset var stReturn = GenerateReturnStruct()/>
        <cfset var q_insert_product = 0 />
        <cfset var q_update_product = 0 />
		
		<cfif action_type IS 'Create'>
			<cfinclude template="queries/products/q_insert_product.cfm"/>
		<cfelse>
			<cfinclude template="queries/products/q_update_product.cfm"/>
		</cfif>
		<cfreturn SetReturnStructSuccessCode(stReturn)/>
	</cffunction>

	<cffunction access="public" name="FindProducts" output="false" returntype="struct">
		<cfargument name="securitycontext" type="struct" required="true"/>
		<cfargument name="usersettings" type="struct" required="true"/>
		<cfargument name="filter" type="struct" default="#StructNew()#" required="false"
			hint="filter for e.g. companykey of a certain productgroupkey, entrykey and so on "/>
        <cfargument name="orderBy" type="string" required="false" default="" />
			
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var q_select_products = 0/>
		<cfinclude template="queries/products/q_select_products.cfm"/>
		
		<cfset stReturn.q_select_products = q_select_products />
		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>
    
	<cffunction access="public" name="DeleteProduct" output="false" returntype="struct">
		<cfargument name="securitycontext" type="struct" required="true"/>
		<cfargument name="usersettings" type="struct" required="true"/>
		<cfargument name="entrykey" type="string" required="true"/>

		<cfset var stReturn = GenerateReturnStruct()/>
        <cfset var q_delete_product = 0/>
        
        <!--- check if the is company admin --->
        <cfif NOT(arguments.securitycontext.iscompanyadmin)>
			<cfreturn SetReturnStructErrorCode(stReturn, 13503)/>
        </cfif>
        
        <!--- delete the product group --->
        <cfinclude template="queries/products/q_delete_product.cfm"/>
		
		<cfreturn SetReturnStructSuccessCode(stReturn)/>
	</cffunction>
    
    <!--- ######################################## --->
    <!--- functions for PRODUCTS_OF_CONTACT entity --->    
    
	<cffunction access="public" name="FindProductsOfContact" output="false" returntype="struct"
			hint="Return products assigned to a given address book item (contact, account or lead">
		<cfargument name="securitycontext" type="struct" required="true"/>
		<cfargument name="usersettings" type="struct" required="true"/>
		<cfargument name="contactkey" type="string" required="true"/>
		<cfargument name="filter" type="struct" default="#StructNew()#" required="false"
			hint="filter for e.g. products of a certain productgroup, projectkey and so on ">
        <cfargument name="orderBy" type="string" required="false" default="" />

		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var q_select_products_of_contact = 0/>
		<cfinclude template="queries/products/q_select_products_of_contact.cfm"/>
		
		<cfset stReturn.q_select_products_of_contact = q_select_products_of_contact />
		<cfreturn SetReturnStructSuccessCode(stReturn) />

	</cffunction>
	
	<!--- ######################################## --->
	<!--- function for PRODUCTQUANTITY   Author: jarok--->
	
	<cffunction access="public" name="FindProductsQuantity" output="false" returntype="struct"
			hint="Retrun table with quantity">
		<cfargument name="securitycontext" type="struct" required="true"/>
		<cfargument name="usersettings" type="struct" required="true"/>
		<cfargument name="filter" type="struct" default="#StructNew()#" required="false"
			hint="filter for e.g. enabled, productquantitykey, company key">

		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var q_select_productquantity = 0/>
		<cfinclude template="queries/products/q_select_productquantity.cfm"/>
		
		<cfset stReturn.q_select_productquantity = q_select_productquantity />
		<cfreturn SetReturnStructSuccessCode(stReturn) />

	</cffunction>
	
    
	<!--- display products of the contact --->
	<cffunction access="public" name="DisplayProductsOfContact" output="false" returntype="string">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="contactkey" type="string" required="yes">
		<cfargument name="filter" type="struct" default="#StructNew()#" required="false"
			hint="filter for e.g. products of a certain productgroup, projectkey and so on ">
		<cfargument name="editmode" type="boolean" required="no" default="false">
		
		<cfset var sReturn = '' />
		
		<cfinclude template="utils/products/inc_display_products_assigned_to_contact.cfm">
		
		<cfreturn Trim(sReturn) />
	</cffunction>
    
	<cffunction access="public" name="AddProductToContact" output="false" returntype="struct">
		<cfargument name="securitycontext" type="struct" required="true"/>
		<cfargument name="usersettings" type="struct" required="true"/>
		<cfargument name="action_type" type="string" required="true"
			hint="create, edit or other"/>
		<cfargument name="database_values" type="struct" required="true"
			hint="structure with values for database"/>
		<cfargument name="all_values" type="struct" required="true"
			hint="all values posted by the user"/>
		
		<cfset var stReturn = GenerateReturnStruct()/>
		<cfset var a_struct_filter = StructNew() />
        <cfset var q_add_product_to_contact = 0 />
        <cfset var q_update_product_of_contact = 0 />
		<cfset var q_select_productsassignedtocontact = 0 />
		<cfset var a_int_old_quantity = -1 />
		<cfset var q_select_products = 0 />
		<cfset var filter_for_quantity = StructNew() />
		<cfset var stReturn_aq = 0 />
		
		<!--- should we auto-update the lastcontact field? --->
		<cfset var a_bol_autoupdate_lastcontact = (application.components.cmp_person.GetUserPreference( userid = arguments.securitycontext.myuserid,
						section = 'extensions.crm',
						name = 'products.autoupdate_lastupdate_on_add',
						defaultvalue = '0',
						savesetting = false) IS '1') />
						
		<cfset var a_struct_data_update_lastcontact = StructNew() />
		
        <!--- add the product only if the quentity is > 0, otherwise ignore it --->
        <cfif val(arguments.database_values.quantity) GT 0>
       		               
			<cfif action_type IS 'Create'>
			
		        <!--- check if the product exists and if it is enabled --->
				<cfset a_struct_filter = StructNew()/>
				<cfset a_struct_filter.entrykey = arguments.database_values.projectkey />
				<cfset a_struct_filter.enabled = 1/>
				<cfset stReturn = FindProducts(securitycontext = arguments.securitycontext,
													usersettings = arguments.usersettings,
													filter = a_struct_filter)/>
													
		        <cfif stReturn.q_select_products.recordcount IS 0>
					<cfreturn SetReturnStructErrorCode(stReturn, 13504)/>
		        </cfif>
		        
		        <cfset q_select_products = stReturn.q_select_products />
		        
	            <!--- set the serial number of the product --->
	            <cfset arguments.database_values.serialnumber = q_select_products.serialnumber />
		        
		        <cfif q_select_products.individualhandling IS 0>
		        
	    	        <!--- if the product has individual handling than check if such product is already assigned to the contact --->
					<cfset a_struct_filter = StructNew()/>
					<cfset a_struct_filter.projectkey = arguments.database_values.projectkey/>
	                <cfset stReturn = FindProductsOfContact(securitycontext = arguments.securitycontext,
													usersettings = arguments.usersettings,
	                                                contactkey = arguments.database_values.contactkey,
													filter = a_struct_filter)/>
	                <cfif stReturn.q_select_products_of_contact.recordcount GT 0>
                        <cfset a_int_old_quantity = stReturn.q_select_products_of_contact.quantity />
	                    <!--- individualhandling and such product already assigned, so simply update quantity, comment and date ---> 
	                    <cfset arguments.database_values.entrykey = stReturn.q_select_products_of_contact.entrykey />
	                    <cfset arguments.database_values.quantity = int(a_int_old_quantity) + int(arguments.database_values.quantity) />
	        			<cfinclude template="queries/products/q_update_product_of_contact.cfm"/>
	                <cfelse>
	                    <!--- individualhandling and such product is not yet assigned, so create new record ---> 
	        			<cfinclude template="queries/products/q_add_product_to_contact.cfm"/>
	                </cfif>
	            <cfelse>
	                <!--- if the product doesn't have individual handling than simply add new record --->
	    			<cfinclude template="queries/products/q_add_product_to_contact.cfm"/>
		        </cfif>
			<cfelse>
				<cfinclude template="queries/products/q_update_product_of_contact.cfm"/>
			</cfif>
			
			<!--- automagically update the lastcontact property --->
			<cfif a_bol_autoupdate_lastcontact>
			
				<cfset a_struct_data_update_lastcontact.dt_lastcontact = Now() />
				
				<!--- do it! --->	
				<cfinvoke component="#application.components.cmp_addressbook#" method="UpdateContact" returnvariable="stReturn_update_lastcontact">
					<cfinvokeargument name="entrykey" value="#arguments.database_values.contactkey#">
					<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
					<cfinvokeargument name="usersettings" value="#arguments.usersettings#">
					<cfinvokeargument name="newvalues" value="#a_struct_data_update_lastcontact#">
				</cfinvoke>
			
			</cfif>
        </cfif>
		
		<!--- update available quantity --->
		<cfset filter_for_quantity.productkey = arguments.database_values.projectkey />

		<cfinvoke component="#this#" method="FindProductsQuantity" returnvariable="stReturn_aq">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
			<cfinvokeargument name="filter" value="#filter_for_quantity#">
		</cfinvoke>
		
		<!--- if available quantity value is under value 0, send mail to user --->
		<cfif Len(stReturn_aq.q_select_productquantity.quantity) GT 0 AND
				stReturn_aq.q_select_productquantity.quantity LT 0>
					
			<cfmail from="info@openTeamware.com" to="#request.stSecurityContext.q_select_all_email_addresses.emailadr#" subject="#GetLangVal('crm_wd_product_mail_subject')#">
				<cfmailpart type="html">
				<big>#GetLangVal('crm_wd_product_mail_dear')# #request.stSecurityContext.q_select_all_email_addresses.displayname#,</big><br /> #GetLangVal('crm_wd_product_mail_text')#<br /><br />
				<li><b>#GetLangVal('crm_wd_product')#: </b> #stReturn_aq.q_select_productquantity.title#</li>
				<li><b>#GetLangVal('crm_wd_product_aq')#: </b> #stReturn_aq.q_select_productquantity.quantity#</li>
				</cfmailpart>
			</cfmail>
			
		</cfif>
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>
    
	<cffunction access="public" name="RemoveProductFromContact" output="false" returntype="struct">
		<cfargument name="securitycontext" type="struct" required="true"/>
		<cfargument name="usersettings" type="struct" required="true"/>
		<cfargument name="entrykey" type="string" required="true"/>

		<cfset var stReturn = GenerateReturnStruct()/>
        <cfset var q_delete_product_from_contact = 0/>
        
        <!--- delete the product from the contact --->
        <cfinclude template="queries/products/q_delete_product_from_contact.cfm"/>
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>
    
    
    <!--- functions for PRODUCTASSIGNMENT_HISTORY entity --->    
    
	<cffunction access="public" name="FindProductAssignmentHistory" output="false" returntype="struct"
			hint="Return products assigned to a given address book item (contact, account or lead">
		<cfargument name="securitycontext" type="struct" required="true"/>
		<cfargument name="usersettings" type="struct" required="true"/>
		<cfargument name="by_customer_username" type="boolean" default="false" required="false" 
					hint="Use for generating report (columns customer and username added)"/>
		<cfargument name="filter" type="struct" default="#StructNew()#" required="false"
			hint="filter for e.g. contactkey, products of a certain productgroup (productgroukey) and productkey ">

		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var q_select_productassignment_history = 0 />
		<cfinclude template="queries/products/q_select_productassignment_history.cfm"/>
		
		<cfset stReturn.q_select_productassignment_history = q_select_productassignment_history />
		<cfreturn SetReturnStructSuccessCode(stReturn) />

	</cffunction>
	
	<cffunction access="public" name="GenerateConfirmationOutputOfAssignments" returntype="struct" output="false"
			hint="Read default .html and replace all variables with given values">
		<cfargument name="securitycontext" type="struct" required="true"/>
		<cfargument name="usersettings" type="struct" required="true"/>
		<cfargument name="contactaddress" type="string" required="true">
		<cfargument name="content" type="string" required="true">
		<cfargument name="is_sale" type="boolean" default="false" required="false"
			hint="is it an invoice or just a simple confirmation?">
	
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var a_str_content = '' />
		<cfset var a_str_element_name = 'productadd_confirmation' />
		
		<!--- in case of sale, use different template --->
		<cfif arguments.is_sale>
			<cfset a_str_element_name = 'productadd_confirmation_sale' />
		</cfif>
		
		<cfset a_str_content = application.components.cmp_content.GetCompanyCustomElement(companykey = arguments.securitycontext.mycompanykey,
				elementname = a_str_element_name) />

		<cfset a_str_content = ReplaceNoCase(a_str_content, '%DATE%', LSDateFormat(Now(), arguments.usersettings.default_dateformat)) />
		<cfset a_str_content = ReplaceNoCase(a_str_content, '%ADDRESS%', arguments.contactaddress) />
		<cfset a_str_content = ReplaceNoCase(a_str_content, '%CONTENT%', arguments.content) />
		
		<cfsavecontent variable="a_str_content">
		<html>
			<head>
				<title>Confirmation</title>
				<style type="text/css">
					body,p,td,div {font-family:Arial;font-size:12px;}
				</style>
			</head>
		<body>
		<cfoutput>#a_str_content#</cfoutput>
		</body>
		</html>
		</cfsavecontent>
		
		<cfset stReturn.a_str_content = a_str_content />
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>
    
    <cffunction access="public" name="FindRecordsTravelling" output="false" returntype="struct"
			hint="">
		<cfargument name="securitycontext" type="struct" required="true"/>
		<cfargument name="usersettings" type="struct" required="true"/>
		<cfargument name="useinreport" type="boolean" default="false" required="false" 
					hint="Use for generating report (column customer added)"/>
		<cfargument name="filter" type="struct" default="#StructNew()#" required="false"
			hint="filter for e.g. start date, end date">

		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var q_select_recording_travelling = 0 />
	
		<cfinclude template="queries/products/q_select_recording_travelling.cfm"/>
		
		<cfset stReturn.q_select_recording_travelling = q_select_recording_travelling />
		<cfreturn SetReturnStructSuccessCode(stReturn) />

	</cffunction>
	
	<cffunction access="public" name="FindTotalValuesTravelRecords" output="false" returntype="struct"
			hint="">
		<cfargument name="securitycontext" type="struct" required="true"/>
		<cfargument name="usersettings" type="struct" required="true"/>
		<cfargument name="filter" type="struct" default="#StructNew()#" required="false"
			hint="filter for e.g. start date, end date">

		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var q_select_recording_travel_total = 0/>
	
		<cfinclude template="queries/products/q_select_record_travel_total.cfm"/>
		
		<cfset stReturn.q_select_recording_travel_total = q_select_recording_travel_total />
		<cfreturn SetReturnStructSuccessCode(stReturn) />

	</cffunction>
    
    
    
    
    






    
	<cffunction access="public" name="GetProduct" output="false" returntype="struct"
			hint="return a product by entrykey">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="entrykey" type="string" required="true"
			hint="entrykey of product">
			
		<cfset var stReturn = GenerateReturnStruct() />
        <cfset var q_select_product =0/>		
		include query ...
		
		<cfset stReturn.q_select_product = q_select_product />
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />

	</cffunction>

	
	<cffunction access="public" name="GetAllProductsOfCompany" output="false" returntype="struct">
		securitycontext
		usersettings
		<cfargument name="filter" type="struct" default="#StructNew()#" required="false"
			hint="filter for e.g. products of a certain productgroup?">
		
		return all products of a company, but allow filtering as well based on
			- category
			- productgroupkey
			
		first of all, load all userkeys of the company, then load the products using these contactkeys
	
	</cffunction>
	
    <cffunction access="public" name="CreateProductGroup" output="false" returntype="struct">
		
		create a productgroup
		
		mycrm.`productgroups` (
  `id` int(11) NOT NULL auto_increment,
  `entrykey` varchar(40) NOT NULL,
  `companykey` varchar(40) NOT NULL,
  `categoryname` varchar(255) NOT NULL,
  `dt_created` datetime NOT NULL,
  `createdbyuserkey` varchar(40) NOT NULL,
  `description` varchar(255) NOT NULL,
  `parentproductcategoryentrykey` varchar(40) NOT NULL,
  PRIMARY KEY  (`id`)
)
	
	</cffunction>
	
	<cffunction access="public" name="UpdateProductGroup" output="false" returntype="struct">
	
		update from arguments.newvalues structure ...
		check permssion the same way as above
		
	</cffunction>
	
	<cffunction access="public" name="CreateProduct" output="false" returntype="struct">
		securitycontext
		usersettings

		name
		description
		purchase_price float ... optional
		retail_price float ... optional
		enabled ... 0/1 ... allow to add product to customers or not
?		producturl ... url to product information
		vendorpartnumber ... id of vendor
		partnumber ... internal part number
		serialnumber ... possible serial number
?		categories
		productgroupkey
		weight
		defaultsupporttermindays (default: 730, 2 years)
		individualhandling (0/1) ... default = 0 ... handle products individually or join them
			together on adding new items of this product to customer
	
		<cfset var a_str_new_productkey = CreateUUID() />
		create a new product, return entryeky
	
	</cffunction>
	
	<cffunction access="public" name="UpdateProduct" output="false" returntype="struct">
		update values
	</cffunction>
	
	<cffunction access="public" name="DisableProduct" output="false" returntype="struct">
		securitycontext
		usersettings
		productkey
		
		
		call UpdateProduct with enabled = 0 
	
	</cffunction>
	
	
	<cffunction access="public" name="RemoveProductFromCustomer" output="false" returntype="struct">
		securitycontext
		usersettings
		quantity ... quantity to remove ... if "0", remove whole product from customer
		
	
	</cffunction>
	
	<cffunction access="public" name="CreateProductDevelopmentHistoryItem" output="false" returntype="struct">
		securitycontext
		usersettings
		productkey
		oldquantity
		
		add an item in the history to see later on the development of the product at this customer
	
	</cffunction>
	

</cfcomponent>

<!--- //
	$Log: cmp_products.cfc,v $
	Revision 1.32  2007-11-19 16:32:44  hansjp
	auto-update lastcontact on adding new products

	Revision 1.31  2007-11-01 17:00:34  hansjp
	*** empty log message ***

	Revision 1.30  2007-10-11 18:23:33  hansjp
	generate product add confirmation

	Revision 1.29  2007-09-10 13:35:15  hansjp
	- varing all local variables- xml formatting

	Revision 1.28  2007-08-26 22:35:42  hansjp
	*** empty log message ***

	Revision 1.27  2007-08-06 23:19:29  hansjp
	var used variables

	Revision 1.26  2007-08-02 09:14:06  jarok
	filter by start, end dates added to function FindRecordsTravelling

	Revision 1.25  2007-08-02 08:40:31  jarok
	filter for start, end date added to FindTotalValuesTravelRecords
	"useinreport" argumet added to FindRecordsTravelling

	Revision 1.24  2007-07-30 12:15:22  jarok
	functions FindRecordsTravelling and FindTotalValuesTravelRecords added

	Revision 1.23  2007-07-26 15:27:23  jarok
	one path to query fixed

	Revision 1.22  2007-07-26 07:58:48  jarok
	new argument by_customer_username added in function FindProductAssignmentHistory

	Revision 1.21  2007-07-23 13:20:55  jarok
	mail in function AddProductToContact supported NLS

	Revision 1.20  2007-07-20 14:18:59  jarok
	sending mail if available quantity is LT 0 (inside function AddProductToContact)

	Revision 1.19  2007-07-20 12:01:11  jarok
	calculation of arguments.database_values.quantity changed

	Revision 1.18  2007-07-19 08:05:15  jarok
	function DisplayProductsQuantity canceled

	Revision 1.17  2007-07-13 14:28:00  jarok
	corection one query path

	Revision 1.16  2007-07-10 19:49:18  hansjp
	use new query paths

	Revision 1.15  2007-07-09 15:50:30  jarok
	add new function FindProductsQuantity which find quantity of products
	add new function DisplayProductsQuantity which render table with products and their quantities

	Revision 1.14  2007-07-04 08:55:12  jarok
	change var a_int_old_quantity to functionlocal (all occurrences)

	Revision 1.13  2007-06-27 14:23:09  hansjp
	FindProductAssignmentHistory function added

	Revision 1.12  2007-06-27 11:21:47  hansjp
	orderBy arguments added to find functions
	AddProductToContact updated (add only if quantity > 0)

	Revision 1.11  2007-05-29 17:00:54  hansjp
	trim return

	Revision 1.10  2007/05/25 15:17:54  hansjp
	functions for adding, browsing and removing products to/from contacts
	
	Revision 1.9  2007/05/24 15:00:23  hansjp
	FindProductsOfContact and DisplayProductsOfContact functions added
	
	Revision 1.8  2007/05/18 13:53:55  hansjp
	function CreateUpdateProduct added
	+ using XML style
	
	Revision 1.7  2007/05/17 11:30:00  hansjp
	added comments and todos
	
	Revision 1.6  2007/05/16 13:43:18  hansjp
	productGroup related function implemented
	
	Revision 1.5  2007/04/05 08:06:44  hansjp
	*** empty log message ***
	
	Revision 1.4  2007/03/28 17:25:44  hansjp
	adding product management / administration
	
	Revision 1.3  2007/03/28 15:45:11  hansjp
	*** empty log message ***
	
	Revision 1.2  2007/03/27 10:25:28  hansjp
	starting product admin component
	
	// --->