<!--- //

	load table
	
	// --->
	
	
<cfset request.a_cmp_lang = application.components.cmp_lang />
	
<!--- special tables? --->

<cfswitch expression="#arguments.reportkey#">

	<cfcase value="4EF24192-0626-7F32-E81AD993A04AB881">
		<!--- growth of contacts ... --->
		<cfinclude template="default_reports/inc_report_4EF24192-0626-7F32-E81AD993A04AB881.cfm">
	</cfcase>
	<cfcase value="EC8529E6-F963-096F-4EAE7C2041262B44">
	
		<!--- inactive accounts ... --->
		<cfinclude template="default_reports/inc_report_EC8529E6-F963-096F-4EAE7C2041262B44.cfm">
		
	</cfcase>
	
	<cfcase value="AC329E6-F963-096F-4EAE7C2041262777">
		<!--- activities ... --->
		<cfinclude template="default_reports/inc_report_AC329E6-F963-096F-4EAE7C2041262777.cfm">
	</cfcase>
	
	<cfcase value="ECC429C2-E237-F73F-E6233C1656C80378">
	
		<!--- country statistic --->		
		<cfinclude template="default_reports/inc_report_ECC429C2-E237-F73F-E6233C1656C80378.cfm">
	
	</cfcase>
	
	<cfcase value="35B59D8F-F002-C2F9-E9B1F98AF2B1F293">
		<!--- overdue followups ... --->
		<cfinclude template="default_reports/inc_report_35B59D8F-F002-C2F9-E9B1F98AF2B1F293.cfm">
	</cfcase>

	
</cfswitch>