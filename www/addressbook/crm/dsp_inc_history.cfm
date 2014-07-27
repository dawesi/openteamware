<!--- //

	Module:		Address Book / CRM
	Action:		ShowItem
	Description:Display the history of an item

// --->

<cfsavecontent variable="tablist">
<cfoutput>
<ul class="nav nav-tabs crmHistory" role="tablist">
  <li class="active"><a href="##home" data-history-area="activities" role="tab" data-toggle="tab">#GetLangVal('adrb_wd_activities')#</a></li>
  <li><a href="##messages" role="tab" data-history-area="appointments" data-toggle="tab">#GetLangVal('cm_wd_events')#</a></li>
  <li><a href="##settings" role="tab" data-history-area="emailfaxsms" data-toggle="tab">#GetLangVal('cm_wd_email')#</a></li>
</ul>

<!-- Tab panes -->
<div class="tab-content">
  <div class="tab-pane active" id="crmHistoryOutput">...</div>
</div>

<script>
var contactKey = '#jsstringformat(url.entrykey)#';
$('.crmHistory a').click(function (e) {
  e.preventDefault();
	var area = $(this).data( 'history-area' );

	var u = '/crm/?action=DisplayAddresBookItemHistory&entrykeys=' + escape(contactKey) + '&area=' + escape( area );

	$.get( u, function( data ) {
		$('##crmHistoryOutput').html( data );

	});
  //$(this).tab('show')
})

$('.crmHistory a:first').click();
</script>

</cfoutput>
</cfsavecontent>

<cfsavecontent variable="a_str_buttons">
<cfoutput>
	<form style="margin:0px;" name="form_set_crm_history_days">
		<input class="btn btn-primary" type="button" style="width:auto;" onclick="call_new_item_for_contact('#jsstringformat(url.entrykey)#', 'history');return false;" value="#GetLangVal('crm_ph_record_event')#" />

		<!--- <cfif a_struct_object.rights.delete>
			<input type="button" class="btn btn-default" value="#MakeFirstCharUCase(GetLangVal('cm_wd_edit'))#" onclick="ShowActivitiesData('#jsstringformat(url.entrykey)#', 'activities', GetCurrentCRMHistoryDays(), true);" />
		</cfif> --->

	</form>
</cfoutput>

</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('crm_wd_history'), a_str_buttons, tablist)#</cfoutput>

<cfset AddJSToExecuteAfterPageLoad('ShowActivitiesData(''#jsstringformat(url.entrykey)#'', ''activities'', ''30'')', '') />


<!--- other linked contacts --->
<cfset a_struct_filter_linked_contacts = StructNew()>
<cfset a_struct_filter_linked_contacts.statusonly = 0>

<cfinvoke component="#application.components.cmp_crmsales#" method="GetItemActivitiesAndData" returnvariable="a_struct_linked_contacts">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="contactkeys" value="#url.entrykey#">
	<cfinvokeargument name="filter" value="#a_struct_filter_linked_contacts#">
	<cfinvokeargument name="type" value="linked_items">
</cfinvoke>

<cfif a_struct_linked_contacts.recordcount GT 0>

	<cfsavecontent variable="a_str_buttons">
		<input onClick="call_edit_contact('<cfoutput>#jsstringformat(url.entrykey)#</cfoutput>', 'contact_links');" type="button" value=" <cfoutput>#htmleditformat(GetLangVal('cm_wd_edit'))#</cfoutput> " class="btn btn-primary">
		<input onClick="call_edit_contact('<cfoutput>#jsstringformat(url.entrykey)#</cfoutput>', 'contact_links');" type="button" value=" <cfoutput>#htmleditformat(GetLangVal('cm_wd_new'))#</cfoutput> " class="btn btn-primary">
	</cfsavecontent>

	<cfoutput>#WriteNewContentBox(GetLangVal('cm_wd_links'), a_str_buttons, a_struct_linked_contacts.a_str_content, 'id_div_fieldset_contacts_linked_to')#</cfoutput>
</cfif>
