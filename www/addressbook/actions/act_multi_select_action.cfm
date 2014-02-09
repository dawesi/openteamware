<!--- //

	Module:		Address Book
	Action:		DoMultiSelectAction
	Description:Handle multi select actions 
	
// --->


<!--- the selected items ... --->
<cfparam name="form.frmcbselect" type="string" default="">
<cfparam name="form.frmselectaction" type="string" default="">
<cfparam name="form.frmdisplaydatatype" type="numeric" default="0">

<cfif Len(form.frmcbselect) IS 0>
	<cflocation addtoken="no" url="#ReturnRedirectURL()#">
</cfif>

<cfswitch expression="#form.frmselectaction#">
	<cfcase value="massaction">
		<!--- apply criteria to all selected contacts ... or other mass action --->

		<cfset session.a_struct_temp_data = StructNew() />
		<cfset session.a_struct_temp_data.addressbook_selected_entrykeys = form.frmcbselect />
		
		<cflocation addtoken="false" url="default.cfm?action=ShowMassActions&datatype=#form.frmdisplaydatatype#">
		
	</cfcase>
	<cfcase value="createmailing">
		<!--- create a new mailing based on the current selection ... --->
		<cfset session.a_struct_temp_data = StructNew() />
		<cfset session.a_struct_temp_data.addressbook_selected_entrykeys = form.frmcbselect />
		
		<cflocation addtoken="no" url="/mailing/default.cfm?action=CreateMailingFromAddressBook">
	</cfcase>
	
	<cfcase value="addtonewsletter">
		
		<!--- add selected contacts to a newsletter --->
		<cfset session.a_struct_temp_data = StructNew() />
		<cfset session.a_struct_temp_data.addressbook_selected_entrykeys = form.frmcbselect />
		<cflocation addtoken="no" url="default.cfm?action=AddContactsToNewsletter">
		
	</cfcase>
	<cfcase value="export">
		
		<!--- export contacts as CSV --->
		<cfset session.a_struct_temp_data = StructNew() />
		<cfset session.a_struct_temp_data.addressbook_selected_entrykeys = form.frmcbselect />
		<cflocation addtoken="no" url="default.cfm?action=ExportContacts">
		
	</cfcase>
	<cfcase value="addtomailinglist">
		<!--- add selected contacts to a mailinglist ... --->
		<cfset session.a_struct_temp_data = StructNew()>
		<cfset session.a_struct_temp_data.addressbook_selected_entrykeys = form.frmcbselect>	
		<cflocation addtoken="no" url="default.cfm?action=AddContactsToMailinglist">
		
	</cfcase>
	<cfcase value="email">
		<!--- load email addresses and create an email ... --->
		<cfinclude template="utils/inc_send_mail_to_selected_addresses.cfm">			
	</cfcase>
	<cfcase value="forward">
		<cflocation addtoken="no" url="default.cfm?action=forward&entrykeys=#urlencodedformat(form.frmcbselect)#">
	</cfcase>
	<cfcase value="remoteedit">
		<cfset session.a_struct_temp_data = StructNew()>
		<cfset session.a_struct_temp_data.addressbook_selected_entrykeys = form.frmcbselect>		
		<cflocation addtoken="no" url="default.cfm?action=remoteedit&entrykeys=session">
	</cfcase>
	<cfcase value="delete">
		<cfset session.a_struct_temp_data = StructNew()>
		<cfset session.a_struct_temp_data.addressbook_url = form.frmcbselect>	
		<cflocation addtoken="no" url="default.cfm?action=DeleteContacts">
	</cfcase>
	<cfdefaultcase>
		<cflocation addtoken="no" url=".">
	</cfdefaultcase>
</cfswitch>

