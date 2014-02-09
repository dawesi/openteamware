<!--- //

	Module:		Framework
	Description:Loginbox for Homepage
	

// --->
<cfcontent type="text/javascript">

<cfprocessingdirective pageencoding="UTF-8">

<!--- // check if user is logged in // --->
<cfset variables.a_bol_known_user = StructKeyExists(client, 'lastloginusername') AND Len(client.lastloginusername) GT 0 />

<!--- exit if unknown user --->
<cfif NOT variables.a_bol_known_user>
	<cfexit method="exittemplate">
</cfif>

<cfsavecontent variable="a_str_login">
<!--- user has been logged in some time ago ... --->		
<form action="/login/act_login.cfm" method="post" style="margin:0px; " name="form_login_box">
<input type="hidden" name="frmusername" value="<cfoutput>#htmleditformat(client.lastloginusername)#</cfoutput>">
<table border="0" cellspacing="0" cellpadding="4" align="right">
  <tr>
  	
	<td style="padding-left:25px;  ">
		Benutzername: 
		<b>
			<cfoutput>#htmleditformat(client.lastloginusername)#</cfoutput>
		</b>
			[ <a href="/login/?resetloginusername=1">&Auml;ndern ...</a> ]
	</td>		
	<td>
		Passwort:
		&nbsp;
		<input type="password" name="frmpassword" value="" size="12" />
	</td>
	<td>
		|
	</td>			
	<td>
		[ <a href="javascript:document.form_login_box.submit();"><img src="/images/si/key.png" class="si_img" /> Login</a> ]
	</td>
  </tr>
</table>
</form>
		
</cfsavecontent>
function CheckLoginBox() {
	var obj1 = findObj('id_login_box');
	obj1.style.display = '';
	obj1.innerHTML = '<cfoutput>#jsstringformat(a_str_login)#</cfoutput>';
	// set focus ...
	document.forms.form_login_box.frmpassword.focus();
	}

// add event ... 
addEventEx(window, 'load', CheckLoginBox);

