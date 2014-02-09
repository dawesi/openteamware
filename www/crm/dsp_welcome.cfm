<!--- //

	Module:		CRM
	Description:Show Welcome screen ... not needed to be honest
	

// --->

<cflocation addtoken="false" url="default.cfm?action=activities">

<cfinvoke component="#application.components.cmp_crmsales#" method="GetListOfViewFilters" returnvariable="q_select_filters">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>					

<cfset tmp = SetHeaderTopInfoString(GetLangVal('cm_wd_overview'))>


<cfexit method="exittemplate">

	
<!--- <cfif request.stSecurityContext.myusername IS 'vertriebsmitarbeiter1@openTeamware.com'>
	
	<div style="padding:8px; ">
		<fieldset class="bg_fieldset">
			<legend>
				<img src="/images/menu/img_icon_followups_32x32.gif" align="absmiddle"> Unbearbeitete Anfragen
			</legend>
			<div>
				
				Es liegen 3 unbeantwortete Anfragen im Pool:
				
				<br /><br />
				
				<table border="0" cellspacing="0" cellpadding="4" width="90%">
					<tr>
						<td class="bb bt addinfotext" align="center" width="120px" style="font-size:10px;text-transform:uppercase; ">Typ</td>
						<td class="bb bt addinfotext" style="font-size:10px;text-transform:uppercase; ">Von</td>
						<td class="bb bt addinfotext" style="font-size:10px;text-transform:uppercase; ">Betreff</td>
						<td class="bb bt addinfotext" style="font-size:10px;text-transform:uppercase; ">eingetroffen</td>
						<td class="bb bt addinfotext" style="font-size:10px;text-transform:uppercase; ">Dokumenten-Nr</td>
						<td class="bb bt addinfotext" style="font-size:10px;text-transform:uppercase; ">&nbsp;</td>
					</tr>
				  <tr>
					<td style="text-align:center;" class="bb">
						<div style="text-align:center;color:white;font-size:10px;text-transform:uppercase;background-color:#CC3300;width:80px;padding:1px;">E-Mail</div>
					</td>
					<td class="bb">
						max.mustermann@musterfirma.at
					</td>
					<td class="bb">
						Durchrechnungszeitraum
					</td>
					<td class="bb">
						vor 27 min
					</td>
					<td class="bb">
						#234727
					</td>
					<td class="bb">
						Anzeigen &amp; Zuweisen ...
					</td>
				  </tr>
				  <tr>
					<td style="text-align:center;" class="bb">
						<div style="text-align:center;color:white;font-size:10px;text-transform:uppercase;background-color:#3366CC;width:80px;padding:1px;">Fax</div>
					</td>
					<td class="bb">
						+43 1 991 28238
					</td>
					<td class="bb">&nbsp;</td>
					<td class="bb">
						vor 3 Stunden
					</td>					
					<td class="bb">
						#233739
					</td>
					<td class="bb">
						Anzeigen &amp; Zuweisen ...
					</td>
				  </tr>
				  <tr>
					<td style="text-align:center;" class="bb">
						<div style="text-align:center;color:white;font-size:10px;text-transform:uppercase;background-color:#CC9933;width:80px;padding:1px;">Webform</div>
					</td>
					<td class="bb">
						Manfred Mustermann &lt;m.mustermann@musterfirma.at&gt;
					</td>
					<td class="bb">
						Angebot 2006/23737
					</td>
					<td class="bb">
						gestern um 19:23
					</td>
					<td class="bb">
						#232782
					</td>
					<td class="bb">
						Anzeigen &amp; Zuweisen ...
					</td>
				  </tr>
				</table>
				
				
			</div>
		</fieldset>
	</div>

	<br />
</cfif> --->

<table width="100%"  border="0" cellspacing="0" cellpadding="8">
  <tr>
    <td width="50%" valign="top">
		<fieldset class="bg_fieldset">
			<legend>
				<a href="/addressbook/"><img src="/images/menu/img_heads_32x32.gif" width="32" height="32" hspace="0" vspace="0" border="0" align="absmiddle"> <cfoutput>#GetLangVal('cm_wd_accounts')#/#GetLangVal('cm_wd_contacts')#</cfoutput></a>
			</legend>
			<div>
				<div class="bb">
					<a href="/addressbook/"><cfoutput>#GetLangVal('adrb_ph_show_all_contacts')#</cfoutput></a>
					&nbsp;|&nbsp;
					<a href="/addressbook/?action=createnewitem"><cfoutput>#GetLangVal('adrb_ph_new_contact')#</cfoutput></a>
					&nbsp;|&nbsp;
					<a href="/addressbook/?action=telephonelist"><cfoutput>#GetLangVal('adb_wd_telephonelist')#</cfoutput></a>
				</div>
				
				
				<div class="bb">
				<form action="/addressbook/" method="get" style="margin:0px; ">
					<cfoutput>#GetLangVal('adrb_ph_fulltext_search')#</cfoutput>: <input type="text" name="search" value="" size="12"> <input type="submit" value="<cfoutput>#GetLangVal('cm_wd_search')#</cfoutput>">
					
				</form>
				</div>
				
				<br />
				
				<div class="bb">
				<a href="/addressbook/?action=advancedsearch"><cfoutput>#GetLangVal('crm_ph_saved_filters')#</cfoutput> (<cfoutput>#q_select_filters.recordcount#</cfoutput>):</a>
				

				<ul>
					<cfoutput query="q_select_filters">
						<li>
							<a style="font-weight:bold; " href="../addressbook/?action=showcontacts&filterviewkey=#urlencodedformat(q_select_filters.entrykey)#">#htmleditformat(q_select_filters.viewname)#</a>
							<br />
							#GetLangVal('cm_wd_created')#: #DateFormat(q_select_filters.dt_created, 'dd.mm.yyyy')#
							
							<cfif Len(q_select_filters.description) GT 0>
							<br />#htmleditformat(q_select_filters.description)#
							</cfif>
						</li>
					</cfoutput>
				</ul>
				</div>
				
			
			<cfquery name="q_select_open_re_requests" datasource="#request.a_str_db_tools#">
			SELECT
				COUNT(remoteedit.id) AS count_id
			FROM
				remoteedit
			WHERE
				remoteedit.userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
			;
			</cfquery>			
			
				<div>
					<cfset a_str_open_res = ReplaceNoCase(GetLangVal('adrb_ph_outlook_open_remote_edits'), '%RECORDCOUNT%', q_select_open_re_requests.count_id)>
					<a href="/addressbook/?action=remoteeditstatus"><cfoutput>#a_str_open_res#</cfoutput></a>
				</div>
				
				
				<cfset a_dt_check = DateAdd('d', -5, Now())>

				<div class="bb bt">
					<cfoutput>#GetLangVal('cm_ph_last_displayed')#</cfoutput>&nbsp;
				</div>
				
				<cfset ab = GetTickCount()>
				<cfquery name="q_select_latest" datasource="#request.a_str_db_log#">
				SELECT
					title,query_string
				FROM
					clickstream
				WHERE
					userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
					AND
					servicekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="52227624-9DAA-05E9-0892A27198268072">
					AND
					dt_created > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_check)#">
					AND
					Length(title) > 0
					AND
					action = 'ShowContact'
				ORDER BY
					dt_created DESC
				LIMIT
					7
				;
				</cfquery>
				
					<ul>
					<cfoutput query="q_select_latest">
						<li><a href="/addressbook/default.cfm?#q_select_latest.query_string#">#htmleditformat(q_select_latest.title)#</a></li>
					</cfoutput>
					</ul>
			</div>
		</fieldset>
		
		<br /><br />
		
		<!--- calendar --->
		<cfinclude template="../calendar/dsp_outlook_default.cfm">

		
		<!---<fieldset class="bg_fieldset">
			<legend><cfoutput>#GetLangVal('cm_wd_opportunities')#</cfoutput> </legend>
			<div>
				<a href="default.cfm?action=opportunities">Reports</a>
			</div>
		</fieldset>			
		
		<br /><br />--->
		
		<!---<fieldset class="bg_fieldset">
			<legend><cfoutput>#GetLangVal('cm_wd_settings')#</cfoutput> </legend>
			<div>
			
				<div class="bb">
				Sie k�nnen im Administrations-Tool diverse Einstellungen f�r das CRM Modul vornehmen um das System f�r Ihre Bed�rfnisse anzupassen.
				</div>
				
				<br />
				<div>
				<a href="/administration/?action=crm" target="_blank"><cfoutput>#GetLangVal('cm_wd_settings')#</cfoutput></a>
				</div> 
			</div>
		</fieldset>			--->
	</td>
    <td width="50%" valign="top">
		
			
		<cfinclude template="../tools/followups/dsp_outlook.cfm">

		
		<br /><br />
		
		<cfinvoke component="/components/crmsales/crm_reports" method="GetReportDatabaseOfUser" returnvariable="a_str_databasekey">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		</cfinvoke>		
		
		<cfset a_struct_options = StructNew()>
		<cfset a_struct_options.tabletyp = 'report'>
		
		
	</td>
  </tr>
</table>


