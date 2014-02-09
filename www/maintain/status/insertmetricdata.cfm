<cfset inet = CreateObject("java", "java.net.InetAddress")>
<cfset inet = inet.getLocalHost()>

<cfset metrics = GetMetricData("PERF_MONITOR")>

<!---<cfset runtime = CreateObject("java","java.lang.Runtime").getRuntime()>
<cfset freeMemory = runtime.freeMemory() / 1024 / 1024>
<cfset totalMemory = runtime.totalMemory() / 1024 / 1024>
<cfset maxMemory = runtime.maxMemory() / 1024 / 1024>--->
<cfset freeMemory = 0>
<cfset totalMemory = 0>
<cfset maxMemory = 0>

<cfquery name="q_insert" datasource="mysqllog">
INSERT INTO
	serverlog
	(
	hostname,
	dt_created,
	DBHits,
	ReqQueued,
	ReqTimedOut,
	PageHits,
	ReqRunning,
	BytesIn,
	AvgQueueTime,
	AvgDBTime,
	AvgReqTime,
	BytesOut,
	freeMemory,
	totalMemory,
	maxMemory)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#inet.getHostName()#">,
	Now(),
	<cfqueryparam cfsqltype="cf_sql_integer" value="#metrics.DBHits#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#metrics.ReqQueued#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#metrics.ReqTimedOut#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#metrics.PageHits#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#metrics.ReqRunning#">,
	<cfqueryparam cfsqltype="cf_sql_bigint" value="#metrics.BytesIn#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#metrics.AvgQueueTime#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#metrics.AvgDBTime#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#metrics.AvgReqTime#">,
	<cfqueryparam cfsqltype="cf_sql_bigint" value="#metrics.BytesOut#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#freeMemory#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#totalMemory#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#maxMemory#">
	)
;
</cfquery>

<cfset runtime = 0>