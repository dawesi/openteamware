
<cfinclude template="queries/q_select_reseller.cfm">

<cfparam name="CreateEditReseller.query" type="query" default="#QueryNew('contractingparty,companykey,assignedareas,bankdetails,assignedzipcodes,partnertype,AFFILIATECODE,description,CITY,COMPANYNAME,COUNTRY,CUSTOMERCONTACT,DELEGATERIGHTS,DOMAINS,DT_CREATED,EMAILADR,ENTRYKEY,ID,INCLUDEFOOTER,LOGO,PARENTID,PARENTKEY,STANDARDPERCENTS,STREET,TELEPHONE,USERID,ZIPCODE,issystempartner,isdistributor,isprojectpartner,isdealer,homepage')#">
<cfparam name="CreateEditReseller.action" type="string" default="create">

<cfif createeditreseller.action is 'edit'>
	<cfquery name="q_select_reseller" dbtype="query">
	SELECT
		*
	FROM
		q_select_reseller
	WHERE
		NOT entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateEditReseller.query.entrykey#">
	;
	</cfquery>
<cfelse>
	<cfset QueryAddRow(CreateEditReseller.query, 1)>
	
	<cfquery name="q_select_reseller" dbtype="query">
	SELECT
		*
	FROM
		q_select_reseller
	WHERE
		partnertype = 3
	;
	</cfquery>
	
	<!--- customerid provided? --->
	<cfif StructKeyExists(url, 'customerid')>
		<!--- load data --->
		<cfquery name="q_select_company" datasource="#request.a_str_db_users#">
		SELECT
			companyname,zipcode,email,telephone,customerid,country,city,street
		FROM
			companies
		WHERE
			customerid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.customerid#">
		;
		</cfquery>
		
		<cfset QuerySetCell(CreateEditReseller.query, 'companyname', q_select_company.companyname, 1)>
		<cfset QuerySetCell(CreateEditReseller.query, 'telephone', q_select_company.telephone, 1)>
		<cfset QuerySetCell(CreateEditReseller.query, 'emailadr', q_select_company.email, 1)>
		<cfset QuerySetCell(CreateEditReseller.query, 'country', q_select_company.country, 1)>
		<cfset QuerySetCell(CreateEditReseller.query, 'city', q_select_company.city, 1)>
		<cfset QuerySetCell(CreateEditReseller.query, 'street', q_select_company.street, 1)>
		<cfset QuerySetCell(CreateEditReseller.query, 'zipcode', q_select_company.zipcode, 1)>
		
		<cfset a_str_customercontact = q_select_company.telephone & chr(13) & chr(10) & q_select_company.email>
		<cfset QuerySetCell(CreateEditReseller.query, 'CUSTOMERCONTACT', a_str_customercontact, 1)>
	</cfif>
</cfif>

<cfquery name="q_select_customerid" datasource="#request.a_str_db_users#">
SELECT
	customerid
FROM
	companies
WHERE
	<cfif StructKeyExists(url, 'customerid')>
	customerid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.customerid#">
	<cfelse>
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateEditReseller.query.companykey#">
	</cfif>
;
</cfquery>

<cfoutput query="CreateEditReseller.query">
<table border="0" cellspacing="0" cellpadding="4">
<cfif createeditreseller.action is 'edit'>
<form action="act_edit_reseller.cfm" method="post">
<cfelse>
<form action="act_create_reseller.cfm" method="post">
</cfif>

<input type="hidden" name="frmentrykey" value="#CreateEditReseller.query.entrykey#">
  <tr>
  	<td align="right">
		Uebergeordnet:
	</td>
	<td>
		<select name="frmparentkey">
			<cfloop query="q_select_reseller">
			<option #WriteSelectedElement(q_select_reseller.entrykey,CreateEditReseller.query.parentkey)# value="#q_select_reseller.entrykey#">#q_select_reseller.companyname#</option>
			</cfloop>
		</select>
	</td>
  </tr>
  <tr>
    <td align="right">
		Unternehmen:
	</td>
    <td>
		<input type="text" name="frmcompanyname" value="#htmleditformat(CreateEditReseller.query.companyname)#" size="30">
	</td>
  </tr>
  <tr>
  	<td align="right">
		Kundennummer:
	</td>
	<td>
		<input type="text" name="frmcustomerid" value="#q_select_customerid.customerid#" size="30"><br>
		Benutzer dieses Kunden koennen als<br>
		Resellerkontakte angelegt werden.
	</td>
  </tr>
  <cfif createeditreseller.action is 'create'>
  	<tr>
		<td></td>
		<td>
			<input type="button" value="Uebernehmen" onClick="Uebernehmen();">
		</td>
	</tr>
	<script type="text/javascript">
		function Uebernehmen()
			{
			location.href = 'index.cfm?action=newreseller&customerid='+document.all.frmcustomerid.value;
			}
	</script>
  </cfif>
  <tr>
  	<td align="right">
		Typ:
	</td>
	<td>
		<input type="checkbox" name="frmcbissystempartner" value="1" #WriteCheckedElement(1, val(CreateEditReseller.query.issystempartner))#> System-Partner<br>
		<input type="checkbox" name="frmcbisdistributor" value="1" #WriteCheckedElement(1, val(CreateEditReseller.query.isdistributor))#> Distributor<br>
		<input type="checkbox" name="frmcbisprojectpartner" value="1" #WriteCheckedElement(1, val(CreateEditReseller.query.isprojectpartner))#> Projekt-Partner<br>
		<input type="checkbox" name="frmcbisdealer" value="1" #WriteCheckedElement(1, val(CreateEditReseller.query.isdealer))#> (Grosz-)Haendler<br>
	</td>
  </tr>
  <tr>
  	<td align="right">
		Vertragspartner:
	</td>
	<td>
		<input type="checkbox" name="frmcbcontractingparty" value="1" #writecheckedelement(1, val(CreateEditReseller.query.contractingparty))#>
	</td>
  </tr>
  <tr>
    <td align="right">
		Beschreibung:
	</td>
    <td>
		<input type="text" name="frmdescription" value="#htmleditformat(CreateEditReseller.query.description)#" size="30">
	</td>
  </tr>   
  <tr>
    <td align="right">
		Strasse:
	</td>
    <td>
		<input type="text" name="frmstreet" value="#htmleditformat(CreateEditReseller.query.street)#" size="30">
	</td>
  </tr>    
  <tr>
    <td align="right">
		PLZ:
	</td>
    <td>
		<input type="text" name="frmzipcode" value="#htmleditformat(CreateEditReseller.query.zipcode)#" size="30">
	</td>
  </tr> 
  <tr>
    <td align="right">
		Stadt:
	</td>
    <td>
		<input type="text" name="frmcity" value="#htmleditformat(CreateEditReseller.query.city)#" size="30">
	</td>
  </tr> 
  <tr>
    <td align="right">
		Land:
	</td>
    <td>
		<input type="text" name="frmcountry" value="#htmleditformat(CreateEditReseller.query.country)#" size="30">
	</td>
  </tr>
  <tr>
    <td align="right">
		Telephone:
	</td>
    <td>
		<input type="text" name="frmtelephone" value="#htmleditformat(CreateEditReseller.query.telephone)#" size="30">
	</td>
  </tr> 
  <tr>
    <td align="right">
		E-Mail:
	</td>
    <td>
		<input type="text" name="frmemailadr" value="#htmleditformat(CreateEditReseller.query.emailadr)#" size="30">
	</td>
  </tr>  
  <tr>
  	<td align="right">
		Homepage (WWW):
	</td>
	<td>
		<input type="text" name="frmhomepage" value="#htmleditformat(CreateEditReseller.query.homepage)#" size="30">
	</td>
  </tr>
  <tr>
    <td align="right">
		Bankverbindung
	</td>
    <td>
		<textarea name="frmbankdetails" cols="30" rows="5">#CreateEditReseller.query.bankdetails#</textarea>
	</td>
  </tr>    
  <tr>
    <td align="right">
		Kontaktdaten (Website):
	</td>
    <td>
		<textarea cols="30" rows="3" name="frmcustomercontact">#htmleditformat(CreateEditReseller.query.CUSTOMERCONTACT)#</textarea>
	</td>
  </tr>   
  <tr>
  	<td align="right">Zugeteilte Gebiete:</td>
	<td>
		<input type="text" name="frmassignedareas" value="#htmleditformat(CreateEditReseller.query.assignedareas)#" size="30">
	</td>
  </tr>
  <tr>
  	<td align="right">Zugeteilte Postleitzahlen:</td>
	<td>
		<textarea name="frmassignedzipcodes" cols="30" rows="5">#CreateEditReseller.query.assignedzipcodes#</textarea>
	</td>
  </tr>
  <tr>
  	<td align="right">Affiliate-Code:</td>
	<td>
		<input type="text" name="frmaffiliatecode" value="#htmleditformat(CreateEditReseller.query.affiliatecode)#" size="10">
	</td>
  </tr>  
  <tr>
    <td>&nbsp;</td>
    <td>
		<input type="submit" name="frmsubmit" value="Speichern">
	</td>
  </tr>
</form>
</table>
</cfoutput>