<!--- //

	Module:		Address Book
	Action:		Telephonelist
	Description: 
	

// --->

<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="fieldlist" value="company,surname,firstname,b_telephone,b_fax,p_fax,p_telephone,email_prim,username,b_mobile,lastemailcontact,p_mobile,reupdateavaliable,categories,company,lastsmssent,archiveentry">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">	
</cfinvoke>

<cfset q_select_contacts = stReturn.q_select_contacts />

<cfquery name="q_select_contacts" dbtype="query">
SELECT
	*
FROM
	q_select_contacts
WHERE
	NOT
		(
			(b_telephone = '')
			AND
			(p_telephone = '')
			AND
			(p_mobile = '')
			AND
			(b_mobile = '')
			AND
			(p_fax = '')
			AND
			(b_fax = '')
		)
;
</cfquery>

<table border="0" cellspacing="0" cellpadding="6">
  <tr>
  	<td></td>
	<td class="mischeader bl" colspan="3">
	<cfoutput>#GetLangVal('adrb_wd_business')#</cfoutput>
	</td>
	<td colspan="3" class="bl mischeader">
	<cfoutput>#GetLangVal('adrb_wd_private')#</cfoutput>
	</td>
	<td></td>
  </tr>
  <tr class="mischeader">
    <td class="bb"><cfoutput>#GetLangVal('cm_wd_name')#</cfoutput></td>
    <td class="bb bl"><img src="/images/ico_phone.gif" align="absmiddle" vspace="2" hspace="2" border="0"> <cfoutput>#GetLangVal('adrb_wd_telephonelist_telephone')#</cfoutput></td>
    <td class="bb mischeader"><img src="/images/ico_fax.gif" align="absmiddle" vspace="2" hspace="2" border="0"> <cfoutput>#GetLangVal('adrb_wd_telephonelist_fax')#</cfoutput></td>
    <td class="bb"><img src="/images/ico_mobil.gif" align="absmiddle" vspace="2" hspace="2" border="0"> <cfoutput>#GetLangVal('adrb_wd_telephonelist_mobile')#</cfoutput></td>
    <td class="bb bl"><img src="/images/ico_phone.gif" align="absmiddle" vspace="2" hspace="2" border="0"> <cfoutput>#GetLangVal('adrb_wd_telephonelist_telephone')#</cfoutput></td>
    <td nowrap class="bb"><img src="/images/ico_fax.gif" align="absmiddle" vspace="2" hspace="2" border="0"> <cfoutput>#GetLangVal('adrb_wd_telephonelist_fax')#</cfoutput></td>
    <td class="bb"><img src="/images/ico_mobil.gif" align="absmiddle" vspace="2" hspace="2" border="0"> <cfoutput>#GetLangVal('adrb_wd_telephonelist_mobile')#</cfoutput></td>
	<td class="bb bl"><cfoutput>#GetLangVal('cm_wd_categories')#</cfoutput></td>
  </tr>
  <cfoutput query="q_select_contacts">
  <tr id="idtr#q_select_contacts.currentrow#" onMouseOver="hilite(this.id);"  onMouseOut="restore(this.id);">
    <td class="bb">
	<a href="default.cfm?action=ShowItem&entrykey=#urlencodedformat(q_select_contacts.entrykey)#"><b>#htmleditformat(checkZeroString(q_select_contacts.surname))#</b>, #q_select_contacts.firstname#</a>
	<br>
	#htmleditformat(q_select_contacts.company)#
	</td>
    <td class="bb bl">
	#q_select_contacts.b_telephone#&nbsp;
	</td>
    <td class="bb mischeader">
	#q_select_contacts.b_fax#&nbsp;
	</td>
    <td class="bb">
	#q_select_contacts.b_mobile#&nbsp;
	</td>
    <td class="bb bl">
	#q_select_contacts.p_telephone#&nbsp;
	</td>
    <td class="bb mischeader">
	#q_select_contacts.p_fax#&nbsp;
	</td>
    <td class="bb">
	#q_select_contacts.p_mobile#&nbsp;
	</td>
	<td class="bb bl">
	#shortenstring(q_select_contacts.categories, 25)#&nbsp;
	</td>	
  </tr>
  </cfoutput>
  <tr>

  <tr class="mischeader">
    <td class="bb"><cfoutput>#GetLangVal('cm_wd_name')#</cfoutput></td>
    <td class="bb bl"><img src="/images/ico_phone.gif" align="absmiddle" vspace="2" hspace="2" border="0"> <cfoutput>#GetLangVal('adrb_wd_telephonelist_telephone')#</cfoutput></td>
    <td class="bb mischeader"><img src="/images/ico_fax.gif" align="absmiddle" vspace="2" hspace="2" border="0"> <cfoutput>#GetLangVal('adrb_wd_telephonelist_fax')#</cfoutput></td>
    <td class="bb"><img src="/images/ico_mobil.gif" align="absmiddle" vspace="2" hspace="2" border="0"> <cfoutput>#GetLangVal('adrb_wd_telephonelist_mobile')#</cfoutput></td>
    <td class="bb bl"><img src="/images/ico_phone.gif" align="absmiddle" vspace="2" hspace="2" border="0"> <cfoutput>#GetLangVal('adrb_wd_telephonelist_telephone')#</cfoutput></td>
    <td nowrap class="bb"><img src="/images/ico_fax.gif" align="absmiddle" vspace="2" hspace="2" border="0"> <cfoutput>#GetLangVal('adrb_wd_telephonelist_fax')#</cfoutput></td>
    <td class="bb"><img src="/images/ico_mobil.gif" align="absmiddle" vspace="2" hspace="2" border="0"> <cfoutput>#GetLangVal('adrb_wd_telephonelist_mobile')#</cfoutput></td>
	<td class="bb bl"><cfoutput>#GetLangVal('cm_wd_categories')#</cfoutput></td>
  </tr>
  
   <tr>
  	<td></td>
	<td class="mischeader bl" colspan="3">
	<cfoutput>#GetLangVal('adrb_wd_business')#</cfoutput>
	</td>
	<td colspan="3" class="bl mischeader">
	<cfoutput>#GetLangVal('adrb_wd_private')#</cfoutput>
	</td>
	<td></td>
  </tr>
</table>


