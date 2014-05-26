<!--- //

	Module:        Framework
	Description:   Include given file
	

// --->
	
<cfset variables.a_tc_count_runtime_fw = GetTickCount()>

<cfswitch expression="#GetCurrentStyleUsed()#">

	<cfdefaultcase>
		<cfinclude template="inc_include_switch_file_index.cfm">
	</cfdefaultcase>

</cfswitch>
	
<cfset variables.a_tc_count_runtime_fw = GetTickCount() - variables.a_tc_count_runtime_fw>
<cfinclude template="queries/q_insert_log.cfm">


