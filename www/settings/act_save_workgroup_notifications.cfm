<!--- &auml;nderungen bei den notification einstellungen speichern --->
<cfquery name="q_update" datasource="inboxccusers">
UPDATE workgroup_members
SET
notification_cal_email = <cfif isdefined("form.frm_notification_cal_email")>1<cfelse>0</cfif>,
notification_cal_sms = <cfif isdefined("form.frm_notification_cal_sms")>1<cfelse>0</cfif>,
notification_cal_icq = <cfif isdefined("form.frm_notification_cal_icq")>1<cfelse>0</cfif>,
notification_adrb_email = <cfif isdefined("form.frm_notification_adrb_email")>1<cfelse>0</cfif>
WHERE userid = #request.stSecurityContext.myuserid#
AND group_id = #val(form.frmWorkgroup_id)#
</cfquery>

<cflocation addtoken="no" url="index.cfm?action=WorkgroupProperties&id=#form.frmWorkgroup_id#">