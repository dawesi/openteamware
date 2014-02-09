<!--- //

	edit the email account
	
	// --->
	
<cfparam name="url.id" type="numeric" default="0">

<cfset SelectEmailAccountRequest.id = url.id>
<cfinclude template="queries/q_select_email_account.cfm">

<script type="text/javascript">
	function showColor(str) {
		document.formsettings.frmmarkcolor.value = str;
		}
</script>

<cfif q_select_email_account.origin is 0>
	<!--- load possible forwarding targets ... --->
	<cfset SelectEmailForwardingRequest.emailadr = q_select_email_account.emailadr>
	<cfinclude template="queries/q_select_email_forwarding_settings.cfm">
</cfif>

<cfinclude template="../email/utils/inc_load_imap_access_data.cfm">
<cfinclude template="../email/utils/inc_load_folders.cfm">

<!---<cfdump var="#q_select_email_account#">--->

<cf_disp_navigation mytextleft=#htmleditformat(q_select_email_account.emailadr)#>
<br>

<cfoutput query="q_select_email_account">
<form action="act_update_email_account_settings.cfm" method="post" name="formsettings">
<input type="hidden" name="frmid" value="#q_select_email_account.id#">
<input type="hidden" name="frmemailaddress" value="#htmleditformat(q_select_email_account.emailadr)#">
<table class="table_details">
  <tr>
    <td class="field_name">#GetLangVal('mail_ph_email_address')#</td>
    <td><b>#htmleditformat(q_select_email_account.emailadr)#</b></td>
  </tr>
  <tr>
     <td class="field_name">#GetLangVal('prf_ph_email_sender_name')#</td>
    <td><input type="text" name="frmdisplayname" value="#htmleditformat(q_select_email_account.displayname)#" size="40" maxlength="250"></td>
  </tr>  
  <tr>
  	 <td class="field_name">#GetLangVal('cm_wd_password')#</td>
	<td><input type="Password" name="frmpop3password" size="40" maxlength="250"></td>
  </tr>
  <tr>
  	<td>&nbsp;</td>
	<td class="addinfotext">#GetLangVal('prf_ph_passwort_enter_only_if_change_wanted')#</td>
  </tr>
  
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <cfif q_select_email_account.origin is 0>
  <!--- email address of the current host system ... --->
  <tr>
  	 <td class="field_name">#GetLangVal('prf_ph_email_forward_messages')#</td>
	<td>
	<input type="text" name="frmforwardingdestination" value="#htmleditformat(q_Select_forwarding.destination)#" size="40" maxlength="250">

	</td>
  </tr> 
  <tr>
  	<td></td>
	<td class="addinfotext">
	#GetLangVal('prf_ph_email_forward_messages_remove_forwarding')#
	</td>
  </tr>
	  <cfif q_select_email_account.emailadr is request.stSecurityContext.myusername>
	  	<!--- if we've got the main address ... ask if we should leave a copy in the box ... --->
		  <tr>
			 <td class="field_name">#GetLangVal('cm_ph_forwarding_leave_copy')#</td>
			<td>
			<input type="checkbox" name="frmleavecopy" <cfif q_select_email_account.deletemsgonserver is 0>checked</cfif> value="1" class="noborder">
			</td>
		  </tr> 
	  <cfelse>
	  <input type="hidden" name="frmleavecopy" value="0">
	  </cfif>
	  
  </cfif>
  <cfif q_select_email_account.origin is 1>
  <!--- external address --->
  <tr>
     <td class="field_name">Typ</td>
    <td>
	<select name="frmhosttype" disabled>
		<option #writeselectedelement(q_select_email_account.hosttype, 1)# value="0">POP3</option>
		<option #writeselectedelement(q_select_email_account.hosttype, 1)# value="1">IMAP</option>
	</select>
	</td>
  </tr>
 <tr>
     <td class="field_name">#GetLangVal('cm_wd_server')#</td>
    <td><input type="text" name="frmpop3server" value="#q_select_email_account.pop3server#" size="40" maxlength="250"></td>
  </tr>
  <tr>
  	 <td class="field_name">Port</td>
	<td>
	<cfif val(q_select_email_account.port) IS 0>
		<cfset a_int_port = 110>
	<cfelse>
		<cfset a_int_port = q_select_email_account.port>
	</cfif>
	
	<input type="text" name="frmpop3port"  size="5" maxlength="5" value="#a_int_port#"> (default/standard = 110)
	</td>
  </tr>
  <tr>
  	<td align="right"></td>
	<td>
		<input type="checkbox" #writecheckedelement(q_select_email_account.usessl, 1)# class="noborder" name="frmcbusessl" value="1"> #GetLangVal('prf_ph_email_use_pop3ssl')# 
	</td>
  </tr>
  <tR>
  	<td></td>
	<td>
		#GetLangVal('prf_ph_email_use_pop3ssl_description')#
	</td>
  </tR>
  <tr>
    <td class="field_name">#GetLangVal('cm_Wd_username')#</td>
    <td><input type="text" name="frmpop3username" value="#q_select_email_account.pop3username#" size="40" maxlength="250"></td>
  </tr>  
  <!---<tr>
  	<td>&nbsp;</td>
	<td class="addinfotext">
	Hinweis: Ersetzen Sie moegliche "\" im Benutzernamen durch "\\" (z.B. bei Microsoft Exchange)
	</td>
  </tr>--->
  <tr>
    <td align="right">#GetLangVal('prf_ph_email_delete_msg_onserver')#:</td>
    <td>
	<select name="frmdeletemsgonserver">
		<option #writeselectedelement(q_select_email_account.deletemsgonserver, 1)# value="1">#GetLangVal('cm_wd_yes')#</option>
		<option #writeselectedelement(q_select_email_account.deletemsgonserver, 0)# value="0">#GetLangVal('cm_wd_no')#</option>
	</select>
	</td>
  </tr>
  <tr>
     <td class="field_name">#GetLangVal('prf_ph_email_autocheck')#</td>
    <td>
	<select name="frmAutoCheckEachMinutes">
	<option value="0">#GetLangVal('cm_wd_never')#</option>
	<option value="1" #writeselectedelement(q_select_email_account.autocheckminutes, 1)#>#GetLangVal('prf_ph_email_autocheck_each_min')#</option>
	<option value="3" #writeselectedelement(q_select_email_account.autocheckminutes, 3)#>#ReplaceNoCase(GetLangVal('prf_ph_email_autocheck_each_n_minutes'), '%n%', 3)#</option>	
	<option #writeselectedelement(q_select_email_account.autocheckminutes, 5)# value="5">#ReplaceNoCase(GetLangVal('prf_ph_email_autocheck_each_n_minutes'), '%n%', 5)#</option>
	<option #writeselectedelement(q_select_email_account.autocheckminutes, 10)# value="10">#ReplaceNoCase(GetLangVal('prf_ph_email_autocheck_each_n_minutes'), '%n%', 10)#</option>
	<option #writeselectedelement(q_select_email_account.autocheckminutes, 30)# value="30">#ReplaceNoCase(GetLangVal('prf_ph_email_autocheck_each_n_minutes'), '%n%', 30)#</option>
	<option #writeselectedelement(q_select_email_account.autocheckminutes, 60)# value="60">#ReplaceNoCase(GetLangVal('prf_ph_email_autocheck_each_n_hours'), '%n%', 1)#</option>
	<option #writeselectedelement(q_select_email_account.autocheckminutes, 180)# value="180">#ReplaceNoCase(GetLangVal('prf_ph_email_autocheck_each_n_hours'), '%n%', 3)#</option>
	<option #writeselectedelement(q_select_email_account.autocheckminutes, 720)# value="720">#ReplaceNoCase(GetLangVal('prf_ph_email_autocheck_each_n_hours'), '%n%', 12)#</option>
	<option #writeselectedelement(q_select_email_account.autocheckminutes, 1440)# value="1440">#ReplaceNoCase(GetLangVal('prf_ph_email_autocheck_each_n_hours'), '%n%', 24)#</option>	
	</select>
	</td>
  </tr>
  <tr>
     <td class="field_name">#GetLangVal('prf_ph_email_put_to_folder')#</td>
    <td>
	<select name="frmdestinationfolder" disabled>
		<option value="">#GetLangVal('cm_wd_inbox')#</option>
		<cfloop query="request.q_select_folders">
		<option #writeselectedelement(q_select_email_account.destinationfolder, request.q_select_folders.fullfoldername)# value="#htmleditformat(request.q_select_folders.fullfoldername)#">#htmleditformat(request.q_select_folders.foldername)#</option>
		</cfloop>
	</select>
	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>      
  </cfif>
<tr>
  	 <td class="field_name">#GetLangVal('prf_ph_email_address_assign_color')#</td>
	<td>
	<input type="text" name="frmmarkcolor" value="#htmleditformat(q_select_email_account.markcolor)#" size="10" maxlength="10">
	<cfif len(q_select_email_account.markcolor) gt 0><span style="background-color:#q_select_email_account.markcolor#;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></cfif>
	</td>
  </tr>
  <tr>
  	<td>&nbsp;</td>
	<td>
	<map name="colmap">
	<area shape="rect" coords="1,1,7,10" href="javascript:showColor('##00FF00')">
	<area shape="rect" coords="9,1,15,10" href="javascript:showColor('##00FF33')">
	<area shape="rect" coords="17,1,23,10" href="javascript:showColor('##00FF66')">
	<area shape="rect" coords="25,1,31,10" href="javascript:showColor('##00FF99')">
	<area shape="rect" coords="33,1,39,10" href="javascript:showColor('##00FFCC')">
	<area shape="rect" coords="41,1,47,10" href="javascript:showColor('##00FFFF')">
	<area shape="rect" coords="49,1,55,10" href="javascript:showColor('##33FF00')">
	<area shape="rect" coords="57,1,63,10" href="javascript:showColor('##33FF33')">
	<area shape="rect" coords="65,1,71,10" href="javascript:showColor('##33FF66')">
	<area shape="rect" coords="73,1,79,10" href="javascript:showColor('##33FF99')">
	<area shape="rect" coords="81,1,87,10" href="javascript:showColor('##33FFCC')">
	<area shape="rect" coords="89,1,95,10" href="javascript:showColor('##33FFFF')">
	<area shape="rect" coords="97,1,103,10" href="javascript:showColor('##66FF00')">
	<area shape="rect" coords="105,1,111,10" href="javascript:showColor('##66FF33')">
	<area shape="rect" coords="113,1,119,10" href="javascript:showColor('##66FF66')">
	<area shape="rect" coords="121,1,127,10" href="javascript:showColor('##66FF99')">
	<area shape="rect" coords="129,1,135,10" href="javascript:showColor('##66FFCC')">
	<area shape="rect" coords="137,1,143,10" href="javascript:showColor('##66FFFF')">
	<area shape="rect" coords="145,1,151,10" href="javascript:showColor('##99FF00')">
	<area shape="rect" coords="153,1,159,10" href="javascript:showColor('##99FF33')">
	<area shape="rect" coords="161,1,167,10" href="javascript:showColor('##99FF66')">
	<area shape="rect" coords="169,1,175,10" href="javascript:showColor('##99FF99')">
	<area shape="rect" coords="177,1,183,10" href="javascript:showColor('##99FFCC')">
	<area shape="rect" coords="185,1,191,10" href="javascript:showColor('##99FFFF')">
	<area shape="rect" coords="193,1,199,10" href="javascript:showColor('##CCFF00')">
	<area shape="rect" coords="201,1,207,10" href="javascript:showColor('##CCFF33')">
	<area shape="rect" coords="209,1,215,10" href="javascript:showColor('##CCFF66')">
	<area shape="rect" coords="217,1,223,10" href="javascript:showColor('##CCFF99')">
	<area shape="rect" coords="225,1,231,10" href="javascript:showColor('##CCFFCC')">
	<area shape="rect" coords="233,1,239,10" href="javascript:showColor('##CCFFFF')">
	<area shape="rect" coords="241,1,247,10" href="javascript:showColor('##FFFF00')">
	<area shape="rect" coords="249,1,255,10" href="javascript:showColor('##FFFF33')">
	<area shape="rect" coords="257,1,263,10" href="javascript:showColor('##FFFF66')">
	<area shape="rect" coords="265,1,271,10" href="javascript:showColor('##FFFF99')">
	<area shape="rect" coords="273,1,279,10" href="javascript:showColor('##FFFFCC')">
	<area shape="rect" coords="281,1,287,10" href="javascript:showColor('##FFFFFF')">
	<area shape="rect" coords="1,12,7,21" href="javascript:showColor('##00CC00')">
	<area shape="rect" coords="9,12,15,21" href="javascript:showColor('##00CC33')">
	<area shape="rect" coords="17,12,23,21" href="javascript:showColor('##00CC66')">
	<area shape="rect" coords="25,12,31,21" href="javascript:showColor('##00CC99')">
	<area shape="rect" coords="33,12,39,21" href="javascript:showColor('##00CCCC')">
	<area shape="rect" coords="41,12,47,21" href="javascript:showColor('##00CCFF')">
	<area shape="rect" coords="49,12,55,21" href="javascript:showColor('##33CC00')">
	<area shape="rect" coords="57,12,63,21" href="javascript:showColor('##33CC33')">
	<area shape="rect" coords="65,12,71,21" href="javascript:showColor('##33CC66')">
	<area shape="rect" coords="73,12,79,21" href="javascript:showColor('##33CC99')">
	<area shape="rect" coords="81,12,87,21" href="javascript:showColor('##33CCCC')">
	<area shape="rect" coords="89,12,95,21" href="javascript:showColor('##33CCFF')">
	<area shape="rect" coords="97,12,103,21" href="javascript:showColor('##66CC00')">
	<area shape="rect" coords="105,12,111,21" href="javascript:showColor('##66CC33')">
	<area shape="rect" coords="113,12,119,21" href="javascript:showColor('##66CC66')">
	<area shape="rect" coords="121,12,127,21" href="javascript:showColor('##66CC99')">
	<area shape="rect" coords="129,12,135,21" href="javascript:showColor('##66CCCC')">
	<area shape="rect" coords="137,12,143,21" href="javascript:showColor('##66CCFF')">
	<area shape="rect" coords="145,12,151,21" href="javascript:showColor('##99CC00')">
	<area shape="rect" coords="153,12,159,21" href="javascript:showColor('##99CC33')">
	<area shape="rect" coords="161,12,167,21" href="javascript:showColor('##99CC66')">
	<area shape="rect" coords="169,12,175,21" href="javascript:showColor('##99CC99')">
	<area shape="rect" coords="177,12,183,21" href="javascript:showColor('##99CCCC')">
	<area shape="rect" coords="185,12,191,21" href="javascript:showColor('##99CCFF')">
	<area shape="rect" coords="193,12,199,21" href="javascript:showColor('##CCCC00')">
	<area shape="rect" coords="201,12,207,21" href="javascript:showColor('##CCCC33')">
	<area shape="rect" coords="209,12,215,21" href="javascript:showColor('##CCCC66')">
	<area shape="rect" coords="217,12,223,21" href="javascript:showColor('##CCCC99')">
	<area shape="rect" coords="225,12,231,21" href="javascript:showColor('##CCCCCC')">
	<area shape="rect" coords="233,12,239,21" href="javascript:showColor('##CCCCFF')">
	<area shape="rect" coords="241,12,247,21" href="javascript:showColor('##FFCC00')">
	<area shape="rect" coords="249,12,255,21" href="javascript:showColor('##FFCC33')">
	<area shape="rect" coords="257,12,263,21" href="javascript:showColor('##FFCC66')">
	<area shape="rect" coords="265,12,271,21" href="javascript:showColor('##FFCC99')">
	<area shape="rect" coords="273,12,279,21" href="javascript:showColor('##FFCCCC')">
	<area shape="rect" coords="281,12,287,21" href="javascript:showColor('##FFCCFF')">
	<area shape="rect" coords="1,23,7,32" href="javascript:showColor('##009900')">
	<area shape="rect" coords="9,23,15,32" href="javascript:showColor('##009933')">
	<area shape="rect" coords="17,23,23,32" href="javascript:showColor('##009966')">
	<area shape="rect" coords="25,23,31,32" href="javascript:showColor('##009999')">
	<area shape="rect" coords="33,23,39,32" href="javascript:showColor('##0099CC')">
	<area shape="rect" coords="41,23,47,32" href="javascript:showColor('##0099FF')">
	<area shape="rect" coords="49,23,55,32" href="javascript:showColor('##339900')">
	<area shape="rect" coords="57,23,63,32" href="javascript:showColor('##339933')">
	<area shape="rect" coords="65,23,71,32" href="javascript:showColor('##339966')">
	<area shape="rect" coords="73,23,79,32" href="javascript:showColor('##339999')">
	<area shape="rect" coords="81,23,87,32" href="javascript:showColor('##3399CC')">
	<area shape="rect" coords="89,23,95,32" href="javascript:showColor('##3399FF')">
	<area shape="rect" coords="97,23,103,32" href="javascript:showColor('##669900')">
	<area shape="rect" coords="105,23,111,32" href="javascript:showColor('##669933')">
	<area shape="rect" coords="113,23,119,32" href="javascript:showColor('##669966')">
	<area shape="rect" coords="121,23,127,32" href="javascript:showColor('##669999')">
	<area shape="rect" coords="129,23,135,32" href="javascript:showColor('##6699CC')">
	<area shape="rect" coords="137,23,143,32" href="javascript:showColor('##6699FF')">
	<area shape="rect" coords="145,23,151,32" href="javascript:showColor('##999900')">
	<area shape="rect" coords="153,23,159,32" href="javascript:showColor('##999933')">
	<area shape="rect" coords="161,23,167,32" href="javascript:showColor('##999966')">
	<area shape="rect" coords="169,23,175,32" href="javascript:showColor('##999999')">
	<area shape="rect" coords="177,23,183,32" href="javascript:showColor('##9999CC')">
	<area shape="rect" coords="185,23,191,32" href="javascript:showColor('##9999FF')">
	<area shape="rect" coords="193,23,199,32" href="javascript:showColor('##CC9900')">
	<area shape="rect" coords="201,23,207,32" href="javascript:showColor('##CC9933')">
	<area shape="rect" coords="209,23,215,32" href="javascript:showColor('##CC9966')">
	<area shape="rect" coords="217,23,223,32" href="javascript:showColor('##CC9999')">
	<area shape="rect" coords="225,23,231,32" href="javascript:showColor('##CC99CC')">
	<area shape="rect" coords="233,23,239,32" href="javascript:showColor('##CC99FF')">
	<area shape="rect" coords="241,23,247,32" href="javascript:showColor('##FF9900')">
	<area shape="rect" coords="249,23,255,32" href="javascript:showColor('##FF9933')">
	<area shape="rect" coords="257,23,263,32" href="javascript:showColor('##FF9966')">
	<area shape="rect" coords="265,23,271,32" href="javascript:showColor('##FF9999')">
	<area shape="rect" coords="273,23,279,32" href="javascript:showColor('##FF99CC')">
	<area shape="rect" coords="281,23,287,32" href="javascript:showColor('##FF99FF')">
	<area shape="rect" coords="1,34,7,43" href="javascript:showColor('##006600')">
	<area shape="rect" coords="9,34,15,43" href="javascript:showColor('##006633')">
	<area shape="rect" coords="17,34,23,43" href="javascript:showColor('##006666')">
	<area shape="rect" coords="25,34,31,43" href="javascript:showColor('##006699')">
	<area shape="rect" coords="33,34,39,43" href="javascript:showColor('##0066CC')">
	<area shape="rect" coords="41,34,47,43" href="javascript:showColor('##0066FF')">
	<area shape="rect" coords="49,34,55,43" href="javascript:showColor('##336600')">
	<area shape="rect" coords="57,34,63,43" href="javascript:showColor('##336633')">
	<area shape="rect" coords="65,34,71,43" href="javascript:showColor('##336666')">
	<area shape="rect" coords="73,34,79,43" href="javascript:showColor('##336699')">
	<area shape="rect" coords="81,34,87,43" href="javascript:showColor('##3366CC')">
	<area shape="rect" coords="89,34,95,43" href="javascript:showColor('##3366FF')">
	<area shape="rect" coords="97,34,103,43" href="javascript:showColor('##666600')">
	<area shape="rect" coords="105,34,111,43" href="javascript:showColor('##666633')">
	<area shape="rect" coords="113,34,119,43" href="javascript:showColor('##666666')">
	<area shape="rect" coords="121,34,127,43" href="javascript:showColor('##666699')">
	<area shape="rect" coords="129,34,135,43" href="javascript:showColor('##6666CC')">
	<area shape="rect" coords="137,34,143,43" href="javascript:showColor('##6666FF')">
	<area shape="rect" coords="145,34,151,43" href="javascript:showColor('##996600')">
	<area shape="rect" coords="153,34,159,43" href="javascript:showColor('##996633')">
	<area shape="rect" coords="161,34,167,43" href="javascript:showColor('##996666')">
	<area shape="rect" coords="169,34,175,43" href="javascript:showColor('##996699')">
	<area shape="rect" coords="177,34,183,43" href="javascript:showColor('##9966CC')">
	<area shape="rect" coords="185,34,191,43" href="javascript:showColor('##9966FF')">
	<area shape="rect" coords="193,34,199,43" href="javascript:showColor('##CC6600')">
	<area shape="rect" coords="201,34,207,43" href="javascript:showColor('##CC6633')">
	<area shape="rect" coords="209,34,215,43" href="javascript:showColor('##CC6666')">
	<area shape="rect" coords="217,34,223,43" href="javascript:showColor('##CC6699')">
	<area shape="rect" coords="225,34,231,43" href="javascript:showColor('##CC66CC')">
	<area shape="rect" coords="233,34,239,43" href="javascript:showColor('##CC66FF')">
	<area shape="rect" coords="241,34,247,43" href="javascript:showColor('##FF6600')">
	<area shape="rect" coords="249,34,255,43" href="javascript:showColor('##FF6633')">
	<area shape="rect" coords="257,34,263,43" href="javascript:showColor('##FF6666')">
	<area shape="rect" coords="265,34,271,43" href="javascript:showColor('##FF6699')">
	<area shape="rect" coords="273,34,279,43" href="javascript:showColor('##FF66CC')">
	<area shape="rect" coords="281,34,287,43" href="javascript:showColor('##FF66FF')">
	<area shape="rect" coords="1,45,7,54" href="javascript:showColor('##003300')">
	<area shape="rect" coords="9,45,15,54" href="javascript:showColor('##003333')">
	<area shape="rect" coords="17,45,23,54" href="javascript:showColor('##003366')">
	<area shape="rect" coords="25,45,31,54" href="javascript:showColor('##003399')">
	<area shape="rect" coords="33,45,39,54" href="javascript:showColor('##0033CC')">
	<area shape="rect" coords="41,45,47,54" href="javascript:showColor('##0033FF')">
	<area shape="rect" coords="49,45,55,54" href="javascript:showColor('##333300')">
	<area shape="rect" coords="57,45,63,54" href="javascript:showColor('##333333')">
	<area shape="rect" coords="65,45,71,54" href="javascript:showColor('##333366')">
	<area shape="rect" coords="73,45,79,54" href="javascript:showColor('##333399')">
	<area shape="rect" coords="81,45,87,54" href="javascript:showColor('##3333CC')">
	<area shape="rect" coords="89,45,95,54" href="javascript:showColor('##3333FF')">
	<area shape="rect" coords="97,45,103,54" href="javascript:showColor('##663300')">
	<area shape="rect" coords="105,45,111,54" href="javascript:showColor('##663333')">
	<area shape="rect" coords="113,45,119,54" href="javascript:showColor('##663366')">
	<area shape="rect" coords="121,45,127,54" href="javascript:showColor('##663399')">
	<area shape="rect" coords="129,45,135,54" href="javascript:showColor('##6633CC')">
	<area shape="rect" coords="137,45,143,54" href="javascript:showColor('##6633FF')">
	<area shape="rect" coords="145,45,151,54" href="javascript:showColor('##993300')">
	<area shape="rect" coords="153,45,159,54" href="javascript:showColor('##993333')">
	<area shape="rect" coords="161,45,167,54" href="javascript:showColor('##993366')">
	<area shape="rect" coords="169,45,175,54" href="javascript:showColor('##993399')">
	<area shape="rect" coords="177,45,183,54" href="javascript:showColor('##9933CC')">
	<area shape="rect" coords="185,45,191,54" href="javascript:showColor('##9933FF')">
	<area shape="rect" coords="193,45,199,54" href="javascript:showColor('##CC3300')">
	<area shape="rect" coords="201,45,207,54" href="javascript:showColor('##CC3333')">
	<area shape="rect" coords="209,45,215,54" href="javascript:showColor('##CC3366')">
	<area shape="rect" coords="217,45,223,54" href="javascript:showColor('##CC3399')">
	<area shape="rect" coords="225,45,231,54" href="javascript:showColor('##CC33CC')">
	<area shape="rect" coords="233,45,239,54" href="javascript:showColor('##CC33FF')">
	<area shape="rect" coords="241,45,247,54" href="javascript:showColor('##FF3300')">
	<area shape="rect" coords="249,45,255,54" href="javascript:showColor('##FF3333')">
	<area shape="rect" coords="257,45,263,54" href="javascript:showColor('##FF3366')">
	<area shape="rect" coords="265,45,271,54" href="javascript:showColor('##FF3399')">
	<area shape="rect" coords="273,45,279,54" href="javascript:showColor('##FF33CC')">
	<area shape="rect" coords="281,45,287,54" href="javascript:showColor('##FF33FF')">
	<area shape="rect" coords="1,56,7,65" href="javascript:showColor('##000000')">
	<area shape="rect" coords="9,56,15,65" href="javascript:showColor('##000033')">
	<area shape="rect" coords="17,56,23,65" href="javascript:showColor('##000066')">
	<area shape="rect" coords="25,56,31,65" href="javascript:showColor('##000099')">
	<area shape="rect" coords="33,56,39,65" href="javascript:showColor('##0000CC')">
	<area shape="rect" coords="41,56,47,65" href="javascript:showColor('##0000FF')">
	<area shape="rect" coords="49,56,55,65" href="javascript:showColor('##330000')">
	<area shape="rect" coords="57,56,63,65" href="javascript:showColor('##330033')">
	<area shape="rect" coords="65,56,71,65" href="javascript:showColor('##330066')">
	<area shape="rect" coords="73,56,79,65" href="javascript:showColor('##330099')">
	<area shape="rect" coords="81,56,87,65" href="javascript:showColor('##3300CC')">
	<area shape="rect" coords="89,56,95,65" href="javascript:showColor('##3300FF')">
	<area shape="rect" coords="97,56,103,65" href="javascript:showColor('##660000')">
	<area shape="rect" coords="105,56,111,65" href="javascript:showColor('##660033')">
	<area shape="rect" coords="113,56,119,65" href="javascript:showColor('##660066')">
	<area shape="rect" coords="121,56,127,65" href="javascript:showColor('##660099')">
	<area shape="rect" coords="129,56,135,65" href="javascript:showColor('##6600CC')">
	<area shape="rect" coords="137,56,143,65" href="javascript:showColor('##6600FF')">
	<area shape="rect" coords="145,56,151,65" href="javascript:showColor('##990000')">
	
	<area shape="rect" coords="153,56,159,65" href="javascript:showColor('##990033')">
	<area shape="rect" coords="161,56,167,65" href="javascript:showColor('##990066')">
	<area shape="rect" coords="169,56,175,65" href="javascript:showColor('##990099')">
	<area shape="rect" coords="177,56,183,65" href="javascript:showColor('##9900CC')">
	<area shape="rect" coords="185,56,191,65" href="javascript:showColor('##9900FF')">
	<area shape="rect" coords="193,56,199,65" href="javascript:showColor('##CC0000')">
	<area shape="rect" coords="201,56,207,65" href="javascript:showColor('##CC0033')">
	<area shape="rect" coords="209,56,215,65" href="javascript:showColor('##CC0066')">
	<area shape="rect" coords="217,56,223,65" href="javascript:showColor('##CC0099')">
	<area shape="rect" coords="225,56,231,65" href="javascript:showColor('##CC00CC')">
	<area shape="rect" coords="233,56,239,65" href="javascript:showColor('##CC00FF')">
	<area shape="rect" coords="241,56,247,65" href="javascript:showColor('##FF0000')">
	<area shape="rect" coords="249,56,255,65" href="javascript:showColor('##FF0033')">
	<area shape="rect" coords="257,56,263,65" href="javascript:showColor('##FF0066')">
	<area shape="rect" coords="265,56,271,65" href="javascript:showColor('##FF0099')">
	<area shape="rect" coords="273,56,279,65" href="javascript:showColor('##FF00CC')">
	<area shape="rect" coords="281,56,287,65" href="javascript:showColor('##FF00FF')">
	</map>
	<a><img usemap="##colmap" src="/images/activedesktop/colortable.gif" border=0 width=289 height=67></a><br>

	</td>
  </tr>  
  <tr>
    <td>&nbsp;</td>
    <td><input type="submit" class="btn" name="frmSubmit" value="#GetLangVal('cm_wd_save')#"></td>
  </tr>  
</table>
</form>
</cfoutput>