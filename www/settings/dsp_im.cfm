<!---	



	--->
	
<cfinvoke component="#application.components.cmp_im#" method="GetContactlist" returnvariable="stReturn">
	<cfinvokeargument name="username" value="#request.stSecurityContext.myusername#">
</cfinvoke>
<cfset q_select_contact_list = stReturn.q_select_contact_list>

<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "im"
	entryname = "enable_alerts"
	defaultvalue1 = "1"
	setcallervariable1 = "a_int_enable_alerts">

<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "im"
	userid = 0
	entryname = "visibility_modus_#Hash(request.stSecurityContext.myusername)#"
	defaultvalue1 = "1"
	setcallervariable1 = "a_int_visible_mode_common">	
	
<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "im"
	entryname = "visibility_modus"
	defaultvalue1 = "1"
	setcallervariable1 = "a_int_visible_mode">	
	
<cf_disp_navigation mytextleft="#GetLangVal('cm_ph_instant_messenger')#">
<br>
<div class="b_all mischeader" style="padding:4px;width:300px;font-weight:bold;"><a href="/im/">&lt; <cfoutput>#GetLangVal('prf_ph_goto_im_module')#</cfoutput></a></div><br>


<table border="0" cellspacing="0" cellpadding="4">
<form action="act_save_im_settings.cfm" method="post">
  <!---<tr>
    <td align="right">
		Status beim Start:
	</td>
    <td>
		<select name="frmstandardmodus">
			<option value="1">online</option>
		</select>
	</td>
  </tr>--->
  <!---<tr>
    <td align="right" valign="top">
		Invisible-List:
	</td>
    <td valign="top">
		Fuer diese Kontakte soll ich immer offline erscheinen auch wenn ich online bin:
		<br>
		<cfoutput query="q_select_contact_list">
			<input class="noborder" type="checkbox" name="frmcbinvisible" value="#htmleditformat(q_select_contact_list.jid)#"> #q_select_contact_list.nick#<br>
		</cfoutput>
	</td>
  </tr>--->
  <tr>
    <td>
		<input type="checkbox" name="frmcb_enable_alerts" class="noborder" value="1" <cfoutput>#WriteCheckedElement(a_int_enable_alerts, 1)#</cfoutput>>
	</td>
    <td>
		<cfoutput>#GetLangVal('prf_ph_im_enable_alerts')#</cfoutput>
	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
		<cfoutput>#GetLangVal('prf_ph_im_online_status_visible_for')#</cfoutput>
		&nbsp;
		<select name="frmvisible_mode">
			<option value="0" <cfoutput>#WriteSelectedElement(a_int_visible_mode, 0)#</cfoutput>><cfoutput>#GetLangVal('prf_ph_im_online_status_visible_for_nobody')#</cfoutput></option>
			<option value="1" <cfoutput>#WriteSelectedElement(a_int_visible_mode, 1)#</cfoutput>><cfoutput>#GetLangVal('prf_ph_im_online_status_visible_for_contactlist')#</cfoutput></option>
			<option value="2" <cfoutput>#WriteSelectedElement(a_int_visible_mode, 2)#</cfoutput>><cfoutput>#GetLangVal('prf_ph_im_online_status_visible_for_all')#</cfoutput></option>
		</select>
	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
		<input type="submit" name="frmsubmit" value="<cfoutput>#GetLangVal('cm_wd_save')#</cfoutput>">
	</td>
  </tr>
</form>  
</table>