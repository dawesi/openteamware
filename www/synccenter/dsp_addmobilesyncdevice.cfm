<cfprocessingdirective pageencoding="iso-8859-1">

<cf_disp_navigation mytextleft="Add device ...">
<br><br>

<cfquery name="q_select_manufactors" datasource="#request.a_str_db_tools#">
SELECT
	DISTINCT(manufactor)
FROM
	syncml_compatible_devices
ORDER BY
	manufactor
;
</cfquery>

<script type="text/javascript">
	function ShowDeviceImage(id)
		{
		var obj1;
		obj1 = findObj('id_img_mobile');
		obj1.src = 'show_mobile_device_image.cfm?device=' + escape(id);
		}
</script>



<fieldset class="default_fieldset">

<legend><cfoutput>#GetLangVal('sync_ph_add_device')#</cfoutput></legend>
<div>
<b>Dieser Dienst befindet sich in der EarlyAccess (Beta) - Phase und daher kann keine Garantie fuer die volle Funktionsfaehigkeit uebernommen werden! Sichern Sie auf jeden Fall vor einem ersten Abgleich Ihre Daten.</b>
<br><br>

<form action="act_add_mobilesync_device.cfm" method="post" style="margin:0px; ">
	<table border="0" cellspacing="0" cellpadding="4">
	  <tr>
	  	<td valign="top">
			<cfoutput>#GetLangVal('sync_ph_add_device_vendor')#</cfoutput>:
		</td>
		<td valign="middle">
			<select name="frm_manufactor_model" onChange="ShowDeviceImage(this.value);" size="10" style="width:250px; ">
				<option value="other"><cfoutput>#GetLangVal('cm_ph_please_select_option')#</cfoutput></option>
				<cfoutput query="q_select_manufactors">
					<optgroup label="#htmleditformat(q_select_manufactors.manufactor)#">
					
					<cfquery name="q_select_devices" datasource="#request.a_str_db_tools#">
						SELECT
							image,device_name
						FROM
							syncml_compatible_devices
						WHERE
							manufactor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_manufactors.manufactor#">
						ORDER BY
							device_name
						;
					</cfquery>
					
						<cfloop query="q_select_devices">
							<option value="#q_select_devices.image#">#htmleditformat(q_select_devices.device_name)#</option>
						</cfloop>
				
				</cfoutput>
				
			</select>
			&nbsp;
			<img src="/images/space_1_1.gif"  id="id_img_mobile" align="absmiddle">
		</td>
	  </tr>
	  <tr>
		<td align="right" valign="top">
			<cfoutput>#GetLangVal('cm_wd_name')#</cfoutput>:
		</td>
		<td>
			<input type="text" name="frmname" value="" size="30" style="width:250px; ">
			<br><br>
			<cfoutput>#GetLangVal('sync_ph_add_device_name_hint')#</cfoutput>
		</td>
	  </tr>
	  <tr>
		<td align="right">
			<cfoutput>#GetLangVal('cm_wd_description')#</cfoutput>:
		</td>
		<td>
			<input type="text" name="frmdescription" value="" size="30" style="width:250px; ">
		</td>
	  </tr>
	  <tr>
		<td valign="top" align="right">
			Device ID (IMEI):
		</td>
		<td valign="top">
			<input type="text" name="frmimei" value="" size="30" style="width:250px; ">
			<br><br>
			<cfoutput>#GetLangVal('sync_ph_add_device_imei_description')#</cfoutput>: 
			<br>
			<font style="font-family:'Courier New', Courier, mono;font-size:16px;font-weight:bold; ">*#06#</font>
			<!---<br>
			Geben Sie diesen Code dann im Feld "Device ID" ein. Bei manchen Ger�ten m�ssen Sie <u>IMEI: <i>Der Code</i></u> eingeben, vor allem bei �lteren Siemens Ger�ten.
			<br>
			Falls der erste Abgleich fehlschl�gt probieren Sie bitte den Code so einzugeben.--->
			<br><br>
			BlackBerry Users: Please enter <i>scpimblackberry</i> as IMEI!
			<br><br>
			<a style="color:#3300FF " href="default.cfm?action=mobilesync" target="_blank"><cfoutput>#GetLangVal('sync_ph_add_device_imei_description_why_faq_link')#</cfoutput></a>
		</td>
	  </tr>
	  <tr>
	  	<td valign="top" align="right">
			<cfoutput>#GetLangVal('cm_wd_encoding')#</cfoutput>:
		</td>
		<td>
			<select name="frmencoding">
				<option value="UTF-8">UTF-8 (Unicode / Default)</option>
				<option value="ISO-8859-1">ISO-8859-1</option>
			</select>
		</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
		<td>
			<input type="submit" value="<cfoutput>#GetLangVal('sync_ph_add_device_submit_btn')#</cfoutput>" class="btn">
		</td>
	  </tr>
	</table>
</form>
</div>
</fieldset>