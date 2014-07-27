<!--- //

	Module:		Backup history
	Action:		
	Description:	
	

	
	
	Load all entrykeys of address book items and store history
	
// --->

<cfset a_str_list_history_item_entrykeys = 'doesnotexist' />

<!--- add account / contact entrykeys --->
<cfset a_str_list_history_item_entrykeys = ListAppend(a_str_list_history_item_entrykeys, ValueList(q_select_accounts.entrykey)) />
<cfset a_str_list_history_item_entrykeys = ListAppend(a_str_list_history_item_entrykeys, ValueList(q_select_contacts.entrykey)) />

<!--- load data --->
<cfset a_struct_history = application.components.cmp_crmsales.GetHistoryItemsOfContact(securitycontext = variables.stSecurityContext,
									usersettings = variables.stUserSettings,
									servicekey = '52227624-9DAA-05E9-0892A27198268072',
									objectkeys = a_str_list_history_item_entrykeys) />
									
<cfset q_select_history_items = a_struct_history.q_select_history_items />

<cfset LogMessage('history items: ' & q_select_history_items.recordcount) />

<!--- generate CSV --->
<cfset a_csv_history = QueryToCSV2(q_select_history_items) />

<cfset a_str_backup_dir = a_str_backup_directory & request.a_str_dir_separator & 'history' />

<!--- create the email directory --->
<cfdirectory action="create" directory="#a_str_backup_dir#">

<cffile action="write" addnewline="no" charset="utf-8" file="#a_str_backup_dir#/history.csv" output="#a_csv_history#">

