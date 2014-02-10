<!--- //
	load all followups of THIS user
	// --->
<cfsetting requesttimeout="20000">
	
<!--- load only private items --->
<cfset a_struct_filter = StructNew()>
<cfset a_struct_filter.userkey = variables.stSecurityContext.myuserkey>
<cfset a_struct_filter.done = 0>

<cfinvoke component="#request.a_str_component_followups#" method="GetFollowUps" returnvariable="q_select_follow_ups">
	<cfinvokeargument name="servicekey" value="">
	<cfinvokeargument name="objectkeys" value="">
	<cfinvokeargument name="usersettings" value="#variables.stUserSettings#">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
</cfinvoke>

<cfset tmp = LogMessage('followups: ' & q_select_follow_ups.recordcount)>

<!--- generate CSV --->
<cfset a_csv_followups = QueryToCSV2(variables.q_select_follow_ups)>

<cfset a_str_backup_dir = a_str_backup_directory & request.a_str_dir_separator & 'followups'>

<!--- create the email directory --->
<cfdirectory action="create" directory="#a_str_backup_dir#">

<cffile action="write" addnewline="no" charset="utf-8" file="#a_str_backup_dir#/followups.csv" output="#a_csv_followups#">