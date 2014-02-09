<!--- //

	Module:        Tools/ErrorMsg
	Description:   Display an error message
	
	Parameters

// --->

<cfinclude template="/common/scripts/script_utils.cfm">

<cfparam name="url.errorno" type="string" default="0">
<cfparam name="url.errormsg" type="string" default="">

<cfset a_str_error_msg = GetLangVal('cm_ph_error_msg_' & val(url.errorno)) />

<table border="0" cellpadding="6" cellspacing="0">
	<tr>
		<td valign="top">
			<img src="/images/si/exclamation.png" class="si_img" />
		</td>
		<td>
			<b><cfoutput>#GetLangVal('cm_ph_an_error_has_occured')# (#url.errorno#)</cfoutput></b>
			<br />
			<br /> 
			<!--- try to load translation for error ... --->
			<cfoutput>#a_str_error_msg#</cfoutput>
			
			<!--- additional information? --->
			<cfif Len(url.errormsg) GT 0>
				<br />
				<cfoutput>#url.errormsg#</cfoutput>  
			</cfif> 
			
			<br /><br />
			<input type="button" value="<cfoutput>#GetLangVal('cm_wd_close_btn_caption')#</cfoutput>" onclick="CloseSimpleModalDialog();" class="btn2" />  
		</td>
	</tr>
</table>

