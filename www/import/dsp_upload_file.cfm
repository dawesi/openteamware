<!--- //

	Module:        Import
	Description:   Upload a file
	

// --->


<cfset tmp = SetHeaderTopInfoString(GetLangVal('cm_ph_select_file')) />

<form action="default.cfm?action=DoUploadFile" method="post" enctype="multipart/form-data" onsubmit="DisplayPleaseWaitMsgOnLocChange();">
<input type="hidden" name="frm_jobkey" value="<cfoutput>#CreateUUID()#</cfoutput>"/>

<table class="table_details table_edit_form">
	<tr>
		<td class="field_name">
			<cfoutput>#GetLangVal('cm_wd_service')#</cfoutput>:
		</td>
		<td>
			<select name="frm_servicekey">
				<option value="52227624-9DAA-05E9-0892A27198268072"><cfoutput>#GetLangVal('cm_wd_addressbook')#</cfoutput></option>
			</select>	
		</td>
	</tr>
	<tr>
		<td class="field_name">
			<cfoutput>#GetLangVal('odb_ph_datatype')#</cfoutput>:
		</td>
		<td>
			<select name="frm_datatype">
				<cfoutput>
				<option value="0">#GetLangVal('cm_wd_contacts')#</option>
				<!--- <option value="1">#GetLangVal('crm_wd_accounts')#</option> --->
				<option value="2">#GetLangVal('crm_wd_leads')#</option>
				</cfoutput>
			</select>
		</td>
	</tr>
	<tr>
		<td class="field_name">
			<cfoutput>#GetLangVal('cm_wd_file')#</cfoutput>:
		</td>
		<td>
			<input type="file" name="frm_filename" />
		</td>
	</tr>
	<tr>
		<td class="field_name">
			<input type="checkbox" value="1" name="frmadvanced_criteria_selection" />
		</td>
		<td>
			<cfoutput>#GetLangVal('import_ph_advanced_criteria_select')#</cfoutput>
		</td>
	</tr>
	<tr>
		<td class="field_name"></td>
		<td>
			<input type="submit" value="<cfoutput>#GetLangVal('sto_wd_upload')#</cfoutput>" class="btn" />
		</td>
	</tr>
</table>
</form>

