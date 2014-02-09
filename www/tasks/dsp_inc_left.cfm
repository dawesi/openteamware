<cfinclude template="../tools/browser/inc_check_browser.cfm">

<div class="divleftnavigation_center">

	<div class="divleftnavpanelactions">
	
	<cfswitch expression="#url.action#">
	<cfcase value="ShowTask,Edittask">	
		<div class="divleftnavpanelheader"><!---&raquo; ---><cfoutput>#GetLangVal('cm_wd_task')#</cfoutput></div>
		
			<ul class="divleftpanelactions">
			<li><a href="default.cfm?action=edittask&entrykey=<cfoutput>#url.entrykey#</cfoutput>"><cfoutput>#GetLangVal('cm_wd_Edit')#</cfoutput></a></li>
			<li><a href="default.cfm?action=deletetask&entrykey=<cfoutput>#url.entrykey#</cfoutput>"><cfoutput>#GetLangVal('cm_wd_delete')#</cfoutput></a></li>
			<li><a target="_blank" href="default.cfm?action=PrintVersion&entrykeys=<cfoutput>#url.entrykey#</cfoutput>"><cfoutput>#GetLangVal('cal_wd_printversion')#</cfoutput></a></li>
			<!---<li>Weiterleiten</li>--->
			</ul>
		
	</cfcase>	
	</cfswitch>
	
	
		
		<div class="divleftnavpanelheader"><!---&raquo; ---><cfoutput>#GetLangVal('cm_wd_global')#</cfoutput></div>
	
			<ul class="divleftpanelactions">
			<li><a href="default.cfm?action=newtask">Neue Aufgabe</a></li>
			<li><a href="default.cfm"><cfoutput>#htmleditformat(GetLangval('cm_wd_overview'))#</cfoutput></a></li>
			<li><a href="default.cfm?filterstatus=open&filtercategory=&filterworkgroup=&filtertimeframe=&filterpriority=">Reset filter</a></li>
			<li><a href="/assistants/import/"><cfoutput>#GetLangVal('adrb_ph_outlook_sync')#</cfoutput></a></li>
			<li><a style="color:#CC0000; " href="default.cfm?filtertimeframe=overdue"><cfoutput>#GetLangVal('tsk_wd_view_overdue')#</cfoutput></a></li>
			
			<cfif request.a_bol_ibx_local_service_running>
				<li><a target="_blank" href="#" onClick="LaunchOutlookSync();return false;">OutlookSync ausfuehren</a></li>
				
				<script type="text/javascript">
					var a_http_outlooksync;
					function processReqNTChange()
						{
						// alert(a_http_outlooksync.status);
						}							
					function LaunchOutlookSync()
						{
						var url = 'http://127.0.0.1:4567/exec/outlooksync?rand='+escape(Math.random());
						// alert(url);
						a_http_outlooksync = GetNewHTTPObject();	
						CallHTTPGet(a_http_outlooksync, url, processReqNTChange);
						}
				
				</script>
			</cfif>
			</ul>
	</div>	

</div>