<!--- //

	Module:		Background-Jobs
	Description:Execute some queries and so on once a minute
	

// --->

<cfparam name="server.exec_once_a_minute_running" type="boolean" default="false">

<cfif server.exec_once_a_minute_running>
	<!---<cfabort>--->
</cfif>

<cfset server.exec_once_a_minute_running = true />
	
<!--- a) calendar alert --->
<h1><cfoutput>#Now()#</cfoutput></h1>
<hr>
<h4>cal alert</h4>
<cfinclude template="../calendar/alert/default.cfm">
<cfinclude template="../alert/cal_remind.cfm">
<hr>

<!--- b) new mail alerts --->
<h4>new mail alerts</h4>
<cfinclude template="../alert/newmail_alerts.cfm">
<hr>

<!--- send out newsletter --->
<cfinclude template="../newsletter/custom/send/sendout.cfm">

<!--- d) after first login --->
<cfif Minute(Now()) mod 5 IS 0>
	<hr>
	<h4>after first login</h4>
	<cftry>
	<cfinclude template="../automails/afterfirstlogin/default.cfm">
	<cfcatch type="any"></cfcatch>
	</cftry>
	<hr>
	
	<h4>insert metric data</h4>
	<cftry>
	<cfinclude template="../../maintain/status/insertmetricdata.cfm">
	<cfcatch type="any"></cfcatch>
	</cftry>
</cfif>

<h4>sessions ::</h4>
<cfinclude template="queries/q_delete_expired_keys.cfm">

<h4>fax incoming</h4>
<!--- <cfinclude template="../fax/check_incoming/default.cfm"> --->

<h4>mobileSync Status</h4>
<cftry>
<cfinclude template="../mobile/check_mobilesync_status.cfm">
<cfcatch type="any"> </cfcatch>
</cftry>

<h4>check wap profiles</h4>
<cftry>
<cfinclude template="../mobile/check_wap_profiles.cfm">
<cfcatch type="any"> </cfcatch>
</cftry>

<h4>Delete timed out locks</h4>
<cfset tmp = application.components.cmp_locks.RemoveTimedOutExclusiveLocks() />

<h4>calc md5 values from/to</h4>
<cftry>
<cfinclude template="../email/calc_md5_vals/default.cfm">
<cfcatch type="any"> </cfcatch>
</cftry>

<h4>Cleanup cache</h4>
<cfinclude template="cache/cleanup.cfm">

<cfset server.exec_once_a_minute_running = false />

