<!--- //

	Module:		
	Action:		
	Description:Execute a virus check on a file	
	

// --->
<cfcomponent displayname="VirusCheck">

	<!--- //
	
		execute a virus check and return 
		
		
		TRUE = file is clean
		
		FALSE ... not CLEAR INFECTED!!
		
		// --->
		
	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
		
	<!---<cfset a_str_avp_daemon = "/opt/AVP/AvpDaemonClient">--->
	<cfset a_str_avp_scanner = '/opt/AVP/kavscanner'>
	<cfset a_str_fprot_scanner = '/usr/local/bin/f-prot'>
	
	<cffunction access="public" name="checkfileforvirus" output="false" returntype="struct"
			hint="scan a file for viruses">
		<cfargument name="filename" type="string" required="true"
			hint="full path to file to check">
		
		<!--- the return structure ... --->
		<cfset var stReturn = GenerateReturnStruct() />
		<!--- the filename of the report ... --->
		<cfset var a_str_report_filename = request.a_str_temp_directory & createuuid() />
		<cfset var a_str_arguments = ' "' & arguments.filename & '" > ' & a_str_report_filename />
		<cfset var a_str_sh_cmd = a_str_fprot_scanner & a_str_arguments />
		<cfset var a_str_sh_tmp_file = request.a_str_temp_directory & CreateUUID() & '.sh' />
		<cfset var a_bol_clean = false />
		<cfset var a_str_report = '' />
		
		<cfset stReturn.exec = ' ok.' />
		<cfset stReturn.clean =  true />
		<cfset stReturn.report = '' />
		
		<cfreturn stReturn />

		<cffile action="write" addnewline="false" charset="utf-8" output="#a_str_sh_cmd#" file="#a_str_sh_tmp_file#">
		
		<cfexecute name="sh" arguments="#a_str_sh_tmp_file#" outputfile="/tmp/virusscan.txt"></cfexecute>
		
		<!--- <cfreturn SetReturnStructErrorCode(stReturn, 999) /> --->
		<cfexecute name="#a_str_fprot_scanner#"
			arguments="#a_str_arguments#" timeout="300">
		</cfexecute>		
		
		<!--- <cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="Virus checking" type="html">
			<cfdump var="#a_str_arguments#" label="a_str_arguments">
			<cfdump var="#arguments#">
			<br /> 
			a_str_sh_tmp_file: #a_str_sh_tmp_file#
			<br /> 
			a_str_report_filename: #a_str_report_filename#
			#FileExists(a_str_report_filename)#
		</cfmail> --->
		
		
		<cffile action="read" file="#a_str_report_filename#" variable="a_str_report">
		
		<!--- look for the string "No viruses were found":
		
			+-------------------------------------------------------+ 
			| Kaspersky Anti-Virus for Linux | 
			| Copyright(C) Kaspersky Lab. 1998-2001 | 
			| Version 3.0 build 136 | | 
			| +-------------------------------------------------------+ 
			Registration info: Evaluation copy KAV Key is not loaded or your KAV 
			license was expiried. Program can work only as demo. Antiviral 
			databases have been loaded. Known records: 73879. 
			Current object: /var/spool/cfmx//9A652F96-C2BE-B6D8-2434D7FFA7398354 
			You will not be able to read the disk info. 
			/var/spool/cfmx//9A652F96-C2BE-B6D8-2434D7FFA7398354 ok. 
			Scan process completed. 
			Sector Objects : 0 
			Known viruses : 0 
			Files : 1 
			Virus bodies : 0 
			Folders : 0 
			Disinfected : 0 
			Archives : 0 
			Deleted : 0 
			Packed : 0 
			Warnings : 0 
			Suspicious : 0 
			Speed (Kb/sec) : 1 
			Corrupted : 0 
			Scan time : 00:00:01 
			I/O Errors : 0 
			
			--->
			
		<!---<cfset a_bol_clean = FindNoCase(a_str_temp_filename&' ok.', a_str_report) GT 0>--->
		<cfset a_bol_clean = FindNoCase('No viruses or suspicious files/boot sectors were found', a_str_report) GT 0>
			
		<cfset stReturn.exec = a_str_temp_filename & ' ok.' />
		<cfset stReturn.clean =  a_bol_clean />
		<cfset stReturn.report = a_str_report />
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>

</cfcomponent>

