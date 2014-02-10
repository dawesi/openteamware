<!--- //

	route planner
	
	created on 27.06.2003 by hansjoerg posch
	
	// --->
	
<cfcomponent>
	<cffunction access="public" name="getrouteplannerurl" output="false" returntype="string">
		<!---
		
			route or location?
			
			route = from a to b
			location = location A only
			
			--->
		<cfargument name="actiontype"	type="string"	default="route" required="true">
		
		<cfargument name="title"		type="string"	default="" 		required="true">
		
		<cfargument name="country1"		type="string" default="" required="true">
		<cfargument name="zipcode1" type="string" default="" required="true">
		<cfargument name="street1" type="string" default="" required="true">
		<cfargument name="city1" type="string" default="" required="true">
		
		<cfargument name="country2" type="string" default="" required="true">
		<cfargument name="zipcode2" type="string" default="" required="true">
		<cfargument name="street2" type="string" default="" required="true">
		<cfargument name="city2" type="string" default="" required="true">
		
		<!--- get iso codes ... --->
		<cfset var a_str_country1 = getcountrycode(arguments.country1)>
		<cfset var a_str_country2 = getcountrycode(arguments.country2)>
		
		<cfif arguments.actiontype is "route">
			<cfset a_str_url = "http://link2.map24.com/?lid=94b0678e&maptype=JAVA&action=route&scountry="&urlencodedformat(a_str_country1)&"&szip="&urlencodedformat(arguments.zipcode1)&"&scity="&urlencodedformat(arguments.city1)&"&sstreet="&urlencodedformat(arguments.street1)&"&dcountry="&urlencodedformat(a_str_country2)&"&dstreet="&urlencodedformat(arguments.street2)&"&dzip="&urlencodedformat(arguments.zipcode2)&"&dcity="&urlencodedformat(arguments.city2)>			
		<cfelse>
			<cfset a_str_url = "http://link2.map24.com/?lid=94b0678e&maptype=JAVA&country0="&a_str_country1&"&street0="&urlencodedformat(arguments.street1)&"&zip0="&urlencodedformat(arguments.zipcode1)&"&city0="&urlencodedformat(arguments.city1)&"&description0="&urlencodedformat(arguments.title)>
		</cfif>
		
		<cfreturn a_str_url>
	
	</cffunction>
	
	<!--- //
	
		return the country ISO code ... 
		
		// --->
	<cffunction access="public" name="getcountrycode" output="false" returntype="string">
		<cfargument name="country" type="string" default="" required="true">
		
		<!--- the default return value --->
		<cfset var a_str_country_code = "at">
		
		<cfswitch expression="#arguments.country#">
			<cfcase delimiters="," value="�sterreich,Austria,a,at">
			<cfset a_str_country_code = "at">
			</cfcase>
			<cfcase delimiters="," value="Deutschland,D,de,Germany">
			<cfset a_str_country_code = "de">
			</cfcase>
			<cfcase delimiters="," value="Schweiz,Swiss,Switzerland,CH">
			<cfset a_str_country_code = "ch">
			</cfcase>
			<cfcase delimiters="," value="France,Frankreich,fr,f">
			<cfset a_str_country_code = "fr">
			</cfcase>
			<cfcase value="Schweden">
			<cfset a_str_country_code = "se">
			</cfcase>	
			<cfcase value="Spanien">
			<cfset a_str_country_code = "es">
			</cfcase>
			<cfcase value="San Marino">
			<cfset a_str_country_code = "sm">
			</cfcase>
			<cfcase value="San Andorra">
			<cfset a_str_country_code = "ad">
			</cfcase>
			<cfcase value="Belgien">
			<cfset a_str_country_code = "be">
			</cfcase>
			<cfcase value="D�nemark">
			<cfset a_str_country_code = "dk">
			</cfcase>	
			<cfcase value="Gro�britannien,England,UK,United Kingdom">
			<cfset a_str_country_code = "gb">
			</cfcase>
			<cfcase value="Irland">
			<cfset a_str_country_code = "ie">
			</cfcase>
			<cfcase value="Liechtenstein">
			<cfset a_str_country_code = "li">
			</cfcase>
			<cfcase value="Luxemburg">
			<cfset a_str_country_code = "lu">
			</cfcase>
			<cfcase value="Monaco">
			<cfset a_str_country_code = "mc">
			</cfcase>
			<cfcase value="Niederland,Holland">
			<cfset a_str_country_code = "nl">
			</cfcase>
			<cfcase value="Norwegen">
			<cfset a_str_country_code = "no">
			</cfcase>
			<cfcase value="Portugal">
			<cfset a_str_country_code = "pt">
			</cfcase>	
			<cfcase value="Polen,Poland,pl">
			<cfset a_str_country_code = "pl">
			</cfcase>
			<cfcase value="Slovakia,Slowakei,sk">
			<cfset a_str_country_code = "sk">
			</cfcase>
			<cfcase value="cz,Tschechien,Czech Republic">
			<cfset a_str_country_code = "cz">
			</cfcase>			
		</cfswitch>
		
		<cfreturn a_str_country_code>
	</cffunction>	

</cfcomponent>