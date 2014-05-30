<!--- //

	Module:		AddressBook
	Action:		doPostBackgroundAction
	Description:Do a duplicate check ...
	
// --->

<cfprocessingdirective pageencoding="utf-8">


<cfset a_struct_loadoptions = StructNew() />
<cfset a_struct_loadoptions.maxrows = 5 />

<cfset stCRMFilter = StructNew() />
<cfset stCRMFilter = application.components.cmp_crmsales.AddTempCRMFilterStructureCriteria(CRMFilterStructure = stCRMFilter,
									operator = 4,
									internalfieldname = 'firstname',
									comparevalue = a_struct_parse.data.firstname) />

<cfset stCRMFilter = application.components.cmp_crmsales.AddTempCRMFilterStructureCriteria(CRMFilterStructure = stCRMFilter,
									operator = 4,
									internalfieldname = 'surname',
									comparevalue = a_struct_parse.data.surname) />

<cfset stCRMFilter = application.components.cmp_crmsales.AddTempCRMFilterStructureCriteria(CRMFilterStructure = stCRMFilter,
									operator = 1,
									internalfieldname = 'entrykey',
									comparevalue = a_struct_parse.data.entrykey) />

<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">	
	<cfinvokeargument name="crmfilter" value="#stCRMFilter#">
	<cfinvokeargument name="loadoptions" value="#a_struct_loadoptions#">
	<!--- only select accounts or contacts, ... ... --->
	<cfinvokeargument name="filterdatatypes" value="#a_struct_parse.data.datatype#">
	<cfinvokeargument name="CacheLookupData" value="false">
</cfinvoke> 

<cfset q_select_hits = stReturn.q_select_contacts />

<!--- hits? ... --->
<script type="text/javascript">
	HideStatusInformation();
</script>
<cfif q_select_hits.recordcount GT 0>
	
	<cfsavecontent variable="as">
		
		<div class="mischeader">
		<b><img src="/images/si/asterisk_yellow.png" class="si_img" alt="" /> <cfoutput>#GetLangVal('crm_ph_dup_check_maybe_found')#</cfoutput></b>
		<table class="table table-hover">
			<cfoutput>
			<tr class="tbl_overview_header">
				<td>
					#GetLangVal('cm_wd_name')#
				</td>
				<td>
					#GetLangVal('adrb_wd_company')#
				</td>
				<td>
					#GetLangVal('adrb_wd_city')#
				</td>
				<td>
					#GetLangVal('cm_wd_action')#
				</td>
			</tr>
			</cfoutput>
			<cfoutput query="q_select_hits">
			<tr>
				<td>
					<a target="_blank" href="/addressbook/?action=ShowItem&entrykey=#urlencodedformat(q_select_hits.entrykey)#"><img src="/images/si/vcard.png" alt="" class="si_img" /> #htmleditformat(q_select_hits.surname)#, #htmleditformat(q_select_hits.firstname)#</a>
				</td>
				<td>
					#htmleditformat(q_select_hits.company)#
				</td>
				<td>
					#htmleditformat(q_select_hits.b_city)#
				</td>
				<td>
					<!--- TODO hp: activate link ... --->
					<a target="_blank" href="/addressbook/?action=ShowItem&entrykey=#urlencodedformat(q_select_hits.entrykey)#">#GetLangVal('cm_wd_show')#</a>
				</td>
			</tr>
			</cfoutput>
		</table>
	</div>
	</cfsavecontent>

	<script type="text/javascript">
		$('#formcreateeditcontact').before("<cfoutput>#jsstringformatex(as)#</cfoutput>");
	</script>
</cfif>