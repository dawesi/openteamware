<!--- parse line by line ... --->

<!--- first of all ... loop through CRM fields and replace items in the text with the real fieldname ... --->

<cfloop query="arguments.query_own_datafields_crm">
	<cfset a_str_showname = '%db_crm_' & query_own_datafields_crm.showname & '%'>
	
	<cfset a_str_real_showname = '%db_' & query_own_datafields_crm.fieldname & '%'>
	
	<cfset sReturn = ReplaceNoCase(sReturn, a_str_showname, a_str_real_showname, 'ALL')>
</cfloop>

<cfif FindNoCase('%SALUTATION%', sReturn) GT 0>
	<!--- salutation should be replaced ... take a look at the database ... --->
	
	<cfif Len(arguments.query_holding_data_to_replace.surname) GT 0>
	
		<cfif arguments.query_holding_data_to_replace.sex GTE 0>
		
			<!--- male or female? --->
			<cfif arguments.query_holding_data_to_replace.sex IS 0>
				<cfset a_str_salutation = request.a_component_lang.GetLangValExt(langno = arguments.langno, entryid='adrb_crm_ph_dear_sir')>
			<cfelse>
				<cfset a_str_salutation = request.a_component_lang.GetLangValExt(langno = arguments.langno, entryid='adrb_crm_ph_dear_madame')>
			</cfif>
			
			<cfset a_str_salutation = a_str_salutation & ' '>
			
			<cfif Len(arguments.query_holding_data_to_replace.title) GT 0>
				<cfset a_str_salutation = a_str_salutation & arguments.query_holding_data_to_replace.title & ' '>
			</cfif>
			
			<cfset a_str_salutation = a_str_salutation & arguments.query_holding_data_to_replace.surname & '!'>
		
		<cfelse>
			<!--- use default ... --->
			<cfset a_str_salutation = request.a_component_lang.GetLangValExt(langno = arguments.langno, entryid='cal_ph_invitation_hello')>
		</cfif>
	
	<cfelse>
		<!--- use default ... --->
		<cfset a_str_salutation = request.a_component_lang.GetLangValExt(langno = arguments.langno, entryid='cal_ph_invitation_hello')>
	</cfif>
	
</cfif>

<cfloop list="#sReturn#" delimiters="#chr(10)#" index="a_str_single_line">

	<!---
	<cflog text="body line: #a_str_single_line#" type="Information" log="Application" file="ib_nl">
	--->

	<!---<cfset a_str_single_line = ReplaceNoCase(a_str_single_line, '%UNSUBSCRIBE_LINK%', '<a href="http://www.openTeamWare.com/nl/us/' & htmleditformat(q_select_profile.entrykey) & '/' & htmleditformat(query_holding_data_to_replace.entrykey) & '/">Klicken Sie hier um sich von diesem Newsletter abzumelden</a>', 'ALL')>--->
	<cfset a_str_single_line = ReplaceNoCase(a_str_single_line, '%UNSUBSCRIBE_LINK%', '<a href="http://www.openTeamWare.com/nl/us/?l=' & htmleditformat(q_select_profile.entrykey) & '&e=' & htmleditformat(arguments.entrykey) & '">' & request.a_component_lang.GetLangValExt(langno = arguments.langno, entryid='nl_ph_to_unsubscribe_click_here') & '</a>', 'ALL')>
	<cfset a_str_single_line = ReplaceNoCase(a_str_single_line, '%NOW%', LsDateFormat(Now(), arguments.usersettings.default_dateformat) & ' ' & TimeFormat(Now(), arguments.usersettings.default_timeformat), 'ALL')>
	<cfset a_str_single_line = ReplaceNoCase(a_str_single_line, '%SALUTATION%', a_str_salutation, 'ALL')>

	<!--- loop as long as there exist variables ... --->
	<cfloop condition="VariableStillExistsInString(a_str_single_line) IS TRUE">
	
		<cfset a_str_item_name = GetVariableItemName(a_str_single_line)>

		<cfset a_str_item_name_without_db = ReplaceNoCase(a_str_item_name, 'DB_', '')>
		
		<cflog text="a_str_item_name: #a_str_item_name#" type="Information" log="Application" file="ib_nl">
		
		<!--- check database query ... --->
		<cfif ListFindNoCase(arguments.query_holding_data_to_replace.columnlist, a_str_item_name) GT 0>
			<!--- found in the database ... --->
			<cfset a_str_new_value = arguments.query_holding_data_to_replace[a_str_item_name][1]>

			<cfset a_str_single_line = ReplaceNoCase(a_str_single_line, '%' & a_str_item_name & '%', a_str_new_value, 'ALL')>
		
		<cfelseif ListFindNoCase(arguments.query_holding_data_to_replace.columnlist, a_str_item_name_without_db) GT 0>
			<cfset a_str_new_value = arguments.query_holding_data_to_replace[a_str_item_name_without_db][1]>

			<cfset a_str_single_line = ReplaceNoCase(a_str_single_line, '%' & a_str_item_name & '%', a_str_new_value, 'ALL')>

		<cfelse>
		
			<cfset a_str_single_line = ReplaceNoCase(a_str_single_line, '%' & a_str_item_name & '%', '', 'ALL')>
		</cfif>				
	
	</cfloop>
	
	<!---<cfset a_str_single_line = REReplaceNoCase(a_str_single_line, '<a[^>]*>[^>]*</a>', '<a href="https://www.openTeamWare.com/nl/c.cfm?=', 'ALL')>--->
	
	<cfset sReturn_new = sReturn_new & a_str_single_line>
	
	<!---<cflog text="REPLACED a_str_single_line: #a_str_single_line#" type="Information" log="Application" file="ib_nl">--->

</cfloop>

<cfset sReturn = sReturn_new>
