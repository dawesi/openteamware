<!--- //

	Module:		Send out SMS
	Action:		
	Description:	
	

// --->
<cfcomponent displayname="smsgateway">

	<cfinclude template="/common/app/app_global.cfm">
	
	<cffunction access="public" name="SendSMSEx" output="false" returntype="struct">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="body" type="string" required="true">
		<cfargument name="sender" type="string" required="true">
		<cfargument name="recipient" type="string" required="true">
		<cfargument name="dt_2send" type="date" required="false" default="#Now()#">
		<!---
			0 = user generated
			1 = alert sms
			
			--->
		<cfargument name="jobsource" type="numeric" default="0" required="false">
		<cfargument name="parameters" type="string" default="" required="no">
		
		<cfset var a_int_specialaccount = 0>
		<cfset var stReturn = StructNew()>
		<cfset stReturn.result = false>
		<cfset stReturn.errormessage = ''>
		<cfset stReturn.debitpoints = 0>
		
		<cfif Len(arguments.body) IS 0>
			<cfreturn stReturn>
		</cfif>
		
		<cfif Len(arguments.sender) IS 0>
			<cfreturn stReturn>
		</cfif>
		
		<!--- check if this company has fax.de account data or not --->
		
		<cfthrow message="to implement">	
		
		<cfif NOT stReturn_fax_de_data.accountavailable OR stReturn_Fax_De_Data.faxreceiveonly IS 1>
			<!--- no fax.de account available ... use internal openTeamware.com points system ... --->
			<cfset a_int_specialaccount = 1>
			
			<cfinvoke component="#application.components.cmp_licence#" method="GetAvailablePoints" returnvariable="a_int_points">
				<cfinvokeargument name="companykey" value="#arguments.securitycontext.mycompanykey#">
			</cfinvoke>
		
			<!--- calculate points and debit --->
			<cfinvoke component="#application.components.cmp_licence#" method="CalculateAndDebitAccount" returnvariable="stReturn_debit">
				<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
				<cfinvokeargument name="messagetype" value="sms">
				<cfinvokeargument name="parameters" value="#arguments.parameters#">
				<cfinvokeargument name="destinationnumber" value="#arguments.recipient#">
			</cfinvoke>
	
				<cfif NOT stReturn_debit.result>
			
					<cfset stReturn.errormessage = stReturn_debit.errormessage>

					<cfreturn stReturn>					
					
				</cfif>
				
				<cfset stReturn.debitpoints = stReturn_debit.a_int_points_needed>

		</cfif>
		
		
		<cfset arguments.recipient = ReplaceNoCase(arguments.recipient, '+', '')>
		
		<cfif IsNumeric(arguments.sender) AND FindNoCase('00', arguments.sender) NEQ 1>
			<cfset arguments.sender = '00'&arguments.sender>
		</cfif>
		
		<cfif FindNoCase('00', arguments.recipient) NEQ 1>
			<cfset arguments.recipient = '00'&arguments.recipient>
		</cfif>		
		
		<!--- insert job ... --->
		<cfinclude template="queries/q_insert_sms_job.cfm">
		
		<!--- insert into sent sms folder ... or create email? --->
		
		
		<cfset stReturn.result = true>
		<cfreturn stReturn>
	</cffunction>

	<!--- send an sms ... --->
	<cffunction access="public" name="SendSMS" output="false" returntype="struct">
		<cfargument name="userid" type="numeric" required="true" default="0">
		<cfargument name="username" type="string" required="true" default="">
		<cfargument name="body" type="string" required="true" default="">
		<cfargument name="sender" type="string" required="true" default="">
		<cfargument name="recipient" type="string" required="true" default="">
		<cfargument name="dt_send" type="date" required="true" default="">
		<cfargument name="priority" type="numeric" required="false" default="3">
		<cfargument name="ownnumberassender" type="numeric" required="true" default="0">
		
		<cfset var stReturn = StructNew() />
		<cfset var a_dt_send = 0 />
		<cfset var stReturn_securitycontext = 0 />
		
		<cfif isDate(arguments.dt_send)>
			<cfset a_dt_send = arguments.dt_send />
		<cfelse>
			<cfset a_dt_send = now() />
		</cfif>		

		<!--- create securitycontext for account used to send out sms messages (smsversand.intern@openTeamware.com) ... --->
		<cfinvoke component="#application.components.cmp_security#" method="GetSecurityContextStructure" returnvariable="stReturn_securitycontext">
			<cfinvokeargument name="userkey" value="4BBB7FBE-DD01-A2CF-9E406A3A3E4E7879">
		</cfinvoke>
		
		<cfset stReturn = SendSMSEx(securitycontext = stReturn_securitycontext, body = arguments.body, sender = arguments.sender, recipient = arguments.recipient, dt_2send = arguments.dt_send)>
		
		<cfreturn stReturn>
		
	</cffunction>
	
	<cffunction access="public" name="GetArchive" output="false" returntype="struct">
		<cfargument name="userid" type="numeric" default="0" required="true">
		
		<cfset a_struct = StructNew()>
	
		<cfreturn a_struct>
	</cffunction>
	
	<!--- newest version ... --->
	<cffunction access="public" output="false" name="CreateSMSSendJob" returntype="struct">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="body" type="string" required="true">
		
		<!--- anonym oder mit nummer --->
		<cfargument name="sender" type="string" required="true">
		<cfargument name="recipient" type="string" required="true">
		<cfargument name="dt_2send" type="date" required="false" default="#Now()#">
		<cfargument name="jobsource" type="numeric" default="0" required="false">
		<cfargument name="parameters" type="struct" default="#StructNew()#" required="no">
		
		<cfset var stReturn = StructNew()>
		
		<!--- set default parameters ... --->
		
		<cfreturn stReturn>
	</cffunction>

</cfcomponent>
