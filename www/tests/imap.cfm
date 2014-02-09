<cfset a_cmp = createObject( 'component', request.a_str_component_mailconnector ) />

<!--- <cfset a_folders = a_cmp.GetAllFolders( server = 'imap.gmail.com', username = 'hp@openTeamware.com', password = 'fiatlux', port = 993, useSSL = true ) />

<cfdump var="#a_folders#">
--->

<cfset a_var_store = a_cmp.ConnectToIMAPAccountAndReturnStore( server = 'imap.gmail.com', username = 'hp@openTeamware.com', password = 'fiatlux', port = 993, useSSL = true ) />

<!--- <cfdump var="#a_folder#"> --->

<cfset a_folder = a_cmp.ListMessages( server = 'imap.gmail.com', username = 'hp@openTeamware.com', password = 'fiatlux', port = 993, useSSL = true, foldername =  'INBOX') />

<!--- <cfdump var="#a_folder#"> --->