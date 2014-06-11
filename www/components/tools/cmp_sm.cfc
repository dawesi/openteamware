<cfcomponent output='false'>

	<cfinclude template="/common/scripts/script_utils.cfm">
	<cfinclude template="/common/app/app_global.cfm">
	

	<cffunction access="public" name="GetJobInfo" returntype="query" output="false" hint="return the job information">
		<cfargument name="jobkey" type="string" required="true">
		
		<cfinclude template="queries/q_select_jobinfo.cfm">
		
		<cfreturn q_select_jobinfo>
	</cffunction>
		
	<cffunction access="public" name="SearchLDAPServer" returntype="query" output="false">
		<cfargument name="search" type="string" required="true">
		
		<cfset q_select_results = QueryNew('givenName,sn,eidCertificateSerialNumber,mail,userCertificate,objectClass,eidUniqueIdentifier,cn,eidCertKeyUsage,eidSmartCardSerialNumber')>
		
		<cfif Len(arguments.search) LTE 3>
			<cfreturn q_select_results>
		</cfif>
		
		<cfldap name="GetList" filter="(|(cn=*#arguments.search#*)(mail=*#arguments.search#*))" server="ldap.a-trust.at" port="389" action="query" attributes="*" scope="subtree" start="o=a-trust,c=AT" >

		<cfset a_int_currentrow = 0>
		
		<cfoutput query="GetList">
			<cfif GetList.Name IS 'givenName'>
				<cfset QueryAddRow(q_select_results, 1)>
				<cfset a_int_currentrow = q_select_results.recordcount>
			</cfif>
			
			<cftry>
			<cfset QuerySetCell(q_select_results, Replace(GetList.name, ';binary', ''), GetList.value, a_int_currentrow)>
			<cfcatch type="any"></cfcatch></cftry>
			
		</cfoutput>
		
		<cftry>
		<cfquery name="q_select_results" dbtype="query">
		SELECT
			*
		FROM
			q_select_results
		WHERE
			NOT mail IS NULL
			AND
			NOT mail = ''
		;
		</cfquery>
		<cfcatch type="any"></cfcatch></cftry>
		
		<cfreturn q_select_results>
	
	</cffunction>
	
	<!--- load the cert and return the content ... --->
	<cffunction access="public" name="GetCertFromATrust" returntype="binary" output="false">
		<cfargument name="id" type="numeric" required="true">
		
		<cfhttp url="http://www.a-trust.at/html/ldaptrust_all_ver.asp?p1=%2Ftempcerts%2F#CreateUUID()#.crt&p2=#CreateUUID()#&p3=#arguments.id#" resolveurl="no" getasbinary="yes"></cfhttp>
			
		<cfreturn CFHTTP.fileContent>
		
	</cffunction>
	
	<cffunction access="public" name="SetMessageStatus" returntype="boolean" output="false">
		<cfargument name="uid" type="numeric" required="true">
		<cfargument name="foldername" type="string" required="true">
		<cfargument name="userkey" type="string" required="true">
		<cfargument name="valid" type="numeric" required="true">
		<cfargument name="expired" type="numeric" required="true">
		<cfargument name="subject" type="string" required="true">
		<cfargument name="issuer" type="string" required="true">
		<cfargument name="validto" type="string" required="false" default="">
		
		<cfreturn true>
	</cffunction>
	
	<!--- verify a message on the server --->
	<cffunction access="public" name="VerifyMessageOnServer" output="false" returntype="struct">
		<cfargument name="userkey" type="string" required="true">
		<cfargument name="mailsource" type="string" required="true">
		
		<!--- the report output file ... --->
		<cfset a_str_report = request.a_str_temp_directory & createuuid()>
		
		<!---<cfset a_str_report = '/tmp/report.txt'>--->
		
		<cfset a_bool_verify_successful = false>
		
		<!--- execute check --->
		<cfexecute name="/mnt/config/bin/opensslverify.sh" arguments="#a_str_report# #arguments.mailsource#" timeout="60"></cfexecute>
		
		
		<cffile action="read" file="#a_str_report#" variable="a_str_outtext">
		
		<!--- Search for "Verification successful" String --->
		<cfif CompareNoCase('Verification Successful',Trim(a_str_outtext)) IS 0>
			<cfset a_bool_verify_successful = true>
		</cfif>

		<cfset stReturn = StructNew()>
		<cfset stReturn.returncode = a_bool_verify_successful>
		<cfset stReturn.output = a_str_outtext>
	
		<cfreturn stReturn>
	</cffunction>
	
	<cffunction access="public" name="CreateCertificate" output="false" returntype="boolean">
		<cfargument name="keyoutputfilename" type="string" required="true">
		<cfargument name="certoutputfilename" type="string" required="true">
		<cfargument name="country"  required="true">
		<cfargument name="state" type="string"  required="false">
		<cfargument name="city" type="string"  required="false">
		<cfargument name="organization" type="string" required="false">
		<cfargument name="organizationunit" type="string" required="false">
		<cfargument name="commonname" type="string" required="true">
		<cfargument name="emailaddress" type="string" required="true">

		<cfset a_str_subject="">
		<cfif arguments.country neq "">
			<cfset a_str_subject=a_str_subject&"/C="&arguments.country>
		</cfif>
		<cfif arguments.state neq "">
			<cfset a_str_subject=a_str_subject&"/ST="&arguments.state>
		</cfif>
		<cfif arguments.city neq "">
			<cfset a_str_subject=a_str_subject&"/L="&arguments.city>
		</cfif>
		<cfif arguments.organization neq "">
			<cfset a_str_subject=a_str_subject&"/O="&arguments.organization>
		</cfif>
		<cfif arguments.organizationunit neq "">
			<cfset a_str_subject=a_str_subject&"/OU="&arguments.organizationunit>
		</cfif>
		<cfif arguments.commonname neq "">
			<cfset a_str_subject=a_str_subject&"/CN="&arguments.commonname>
		</cfif>
		<cfif arguments.emailaddress neq "">
			<cfset a_str_subject=a_str_subject&"/emailAddress="&arguments.emailaddress>
		</cfif>
		<cfset a_str_subject='"' & a_str_subject & '"'>
		<cfset a_str_batchfile="#request.a_str_temp_directory##request.a_str_dir_separator#"&createuuid()&".sh">
		<cfset a_str_script="##!/bin/bash" & Chr(10) >
		<cfset a_str_script=a_str_script&"/usr/bin/openssl req -new -batch -nodes -subj #a_str_subject# -out #keyoutputfilename# -keyout #keyoutputfilename#"& Chr(10) >
		<cfset a_str_script=a_str_script&"/usr/bin/openssl ca -batch -policy policy_anything -out #certoutputfilename# -infiles #keyoutputfilename# " & Chr(10) >
		<cffile action="WRITE" file="#a_str_batchfile#" output="#a_str_script#">
	 	<cfexecute name="/bin/bash" arguments="#a_str_batchfile#"   timeOut="10">
		</cfexecute>
		
		<cfreturn true>
	</cffunction>
	
	
</cfcomponent>