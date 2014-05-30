<!--- //

	Module:		Framework
	Description:Display history
	

// --->

<cfif NOT StructKeyExists(request, 'stSecurityContext')>
	<cfabort>
</cfif>

<cfquery name="q_select_history" datasource="#request.a_str_db_log#">
SELECT
	servicekey,action,title,query_string
FROM
	clickstream
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
	AND
	LENGTH(title) > 0
	AND
	dt_created > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(DateAdd('d', -5, Now()))#">
ORDER BY
	dt_created DESC
LIMIT
	20
;
</cfquery>

<cfinclude template="/common/scripts/script_utils.cfm">

<table class="table table-hover">
		
	<cfif q_select_history.recordcount IS 0>
		<tr>
			<td colspan="2">
				<cfoutput>#GetLangVal('cm_ph_clickstream_no_data_found')#</cfoutput>
			</td>
		</tr>
	</cfif>
  <cfoutput query="q_select_history">
  <tr>
	<td class="bb" valign="top">
		<cfswitch expression="#q_select_history.servicekey#">
			<cfcase value="52228B55-B4D7-DFDF-4AC7CFB5BDA95AC5">
				<img src="/images/si/email.png" class="si_img" />
			</cfcase>
			<cfcase value="52227624-9DAA-05E9-0892A27198268072">
				<img src="/images/si/vcard.png" class="si_img" />
			</cfcase>
			<cfcase value="5222ECD3-06C4-3804-E92ED804C82B68A2">
				<img src="/images/si/folder.png" class="si_img" />
			</cfcase>
			<cfdefaultcase>
				<img src="/images/space_1_1.gif">
			</cfdefaultcase>
		</cfswitch>
	</td>
	<td class="bb" valign="top">
		<cfswitch expression="#q_select_history.servicekey#">
			<cfcase value="52228B55-B4D7-DFDF-4AC7CFB5BDA95AC5">
			<a href="/email/?#q_select_history.query_string#">
			</cfcase>
			<cfcase value="52227624-9DAA-05E9-0892A27198268072">
				<a href="/addressbook/?#q_select_history.query_string#">
			</cfcase>
			<cfcase value="5222ECD3-06C4-3804-E92ED804C82B68A2">
				<a href="/storage/?#q_select_history.query_string#">
			</cfcase>
		</cfswitch>
		#htmleditformat(shortenstring(CheckZerostring(q_select_history.title), 50))#</a>
	</td>
  </tr>
  </cfoutput>
</table>

