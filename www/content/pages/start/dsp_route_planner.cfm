<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserdata" returnvariable="stReturn">
	<cfinvokeargument name="entrykey" value="#request.stSecurityContext.myuserkey#">
</cfinvoke>
<cfset q_user_data = stReturn.query>

<table width="100%" border="0" cellspacing="0" cellpadding="2">
  <tr> 
    <td class="b_all" style="letter-spacing:2px;font-size:10px;text-transform:uppercase;"> 
      &nbsp;
	  <a href="/extras/default.cfm?action=routeplanner"><b><cfoutput>#GetLangVal("start_wd_routeplanner")#</cfoutput></b></a>
	  </td>
  </tr>
  <form action="/extras/show_goto_route_planner.cfm" method="get" target="_blank">
  
  <cfoutput>
  <input type="hidden" name="frmstreet1" value="#htmleditformat(q_user_data.address1)#">
  <input type="hidden" name="frmzipcode1" value="#htmleditformat(q_user_data.plz)#">
  <input type="hidden" name="frmcity1" value="#htmleditformat(q_user_data.city)#">
  <input type="hidden" name="frmcountry1" value="<cfif ListFindNoCase('Deutschland,Germany', q_user_data.country) GT 0>de<cfelse>at</cfif>">
  </cfoutput>
    <tr> 
      <td>
	  	<table border="0" cellspacing="0" cellpadding="5">
		  <tR>
		  	<td colspan="2" class="addinfotext">
			<cfoutput>#GetLangVal("extras_wd_startaddress")#</cfoutput>: <cfoutput>#htmleditformat(q_user_data.address1)#, #htmleditformat(q_user_data.plz)# #htmleditformat(q_user_data.city)#, #htmleditformat(q_user_data.country)#</cfoutput>
			</td>
		  </tR>
		  <tr>
		  	<td colspan="2">
			<cfoutput>#GetLangVal("start_ph_routeplanner_enterdestinationaddress")#</cfoutput>
			</td>
		  </tr>
          <tr> 
            <td align="right">Strasse:</td>
            <td><input type="text" name="frmstreet2" size="25" maxlength="150" value=""></td>
          </tr>
          <tr> 
            <td align="right">
				<cfoutput>#GetLangVal("extras_wd_postcode")#</cfoutput>:
			</td>
            <td><input type="text" name="frmzipcode2" size="10" maxlength="10" value=""></td>
          </tr>
          <tr> 
            <td align="right">Ort:</td>
            <td><input type="text" name="frmcity2" size="25" maxlength="150" value=""></td>
          </tr>
          <tr> 
            <td align="right">Land:</td>
            <td> <select name="frmcountry2">
                <option value='at' >Oesterreich (A)</option>
                <option value='de' >Deutschland (D)</option>
                <option value='ad' >Andorra (AND)</option>
                <option value='be' >Belgien (B)</option>
                <option value='dk' >D&auml;nemark (DK)</option>
                <option value='fr' >Frankreich (F)</option>
                <option value='gb' >Groszbritannien (GB)</option>
                <option value='ie' >Irland (IE)</option>
                <option value='it' >Italien (I)</option>
                <option value='li' >Liechtenstein (FL)</option>
                <option value='lu' >Luxemburg (L)</option>
                <option value='mc' >Monaco (MC)</option>
                <option value='nl' >Niederland (NL)</option>
                <option value='no' >Norwegen (N)</option>
                <option value='pt' >Portugal (P)</option>
                <option value='sm' >San Marino (RSM)</option>
                <option value='ch' >Schweiz (CH)</option>
                <option value='es' >Spanien (E)</option>
                <option value='se' >Schweden (S)</option>
              </select> </td>
          </tr>
          <tr>
		  	<td></td>
            <td> <input type="submit" name="frmsubmit" style="font-weight:bold;" value="<cfoutput>#htmleditformat(GetLangVal('start_ph_show_routing_now'))#</cfoutput>"> 
            </td>
          </tr>
        </table></td>
    </tr>
  </form>
</table>
