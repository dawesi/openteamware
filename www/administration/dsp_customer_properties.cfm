<!--- //

	Module:		Administrationtool
	Action:		CustomerProperties
	Description:Display customer properties
	
// --->
<cfinclude template="dsp_inc_select_company.cfm">
	
<cfset LoadCompanyData.entrykey = url.companykey>
<cfinclude template="queries/q_select_company_data.cfm">


<cfif q_select_company_data.recordcount is 0>
  no such company found 
  <cfexit method="exittemplate">
</cfif>

<cfset GetNumberofcustomersRequest.companykey = q_select_company_data.entrykey>
<cfinclude template="queries/q_select_number_of_customers.cfm">

<cfset SelectAccounts.CompanyKey = q_select_company_data.entrykey>
<cfinclude template="queries/q_select_accounts.cfm">

<cfset SelectBookedServices.companykey = q_select_company_data.entrykey>
<cfset SelectBookedServices.SettledType = 1>
<cfinclude template="queries/q_select_booked_services.cfm">

<cfif request.a_bol_is_reseller>
	<cfinvoke component="/components/tools/cmp_comments" method="GetCommentsInternal" returnvariable="stReturn">
		<cfinvokeargument name="servicekey" value="#request.sCurrentServiceKey#">
		<cfinvokeargument name="objectkey" value="#url.companykey#">
	</cfinvoke>
	<cfset q_select_comments = stReturn.q_select_comments>
</cfif>

<cfinvoke component="#request.a_str_component_billing#" method="GetBills" returnvariable="q_select_invoices">
	<cfinvokeargument name="companykey" value="#url.companykey#">
</cfinvoke>

<h4><cfoutput>#GetLangVal('adm_ph_customer_data')#</cfoutput> <cfoutput>#htmleditformat(q_select_company_data.companyname)#</cfoutput></h4>

<!--- data ... --->
<!--- AND request.a_str_reseller_entry_key IS 'D347486D-BE39-67D4-22A13225317F7413' --->
<cfif request.a_bol_is_reseller AND q_select_accounts.recordcount IS 0>
		<cfquery name="q_select_activate_code" datasource="#request.a_str_db_users#">
		SELECT
			*
		FROM
			activatecodes
		WHERE
			companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.companykey#">
		;
		</cfquery>
		
		<cfif q_select_activate_code.recordcount IS 0>
			<div style="border:orange solid 2px;padding:4px;" class="mischeader">
			<img src="/images/menu/img_icon_followups_32x32.gif" border="0" align="left" vspace="4" hspace="4">
			<a  href="default.cfm?<cfoutput>#writeurltags()#</cfoutput>&action=createactivatecode"><b><cfoutput>#GetLangVal('adm_ph_create_and_send_activation_code')#</cfoutput></b></a>
			<br>
			<cfoutput>#GetLangVal('adm_ph_create_and_send_activation_code_alternative')#</cfoutput>
			<br>
			<a href="default.cfm?action=newuser&<cfoutput>#writeurltags()#</cfoutput>&productkey=AE79D26D-D86D-E073-B9648D735D84F319"><cfoutput>#GetLangVal('cm_ph_please_click_here_to_proceed')#</cfoutput></a>
			</div>
			<br>
		</cfif>
		
		<cfif q_select_activate_code.recordcount IS 1 AND q_select_activate_code.activated IS 0>
			<div style="border:orange solid 2px;padding:4px; ">
			<a  href="default.cfm?<cfoutput>#writeurltags()#</cfoutput>&action=createactivatecode"><img src="/images/menu/img_icon_followups_32x32.gif" align="absmiddle" border="0"> <b><cfoutput>#GetLangVal('adm_ph_send_activation_code_again')#</cfoutput></b></a>
			</div>							
			<br>
		</cfif>
	
</cfif>

<cfsavecontent variable="a_str_content">


<cfquery name="q_select_reseller_name" datasource="#request.a_str_db_users#">
SELECT
	companyname
FROM
	reseller
WHERE
	entrykey = '#q_select_company_data.resellerkey#'
;
</cfquery>

<table border="0" cellspacing="0" cellpadding="4">
  <tr>
	<td valign="top">
	
		<fieldset class="default_fieldset">
		<legend style="font-weight:bold; "><cfoutput>#GetLangVal('cm_wd_summary')#</cfoutput></legend>
			
		<div>
		
		<table border="0" cellspacing="0" cellpadding="4">
		  <tr> 
			<td valign="top">
			
			<table border="0" cellspacing="0" cellpadding="4">
			<cfoutput query="q_select_company_data">
				<cfif request.a_bol_is_reseller AND Len(q_select_company_data.distributorkey) GT 0>
					<tr>
						<td align="right">#GetLangVal('adm_wd_distributor')#:</td>
						<td>
							<cfquery name="q_select_distriname" datasource="#request.a_str_db_users#">
							SELECT
								companyname
							FROM
								reseller
							WHERE
								entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_company_data.distributorkey#">
							;
							</cfquery>
							
							#q_select_distriname.companyname#
						</td>
					</tr>
				</cfif>
				<tr>
					<td align="right">#GetLangVal('adm_wd_partner')#:</td>
					<td>
					<a href="default.cfm?action=resellerproperties&resellerkey=#urlencodedformat(q_select_company_data.resellerkey)#">#q_select_reseller_name.companyname#</a>
					</td>
				</tr>
				<cfif Len(q_select_company_data.signupsource) GT 0>
					<tr>
						<td align="right">
							#GetLangVal('cm_wd_source')#:
						</td>
						<td>
							#q_select_company_data.signupsource#
						</td>
					</tr>
				</cfif>
				<tr>
					<td align="right">#GetLangVal('adm_ph_created_by')#:</td>
					<td>
						<cfif Len(q_select_company_data.createdbyuserkey) IS 0>
							#GetLangVal('adm_ph_web_self_registration')#
						<cfelse>
							<cfinvoke component="#application.components.cmp_user#" method="GetUsernameByentrykey" returnvariable="a_str_username">
								<cfinvokeargument name="entrykey" value="#q_select_company_data.createdbyuserkey#">
							</cfinvoke>
							
							<cfif Len(a_str_username) GT 0>
								#a_str_username# (#GetLangVal('adm_wd_partner')#)
							<cfelse>
								#GetLangVal('adm_wd_partner')#
							</cfif>
						</cfif>
					</td>
				</tr>
				<cfif (q_select_company_data.settlement_type IS 0) AND (q_select_company_data.generaltermsandconditions_accepted IS 0)>
				<tr>
					<td align="right">&nbsp;</td>
					<td style="background-color:##FF9966;">
						#GetLangVal('adm_ph_not_activated_yet')#
					</td>
				</tr>
				</cfif>
				
				<cfif len(q_select_company_data.description) gt 0>
				  <tr> 
					<td align="right">#GetLangVal('cm_wd_description')#:</td>
					<td>#q_select_company_data.description#</td>
				  </tr>
				</cfif>
				<cfif q_select_company_data.disabled IS 1>
					<tr bgcolor="red">
						<td colspan="2" style="color:white;font-weight:bold;">
						Dieser Kunde wurde gesperrt.<bR>
						Datum: #dateformat(q_select_company_data.dt_disabled, 'dd.mm.yy')#<br>
						Grund: #q_select_company_data.disabled_reason#
						</td>
					</tr>
				</cfif>
				<tr>
					<td align="right" valign="top">#GetLangVal('cm_wd_status')#:</td>
					<td valign="top">
					<cfif q_select_company_data.status is 0>
					#GetLangVal('adm_wd_customer')#
					<cfelse>
					<b style="color:Red;">#GetLangVal('adm_ph_interested_party')#
					
						<cfif q_select_company_data.generaltermsandconditions_accepted IS 1>
							<br>
							<cfif IsDate(q_select_company_data.dt_trialphase_end)>
							#GetLangVal('adm_ph_end_trialphase')#: #DateFormat(q_select_company_data.dt_trialphase_end, 'dd.mm.yyyy')#</b>
							<br>
							#ReplaceNoCase(GetLangVal('cm_ph_in_n_days'), '%DAYS%', DateDiff('d', now(), q_select_company_data.dt_trialphase_end))#
						</cfif>
						
						<cfif q_select_company_data.autoorderontrialend IS 0>
							<br><img src="/images/info.jpg" align="absmiddle" vspace="2" hspace="2"> #GetLangVal('adm_ph_no_autoorder')#
						</cfif>
					</cfif>
					
					<cfif request.a_bol_is_reseller AND q_select_company_data.generaltermsandconditions_accepted IS 1>
					<br>
					<a href="default.cfm?action=customer.extendtrialphase#writeurltags()#">#GetLangVal('adm_ph_extend_trialphase')#</a> | <a href="javascript:alert('#GetLangValJS('adm_ph_extend_trialphase_contact_office')#');">#GetLangVal('cm_wd_delete')#</a>
					</cfif>
					</cfif>
					</td>
				</tr>
				<cfif request.a_bol_is_reseller>
				<tr>
					<td align="right">#GetLangVal('adm_wd_settlement')#:</td>
					<td>
						#GetLangVal('adm_ph_settlement_type_' & q_select_company_data.settlement_type)#						
					</td>
				</tr>
				</cfif>
				<tr> 
				  <td align="right">#GetLangVal('adm_ph_customer_id')#:</td>
				  <td>#q_select_company_data.customerid#</td>
				</tr>
				<tr> 
				  <td align="right">#GetLangVal('cm_wd_created')#:</td>
				  <td>#lsdateformat(q_select_company_data.dt_created, "dd.mm.yy")#</td>
				</tr>
				<tr> 
				  <td align="right">#GetLangVal('adm_ph_end_of_contract')#:</td>
				  <td>
					<cfif isDate(q_select_company_data.dt_contractend) is true>
					 #dateformat(q_select_company_data.dt_contractend, "dd.mm.yy")# 
					 <cfelse>
					 #GetLangVal('adm_ph_nothing_ordered_yet')#
					 </cfif>
				</td>
				</tr>
				
			  </table> 
			  
			
			  <!--- end left table ... --->
			</td>
			<td valign="top"> 
			  <!--- start right table .. --->
			  <table border="0" cellpadding="4" cellspacing="0">
				<tr> 
				  <td><b>#GetLangVal('adm_wd_additional_information')#</b></td>
				</tr>
				<cfif request.a_bol_is_reseller>
				<tr> 
				  <td>
				  #GetLangVal('cm_wd_comments')#: #q_select_comments.recordcount#
				  <br><br>
				  <a href="default.cfm?action=activity&#WriteURLTags()#">#GetLangVal('cm_ph_show_usage')#</a>
				  </td>
				</tr>
				</cfif>
				<tr>
					<td>
					#listlen(q_select_company_data.domains, ',')# #GetLangVal('cm_wd_domains')#<br>
					
					<cfloop list="#q_select_company_data.domains#" delimiters="," index="a_str_domain">
					#a_str_domain#<br>
					</cfloop>
					</td>
				</tr>
				
				
			  		
			  </table>
			  </td>
		  </tr>
		</table>
		</cfoutput>
		
		
  		</div>
			
		</fieldset>
		

	</td>
    <td valign="top">
		<!--- financial things ... --->
		
		<fieldset class="default_fieldset">
		
		<legend><b><cfoutput>#GetLangVal('adm_ph_ordered_services')#</cfoutput> (<cfoutput>#q_select_booked_services.recordcount#)</cfoutput></b></legend>

		<div>
		<table border="0" cellspacing="0" cellpadding="4">
		  <tr> 
			<td>
				
				<table width="100%" border="0" cellspacing="0" cellpadding="4">
				<tr class="mischeader"> 
				<cfoutput>
				  <td>#GetLangVal('adm_ph_ordered_services_quantity')#</td>
				  <td>#GetLangVal('cm_wd_description')#</td>
				 </cfoutput>
				</tr>
				<cfoutput query="q_select_booked_services" startrow="1" maxrows="10"> 
				  <tr> 
					<td align="right">
						#q_select_booked_services.quantity#
					</td>
					<td>
						#htmleditformat(q_select_booked_services.productname)#
					</td>
				  </tr>
				</cfoutput> 
				
				<cfquery name="q_select_invoices" dbtype="query" maxrows="10">
				SELECT
					*
				FROM
					q_select_invoices
				WHERE
					cancelled = 0
				ORDER BY
					dt_created DESC
				;
				</cfquery>
				
				<tr>
					<td class="lightbg" colspan="7"><cfoutput>#GetLangVal('cm_wd_invoices')#</cfoutput> (<cfoutput>#q_select_invoices.recordcount#)</cfoutput></td>
				</tr>
				<tr>
					<td colspan="7">
					
					
					<table width="100%" border="0" cellspacing="0" cellpadding="2">
					  <tr>
						<td><cfoutput>#GetLangVal('adm_wd_invoice_number')#</cfoutput></td>
						<td><cfoutput>#GetLangVal('adm_wd_invoice_sum')#</cfoutput></td>
						<td><cfoutput>#GetLangVal('adm_wd_invoice_paid')#</cfoutput></td>
						<td><cfoutput>#GetLangVal('adm_ph_invoices_dunning_level')#</cfoutput></td>
						<td><cfoutput>#GetLangVal('cm_wd_show')#</cfoutput></td>
					  </tr>
					  <cfoutput query="q_select_invoices">
					  <tr>
						<td>
							#q_select_invoices.invoicenumber#
						</td>
						<td align="right">
							#q_select_invoices.invoicetotalsum#
						</td>
						<td align="center">
							#YesNoFormat(q_select_invoices.paid)#
						</td>				
						<td align="center">
							<cfif q_select_invoices.paid IS 0>
							#q_select_invoices.dunninglevel#
							</cfif>
						</td>
						<td>
							<a target="_blank" href="tools/dl_invoice.cfm?entrykey=#q_select_invoices.entrykey##writeurltags()#">#GetLangVal('cm_wd_show')# ...</a>
						</td>
					  </tr>
					  </cfoutput>
					</table>
					
					</td>
				</tr>
				
				<tr> 
				  <td colspan="7">
				  <a href="default.cfm?action=shop<cfoutput>#WriteURLTags()#</cfoutput>"><b><cfoutput>#GetLangVal('adm_ph_add_products_shop')#</cfoutput></b>
				  <br><br>
				  <a href="default.cfm?action=licence.status<cfoutput>#WriteURLTags()#</cfoutput>"><cfoutput>#GetLangVal('adm_ph_show_licence_status')#</cfoutput></a>
				  </td>
				</tr>
			  </table> 
			  
			
			 </td>
		  </tr>
		</table>
		</div>
		</fieldset>
	</td>
  </tr>
</table>


</cfsavecontent>
<cfsavecontent variable="a_str_buttons">
<cfoutput>
	<input type="button" value="#GetLangVal('adm_ph_nav_account_data')#" class="btn2" onclick="GotoLocHref('default.cfm?action=editcustomer&#WriteURLTags()#');" />
	<input type="button" value="#GetLangVal('adm_wd_administrators')#" class="btn2" onclick="GotoLocHref('default.cfm?action=customercontacts&#WriteURLTags()#');" />
	<input type="button" value="#GetLangVal('adm_ph_create_datasheet')#" class="btn2" onclick="GotoLocHref('default.cfm?action=customer.createfulldatasheet&#WriteURLTags()#');" />
	
	<cfif request.a_bol_is_reseller>
		<input type="button" value="#GetLangVal('adm_ph_assign_to_other_partner')#" class="btn2" onclick="GotoLocHref('default.cfm?action=assigntootherreseller&#WriteURLTags()#');" />
	</cfif>
	
</cfoutput>
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('cm_wd_summary'), a_str_buttons, a_str_content)#</cfoutput>

<br /><br />
<cfsavecontent variable="a_str_content">

	<table border="0" cellspacing="0" cellpadding="4">
		
		<cfif q_select_accounts.recordcount IS 0>
			<form>
			<tr>
				<td colspan="3">
				<input type="button" class="btn" name="frmbtn" value="<cfoutput>#GetLangVal('adm_ph_add_user_now')#</cfoutput>" onClick="location.href='?action=useradministration&<cfoutput>#WriteURLTags()#</cfoutput>';">
				</td>
			</tr>
			</form>
		</cfif>
	  <cfoutput query="q_select_accounts" startrow="1" maxrows="10"> 
		<tr> 
		  <td>
			  
			  <img src="/images/si/user.png" class="si_img" />#q_select_accounts.username#</td>
		  <td>
			#htmleditformat(q_select_accounts.surname)#, #htmleditformat(q_select_accounts.firstname)#
		  </td>
		  <td>
		  </td>
		</tr>
	  </cfoutput> 
	</table>


	</div>
</fieldset>

</cfsavecontent>
<cfsavecontent variable="a_str_buttons">
	<cfoutput>
		<input type="button" value="#GetLangVal('cm_wd_edit')#" onclick="GotoLocHref('default.cfm?action=useradministration&#WriteURLTags()#');" class="btn2" />
	</cfoutput>
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('adm_wd_accounts') & ' (' & q_select_number_of_customers.count_id & ')', a_str_buttons, a_str_content)#</cfoutput>  

<br />
 
<cfinclude template="queries/q_select_workgroups.cfm">

<cfsavecontent variable="a_str_content">

	<ul class="ul_nopoints">
	<cfoutput query="q_select_workgroups">
		<li><a href="default.cfm?action=workgroupproperties&entrykey=#q_select_workgroups.entrykey#&#writeurltags()#"><img src="/images/si/group.png" class="si_img" />  #htmleditformat(q_select_workgroups.groupname)#</a></li>
	</cfoutput>
	</ul>
			
</cfsavecontent>
<cfsavecontent variable="a_str_buttons">
	<cfoutput >
		<input type="button" class="btn2" onclick="GotoLocHref('default.cfm?action=workgroups&#writeurltags()#');" value="#GetLangVal('cm_wd_edit')#" />
	</cfoutput>
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('cm_wd_workgroups') & ' (' & q_select_workgroups.recordcount & ')', a_str_buttons, a_str_content)#</cfoutput>


<cfif request.a_bol_is_reseller>
	<br>
	<cfif q_select_comments.recordcount GT 0>
	<span style="background-color:#FFFF99;" style="padding:5px;">
	</cfif>
	<b><cfoutput>#GetLangVal('cm_wd_comments')#</cfoutput> (<cfoutput>#q_select_comments.recordcount#</cfoutput>) ...</b>
	<cfif q_select_comments.recordcount GT 0>
	</span>
	</cfif>
	
		<cfoutput>
		&nbsp;[ <a href="javascript:AddComment('#jsstringformat(request.sCurrentServiceKey)#','#jsstringformat(url.companykey)#');">#GetLangVal('adm_wd_add_comment')#</a> ]
		</cfoutput>
	<br>
	<table border="0" cellspacing="0" cellpadding="4">
	  <cfoutput query="q_select_comments">
	  
		<cfinvoke component="#application.components.cmp_user#" method="GetUsernamebyentrykey" returnvariable="a_str_username">
			<cfinvokeargument name="entrykey" value="#q_select_comments.userkey#">
		</cfinvoke>
					
	  <tr>
		<td valign="top">#lsdateformat(q_select_comments.dt_created, "dd.mm.yy")# #TimeFormat(q_select_comments.dt_created, "HH:mm")#</td>
		<td valign="top">#a_str_username#</td>
		<td valign="top">#replacenocase(q_select_comments.comment, chr(10), "<br>", "ALL")#</td>
	  </tr>
	  </cfoutput>
	</table>
</cfif>

