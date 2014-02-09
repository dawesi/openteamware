<!--- //

	Module:		E-Mail
	Action:		Filter
	Description: 
	

// --->
	
<cfparam name="url.restrict" type="string" default="">
	
<cfinclude template="queries/q_select_filter.cfm">

<!--- select number of anti-spam-filters ... --->
<cfquery name="q_select_normal_filters" dbtype="query">
SELECT
	COUNT(id) AS count_id
FROM
	q_select_filter
WHERE
	antispamfilter = 0
;
</cfquery>

<cfquery name="q_select_antispam_filter" dbtype="query">
SELECT
	COUNT(id) AS count_id
FROM
	q_select_filter
WHERE
	antispamfilter = 1
;
</cfquery>

<cfif len(url.restrict) GT 0>
	<cfquery name="q_select_filter" dbtype="query">
	SELECT * FROM q_select_filter
	WHERE
	<cfif url.restrict is "antispam">
	antispamfilter = 1
	<cfelse>
	antispamfilter = 0
	</cfif>
	</cfquery>
</cfif>


<script type="text/javascript">
	function deletefilter(id)
		{
		if (confirm('<cfoutput>#GetLangValJS('cm_ph_are_you_sure')#</cfoutput>'))
			{
			location.href = 'act_delete_filter.cfm?id='+id;
			}
		}
</script>

<cfset tmp = SetHeaderTopInfoString(GetLangVal('email_wd_filter')) />

<br />
Mit Filtern k&ouml;nnen Sie Ihre E-Mails effizient vorsortieren lassen und auch unerw&uuml;nschte Nachrichten blockieren.<br />
<a href="../settings/default.cfm?action=spamguard">Gegen Spam-Nachrichten steht Ihnen auch unser SpamGuard zur Seite!</a>
<br />
<form action="default.cfm">
<input type="hidden" name="action" value="createfilter">
<input class="btn" type="submit" value="<cfoutput>#GetLangVal('mail_ph_create_new_filter')#</cfoutput>">
</form>
<table width="500" border="0" cellpadding="4" cellspacing="0" class="b_all">
	<tr>
		<td class="br"><b>Anzeige einschr&auml;nken:</b></td>
		
		<td class="br<cfif comparenocase(url.restrict, "") is 0> mischeader</cfif>" align="center">
		<a href="default.cfm?action=filter">Alle (<cfoutput>#q_select_filter.recordcount#</cfoutput>)</a>
		</td>
		
		<td class="br<cfif comparenocase(url.restrict, "antispam") is 0> mischeader</cfif>" align="center">
		<a href="default.cfm?action=filter&restrict=antispam">nur Anti-Spam-Filter (<cfoutput>#val(q_select_antispam_filter.count_id)#</cfoutput>)</a>
		</td>
		
		<td align="center" <cfif comparenocase(url.restrict, "standard") is 0>class="mischeader"</cfif>>
		<a href="default.cfm?action=filter&restrict=standard">Standard-Filter (<cfoutput>#val(q_select_normal_filters.count_id)#</cfoutput>)</a>
		</td>
	</tr>
</table>
<br />

<table class="table_overview">
  <tr class="tbl_overview_header">
    <td>&nbsp;</td>
    <td><cfoutput>#GetLangVal('cm_wd_name')#</cfoutput></td>
    <td><cfoutput>#GetLangVal('email_ph_filter_action')#</cfoutput></td>
    <td><cfoutput>#GetLangVal('cm_wd_action')#</cfoutput></td>
  </tr>
  <cfoutput query="q_select_filter">
  <tr>
    <td class="addinfotext">
		#q_select_filter.currentrow#
	</td>
    <td>
		<a href="default.cfm?action=editfilter&id=#q_select_filter.id#">#htmleditformat(checkzerostring(q_select_filter.filtername))#</a>
		<br />
	<!--- where to look for? --->
	<cfswitch expression="#q_select_filter.comparisonfield#">
		<cfcase value="0">Betreff</cfcase>
		<cfcase value="1">Absender</cfcase>
		<cfcase value="2">Empf&auml;nger</cfcase>
		<cfcase value="3">Priorit&auml;t</cfcase>
		<cfcase value="4">Gr&ouml;sse</cfcase>
		<cfcase value="5">Gesamter Header</cfcase>
	</cfswitch>

	<!--- comparision --->
	<cfswitch expression="#q_select_filter.comparison#">
		<cfcase value="0">ist</cfcase>
		<cfcase value="1">ist nicht</cfcase>
		<cfcase value="2">enth&auml;lt</cfcase>
		<cfcase value="3">enth&auml;lt nicht</cfcase>
		<cfcase value="4">gr&ouml;sser als</cfcase>
		<cfcase value="5">kleiner als</cfcase>
	</cfswitch>

	<!--- comparison value --->
	"#htmleditformat(q_select_filter.comparisonparm)#"
	</td>
    <td class="bb" valign="top">
	<cfswitch expression="#q_select_filter.filtertype#">
		<cfcase value="0">
		l&ouml;schen
		</cfcase>
		<cfcase value="1">
		verschieben in den Ordner "#htmleditformat(q_select_filter.parameter)#"
		</cfcase>
		<cfcase value="2">
		weiterleiten per E-Mail an "#htmleditformat(q_select_filter.parameter)#"
		</cfcase>
	</cfswitch>
	</td>
    <td nowrap>
		<!--- move up/down ... --->
		<cfif q_select_filter.currentrow is 1>
		<img src="/images/space_1_1.gif" class="si_img" />
		<cfelse>
		<a class="nl" href="act_move_filter_position.cfm?direction=up&id=#q_select_filter.id#">#si_img('arrow_up')#</a>
		</cfif>
		
		<cfif q_select_filter.currentrow is q_select_filter.recordcount>
		<img src="/images/space_1_1.gif" class="si_img" />
		<cfelse>
		<a class="nl" href="act_move_filter_position.cfm?direction=down&id=#q_select_filter.id#">#si_img('arrow_down')#</a>
		</cfif>
	
		&nbsp;|&nbsp;
		<a href="default.cfm?action=editfilter&id=#q_select_filter.id#">#si_img('pencil')#</a>
		&nbsp;|&nbsp;
		<a href="javascript:deletefilter('#q_select_filter.id#');">#si_img('delete')#</a></td>
  </tr>
  </cfoutput>
</table>

<form action="default.cfm">
<input type="hidden" name="action" value="createfilter">
<input class="btn" type="submit" value="<cfoutput>#GetLangVal('mail_ph_create_new_filter')#</cfoutput>">
</form>


