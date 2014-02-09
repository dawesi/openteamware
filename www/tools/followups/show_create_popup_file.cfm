<cfinclude template="../../login/check_logged_in.cfm">

<cfparam name="url.objectkey" type="string" default="">

<cfinvoke   
	component = "#application.components.cmp_storage#"   
	method = "GetFileInformation"   
	returnVariable = "q_query_file"   
	entrykey = "#url.objectkey#"
	securitycontext="#request.stSecurityContext#"
	usersettings="#request.stUserSettings#">
</cfinvoke>		

<cfset a_str_followup = '/tools/followups/show_popup_create.cfm?objectkey='& url.objectkey & '&servicekey=5222ECD3-06C4-3804-E92ED804C82B68A2&title='&urlencodedformat(q_query_file.filename)>

<cflocation addtoken="no" url="#a_str_followup#">		