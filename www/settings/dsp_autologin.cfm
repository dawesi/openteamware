<!--- //


	autologin feature
	
	// --->
	
<cf_disp_navigation mytextleft="Autologin">
<br>

<!--- select current login key --->
<cfinclude template="queries/q_select_autologinkey.cfm">

<cfif Len(q_select_autologinkey.autologin_key) is 0>
<!--- no key yet created --->
<cfoutput>#GetLangVal('prf_ph_autologin_notCreatedYet')#</cfoutput>
<br>
<form action="act_create_autologin_key.cfm" method="post">
<input type="submit" name="frmSubmit" value="<cfoutput>#GetLangVal('prf_ph_autologin_createnow')#</cfoutput>">
</form>

<cfexit method="exittemplate">
</cfif>



<cfset a_str_autologin = "http://www.openTeamWare.com/al/?key="&q_select_autologinkey.autologin_key>

<script type="text/javascript">
var url = "<cfoutput>#a_str_autologin#</cfoutput>"

var ms = navigator.appVersion.indexOf("MSIE")
var ie5 = (ms>0) && (parseInt(navigator.appVersion.substring(ms+5, ms+7)) >= 5)

function set_as_homepage(othis)
{
if(ie5)
{
othis.style.behavior='url(#default#homepage)';
othis.setHomePage(url);
}
else
{
 alert("Ihr Browser unterstuetzt dieses Feature leider nicht - bitte nehmen Sie die Einstellung manuell vor.\n Only Internet Explorer 5 or higher.");
}
}
</script>

<table border="0" cellspacing="0" cellpadding="4">
  <tr>
  	<td colspan="2">
	<!--- let the user create a new one --->
	<cfoutput>#GetLangVal('prf_ph_autologin_security_create_new')#</cfoutput>

	</td>
  </tr>
  <form action="act_create_autologin_key.cfm" method="post">
  <tr>
  	<td colspan="2" align="center">
	<input type="submit" name="frmSubmit" value="<cfoutput>#GetLangVal('prf_ph_autologin_createnow')#</cfoutput>">
	</td>
  </tr>
  </form>
  <tr>
  	<td colspan="2">&nbsp;</td>
  </tr>
  <tr class="mischeader">
    <td colspan="2">
	<img src="/storage/images/topopen.gif" align="absmiddle" vspace="2" height="19" width="19" border="0"><cfoutput>#GetLangVal('prf_ph_autologin_your_link')#</cfoutput>: <b>http://www.openTeamWare.com/al/?key=<cfoutput>#q_select_autologinkey.autologin_key#</cfoutput></b>
	</td>
  </tr>
  <tr>
  	<td colspan="2">&nbsp;</td>
  </tr>
  <tr>
    <td align="center"><a HREF="#" onClick="set_as_homepage(this);"><img src="/images/settings/set_as_home.gif" align="absmiddle" border="0"> <cfoutput>#GetLangVal('prf_ph_autologin_set_as_homepage')#</cfoutput></a></td>
    <td align="center"><a href="javascript:window.external.AddFavorite('<cfoutput>#a_str_autologin#</cfoutput>','openTeamWare [Autologin]')"><img src="/images/bookmarks/menu_neues_bookmark.gif" align="absmiddle" border="0"> <cfoutput>#GetLangVal('prf_ph_autologin_add_fav')#</cfoutput></a></td>
  </tr>
</table>
<!---<br>
<br>
<br>
<i>Anleitung f�r andere Browser als den Internet Explorer:</i><br>
Kopieren Sie die oben angegebene URL aus dieser Seite heraus<br>
und geben Sie diese dann in Ihren Browsereinstellungen als Startseite an.--->