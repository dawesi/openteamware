
<!--- html datei zum includen --->

<cfparam name="Attributes.Include" default="">

<cfparam name="Attributes.TableWidth" default="120">

<cfparam name="Attributes.WholeTableHeight" default="">

<!--- bereich --->

<cfparam name="Attributes.Section" default="unknown">



<!--- benutzerdefinierte daten --->

<cfparam name="Attributes.Userdata1" default="">

<cfparam name="Attributes.userdata2" default="">

<cfparam name="Attributes.userdata3" default="">



<!--- webmail spezifisch --->

<cfif CompareNoCase(attributes.section, "email") is 0>

	<!--- bereich braucht eine query! --->

	<cfparam name="Attributes.Query" type="query">

</cfif>



<!--- globale variablen einbinden --->

<cfinclude template="../app_global.cfm">



<table width="100%" border="0" cellspacing="0" cellpadding="0" <cfif Attributes.WholeTableHeight neq "">height="<cfoutput>#Attributes.WholeTableHeight#</cfoutput>"</cfif>>

<tr>	

	<cfif Len(Attributes.Include) gt 0>

	<td width="<cfoutput>#Attributes.TableWidth#</cfoutput>" valign="top">

	<cfinclude template="#Attributes.Include#">

	</td>

	</cfif>

	<td valign="top" style="padding:5px;">