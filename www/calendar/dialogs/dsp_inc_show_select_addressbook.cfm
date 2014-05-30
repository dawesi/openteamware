<!---
	TODO hp: this is included page (in dsp_select_event_assignements) and should render a form with two
    hidden fields and the "assign" and "cancel" buttons:
	<form name="formSelectElements">
		<input type="hidden" name="frmentrykey" value="#url.entrykey#"/>
		<input type="hidden" name="frmtype" value="#url.type#"/>
      ......contact selection......
		<input type="button" value="assign" class="btn btn-primary" onclick="DoAssignElements();"/>
		<input type="button" value="cancel" class="btn" onclick="CloseSimpleModalDialog();"/>
	</form>
    
    The form should also contain checkboxes or hidden fields named "assigned_elements". These form elements should 
    contain entrykey of the contact as value.
    See show_select_resources.cfm as an example.
    variable a_str_assigned_entrykeys can be accessed to find out which 'contacts'(?) are already assigned.
--->

<!--- //

	Module:		Calendar
	Action:		Create / Edit event
	Description:	Show possible fields mappings
	

// --->

<cfset url.frmentrykey = url.entrykey />
<cfset url.frmtype = url.type />

<cfparam name="url.search" type="string" default="">
<cfparam name="url.emailaddresses" type="string" default="">
<cfparam name="url.assigned_elements" type="string" default="">


<cfoutput>
<form class="frm_inpage" action="#cgi.SCRIPT_NAME#" name="formSelectElements" id="formSelectElements" method="get" onsubmit="DoHandleAjaxForm(this.id);return false;">
#CreateHiddenFieldsOfURLParameters('search')#

<cfif Len(Trim(url.search)) GT 0>

<cfset stCRMFilter = StructNew() />
<cfset stCRMFilter = application.components.cmp_crmsales.AddTempCRMFilterStructureCriteria(CRMFilterStructure = stCRMFilter,
									operator = 4,
									connector = 1,
									internalfieldname = 'firstname',
									comparevalue = url.search) />

<cfset stCRMFilter = application.components.cmp_crmsales.AddTempCRMFilterStructureCriteria(CRMFilterStructure = stCRMFilter,
									operator = 4,
									connector = 1,
									internalfieldname = 'surname',
									comparevalue = url.search) />

<cfset stCRMFilter = application.components.cmp_crmsales.AddTempCRMFilterStructureCriteria(CRMFilterStructure = stCRMFilter,
									operator = 4,
									connector = 1,
									internalfieldname = 'company',
									comparevalue = url.search) />

<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">	
	<cfinvokeargument name="crmfilter" value="#stCRMFilter#">
	<cfinvokeargument name="CacheLookupData" value="false">
</cfinvoke> 

<cfset q_select_hits = stReturn.q_select_contacts />

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
			<cfloop query="q_select_hits">
			<tr>
				<td>
					<img src="/images/si/vcard.png" alt="" class="si_img" /> #htmleditformat(q_select_hits.surname)#, #htmleditformat(q_select_hits.firstname)#
				</td>
				<td>
					#htmleditformat(q_select_hits.company)#
				</td>
				<td>
					#htmleditformat(q_select_hits.b_city)#
				</td>
				<td>
					<input type="button" value="<cfoutput>#GetLangVal('cm_ph_btn_action_apply')#</cfoutput>" class="btn btn-primary" onclick="$('##ASSIGNED_ELEMENTS').val('#jsstringformat(q_select_hits.entrykey)#');DoAssignElements();" />
				</td>
			</tr>
			</cfloop>
		</table>

</cfif>


<table class="table_details table_edit_form">
	<tr>
		<td class="field_name">
			#GetLangVal('cm_wd_search')#
		</td>
		<td>
			<input type="text" name="search" value="#htmleditformat(url.search)#" />
		</td>
	</tr>
	<tr>
		<td class="field_name"></td>
		<td>
			<input type="submit" class="btn btn-primary" value="#GetLangVal('cm_wd_search')#" />
			
			<input type="button" value="<cfoutput>#GetLangVal('cm_wd_cancel')#</cfoutput>" class="btn" onclick="CloseSimpleModalDialog();" />
		</td>
	</tr>
</table>
</form>
</cfoutput>

<cfquery name="q_select_last_5_invited_contacts" datasource="#request.a_str_db_tools#">
SELECT
	parameter
FROM
	meetingmembers
WHERE
	createdbyuserkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
	AND
	type = 3
ORDER BY
	dt_created DESC
LIMIT
	5
;
</cfquery>

<cfset a_struct_filter = StructNew() />
<cfset a_struct_filter.search = url.search />

<!--- load contacts ... --->
<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>

<cfset q_select_contacts = stReturn.q_select_contacts>

<cfif q_select_last_5_invited_contacts.recordcount GT 0>
	<!--- load last five invitees ... --->
	<cfset a_struct_filter = StructNew() />
	<cfset a_struct_filter.entrykeys = ValueList(q_select_last_5_invited_contacts.parameter) />

	<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="filter" value="#a_struct_filter#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	</cfinvoke>

	<cfset q_select_contacts_last_five = stReturn.q_select_contacts>
</cfif>


