<cfparam name="attributes.companykey" type="string" default="">
<cfparam name="attributes.productkey" type="string" default="">
<cfparam name="attributes.quantity" type="numeric" default="0">

<cfswitch expression="#attributes.productkey#">
	<cfcase value="AD95D469-FCC1-17C1-CB8F711360E2450D">
	<!--- email only ... --->
	
		<cfinvoke component="#application.components.cmp_licence#" method="AddAvailableSeats">
			<cfinvokeargument name="companykey" value="#attributes.companykey#">
			<cfinvokeargument name="productkey" value="#attributes.productkey#">
			<cfinvokeargument name="addseats" value="#attributes.quantity#">
			<cfinvokeargument name="comingfromshop" value="1">
		</cfinvoke>	
	
	</cfcase>
	
	<cfcase value="AD9947E9-92B7-635C-B48BC5D8259841DF">
	<!--- space (Harddisk) --->
	
		<cfinvoke component="#application.components.cmp_licence#" method="AddAvailableQuota">
			<cfinvokeargument name="companykey" value="#attributes.companykey#">
			<cfinvokeargument name="mb" value="#attributes.quantity#">
		</cfinvoke>
	
	</cfcase>
	
	<cfcase value="AE79D26D-D86D-E073-B9648D735D84F319">
	<!--- groupware --->
	
		<cfinvoke component="#application.components.cmp_licence#" method="AddAvailableSeats">
			<cfinvokeargument name="companykey" value="#attributes.companykey#">
			<cfinvokeargument name="productkey" value="#attributes.productkey#">
			<cfinvokeargument name="addseats" value="#attributes.quantity#">
			<cfinvokeargument name="comingfromshop" value="1">						
		</cfinvoke>
		
	</cfcase>
	
	<cfcase value="8D838EE7-FCFF-D1AF-4D7FF0A7AB95E6E4">
		<!--- starter package --->
		<cfinvoke component="#application.components.cmp_licence#" method="AddAvailableSeats">
			<cfinvokeargument name="companykey" value="#attributes.companykey#">
			<!--- groupware --->
			<cfinvokeargument name="productkey" value="AE79D26D-D86D-E073-B9648D735D84F319">
			<!--- 5 seats --->
			<cfinvokeargument name="addseats" value="5">
			<cfinvokeargument name="comingfromshop" value="1">						
		</cfinvoke>
	</cfcase>
	
	<cfcase value="AD4262D0-98D5-D611-4763153818C89190">
	<!--- einzelplatz ... --->
	
		<cfinvoke component="#application.components.cmp_licence#" method="AddAvailableSeats">
			<cfinvokeargument name="companykey" value="#attributes.companykey#">
			<cfinvokeargument name="productkey" value="#attributes.productkey#">
			<cfinvokeargument name="addseats" value="#attributes.quantity#">
			<cfinvokeargument name="comingfromshop" value="1">						
		</cfinvoke>	
	
	</cfcase>
	
	<cfcase value="E11A2209-9448-1723-8EEEDF6CCB91E747">
	<!--- points for SMS/fax --->
		
		<cfinvoke component="#application.components.cmp_licence#" method="AddAvailablePoints">
			<cfinvokeargument name="companykey" value="#attributes.companykey#">
			<cfinvokeargument name="points" value="#attributes.quantity#">
		</cfinvoke>
		
	</cfcase>
</cfswitch>