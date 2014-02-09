  <cfquery name="q_get_old_values"  datasource="#request.a_str_db_tools#">
  SELECT timesseen,firstvisit,lastvisit from scenarioseen WHERE (userid = 
  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.userid#">
  ) AND (pagesection = 
  <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.section#">
  ) AND (pagename = 
  <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.page#">
  ); 
  </cfquery>