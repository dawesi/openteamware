<cfprocessingdirective pageencoding="iso-8859-1">

<br>
<cfinvoke component="#request.a_str_component_mobilesync#" method="GetDevicesOfUser" returnvariable="q_select_devices">
	<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
</cfinvoke>

<cfinclude template="queries/q_select_outlook_setups.cfm">


<cfsavecontent variable="a_str_content">
	<div style="padding:20px; ">
	<cfoutput>#GetLangVal('sync_ph_outlooksync_into')#</cfoutput>
	</div>
	<table class="table table-hover">
	  <tr class="tbl_overview_header">
		<td  style="width:40px;">&nbsp;</td>
		<td>
			<cfoutput>#GetLangVal('cm_wd_name')#</cfoutput>
		</td>
		<td>
			<cfoutput>#GetLangVal('cm_wd_description')#</cfoutput>
		</td>
		<td>
			<cfoutput>#GetLangVal('cm_ph_lastsync')#</cfoutput>
		</td>		
		<td>
			<cfoutput>#GetLangVal('cm_wd_version')#</cfoutput>
		</td>		
	  </tr>
	  <cfoutput query="q_select_outlook_setups">
	  <tr>
	  	<td style="width:40px; ">
			###q_select_outlook_setups.currentrow#
		</td>
	  	<td style="font-weight:bold; " width="30%">
			#htmleditformat(q_select_outlook_setups.install_name)#&nbsp;
		</td>
		<td>&nbsp;
			
		</td>
		<td>
			<cfif isDate(q_select_outlook_setups.dt_lastmodified)>
				#DateFormat(q_select_outlook_setups.dt_lastmodified, request.stUserSettings.default_dateformat)#
				&nbsp;
				#TimeFormat(q_select_outlook_setups.dt_lastmodified, request.stUserSettings.default_timeformat)#
			</cfif>
		</td>
		<td>
			#q_select_outlook_setups.version#&nbsp;
		</td>
	  </tr>
	  </cfoutput>
	</table>
</cfsavecontent>

<cfsavecontent variable="a_str_buttons">
	<cfoutput>
		<input onClick="location.href = '/download/';" type="button" value="#GetLangVal('cm_wd_download')#" class="btn btn-primary">
	</cfoutput>
</cfsavecontent>


<cfoutput>#WriteNewContentBox('OutlookSync (' & q_select_outlook_setups.recordcount & ')', a_str_buttons, a_str_content)#</cfoutput>




<br><br>

<cfsavecontent variable="a_str_content">
	
	<div style="padding:20px; ">
		<cfoutput>#GetLangVal('sync_ph_mobilesync_intro')#</cfoutput>
	</div>
		
		<table class="table table-hover">
	 	 <tr class="tbl_overview_header">
			<td style="width:40px;">&nbsp;</td>
			<td width="30%">
				<cfoutput>#GetLangVal('cm_wd_name')#</cfoutput>
			</td>
			<td>
				<cfoutput>#GetLangVal('cm_wd_description')#</cfoutput>
			</td>
			<td>
				<cfoutput>#GetLangVal('cm_ph_lastsync')#</cfoutput>
			</td>
			<td>
				<cfoutput>#GetLangVal('cm_wd_action')#</cfoutput>
			</td>
		  </tr>
		  <cfoutput query="q_select_devices">
		  <tr>
			<td>
				## #q_select_devices.currentrow#
			</td>
			<td style="font-weight:bold; ">
				<img src="show_mobile_device_image.cfm?device=#urlencodedformat(q_select_devices.manufactor_model)#" align="absmiddle" vspace="4" hspace="4">
				#htmleditformat(q_select_devices.type)#&nbsp;
			</td>
			<td>
				#htmleditformat(q_select_devices.description)#&nbsp;
			</td>
			<td>
				<cfif IsDate(q_select_devices.dt_lastsync)>
					#DateFormat(q_select_devices.dt_lastsync, request.stUserSettings.default_dateformat)#
					#TimeFormat(q_select_devices.dt_lastsync, request.stUserSettings.default_timeformat)#
					<br>
					Dauer: #dt_lastsync_duration_sec# Sekunden
				<cfelse>
					&nbsp;
				</cfif>
			</td>
			<td>
				<a href="index.cfm?action=enablemobilesync&deviceid=#urlencodedformat(q_select_devices.id)#"><img src="/images/icon/notizen.gif" align="absmiddle" border="0"> #GetLangVal('sync_ph_operating_hints')#</a>
				<br><br>
				<a onClick="alert('#GetLangValJS('cm_ph_not_available_yet_message')#');" href="index.cfm?action=editmobilesyncdevice&device=#urlencodedformat(q_select_devices.id)#">#si_img('pencil')# #GetLangVal('cm_wd_edit')#</a>
				<br><br>
				<a onClick="alert('#GetLangValJS('cm_ph_not_available_yet_message')#');" href="index.cfm?action=deletemobilesyncdevice&device=#urlencodedformat(q_select_devices.id)#"><img src="/images/email/img_trash_19x16.gif" align="absmiddle" border="0"> #GetLangVal('cm_wd_delete')#</a>
			</td>
		  </tr>
		  </cfoutput>
		</table>
	
	
	<br><br>
	<!---<a style="font-weight:bold; " href=""><cfoutput>#GetLangVal('sync_ph_add_new_device')#</cfoutput> ...</a>
	&nbsp;&nbsp;--->
	<a href="/settings/index.cfm?action=mobilesync"><cfoutput>#GetLangVal('sync_ph_mobilesync_further_settings')#</cfoutput> ...</a>
	&nbsp;&nbsp;
	<a href="index.cfm?action=mobilesync"><cfoutput>#GetLangVal('cm_ph_faq_long')#</cfoutput></a>
</cfsavecontent>	

<cfsavecontent variable="a_str_buttons">
	<cfoutput>
		<input onClick="location.href = 'index.cfm?action=addmobilesyncdevice';" type="button" value="#GetLangVal('sync_ph_add_new_device')#" class="btn btn-primary">
	</cfoutput>
</cfsavecontent>

<cfoutput>#WriteNewContentBox('MobileSync (' & q_select_devices.recordcount & ')', a_str_buttons, a_str_content)#</cfoutput>

