<!--- //

	edit several contacts at one time
	
	// --->

<cfparam name="form.frmAction" type="string" default="none">

<!--- the selected ids ... 1,234,5345,345345,23542385 --->
<cfparam name="form.frmid" type="string" default="">

<!--- handled? --->
<cfset a_bol_Handled = false>
						
<cfif len(form.frmid) gt 0>

	<!--- // which action should be taken with the selected items // --->
	
	<cfswitch expression="#form.frmAction#">
		<cfcase value="sendemail">
		<!--- send an email to the selected items --->
		<cfset a_bol_Handled = true>
		<cfinclude template="act_send_massmail.cfm">
		</cfcase>
		
		<cfcase value="delete">
		<!--- delete the selected items --->
		<cfset a_bol_Handled = true>
		<cfinclude template="dsp_delete_selected.cfm">
		</cfcase>
		
		<cfcase value="forward">
		<!--- forward contacts --->
		<cfset a_bol_Handled = true>
		<cfinclude template="dsp_forward_selected.cfm">
		</cfcase>
		
		<cfcase value="remoteedit">
		<!--- remote edit for a lot of contacts --->
		<cfset a_bol_Handled = true>
		<cfset url.id = form.select>
		<cfinclude template="dsp_activate_remote_edit.cfm">
		</cfcase>
	
	</cfswitch>			
</cfif>

<!--- keine aktion - alle kontakte anzeigen --->
<cfif a_bol_Handled is false>
	<cflocation addtoken="No" url="default.cfm">
</cfif>