<!---



	header for address book

	

	show common actions



--->

<cfoutput>#CreateDefaultTopHeader(GetLangVal('cm_wd_accounts') & ' & ' & GetLangval('cm_wd_contacts'))#</cfoutput>
<!---
<table class="tablemaincontenttop">
	<tr>
		<td class="addinfotext" style="font-weight:bold; "><a class="addinfotext" href="/addressbook/">Accounts &amp; Kontakte</a></td>
	</tr>
</table>
<cfexit method="exittemplate">

<table class="tablemaincontenttop">
<form action="default.cfm" method="get" name="search">
<input type="hidden" name="Action" value="ViewAll">
<tr>
	<td><a href="default.cfm" class="TopHeaderLink">&nbsp;<cfoutput>#GetLangVal("adrb_ph_show_all_contacts")#</cfoutput></a>&nbsp;</td>
	<td class="tdtopheaderdivider">|</td>
	<td>&nbsp;<a href="default.cfm?Action=createnewcontact" class="TopHeaderLink"><b><cfoutput>#GetLangval("adrb_ph_new_contact")#</cfoutput></b></a></td>

	<td class="tdtopheaderdivider">|</td>

	<td>
		<a href="default.cfm?action=remoteedit" class="TopHeaderLink"><cfoutput>#GetLangVal('adrb_wd_remote_edit')#</cfoutput></a>
	</td>
	
	<td class="tdtopheaderdivider">|</td>

	<td><a href="default.cfm?action=Mailinglists" class="TopHeaderLink"><cfoutput>#GetLangVal("adrb_wd_mailinglists")#</cfoutput></a></td>

	<td class="tdtopheaderdivider">|</td>

	<td><a href="/synccenter/" class="TopHeaderLink"><cfoutput>#GetLangVal("cm_wd_synccenter")#</cfoutput></a></td>

	<cfif request.stSecurityContext.myuserid is 2>
	<td class="tdtopheaderdivider">|</td>

	<td align="center" class="HeaderTopFont" style="color:white;">
		<a href="javascript:DisplaySavedFilters();">TEST: display saved filters</a>

	<script type="text/javascript">
		function DisplaySavedFilters()
			{
			var obj1;
			
			obj1 = findObj('id_div_top_filter_search');
			
			obj1.style.display = '';
			}
	</script>
	</td>
	</cfif>
</tr>
</form>
</table>--->