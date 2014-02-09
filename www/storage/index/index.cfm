<!--- Interesting Content types --->
<cfset a_arr_contenttypes=ArrayNew(1)>
<cfset temp=ArrayAppend(a_arr_contenttypes,'text/html')>
<cfset temp=ArrayAppend(a_arr_contenttypes,'text/plain')>
<cfset temp=ArrayAppend(a_arr_contenttypes,'applicaton/pdf')>
<cfset temp=ArrayAppend(a_arr_contenttypes,'application/x-zip-compressed')>
<cfset temp=ArrayAppend(a_arr_contenttypes,'application/msexcel')>
<cfset temp=ArrayAppend(a_arr_contenttypes,'application/mspowerpoint')>
<cfset temp=ArrayAppend(a_arr_contenttypes,'application/msword')>


<!--- Parse the Query_String TODO --->		
<cfset a_int_idx1=0>
<cfset a_int_idx2=1>
<cfset lc=0>
<cfset a_arr_path_arguments=ArrayNew(1)>
<cfloop condition="lc le 100">
  <cfset a_int_idx1=Find("/",CGI.PATH_INFO,a_int_idx2)>
  <cfif a_int_idx1 gt 0>
  
    <cfset a_int_idx2=Find("/",CGI.PATH_INFO,a_int_idx1+1)>
    <cfif a_int_idx2 eq 0>
      <cfset a_int_idx2 = len(CGI.PATH_INFO)+1>
      <cfset lc=100>
    </cfif>
    <cfset a_str_value=mid(CGI.PATH_INFO,a_int_idx1+1,a_int_idx2-a_int_idx1-1)>
  
    <cfset temp=ArrayAppend(a_arr_path_arguments,a_str_value)>
    <cfset lc=lc+1>
  <cfelse>
    <cfset lc=101>
  </cfif>
</cfloop>


<cfif Arraylen(a_arr_path_arguments) eq 0>
<cfinvoke   
	component = "#application.components.cmp_storage#"   
	method = "ListAllUsers"   
	returnVariable = "a_query_users"
	 >  

<cfparam name="request.current_userkey" default="" type="string">
<!--- Retreive all User Keys  TODO --->
<cfset a_query_userkeys=QueryNew('userkey')>


<cfif len(request.current_userkey) eq 0>
	<cfoutput query="a_query_users">
<!---	<cfif userkey eq "D370A7E6-C445-6EFE-3D5AC109D99DA1EE" >--->
	<a href="index.cfm/#userkey#">#userkey#</a>
<br>
<!---	</cfif>--->
	</cfoutput>
<cfelse>

</cfif>

</cfif>

<cfif ArrayLen(a_arr_path_arguments) gte 1>
<cfset request.securitycontext=structnew()>
<cfset request.usersettings=StructNew()>
<cfset request.securitycontext.myuserkey=#a_arr_path_arguments[1]#>

<cfif a_arr_path_arguments[arraylen(a_arr_path_arguments)] eq "v">
<cfset sEntrykey=a_arr_path_arguments[arraylen(a_arr_path_arguments)-1]>
<cfinvoke   
	component = "#request.a_str_component_storage#"   
	method = "GetFileInformation"   
	returnVariable = "a_struct_file_info"
	entrykey="#sEntrykey#"
	securitycontext="#request.securitycontext#"
	usersettings="#request.usersettings#"></cfinvoke>
	

<cfset q_query_file = a_struct_file_info.q_select_file_info />
<!---	 
<cfheader name="Content-Disposition" value="attachment;filename=#q_select_file.filename#">
--->
<cftry>
	<cfheader name="Last-Modified" value="#dateformat(q_select_file.dt_lastmodified, 'ddd, dd mmm yyyy')#">
	<cfcontent type="#q_select_file.contenttype#" file="#q_select_file.storagepath##request.a_str_dir_separator##q_select_file.storagefilename#">
	<cfcatch>
		file not found
	</cfcatch>
</cftry>


<cfelseif a_arr_path_arguments[arraylen(a_arr_path_arguments)] eq "f">
<!--- File Handling --->
<cfset sEntrykey=a_arr_path_arguments[arraylen(a_arr_path_arguments)-1]>
Showing File:
<cfoutput>#sEntrykey#</cfoutput>
<cfinvoke   
	component = "#request.a_str_component_storage#"   
	method = "GetFileInformation"   
	returnVariable = "q_select_file"
	entrykey="#sEntrykey#"
	securitycontext="#request.securitycontext#"
	usersettings="#request.usersettings#"
	 >  
<cfoutput>
<br>
Name: #q_select_file.filename#<br>
Size: #q_select_file.filesize#<br>
Description: #q_select_file.description#<br>
Content-Type: #q_select_file.contenttype#<br>
Link: <a href="v">Show</a>
</cfoutput>

<cfelse>
<!--- Directory Handling --->

<cfset sDirectorykey="">
<cfif ArrayLen(a_arr_path_arguments) gt 1>
  <cfset sDirectorykey=#a_arr_path_Arguments[ArrayLen(a_arr_path_arguments)]#>
</cfif>

Files from User <cfoutput>#a_arr_path_arguments[1]#</cfoutput>
<cfoutput>
#request.securitycontext.myuserkey#<br>
Active Directory: #sDirectorykey#
</cfoutput>
<cfinvoke   
	component = "#request.a_str_component_storage#"   
	method = "ListAllFiles"   
	returnVariable = "a_struct_files"
	directorykey="#sDirectorykey#"
	securitycontext="#request.securitycontext#"
	usersettings="#request.usersettings#"
	 >  
<br>
<table>
<cfoutput query="a_struct_files.files">
<cfif listfindnocase(ArraytoList(a_arr_contenttypes),#contenttype#)>
<tr><td>
<cfset a_str_suffix="">
<cfif filetype eq "file">
  <cfset a_str_suffix="/f">
</cfif>
<cfset a_str_slash="/">
<a
href="#a_arr_path_arguments[ArrayLen(a_arr_path_arguments)]##a_str_slash##entrykey##a_str_suffix#">#entrykey#</a>
</td>
<td>
#name#</td>
<td>
Typ:#filetype#<br>
</tr>
</cfif>
</cfoutput>
</table>
</cfif>
</cfif>
