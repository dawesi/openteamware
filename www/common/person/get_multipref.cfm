<!--- array holding the structures ... --->
<cfparam name="attributes.LoadMultiPrefArray" type="array">

<!--- works only in request scope ... --->
<!---<cfdump var="#attributes#">--->

<cfif ArrayLen(attributes.LoadMultiPrefArray) IS 0>
	<!--- no items provided --->
	<cfexit method="exittemplate">
</cfif>

<cfset a_str_check_keys = ''>

<!--- create the md5 keys --->
<cfloop from="1" to="#arrayLen(attributes.LoadMultiPrefArray)#" index="ii">
	<!--- set found default to false --->
	<cfset attributes.LoadMultiPrefArray[ii].found = false>
	<!--- create md5 hash --->
	<cfset attributes.LoadMultiPrefArray[ii].md5 = Hash(attributes.LoadMultiPrefArray[ii].entrysection & attributes.LoadMultiPrefArray[ii].entryname)>
	
	<cfset a_str_check_keys = ListAppend(a_str_check_keys, attributes.LoadMultiPrefArray[ii].md5)>
</cfloop>

<cfquery name="q_select_multi_entry" datasource="#request.a_str_db_tools#">
SELECT
	entryvalue1,
	entrysection,
	entryname,
	md5_section_entryname
FROM
	userpreferences
WHERE
	(userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">)
	AND
	(md5_section_entryname IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_check_keys#" list="yes">))
; 
</cfquery>

<cfloop query="q_select_multi_entry">
	<!--- check value, if found set and delete --->

		<cfloop from="1" to="#arrayLen(attributes.LoadMultiPrefArray)#" index="ii">
			
			<cfif Compare(attributes.LoadMultiPrefArray[ii].md5, q_select_multi_entry.md5_section_entryname) IS 0>
				<!--- found! --->

				<cfif Len(attributes.LoadMultiPrefArray[ii].setcallervariable) GT 0>
					<cfset "caller.#attributes.LoadMultiPrefArray[ii].setcallervariable#" = q_select_multi_entry.entryvalue1>
					
					<!--- set found! --->
					<cfset attributes.LoadMultiPrefArray[ii].found = true>
				</cfif>
				
			</cfif>
		</cfloop>
		
</cfloop>

<cfloop from="1" to="#arrayLen(attributes.LoadMultiPrefArray)#" index="ii">
	<cfif NOT attributes.LoadMultiPrefArray[ii].found>
		<!--- set default value --->
		<cfif Len(attributes.LoadMultiPrefArray[ii].setcallervariable) GT 0>
			<cfset "caller.#attributes.LoadMultiPrefArray[ii].setcallervariable#" = attributes.LoadMultiPrefArray[ii].defaultvalue>
		</cfif>		
	</cfif>
</cfloop>