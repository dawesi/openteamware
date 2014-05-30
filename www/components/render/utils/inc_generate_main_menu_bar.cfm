<!--- //

	Component:	Render
	Function:	GenerateMainMenuBar
	Description:
	
// --->

<cfset a_bol_force_header = StructKeyExists(url, 'includeheader') AND (url.includeheader IS 1)>

<cfif (
		(ListFindNoCase('action,inpage', request.a_struct_current_service_action.type) GT 0)
		OR
		(ListFindNoCase(request.a_struct_current_service_action.attributes,'noheader') GT 0)
	  )
	  AND NOT
	  	a_bol_force_header>
	<cfexit method="exittemplate">
</cfif>



<!--- display top menu ... --->
<nav class="navbar navbar-default navbar-fixed-top" role="navigation">
  <div class="container-fluid">
    <div class="navbar-header">
      <a class="navbar-brand" href="/" title="<cfoutput>#GetLangVal('cm_wd_home')#</cfoutput>">otw</a>
    </div>

    <!-- Collect the nav links, forms, and other content for toggling -->
    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
      <ul class="nav navbar-nav">
        <cfoutput><li class="dropdown">
          <a href="##" class="dropdown-toggle" data-toggle="dropdown">#GetLangVal('cm_wd_new')# <b class="caret"></b></a>
          <ul class="dropdown-menu">
            <li><a href="/addressbook/?action=CreateNewItem&datatype=0">#GetLangval('cm_wd_contact')#</a></li>
            <li><a href="/addressbook/?action=CreateNewItem&datatype=1">#GetLangval('cm_wd_account')#</a></li>
            <li><a href="/project/?action=NewProject&type=1">#GetLangval('crm_ph_project_type_1')#</a></li>
            <li class="divider"></li>
            <li><a href="/calendar/index.cfm?action=ShowNewEvent">#GetLangval('cm_wd_appointment')#</a></li>
            <li><a href="/tasks/index.cfm?action=newtask">#GetLangval('cm_wd_task')#</a></li>
          </ul>
        </li>
		<li>
			<a href="/crm/?action=activities"><cfoutput>#GetLangVal('adrb_wd_activities')#</cfoutput></a>
		</li>
	   	<li>
	    	<a href="/addressbook/index.cfm?filterdatatype=0"><cfoutput>#GetLangVal('cm_wd_contacts')#</cfoutput></a>
	    </li>
	    <li>
	     	<a href="/addressbook/index.cfm?filterdatatype=1"><cfoutput>#GetLangVal('crm_wd_accounts')#</cfoutput></a>
	     </li>	
	     <li>
			<a href="/project"><cfoutput>#GetLangval('cm_wd_projects')#</cfoutput></a>
		</li>
		</cfoutput>
      </ul>
      <!--- <form class="navbar-form navbar-left" role="search">
        <div class="form-group">
          <input type="text" class="form-control" placeholder="Search">
        </div>
        <button type="submit" class="btn btn-default">Submit</button>
      </form> --->
      <ul class="nav navbar-nav navbar-right">
        <li><a href="#"></a></li>
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown"><cfoutput>#htmleditformat(request.stSecurityContext.myusername)#</cfoutput> <b class="caret"></b></a>
          <ul class="dropdown-menu">
            <li><a href="/settings/"><cfoutput>#GetLangVal('cm_wd_preferences')#</cfoutput></a></li>
            <li><a target="_top" onclick="ShowLogoutDialog();return false;" href="/logout.cfm"><cfoutput>#GetLangVal('cm_wd_logout')#</cfoutput></a></li>
          </ul>
        </li>
      </ul>
    </div><!-- /.navbar-collapse -->
  </div><!-- /.container-fluid -->
</nav>

<div style="clear:both"></div>

<!--- 		
 --->

<div class="div_top_header_info" id="id_top_header_navigation">
openTeamware.com &gt;
<span id="id_span_header_top_info"></span>	
<span><a href="#" class="nl"><img src="/images/space_1_1.gif" class="si_img" /></a></span>
</div>

<div style="clear:both"></div>

