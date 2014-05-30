<!--- //

	Module:		Cmp_FollowUp
	Function:	DisplayShortFollowupInfos
	Description: 
	

// --->
	
<cfif (Len(arguments.servicekey) IS 0) OR (Len(arguments.objectkeys) IS 0)>
	<!--- invalid data --->
	<cfexit method="exittemplate">
</cfif>
	
<cfset a_struct_filter = StructNew() />
<!---<cfset a_struct_filter.done = 0>--->

<cfset q_select_follow_ups = GetFollowUps(servicekey = arguments.servicekey,
								objectkeys = arguments.objectkeys,
								usersettings = arguments.usersettings,
								filter = a_struct_filter) />
								
<cfquery name="q_select_follow_ups" dbtype="query">
SELECT
	*
FROM
	q_select_follow_ups
WHERE
	done = 0
;
</cfquery>

<cfif q_select_follow_ups.recordcount IS 0>
	<cfexit method="exittemplate">
</cfif>

<cfset stReturn.q_select_follow_ups = q_select_follow_ups />

<cfsavecontent variable="a_str_content">
<table class="table table-hover">
	<tr class="tbl_overview_header">
		<td><cfoutput>#GetLangVal('cm_wd_comment')#</cfoutput></td>
		<td><cfoutput>#GetLangVal('cm_wd_type')#</cfoutput></td>
		<td><cfoutput>#GetLangVal('cm_wd_date')#</cfoutput></td>
		<td><cfoutput>#GetLangVal('cm_wd_action')#</cfoutput></td>
	</tr>
	<cfoutput query="q_select_follow_ups">
	<tr>
		<td>
			#htmleditformat(CheckZeroString(q_select_follow_ups.comment))#
		</td>
		<td>
			<cfswitch expression="#q_select_follow_ups.followuptype#">
				<cfcase value="0">#GetLangVal('crm_wd_follow_up')#</cfcase>
				<cfcase value="1">#GetLangVal('cm_wd_email')#</cfcase>
				<cfcase value="2">#GetLangVal('crm_wd_follow_up_call')#</cfcase>
				<cfcase value="3">#GetLangVal('crm_wd_follow_up_write_letter')#</cfcase>
			</cfswitch>
		</td>
		<td>
			#LSDateFormat(q_select_follow_ups.dt_due, request.stUserSettings.default_dateformat)#
		</td>
		<td>
			<a href="/crm/?action=EditFollowup&entrykey=#q_select_follow_ups.entrykey#" class="nl"><img src="/images/si/pencil.png" class="si_img" alt="#GetLangVal('cm_wd_edit')#" /></a>
			<a class="nl" href="##" onclick="ShowSimpleConfirmationDialog('index.cfm?action=DeleteFollowups&entrykeys=#q_select_follow_ups.entrykey#');"><img src="/images/si/delete.png" class="si_img" alt="Delete" /></a>
		</td>
	</tr>
	</cfoutput>
</table>
</cfsavecontent>

<!--- highlight? --->
<cfif arguments.highlight>
	<cfset a_str_content = '<div class="bb" style="margin-top:10px;background-color:##EEFEB8;">' & a_str_content & '</div>'>
</cfif>

<cfset stReturn.content = a_str_content />
<cfset stReturn.result = true />

