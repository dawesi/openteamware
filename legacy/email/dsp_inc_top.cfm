<cfparam name="url.userkey" type="string" default="#request.stSecurityContext.myuserkey#">

<cfif ListFindNoCase('ShowMailbox,ShowMailboxContent', url.action) IS 0>
<!---</cfif> url.action NEQ 'ShowMailbox'>--->
	<cfoutput>#CreateDefaultTopHeader(GetLangVal('cm_wd_email'))#</cfoutput>

	<cfexit method="exittemplate">
</cfif>

<table class="tablemaincontenttop">
  <tr>
  	<td style="width:60px;">
		<img src="/images/space_1_1.gif" alt=""/>
	</td>
  	<cfif Compare(url.userkey, request.stSecurityContext.myuserkey) NEQ 0>
	
		<cfinvoke component="#application.components.cmp_user#" method="GetUsernamebyentrykey" returnvariable="a_str_username">
			<cfinvokeargument name="entrykey" value="#url.userkey#">
		</cfinvoke>
		<td>
			<a href="index.cfm?action=displayusermailbox&userkey=<cfoutput>#url.userkey#</cfoutput>" class="TopHeaderLink" style="font-weight:bold; "><img src="/images/img_person_small.gif" align="absmiddle" border="0"> <cfoutput>#a_str_username#</cfoutput></a>
		</td>
		<td class="tdtopheaderdivider">|</td>
	</cfif>
    <td nowrap>
		<a class="TopHeaderLink"  href="#" title="<cfoutput>#GetLangVal('mail_ph_top_new_message_hint')#</cfoutput>" onClick="OpenComposePopup();return false;"><cfoutput>#GetLangVal('mail_ph_top_new_message')#</cfoutput></a>
	</td>
	<td class="tdtopheaderdivider">|</td>	
    <td>
		<cfif StructKeyExists(url, 'mailbox')>
			<cfset a_str_mbox_link = '&mailbox='&urlencodedformat(url.mailbox)>
		<cfelse>	
			<cfset a_str_mbox_link = ''>
		</cfif>
		
		
		<a target="_self" class="TopHeaderLink" href="index.cfm?action=showsearch<cfoutput>#a_str_mbox_link#</cfoutput>"><cfoutput>#GetLangVal('mail_ph_top_search')#</cfoutput></a>
	</td>	
	<td class="tdtopheaderdivider">|</td>	
    <td>
		<a target="_self" id="idlinkopenfolders" class="TopHeaderLink" href="javascript:OpenFoldersPopup();"><cfoutput>#GetLangVal('mail_wd_folders')#</cfoutput></a>
	</td>	
	<td class="tdtopheaderdivider">|</td>
    <td>
		<a target="_self" class="TopHeaderLink" href="index.cfm?action=extras"><cfoutput>#GetLangVal('mail_wd_extras')#</cfoutput></a>
	</td>

	<!---<cfif ListFindNocase('ShowMailbox,ShowMailboxContent', url.action) GT 0>
	<td class="tdtopheaderdivider">|</td>	
		<td class="TopHeaderLink">
			<cfoutput>#GetLangVal('cm_wd_view')#</cfoutput>: <a target="_self" class="TopHeaderLink" href="index.cfm?action=showmailbox&mailbox=<cfoutput>#url.mailbox#</cfoutput>&style=cols<cfoutput>#AddUserkeyToURL()#</cfoutput>"><cfoutput>#GetLangVal('mail_wd_top_link_columns')#</cfoutput></a> / <a target="_self" class="TopHeaderLink" href="index.cfm?action=showmailbox&mailbox=<cfoutput>#url.mailbox#</cfoutput>&style=rows<cfoutput>#AddUserkeyToURL()#</cfoutput>"><cfoutput>#GetLangVal('mail_wd_top_link_rows')#</cfoutput></a>
		</td>
	</cfif>--->
	
	<td class="tdtopheaderdivider">|</td>
    <td>
		<a target="_self" href="/settings/?action=emailaccounts" class="TopHeaderLink"><cfoutput>#GetLangVal('mail_ph_top_link_email_accounts')#</cfoutput></a>
	</td>	
  </tr>
</table>