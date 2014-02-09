<!--- general scripts ... --->
<!--- optional: action (some js just have to be included upon special actions) --->
<cfparam name="attributes.action" type="string" default="">

<cfoutput>#application.components.cmp_render.CallJavaScriptsInclude(currentaction = attributes.action)#</cfoutput>