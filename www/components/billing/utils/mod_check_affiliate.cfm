<!--- //

	check certain affiliates
	
	// --->
	
	
<cfswitch expression="#q_select_customer_data.distributorkey#">
	<cfcase value="C35C6B51-EBE1-D8C5-90702FF30D167987">
		<!--- propartner pl --->
		
		<cfset a_str_url = 'http://service.propartner.pl/02-02.php?m=inbox&c_tracking=' & urlencodedformat(q_select_invoice.invoicenumber) & '&c_email=' & urlencodedformat(q_select_customer_data.email) & '&c_amount=' & ReplaceNoCase(q_select_invoice.invoicetotalsum_gross, ',', '.')>
		
		<cftry>
		<cfhttp url="#a_str_url#" resolveurl="no" timeout="30" getasbinary="yes"></cfhttp>
		
		<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="cfhttp called (affiliate propartner pl)" type="html">
		
			<cfdump var="#a_str_url#">
			<cfdump var="#cfhttp#">
			<cfdump var="#arguments#">
		</cfmail>
		<cfcatch type="any">
			<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="exception on set paid affiliate propartner pl" type="html">
				<cfdump var="#a_str_url#">
				<cfdump var="#arguments#">
				<cfdump var="#cfcatch#">
			</cfmail>
		</cfcatch>
		</cftry>		
	</cfcase>
	<cfcase value="D6ADB8A7-0A71-2C87-EB1E2C7F5A9089D0">
		<!--- adbutler ... --->
		
		
		<cfset a_str_url = 'http://james.adbutler.de/lsgen.php?pid=8589&summe='&ReplaceNoCase(q_select_invoice.invoicetotalsum_gross, ',', '.')&'&opts='&urlencodedformat(q_select_customer_data.companyname)&'&kid='&urlencodedformat(q_select_invoice.invoicenumber)&'&kdnr='&q_select_customer_data.customerid>
		
		<cftry>
		<cfhttp url="#a_str_url#" resolveurl="no" timeout="30" getasbinary="yes"></cfhttp>
		
		<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="cfhttp called (affiliate)" type="html">
		
			<cfdump var="#a_str_url#">
			<cfdump var="#cfhttp#">
			<cfdump var="#arguments#">
		</cfmail>
		<cfcatch type="any">
			<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="exception on set paid affiliate" type="html">
				<cfdump var="#a_str_url#">
				<cfdump var="#arguments#">
				<cfdump var="#cfcatch#">
			</cfmail>
		</cfcatch>
		</cftry>
		
	</cfcase>
	<cfcase value="F6182792-CAB8-8C4A-EB72152206841975">
		<!--- affiliwelt --->
		<cfset a_str_url = 'http://www.affiliwelt.net/tracking.php?prid=672&sid=466&bestid='&urlencodedformat(q_select_invoice.invoicenumber)&'&beschreibung=InBox_cc_Kunde_Nr_'&q_select_customer_data.customerid&'&preis='&ReplaceNoCase(q_select_invoice.invoicetotalsum_gross, ',', '.')>
		
		<cftry>
		<cfhttp url="#a_str_url#" resolveurl="no" timeout="30" getasbinary="yes"></cfhttp>
		
		<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="cfhttp called (affiliwelt)" type="html">
		
			<cfdump var="#a_str_url#">
			<cfdump var="#cfhttp#">
			<cfdump var="#arguments#">
		</cfmail>
		<cfcatch type="any">
			<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="exception on set paid affiliwelt" type="html">
				<cfdump var="#a_str_url#">
				<cfdump var="#arguments#">
				<cfdump var="#cfcatch#">
			</cfmail>
		</cfcatch>
		</cftry>
	</cfcase>
	<cfcase value="F617DAF8-FB01-A941-08846184BE3ABA5E">
		<!--- Affiliscout --->
		<cfset a_str_url = 'http://www.affiliscout.com/network/registering.php3?ID=214888464&art=sale&track='&urlencodedformat(q_select_invoice.invoicenumber)&'&wert='&ReplaceNoCase(q_select_invoice.invoicetotalsum_gross, ',', '.')>
		
		<cftry>
		<cfhttp url="#a_str_url#" resolveurl="no" timeout="30" getasbinary="yes"></cfhttp>
		
		<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="cfhttp called (Affiliscout)" type="html">
		
			<cfdump var="#a_str_url#">
			<cfdump var="#cfhttp#">
			<cfdump var="#arguments#">
		</cfmail>
		<cfcatch type="any">
			<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="exception on set paid Affiliscout" type="html">
				<cfdump var="#a_str_url#">
				<cfdump var="#arguments#">
				<cfdump var="#cfcatch#">
			</cfmail>
		</cfcatch>
		</cftry>
		
	</cfcase>
</cfswitch>