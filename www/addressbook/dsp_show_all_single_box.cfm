<!--- // show contacts in a boxed version - like Outlook // --->



<table height="70" width="98%" border="0" cellspacing="0" cellpadding="4"  style="margin:5px;" class="b_all">

<tr>

	<td class="mischeader" height="17">

	<a href="index.cfm?action=ShowItem&entrykey=<cfoutput>#q_select_contacts.entrykey#</cfoutput>" style="font-weight:bold;"><cfoutput>#checkzerostring(q_select_contacts.Surname)#</a>, #htmleditformat(q_select_contacts.Firstname)#</cfoutput>

	</td>

</tr>

<tr>

	<td onMouseOver="hilite(this.id);"  onMouseOut="restore(this.id);" ID="idtd<cfoutput>#q_select_contacts.currentrow#</cfoutput>">

	<cfif len(q_select_contacts.Company) gt 0>

	<cfoutput>#q_select_contacts.Company#</cfoutput><br>

	</cfif>

	

	<cfif Len(q_select_contacts.b_telephone) gt 0>

	<cfoutput>#q_select_contacts.b_telephone#</cfoutput>

	<cfelseif len(q_select_contacts.b_mobile) gt 0>

	<cfoutput>#q_select_contacts.b_mobile#</cfoutput>

	</cfif>

	

	<cfif len(q_select_contacts.Email_prim) gt 0>

	<br><cfoutput><a href="javascript:OpenComposePopupTo('#jsstringformat(q_select_contacts.Email_prim)#');">#htmleditformat(shortenstring(q_select_contacts.Email_prim, 30))#</a></cfoutput>	

	</cfif>

	</td>

</tr>

</table>

