<!--- //

	Component:	Render
	Description:Include neccessary JavaScripts
	
	SUCCESSOR OF /COMMON/JS/INC_JS.CFM
	
// --->

<script src="/common/js/init.js" type="text/javascript"></script>
<script src="/assets/js/jquery-1.11.1.min.js" type="text/javascript"></script>
<script src="/common/js/display.js" type="text/javascript"></script>

<!--- list of JavaScript files to load ... --->
<cfset a_str_js_files_2_load = '' />

<!--- <cfset a_str_js_files_2_load = ListAppend(a_str_js_files_2_load, '/common/js/display.js') /> --->
<!--- <cfset a_str_js_files_2_load = ListAppend(a_str_js_files_2_load, '/common/js/jquery.validate.pack.js') /> --->
<!--- <cfset a_str_js_files_2_load = ListAppend(a_str_js_files_2_load, '/common/js/jquery.shortkeys.js') /> --->
<!--- <cfset a_str_js_files_2_load = ListAppend(a_str_js_files_2_load, '/common/js/jquery.plugins.js') /> --->

<cfswitch expression="#request.sCurrentServiceKey#">
	<cfcase value="7E68B84A-BB31-FCC0-56E6125343C704EF">
		<!--- CRM overview --->
		<cfset a_str_js_files_2_load = ListAppend(a_str_js_files_2_load, '/common/js/calendar.js') />
		<cfset a_str_js_files_2_load = ListAppend(a_str_js_files_2_load, '/common/js/addressbook.js') />
		<cfset a_str_js_files_2_load = ListAppend(a_str_js_files_2_load, '/common/js/crm_ext.js') />	
		<cfset a_str_js_files_2_load = ListAppend(a_str_js_files_2_load, '/common/js/CalendarPopup.js') />
		<cfset a_str_js_files_2_load = ListAppend(a_str_js_files_2_load, '/common/js/jquery.calendar.js') />
	</cfcase>	
	<cfcase value="52227624-9DAA-05E9-0892A27198268072">
		<!--- addressbook ... --->
		<cfset a_str_js_files_2_load = ListAppend(a_str_js_files_2_load, '/common/js/addressbook.js') />
		<cfset a_str_js_files_2_load = ListAppend(a_str_js_files_2_load, '/common/js/crm_ext.js') />
		<cfset a_str_js_files_2_load = ListAppend(a_str_js_files_2_load, '/common/js/CalendarPopup.js') />
		<cfset a_str_js_files_2_load = ListAppend(a_str_js_files_2_load, '/common/js/jquery.treeview.pack.js') />

		<cfset a_str_js_files_2_load = ListAppend(a_str_js_files_2_load, '/common/js/jquery.calendar.js') />	
	</cfcase>
	
	<cfcase value="5222B55D-B96B-1960-70BF55BD1435D273">
		<!--- calendar ... --->
		<cfset a_str_js_files_2_load = ListAppend(a_str_js_files_2_load, '/common/js/calendar.js')>
		<cfset a_str_js_files_2_load = ListAppend(a_str_js_files_2_load, '/common/js/jquery.calendar.js') />
		<cfset a_str_js_files_2_load = ListAppend(a_str_js_files_2_load, '/common/js/CalendarPopup.js')>
		
		<!--- <cfset a_str_js_files_2_load = ListAppend(a_str_js_files_2_load, '/common/js/NonIECalendarPopup.js')> --->
	</cfcase>
	
	<cfcase value="5137784B-C09F-24D5-396734F6193D879D">
		<!--- projects ... --->
		<cfset a_str_js_files_2_load = ListAppend(a_str_js_files_2_load, '/common/js/jquery.calendar.js') />
	</cfcase>
	
	<cfcase value="9596B599-B48F-087E-2A1FA266FEED4D61">
		<!--- admin tool ... --->
		<cfset a_str_js_files_2_load = ListAppend(a_str_js_files_2_load, '/common/js/jquery.treeview.pack.js') />
		<cfset a_str_js_files_2_load = ListAppend(a_str_js_files_2_load, '/common/js/admintool.js') />
		
	</cfcase>
	
	<cfcase value="52228B55-B4D7-DFDF-4AC7CFB5BDA95AC5">
		<!--- e-mail ... --->
		<cfset a_str_js_files_2_load = ListAppend(a_str_js_files_2_load, '/common/js/email.js') />
		<cfset a_str_js_files_2_load = ListAppend(a_str_js_files_2_load, '/common/js/jquery.treeview.pack.js') />
		
		<cfif ListFindNoCase('composemail', arguments.currentaction) GT 0>
			<cfset a_str_js_files_2_load = ListAppend(a_str_js_files_2_load, '/common/js/wddx.js') />
			<cfset a_str_js_files_2_load = ListAppend(a_str_js_files_2_load, '/common/js/email_compose.js') />
		</cfif>
	</cfcase>
	
	<cfcase value="5222ECD3-06C4-3804-E92ED804C82B68A2">
		<!--- storage ... --->
		<cfset a_str_js_files_2_load = ListAppend(a_str_js_files_2_load, '/common/js/storage.js')>
		<cfset a_str_js_files_2_load = ListAppend(a_str_js_files_2_load, '/common/js/jquery.calendar.js') />
	</cfcase>
	
	<cfcase value="startpagecontent">
		<cfset a_str_js_files_2_load = ListAppend(a_str_js_files_2_load, '/common/js/calendar.js')>
		<cfset a_str_js_files_2_load = ListAppend(a_str_js_files_2_load, '/common/js/email.js')>
		<cfset a_str_js_files_2_load = ListAppend(a_str_js_files_2_load, '/common/js/addressbook.js')>
	</cfcase>
	
	<cfcase value="52230718-D5B0-0538-D2D90BB6450697D1">
		<!--- tasks --->
		<cfset a_str_js_files_2_load = ListAppend(a_str_js_files_2_load, '/common/js/tasks.js')>

		<cfset a_str_js_files_2_load = ListAppend(a_str_js_files_2_load, '/common/js/jquery.calendar.js') />		
		
	</cfcase>
	<cfcase value="7E6F3B98-F885-03B7-FC68D096FD692F66">
		<cfset a_str_js_files_2_load = ListAppend(a_str_js_files_2_load, '/common/js/CalendarPopup.js')>
		<cfset a_str_js_files_2_load = ListAppend(a_str_js_files_2_load, '/common/js/newsletter.js')>
	</cfcase>
	<cfcase value="7E6BDD88-FF3F-96D6-BD30172024704A60">
		<!--- extras --->
		<cfset a_str_js_files_2_load = ListAppend(a_str_js_files_2_load, '/common/js/jquery.calendar.js') />
	</cfcase>
</cfswitch>

<!--- list of fn to call when doc is ready (NOT onload, might be later (e.g. images ...) --->
<cfset a_str_functions2CallOnDocumentReady = '' />

<!--- TODO: IncludeRes file prüfen ... mit output usw ... --->
<!--- <cfloop list="#a_str_js_files_2_load#" index="a_str_js_filename">
	<cfoutput>
<script type="text/javascript" src="#a_str_js_filename#"></script>
</cfoutput>
</cfloop> --->


<cfloop list="#a_str_js_files_2_load#" index="a_str_js_filename">

	<script src="<cfoutput>#a_str_js_filename#</cfoutput>" type="text/javascript"></script>
</cfloop>

<!--- IncludeResFile('<cfoutput>#a_str_js_filename#</cfoutput>', 'script'); --->

<!--- fire now loading of js ... --->
<script type="text/javascript">
	
	<cfif StructKeyExists(request, 'stSecurityContext')>
	vl_current_username = '<cfoutput>#jsstringformat(request.stSecurityContext.myusername)#</cfoutput>';
	</cfif>
	
	<!---- check if frameset should be checked ... replace YES with true on return --->	
	<cfset a_bol_check_frameset = ReplaceNoCase(ReplaceNoCase((StructKeyExists(request, 'a_struct_current_service_action') AND (request.a_struct_current_service_action.checkframeset IS 1)), 'YES', 'true'), 'NO', 'false') />
	
	<cfset a_str_functions2CallOnDocumentReady = 'InitBasicDoc(''' & jsstringformat(request.sCurrentServiceKey) &  ''',' & a_bol_check_frameset & ')' />
	
	<!--- Call all init scripts ...  --->
	$(document).ready(function(){<cfoutput>#a_str_functions2CallOnDocumentReady#</cfoutput>});

</script>