<!--- //

	Module:		E-Mail
	Description:MultiEdit
	

	
	
	what to do now?
	
	
	IMPORTANT:
	
	we have to check the folder name of the message ...
	these fucking UIDs are unique for each folder!
	
	
	example:
	
	12_INBOX,1237_INBOX,345_Inbox.Trash
	
// --->

<cfinclude template="../login/check_logged_in.cfm">
	
<cfparam name="form.frmid" default="0" type="string">
<!--- new status ... --->
<cfparam name="form.frmnewstatus" default="read" type="string">
<!--- read / unread --->
<cfparam name="form.frmnewstatus" default="unread" type="string">
<!--- redirect target ... --->
<cfparam name="form.frmredirect" type="string" default="#cgi.http_referer#">

<cfif (len(form.frmid) is 0) OR (form.frmid is "0")>
	<!--- no message have been selected --->
	<cflocation addtoken="no" url="#form.frmredirect#">
</cfif>

<cfinclude template="utils/inc_load_imap_access_data.cfm">

<!--- create a virtual query with all entries .... --->
<cfset q_select_items = QueryNew("id,foldername", 'Integer,VarChar')>

<cfloop list="#form.frmid#" delimiters="," index="a_str_single_id">

	<!--- parse in id,foldername --->
	<cfset a_int_pos = FindNoCase("_", a_str_single_id) />
	
	<!--- the id ... --->
	<cfset a_int_id = Mid(a_str_single_id, 1, a_int_pos -1) />
	
	<!--- the foldername ... --->
	<cfset a_str_foldername = Mid(a_str_single_id, a_int_pos+1, len(a_str_single_id)) />
	
	<!--- insert new record ... --->
	<cfset tmp = QueryAddRow(q_select_items, 1) />
	
	<!--- set data --->
	<cfset tmp = QuerySetCell(q_select_items, "id", a_int_id, q_select_items.recordcount)>
	<cfset tmp = QuerySetCell(q_select_items, "foldername", a_str_foldername, q_select_items.recordcount)>

</cfloop>

<!--- // select the unique folder names ... --->
<cfquery name="q_select_unique_foldernames" dbtype="query">
SELECT
	DISTINCT(foldername)
FROM
	q_select_items
;
</cfquery>

<cfset a_str_action = "none" />

<!--- check which action is desired ... --->
<cfif IsDefined("form.frmSubmitChangeReadStatus1")>
	<cfset a_str_action = "changestatus" />
	<cfset a_str_newstatus = form.frmnewstatus1 />
</cfif>

<cfif IsDefined("form.frmSubmitChangeReadStatus2")>
	<cfset a_str_action = "changestatus" />
	<cfset a_str_newstatus = form.frmnewstatus2 />
</cfif>

<cfif IsDefined("form.frmSubmitMove1")>
	<cfset a_str_action = "move" />
	<cfset a_str_dest_folder = form.frmdestinationfolder1 />
</cfif>

<cfif IsDefined("form.frmSubmitMove2")>
	<cfset a_str_action = "move" />
	<cfset a_str_dest_folder = form.frmdestinationfolder2 />
</cfif>

<cfif IsDefined("form.frmSubmitDelete")>
	<cfset a_str_Action = "delete" />
</cfif>


<cfswitch expression="#a_str_action#">
	<cfcase value="changestatus">
	
	<cfoutput query="q_select_unique_foldernames">
		
		<cfquery name="q_select_folder_items" dbtype="query">
		SELECT
			id
		FROM
			q_select_items
		WHERE
			foldername = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_unique_foldernames.foldername#">
		ORDER by
			id
		;
		</cfquery>
		
		<cfset a_str_uids = ValueList(q_select_folder_items.id) />
		
		<cfif a_str_newstatus is "unread">
			<cfset a_int_new_status = 20 />
		<cfelseif a_str_newstatus is "flag">
			<cfset a_int_new_status = 3 />
		<cfelse>
			<cfset a_int_new_status = 2 />
		</cfif>
		
		<!--- edit status for this msg --->
		<cfinvoke component="/components/email/cmp_tools" method="setmessagestatus" returnvariable="a_struct_result">
			<cfinvokeargument name="server" value="#request.a_str_imap_host#">
			<cfinvokeargument name="username" value="#request.a_str_imap_username#">
			<cfinvokeargument name="password" value="#request.a_str_imap_password#">
			<cfinvokeargument name="foldername" value="#q_select_unique_foldernames.foldername#">
			<cfinvokeargument name="uid" value="#a_str_uids#">
			<cfinvokeargument name="status" value="#a_int_new_status#">
		</cfinvoke>
		
	</cfoutput>
	
	<cflocation addtoken="no" url="#form.frmredirect#">
	
	</cfcase>
	
	<cfcase value="move">
	<!--- // move the selected messages	// --->
	
	<cfoutput query="q_select_unique_foldernames">
		
		<cfquery name="q_select_folder_items" dbtype="query">
		SELECT id FROM q_select_items
		WHERE foldername = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_unique_foldernames.foldername#">
		ORDER by id;
		</cfquery>
		
		<cfset a_str_uids = ValueList(q_select_folder_items.id) />
	
		<!--- move to trash ... --->
		<cfinvoke component="/components/email/cmp_tools" method="moveorcopymessage" returnvariable="a_struct_result">
			<cfinvokeargument name="server" value="#request.a_str_imap_host#">
			<cfinvokeargument name="username" value="#request.a_str_imap_username#">
			<cfinvokeargument name="password" value="#request.a_str_imap_password#">
			<cfinvokeargument name="uid" value="#a_str_uids#">
			<cfinvokeargument name="sourcefolder" value="#q_select_unique_foldernames.foldername#">
			<cfinvokeargument name="destinationfolder" value="#a_str_dest_folder#">
			<cfinvokeargument name="copymode" value="false">		
		</cfinvoke>
		
	</cfoutput>
	
	<cflocation addtoken="no" url="#form.frmredirect#">
	</cfcase>
	
	<cfcase value="delete">
	<!--- // delete the selected messages // --->
		
		<cfoutput query="q_select_unique_foldernames">

		<cfquery name="q_select_folder_items" dbtype="query">
		SELECT
			id
		FROM
			q_select_items
		WHERE
			(foldername = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_unique_foldernames.foldername#">)
		ORDER BY
			id
		;
		</cfquery>
		
		<cfset a_str_uids = ValueList(q_select_folder_items.id) />
		
		
			<cfif CompareNoCase(q_select_unique_foldernames.foldername, "INBOX.Trash") is 0>
				<!--- we are in the "trash" folder ... delete messages really now --->
				<cfinvoke component="#application.components.cmp_email#" method="deletemessages" returnvariable="a_struct_result">
					<cfinvokeargument name="server" value="#request.a_str_imap_host#">
					<cfinvokeargument name="username" value="#request.a_str_imap_username#">
					<cfinvokeargument name="password" value="#request.a_str_imap_password#">
					<cfinvokeargument name="foldername" value="#q_select_unique_foldernames.foldername#">
					<cfinvokeargument name="uids" value="#a_str_uids#">
				</cfinvoke>		
				
			<cfelse>
				<!--- move to trash ... --->
				<cfinvoke component="/components/email/cmp_tools" method="moveorcopymessage" returnvariable="a_struct_result">
					<cfinvokeargument name="server" value="#request.a_str_imap_host#">
					<cfinvokeargument name="username" value="#request.a_str_imap_username#">
					<cfinvokeargument name="password" value="#request.a_str_imap_password#">
					<cfinvokeargument name="uid" value="#a_str_uids#">
					<cfinvokeargument name="sourcefolder" value="#q_select_unique_foldernames.foldername#">
					<cfinvokeargument name="destinationfolder" value="INBOX.Trash">
					<cfinvokeargument name="copymode" value="false">		
				</cfinvoke>
			</cfif>
			
		</cfoutput>
		
		<cflocation addtoken="no" url="#form.frmredirect#&nocache=1">

	</cfcase>

	<cfdefaultcase>
	<!--- no known action ... forward to default --->
	<cflocation addtoken="no" url="#ReturnRedirectURL()#">
	</cfdefaultcase>
</cfswitch>


