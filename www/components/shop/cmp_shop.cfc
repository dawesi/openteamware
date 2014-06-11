<cfcomponent output=false>
	
	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<cffunction access="public" name="addtobasket" returntype="struct" output="false"
		hint="add a product to the basket">
		<cfargument name="companykey" type="string" required="true">
		<cfargument name="productkey" type="string" required="true">
		<cfargument name="quantity" type="numeric" required="true" hint="quantity of this product ... total number">
		<cfargument name="nextsettlementperiod" type="boolean" default="false" required="false" hint="put in basket for the next settlement period or the current?">
		<cfargument name="createdbyuserkey" type="string" required="true" hint="who has commited this action? ">
		
		<!--- special discount given? do NOT use 0 as default value ... (see q_insert_order.cfm) --->
		<cfargument name="specialdiscount" type="string" default="" required="false">
		
		<cfset var stReturn = StructNew()>
		<cfset stReturn.result = false>
		<cfset stReturn.message = ''>
		
		<cflog text="------------- add to basket" type="Information" log="Application" file="ib_sales">
		<cflog text="companykey: #arguments.companykey#" type="Information" log="Application" file="ib_sales">
		<cflog text="productkey: #arguments.productkey#" type="Information" log="Application" file="ib_sales">
		<cflog text="quantity: #arguments.quantity#" type="Information" log="Application" file="ib_sales">
		
		<cfif VAL(arguments.quantity) LT 1>
			<cfset stReturn.message = 'quantity is zero'>
			<cfreturn stReturn>
		</cfif>
		
		<!--- load the company data --->
		<cfinvoke component="#application.components.cmp_customer#" method="GetCustomerData" returnvariable="q_select_customer">
			<cfinvokeargument name="entrykey" value="#arguments.companykey#">
		</cfinvoke>
		
		<cfset stReturn.q_select_customer = q_select_customer>		
		
		<!--- does this product exist? --->
		
		<!--- is the company still active? --->
		<cfif q_select_customer.recordcount IS 0>
			<cfset stReturn.message = 'thiscompanydoesnotexist'>
			<cfreturn stReturn>
		</cfif>
		
		<cfif q_select_customer.disabled IS 1>
			<cfset stReturn.message = 'thiscompanyisdisabled'>
			<cfreturn stReturn>
		</cfif>		
		
		<!--- load the prices of this product --->		
		<cfset q_select_prices = getprices(productkey = arguments.productkey)>
		
		<!--- load the product ... --->
		<cfset q_select_product = getproduct(productkey = arguments.productkey)>
		
		<cfset stReturn.q_select_prices = q_select_prices>
		<cfset stReturn.q_select_product = q_select_product>
		
		<!--- select the price according to the number of items --->
		<cfquery name="q_select_price" dbtype="query" maxrows="1">
		SELECT
			*
		FROM
			q_select_prices
		WHERE
			quantity <= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.quantity#">
		ORDER BY
			quantity
		;
		</cfquery>
		
		<!--- set quantity to the current number ... --->
		<cfset QuerySetCell(q_select_price, 'quantity', arguments.quantity, 1)>
		
		<cfset stReturn.q_select_price = q_select_price>
				
		<!--- calculate the already bought items --->
		<cfset a_int_quantity_already_bought = 0>
		
		<!--- if NOT for next settlement period, check the number of already bought seats, otherwise begin from scratch with counting ... --->
		<cfif NOT arguments.nextsettlementperiod>
		
			<cfswitch expression="#arguments.productkey#">
				<!--- check if a licence already has been bought ... --->
				<cfcase value="AE79D26D-D86D-E073-B9648D735D84F319">
					<!--- mobile crm --->
					<cfinvoke component="#application.components.cmp_licence#" method="GetLicenceStatus" returnvariable="q_select_licence_status">
						<cfinvokeargument name="companykey" value="#arguments.companykey#">
						<cfinvokeargument name="productkey" value="AE79D26D-D86D-E073-B9648D735D84F319">
					</cfinvoke>
					
					<cfset a_int_quantity_already_bought = q_select_licence_status.totalseats>
					
				</cfcase>
				
				<cfcase value="AD4262D0-98D5-D611-4763153818C89190">
					<!--- mobile office --->
					<cfinvoke component="#application.components.cmp_licence#" method="GetLicenceStatus" returnvariable="q_select_licence_status">
						<cfinvokeargument name="companykey" value="#arguments.companykey#">
						<cfinvokeargument name="productkey" value="AD4262D0-98D5-D611-4763153818C89190">
					</cfinvoke>
					
					<cfset a_int_quantity_already_bought = q_select_licence_status.totalseats>
				</cfcase>	
			</cfswitch>
		
		</cfif>
		
		<cflog text="a_int_quantity_already_bought: #a_int_quantity_already_bought#" type="Information" log="Application" file="ib_sales">
		
		
		<!--- calculate the best price ... --->
		<cfif a_int_quantity_already_bought GT 0>
		
			<cfquery name="q_select_best_price" dbtype="query" maxrows="1">
			SELECT
				MIN(price1) AS price1
			FROM
				q_select_prices
			WHERE
				quantity <= #val(q_select_licence_status.totalseats + q_select_price.quantity)#
			;
			</cfquery>
			
			<cfset stReturn.q_select_best_price = q_select_best_price>
			
			<cfif Val(q_select_best_price.price1) GT 0>
				<!--- set now all rows to this value if higher ... --->
				<cfset a_max_price = q_select_best_price.price1>
				
				<cfloop query="q_select_price">
				
					<cfif q_select_price.price1 GT a_max_price>
						<cfset QuerySetCell(q_select_price, 'price1', DecimalFormat(a_max_price), q_select_price.currentrow)>
					</cfif>
					
				</cfloop>
				
			</cfif>
		</cfif>
		
		
		
		<!--- calculate price ... --->
		<cfif q_select_product.ongoing is 1>
			<!--- ongoing product ... --->
			
			<cfif isDate(q_select_customer.dt_contractend)>
				
				<cfif NOT arguments.nextsettlementperiod AND (q_select_customer.dt_contractend LT Now())>
					<!--- try to calculate the number of months between now and the contract end --->
					<cfset a_int_contract_months_duration = DateDiff('m', now(), q_select_customer.dt_contractend)>
					
					<cfif a_int_contract_months_duration LT 1>
						<!--- calculate at least one month --->
						<cfset a_int_contract_months_duration = 1>
					</cfif>
					
				<cfelse>
					<!--- calculate the full standard settlement interval ... --->
					<cfset a_int_contract_months_duration = q_select_customer.settlementinterval>
				</cfif>
				
			<cfelse>
				<!--- no end date given ... select the standard settlement for this company --->
				<cfset a_int_contract_months_duration = q_select_customer.settlementinterval>
				<!--- standard = 12 months --->
			</cfif>
		<cfelse>
			<!--- a one-time-product --->
			<cfset a_int_contract_months_duration = 1>			
		</cfif>
		
		<cflog text="a_int_contract_months_duration: #a_int_contract_months_duration#" type="Information" log="Application" file="ib_sales">
		
		<!--- the original price --->
		<cfset a_int_original_price = DecimalFormat(a_int_contract_months_duration * q_select_price.price1 * q_select_price.quantity)>
		<!--- the real price --->
		<cfset a_int_price = DecimalFormat(a_int_contract_months_duration * q_select_price.price1 * q_select_price.quantity)>
		
		<cflog text="a_int_price: #a_int_price#" type="Information" log="Application" file="ib_sales">
		<cflog text="q_select_price.quantity: #q_select_price.quantity#" type="Information" log="Application" file="ib_sales">
		<cflog text="a_int_original_price: #a_int_original_price#" type="Information" log="Application" file="ib_sales">
		
		<cfset stReturn.a_int_original_price = a_int_original_price>
		<cfset stReturn.a_int_price = a_int_price>
		
		<!--- insert into order table ... --->
		<cfinclude template="queries/q_insert_order.cfm">
		
		<cfset stReturn.result = true>
		
		<cfreturn stReturn>
	</cffunction>
	
	<!--- return the prices of a product --->
	<cffunction access="public" name="GetPrices" returntype="query" output="false">
		<cfargument name="productkey" type="string" required="true">
		<cfargument name="resellerkey" type="string" required="no" default="" hint="resellerkey ... if empty use default prices">
		
		<cfinclude template="queries/q_select_prices.cfm">
		
		<cfreturn q_select_prices>		
	</cffunction>
	
	<!--- return the prices for a product based on productkey and companykey ... --->
	<cffunction access="public" name="GetPricesEx" returntype="query" output="false">
		<cfargument name="productkey" type="string" required="true">
		<cfargument name="companykey" type="string" required="yes">
		
		<!--- check the settlement type of the company --->
		<cfset a_int_settlement_type = CreateObject('component', request.a_str_component_accounting).GetSettlementTypeOfCompany(companykey = arguments.companykey)>
		
		<cfif a_int_settlement_type IS 0>
			<!--- default ... --->
			<cfset a_str_resellerkey = ''>
		<cfelse>
			<!--- get resellerkey of company --->
			<cfset a_str_resellerkey = application.components.cmp_customer.GetPartnerKeyOfCustomer(companykey = arguments.companykey)>
		</cfif>
		
		<!--- load now prices --->
		<cfinclude template="queries/q_select_prices_ex.cfm">
		
		<cfreturn q_select_prices_ex>
		
	</cffunction>
	
	<!--- return the product --->
	<cffunction access="public" name="GetProduct" returntype="query" output="false">
		<cfargument name="productkey" type="string" required="true">
		<cfinclude template="queries/q_select_product.cfm">
		<cfreturn q_select_product>
	</cffunction>
	
	<cffunction access="public" name="GetProductGroups" returntype="query" output="false">
		<cfargument name="resellerkey" type="string" required="yes">
		
		
	</cffunction>

</cfcomponent>