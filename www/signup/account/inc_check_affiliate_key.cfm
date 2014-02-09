
<cfset request.a_bol_affiliate_has_been_provided = false>
<cfset request.a_bol_systempartner_has_been_provided = false>
<cfset request.a_bol_distributor_has_been_provided = false>

<cfset request.a_str_distributorkey = ''>
<!--- head of company ... --->
<cfset request.a_str_resellerkey = '5872C37B-DC97-6EA3-E84EC482D29FC169'>

<cfset request.a_str_affiliatekey = ''>

<cfif StructKeyExists(cookie, 'IB_AFFLIATE_KEY')>
	<!--- check if the entered key is valid ... --->
	<cfquery name="q_select_reseller" datasource="#request.a_str_db_users#">
	SELECT
		entrykey,companyname,issystempartner,isprojectpartner,isdistributor
	FROM
		reseller
	WHERE
		entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cookie.IB_AFFLIATE_KEY#">
	;
	</cfquery>
		
	<cfif q_select_reseller.recordcount GT 0>
		<!--- ok, here we go ... --->
		<cfset request.a_bol_affiliate_has_been_provided = true>
		
		<cfif q_select_reseller.issystempartner IS 1 OR q_select_reseller.isprojectpartner IS 1>
			<cfset request.a_bol_systempartner_has_been_provided = true>
			<cfset request.a_str_resellerkey = q_select_reseller.entrykey>
	
		</cfif>
		
		<cfif q_select_reseller.isdistributor IS 1>
			<cfset request.a_bol_distributor_has_been_provided = true>
			<cfset request.a_str_distributorkey = q_select_reseller.entrykey>

		</cfif>
	</cfif>	
	
	
</cfif> 

<cfif (StructKeyExists(session.a_struct_data, 'partnerid') AND Len(session.a_struct_data.partnerid) GT 0)>
	  
	<cfquery name="q_select_reseller" datasource="#request.a_str_db_users#">
	SELECT
		entrykey,companyname,issystempartner,isprojectpartner,isdistributor
	FROM
		reseller
	WHERE
		<!--- has the user entered a valid partner id? --->
		affiliatecode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.a_struct_data.partnerid#">
	;
	</cfquery>
	
	<!--- IS IT A RESELLER?? --->
	<cfif q_select_reseller.recordcount GT 0>
		<!--- ok, here we go ... --->
		<cfset request.a_bol_affiliate_has_been_provided = true>
		
		<cfif q_select_reseller.issystempartner IS 1 OR q_select_reseller.isprojectpartner IS 1>
			<cfset request.a_bol_systempartner_has_been_provided = true>
			<cfset request.a_str_resellerkey = q_select_reseller.entrykey>

		</cfif>
		
		<cfif q_select_reseller.isdistributor IS 1>
			<cfset request.a_bol_distributor_has_been_provided = true>
			<cfset request.a_str_distributorkey = q_select_reseller.entrykey>
			
			<!--- set cookie --->
			<cfcookie name="IB_AFFLIATE_KEY" value="#q_select_reseller.entrykey#">
		</cfif>
		
	</cfif>
	
	<!--- is it a promocode? --->
	<cfif VAL(session.a_struct_data.partnerid) GT 0>
		
		<cfquery name="q_select_is_promo_code" datasource="#request.a_str_db_users#">
		SELECT
			resellerkey,used,codevalue
		FROM
			promocodes
		WHERE
			code = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(session.a_struct_data.partnerid)#">
		;
		</cfquery>
		
		<cfif q_select_is_promo_code.recordcount IS 1>
			<!--- yes, hit!!! --->
			<cfset request.a_str_promocode = VAL(session.a_struct_data.partnerid)>
			
			<!--- save promocode --->
			<cfcookie name="IB_AFFLIATE_KEY" value="#q_select_is_promo_code.resellerkey#">
			<cfset request.a_bol_distributor_has_been_provided = true>
			<cfset request.a_str_distributorkey = q_select_is_promo_code.resellerkey>
			<cfset request.a_int_promocode_codevalue = q_select_is_promo_code.codevalue>
			
		</cfif>
	
	</cfif>
	
	<!--- last change ... keyword? --->
	
	<cfif Len(session.a_struct_data.partnerid) GT 0>
		
		<!--- check if it is a keyword --->
		<cfquery name="q_select_is_keyword" datasource="#request.a_str_db_users#">
		SELECT
			keyword,percent,resellerkey
		FROM
			keywords
		WHERE
			keyword = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(session.a_struct_data.partnerid)#">
		;
		</cfquery>
		
		<cfif q_select_is_keyword.recordcount IS 1>
			<!--- hit! --->
			
			<cfset request.a_str_keyword = session.a_struct_data.partnerid>
			
			<cfcookie name="IB_AFFLIATE_KEY" value="#q_select_is_keyword.resellerkey#">
			<cfset request.a_bol_distributor_has_been_provided = true>
			<cfset request.a_str_distributorkey = q_select_is_keyword.resellerkey>
			<cfset request.a_int_keyword_value = q_select_is_keyword.percent>
		</cfif>
	
	</cfif>

</cfif>