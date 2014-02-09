<cfparam name="url.search" type="string" default="">
<html>
<head>
<cfinclude template="../style_sheet.cfm">
<script type="text/javascript">
	function SetReseller(key)
		{
		var obj1 = window.opener.formcustomers.resellerkey;
		// var obj2 = window.opener.formfilter.resellerkeys;
		
		var k = '';
		
		for(i=0; i<obj1.options.length; i++)
			{
			k = obj1.options[i].value;
			
			if (k == key)
				{
				obj1.selectedIndex = i;
				window.opener.formcustomers.submit();
				window.close();
				return true;
				}
			}
		
		}
</script>
<title>Select Reseller</title>
</head>

<body style="padding:6px; ">
<h4><cfoutput>#GetLangVal('adm_ph_Select_partner')#</cfoutput></h4>
<cfif Len(url.search) GT 0>
	<cfquery name="q_select_reseller" dbtype="query">
	SELECT
		*
	FROM
		q_select_reseller
	WHERE
		UPPER(companyname) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(url.search)#%">
	;
	</cfquery>
</cfif>


<form action="show_select_reseller.cfm" method="get">
Suchen: <input type="text" name="search" value="<cfoutput>#htmleditformat(url.search)#</cfoutput>"> <input type="submit" value="Suchen ...">
<cfif Len(url.search) GT 0>
	&nbsp;&nbsp;<a href="show_select_reseller.cfm">Alle anzeigen</a>
</cfif>
</form>

<cfoutput query="q_select_reseller">
<div style="padding:3px;">
<img src="/images/space_1_1.gif" align="absmiddle" height="1" width="#(q_select_reseller.resellerlevel*20)#">

<a <cfif request.q_select_reseller.contractingparty IS 0>style="color:silver;"</cfif> href="javascript:SetReseller('#jsstringformat(request.q_select_reseller.entrykey)#');">#htmleditformat(request.q_select_reseller.companyname)#</a>

<cfif request.q_select_reseller.issystempartner IS 1>[SP]</cfif>
<cfif request.q_select_reseller.isdistributor IS 1>[DP]</cfif>
<cfif request.q_select_reseller.isprojectpartner IS 1>[PP]</cfif>
</div>
</cfoutput>

</body>
</html>
