<!--- //

	Module:		Tools
	Function:	GenerateLinkToItem
	Description: 
	

// --->

<cfswitch expression="#arguments.servicekey#">
	<cfcase value="52227624-9DAA-05E9-0892A27198268072">
		<!--- contact --->
		<cfif arguments.format IS 'html'>
			<cfset sReturn = '<a href="/addressbook/?action=showitem&entrykey=#urlencodedformat(arguments.objectkey)#">' />
		<cfelse>
			<cfset sReturn = 'https://' & a_str_base_url & '/addressbook/?action=showitem&entrykey=#urlencodedformat(arguments.objectkey)#' />
		</cfif>
		
	</cfcase>
	<cfcase value="52228B55-B4D7-DFDF-4AC7CFB5BDA95AC5">
		<!--- email --->
		<cfif arguments.format IS 'html'>
			<cfset sReturn = '<a href="##" onClick="window.open(''/email/default.cfm?Action=GotoMessageByMessageID&messageid=#urlencodedformat(arguments.objectkey)#&deletefollowupifdoesnotexist=true'', ''_blank'', ''resizable=1,location=0,directories=0,status=1,menubar=0,scrollbars=1,toolbar=0,width=780,height=600'');">' />
		<cfelse>
			<cfset sReturn = 'https://' & a_str_base_url & '/email/default.cfm?Action=GotoMessageByMessageID&messageid=#urlencodedformat(arguments.objectkey)#&deletefollowupifdoesnotexist=true' />
		</cfif>
		
	</cfcase>
	<cfcase value="5222ECD3-06C4-3804-E92ED804C82B68A2">
		<!--- storage --->
		<cfif arguments.format IS 'html'>
			<cfset sReturn = '<a href="/storage/default.cfm?action=FileInfo&entrykey=#urlencodedformat(arguments.objectkey)#">' />
		<cfelse>
			<cfset sReturn = 'https://' & a_str_base_url & '/storage/default.cfm?action=FileInfo&entrykey=#urlencodedformat(arguments.objectkey)#' />
		</cfif>
	</cfcase>
	<cfcase value="5137784B-C09F-24D5-396734F6193D879D">
		<!--- project --->
		<cfif arguments.format IS 'html'>
			<cfset sReturn = '<a href="/project/default.cfm?action=ShowProject&entrykey=#urlencodedformat(arguments.objectkey)#">' />
		<cfelse>
			<cfset sReturn = 'https://' & a_str_base_url & '/project/default.cfm?action=ShowProject&entrykey=#urlencodedformat(arguments.objectkey)#' />
		</cfif>
	</cfcase>
</cfswitch>

<!--- create full a link for html format --->
<cfif arguments.format IS 'html'>
	<cfset sReturn = sReturn & htmleditformat(CheckZeroString(trim(arguments.title))) />

	<cfset sReturn = sReturn & '</a>' />
</cfif>

