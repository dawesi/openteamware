<!--- //

	Module:		AddressBook
	Action:		Showall
	Description:Display all contacts which apply


// --->

<!--- display the column with the email address? --->
<cfset a_bol_display_email_col = true />

<!--- load various CRM data ... --->
<cfinclude template="utils/inc_show_all_list_load_crm_misc.cfm">


<!--- create action popup menu for contacts menu ... --->
<cfscript>
	StartNewJSPopupMenu('a_act_popm');
	AddNewJSPopupMenuItem(GetLangValJS('adrb_wd_view'), 'javascript:DoHandleCurItemAction(\''display\'');');
	AddNewJSPopupMenuItem('-', '');
	AddNewJSPopupMenuItem(MakeFirstCharUCase(GetLangValJS('cm_wd_edit')), 'javascript:DoHandleCurItemAction(\''edit\'');');
	AddNewJSPopupMenuItem(MakeFirstCharUCase(GetLangValJS('cm_wd_delete')), 'javascript:DoHandleCurItemAction(\''delete\'');');

	//if (a_str_display_data_type NEQ 1) {
	//	AddNewJSPopupMenuItem('-', '');
	//	AddNewJSPopupMenuItem('Google Maps', 'javascript:DoHandleCurItemAction(\''googlemaps\'');');
	//	}

	AddNewJSPopupMenuToPage();
</cfscript>


<!--- display email column? --->
<cfset a_str_display_email_col = (a_str_display_data_type NEQ 1)>


<!--- CRM ... check what to display exactly ... --->
<cfswitch expression="#a_str_display_data_type#">
	<cfcase value="0">
		<!--- contacts only ... --->
		<cfinclude template="utils/dsp_inc_display_all_list_contacts.cfm">
	</cfcase>
	<cfcase value="1">
		<!--- accounts only ... --->
		<cfinclude template="utils/dsp_inc_display_all_list_accounts.cfm">
	</cfcase>
</cfswitch>
