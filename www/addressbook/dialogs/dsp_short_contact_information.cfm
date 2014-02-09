<!--- //

	Service:	Address Book
	Action:		DisplayShortContactInformation
	Description:Display short contact information (e.g. in email service)
	
	Header:	

// --->

<cfparam name="url.entrykey" type="string" default="">

<!--- load contact ... --->
<cfinvoke component="#application.components.cmp_addressbook#" method="GetContact" returnvariable="stReturn">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>

<cfif NOT stReturn.result>
	<cfexit method="exittemplate">
</cfif>

<cfset q_select_contact = stReturn.q_select_contact />

<cfset a_bol_br_needed = false />

<cfsavecontent variable="a_str_info">

<cfoutput query="q_select_contact">
	
	<cfif Len(q_select_contact.company) GT 0>
		#htmleditformat(q_select_contact.company)#
		<cfset a_bol_br_needed = true />
	</cfif>
	
	<cfif Len(q_select_contact.department) GT 0>
		(#htmleditformat(q_select_contact.department)#)
		<cfset a_bol_br_needed = true />
	</cfif>
	
	<cfif Len(q_select_contact.aposition) GT 0>
		#GetLangVal('adrb_wd_position')#: #htmleditformat(q_select_contact.aposition)#
		<cfset a_bol_br_needed = true />
	</cfif>
	
	<cfif Len(q_select_contact.b_zipcode) GT 0 OR Len(q_select_contact.b_city) GT 0>
		<cfif a_bol_br_needed><br /></cfif>
		#htmleditformat(q_select_contact.b_zipcode)# #htmleditformat(q_select_contact.b_city)# #htmleditformat(q_select_contact.b_street)#
	</cfif>
	
	<cfif Len(q_select_contact.b_telephone) GT 0>
		<cfif a_bol_br_needed>&nbsp;&nbsp;&nbsp;</cfif>
		T: #htmleditformat(q_select_contact.b_telephone)#
	</cfif>
	
</cfoutput>	

</cfsavecontent>

<cfset a_str_info = trim(a_str_info) />

<cfif Len(a_str_info) IS 0>
	<cfexit method="exittemplate">
</cfif>

<cfoutput><a target="_top" href="/addressbook/?action=ShowItem&entrykey=#url.entrykey#" target="_top">#Trim(a_str_info)#</a></cfoutput>


