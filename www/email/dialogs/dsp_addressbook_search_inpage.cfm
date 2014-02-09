<!--- //

	Module:		Email
	Action:		ShowAddressBookSearchInpage
	Description: 
	

// --->

<!--- search string --->
<cfparam name="url.search" default="" type="string">

<!--- check sort order --->
<cfset url.sort = GetUserPrefPerson('email', 'adressbooksortorder', 'dt_lastcontact', 'url.sort', true) />

<cfif ListFindNoCase("surname,company,dt_lastcontact", url.sort) is 0>
	<cfset url.sort = "dt_lastcontact" />
</cfif>

<!--- autoclose on click? --->
<cfset a_str_autoclose = GetUserPrefPerson('email', 'addressbookautoclose', '0', '', false) />

<cfinvoke component="#application.components.cmp_customer#" method="GetCompanyContacts" returnvariable="q_select_company_contacts">
	<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
</cfinvoke>

<cfquery name="q_select_is_company_admin" dbtype="query">
SELECT
	*
FROM
	q_select_company_contacts
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
;
</cfquery>

<cfsavecontent variable="a_str_js">
function UpdateHeights() {
	$('#id_body').css('overflow', 'auto');
	$('#id_body').css('height', 'auto');
	return true;
	}
		
function AddTo(adr) {
	var TempTo = parent.document.sendform.mailto.value;
	var EmailAddress = eval("document.frmAdressbookData.adr"+adr).value;
	var afound = TempTo.indexOf(EmailAddress);

	if (afound > -1) {
		alert('Adresse wurde bereits hinzugefuegt!');
		return;
		}

    if (TempTo.length == 0) {
      	parent.document.sendform.mailto.value = EmailAddress;
    	}
    		else {
      			parent.document.sendform.mailto.value = TempTo + ', ' + EmailAddress;
    			}

	<cfif a_str_autoclose is 1>
	parent.ShowOrHideAddressbook();
	</cfif>
  	}

function AddCC(adr)

	{

	var TempCC = "";

	var EmailAddress = "";

	var afound = -1;

	TempCC = parent.document.sendform.mailcc.value;

	EmailAddress = eval("document.frmAdressbookData.adr"+adr).value;

	parent.Showccfield();	

	afound = TempCC.indexOf(EmailAddress);

	

	if (afound > -1)

		{

		alert('Adresse wurde bereits hinzugefuegt!');

		return;

		}

  

    if (TempCC.length == 0)

    	{

      	parent.document.sendform.mailcc.value = EmailAddress;

    	}

    		else

    			{

      			parent.document.sendform.mailcc.value = TempCC + ', ' + EmailAddress;

    			}

				

	<cfif a_str_autoclose is 1>

	parent.ShowOrHideAddressbook();

	</cfif>

			

	}

function AddBCC(adr)

	{

	var TempBCC = "";

	var EmailAddress = "";

	var afound = -1;

	TempBCC = parent.document.sendform.mailbcc.value;

	EmailAddress = eval("document.frmAdressbookData.adr"+adr).value;

	parent.Showbccfield();	

	afound = TempBCC.indexOf(EmailAddress);

	

	if (afound > -1)

		{

		alert('Adresse wurde bereits hinzugefuegt!');

		return;

		}

  

    if (TempBCC.length == 0)

    	{

      	parent.document.sendform.mailbcc.value = EmailAddress;

    	}

    		else

    			{

      			parent.document.sendform.mailbcc.value = TempBCC + ', ' + EmailAddress;

    			}

	<cfif a_str_autoclose is 1>

	parent.ShowOrHideAddressbook();

	</cfif>

					

	}
</cfsavecontent>

<cfset tmp = AddJSToExecuteAfterPageLoad('', a_str_js) />


<cfset a_struct_filter = StructNew() />

<!--- set possible filters ... --->
<cfset a_struct_filter.search = url.search>

<cfset a_struct_loadoptions = StructNew() />
<cfset a_struct_loadoptions.maxrows = 50 />

<!--- load contacts ... --->
<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="fieldlist" value="company,surname,firstname,b_telephone,p_telephone,email_prim,username,b_mobile,lastemailcontact,p_mobile,reupdateavaliable,categories,company,lastsmssent,archiveentry,email_adr">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="loadoptions" value="#a_struct_loadoptions#">
</cfinvoke>

<cfset q_select_adrb = stReturn.q_select_contacts />

<cfquery name="q_select_adrb" dbtype="query">
SELECT
	*
FROM
	q_select_adrb
WHERE
	(
	(email_prim IS NOT NULL)
	AND NOT
	(email_prim = '')
	)
ORDER BY
	#url.sort# <cfif CompareNoCase(url.sort, "dt_lastcontact") is 0>DESC</cfif>
;
</cfquery>


<cfset a_int_loop = 1 />

<form name="frmAdressbookData">

<cfoutput query="q_select_adrb">
	<input type="hidden" name="adr#q_select_adrb.currentrow#" value="#htmleditformat(q_select_adrb.email_prim)#" />

	<cfif len(q_select_adrb.email_adr) gt 0>
		<!--- further email address ... --->

		<cfif FindNoCase(",", q_select_adrb.email_adr) GT 0>
			<cfset a_str_email_addresses_delimeter = "," />
		<cfelse>
			<cfset a_str_email_addresses_delimeter = chr(10) />
		</cfif> 

		
		<cfloop list="#q_select_adrb.email_adr#" delimiters="#a_str_email_addresses_delimeter#" index="a_str_further_email">		
			<cfset a_int_loop = a_int_loop + 1 />
			<input type="hidden" name="adr#q_select_adrb.currentrow#_#a_int_loop#" value="#htmleditformat(a_str_further_email)#" />
		</cfloop>

	</cfif>	
</cfoutput>
</form>



<form action="default.cfm" method="GET"  name="adrbsearch">
<input type="hidden" name="action" value="ShowAddressBookSearchInpage" />

<table width="100%" border="0" cellspacing="0" cellpadding="4">
  <tr>
    <td valign="top" align="right" style="line-height:20px;" width="100">

	<input type="Text" name="search" required="No" size="13" maxlength="50" value="<cfoutput>#htmleditformat(url.search)#</cfoutput>" />

	<br />

	<a href="javascript:adrbsearch.submit();" class="simplelink"><img src="/images/si/find.png" class="si_img" /><cfoutput>#GetLangval('cm_wd_search')#</cfoutput> ...</a>

	

	<cfif Len(url.search) gt 0>

		<!--- search operation --->

		<br />

		<b style="color:#CC0000;">Ihre Suche<br />brachte<br /><cfoutput>#q_select_adrb.recordcount#</cfoutput> Treffer</b>

		<br />

	</cfif>

	

	<!---<div class="bt" style="padding:5px;" align="right">

	Anzeigen ...<br />

	<select name="frmShowItems">

		<option>Alle Eintr&auml;ge</option>

		<option value="">nur private</option>

	</select>

	</div>--->

	<div class="bt" style="padding:5px;" align="right">

	<input class="noborder" <cfif a_str_autoclose is 1>checked</cfif> onClick="SetPersonalPreferenceValue('emai', 'addressbookautoclose', Return01OfTrueFalse(this.checked));" type="checkbox" name="frmCheckBoxAutoClose"> Fenster nach Auswahl<br />ausblenden

	</div>
	
	<cfif request.stSecurityContext.myuserid is 2 AND q_select_is_company_admin.recordcount IS 1>
		<div class="bt" style="padding:5px;">
			<a href="show_employee_addressbook.cfm">Mitarbeiter-Adressbuch ...</a>
		</div>
	</cfif>

	</td>

    <td valign="top">



	<table class="table_overview">

	<tr class="tbl_overview_header">

		<td <cfif comparenocase(url.sort, "surname") is 0>class="mischeader"</cfif> colspan="3"><a title="Nach dem Namen sortieren" href="<cfoutput>#cgi.SCRIPT_NAME#?#ReplaceOrAddURLParameter(cgi.QUERY_STRING, "sort", "surname")#</cfoutput>" class="simplelink">Name</a></td>

		<td <cfif comparenocase(url.sort, "company") is 0>class="mischeader"</cfif>><a href="<cfoutput>#cgi.SCRIPT_NAME#?#ReplaceOrAddURLParameter(cgi.QUERY_STRING, "sort", "company")#</cfoutput>" title="Nach der Organisation sortieren" class="simplelink">Organisation</a></td>

		<td <cfif comparenocase(url.sort, "lastcontact") is 0>class="mischeader"</cfif>><a title="Nach dem Letztkontakt sortieren" href="<cfoutput>#cgi.SCRIPT_NAME#?#ReplaceOrAddURLParameter(cgi.QUERY_STRING, "sort", "lastcontact")#</cfoutput>" class="contrastsimplelink">Kontakt</a></td>

	</tr>

	<cfset a_int_loop = 1>

	<cfoutput query="q_select_adrb">

	<tr>

		<td>

		<cfset a_str_display_name = "">

		

		<cfif len(trim(q_select_adrb.surname)) gt 0>

			<cfset a_str_display_name = "<b>"&trim(q_select_adrb.surname)&"</b>">

		</cfif>

		

		<cfif len(trim(q_select_adrb.firstname)) gt 0>

			<cfif len(a_str_display_name) gt 0>

				<cfset a_str_display_name = a_str_display_name & ", ">

			</cfif>

			<cfset a_str_display_name = a_str_display_name & trim(q_select_adrb.firstname)>

		</cfif>

		

		<cfif len(a_str_display_name) is 0>

			<!--- display email address --->

			<cfset a_str_display_name = extractemailadr(q_select_adrb.email_prim)>

		</cfif>



		#si_img('vcard')# <a href="javascript:AddTo('#q_select_adrb.currentrow#');">#Shortenstring(a_str_display_name, 25)#</a>

		</td>

		<td><a href="##" onclick="AddCC('#q_select_adrb.currentrow#');return false;">Cc</a></td>

		<td><a href="javascript:AddBCC('#q_select_adrb.currentrow#');">Bcc</a></td>

		<td>#shortenstring(q_select_adrb.company, 15)#</td>

		<td>

		<cfif IsDate(q_select_adrb.dt_lastcontact)>

			<cfset a_str_dt_today = DateFormat(now(), "ddmmyy")>

			<cfset a_str_dt_yeasterday = DateFormat(dateadd("d", -1, now()), "ddmmyy")>

			<cfset a_str_dt_lastcontact = dateformat(q_select_adrb.dt_lastcontact, "ddmmyy")>

			

			<cfif comparenocase(a_str_dt_today, a_str_dt_lastcontact) is 0>

				heute

			<cfelseif comparenocase(a_str_dt_lastcontact, a_str_dt_yeasterday) is 0>

				gestern

			<cfelse>

				#DateDiff("d", q_select_adrb.dt_lastcontact, now())# d

			</cfif>

			

		</cfif>

		</td>

	</tr>

	<cfif len(q_select_adrb.email_adr) gt 0>

		<!--- further email addresses ... --->

		<tr>

		<cfif FindNoCase(",", q_select_adrb.email_adr) gt 0>
			<cfset a_str_email_addresses_delimeter = ",">
		<cfelse>
			<cfset a_str_email_addresses_delimeter = chr(10)>
		</cfif> 

		<td colspan="4">
		<cfloop list="#q_select_adrb.email_adr#" delimiters="#a_str_email_addresses_delimeter#" index="a_str_further_email">		

			<cfset a_int_loop = a_int_loop + 1>
			<img  src="/images/space_1_1.gif" width="30" height="1" hspace="0" vspace="0" border="0"> <a class="smalllink" href="javascript:AddTo('#q_select_adrb.currentrow#_#a_int_loop#');">#htmleditformat(shortenstring(a_str_further_email, 25))#</a>
		<br />

		</cfloop>

		</td>

		

		</tr>		

	</cfif>

	</cfoutput>

	</table>



	</td>

  </tr>

</table>
</form>


</body>

</html>


