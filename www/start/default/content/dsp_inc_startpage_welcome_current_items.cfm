<!--- //

	Module:		Startpage
	Description:DisplayCurrentItems
	

	
	
	Display current bookmarks, files, news, ...
	
// --->

<cfset tmp = StartNewTabNavigation() />	
<cfset a_str_id_news = AddTabNavigationItem(GetLangVal('cm_wd_newsticker'), '', '') /> 
<!--- <cfset a_str_id_files = AddTabNavigationItem(GetLangVal('cm_Wd_files'), '', '') /> --->
<cfset a_str_id_bookmarks = AddTabNavigationItem(GetLangVal('cm_wd_bookmarks'), '', '') />
<!--- <cfset a_str_id_statistics = AddTabNavigationItem('SyncCenter & ' & GetLangVal('adm_wd_statistics'), '', '') /> ---> 
<!--- <cfset a_str_id_locks = AddTabNavigationItem(GetLangVal('cm_wd_locked_objects'), '', '') /> --->

<!--- <cfsavecontent variable="a_str_js_to_exec_on_load">
function DisplayNewFiles() {
	var a_simple_get = new cBasicBgOperation();
	
	a_simple_get.url = '/storage/default.cfm?Action=DisplayLatelyAddedFilesList';
	a_simple_get.id_obj_display_content = '<cfoutput>#a_str_id_files#</cfoutput>';
	a_simple_get.doOperation();
	}
</cfsavecontent> --->

<!--- <cfset tmp = AddJSToExecuteAfterPageLoad('DisplayNewFiles()', a_str_js_to_exec_on_load) />
	 --->
<!--- catch content ... --->
<cfsavecontent variable="a_str_box">

<cfoutput>#BuildTabNavigation('', false)#</cfoutput>

<!--- new files ... --->
<!--- <div id="<cfoutput>#a_str_id_files#</cfoutput>" class="b_all">
files
</div>
 --->

<!--- bookmarks ... --->

</div>

<!--- display which channels? --->
<cfif StructKeyExists(server, 'q_select_rss')>
<cfset a_str_nt_sourceids = GetUserPrefPerson('newsticker', 'sourceids', '4,15,11,10', '', false) />

<cfif Len(a_str_nt_sourceids) IS 0>
	<cfset a_str_nt_sourceids = '4,15,11,10' />
</cfif>

<cfquery dbtype="query" name="q_select_rss_feed" maxrows="10">
SELECT
	entryid,title,href,feedsection,weight
FROM
	server.q_select_rss
WHERE
	feedid IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#a_str_nt_sourceids#">)
ORDER BY
	weight,feedid
;
</cfquery>

<div class="b_all" id="<cfoutput>#a_str_id_news#</cfoutput>" style="display:none;width:99%;">
	<table class="table_overview">
		<cfoutput query="q_select_rss_feed">
		<tr>
			<td>
				<img src="/images/si/bullet_orange.png" class="si_img" /> <a href="#q_select_rss_feed.href#" target="_blank">#htmleditformat(q_select_rss_feed.title)#</a>
			</td>
		</tr>
		</cfoutput>
	</table>
</div>
</cfif>

</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('cm_ph_current_items'), '', a_str_box)#</cfoutput>

<!--- <cfsavecontent variable="a_str_js">
	function ShowStartCurrentItems(section) {
	
		}

	ShowStartCurrentItems('bookmarks');
</cfsavecontent>

<cfset tmp = AddJSToExecuteAfterPageLoad('', a_str_js) /> --->
