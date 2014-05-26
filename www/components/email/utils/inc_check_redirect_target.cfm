<!--- //

	Module:		E-Mail / Tools
	Function:	GetRedirectTarget
	Description: 
	

// --->
<!--- 
<cfif (Len(arguments.md5_querystring) GT 0) AND StructKeyExists(arguments.session_scope, 'email_mbox_display_' & arguments.md5_querystring)>

	<!--- we're in the game ... --->
	<cfset a_str_arguments_session_scope_meta_scroll_data = arguments.session_scope['email_mbox_display_' & arguments.md5_querystring] />
	
	<!--- try to find the item ... --->
	<cfset a_int_find_item = ListFind(a_str_arguments_session_scope_meta_scroll_data, a_str_current_item) />
	
	<cfif a_int_find_item GT 0>
		<!--- hit !! set arguments.session_scope var now ... delete original item first --->
		<cfset a_str_arguments_session_scope_meta_scroll_data = ListDeleteAt(a_str_arguments_session_scope_meta_scroll_data, a_int_find_item) />
		
		<!--- set new variable ... --->
		<cflock scope="session" timeout="30" type="exclusive" throwontimeout="true">
			<cfset arguments.session_scope['email_mbox_display_'&arguments.md5_querystring] = a_str_arguments_session_scope_meta_scroll_data />
			<cfset session['email_mbox_display_'&arguments.md5_querystring] = a_str_arguments_session_scope_meta_scroll_data />
		</cflock>
		
		<!--- get length ... --->
		<cfset a_int_len_arguments = ListLen(a_str_arguments_session_scope_meta_scroll_data) />
		
		<cfif a_int_len_arguments IS 0>
			<!--- no further items ... --->
			<cfexit method="exittemplate">
		</cfif>		
		
		<!--- the row index is the ordinary index minus 1 ... because JS is zero based ... --->
		<cfset a_int_new_item_row_index = a_int_find_item - 1 />
		
		<!--- by default ... use the next item ... --->
		<cfset a_int_new_item = a_int_find_item - 1 />
		
		<cfif a_int_new_item GTE ListLen(a_str_arguments_session_scope_meta_scroll_data)>
			<!--- take the last item ... --->
			<cfset a_int_new_item = a_int_len_arguments.session_scope_meta_scroll_data />
		</cfif>
		
		<cfif a_int_new_item LT 1>
			<!--- if it's zero ... --->
			<cfset a_int_new_item = 1 />
		</cfif>
		
		<cfset a_str_new_item = ListGetAt(a_str_arguments_session_scope_meta_scroll_data, a_int_new_item) />
		
		<cfset a_int_id = Mid(a_str_new_item, 1, Find('_', a_str_new_item)-1) />
		<cfset a_str_mbox = Mid(a_str_new_item, Find('_', a_str_new_item)+1, Len(a_str_new_item)) />
		<cfset a_str_rowno = Hash(a_str_new_item) />
		
		<cfset a_str_target = "index.cfm?action=showmessage&mailbox=#urlencodedformat(a_str_mbox)#&id=#a_int_id#&rowno=#a_int_new_item_row_index#&mbox_query_md5=#arguments.md5_querystring#&openfullcontent=#arguments.openfullcontent#" />

	
	</cfif>

</cfif> --->


