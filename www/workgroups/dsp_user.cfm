<!--- //

	Module:		Workgroups
	Action:		ShowUser
	Description: 
	

	
	
	Display virtual business card
	
// --->

<cfexit method="exittemplate">

<!--- load userdata --->
<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserData" returnvariable="stReturn">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

<cfset q_select_user = stReturn.query>

<cfif Compare(q_select_user.companykey, request.stSecurityContext.mycompanykey) NEQ 0>
	<!--- check permissions ... --->
	<cfexit method="exittemplate">
</cfif>

<table border="0" cellspacing="0" cellpadding="10">
  <tr>
    <td valign="top">
		<!--- a photo? --->

		
	</td>
    <td>
	
	<table border="0" cellspacing="0" cellpadding="4">
	  <cfoutput query="q_select_user">
	  <tr>
		<td align="right">
			<h4 style="margin-bottom:5px;">Name:</h4>
		</td>
		<td>
			<h4 style="margin-bottom:5px;">#q_select_user.surname#, #q_select_user.firstname#</h4>
		</td>
	  </tr>
	  <tr>
		<td align="right">Benutzername:</td>
		<td>
			#q_select_user.username#
		</td>
	  </tr>
	  <tr>
	  	<td class="bb" align="right"><b>Details</b></td>
		<td class="bb">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td align="right">dabei seit:</td>
		<td></td>
	  </tr>
	  <tr>
	  	<td align="right">Abteilung:</td>
		<td>
		#q_select_user.department#
		</td>
	  </tr>
	  <tr>
	  	<td align="right">Position:</td>
		<td>
		#q_select_user.aposition#
		</td>
	  </tr>
	  <tr>
	  	<td align="right">Status:</td>
		<td>
		
		</td>
	  </tr>
	  <tr>
	  	<td align="right">Arbeitsgruppen:</td>
		<td>
		
		</td>
	  </tr>
	  <tr>
	  	<td align="right">
		Raum:
		</td>
		<td>
		
		</td>
	  </tr>
	  <tr>
	  	<td align="right">
		Telefon (Buero):
		</td>
		<td>
		
		</td>
	  </tr>
	  <tr>
	  	<td align="right">
		Telefon (mobil):
		</td>
		<td>
		
		</td>
	  </tr>	  
	  <tr>
	  	<td align="right">
		Fax:
		</td>
		<td>
		
		</td>
	  </tr>
	  <tr>
	  	<td class="bb" align="right">Privatadresse</td>
		<td class="bb">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td align="right">Adresse:</td>
		<td></td>
	  </tr>
	  <tr>
	  	<td align="right" class="bb"><b>Aktionen</b></td>
		<td class="bb">&nbsp;</td>
	  </tr>
	  <tr>
		<td align="right">E-Mail schreiben:</td>
		<td>
			<a href="../email/default.cfm?action=composemail&type=0&to=#urlencodedformat(q_select_user.username)#">hier klicken ...</a>
		</td>
	  </tr>
	  <tr>
		<td>
			Verfuegbarkeit anzeigen:
		</td>
		<td>
			...
		</td>
	  </tr>
	  
	</table>
	
	</td>
	<td valign="top">
		<br><br>
		
		<table border="0" cellspacing="0" cellpadding="4" class="b_all">
		  <tr>
			<td align="center" valign="middle">
			<cfif q_select_user.bigphotoavaliable IS 1>
				<img src="../tools/img/show_big_userphoto.cfm?entrykey=#urlencodedformat(q_select_user.entrykey)#">
			<cfelseif q_select_user.smallphotoavaliable IS 1>
				<img src="../tools/img/show_small_userphoto.cfm?entrykey=#urlencodedformat(q_select_user.entrykey)#">
			<cfelse>
			kein Foto verfugbar
			</cfif>
			</td>
		  </tr>
		</table>
		
		<br><br>
		Status: <b><font color="##CC0000">offline</font></b>
	</td>
  </tr>
</table>
</cfoutput>

