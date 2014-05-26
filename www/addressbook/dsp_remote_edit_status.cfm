<!--- //

	Module:		Address Book
	Action:		remoteeditstatus
	Description:Display Remote Edit status
	

// --->

<cfset tmp = SetHeaderTopInfoString(GetLangVal('adrb_ph_remote_edit_status')) />

<cfoutput>#GetLangVal('adrb_ph_remote_edit_status_description')#</cfoutput>

<br /><br />  

<cfquery name="q_select_open_job_keys" datasource="#request.a_str_db_tools#">
SELECT
	objectkey,dt_created
FROM
	remoteedit
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
;
</cfquery>

<cfif q_select_open_job_keys.recordcount IS 0>
	Es liegen keine Remote Edit Einladungen vor.
	<cfexit method="exittemplate">
</cfif>

<cfset sEntrykeys = valuelist(q_select_open_job_keys.objectkey) />

<cfset a_struct_filter = StructNew() />
<cfset a_struct_filter.entrykeys = sEntrykeys />

<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">	
	<cfinvokeargument name="filter" value="#a_struct_filter#">
</cfinvoke>

<cfset q_select_contacts = stReturn.q_select_contacts />

<cfquery name="q_select_open_re_requests" dbtype="query">
SELECT
	*,'' AS dt_created
FROM
	q_select_contacts
;
</cfquery>

<cfoutput query="q_select_open_re_requests">
	<cfquery name="q_select_dt_created" dbtype="query">
	SELECT
		dt_created
	FROM
		q_select_open_job_keys
	WHERE
		objectkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_open_re_requests.entrykey#">
	;
	</cfquery>
	
	<cfset tmp = QuerySetCell(q_select_open_re_requests, 'dt_created', q_select_dt_created.dt_created, q_select_open_re_requests.currentrow)>
</cfoutput>

<cfquery name="q_select_open_re_requests" dbtype="query">
SELECT
	*
FROM
	q_select_open_re_requests
ORDER BY
	dt_created
;
</cfquery>

<form action="act_multi_edit_remote_edit_status.cfm" name="formcontacts" method="post" style="margin:0px; ">
<table class="table_overview">
  <tr class="tbl_overview_header">
    <td>
	</td>
    <td>
		<cfoutput>#GetLangVal('cm_wd_name')#</cfoutput>
	</td>
    <td>
		<cfoutput>#GetLangVal('adrb_wd_email_address')#</cfoutput>
	</td>
	<td width="120">
		<cfoutput>#GetLangVal('adrb_ph_re_invitation_sent_on')#</cfoutput>
	</td>
    <td width="120">
		<cfoutput>#GetLangVal('adrb_ph_re_resend_now')#</cfoutput>
	</td>
    <td width="100">
		<cfoutput>#GetLangVal('adrb_ph_re_cancel')#</cfoutput>
	</td>
  </tr>
  <cfoutput query="q_select_open_re_requests">
  <tr id="idtr#q_select_open_re_requests.currentrow#"  onMouseOver="hilite(this.id);" onMouseOut="restore(this.id);">
  	<td>
		<input type="checkbox" name="frmentrykeys" value="#q_select_open_re_requests.entrykey#" class="noborder">
	</td>
    <td>
		<a href="index.cfm?action=ShowItem&entrykey=#q_select_open_re_requests.entrykey#">#CheckZeroString(htmleditformat(q_select_open_re_requests.surname))#, #htmleditformat(q_select_open_re_requests.firstname)#</a>
		
		<cfif Len(q_select_open_re_requests.company) GT 0>
			<br />#htmleditformat(q_select_open_re_requests.company)#
		</cfif>
	</td>
    <td>
		#htmleditformat(q_select_open_re_requests.email_prim)#
	</td>
    <td>
		#DateFormat(q_select_open_re_requests.dt_created, request.stUserSettings.default_dateformat)#
	</td>
	<td>
		<a href="index.cfm?action=remoteedit&entrykeys=#q_select_open_re_requests.entrykey#&force=true">#GetLangVal('cm_wd_proceed')#</a>
	</td>
    <td align="center">
		<a onClick="return confirm('#GetLangValJS('cm_ph_are_you_sure')#');" href="act_cancel_remote_edit_job.cfm?entrykeys=#q_select_open_re_requests.entrykey#"><img src="/images/si/delete.png" class="si_img" /></a>
	</td>
  </tr>
  </cfoutput>
  <tr>
  	<td class="bt">&nbsp;</td>
	<td colspan="4" class="bt">
		<cfoutput>#GetLangVal('adrb_ph_selected_action')#</cfoutput>
		&nbsp;
		<select name="frmaction">
			<option value="resend"><cfoutput>#GetLangVal('adrb_ph_re_resend_now')#</cfoutput></option>
			<option value="cancel"><cfoutput>#GetLangVal('adrb_ph_re_cancel')#</cfoutput></option>
		</select>
		
		&nbsp;
		<input type="submit" value="<cfoutput>#GetLangVal('cm_wd_proceed')#</cfoutput>" class="btn" />
	</td>
  </tr>
</table>
</form>

