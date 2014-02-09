<cfcontent type="text/javascript">

<!--- //

	do a search and output in js (for quicker loading)
	
	// --->
<cfinclude template="../utils/inc_load_imap_access_data.cfm">

<cfinvoke component="/components/email/cmp_tools"
	method="search"
	returnvariable="a_return_struct">
	<cfinvokeargument name="server" value="#request.a_str_imap_host#">
	<cfinvokeargument name="username" value="#request.a_str_imap_username#">
	<cfinvokeargument name="password" value="#request.a_str_imap_password#">
	<cfinvokeargument name="beautifyfromto" value="true">
	<cfinvokeargument name="searchstring" value="#url.search#">
	<cfinvokeargument name="loadpreview" value="0">
</cfinvoke>

<cfset q_select_mailbox = a_return_struct["query"]>


<cfoutput query="q_select_mailbox">
document.write('#jsstringformat(q_select_mailbox.subject)# #jsstringformat(dateformat(q_select_mailbox.date_local, "ddd, dd.mm.yy")#<br>');
<!---document.write('test<a href="email/default.cfm?action=ShowMessage&id=#q_select_mailbox.id#&mailbox=#urlencodedformat(q_select_mailbox.mailbox)" class="simplelink">#jsstringformat(q_select_mailbox.subject)# #jsstringformat(dateformat(q_select_mailbox.date_local, "ddd, dd.mm.yy")#</a><br>');--->
</cfoutput>