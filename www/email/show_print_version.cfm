<!--- // druckversion einer datei anzeigen // --->



<cfinclude template="../login/check_logged_in.cfm">

<cfinclude template="../common/scripts/script_utils.cfm">



<cfparam name="url.folder" default="" type="string">

<cfparam name="url.account" default="#request.stSecurityContext.myusername#" type="string">

<cfparam name="url.id" type="numeric" default="0">





<cfinclude template="utils/inc_load_imap_access_data.cfm">





<cfinvoke component="/components/email/cmp_loadmsg" method="LoadMessage" returnvariable="stReturn">

	<cfinvokeargument name="server" value="#request.a_str_imap_host#">

	<cfinvokeargument name="username" value="#request.a_str_imap_username#">

	<cfinvokeargument name="password" value="#request.a_str_imap_password#">

	<cfinvokeargument name="foldername" value="#url.folder#">

	<cfinvokeargument name="uid" value="#url.id#">

	<cfinvokeargument name="savecontenttypes" value="image/jpeg">

	<cfinvokeargument name="tempdir" value="#request.a_str_temp_directory#">

</cfinvoke>


<cfif StructKeyExists(stReturn, 'query') IS FALSE>
	Message not found
	<cfexit method="exittemplate">
</cfif>



<cfset q_msg = stReturn["query"]>

<cfset q_attachments = stReturn["attachments_query"]>



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>

<head>

	<title><cfoutput>#htmleditformat(q_msg.subject)#</cfoutput></title>

<style>

	body,p,none,td,div{font-family:"Lucida Grande",Verdana;font-size:11px;}

</style>

<body onLoad="window.print();">





<h4><b><cfoutput>#htmleditformat(checkzerostring(q_msg.subject))#</cfoutput></b></h4>

<hr size="1" noshade />

<table border="0" cellspacing="0" cellpadding="2">

  <tr>

    <td align="right"><cfoutput>#GetLangVal('mail_wd_from')#</cfoutput>:</td>

    <td><cfoutput>#htmleditformat(q_msg.afrom)#</cfoutput></td>

  </tr>

  <tr>

    <td align="right"><cfoutput>#GetLangVal('mail_wd_to')#</cfoutput>:</td>

    <td><cfoutput>#htmleditformat(q_msg.ato)#</cfoutput></td>

  </tr>

  <tr>

    <td align="right"><cfoutput>#GetLangVal('mail_wd_date')#</cfoutput>:</td>

    <td><cfoutput>#dateformat(q_msg.date_local, "dd.mm.yyyy")# #TimeFormat(q_msg.date_local, "HH:mm")#</cfoutput></td>

  </tr>

  <tr>

    <td align="right"><cfoutput>#GetLangVal('mail_wd_size')#</cfoutput>:</td>

    <td><cfoutput>#ceiling(q_msg.asize/1000)#</cfoutput> kB</td>

  </tr>

</table>

<hr size="1" noshade />

<!--- body --->

<cfloop list="#q_msg.body#" delimiters="#chr(10)#" index="a_str_line">

<cfoutput>#a_str_line#</cfoutput><br />

</cfloop>

<cfquery name="q_attachments" dbtype="query">

SELECT * FROM q_attachments

WHERE filenamelen > 0;

</cfquery>



<!--- attachments? ---->

<cfif q_attachments.recordcount gt 0>

<hr size="1" noshade>

<b><cfoutput>#q_attachments.recordcount#</cfoutput> Dateianh&auml;nge</b>

<table width="100%" border="0" cellspacing="0" cellpadding="4">

  <tr>

    <td><cfoutput>#GetLangVal('mail_wd_compose_filename')#</cfoutput></td>

    <td><cfoutput>#GetLangVal('mail_wd_compose_filetype')#</cfoutput></td>

    <td><cfoutput>#GetLangVal('mail_wd_size')#</cfoutput></td>

  </tr>

<cfoutput query="q_attachments">

  <tr>

    <td>#q_attachments.afilename#</td>

    <td>#q_attachments.contenttype#</td>

    <td>#q_attachments.asize#</td>

  </tr>

</cfoutput>

</table>

</cfif>

</body>

</html>

