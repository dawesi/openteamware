<!--- //

	execute a search operation

	// --->

<cfparam name="url.search" type="string" default="">
<cfparam name="url.mailbox" type="string" default="">
<cfparam name="url.account" type="string" default="#request.stSecurityContext.myusername#">

<!--- load access data --->
<cfinclude template="utils/inc_load_imap_access_data.cfm">

<cfset a_str_header = GetLangVal('mail_ph_search_header')>
<cfset a_str_header = ReplaceNoCase(a_str_header, '%TERM%', url.search)>

<cfset tmp = SetHeaderTopInfoString(a_str_header) />


<cfif len(trim(url.search)) lte 2>

<cfoutput>#GetLangVal('mail_ph_search_error_at_least_3_chars')#</cfoutput>

<br />

<a href="javascript:history.go(-1);"><cfoutput>#GetLangVal('cm_wd_back')#</cfoutput></a>

<cfexit method="exittemplate">

</cfif>



<cfif len(url.mailbox) is 0>

	<cfset a_int_recursive = 1>

<cfelse>

	<cfset a_int_recursive = 0>

</cfif>



<script type="text/javascript">

	function AllMessages() 

	 { 

	   for(var x=0;x<document.mboxform.elements.length;x++) 

	     { var y=document.mboxform.elements[x]; 

	       if(y.name!='frmcbselectall') y.checked=document.mboxform.frmcbselectall.checked; 

	     }

	 }

</script>





<cfinvoke component="/components/email/cmp_tools"

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

</cfinvoke>

	

<cfset q_select_mailbox = a_return_struct.query>

<cfset a_str_msg = GetLangVal('mail_ph_search_result')>

<cfset a_str_msg = ReplaceNoCase(a_str_msg, '%SEARCHTERM%', url.search)>
<cfset a_str_msg = ReplaceNoCase(a_str_msg, '%HITS%', q_select_mailbox.recordcount)>

<img src="/images/img_seach_loupe.png" border="0" align="absmiddle" width="32" height="32" vspace="4" hspace="4"><b><cfoutput>#a_str_msg#</cfoutput></b>


<br /><br />
<a href="index.cfm?action=ShowSearch"><cfoutput>#GetLangVal('mail_ph_search_start_new_search')#</cfoutput></a>
<br /><br />


<!--- set search operation ... this is neccessary so that certain properties are display --->

<cfset a_str_display_action = "search">

<cfinclude template="dsp_inc_mailbox_view.cfm">