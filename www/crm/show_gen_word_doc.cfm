<!--- key of contact --->
<cfparam name="url.contactkey" type="string">

<!--- key of the storage ... --->
<cfparam name="url.filekey" type="string">

<cfinclude template="../login/check_logged_in.cfm">

<cfinvoke component="#application.components.cmp_addressbook#" method="GetContact" returnvariable="stReturn">
	<cfinvokeargument name="entrykey" value="#url.contactkey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="includecrmdata" value="true">
</cfinvoke>

<cfset q_select_contact = stReturn.q_select_contact>

<cfset a_str_address = q_select_contact.company & '\par' & q_select_contact.surname & '\par' & q_select_contact.firstname & '\par' & q_select_contact.b_street & '\par' & q_select_contact.b_zipcode & ' ' & q_select_contact.b_city & '\par' & q_select_contact.b_country>

<cffile action="read" file="/mnt/www-source/www.openTeamWare.com/tests/word.rtf" variable="a_str_var">

<cfset a_str_var = ReplaceNoCase(a_str_var, '%ADRESSE%', a_str_address, 'ALL')>
<cfset a_str_var = ReplaceNoCase(a_str_var, '%DATUM%', LSDateFormat(Now(), 'dd. mmmm yyyy'), 'ALL')>

<cfif q_select_contact.sex IS 0>
	<cfset a_str_anrede = 'Herr'>
<cfelse>
	<cfset a_str_anrede = 'Frau'>
</cfif>

<cfset a_str_anrede = a_str_anrede & ' ' & q_select_contact.surname>

<cfset a_str_var = ReplaceNoCase(a_str_var, '%ANREDE%', a_str_anrede, 'ALL')>
<cfset a_str_var = ReplaceNoCase(a_str_var, '%COMMENT%', 'Dynamisch generiert um ' & TimeFormat(Now(), 'HH:mm'), 'ALL')>

<!--- save tmp file --->
<cffile action="write" addnewline="no" file="/tmp/test.rtf" charset="utf-8" output="#a_str_var#">

<cfheader name="Content-disposition" value="attachment;filename=""test.rtf""">
<cfcontent deletefile="no" file="/tmp/test.rtf" type="application/msword">
