<!--- //

	handle translations ...
	
	// --->



	
<cfcomponent>

	<cffunction access="public" name="Translate" output="false" returntype="string">
		<cfargument name="mode" type="string" default="de_en" required="true">
		<cfargument name="sourcedata" type="string" default="" required="true">
		
		<cfset sReturn = "">
		
		<cfloop index="a_int_index" from="1" to="#len(arguments.sourcedata)#" step="140">
		
			<cfset a_str_part = Mid(arguments.sourcedata, a_int_index, 140)>
		
			<!--- call the babelfish engine ... --->
			<!---<cfinvoke method="BabelFish"
				returnvariable="a_str_babelfish_return"
				webservice="http://www.xmethods.net/sd/2001/BabelFishService.wsdl">
				<cfinvokeargument name="translationmode" value="#arguments.mode#">
				<cfinvokeargument name="sourcedata" value="#a_str_part#">
			</cfinvoke>--->
			
			 <CFINVOKE WEBSERVICE="http://www.xmethods.net/sd/2001/BabelFishService.wsdl" METHOD="babelFish" RETURNVARIABLE="a_str_babelfish_return">
				  <CFINVOKEARGUMENT NAME="translationmode" VALUE="#arguments.mode#"/>
				  <CFINVOKEARGUMENT NAME="sourcedata" VALUE="#a_str_part#"/>
			   </CFINVOKE>			
			
			<cfset sReturn = sReturn & a_str_babelfish_return>
		
		</cfloop>
		
		<cfreturn sReturn>
	
	</cffunction>

</cfcomponent>