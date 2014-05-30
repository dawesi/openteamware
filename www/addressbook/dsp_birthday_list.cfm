<!--- //

	Module:		Address Book
	Action:		Birthdaylist
	Description: 
	

// --->

<cfparam name="url.timeframe" type="numeric" default="0">

<cfset a_struct_loadoptions = StructNew()>
<cfset a_struct_loadoptions.maxrows = 0>

<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">	
	<cfinvokeargument name="loadoptions" value="#a_struct_loadoptions#">
	<cfinvokeargument name="fieldlist" value="company,surname,firstname,b_telephone,p_telephone,email_prim,username,b_mobile,lastemailcontact,p_mobile,reupdateavaliable,categories,company,lastsmssent,archiveentry">
</cfinvoke>

<cfset q_select_contacts = stReturn.q_select_contacts />

<cfquery name="q_select_contacts" dbtype="query">
SELECT
	firstname,surname,email_prim,entrykey,company,birthday,categories
FROM
	q_select_contacts
WHERE
	(q_select_contacts.birthday IS NOT NULL)
	AND NOT
	(q_select_contacts.birthday = '')
;
</cfquery>

<cfset tmp = QueryAddColumn(q_select_contacts, 'birthdayindays', ArrayNew(1)) />
<cfset tmp = QueryAddColumn(q_select_contacts, 'birthdaythisyear', ArrayNew(1)) />

<cfloop query="q_select_contacts">

	<cfset a_dt_birthday_this_year = CreateDate(Year(now()), Month(q_select_contacts.birthday), Day(q_select_contacts.birthday)) />
	
	<cfif a_dt_birthday_this_year LT Now()>
		<cfset a_dt_birthday_this_year = DateAdd('yyyy', 1, a_dt_birthday_this_year) />
	</cfif>
	
	<cfset a_int_diff_days = DateDiff('d', Now(), a_dt_birthday_this_year) />
	
	<cfset tmp = QuerySetCell(q_select_contacts, 'birthdaythisyear', a_dt_birthday_this_year, q_select_contacts.currentrow) />
	<cfset tmp = QuerySetCell(q_select_contacts, 'birthdayindays', a_int_diff_days, q_select_contacts.currentrow) />
</cfloop>

<cfquery name="q_select_contacts" dbtype="query">
SELECT
	*
FROM
	q_select_contacts
<cfif val(url.timeframe) GT 0>
	<cfset url.timeframe = url.timeframe + 1>
	WHERE
		(birthdayindays < <cfqueryparam cfsqltype="cf_sql_integer" value="#url.timeframe#">)
</cfif>
ORDER BY
	birthdayindays
;
</cfquery>

<cfset tmp = SetHeaderTopInfoString(GetLangVal('adrb_wd_birthdaylist')) />

<cfoutput>#GetLangVal('adrb_ph_birthdaylist_description')#</cfoutput>
<br /><br />  
<cfoutput>#GetLangVal('cal_wd_period')#</cfoutput>:
&nbsp;<a href="index.cfm?action=birthdaylist&timeframe=3">3 <cfoutput>#GetLangVal('cm_wd_days')#</cfoutput></a>&nbsp;|
&nbsp;<a href="index.cfm?action=birthdaylist&timeframe=7">1 <cfoutput>#GetLangVal('cal_wd_week')#</cfoutput> (7 <cfoutput>#GetLangVal('cm_wd_days')#</cfoutput>)</a>&nbsp;|
&nbsp;<a href="index.cfm?action=birthdaylist&timeframe=30"><cfoutput>#GetLangVal('cal_wd_month')#</cfoutput> (30 <cfoutput>#GetLangVal('cm_wd_days')#</cfoutput>)</a>&nbsp;|
&nbsp;<a href="index.cfm?action=birthdaylist&timeframe=0"><cfoutput>#GetLangVal('cm_wd_all')#</cfoutput></a>
<br /><br />  
<table class="table table-hover">
  <tr class="tbl_overview_header">
    <td colspan="2">
		<cfoutput>#GetLangVal('cm_wd_name')#</cfoutput></td>
    <td>
		<cfoutput>#GetLangVal('adrb_wd_birthday')#</cfoutput>
	</td>
	<td>
		<img src="/images/si/calendar.png" class="si_img" /> <cfoutput>#GetLangVal('adrb_ph_birthday_next_in')#</cfoutput>
	</td>
    <td align="center">
		<cfoutput>#GetLangVal('adrb_ph_new_age')#</cfoutput>
	</td>
    <td class="bb bt">&nbsp;</td>
  </tr>
  <cfoutput query="q_select_contacts">
  
  <cfset a_dt_birthday_this_year = CreateDate(Year(now()), Month(q_select_contacts.birthday), Day(q_select_contacts.birthday)) />
  
  <cfset a_str_dt_link = DateFormat(a_dt_birthday_this_year, 'mm/dd/yyyy') />
  <tr>
  	<td>		
		<img src="/images/si/bullet_orange.png" class="si_img" />
	</td>
    <td>
		<a href="index.cfm?action=ShowItem&entrykey=#urlencodedformat(q_select_contacts.entrykey)#"><b>#q_select_contacts.surname#</b>, #q_select_contacts.firstname#</a>
	</td>
    <td>
		<a href="../calendar/?action=ViewDay&date=#urlencodedformat(a_str_dt_link)#">#DateFormat(q_select_contacts.birthday, 'dd.mm.yyyy')#</a>
	</td>
	<td>
	
		<cfif a_dt_birthday_this_year LT Now()>
			<cfset a_dt_birthday_this_year = DateAdd('yyyy', 1, a_dt_birthday_this_year) />
		</cfif>
		
		<cfset a_int_diff_months = DateDiff('m', Now(), a_dt_birthday_this_year) />
		<cfset a_int_diff_days = DateDiff('d', Now(), a_dt_birthday_this_year) />
		
		<cfif a_int_diff_months GT 0>
			#a_int_diff_months# Monat(en)
		<cfelse>
			#a_int_diff_days# Tag(en)
		</cfif>	
	
	</td>
    <td align="center">
		#(DateDiff('yyyy', q_select_contacts.birthday, Now()) + 1)#
	</td>
    <td>&nbsp;</td>
  </tr>  
  </cfoutput>
</table>


