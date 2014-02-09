<!--- //

	Module:		EMail
	Action:		DoSearchContent
	Description: 
	

// --->

<cfparam name="url.search" type="string" default="">
<cfparam name="url.mailbox" type="string" default="">
<cfparam name="url.account" type="string" default="#request.stSecurityContext.myusername#">
<cfparam name="url.style" type="string" default="cols">
<cfparam name="url.attachments" type="numeric" default="0">
<cfparam name="url.isflagged" type="numeric" default="0">
<cfparam name="url.frmage" type="numeric" default="0">
<cfparam name="url.fulltextsearch" type="numeric" default="0">

<!--- full text search? --->
<cfset a_bol_fulltext = (url.fulltextsearch IS 1) />

<!--- mails per page ... --->
<cfset a_int_mails_per_page = GetUserPrefPerson('email', 'emailsperpage', '50', '', false) />
<!--- the new query string variable ... --->
<cfset a_str_md5_query_string = Hash(cgi.QUERY_STRING) />

	
<cfinclude template="queries/q_select_all_pop3_data.cfm">
<cfset a_struct_markcolors = StructNew() />
<cfoutput query="q_select_all_pop3_data">
	<cfset a_struct_markcolors[q_select_all_pop3_data.pop3server] = q_select_all_pop3_data.markcolor />
</cfoutput>

<cfset request.a_str_link_current_target = 'frameemailmessage' />

<cfif len(trim(url.search)) lte 2>
	<cfoutput>#GetLangVal('mail_ph_search_min_3_chars')#</cfoutput>
	<br />
	<a href="javascript:history.go(-1);"><cfoutput>#GetLangVal('cm_wd_back')#</cfoutput></a>
	<cfexit method="exittemplate">
</cfif>

<div style="padding:4px;" class="mischeader bb">
		<cfoutput>#si_img('magnifier')#</cfoutput>
		<a target="_self" href="<cfoutput>#cgi.SCRIPT_NAME#?#cgi.QUERY_STRING#</cfoutput>&nocache=1"><img src="/images/calendar/recur.png" alt="<cfoutput>#GetLangVal('mail_wd_reload')#</cfoutput>" width="13" height="13" hspace="2" vspace="2" border="0" align="right"></a>
		<b><cfoutput>#GetLangVal('mail_ph_searchfor')#</cfoutput>: <cfoutput>#htmleditformat(url.search)#</cfoutput></b>

</div>
<!--- 
<div id="idwait" align="center">
	<br /><br /><br /><br /><br />
	<div  align="center" style="padding:20px;width:90%;" class="mischeader b_all">
	<cfoutput>#GetLangVal('mail_ph_search_is_executed')#</cfoutput><br />
	<br />
	<img src="/images/Wait.gif" width="78" height="22" hspace="0" vspace="0">
	<br /><br />
	</div>
</div> --->

<cfif len(url.mailbox) is 0>
	<cfset a_int_recursive = 1>
<cfelse>
	<cfset a_int_recursive = 0>
</cfif>


<cfinvoke component="#application.components.cmp_email_tools#"
	method="search"
	returnvariable="a_return_struct">
	<cfinvokeargument name="server" value="#request.a_str_imap_host#">
	<cfinvokeargument name="username" value="#request.a_str_imap_username#">
	<cfinvokeargument name="password" value="#request.a_str_imap_password#">
	<cfinvokeargument name="foldername" value="#url.mailbox#">
	<cfinvokeargument name="beautifyfromto" value="true">
	<cfinvokeargument name="searchstring" value="#url.search#">
	<cfinvokeargument name="loadpreview" value="0">
	<cfinvokeargument name="recursive" value="#a_int_recursive#">
	<cfinvokeargument name="fulltextsearch" value="#a_bol_fulltext#">
</cfinvoke>
	
<cfset q_select_mailbox = a_return_struct["query"]>

<cfset tmp = QueryAddColumn(q_select_mailbox, 'afromemailaddressonly', ArrayNew(1)) />

<cfif url.attachments IS 1>
	<cfquery name="q_select_mailbox" dbtype="query">
	SELECT
		*
	FROM
		q_select_mailbox
	WHERE
		attachments > 0
	;
	</cfquery>
</cfif>

<cfif url.isflagged IS 1>
	<cfquery name="q_select_mailbox" dbtype="query">
	SELECT
		*
	FROM
		q_select_mailbox
	WHERE
		flagged = 1
	;
	</cfquery>
</cfif>

<cfif url.age GT 0>
	<cfquery name="q_select_mailbox" dbtype="query">
	SELECT
		*
	FROM
		q_select_mailbox
	WHERE
		date_local > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', -url.age, Now())#">
	;
	</cfquery>
</cfif>


<cfset tmp = QueryAddColumn(q_select_mailbox, 'prim_key', ArrayNew(1))>
<cfloop query="q_select_mailbox">
	<cfset tmp = QuerySetCell(q_select_mailbox, 'prim_key', q_select_mailbox.id&'_'&q_select_mailbox.foldername, q_select_mailbox.currentrow)>
</cfloop>

<!--- check restrictions ... --->
<cfinclude template="utils/inc_select_mbox_display_restriction.cfm">

<cfquery name="q_select_mailbox" dbtype="query">
SELECT
	*
FROM
	q_select_mailbox
ORDER BY
	id DESC
;
</cfquery>


<cfif CompareNoCase(url.style, 'rows') IS 0>
	<cfinclude template="dsp_inc_show_mailbox_rows.cfm">
<cfelse>
	<cfinclude template="dsp_inc_show_mailbox_cols.cfm">
</cfif>

<script type="text/javascript">
	var obj1;
	// display the content
	DisplayMailboxContent();
	<cfif q_select_mailbox.recordcount GT 0>
	obj1 = findObj('idhref1');
	if (parent.frameemailmessage.location.href.search('id') == -1)
		{
		
		parent.frameemailmessage.location.href = obj1.href;
		}
	</cfif>
</script>


