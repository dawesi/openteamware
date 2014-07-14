<!--- affiliate --->

<cfif request.a_bol_distributor_has_been_provided>

	<!--- load distributor --->
	<cfquery name="q_select_distributor" datasource="#request.a_str_db_users#">
	SELECT
		companyname,smalllogopath,homepage
	FROM
		reseller
	WHERE
		entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.a_str_distributorkey#">
	;
	</cfquery>
	
	<b><cfoutput>#GetLangVal('snp_ph_in_cooperation_with')#</cfoutput></b>
	
	<cfif Len(q_select_distributor.smalllogopath) GT 0>
	
		<cfif Len(q_select_distributor.homepage) GT 0>
			<a href="<cfoutput>#q_select_distributor.homepage#</cfoutput>" target="_blank">
		</cfif>	
		
		<img border="0" vspace="6" hspace="6" src="/images/partner/<cfoutput>#q_select_distributor.smalllogopath#</cfoutput>">
		
		<cfif Len(q_select_distributor.homepage) GT 0>
			</a>
		</cfif>
		
		<br>
	</cfif>
	
	<cfoutput><b>#htmleditformat(q_select_distributor.companyname)#</b></cfoutput>
	<br><br>
</cfif>

<!--- systempartner has been provided --->
<cfif (request.a_bol_systempartner_has_been_provided) AND (request.a_str_resellerkey IS NOT request.a_str_distributorkey)>

	<cfquery name="q_select_partner" datasource="#request.a_str_db_users#">
	SELECT
		companyname,smalllogopath,homepage
	FROM
		reseller
	WHERE
		entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.a_str_resellerkey#">
	;
	</cfquery>
	
	
	<b><cfoutput>#GetLangVal('snp_ph_in_cooperation_with')#</cfoutput></b>
	
	<cfif Len(q_select_partner.smalllogopath) GT 0>
	
		<cfif Len(q_select_partner.homepage) GT 0>
			<a href="<cfoutput>#q_select_partner.homepage#</cfoutput>" target="_blank">
		</cfif>
		
		<img border="0" vspace="6" hspace="6" src="/images/partner/<cfoutput>#q_select_partner.smalllogopath#</cfoutput>">
		
		<cfif Len(q_select_partner.homepage) GT 0>
			</a>
		</cfif>		
				
		<br>
	</cfif>
		
	<cfoutput><b>#htmleditformat(q_select_partner.companyname)#</b></cfoutput>
	<br><br>
</cfif>