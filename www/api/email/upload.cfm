<!--- //

	upload a mail message from SecureMail
	
	parameters:
	
	userkey ... string ... the userkey
	
	message ... the mail message (gzipped; not yet)
	
	savemessage ... save message in SENT folder?
	
	RETURN: XML ... but this is not parsed
	
	// --->
	
<cfparam name="form.userkey" type="string" default="">
<cfparam name="form.messagefile" type="string" default="">
<cfparam name="form.savemessage" type="numeric" default="0">
<cfparam name="form.jobkey" type="string" default="">
<cfparam name="form.from" type="string" default="">
<cfparam name="form.to" type="string" default="">
<cfparam name="form.subject" type="string" default="">
<cfparam name="form.signed" type="numeric" default="0">
<cfparam name="form.encrypted" type="numeric" default="0">

<!--- get message file ... --->
<cffile action="upload" filefield="form.messagefile" destination="#request.a_str_temp_directory#" nameconflict="makeunique">


<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="dump" type="html">
	<cfdump var="#form#">
	<cfdump var="#file#">
</cfmail>


<cfcontent type="text/xml">
<?xml>

result>
	<code>200</code>
</result>