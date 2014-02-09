
<!--- user ... --->
<cfparam name="url.entrykey" type="string" default="">

<cfset cmp_user = application.components.cmp_user>
<cfset a_str_username = cmp_user.GetUsernamebyentrykey(url.entrykey)>

<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserData" returnvariable="stReturn">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

<cfset q_select_user = stReturn.query>

<h4><cfoutput>#GetLangVal('adm_ph_set_photo')#</cfoutput></h4>

<table border="0" cellspacing="0" cellpadding="6">
<form action="user/act_add_user_photo.cfm" method="post" enctype="multipart/form-data">
<input type="hidden" name="frmentrykey" value="<cfoutput>#htmleditformat(url.entrykey)#</cfoutput>">
  <tr>
  	<td class="bb" align="right"><cfoutput>#GetLangVal('cm_wd_username')#</cfoutput>:</td>
	<td class="bb">
		<cfoutput>#a_str_username#</cfoutput>
	</td>
  </tr>
  <cfif q_select_user.smallphotoavaliable is 1>
  <tr>
  	<td>&nbsp;</td>
	<td>
	<img src="/tools/img/show_small_userphoto.cfm?entrykey=<cfoutput>#urlencodedformat(url.entrykey)#</cfoutput>">
	</td>
  </tr>
  </cfif>
  <tr>
    <td align="right">
		<cfoutput>#GetLangVal('adm_ph_photo_small')#</cfoutput>:
	</td>
    <td>
	<input type="file" name="frmphotosmall">
	</td>
  </tr>
  <tr>
  	<td>&nbsp;</td>
	<td>
		<cfoutput>#GetLangVal('adm_ph_photo_small_recommended_height')#</cfoutput>: 60 px
	</td>
  </tr>
  <cfif q_select_user.bigphotoavaliable is 1>
  <tr>
  	<td>&nbsp;</td>
	<td>
	<img src="/tools/img/show_big_userphoto.cfm?entrykey=<cfoutput>#urlencodedformat(url.entrykey)#</cfoutput>">
	</td>
  </tr>
  </cfif>  
  <tr>
    <td align="right"><cfoutput>#GetLangVal('adm_ph_photo_big')#</cfoutput>:</td>
    <td>
	<input type="file" name="frmphotobig">
	</td>
  </tr>
  <tr>
  	<td>&nbsp;</td>
	<td>
		<cfoutput>#GetLangVal('adm_ph_photo_big_recommended_width')#</cfoutput>: 130px
	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
	<input type="submit" name="frmsubmit" value="<cfoutput>#GetLangVal('adm_ph_save_photos')#</cfoutput>">
	</td>
  </tr>
</form>
</table>