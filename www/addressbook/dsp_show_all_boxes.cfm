
<cfset a_int_display_number = q_select_contacts.recordcount - url.startrow>


<cfif a_int_display_number gt a_int_max_rows_per_page>
      <cfset a_int_display_number = a_int_max_rows_per_page>
    <cfelse>
    <cfset a_int_display_number = q_select_contacts.recordcount>
  </cfif>
  
  
  <cfset a_int_third = ceiling(a_int_display_number /  3)>
  	<cfset a_int_two_thirds = ceiling(a_int_display_number / 3)*2>
  <cfif a_int_third lt 1>
    <cfset a_int_third = 1>
  </cfif>

  <table cellpadding="10" cellspacing="0" border="0">
    <tr> 
      <td width="33%" valign="top">
	  <cfset a_int_currentrecord = 0>
	  
	  <!---  startrow="#url.startrow#" maxrows="#a_int_max_rows_per_page#" --->
	  <cfoutput query="q_select_contacts"> 
        <!---<cfinclude template="inc_show_box.cfm">--->
		<cfinclude template="dsp_show_all_single_box.cfm">
		<cfset a_int_currentrecord = a_int_currentrecord + 1>
		
			<cfif (CompareNoCase(a_int_currentrecord, a_int_third) is 0) OR
				  (CompareNoCase(a_int_currentrecord, a_int_two_thirds) is 0)>
        		 </td>
      			<td width="33%"  valign="top">
			</cfif>
	
	   </cfoutput> 
      </td>
    </tr>
  </table>