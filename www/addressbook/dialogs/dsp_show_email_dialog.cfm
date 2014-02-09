<!--- //

	Module:		Address Book
	Action:		OpenEmailDialog
	Description:Offer Email options ...
	

// --->

<cfparam name="url.contactkey" type="string" default="">
<cfparam name="url.emailadr" type="string" default="">

<cfif Len(url.contactkey) IS 0>
	<cfexit method="exittemplate">
</cfif>

<!--- do we have to load the email addresses from the database? ... --->
<cfif Len(url.emailadr) IS 0>
	
	<cfinvoke component="#application.components.cmp_addressbook#" method="GetContact" returnvariable="a_struct_object">
		<cfinvokeargument name="entrykey" value="#url.contactkey#">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		<cfinvokeargument name="loadmetainformations" value="false">
	</cfinvoke>
	
	<cfif NOT a_struct_object.result>
		<cfexit method="exittemplate">
	</cfif>
	
	<cfset url.emailadr = a_struct_object.q_select_contact.email_prim />
	

</cfif>

<cfif Len(url.emailadr) IS 0>
	<cfoutput>#GetLangVal('adrb_ph_you_have_to_enter_an_email_address')#</cfoutput>
	<cfexit method="exittemplate">
</cfif>

<cfset a_int_templates_available = 0 />

<cfif a_int_templates_available IS 0>
	
	<!--- TODO hp: generate default text! ... --->

	<script type="text/javascript">
		OpenComposePopupTo('<cfoutput>#jsstringformat(url.emailadr)#'</cfoutput>);
		CloseSimpleModalDialog();
	</script>

	<cfexit method="exittemplate">
</cfif>

<!--- load available templates ... --->
<table class="table_details table_edit_form">
	<tr>
		<td class="field_name">
			<cfoutput>#GetLangVal('cm_wd_templates')#</cfoutput>:
		</td>
		<td>
			<select name="frmtemplatekey" size="3">
				<option selected value="">Use no template</option>
			</select>
		</td>
	</tr>
	<tr>
		<td class="field_name">
			<cfoutput>#GetLangVal('adrb_wd_email_address')#</cfoutput>:
		</td>
		<td>
			<cfoutput>#htmleditformat(url.emailadr)#</cfoutput>
		</td>
	</tr>
	<tr>
		<td class="field_name">
			
		</td>
		<td>
			<input type="button" value="<cfoutput>#GetLangVal('adrb_ph_actions_compose_mail')#</cfoutput>" class="btn" />
		</td>
	</tr>
</table>


