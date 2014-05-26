<cfif NOT StructKeyExists(request, 'stSecurityContext')>
	<cfabort>
</cfif>


<cfinclude template="../utils/inc_load_imap_access_data.cfm">
<cfinclude template="../queries/q_select_all_pop3_data.cfm">
<cfinclude template="/common/scripts/script_utils.cfm">

<cfparam name="url.userkey" type="string" default="#request.stSecurityContext.myuserkey#">
<cfparam name="url.messageid" type="string" default="">
<cfparam name="url.references" type="string" default="">
<cfparam name="url.uid" type="numeric" default="0">

<cfscript>
	function NiceFromTo(s)
		{
		var i = 0;
		
		s = trim(s);
		
		if (Find('<', s) IS 0)
			{
			return ExtractEmailAdr(s);
			}
		
		i = find('<', s);
		
		s = Mid(s, 1, i-1);
		
		s = ReplaceNoCase(s, '"', '', 'ALL');
		
		return s;
		}
</cfscript>

<cfset a_str_own_addresses = ValueList(q_select_all_pop3_data.emailadr)>
<cfset a_cmp_email_tools = CreateObject('component', '/components/email/cmp_tools')>
<cfset a_cmp_loadmsg = CreateObject('component', '/components/email/cmp_loadmsg')>

<cfinvoke component="#a_cmp_email_tools#" method="GetMessageReferences" returnvariable="q_select_reference_messages">
	<cfinvokeargument name="userkey" value="#url.userkey#">
	<cfinvokeargument name="messageid" value="#url.messageid#">
	<cfinvokeargument name="references" value="#url.references#">
	<cfinvokeargument name="originaluid" value="#url.uid#">
</cfinvoke>

<cfoutput query="q_select_reference_messages">

<cfinvoke component="#a_cmp_loadmsg#" method="LoadMessage" returnvariable="a_struct_load_ref_msg">
		<cfinvokeargument name="server" value="#request.a_str_imap_host#">
		<cfinvokeargument name="username" value="#request.a_str_imap_username#">
		<cfinvokeargument name="password" value="#request.a_str_imap_password#">
		<cfinvokeargument name="foldername" value="#q_select_reference_messages.foldername#">
		<cfinvokeargument name="uid" value="#q_select_reference_messages.uid#">
		<cfinvokeargument name="tempdir" value="#request.a_str_temp_directory_local#">
</cfinvoke>

<cfset a_str_body = ''>

<cfif StructKeyExists(a_struct_load_ref_msg, 'query')>

	<cfset a_str_body = a_struct_load_ref_msg.query.body>
	
	<!--- html body? --->
	<cfif FindNoCase('<html>', a_struct_load_ref_msg.query.body) IS 1>
		<cfset a_str_body = StripHTML(a_str_body)>
		<cfset a_str_body = ReplaceNocase(a_str_body, '<br />', '', 'ALL')>
	</cfif>
	
	
	<cfif ListContainsNoCase(a_str_own_addresses, ExtractEmailAdr(a_struct_load_ref_msg.query.afrom)) GT 0>
		<!--- own account ... --->
		<cfset a_bol_own_account = true>
		<cfset a_str_from_to = htmleditformat(request.a_struct_personal_properties.myfirstname)&' '&htmleditformat(request.a_struct_personal_properties.mysurname)&' <img src="/images/next.gif" align="absmiddle" width="10" height="9" border="0" vspace="2" hspace="2"> <b>'&NiceFromTo(a_struct_load_ref_msg.query.ato)&'</b>'>
	<cfelse>
		<!--- not the own acccount ... --->
		<cfset a_bol_own_account = false>		
		<cfset a_str_from_to = '<b>'&NiceFromTo(a_struct_load_ref_msg.query.afrom)&'</b> <img src="/images/next.gif" align="absmiddle" width="10" height="9" border="0" vspace="2" hspace="2"> '&htmleditformat(request.a_struct_personal_properties.myfirstname)&' '&htmleditformat(request.a_struct_personal_properties.mysurname)>
	</cfif>
		
	<div class="b_all" style="margin:12px;width:auto;<cfif a_bol_own_account>border-left:red solid 2px;<cfelse>border-left:##004080 solid 2px;</cfif>">
	<div class="mischeader bb" style="padding:4px;">
	
	&nbsp;<a title="Nachricht jetzt anzeigen ..." target="_self" href="index.cfm?action=ShowMessage&mailbox=#urlencodedformat(q_select_reference_messages.foldername)#&id=#q_select_reference_messages.uid#">#trim(a_str_from_to)#</a></div>
	
	
	<div style="padding:6px; ">
	<cfloop list="#trim(a_str_body)#" delimiters="#chr(10)#" index="a_str_line">
		
		<cfif (Find('-----', a_str_line) IS 1) OR (Find('_____', a_str_line) IS 1) OR (Find('==========', a_str_line) IS 1)>
			<font class="addinfotext">Zitierter Teil ausgeblendet</font>
			<cfbreak>
		</cfif>

		<cfif (FindNoCase('>', a_str_line) NEQ 1) AND (Find('&gt;', a_str_line) NEQ 1) AND (Len(Trim(a_str_line)) GT 0)>
			#trim(trim(a_str_line))#<br>
		</cfif>
		
	</cfloop>
	</div>
	</div>
	</div>
</cfif>

</cfoutput>