<!--- //

	Module:		Licence
	Description:


// --->
<cfcomponent output=false>

<!--- //

	get/set the number of avaliable seats ...

	// --->

	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">

	<!--- check if trial phase has expired --->
	<cffunction access="public" name="TrialPhaseExipired" output="false" returntype="boolean">
		<cfargument name="companykey" type="string" required="true">

		<cfinclude template="queries/q_select_trial_expired.cfm">

		<cfreturn (q_select_trial_expired.count_id IS 1)>
	</cffunction>


	<cffunction access="public" name="CommonTermsAndConditionsAccepted" output="false" returntype="boolean">
		<cfargument name="companykey" type="string" required="yes">

		<cfinclude template="queries/q_select_ctac_accepted.cfm">

		<!--- if transparent reseller, always accept = true --->
		<cfif (q_select_ctac_accepted.recordcount IS 1) AND (q_select_ctac_accepted.settlement_type NEQ 0)>
			<cfset QuerySetCell(q_select_ctac_accepted, 'generaltermsandconditions_accepted', 1, 1)>
		</cfif>

		<cfif q_select_ctac_accepted.generaltermsandconditions_accepted IS 1>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>

	<!--- are there open invoices which have not been paid for more than 10 days? --->
	<cffunction access="public" name="CheckDunningLetters" output="false" returntype="query">
		<cfargument name="companykey" type="string" required="true">
		<cfargument name="dunningminlevel" type="numeric" default="-1" required="false">

		<cfinclude template="queries/q_select_open_dunningletters.cfm">

		<cfreturn q_select_open_dunningletters>
	</cffunction>


	<cffunction access="public" name="GetAvailableSeats" output="false" returntype="numeric">
		<!--- company --->
		<cfargument name="companykey" type="string" required="true">
		<!--- productkey --->
		<cfargument name="productkey" type="string" required="true">

		<cfinclude template="queries/q_select_available_seats.cfm">

		<cfreturn val(q_select_available_seats.availableseats)>

	</cffunction>

	<cffunction access="public" name="GetLicenceStatus" output="false" returntype="query">
		<!--- company --->
		<cfargument name="companykey" type="string" required="true">
		<!--- productkey --->
		<cfargument name="productkey" type="string" required="true">

		<cfinclude template="queries/q_select_licence_status.cfm">

		<cfreturn q_select_licence_status>
	</cffunction>


	<cffunction access="public" name="AddAvailableSeats" output="false" returntype="boolean">
		<cfargument name="companykey" type="string" required="true">
		<!--- productkey --->
		<cfargument name="productkey" type="string" required="true">
		<!--- number to add --->
		<cfargument name="addseats" type="numeric" default="0" required="true">
		<!--- is this user coming from the shop? If yes, update totalseats --->
		<cfargument name="comingfromshop" type="numeric" default="0" required="false">
		<!--- comment ? --->
		<cfargument name="comment" type="string" default="" required="false">
		<!--- userkey who has set this action --->
		<cfargument name="createdbyuserkey" type="string" required="false" default="">

		<cfinclude template="queries/q_update_available_seats.cfm">

		<cfinclude template="queries/q_insert_licence_history.cfm">

		<!---<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="AddAvailableSeats" type="html">
			<cfdump var="#arguments#">
		</cfmail>--->
		<cfreturn true>
	</cffunction>

	<!---

		this is for quota related units, f.e. the points system

		--->
	<cffunction access="public" name="GetAvailablePoints" output="false" returntype="numeric">
		<cfargument name="companykey" type="string" required="true">

		<cfinclude template="queries/q_select_points.cfm">

		<cfreturn val(q_select_points.availableunits)>
	</cffunction>

	<cffunction access="public" name="GetAvailablePointsOfCompanyOrUser" output="false" returntype="numeric">
		<cfargument name="securitycontext" type="struct" required="yes">

		<cfreturn GetAvailablePoints(arguments.securitycontext.mycompanykey)>
	</cffunction>

	<cffunction access="public" name="AddAvailablePoints" output="false" returntype="boolean">
		<cfargument name="companykey" type="string" required="true">
		<cfargument name="points" type="numeric" default="0" required="true">

		<cfinclude template="queries/q_insert_update_points.cfm">

		<cfreturn true>
	</cffunction>

	<cffunction access="public" name="GetAvailableQuota" output="false" returntype="numeric">
		<cfargument name="companykey" type="string" required="true">

		<cfinclude template="queries/q_select_quota.cfm">

		<cfreturn val(q_select_quota.availableunits)>
	</cffunction>

	<cffunction access="public" name="AddAvailableQuota" output="false" returntype="boolean">
		<cfargument name="companykey" type="string" required="true">
		<cfargument name="mb" type="numeric" default="0" required="true">

		<cfinclude template="queries/q_insert_update_quota.cfm">

		<cfreturn true>
	</cffunction>

	<!--- f.e. fax or securemail --->
	<cffunction access="public" name="FeatureAvailableForUser" output="false" returntype="boolean">
		<cfargument name="userkey" type="string" required="true">
		<cfargument name="servicekey" type="string" required="true">

		<cfreturn true>
	</cffunction>

	<cffunction access="public" name="GetFeatureStatusForProductKey" output="false" returntype="numeric">
		<cfargument name="productkey" type="string" required="true">
		<cfargument name="featurename" type="string" required="true">
		<!---

			1 = included
			0 = not included
			... other ... = MB or something like that

			--->
		<cfinclude template="queries/q_select_featurestatus_for_product.cfm">

		<cfif q_select_featurestatus_for_product.recordcount IS 1>
			<cfreturn q_select_featurestatus_for_product.param>
		<cfelse>
			<!--- nothing special found ... ok --->
			<cfreturn 1>
		</cfif>
	</cffunction>

	<!--- a user is updated or created ... --->
	<cffunction access="public" name="UpdateUserProductKey" output="false" returntype="struct">
		<cfargument name="userkey" type="string" required="true">
		<cfargument name="companykey" type="string" required="true">
		<cfargument name="productkey" type="string" required="true">
		<!--- was this account a trial account? --->
		<cfargument name="wastrialaccount" type="numeric" default="0" required="false">

		<cfset stReturn = StructNew()>
		<cfset stReturn.result = false>
		<cfset stReturn.message = ''>

		<!--- check if the user has the same productkey than before ... --->
		<cfinclude template="queries/q_select_productkey_of_user.cfm">

		<cfif (q_select_productkey_of_user.productkey IS arguments.productkey) AND (arguments.wastrialaccount IS 0)>
			<!--- productkey is not different AND user was NOT in trialphase ... --->
			<cfset stReturn.message = 'sameproductkey'>
			<cfreturn stReturn>
		</cfif>

		<!--- check if there are still licences available --->
		<cfset a_int_available_seats = GetAvailableSeats(companykey=arguments.companykey,productkey=arguments.productkey)>

		<cfif a_int_available_seats IS 0>
			<cfset stReturn.message = 'nomorelicencesavailable'>
			<cfreturn stReturn>
		</cfif>

		<cfif arguments.wastrialaccount IS 0>
			<!--- remove licence for the other product ...

				f.e. a user buys three new groupware seats, the old licences become free
			--->
			<cfset AddAvailableSeats(companykey=arguments.companykey,productkey=q_select_productkey_of_user.productkey,addseats=1)>

		</cfif>

		<!--- remove now one seat ... --->
		<cfset AddAvailableSeats(companykey=arguments.companykey,productkey=arguments.productkey,addseats=-1)>

		<cfinclude template="queries/q_update_user_productkey.cfm">

		<cfset stReturn.result = true>
		<cfreturn stReturn>
	</cffunction>


	<cffunction access="public" name="GetProductkeyforuserkey" returntype="string" output="false">
		<cfargument name="userkey" type="string" required="yes">

		<cfinclude template="queries/q_select_productkey_for_user.cfm">

		<cfreturn q_select_productkey_for_user.productkey>
	</cffunction>

	<cffunction access="public" name="CalculatePointsNeeded" returntype="numeric" output="false">
		<!--- SMS or fax --->
		<cfargument name="messagetype" type="string" default="sms" required="yes">
		<!--- sms parameters ... --->
		<cfargument name="parameters" type="string" required="no" default="">
		<cfargument name="destinationnumber" type="string" required="yes">

		<cfset var a_int_return = 0>

		<cfif arguments.messagetype IS 'sms'>

			<cfset a_int_return = 2>

			<cfif ListFind(arguments.parameters, 'ownnumberassender') GT 0>
				<cfset a_int_return = 4>
			</cfif>

			<cfif ListFind(arguments.parameters, 'statusreport') GT 0>
				<cfset a_int_return = a_int_return + 1>
			</cfif>

		</cfif>

		<cfif arguments.messagetype IS 'fax'>
			<!--- 4 points pro fax --->
			<cfset a_int_return = 4>
		</cfif>

		<cfreturn a_int_return>
	</cffunction>

	<cffunction access="public" name="CalculateAndDebitAccount" returntype="struct" output="false">
		<cfargument name="securitycontext" type="struct" required="yes">
		<!--- SMS or fax --->
		<cfargument name="messagetype" type="string" default="sms" required="yes">
		<cfargument name="parameters" type="string" default="" required="no">
		<cfargument name="destinationnumber" type="string" required="yes">

		<cfset var stReturn = StructNew()>
		<cfset stReturn.result = false>
		<cfset stReturn.errormessage = ''>
		<cfset stReturn.errortype = 0>

		<!--- calculate the points needed ... --->
		<cfset a_int_needed_points_return = CalculatePointsNeeded(messagetype = arguments.messagetype, parameters = arguments.parameters, destinationnumber = arguments.destinationnumber)>

		<!--- return the points needed ... --->
		<cfset stReturn.a_int_points_needed = a_int_needed_points_return>

		<!--- check if we've got enough points ... --->
		<cfset a_int_available_points = GetAvailablePointsOfCompanyOrUser(arguments.securitycontext)>

		<cfif a_int_available_points LT a_int_needed_points_return>
			<!-- error ... --->

			<!--- send hint ... --->
			<cfinclude template="utils/inc_send_hint.cfm">

			<cfset stReturn.errormessage = 'notenoughpoints'>
			<cfreturn stReturn>
		</cfif>

		<!--- debit account ... --->
		<cfset a_bol_return_debit = DebitPointsAccount(securitycontext = arguments.securitycontext, points = a_int_needed_points_return)>

		<!--- everything is ok --->
		<cfset stReturn.result = true>
		<cfreturn stReturn>
	</cffunction>

</cfcomponent>


