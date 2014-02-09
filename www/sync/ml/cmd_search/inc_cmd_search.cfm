<cfcontent type="text/xml"> 
<cfset request.a_struct_response_headers.type = 'text/xml'>
<cfheader statuscode="207">
<cfset request.a_struct_response_headers.statuscode = 207>

<!--- 2 do

	load list of ignored items and remove them from the query
	
	--->
	
<!--- check if in backup mode ... in this case remove all rows from the query so that every time all contacts are transferred --->
<cfset request.a_bol_backup_mode = false>

<cfset a_str_field_list = "">
<cfset a_bol_diff_select = false>
<cfset a_bol_select_by_id = false>
<cfset a_struct_filter = StructNew()>



<cflog text="hello from inc_cmd_search" type="Information" log="Application" file="ib_syncml">

<!--- parse the SQL and set th properties for searching (filter, field_list) and for displaying (diff_select) --->
<cfscript>
	elements = XmlSearch(request.a_struct_action.a_xml_obj, "//D:sql");
	a_str_sql_select = Trim(elements[1].XmlText);
	
	// replace all line breaks ...
	a_str_sql_select = ReplaceNoCase(a_str_sql_select, chr(13), ' ', 'ALL');
	a_str_sql_select = ReplaceNoCase(a_str_sql_select, chr(10), ' ', 'ALL');
	a_str_sql_select = ReplaceNoCase(a_str_sql_select, '  ', ' ', 'ALL');
	
	a_str_diff_select = 'Select "http://schemas.microsoft.com/repl/repl-uid" AS repluid, "DAV:getlastmodified" AS getlastmodified, "DAV:creationdate" AS creationdate, "DAV:href" AS href, "DAV:isfolder" AS isfolder FROM';
	a_str_where_clause = 'where "http://schemas.microsoft.com/repl/repl-uid" =';
	
	// added by hansjoerg posch 17.08.05 ... calendar seems to use the ( in this clause
	a_str_where_clause_2 = 'where ("http://schemas.microsoft.com/repl/repl-uid" =';
</cfscript>

<!---<cflog text="a_str_sql_select: #a_str_sql_select#" type="Information" log="Application" file="ib_syncml">--->

<cfscript>
	a_str_clause = 'empty';
	
	//Initialize the field list and flag if it is only diff select
	if (Find(a_str_diff_select, a_str_sql_select) GT 0) {
		a_str_field_list = "entrykey,dt_lastmodified,dt_created";
		a_bol_diff_select = true;
	}

	//Intialize the filter (parse the where clause of the SQL select)
	/*
	a_int_where_start_pos = Find(a_str_where_clause, a_str_sql_select);
	if (a_int_where_start_pos GT 0) {
		a_str_clause = Mid(a_str_sql_select, a_int_where_start_pos + 5, Len(a_str_sql_select) - a_int_where_start_pos + 1 );
		a_str_clause = Replace(a_str_clause, ' "http://schemas.microsoft.com/repl/repl-uid" = ''rid:', '', "All");
		a_str_clause = Replace(a_str_clause, ''' OR', ',', "All");
		a_str_clause = Left(a_str_clause, Len(a_str_clause) - 1); 
		a_struct_filter.entrykeys = a_str_clause;
		a_bol_select_by_id = true;
	}
	*/
	
	// new: edited some points ... a) removed the space before http://schemas ... and added to replace the ( and )
	a_int_where_start_pos = Find(a_str_where_clause_2, a_str_sql_select);
	
	if (a_int_where_start_pos GT 0)
		{
		
		// new way to parse ... parse through the select statement and find all rid: elements
		a_str_found_entrykeys = '';
	
		for(ii=1; ii LT Len(a_str_sql_select); ii = ii + 1)
			{
			a_arr_re = ReFindNoCase('''rid:[a-z,0-9,\-]*', a_str_sql_select, ii, "true");
			
			if (a_arr_re.len[1] GT 0)
				{
				a_str_hit = Mid(a_str_sql_select, a_arr_re.pos[1], a_arr_re.len[1]);
				
				a_str_hit = ReplaceNoCase(a_str_hit, '''rid:', '');
				
				if (ListFindNoCase(a_str_found_entrykeys, a_str_hit) IS 0)
					{
					a_str_found_entrykeys = ListAppend(a_str_found_entrykeys, a_str_hit);
					}
				}
			
			}
			
		/*a_str_clause = Mid(a_str_sql_select, a_int_where_start_pos + 5, Len(a_str_sql_select));
		
		
		a_str_clause = Replace(a_str_clause, '"http://schemas.microsoft.com/repl/repl-uid" = ''rid:', '', "All");
		a_str_clause = Replace(a_str_clause, ''' OR', ',', "All");
		a_str_clause = Replace(a_str_clause, '(', '', "All");
		a_str_clause = Replace(a_str_clause, ')', '', "All");
		a_str_clause = Left(a_str_clause, Len(a_str_clause) - 1); 
		a_str_clause = trim(a_str_clause);
		a_struct_filter.entrykeys = a_str_clause*/
		
		// Set entrykey filter now
		a_struct_filter.entrykeys = a_str_found_entrykeys;		
		
		a_str_clause = a_str_found_entrykeys;

		a_bol_select_by_id = true;
		}	
		
	// replace '
	a_str_clause = Replace(a_str_clause, '''', '', "All");
	a_str_clause = ReplaceNoCase(a_str_clause, ' ', '', 'ALL');
	
	/*
	if (FindNoCase('AND not "', a_str_clause) GT 0)
		{
		a_str_clause = Mid(a_str_clause, 1, (FindNoCase('AND not "', a_str_clause)-1));
		}
	*/

</cfscript>


<cfif IsDefined('a_str_clause')>
<!---<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="a_str_clause: #a_str_clause#">
a_str_sql_select: #a_str_sql_select#


a_str_clause: #a_str_clause#
</cfmail>--->
</cfif>

<!---

	new trick of the software: it checks for an item that already exists in the syncsource ...
	
	where "urn:schemas:contacts:givenName"='Cnmtmgtmjm' and "urn:schemas:contacts:sn" is null  and "urn:schemas:contacts:middlename" is null  and "urn:schemas:contacts:email1" is null 

	We still have to implement that ... does not work yet.	
	
	Therefore we set a dummy entrykey that is NOT found
	
	<cfset a_struct_filter.fields = StructNew()>
	<cfset a_struct_filter.fields.surname = ...
	<cfset a_struct_filter.fields.email_prim = ...
	<cfset a_struct_filter.fields.firstname = ...
	--->
	
<!--- structure holding the filter internally for a simple query of query comparison ... --->
<cfset a_struct_internal_filter = StructNew()>
	
<!--- check if the select statements contains checks for the address book --->
<cfif FindNoCase('where "urn:schemas:contacts:givenName', a_str_sql_select) GT 0>
	<cfset a_struct_internal_filter.firstname = GetWebDAVSqlWhereAttribute(a_str_sql_select, 'urn:schemas:contacts:givenName')>
	<cfset a_struct_internal_filter.surname = GetWebDAVSqlWhereAttribute(a_str_sql_select, 'urn:schemas:contacts:sn')>
	<cfset a_struct_internal_filter.email_prim = GetWebDAVSqlWhereAttribute(a_str_sql_select, 'urn:schemas:contacts:email1')>
	
	<cflog text="parse for given name: #GetWebDAVSqlWhereAttribute(a_str_sql_select, 'urn:schemas:contacts:givenName')#" type="information" log="application" file="ib_syncml">
	<cflog text="parse for first name: #GetWebDAVSqlWhereAttribute(a_str_sql_select, 'urn:schemas:contacts:sn')#" type="information" log="application" file="ib_syncml">
	<cflog text="parse for email1: #GetWebDAVSqlWhereAttribute(a_str_sql_select, 'urn:schemas:contacts:email1')#" type="information" log="application" file="ib_syncml">

</cfif>

<!--- check if the select statements contains checks for the calendar --->
<cfif FindNoCase('where ("urn:schemas:calendar:dtstart"=CAST', a_str_sql_select) GT 0>
	
	<cfset a_struct_internal_filter.date_start = GetWebDAVSqlWhereAttribute(a_str_sql_select, 'urn:schemas:calendar:dtstart')>
	<cfset a_struct_internal_filter.date_end = GetWebDAVSqlWhereAttribute(a_str_sql_select, 'urn:schemas:calendar:dtend')>	
	<cfset a_struct_internal_filter.location = GetWebDAVSqlWhereAttribute(a_str_sql_select, 'urn:schemas:calendar:location')>	
	
	<cflog text="parse for date start: #GetWebDAVSqlWhereAttribute(a_str_sql_select, 'urn:schemas:calendar:dtstart')#" type="Information" log="Application" file="ib_syncml">
	<cflog text="parse for date end: #GetWebDAVSqlWhereAttribute(a_str_sql_select, 'urn:schemas:calendar:dtend')#" type="Information" log="Application" file="ib_syncml">
</cfif>



<cfif StructKeyExists(a_struct_filter, 'entrykeys')>
	<cflog text="a_struct_filter.entrykeys: #a_struct_filter.entrykeys#" type="Information" log="Application" file="ib_syncml">
<cfelse>
	<cflog text="no entrykeys filter exist" type="Information" log="Application" file="ib_syncml">
</cfif>

<!--- load ignore items! items which have been "deleted" and therefore should not be loaded ... --->
<cfquery name="q_select_ignore_items" datasource="#request.a_str_db_tools#">
SELECT
	entrykey
FROM
	mobilesync_deleted_items_ignore
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.a_struct_security_context.myuserkey#">
;
</cfquery>

<!--- searching for contacts --->
<cfif CompareNoCase(request.a_struct_action.a_str_itemtype, request.a_str_url_identifier_contacts) IS 0>
	
	<cfinclude template="inc_cmd_search_contacts.cfm">


<!--- searching for calendar --->
<cfelseif CompareNoCase(request.a_struct_action.a_str_itemtype, request.a_str_url_identifier_calendar) IS 0>
	
	<cfinclude template="inc_cmd_search_calendar.cfm">

<!--- searching for tasks --->
<cfelseif CompareNoCase(request.a_struct_action.a_str_itemtype, request.a_str_url_identifier_tasks) IS 0>
	
	<cfinclude template="inc_cmd_search_tasks.cfm">

<!--- searching for notes --->
<cfelseif CompareNoCase(request.a_struct_action.a_str_itemtype, request.a_str_url_identifier_notes) IS 0>
	<cfheader statuscode="404">
	<cfset request.a_struct_response_headers.statuscode = 404>
<cfelse>
	<cfthrow message="Invalid request" detail="Requested type '#request.a_struct_action.a_str_itemtype#' is not supported."/>
</cfif>
