<!--- //

	// --->
<cfinclude template="../dsp_inc_select_company.cfm">

<cfparam name="url.entrykey" type="string" default="">

<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserData" returnvariable="stReturn">
  <cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

<cfset q_select_user = stReturn.query>
	
<h4>Photo setzen</h4>

<table border="0" cellspacing="0" cellpadding="6">
<form action="user/act_add_user_photo.cfm" method="post" enctype="multipart/form-data">
<input type="hidden" name="frmentrykey" value="<cfoutput>#htmleditformat(url.entrykey)#</cfoutput>">
  <tr>
  	<td class="bb" align="right"><cfoutput>#GetLangVal('cm_wd_user')#</cfoutput>:</td>
	<td class="bb">
	<cfoutput>#stReturn.query.username#</cfoutput>
	</td>
  </tr>
  <tr>
  	<td colspan="2">&nbsp;&nbsp;</td>
  </tr>
<tr>
	<td colspan="2" class="bb mischeader" style="font-weight:bold; "><cfoutput>#GetLangVal('adm_ph_photo_small')#</cfoutput></td>
</tr>
  
  <cfif q_select_user.smallphotoavaliable is 1>
  <tr>
  	<td>&nbsp;</td>
	<td>
	<a onClick="return confirm('<cfoutput>#GetLangVal('cm_ph_are_you_sure')#</cfoutput>');" href="user/act_remove_photo.cfm?entrykey=<cfoutput>#url.entrykey#</cfoutput>&type=0"><cfoutput><span class="glyphicon glyphicon-trashÓ></span> #GetLangVal('cm_wd_delete')#</cfoutput></a>
	<br>
	<img src="/tools/img/show_small_userphoto.cfm?entrykey=<cfoutput>#urlencodedformat(url.entrykey)#</cfoutput>">
	</td>
  </tr>
  </cfif>
  <tr>
    <td align="right"><cfoutput>#GetLangVal('adm_ph_photo_small')#</cfoutput>:</td>
    <td>
	<input type="file" name="frmphotosmall">
	</td>
  </tr>
  <tr>
  	<td>&nbsp;</td>
	<td>
	<cfoutput>#GetLangVal('adm_ph_photo_small_recommended_height')#</cfoutput>
	</td>
  </tr>
  <tr>
  	<td></td>
	<td>
		<input type="submit" name="frmsubmit" value="<cfoutput>#GetLangVal('adm_ph_save_photos')#</cfoutput>">
	</td>
  </tr>
</form>
<tr>
		<td colspan="2" class="bb mischeader" style="font-weight:bold; "><cfoutput>#GetLangVal('adm_ph_photo_big')#</cfoutput></td>
</tr>
<form action="user/act_add_user_photo.cfm" method="post" enctype="multipart/form-data">
<input type="hidden" name="frmentrykey" value="<cfoutput>#htmleditformat(url.entrykey)#</cfoutput>">
  <cfif q_select_user.bigphotoavaliable is 1>
  <tr>
  	<td>&nbsp;</td>
	<td>
	<a onClick="return confirm('<cfoutput>#GetLangVal('cm_ph_are_you_sure')#</cfoutput>');" href="user/act_remove_photo.cfm?entrykey=<cfoutput>#url.entrykey#</cfoutput>&type=1"><cfoutput><span class="glyphicon glyphicon-trashÓ></span> #GetLangVal('cm_wd_delete')#</cfoutput></a>
	<br>
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
		<cfoutput>#GetLangVal('adm_ph_photo_big_recommended_width')#</cfoutput>
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
<br><br><br><br>
<cfoutput>#GetLangVal('cm_wd_example')#</cfoutput>:<br>
<table border="0" cellspacing="0" cellpadding="4">
  <tr>
    <td valign="middle">
	<img src="/images/admin/img_user_photo_example_big.jpg">
	</td>
    <td valign="middle">
	<img src="/images/admin/img_user_photo_example_small.jpg">
	</td>
  </tr>
</table>
