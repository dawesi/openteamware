<!--- //



	create a folder

	

	// --->
<cfinclude template="../login/check_logged_in.cfm">
<cfinclude template="/common/scripts/script_utils.cfm">

<cfinclude template="utils/inc_load_imap_access_data.cfm">
<cfinclude template="utils/inc_load_folders.cfm">

<cfparam name="form.frmFoldername" type="string" default="">
<cfparam name="form.frmparentfolder" type="string" default="INBOX">

<cfif len(trim(form.frmFoldername)) is 0>
	<!--- zero? --->
	<cflocation addtoken="no" url="index.cfm?action=newfolder&error=noinput">	
</cfif>

<cfif FindNoCase(".", form.frmfoldername) gt 0>
	<!--- zero? --->
	<cflocation addtoken="no" url="index.cfm?action=newfolder&error=pointinname">	
</cfif>

<cfif CompareNoCase('INBOX', form.frmfoldername) IS 0>
	<!--- zero? --->
	<cflocation addtoken="no" url="index.cfm?action=newfolder&error=NameNotAllowed(INBOX)">	
</cfif>

<!--- a) check if such a folder already exists --->
<cfquery name="q_select_folder_exists" dbtype="query">
SELECT
	foldername
FROM
	request.q_select_folders
WHERE
	fullfoldername = <cfqueryparam cfsqltype="cf_sql_varchar" value="INBOX.#form.frmFoldername#">
;
</cfquery>

<cfif q_select_folder_exists.recordcount gt 0>
	<!--- exists ... --->
	<cflocation addtoken="no" url="index.cfm?action=newfolder&error=folderalreadyexists">
</cfif>

<!--- create folder --->
<cfinvoke component="/components/email/cmp_tools"
		method="createfolder"
		returnvariable="sReturn">
		<cfinvokeargument name="server" value="#request.a_str_imap_host#">
		<cfinvokeargument name="username" value="#request.a_str_imap_username#">
		<cfinvokeargument name="password" value="#request.a_str_imap_password#">
		<cfinvokeargument name="foldername" value="#trim(form.frmfoldername)#">
		<cfinvokeargument name="fullparentfoldername" value="#form.frmparentfolder#">
</cfinvoke>

<!--- force reload of folder structure ... --->
<cflock scope="session" timeout="3" type="exclusive">
	<cfset session.a_int_loadfolders_hitcount = 5>
</cflock>
		
<cflocation addtoken="no" url="index.cfm?action=overview">