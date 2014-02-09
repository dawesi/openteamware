<!--- //

	load skype status and display option to call the user ...
	
	// --->

<cfparam name="url.skypeusername" type="string" default="">
<cfparam name="url.contactkey" type="string" default="">

<cfif NOT StructKeyExists(request, 'stSecurityContext')>
	<cfabort>
</cfif>

<cfset a_str_skype_username = trim(url.skypeusername)>

<cfif Len(a_str_skype_username) IS 0>
	<cfabort>
</cfif>


<cfset a_str_original_skype_username = a_str_skype_username>
<cfset a_str_skype_username = ReplaceNoCase(a_str_skype_username, ' ', '_', 'ALL')>

<!--- this is the URL to call in order to get the status --->
<cfset a_str_url = 'http://mystatus.skype.com/' & urlencodedformat(a_str_skype_username) & '.xml'>

<cflock name="a_str_lck_get_skype_status#createuuid()#" timeout="10">
<cfhttp url="#a_str_url#" resolveurl="no" charset="utf-8" timeout="10"></cfhttp>

<cfset a_str_xml = cfhttp.FileContent>
</cflock>

<cftry>
	<cfset a_xml_obj = XmlParse(a_str_xml)>
<cfcatch type="any">
	<cfabort>
</cfcatch>
</cftry>

<cfset a_xml_obj = XmlParse(a_str_xml)>

<cfset a_xml_nodes = a_xml_obj.xmlroot.xmlchildren[1].xmlchildren>

<cfset a_int_status = 0>
<cfset a_str_status_msg = ''>

<cfloop from="1" to="#ArrayLen(a_xml_nodes)#" index="ii">
	<cfif a_xml_nodes[ii].xmlname IS 'statusCode'>
		<cfset a_int_status = a_xml_nodes[ii].xmltext>
	</cfif>
	
	<cfif a_xml_nodes[ii].xmlname IS 'presence'>
		<cfif a_xml_nodes[ii].xmlattributes['xml:lang'] IS 'de'>
			<cfset a_str_status_msg = a_xml_nodes[ii].xmltext>
		</cfif>
	</cfif>
</cfloop>

<!--- crm enabled? add special link for history use --->

<cfset a_str_add_crm = 'call_new_item_for_contact(''#jsstringformat(url.contactkey)#'', ''event'', ''call'');'>

<cfswitch expression="#a_int_status#">
	<cfcase value="0">
		<a class="addinfotext" href="skype:<cfoutput>#htmleditformat(a_str_skype_username)#</cfoutput>"  onclick="<cfoutput>#a_str_add_crm#</cfoutput>return skypeCheck();"><cfoutput>#htmleditformat(url.skypeusername)#</cfoutput> (Offline)</a>
	</cfcase>
	<cfcase value="1">
		<a class="addinfotext" href="skype:<cfoutput>#htmleditformat(a_str_skype_username)#</cfoutput>"  onclick="<cfoutput>#a_str_add_crm#</cfoutput>return skypeCheck();"><cfoutput>#htmleditformat(url.skypeusername)# (#a_str_status_msg#</cfoutput>)</a>
	</cfcase>
	<cfcase value="6">
		<a class="addinfotext" href="skype:<cfoutput>#htmleditformat(a_str_skype_username)#</cfoutput>"  onclick="<cfoutput>#a_str_add_crm#</cfoutput>return skypeCheck();"><cfoutput>#htmleditformat(url.skypeusername)# (#a_str_status_msg#</cfoutput>)</a>
	</cfcase>
	<cfcase value="2,7" delimiters=",">
		
		<a title="<cfoutput>#htmleditformat(GetLangVal('cm_ph_call_with_skype'))#</cfoutput>" onclick="<cfoutput>#a_str_add_crm#</cfoutput>return skypeCheck();" href="skype:<cfoutput>#htmleditformat(a_str_skype_username)#</cfoutput>?call"><cfoutput>#htmleditformat(url.skypeusername)#</cfoutput>
		
		(<font style="color:#009900;"><cfoutput>#a_str_status_msg#</cfoutput></font>)
		
		<img src="/images/skype/img_call_start_12x12.png" width="12" height="12" align="absmiddle" border="0"/></a>

	</cfcase>
	<cfcase value="5">
		<font style="color:#CC0000; "><cfoutput>#htmleditformat(a_str_skype_username)# (#a_str_status_msg#</cfoutput>)</font>
	</cfcase>
	<cfdefaultcase>
		<a class="addinfotext" href="skype:<cfoutput>#htmleditformat(a_str_skype_username)#</cfoutput>"  onclick="<cfoutput>#a_str_add_crm#</cfoutput>return skypeCheck();"><cfoutput>#htmleditformat(url.skypeusername)# (#a_str_status_msg#)</cfoutput></a>
	</cfdefaultcase>
</cfswitch>