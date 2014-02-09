<cfparam name="attributes.md5_querystring" type="string" default="">
<cfparam name="attributes.mailbox" type="string" default="">
<cfparam name="attributes.id" type="numeric" default="0">

<cfset attributes.defaulttarget = 'default.cfm?action=showmessage'>
<cfset attributes.item = attributes.id&'_'&attributes.mailbox>

<!--- <cfif Len(attributes.md5_querystring) GT 0 AND StructKeyExists(session, 'email_mbox_display_'&attributes.md5_querystring)>
	<!--- we're in the game ... --->
	<cfset a_str_session_meta_scroll_data = session['email_mbox_display_'&attributes.md5_querystring]>
	
	<!--- try to find the item ... --->
	<cfset a_int_find_item = ListFind(a_str_session_meta_scroll_data, attributes.item)>
	
	<cfif a_int_find_item GT 0>
		<!--- hit !! --->
		
		<!--- set session var now ... delete original item first --->
		<cfset a_str_session_meta_scroll_data = ListDeleteAt(a_str_session_meta_scroll_data, a_int_find_item)>
		
		<!--- set new variable ... --->
		<cfset session['email_mbox_display_'&attributes.md5_querystring] = a_str_session_meta_scroll_data>
		
		<!--- get length ... --->
		<cfset a_int_len_session_meta_scroll_data = ListLen(a_str_session_meta_scroll_data)>
		
		<cfif a_int_len_session_meta_scroll_data IS 0>
			<!--- no further items ... --->
			<cflocation addtoken="no" url="#attributes.defaulttarget#">
		</cfif>		
		
		<!--- by default ... use the next item ... --->
		<cfset a_int_new_item = a_int_find_item - 1>
		
		<cfif a_int_new_item GTE a_int_len_session_meta_scroll_data>
			<!--- take the last item ... --->
			<cfset a_int_new_item = a_int_len_session_meta_scroll_data>
		</cfif>
		
		<cfif a_int_new_item LT 1>
			<!--- if it's zero ... --->
			<cfset a_int_new_item = 1>
		</cfif>
		
		<cfset a_str_new_item = ListGetAt(a_str_session_meta_scroll_data, a_int_new_item)>
		
		<cfset a_int_id = Mid(a_str_new_item, 1, Find('_', a_str_new_item)-1)>
		<cfset a_str_mbox = Mid(a_str_new_item, Find('_', a_str_new_item)+1, Len(a_str_new_item))>
		<cfset a_str_rowno = Hash(a_str_new_item)>
		
		<cflocation addtoken="no" url="default.cfm?action=showmessage&mailbox=#urlencodedformat(a_str_mbox)#&id=#a_int_id#&rowno=#a_str_rowno#&mbox_query_md5=#attributes.md5_querystring#&openfullcontent=#url.openfullcontent#">

	<cfelse>
		<!--- no hit ... --->
		<cflocation addtoken="no" url="#attributes.defaulttarget#">
	</cfif>
	
<cfelse>
	<cflocation addtoken="no" url="#attributes.defaulttarget#">
</cfif> --->