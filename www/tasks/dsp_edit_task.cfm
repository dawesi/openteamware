

<cfset tmp = SetHeaderTopInfoString(GetLangVal('tsk_ph_edit_task'))>

<cfparam name="url.entrykey" type="string" default="">

<cfparam name="url.id" type="numeric" default="0">

<cfparam name="url.returnurl" type="string" default="">

<cfinclude template="dsp_show_edit_task.cfm">