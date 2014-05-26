<!--- //



	display the lastest visists ...

	

	// --->
<cfif NOT CheckSimpleLoggedIn()>
  <cfexit method="exittemplate">
</cfif>

<!--- load query holding the data ... --->
<cfset q_select_clickstream = application.components.cmp_history.LoadClickStream(request.stSecurityContext.myuserkey, 5)>
<cfif q_select_clickstream.recordcount lte 1>
  <!--- only the current page is logged ... do not display this box ... --->
  <cfexit method="exittemplate">
</cfif>
<tr class="NavLeftTableHeader"> 
  <td class="NavLeftTableHeaderFont"> <img src="/images/nav/button_vor.gif" hspace="2" vspace="2" border="0" align="absmiddle"> 
    Zuletzt besucht ... </td>
</tr>
<tr> 
  <td> 
    <!---<cfdump var="#q_select_clickstream#">--->
    <table width="100%" border="0" cellspacing="0" cellpadding="2">
      <cfoutput query="q_select_clickstream"> 
        <tr> 
          <td> 
            <cfif len(q_select_clickstream.servicekey) gt 0>
              <cfset a_str_image_name = q_select_clickstream.servicekey>
              <cfelse>
              <cfset a_str_image_name = "space_1_1">
            </cfif> <a href="#q_select_clickstream.href#" title="#htmleditformat(q_select_clickstream.pagename)#"><img src="/images/icon/services/#a_str_image_name#.gif" width="12" height="12" hspace="0" vspace="0" border="0" align="absmiddle"> 
            #htmleditformat(Mid(q_select_clickstream.pagename, 1, 16)&" ...")#</a> </td>
        </tr>
      </cfoutput> 
      <tr> 
        <td> <img src="/images/space_1_1.gif" width="12" height="12" hspace="0" vspace="0" border="0" align="absmiddle"> 
          <a href="/extras/index.cfm?action=clickstream">mehr ...</a> </td>
      </tr>
    </table>
	</td>
</tr>
