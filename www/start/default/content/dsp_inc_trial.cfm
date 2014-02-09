

<cfif q_select_is_company_admin.recordcount IS 1>
	<!--- open invoices (dunning letters sent)? --->
	<cfinvoke component="#application.components.cmp_licence#" method="CheckDunningLetters" returnvariable="q_select_dunning_letters">
		<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
	</cfinvoke>
	
	<cfquery name="q_select_dunning_letters" dbtype="query">
	SELECT
		*
	FROM
		q_select_dunning_letters
	WHERE
		dunninglevel = 1
	;
	</cfquery>
	
	<cfif q_select_dunning_letters.recordcount GT 0>
		<div style="padding:4px;" class="mischeader bb">
			<a href="/administration/" target="_blank"><img src="/images/img_groups_blocks.png" width="32" height="32" hspace="4" vspace="4" border="0" align="absmiddle"> <b><cfoutput>#GetLangVal('start_ph_dunnings')#</cfoutput></b></a>
		</div>
		<br>
	</cfif>
</cfif>


<!---<cfif request.stSecurityContext.myuserid is 2>--->
<cfif q_select_company_data.status IS 1>

	<!---<cfinvoke component="#application.components.cmp_customer#" method="GetCompanyContacts" returnvariable="q_select_company_contacts">
		<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
	</cfinvoke>--->
	
	<cfquery name="q_select_reseller" datasource="#request.a_str_db_users#">
	SELECT
		companyname,street,zipcode,city,telephone,emailadr,customercontact,logopath
	FROM
		reseller
	WHERE
		entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_company_data.resellerkey#">
	;
	</cfquery>	

	<cfset a_int_diff = DateDiff('d', Now(), q_select_company_data.dt_trialphase_end)>

	<fieldset class="bg_fieldset">
	<legend>Trial</legend>
	<div style="padding:14px; ">
	<table border="0" cellspacing="0" cellpadding="4" style="border:orange solid 2px; ">
	  <tr>
		<!---<td style="font-size:27px;font-weight:bold; " align="center">
		<img src="/images/img_attention.png"><br>
		<cfoutput>#a_int_diff#</cfoutput>
		</td>--->	  
		<td style="line-height:18px;">
			<cfif Len(q_select_reseller.logopath) gt 0>
				<img align="left" border="0" vspace="4" hspace="4" width="140" src="/images/partner/<cfoutput>#q_select_reseller.logopath#</cfoutput>">
			</cfif>
			
			Sie befinden sich in der kostenlosen Testphase (Ende: <cfoutput>#DateFormat(q_select_company_data.dt_trialphase_end, 'dd.mm.yy')#, in #a_int_diff# Tagen</cfoutput>)
			
			<cfif q_select_is_company_admin.recordcount IS 1>
			[ <a style="text-decoration:underline;" href="https://www.openTeamWare.com/administration/" target="_blank">Zum Shop ...</a> ]
			<cfelse>
				<br>Wenden Sie sich bitte an 
				<cfloop query="q_select_company_contacts">
				
					<cfinvoke component="#application.components.cmp_user#" method="GetUsernamebyentrykey" returnvariable="a_str_username">
						<cfinvokeargument name="entrykey" value="#q_select_company_contacts.userkey#">
					</cfinvoke>
					<cfoutput><a  href="/email/?action=composemail&to=#urlencodedformat(a_str_username)#&subject=Trialphase"><img src="/images/icon/letter_yellow.gif" border="0" align="absmiddle" vspace="2" hspace="2">#a_str_username#</a></cfoutput> <cfif q_select_company_contacts.currentrow NEQ q_select_company_contacts.recordcount>/</cfif>
				</cfloop>
			</cfif>
			
			<br>

			<b>Ihr Ansprechpartner fuer Fragen und Bestellungen:</b><br>
				<cfoutput query="q_select_reseller">#ReplaceNoCase(q_select_reseller.customercontact, chr(10), '<br>', 'ALL')#</cfoutput>
		</td>
	  </tr>
	</table>	
	</div>
	</fieldset>
	<br>
</cfif>