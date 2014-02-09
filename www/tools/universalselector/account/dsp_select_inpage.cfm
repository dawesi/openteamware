<!--- //

	Module:		UniversalSelector
	Description:Select account of contact ...
	

// --->

<cfparam name="url.search" type="string" default="" />

<!--- if no search string is given, search for the given input value ... --->
<cfif Len(url.search) IS 0 AND Len(url.displayvalue) GT 0>
	<cfset url.search = url.displayvalue />
</cfif>

<cfif Len(url.search) GT 0>
	
	<!--- execute a search operation ... --->
	<cfinvoke component="#application.components.cmp_crmsales#" method="AddTempCRMFilterStructureCriteria" returnvariable="stCRMFilter">
		<cfinvokeargument name="operator" value="4">
		<cfinvokeargument name="internalfieldname" value="company">
		<cfinvokeargument name="comparevalue" value="#Trim(url.search)#">
	</cfinvoke>
		
	 <cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">	
		<cfinvokeargument name="crmfilter" value="#stCRMFilter#">
		<!--- only select accounts ... --->
		<cfinvokeargument name="filterdatatypes" value="1">
		<cfinvokeargument name="CacheLookupData" value="false">
	</cfinvoke> 
	
	<cfset q_select_accounts = stReturn.q_select_contacts />
	
	<table class="table_overview">
		<tr class="tbl_overview_header">
			<td>
				<cfoutput>#GetLangVal('cm_wd_name')#</cfoutput>
			</td>
			<td>
				<cfoutput>#GetLangVal('adrb_wd_city')#</cfoutput>
			</td>
			<td>
				<cfoutput>#GetLangVal('cm_wd_action')#</cfoutput>
			</td>
		</tr>
		<cfoutput query="q_select_accounts">
		<tr>
			<td>
				#htmleditformat(q_select_accounts.company)#
			</td>
			<td>
				#htmleditformat(q_select_accounts.b_city)#
			</td>
			<td>
				<input onclick="UniversalSelectorSetReturnValues('#q_select_accounts.entrykey#', '#jsstringformat(q_select_accounts.company)#');" type="button" value="#GetLangval('cm_ph_btn_action_apply')#" class="btn2" />
			</td>
		</tr>
		</cfoutput>
	</table>

</cfif>

<br />
 
<cfoutput>#WriteSimpleHeaderDiv(GetLangVal('cm_wd_search'))#</cfoutput>
<cfoutput>
<form class="frm_inpage" action="#cgi.SCRIPT_NAME#" name="form1" id="form1" method="get" onsubmit="DoHandleAjaxForm(this.id);return false;">
#CreateHiddenFieldsOfURLParameters('search')#
<table class="table_details table_edit_form">
	<tr>
		<td class="field_name"></td>
		<td>
			<input type="text" name="search" value="#htmleditformat(url.search)#" />
		</td>
	</tr>
	<tr>
		<td class="field_name"></td>
		<td>
			<input type="submit" class="btn" value="#GetLangVal('cm_wd_search')#" />
		</td>
	</tr>
</table>
</form>
</cfoutput>

<!--- <input type="button" class="btn" value="CreateNewAccount" /> --->

