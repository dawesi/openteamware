<cfparam name="request.a_int_pagesize" default="10" type="numeric">
<cfparam name="url.directorykey" default="" type="string">
<cfparam name="url.startrow" default="1" type="numeric">



<table cellpadding="3" cellspacing="1" bgcolor="#EEEEEE" border="0">
	<cfoutput>
		<tr>
			<cfset QS=CGI.QUERY_STRING>
			<cfset QS=replaceoraddurlparameter(QS,"ordertype","ASC")>
			<cfif url.ordertype eq "ASC">
			   <cfset QS=replaceoraddurlparameter(QS,"ordertype","DESC")>
			</cfif>
			<td class="bb"><a  href="?#ReplaceOrAddURLParameter(QS,"orderby","name")#">#getlangval('sto_wd_filename')#</a></td>
			<td class="bb"><a  href="?#ReplaceOrAddURLParameter(QS,"orderby","filetype")#">#getlangval('sto_wd_type')#</a></td>
			<td class="bb"><a  href="?#ReplaceOrAddURLParameter(QS,"orderby","filesize")#">#getlangval('sto_wd_filesize')#</a></td>
			<td class="bb"><a  href="?#ReplaceOrAddURLParameter(QS,"orderby","userkey")#">#getlangval('sto_wd_username')#</a></td>
			<td class="bb">#getlangval('sto_wd_actions')#</td>
		</tr>
	</cfoutput>

	<cfset a_cmp_user = application.components.cmp_user>
	<cfoutput query="a_query_displayfiles" startrow="#url.startrow#" maxrows="9">
		<cfswitch expression="#a_query_displayfiles.filetype#">
			<cfcase value="directory">
				<tr>
					<td>
						<img alt="folder" width="15" height="13" src="http://www.openTeamWare.com/storage/images/smallfolder.gif">&nbsp;
						<a href="#a_query_displayfiles.name#/">#a_query_displayfiles.name# <cfif a_query_displayfiles.specialtype lte 0>(#a_query_displayfiles.filescount#)</cfif></a><br>
					</td>
					<td>
						#a_query_displayfiles.filetype#
					</td>
					<td>
					</td>
					<td>
						<cfset a_str_username=a_cmp_user.GetUsernamebyentrykey(
							entrykey=a_query_displayfiles.userkey) >  
						#a_str_username#&nbsp;
					</td>
					<td>
						<cfif a_query_displayfiles.specialtype lte 0 >
						<a href="default.cfm?action=EditFolder&entrykey=#a_query_displayfiles.entrykey#&currentdir=#url.directorykey#">#si_img('pencil')#
						</a>
						|
						<a href="default.cfm?action=DeleteFolder&entrykey=#a_query_displayfiles.entrykey#&parentdirectorykey=#url.directorykey#&currentdir=#url.directorykey#"><img width="12" height="12" alt="del" src="/images/del.gif" border="0"></a>
						</cfif>
					</td>
				</tr>
			</cfcase>
			<cfcase value="file">
				<tr bgcolor="white">
					<td>
						<img width="13" height="16" alt="text" align="absmiddle" src="http://www.openTeamWare.com/storage/images/icon_txt.gif">&nbsp;<a href="#a_query_displayfiles.name#">#a_query_displayfiles.name#</a><br>
					</td>
					<td>
						#a_query_displayfiles.contenttype#
					</td>
					<td align="right">
						#byteConvert(a_query_displayfiles.filesize)#
					</td>
					<td>
						<cfset a_str_username=a_cmp_user.GetUsernamebyentrykey(
							entrykey=a_query_displayfiles.userkey) >  
						#a_str_username#&nbsp;
					</td>
					<td>
						<a href="#a_query_displayfiles.name#/i"><img width="12" height="12" alt="info" src="/images/info.jpg" border="0"></a>
					</td>
				</tr>
			</cfcase>
		</cfswitch>
	</cfoutput>
</table>



<cfoutput>
	<cfset endrecord=request.a_int_pagesize+url.startrow-1>
	<cfif endrecord gt a_query_displayfiles.recordcount>
	        <cfset endrecord=a_query_displayfiles.recordcount>
	</cfif>
	<cfif a_query_displayfiles.recordcount lte 0 >
        <cfoutput>
                #getlangval('odb_ph_nodatafound')#<br><br>
        </cfoutput>
	<cfelse>
        <cfoutput>
	        #replace(replace(replace(getlangval('odb_ph_xtozfromyrecords'),'%y%',a_query_displayfiles.recordcount),'%x%',startrow),"%z%",endrecord)#
        </cfoutput> </b>
		<br>
        <cfif url.startrow gt 1 >
	        <a href="default.cfm?#ReplaceOrAddURLParameter(QUERY_STRING,"startrow",1)#">#getlangval('odb_wd_first')#</a>
	        <a href="default.cfm?#ReplaceOrAddURLParameter(QUERY_STRING,"startrow",startrow-request.a_int_pagesize)#">&lt;&lt;
			</a>
        <cfelse>
	        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        </cfif>
        <cfif (url.startrow+ request.a_int_pagesize) lte a_query_displayfiles.recordcount >
	        <a href="default.cfm?#ReplaceOrAddURLParameter(QUERY_STRING,"startrow",startrow+request.a_int_pagesize)#">&gt;&gt;
			</a>
	        <a href="default.cfm?#ReplaceOrAddURLParameter(QUERY_STRING,"startrow",a_query_displayfiles.recordcount)#">#getlangval('odb_wd_last')#</a>
        </cfif>
	</cfif>
</cfoutput>

<br><br>
