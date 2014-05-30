<cfinclude template="/login/check_logged_in.cfm">

<cfinclude template="/common/scripts/script_utils.cfm">

<!--- entrykey of contacts --->
<cfparam name="url.editmode" type="boolean" default="false">
<cfparam name="url.entrykeys" type="string" default="">
<cfparam name="url.rights" type="string" default="read">

<cfsavecontent variable="a_str_js">
	<cfoutput>
	var a_pop_further_actions_evnt_tsk = new cActionPopupMenuItems();
	a_pop_further_actions_evnt_tsk.AddItem('#GetLangValJS('crm_wd_follow_up')#','javascript:call_new_item_for_contact(\'<cfoutput>#jsstringformat(url.entrykeys)#</cfoutput>\', \'followup\');','','','','');
	a_pop_further_actions_evnt_tsk.AddItem('#GetLangValJS('cm_wd_task')#','javascript:call_new_item_for_contact(\'<cfoutput>#jsstringformat(url.entrykeys)#</cfoutput>\', \'task\')','','','','');
	a_pop_further_actions_evnt_tsk.AddItem('#GetLangValJS('cm_wd_appointment')#','javascript:call_new_item_for_contact(\'<cfoutput>#jsstringformat(url.entrykeys)#</cfoutput>\', \'appointment\')','','','','');
	</cfoutput>
</cfsavecontent>

<cfscript>
	AddJSToExecuteAfterPageLoad('', a_str_js);
</cfscript>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN""http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<cfinclude template="/style_sheet.cfm">
	<cfinclude template="/common/js/inc_js.cfm">
	<cfinclude template="../../../render/inc_html_header.cfm">
	
	<script language="javascript" type="text/javascript" src="../../../common/js/crm_ext.js"></script>
	<title>
		<cfoutput>
			#GetLangVal('crm_wd_follow_ups')# , #GetLangVal('cm_wd_tasks')# &amp; #GetLangVal('cm_wd_events')#
		</cfoutput>
	</title>
</head>

<body class="body_popup">

<cfsavecontent variable="a_str_content">
<cfinclude template="../../../addressbook/crm/utils/inc_load_contacts_data_tasks_appointments.cfm">
</cfsavecontent>

<cfsavecontent variable="a_str_buttons">
	<input id="id_btn_call_tsk_evnt_actions" onClick="ShowHTMLActionPopup('id_btn_call_tsk_evnt_actions', a_pop_further_actions_evnt_tsk);return false;" type="button" value=" <cfoutput>#htmleditformat(GetLangVal('cm_wd_new'))#</cfoutput> " class="btn btn-primary">
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('crm_wd_follow_ups') & ', ' & GetLangVal('cm_wd_tasks') & ' & ' & GetLangVal('cm_wd_events'), a_str_buttons, a_str_content, 'id_fieldset_tasks_appointments_followups')#</cfoutput>
	
</body>
</html>
