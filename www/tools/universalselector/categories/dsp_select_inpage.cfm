<!--- //

	Module:        universal selector
	Description:   Select categories
	
	Parameters

// --->


<!--- first step: the master category list --->
<!--- <cfset a_str_categories = getlangval("cm_ph_categories_masterlist") /> --->
<cfset a_str_categories = '' />
	
<!--- 2nd step: load workgroup defined categories --->
	
<!--- 3rd step: load user defined categories --->
<cfset a_str_own_categories = GetUserPrefPerson('common', 'personalcategories', '', '', false) />
	
<cfif Len(a_str_own_categories) GT 0>
	<cfset a_str_categories = ListPrepend(a_str_categories, a_str_own_categories) />
</cfif>

<cfset a_str_categories = ListSort(a_str_categories, 'textnocase') />

<cfset ii = 0 />

<form class="frm_inpage" name="formdummyform" id="formdummyform">
<input type="button" class="btn btn-primary" name="frmbtnsetcategories" onClick="UniversalSelectorSetReturnValues(CollectCheckedSelectBoxesValues('formdummyform'),CollectCheckedSelectBoxesValues('formdummyform'));" value="<cfoutput>#GetLangVal('cm_ph_btn_action_apply')#</cfoutput>"/>

<div class="clear bb" style="padding-top:8px"></div>
<!--- <table class="table table_details">
  <tr>
	<td colspan="2">
		
	</td>
  </tr> --->
  <cfloop list="#a_str_categories#" index="a_str_category" delimiters=",">
	
<div style="float:left;width:200px;padding:8px" class="">
  <cfset ii = ii + 1 />
  <!--- <tr>
    <td width="25"> --->
		<input id="idcat<cfoutput>#ii#</cfoutput>" type="checkbox" <cfif ListFindNoCase(url.inputvalue, a_Str_category) gt 0>checked</cfif> name="frmcbcategories" class="noborder" value="<cfoutput>#htmleditformat(a_str_category)#</cfoutput>">
	<!--- </td>
    <td> --->
		<label for="idcat<cfoutput>#ii#</cfoutput>"><cfoutput>#a_str_category#</cfoutput></label>
	<!--- </td>
  </tr> --->
</div>
  </cfloop>

<div class="clear"></div>
<br /><br />
<!--- </table> --->
</form>
