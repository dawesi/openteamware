<!--- //

	Module:		Newsletter
	Action:		CalcNumberOfSubscribers
	Description: 
	

// --->

<cfparam name="url.listkey" type="string">

<cfset q_select_subscribers = application.components.cmp_newsletter.GetSubscribers(securitycontext = request.stSecurityContext,
									usersettings = request.stUserSettings,
									listkey = url.listkey, options = '') />
					
<cfoutput>#q_select_subscribers.recordcount#</cfoutput>
					
