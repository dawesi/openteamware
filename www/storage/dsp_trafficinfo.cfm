<cfinvoke   
	component = "#application.components.cmp_storage#"   
	method = "GetTrafficInfo"   
	returnVariable = "q_query_traffic"   
	securitycontext="#request.stSecurityContext#">
</cfinvoke>

<cfset tmp = SetHeaderTopInfoString('Traffic')>
<cfoutput>
<table border="0" cellspacing="0" cellpadding="4">
  <tr>
    <td>Status:</td>
    <td>
		#ByteConvert(q_query_traffic.kbused)#
	</td>
  </tr>
  <tr>
    <td>Tages-Limit:</td>
    <td>
		#ByteConvert(q_query_traffic.kblimit)#
	</td>
  </tr>
</table>
</cfoutput>
