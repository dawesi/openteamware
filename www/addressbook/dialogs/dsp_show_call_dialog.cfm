<!--- //

	Module:		Addressbook
	Action:		OpenCallDialog
	Description:Open call dialog ...
				Offer to launch a call using
				
				- Jajah
				- Skype
				- ?
				
	

// --->

<!--- contactkey --->
<cfparam name="url.contactkey" type="string">
<!--- telnr ... --->
<cfparam name="url.telnr" type="string" default="">
<!--- type (optional ...) ... possible values: , mobile --->
<cfparam name="url.type" type="string" default="">

<script type="text/javascript">
	SetTitleOfModalDialog('<cfoutput>#jsstringformat(application.components.cmp_addressbook.GetContactDisplayNameData(url.contactkey))#</cfoutput>');
</script>

<div style="font-weight:bold;padding-bottom:10px;font-size:18px;">
<cfoutput>#htmleditformat(url.telnr)#</cfoutput>
<!--- <cfif a_bol_skype_enabled>
	<cfoutput>#WriteSkypeCallLink(url.telnr, url.contactkey, 1)#</cfoutput>
</cfif> --->


</div>

<cfset a_int_skype_enabled = GetUserPrefPerson('extensions.skype', 'enabled', '1', '', false) />


<!--- get open call activities ... --->
<!--- <cfset a_struct_filter = StructNew() />
<cfset a_struct_filter.userkey = request.stSecurityContext.myuserkey />
<cfset a_struct_filter.servicekey = '52227624-9DAA-05E9-0892A27198268072' />
<cfset a_struct_filter.done = 0 />
<cfset a_struct_filter.type = 2 />
<cfset a_struct_filter.maxdate = DateAdd('d', 600, Now()) />

<cfinvoke component="#application.components.cmp_followups#" method="GetFollowUps" returnvariable="q_select_follow_ups">
	<cfinvokeargument name="servicekey" value="52227624-9DAA-05E9-0892A27198268072">
	<cfinvokeargument name="objectkeys" value="">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
</cfinvoke>

<cfdump var="#q_select_follow_ups#"> --->

<cfif url.type IS 'mobile'>

<div id="id_div_sendsms" style="display:none">

	
	<form action="" id="idform" onsubmit="SendSMSBG()">
	<table class="table table_details table_edit_form">
		<tr>
			<td class="field_name">
				<cfoutput>#GetLangVal('cm_wd_text')#</cfoutput>
			</td>
			<td>
				<textarea name="frmsms" rows="2" cols="40"></textarea>
			</td>
		</tr>
		<tr>
			<td class="field_name"></td>
			<td>
				<input type="submit" value="<cfoutput>#GetLangVal('cm_wd_submit_btn_send')#</cfoutput>" class="btn btn-primary" />
			</td>
		</tr>
	</table>
	</form>

</div>
</cfif>



<!--- <cfoutput>#WriteSimpleHeaderDiv(GetLangVal('cm_wd_crm'))#</cfoutput> --->
<cfoutput>
<div style="padding:8px;">
<form>
	<input type="button" class="btn btn-primary" onclick="call_new_item_for_contact('<cfoutput>#url.contactkey#</cfoutput>', 'history', '', '1');" value="#GetLangVal('crm_ph_record_event')#" />

	<input type="button" class="btn" onclick="CreateHistoryItemNotReached('<cfoutput>#url.contactkey#</cfoutput>');CloseSimpleModalDialog();" value="#GetLangVal('crm_ph_tel_not_reached')#" />
</form>
</div>
</cfoutput>


<cfif url.type IS 'mobile'>
	<cfoutput>#WriteSimpleHeaderDiv(GetLangVal('cm_wd_sms'))#</cfoutput>
	<!--- <a href="#" onclick="$('#id_div_sendsms').fadeIn();return false;">Send SMS</a> --->
	<div style="padding:8px;">
		<input type="button" onclick="GotoLocHref('/mobile/?action=sms&telnr=<cfoutput>#urlencodedformat(url.telnr)#</cfoutput>');" value="SMS" class="btn" />
	</div>
</cfif>

<script type="text/javascript">
	function CreateHistoryItemNotReached(contactkey) {
		var req = new cSimpleAsyncXMLRequest();
		req.servicekey = '7E68B84A-BB31-FCC0-56E6125343C704EF';
		req.action = 'CreateHistoryItemNotReached';
		req.AddParameter('contactkey', contactkey);
		req.doCall();
	}
</script>


