<!--- 

	show the insert form for a new task

	

	--->

<cfparam name="url.assigned_addressbookkeys" type="string" default="">
<cfparam name="url.assigned_userkey" type="string" default="">

<cfset SetHeaderTopInfoString(GetLangVal('tsk_ph_createnewtask'))>

<!--- set the new uuid ... --->
<cfset a_str_new_uuid = CreateUUID()>


<form name="formeditnewtask" action="act_create_task.cfm" method="POST" onSubmit="DisplayStatusInformation('<cfoutput>#GetLangVal('tsk_ph_status_saving')#</cfoutput>');">
<input type="hidden" name="frmentrykey" value="<cfoutput>#htmleditformat(a_str_new_uuid)#</cfoutput>">

<cfset sEntrykey = a_str_new_uuid>
<cfinclude template="dsp_inc_new_edit_task.cfm">
</form>
