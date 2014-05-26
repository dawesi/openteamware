<!--- //

	request again the confirmation code
	
	// --->
<cfparam name="url.id" type="numeric" default="0">


<cf_disp_navigation mytextleft="Bestaetigungscode anfordern">
<br>
<br>
Der Bestaetigungscode wurde nochmals verschickt!
<br>
<br>
Pruefen Sie bitte in wenigen Minuten Ihren jeweiligen Posteingang bzw. den Posteingang!
<br>
<br>
<a href="index.cfm?action=emailaccounts">zur&uuml;ck</a>

<cfmodule template="mod_send_email_confirm.cfm" id=#url.id# userid=#request.stSecurityContext.myuserid# username=#request.stSecurityContext.myusername#>