<!--- //

	Module:		Email
	Action:		Overview
	Description:Display email overview
	

// --->

<cfset tmp = SetHeaderTopInfoString(GetLangVal('cm_wd_overview')) />

<form action="index.cfm" method="get" name="formsearch" style="margin:0px; ">
<input type="hidden" name="action" value="dosearch">

<table class="table table-hover">

<tr class="mischeader">

	<td class="br">
		<b><cfoutput>#GetLangVal('mail_ph_compose_new_mail')#</cfoutput></b>
	</td>
	<td>
		<b><cfoutput>#GetLangVal('mail_ph_search_mail')#</cfoutput></b>
	</td>

</tr>


<tr>
	<td class="br" style="line-height:24px;">

	<a href="#" title="<cfoutput>#GetLangVal('mail_ph_top_new_message_hint')#</cfoutput>" onClick="OpenComposePopupText();return false;"><cfoutput>#GetLangVal('mail_ph_compose_new_mail_textplain')#</cfoutput></a>

	<br />
	<cfset a_str_formatted_text = GetLangVal('mail_ph_compose_new_mail_formatted') />
	
	<a href="#" title="<cfoutput>#GetLangVal('mail_ph_top_new_message_hint')#</cfoutput>" onClick="OpenComposePopupHTML();return false;"><cfoutput>#a_str_formatted_text#</cfoutput></a>	

	</td>
	<td style="line-height:20px;" class="br">

	<cfoutput>#GetLangVal('mail_ph_search_for')#</cfoutput>&nbsp;<input type="text" name="search" size="15" maxlength="150"> [ <a href="javascript:document.formsearch.submit();"><cfoutput>#GetLangVal('mail_wd_start')#</cfoutput></a> ]<br />

	<a href="index.cfm?action=ShowSearch"><cfoutput>#GetLangVal('mail_ph_enhanced_search')#</cfoutput></a>

	

	</td>
</tr>

</table>
</form>



<br/>

<!--- display all folders --->
<cfinclude template="dsp_all_folders.cfm">	