<cfset stReturn_tasks = request.a_ws_tasks.GetTasks(securitycontext = request.a_struct_security_context,
						filter = a_struct_filter,
						search = '',
						orderby = '', 
						orderbydesc = false,
						loadnotice = true,
						createcategorylist = false)>	
						
<cfset q_select_tasks = stReturn_tasks.q_select_tasks>


<cfmodule template="/common/person/getuserpref.cfm"
	entrysection = "mobilesync"
	entryname = "restrictions_tasks"
	defaultvalue1 = "open"
	savesettings = true
	userid = #request.a_struct_security_context.myuserid#
	setcallervariable1 = "a_str_restriction_tasks">		
	
<cfswitch expression="#a_str_restriction_tasks#">

	<cfcase value="all">
		<!--- include all tasks ... --->
	</cfcase>
	<cfdefaultcase>
		<!--- include only open tasks ... --->
		
		<cfquery name="q_select_tasks" dbtype="query">
		SELECT
			*
		FROM
			q_select_tasks
		WHERE
			NOT status IN (0)
		;
		</cfquery>
		
	</cfdefaultcase>

</cfswitch>

<!--- remove ignore items ... --->
<cfif q_select_ignore_items.recordcount GT 0>

	<cfquery name="q_select_tasks" dbtype="query">
	SELECT
		*
	FROM
		q_select_tasks
	WHERE
		NOT entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ValueList(q_select_ignore_items.entrykey)#" list="yes">)
	;
	</cfquery>
</cfif>


<?xml version="1.0" ?> 
<a:multistatus xmlns:a="DAV:" xmlns="<cfoutput>#xmlformat(request.a_struct_action.path_info)#</cfoutput>">
	<cfif q_select_tasks.recordcount EQ 0>
		<cfif a_bol_select_by_id>
			<cfheader statuscode="404">
			<cfset request.a_struct_response_headers.statuscode = 404>
		</cfif>
	<cfelse>
		<cfoutput query="q_select_tasks">
		<a:response> 
			<a:href>#xmlformat('http://' & cgi.SERVER_NAME & request.a_struct_action.path_info & q_select_tasks.entrykey)#</a:href>
			<a:propstat>
				<a:status>HTTP/1.1 200 OK</a:status>
				<a:prop>
					<repluid>rid:#q_select_tasks.entrykey#</repluid>
					<isfolder>0</isfolder>
					<getlastmodified>#DateFormat(q_select_tasks.dt_lastmodified, "yyyy-mm-dd")# #TimeFormat(q_select_tasks.dt_lastmodified, "HH:mm:ss")#</getlastmodified>
				<cfif a_bol_diff_select>
					<creationdate>#DateFormat(q_select_tasks.dt_created, "yyyy-mm-dd")# #TimeFormat(q_select_tasks.dt_created, "HH:mm:ss")#</creationdate>
					<href>#q_select_tasks.entrykey#</href>
				<cfelse>
					<subject>#XMLFormat(q_select_tasks.title)#</subject>
					<textdescription>#XMLFormat(q_select_tasks.notice)#</textdescription>
					<cfif Len(Trim(q_select_tasks.dt_due)) GT 0>
					<date>#DateFormat(q_select_tasks.dt_due, "yyyy-mm-dd")# #TimeFormat(q_select_tasks.dt_due, "HH:mm:ss")#</date>
					<cfelse>
					<date/>
					</cfif>
				</cfif>  
				</a:prop>
			</a:propstat>
		</a:response>
		</cfoutput>
	</cfif>
</a:multistatus>