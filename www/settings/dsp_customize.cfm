<!--- //

	Module:		Settings
	Action:		Customize
	Description:Offer options to customize look
	

// --->

<cfset tmp = SetHeaderTopInfoString(GetLangVal('cm_wd_customize'))>

<!--- load currently set style ... --->
<cfset q_select_userdata = application.components.cmp_user.GetUserData(userkey = request.stSecurityContext.myuserkey)>

<cfset a_str_current_custom_style = q_select_userdata.style>

<form action="index.cfm?action=DoSaveCustomize" method="POST">

<table class="table table_details">
	
	<tr>
		<td>
			<input <cfoutput>#WriteCheckedElement(a_str_current_custom_style, '')#</cfoutput> type="radio" name="frmcustomstylesheet" value="" class="noborder"/>
		</td>
		<td>
			Default
		</td>
	</tr>
	<tr>
		<td>
			<input <cfoutput>#WriteCheckedElement(a_str_current_custom_style, '0BE35216-925A-52BE-17F514120CF7FC05')#</cfoutput> type="radio" name="frmcustomstylesheet" value="0BE35216-925A-52BE-17F514120CF7FC05" class="noborder"/>
		</td>
		<td>
			Orange Lounge
		</td>
	</tr>
	<tr>
		<td>
			<input <cfoutput>#WriteCheckedElement(a_str_current_custom_style, 'E3A2C3EB-A500-F6B3-2BA776B721AC6F72')#</cfoutput> type="radio" name="frmcustomstylesheet" value="E3A2C3EB-A500-F6B3-2BA776B721AC6F72" class="noborder"/>
		</td>
		<td>
			A1 vfl!
		</td>
	</tr>	
	<tr>
		<td>
			<input <cfoutput>#WriteCheckedElement(a_str_current_custom_style, 'NBE41EEF-C279-3599-AE775A2AB0C8DF52')#</cfoutput> type="radio" name="frmcustomstylesheet" value="NBE41EEF-C279-3599-AE775A2AB0C8DF52" class="noborder"/>
		</td>
		<td>
			November Rain
		</td>
	</tr>	
	<tr>
		<td></td>
		<td>
			<input type="submit" class="btn btn-primary" value="Use Theme">
		</td>
	</tr>
</table>


</form>

