<!--- load now --->
<cfset q_select_clickstream = application.components.cmp_history.LoadClickStream(request.stSecurityContext.myuserkey, 5)>

<table width="100%" border="0" cellspacing="0" cellpadding="2">
  <tr>
	<td class="b_all" style="letter-spacing:2px;font-size:10px;text-transform:uppercase;">
	&nbsp;<b><img src="/images/icon/notizen.gif" width="12" height="12" align="absmiddle" hspace="3" vspace="3" border="0"> Zuletzt verwendet</b>
	</td>
  </tr>
  <tr>
  	<td>
	
	<table width="100%" border="0" cellspacing="0" cellpadding="4">
      <cfoutput query="q_select_clickstream"> 
        <tr id="idtrrecentlyvisited#q_select_clickstream.currentrow#" onMouseOver="hilite(this.id);"  onMouseOut="restore(this.id);"> 
          <td <cfif q_select_clickstream.currentrow GT 1>class="bdashedtop"</cfif>> 
            <cfif len(q_select_clickstream.servicekey) gt 0>
              <cfset a_str_image_name = q_select_clickstream.servicekey>
              <cfelse>
              <cfset a_str_image_name = "space_1_1">
            </cfif>
			&nbsp;<a href="#q_select_clickstream.href#" title="#htmleditformat(q_select_clickstream.pagename)#"><img src="/images/icon/services/#a_str_image_name#.gif" width="12" height="12" hspace="0" vspace="0" border="0" align="absmiddle"> 
            #htmleditformat(Mid(q_select_clickstream.pagename, 1, 35)&" ...")#</a> </td>
        </tr>
      </cfoutput> 
    </table>
	
	</td>
  </tr>
 </table>