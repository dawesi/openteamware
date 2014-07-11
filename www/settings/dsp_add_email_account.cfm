<!--- 

	add an email account

 --->

<cfparam name="url.provider" type="string" default="">
<cfparam name="url.error" type="numeric" default="0">

<cfset SetHeaderTopInfoString( 'Add an email account' ) />

<div class="confirmation">
	To enable all features, you've to add your email account
	<br /><br />
	You will be able to send &amp; receive mails using your existing account.
</div>

<cfif Val( url.error ) GT 0>
	<div class="status">
		<b>An error occured</b>
		<br />
		The access data provided did not work out. Please double-check them / contact your administrator for further instructions.
	</div>	
</cfif>

<cfif Len( url.provider ) IS 0>

	<h4>Please select your email provider</h4>
	
	<a href="index.cfm?action=addemailaccount&amp;provider=gmail">Google Mail</a>
	&nbsp;|&nbsp;
	<a href="index.cfm?action=addemailaccount&amp;provider=custom">Other provider (IMAP)</a>

	<cfexit method="exittemplate">
</cfif>

<cfset a_str_hint_username = '' />
<cfset a_str_server = '' />
<cfset a_str_port = 143 />
<cfset a_bol_ssl = false />

<cfswitch expression="#url.provider#">
	
	<cfcase value="gmail">
		<cfset a_str_hint_username = 'Your full email address' />
		<cfset a_str_server = 'imap.gmail.com' />
		<cfset a_str_port = 993 />
		<cfset a_bol_ssl = true />
	</cfcase>

</cfswitch>

<cfoutput>
	

<div class="confirmation" style="display:none;margin-top:60px" id="id_progress">
	<b>Checking the provided data ... trying to connect to the server</b>
</div>
	



<form action="actions/act_add_email_account.cfm" method="post" onsubmit="$(this).fadeOut();$('##id_progress').fadeIn()">
	
<h4>Please enter your data</h4>

<table class="table table_details table_edit_form" style="width:auto">
	<tr>
		<td class="field_name">
			#GetLangVal( 'prf_ph_email_sender_name' )#
		</td>
		<td>
			<input type="text" value="#htmleditformat( request.a_struct_personal_properties.myfirstname & ' ' & request.a_struct_personal_properties.mysurname )#" name="displayname" />
		</td>
	</tr>	
	<tr>
		<td class="field_name">
			#GetLangVal( 'cm_wd_email' )#
		</td>
		<td>
			<input type="text" value="#htmleditformat( request.stSecurityContext.myusername )#" name="email" />
		</td>
	</tr>
	<tr>
		<td class="field_name">
			#getLangval( 'cm_wd_username' )#
		</td>
		<td>
			<input type="text" value="#htmleditformat( request.stSecurityContext.myusername )#" name="username" />
			<br />
			#a_str_hint_username#
		</td>
	</tr>
	<tr>
		<td class="field_name">
			#GetLangVal( 'cm_wd_password' )#
		</td>
		<td>
			<input type="password" value="" name="password" />
		</td>
		<td>
			
		</td>
	</tr>	
	<tr>
		<td class="field_name">
			#getLangVal( 'cm_wd_server' )#
		</td>
		<td>
			<input type="text" value="#htmleditformat( a_str_server )#" name="server" />
		</td>
	</tr>
	<tr>
		<td class="field_name">
			Port
		</td>
		<td>
			<input type="text" value="#htmleditformat( a_str_port )#" name="port" />
		</td>
	</tr>	
	<tr>
		<td class="field_name">
			SSL
		</td>
		<td>
			<input type="checkbox" name="ssl" value="1" <cfif a_bol_ssl>checked="true"</cfif> />
		</td>
	</tr>	
	<tr>
		<td class="field_name">
		</td>
		<td>
			<input type="submit" value="#GetLangVal('cm_wd_save')#" class="btn btn-primary" />
		</td>
	</tr>
</table>
</form>
</cfoutput>