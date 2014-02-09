<cfparam name="url.storedids" type="string" default="">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<style>
		td,body,p{font-family:Tahoma;font-size:10pt;color:black;}
		.bbd{border-bottom:silver dashed 1px;}
		a{color:navy;text-decoration:none;}
		a:hover{color:darkred;text-decoration:underline;}
	</style>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body marginheight="0" marginwidth="0" leftmargin="0" rightmargin="0" topmargin="0" bottommargin="0">

<cfif cgi.REQUEST_METHOD IS 'POST'>
	<!--- search ... --->
	<cfinvoke component="/components/tools/cmp_sm" method="SearchLDAPServer" returnvariable="q_select_result">
		<cfinvokeargument name="search" value="#form.frmsearch#">
	</cfinvoke>
</cfif>

<div id="iddivformsearch" style="padding:8px;">
	<form action="default.cfm" method="post" onSubmit="StartSearch();">
	<img src="/images/addressbook/menu_suchen.gif" align="absmiddle"> Bitte geben Sie Ihren Suchparameter ein:<br>
	<input type="text" name="frmsearch" size="15">&nbsp;<input type="submit" value="Suchen ...">
	<br>
	Es werden der Name und die E-Mail Adresse durchsucht.
	<br>
	Quelle der Daten: A-Trust Verzeichnisdienst
</form>
</div>

<div id="iddivsearchstatus" style="display:none;padding:10px;background-color:#EEEEEE;">
	<b>Suche laueft ...</b>
	<br><br>
	<a href=".">Abbrechen und eine neue Suche starten</a>
</div>

<div id="iddivsearch" style="padding:4px;">
<cfif IsDefined('q_select_result')>
	
	<b>Ihre Suche nach <font color="#CC0000"><cfoutput>#htmleditformat(form.frmsearch)#</cfoutput></font> ergab <cfoutput>#q_select_result.recordcount#</cfoutput> Treffer.</b>
	<br><br>
	
	<table border="0" cellspacing="0" cellpadding="4">
	  <tr bgcolor="#EEEEEE">
	  	<td>Hinzufuegen</td>
		<td>Name</td>
		<td>E-Mail</td>
		<td>Cert Usage</td>
		<td>Seriennummer</td>
	  </tr>
	  <cfoutput query="q_select_result">
	  <tr>
	  	<td valign="top" class="bbd">
			[ <a title="Zertifikat hinzufuegen ..." href="addcert:#q_select_result.EIDCERTIFICATESERIALNUMBER#"><img border="0" src="/images/img_download.png" width="12" height="12"> add</a> ]
			
			<cfif ListFind(url.storedids, q_select_result.EIDCERTIFICATESERIALNUMBER) GT 0>
				installiert
			</cfif>
		</td>
		<td valign="top" class="bbd">
			<b>#q_select_result.cn#</b>
		</td>
		<td valign="top" class="bbd">
			<a title="Eine neue E-Mail schreiben ..." href="/email/?action=composemail&to=#urlencodedformat(q_select_result.mail)#&type=0" target="_blank">#htmleditformat(q_select_result.mail)#</a>
		</td>
		<td valign="top" style="font-size:10px;" class="bbd">
			<cfloop list="#q_select_result.EIDCERTKEYUSAGE#" delimiters="," index="a_str_usage">
				#a_str_usage#<br>
			</cfloop>
		</td> 
		<td valign="top" style="font-size:10px;" class="bbd">
				#q_select_result.EIDCERTIFICATESERIALNUMBER#
		</td>
	  </tr>
	  </cfoutput>
	</table>
	
</cfif>
</div>

<script type="text/javascript">
	function StartSearch()
		{
		document.all.iddivsearchstatus.style.display = '';
		document.all.iddivformsearch.style.display = 'none';
		document.all.iddivsearch.style.display = 'none';
		}
</script>
</body>
</html>
