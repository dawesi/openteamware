<cfif StructKeyExists(variables, 'q_user_data') IS FALSE>
	<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserdata" returnvariable="stReturn">
		<cfinvokeargument name="entrykey" value="#request.stSecurityContext.myuserkey#">
	</cfinvoke>
	<cfset q_user_data = stReturn.query>
</cfif>

<table width="100%" border="0" cellspacing="0" cellpadding="2">
  <tr> 
    <td class="b_all" style="letter-spacing:2px;font-size:10px;text-transform:uppercase;"> 
      &nbsp;<b>Statistik</b> </td>
  </tr>
  <tr>
  	<td>
	
		<table border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td align="right">Logins:</td>
			<td>
			<cfoutput>#q_user_data.login_count#</cfoutput>
			</td>
		  </tr>
		  <tr>
		  	<td align="right">Last login:</td>
			<td>
			<cfoutput>
			#TimeFormat(q_user_data.lasttimelogin, 'HH:mm')#
			</cfoutput>
			</td>
		  </tr>
		  <tr>
			<td align="right">
			Aktuelle IP-Adresse:
			</td>
			<td>
			<cfoutput>#cgi.REMOTE_ADDR#</cfoutput>
			</td>
		  </tr>
		  <tr>
		  	<td colspan="2" class="bb">Eigene Daten</td>
		  </tr>
		  
		  <cfinvoke component="#application.components.cmp_calendar#" method="GetOwnRecordsRecordcount" returnvariable="a_int_count" userkey = #request.stSecurityContext.myuserkey#>
		  </cfinvoke>		  
		  <tr>
			<td align="right">
				<a href="/calendar/">Termine:</a>
			</td>
			<td>
				<cfoutput>#a_int_count#</cfoutput>
			</td>
		  </tr>
		  
		  <cfinvoke component="#application.components.cmp_addressbook#" method="GetOwnContactsRecordcount" returnvariable="a_int_count" userkey = #request.stSecurityContext.myuserkey#>
		  </cfinvoke>
		  
		  <tr>
			<td align="right">
				<a href="/addressbook/">Kontakte:</a>
			</td>
			<td>
				<cfoutput>#a_int_count#</cfoutput>
			</td>
		  </tr>
		  
		  <cfinvoke component="#application.components.cmp_tasks#" method="GetOwnRecordsRecordcount" returnvariable="a_int_count" userkey = #request.stSecurityContext.myuserkey#>
		  </cfinvoke>		  
		  <tr>
			<td align="right">
				<a href="/tasks/">Aufgaben:</a>
			</td>
			<td>
				<cfoutput>#a_int_count#</cfoutput>
			</td>
		  </tr>
		  
		  <cfinvoke component="#application.components.cmp_storage#" method="GetOwnRecordsRecordcount" returnvariable="a_int_count" userkey = #request.stSecurityContext.myuserkey#>
		  </cfinvoke>
		  
		  <tr>
			<td align="right">
				<a href="/storage/">Dateien:</a>
			</td>
			<td>
				<cfoutput>#a_int_count#</cfoutput>
			</td>
		  </tr>		  
		  <!---<tr>
			<td align="right">Notizen:</td>
			<td>&nbsp;</td>
		  </tr>--->		  		  
		</table>
	
	</td>  
  </tr>
</table>