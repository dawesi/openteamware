 <!--- wie oft hat dieser benutzer bereits dieses und jenes gesehen? --->
<cfparam name="atttributes.userid" default="0">
<cfparam name="attributes.section" default="">
<cfparam name="attributes.page" default="">
<cfparam name="attributes.param1" default="">
<cfparam name="attributes.param2" default="">
<!--- only query or also update? --->
<cfparam name="attributes.queryonly" default="false" type="boolean">

<cfinclude template="queries/q_check_entry.cfm">

<cfif q_check_entry.count_id is 0>
  <!--- entry erstellen --->
  <cfinclude template="queries/q_insert.cfm">

  <!--- tutti kompletti neue werte --->
  <!--- null ... noch nie gesehen --->
  <cfset caller.PersonTimesSeen = 0>
  <cfset caller.firstvisit = now()>
  <cfset caller.lastvisit = now()>
  <cfelse>
  
  <!--- die gespeichterten werte holen und zurückliefern --->
  <cfinclude template="queries/q_get_old_values.cfm">
	

  <cfset caller.PersonTimesSeen = q_get_old_values.Timesseen>
  <cfset caller.firstvisit = q_get_old_values.firstvisit>
  <cfset caller.lastvisit = q_get_old_values.lastvisit>
  <cfset acount = val(q_get_old_values.timesseen) + 1>
  
  <cfinclude template="queries/q_update.cfm">
</cfif>
