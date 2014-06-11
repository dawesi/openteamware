<!--- //

	Component:	Users
	Description:Various user functions
	

	
	
	component for adding, editing and deleting an user
	
	TODO: Test new createUser function
	
// --->

<cfcomponent output='false'>

	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<cffunction access="public" name="CreateUser" output="false" returntype="struct"
			hint="create a new user in the system">
		<cfargument name="username" type="string" required="true"
			hint="full username including domain, e.g. john@doe.com">
		<cfargument name="firstname" type="string" required="true"
			hint="first name">
		<cfargument name="companykey" type="string" required="true"
			hint="entrykey of company">
		<cfargument name="createdbyuserkey" type="string" default="" required="false"
			hint="who has created this user?">
		<cfargument name="password" type="string" required="true"
			hint="password in plaintext format">
		<cfargument name="address1" type="string" default="" required="true"
			hint="street address">
		<cfargument name="city" type="string" default="" required="true"
			hint="street address">
		<cfargument name="country" type="string" default="" required="true"
			hint="country (maybe iso code)">
		<cfargument name="zipcode" type="string" default="" required="true"
			hint="zipcode of address">
		<cfargument name="sex" type="numeric" default="0" required="true"
			hint="sex (0 = male; 1 = female)">
		<cfargument name="birthday" type="string" required="false" default=""
			hint="birthday of user">
		<cfargument name="mobilenr" type="string" required="false" default=""
			hint="cellphone number of user">
		<cfargument name="createmailuser" type="boolean" default="true"
			hint="create an user in the email system as well?">
		<cfargument name="utcdiff" type="numeric" default="-1"
			hint="utc difference ">
		<cfargument name="daylightsavinghours" type="numeric" default="0"
			hint="daylight saving hours  set to -1 ... zero ...">
		<cfargument name="position" type="string" default="" required="false"
			hint="position in company">
		<cfargument name="title" type="string" default="" required="false"
			hint="title">
		<cfargument name="productkey" type="string" required="true" default="AE79D26D-D86D-E073-B9648D735D84F319"
			hint="entrykey of assigned product to user (=licence)">
		<cfargument name="department" type="string" required="false" default=""
			hint="department ...">
		<cfargument name="externalemail" type="string" required="false" default=""
			hint="second email adress">
		<cfargument name="language" type="numeric" default="0" required="no"
			hint="language ... default = german (0)">
		<cfargument name="account_type" type="numeric" default="0" required="no"
			hint="account type ...">
			
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var a_str_userkey = CreateUUID() />
		<cfset var a_str_tmp_username = '' />
		<cfset var SelectNewUseridRequest = StructNew() />
		<cfset var q_select_company_data = 0 />
		<cfset var q_select_licence_status = 0 />
		<cfset var a_bol_return_removeseat = false />
		<cfset var a = false />
		<cfset var a_bol_return = false />
		
		<!--- ALWAYS lowercase --->
		<cfset arguments.username = LCase(arguments.username) />
		
		<cfif Len(arguments.password) IS 0>
			<cfreturn SetReturnStructErrorCode(stReturn, 501) />
		</cfif>
		
		<!--- execute some checks on the username ... --->
		<cfif len(arguments.username) is 0>
			<cfreturn SetReturnStructErrorCode(stReturn, 501) />
		</cfif>
		
		<cfif Len(ExtractEmailAdr(arguments.username)) is 0>
			<cfreturn SetReturnStructErrorCode(stReturn, 502) />
		</cfif>
		
		<cfif UsernameExists(arguments.username)>
			<cfreturn SetReturnStructErrorCode(stReturn, 503) />
		</cfif>
		
		<!--- check if only valid chars are included ...remove the @ sign --->
		<cfset a_str_tmp_username = ReplaceNoCase(arguments.username, '@', '') />
		
		<cfif ReFindNoCase("[^0-9,a-z,.,--,_]", a_str_tmp_username, 1) GT 0>
			<cfreturn SetReturnStructErrorCode(stReturn, 502) />
		</cfif>
		
		<!--- check licence and maybe buy user --->
		<cfinvoke component="#application.components.cmp_customer#" method="GetCustomerData" returnvariable="q_select_company_data">
			<cfinvokeargument name="entrykey" value="#arguments.companykey#">
		</cfinvoke>
		
		<cfif q_select_company_data.status IS 0>
		
			<!--- already a paid service ... check licence ... --->
			<cfinvoke component="#application.components.cmp_licence#" method="GetLicenceStatus" returnvariable="q_select_licence_status">
				<cfinvokeargument name="companykey" value="#arguments.companykey#">
				<cfinvokeargument name="productkey" value="#arguments.productkey#">
			</cfinvoke>
			
			<cfif val(q_select_licence_status.availableseats) IS 0>				
				<cfreturn SetReturnStructErrorCode(stReturn, 510) />	
			</cfif>
			
			<!--- subtract now one available seat ... --->			
			<cfinvoke component="#application.components.cmp_licence#" method="AddAvailableSeats" returnvariable="a_bol_return_removeseat">
				<cfinvokeargument name="companykey" value="#arguments.companykey#">
				<cfinvokeargument name="productkey" value="#arguments.productkey#">
				<cfinvokeargument name="addseats" value="-1">
				<cfinvokeargument name="comment" value="User #arguments.username# created by #arguments.createdbyuserkey#">
			</cfinvoke>
			
		</cfif>
		
		<!--- call insert query ... --->
		<cfinclude template="queries/q_insert_user.cfm">
		
		<cfset SelectNewUseridRequest.entrykey = a_str_userkey />
		<cfinclude template="queries/q_select_new_userid.cfm">
		
		<!--- create mailuser --->
		
		<cfif arguments.createmailuser>
			<!--- create the mailuser now ... --->
			
			<!--- call via cfinvoke ... no chance that parameter order might change ... --->
			<cfinvoke component="/components/email/cmp_accounts" method="CreateInternalEmailAccount" returnvariable="a_bol_return">
				<cfinvokeargument name="entrykey" value="#createuuid()#">
				<cfinvokeargument name="emailaddress" value="#arguments.username#">
				<cfinvokeargument name="password" value="#arguments.password#">
				<cfinvokeargument name="displayname" value="#trim(arguments.firstname&" "&arguments.surname)#">
				<cfinvokeargument name="userkey" value="#a_str_userkey#">
				<cfinvokeargument name="userid" value="#q_select_new_userid.userid#">
			</cfinvoke>

			
		</cfif>	
		
		<cfinvoke component="#request.a_str_component_im#" method="CreateIMUser" returnvariable="a">
			<cfinvokeargument name="userkey" value="#a_str_userkey#">
			<cfinvokeargument name="username" value="#arguments.username#">
			<cfinvokeargument name="password" value="#arguments.password#">
		</cfinvoke>
		
		<!--- return
		
			a) the result (true)
			b) the new entrykey of this user
			c) the new userid
			
			--->
			
		<cfset stReturn.entrykey = a_str_userkey / >
		<cfset stReturn.userid = q_select_new_userid.userid />
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
		
	</cffunction>
	
	<!--- edit a user ... --->
	<cffunction access="public" name="EditUser" output="false" returntype="boolean">
		<!--- the entrykey ... --->
		<cfargument name="entrykey" type="string" default="" required="true">
		
		<cfreturn true />	
	</cffunction>
	
	<!--- delete a user ... --->
	<cffunction access="public" name="DeleteUser" output="false" returntype="boolean">
		<cfargument name="entrykey" type="string" required="true" hint="the entrykey of the user to delete">
		<!--- companykey --->
		<cfargument name="companykey" type="string" required="true">
		<!--- make a backup? --->
		<cfargument name="makebackup" type="boolean" default="false" required="false">
		<!--- who has requested this action? --->
		<cfargument name="createdbyuserkey" type="string" required="false" default="">
		<!--- what should happen to the data of this user? --->
		<cfargument name="actionfordata" type="string" default="ignore" hint="ignore,export,move" required="no">
		<!--- parameter for the export & backup method --->
		<cfargument name="actionfordata_userkey" type="string" default="" hint="the userkey">
		
		<!--- delete everyhing of an user ... --->
		<cfset var a_str_company_key_of_user = '' />
		<cfset var stReturn = 0 />
		<cfset var q_select_user = 0 />
		<cfset var LoadDataRequest = StructNew() />
		<cfset var a_str_workgroupkey = '' />
		<cfset var q_insert_wddx = 0 />
		<cfset var a_bol_return = false />
		<cfset var q_select_workgroup_memberships = 0 />
		<cfset var a_bol_return_delete_wg_ms = false />
		<cfset var q_select_company_data = 0 />
		<cfset var a_bol_return_removeseat = false />
		
		<!--- load user data --->
		<cfinvoke component="cmp_load_userdata" method="LoadUserData" returnvariable="stReturn">
			<cfinvokeargument name="entrykey" value="#arguments.entrykey#">
		</cfinvoke>
		
		<cfif StructKeyExists(stReturn, 'query') IS FALSE>
			<cfreturn false>
		</cfif>
		
		<cfset q_select_user = stReturn.query>
		
		<cfset a_str_company_key_of_user = q_select_user.companykey>
		
		<!--- make backup/move data? --->
		<cfif arguments.actionfordata NEQ 'ignore'>
		
			<cfif Len(arguments.actionfordata_userkey) IS 0>
				<cfthrow message="export userkey cannot be empty">
			</cfif>
		
			<!--- ok, here we go ... --->
			<cfset LoadDataRequest.userkey = arguments.entrykey>
			
			<cfinclude template="utils/inc_delete_user_load_data.cfm">
			
			<cfswitch expression="#arguments.actionfordata#">
				<cfcase value="export">
					<!--- export and make backup --->
					<cfinclude template="utils/inc_delete_user_make_backup.cfm">
				</cfcase>
				<cfcase value="move">
					<!--- move data to a different user ... first make backup and then move data ... --->
					<cfinclude template="utils/inc_delete_user_make_backup.cfm">
					
					<cfinclude template="utils/inc_delete_user_move_data.cfm">
				</cfcase>
			</cfswitch>
		</cfif>
		
		<!----
		
			a) email address
			b) email data
			c) storage files
			d) misc Databases
			e) workgroup memberships
			f) shared data entries
			g) instant messenger
			h) users
			i) alerts ...
			
			TODO
			
			follow ups
			fax routing
		
		--->
		<!--- <cfwddx action="cfml2wddx" input="#q_select_user#" output="a_str_wddx">
		
		<cfquery name="q_insert_wddx" datasource="#request.a_str_db_users#">
		INSERT INTO oldusers
		(userid,username,userkey,wddx,dt_deleted)
		VALUES
		(<cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_user.userid#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_user.username#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_user.entrykey#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_wddx#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
		;
		</cfquery> --->
		
		<!--- delete postfix / courier entry --->
		
		<cfinvoke component="/components/email/cmp_accounts" method="DeleteWholeEmailAccount" returnvariable="a_bol_return">
			<cfinvokeargument name="emailaddress" value="#q_select_user.username#">
			<cfinvokeargument name="userkey" value="#arguments.entrykey#">
			<cfinvokeargument name="companykey" value="#arguments.companykey#">
		</cfinvoke>
		
		<!--- delete alias addresses --->
		
		
		<!--- delete person items ... --->
		
		
		<!--- select storage files ... --->
		
		<!--- delete storage files ... --->
		
		<!--- delete calendar items ... --->
		
		<!--- delete address book items ... --->
		
		
		<!--- delete workgroup_memberships ... --->
		<cfinvoke component="cmp_user" method="GetWorkgroupMemberships" returnvariable="q_select_workgroup_memberships">
			<cfinvokeargument name="entrykey" value="#arguments.entrykey#">
		</cfinvoke>
		
		<cfloop query="q_select_workgroup_memberships">
			<cfset a_str_workgroupkey = q_select_workgroup_memberships.workgroupkey>
			
			<cfinvoke component="#request.a_str_component_workgroups#" method="RemoveWorkgroupMember" returnvariable="a_bol_return_delete_wg_ms">
				<cfinvokeargument name="workgroupkey" value="#a_str_workgroupkey#">
				<cfinvokeargument name="userkey" value="#arguments.entrykey#">
			</cfinvoke>
			
		</cfloop>
		
		<!--- delete instant messenger items ... --->
		
		
		<cfinvoke component="#application.components.cmp_customer#" method="GetCustomerData" returnvariable="q_select_company_data">
			<cfinvokeargument name="entrykey" value="#arguments.companykey#">
		</cfinvoke>
		
		<cfif q_select_company_data.status IS 0>
			<!--- company has paid account --->
		
			<!--- add one seat ... --->			
			<cfinvoke component="#application.components.cmp_licence#" method="AddAvailableSeats" returnvariable="a_bol_return_removeseat">
				<cfinvokeargument name="companykey" value="#arguments.companykey#">
				<cfinvokeargument name="productkey" value="#q_select_user.productkey#">
				<cfinvokeargument name="addseats" value="1">
				<cfinvokeargument name="comment" value="User #q_select_user.username# deleted by #arguments.createdbyuserkey#">
			</cfinvoke>
			
		</cfif>		
		
		<!--- delete user now ... --->
		<cfinclude template="queries/q_delete_user.cfm">
		
		<cfreturn true>	
	</cffunction>
	
	<!--- //////////////////////////////////////////////////////////////////////////////////////////////////////////// --->	
	<!--- return the username by the userkey ... --->
	<!--- if no such user exists, a blank string is returned --->
	<cffunction access="public" name="GetUsernamebyentrykey" output="false" returntype="string">
		<cfargument name="entrykey" type="string" default="any" required="true">
		
		<cfset var a_str_hash_cache = 'a_str_username_lookup_' & hash(arguments.entrykey) />
		<cfset var SelectUsernameByuserkeyRequest = StructNew() />
		<cfset var q_select_username_by_entrykey = 0 />
		
		<cfif StructKeyExists(request, a_str_hash_cache)>
			<cfreturn request[a_str_hash_cache] />
		</cfif>
		
		<cfset SelectUsernameByuserkeyRequest.entrykey = arguments.entrykey />
		<cfinclude template="queries/q_select_username_by_entrykey.cfm">
		
		<cfset request[a_str_hash_cache] = q_select_username_by_entrykey.username />
		
		<cfreturn q_select_username_by_entrykey.username />
	</cffunction>
	
	<cffunction access="public" name="GetShortestPossibleUserIDByEntrykey" output="false" returntype="string"
			hint="return id code or username without @ sign (be short as possible). Cache lookup result in order to avoid multiple lookups for the same id">
		<cfargument name="entrykey" type="string" required="true">
		
		<cfset var sReturn = '' />		
		<cfset var a_str_hash_id = 'LookupUserNameDef_ ' & Hash(arguments.entrykey) />
		<cfset var a_struct_cached_conn_available = false />
		<cfset var q_select_shortest_possible_userid_by_entrykey = 0 />
		<cfset var tmp = false />
		
		<cfset a_struct_cached_conn_available = application.components.cmp_cache.CheckAndReturnStoredCacheElement(a_str_hash_id) />
		
		<cfif a_struct_cached_conn_available.result>
			<cfreturn a_struct_cached_conn_available.data />
		</cfif>
		
		<cfinclude template="queries/q_select_shortest_possible_userid_by_entrykey.cfm">
		
		<cfset application.components.cmp_cache.AddOrUpdateInCacheStore(hashid = a_str_hash_id, datatostore = sReturn)>
					
		<cfreturn sReturn />
	
	</cffunction>
	
	<!--- return basic userdata (name, username, ...) --->
	<cffunction access="public" name="GetBasicUserDataByEntrykey" output="false" returntype="query">
		<cfargument name="entrykey" type="string" default="any" required="true">
		
		<cfinclude template="queries/q_select_basic_user_data.cfm">
		
		<cfreturn q_select_basic_user_data>		
	</cffunction>
	
	<cffunction access="public" name="GetFullNameByentrykey" output="false" returntype="string">
		<cfargument name="entrykey" type="string" required="true">
		<cfinclude template="queries/q_select_user_fullname_by_entrykey.cfm">
		<cfreturn trim(q_select_user_fullname_by_entrykey.firstname&' '&q_select_user_fullname_by_entrykey.surname)>
	</cffunction>
	
	<cffunction access="public" name="GetEntrykeyFromUsername" output="false" returntype="string">
		<cfargument name="username" type="string" required="true">
	
			<cfinclude template="queries/q_select_entrykey_by_username.cfm">
			
		<cfreturn q_select_entrykey_by_username.entrykey>
	</cffunction>
	
	
	<!--- //////////////////////////////////////////////////////////////////////////////////////////////////////////// --->
	<!--- does a username already exist? --->
	<cffunction access="public" name="UsernameExists" output="false" returntype="boolean">
		<!--- the full username (inclusive domain ... ) --->
		<cfargument name="username" type="string" default="" required="true">
		<cfset var SelectUsernameExists = StructNew() />
		<cfset var a_bol_result = false />
		<cfset var q_select_username_exists = 0 />
		<cfset SelectUsernameExists.Username = arguments.username>
		<cfinclude template="queries/q_select_username_exists.cfm">
		
		<cfset a_bol_result = q_select_username_exists.count_userid is 1>
		
		<cfreturn a_bol_result>
	
	</cffunction>
	
	<cffunction access="public" name="UserkeyExists" output="false" returntype="boolean">
		<cfargument name="userkey" type="string" required="true">
		
		<cfinclude template="queries/q_select_userkey_exists.cfm">
		
		<cfreturn (q_select_userkey_exists.count_id IS 1)>
	</cffunction>
	
	
	<!--- does an email address already exist? --->
	<cffunction access="public" name="EmailAddressExists" output="false" returntype="boolean">
		<!--- the email address ... --->
		<cfargument name="emailaddress" type="string" default="" required="true">
		
		<!--- check by query ... --->
		
		<cfreturn false>
	</cffunction>
	
	<!--- delete a forwarding ... --->
	<cffunction access="public" name="DeleteEmailAddress" output="false" returntype="boolean">
		<!--- the entrykey ... --->
		<cfargument name="entrykey" type="string" default="" required="true">
		
		<cfreturn true>
	</cffunction>
	
	<!--- check user, company, reseller for a custom style --->
	<cffunction access="public" name="GetUserCustomStyle" output="false" returntype="string" hint="return the custom style of the user">
		<cfargument name="userkey" type="string" required="yes">
		
		<cfset var sReturn = ''>
		<cfset var q_select_style_user = 0 />
		<!--- get entrykey of company --->
		<cfset var a_str_companykey = GetCompanyKeyOfuser(arguments.userkey)>
		<cfset var a_str_partnerkey = '' />
		
		<!--- try user --->
		<cfinclude template="queries/q_select_style_user.cfm">
		
		<cfif (Len(q_select_style_user.style) GT 0) AND (Compare(q_select_style_user.style, request.a_str_default_style) NEQ 0)>
			<cfset sReturn = q_select_style_user.style>
		</cfif>
		
		
		
		<cfif (Len(sReturn) IS 0)>
			
			<cfinclude template="queries/q_select_style_company.cfm">
			
			<cfif (Len(q_select_style_company.style) GT 0) AND (Compare(q_select_style_company.style, request.a_str_default_style) NEQ 0)>
				<cfset sReturn = q_select_style_company.style>
			</cfif>
		</cfif>
		
		<cfif Len(sReturn) IS 0>
			<!--- get entrykey of partner --->
			<cfset a_str_partnerkey = application.components.cmp_customer.GetPartnerKeyOfCustomer(companykey = a_str_companykey)>
			
			<cfinclude template="queries/q_select_style_partner.cfm">
			
			<cfif (Len(q_select_style_partner.style) GT 0) AND (Compare(q_select_style_partner.style, request.a_str_default_style) NEQ 0)>
				<cfset sReturn = q_select_style_partner.style>
			</cfif>
		</cfif>		
		
		<cfreturn sReturn>
	</cffunction>
	
	<!--- create a structure holding several user preferences which are always needed ... --->
	<cffunction access="public" name="GetUsersettings" output="false" returntype="struct">
		<cfargument name="userkey" type="string" required="true" hint="the userkey of the user">
		<cfargument name="device_type" type="string" required="no" default="www" hint="www, pda, wap or other">
		
		<cfset var stReturn = StructNew() />
		<cfset var q_select_mailprofile = 0 />
		<cfset var q_select_user_settings = 0 />
		<cfset var a_str_index = '' />
		
		<cfinclude template="queries/q_select_user_settings.cfm">
		
		<cfset stReturn.utcdiff = q_select_user_settings.utcdiff + q_select_user_settings.daylightsavinghours />
		<cfset stReturn.daylightsavinghoursonly = q_select_user_settings.daylightsavinghours />
		<cfset stReturn.utcdiffonly = q_select_user_settings.utcdiff />
		<cfset stReturn.charset = q_select_user_settings.charset />
		<cfset stReturn.mailcharset = q_select_user_settings.mailcharset />
		<cfset stReturn.mailusertype = val(q_select_user_settings.mailusertype) />
		<cfset stReturn.default_dateformat = 'dd.mm.yy' />
		<cfset stReturn.default_timeformat = 'HH:mm' />
		
		<!--- last page visit ... --->
		<cfset stReturn.LastPageRequest = '' />
		
		<!--- store various personal properties (cache them) --->
		<cfset stReturn.cached_personal_properties = StructNew() />
		
		<!--- language --->
		<cfset stReturn.language = q_select_user_settings.defaultlanguage />
		
		<!--- country iso code --->
		<cfset stReturn.countryisocode = q_select_user_settings.countryisocode />
		
		<!--- event handlers enabled ... log events ... --->
		<cfset stReturn.eventhandlerregistered = true />
		
		<!--- default style --->
		<cfset stReturn.style = request.a_str_default_style />
		
		<!--- add a custom style ... --->
		<cfset stReturn.customstyle = GetUserCustomStyle(userkey = arguments.userkey) />
		
		<!--- advanced or barriere-frei ... --->
		<cfset stReturn.www_version = 'default' />
		
		<!--- which browser/device? --->
		<cfset stReturn.device = StructNew() />
		<!--- www / pda / wap --->
		<cfset stReturn.device.type = arguments.device_type />
		<cfset stReturn.device.browser_name = cgi.HTTP_USER_AGENT />
		<cfset stReturn.device.screen_height = 0 />
		<cfset stReturn.device.screen_width = 0 />
		<cfset stReturn.device.BitsPerPixel = 0 />
		
		<cfif q_select_user_settings.mailusertype IS 0>
			<cfset stReturn.struct_mailprofile = StructNew() />
		<cfelse>
			<!--- load mail profile ... --->
			<cfset q_select_mailprofile = CreateObject('component', '/components/email/cmp_accounts').GetMailProfile(userkey = arguments.userkey) />
			
			<cfloop list="#q_select_mailprofile.columnlist#" index="a_str_index">
				<cfset stReturn.struct_mailprofile[a_str_index] = q_select_mailprofile[a_str_index][1] />
			</cfloop>
		</cfif>

		<cfreturn stReturn />
	</cffunction>	
	
	<!--- get all workgroup membersships ... --->
	<cffunction access="public" name="GetWorkgroupMemberships" output="false" returntype="query">
		<!--- entrykey of user --->
		<cfargument name="entrykey" type="string" default="" required="true">
		
		<cfset var SelectWorkgroupMemberships = StructNew() />
		
		<cfset SelectWorkgroupMemberships.entrykey = arguments.entrykey>
		<cfinclude template="queries/q_select_workgroup_memberships.cfm">
		
		<cfreturn q_select_workgroup_memberships>		
	
	</cffunction>
	
	<!--- return the online status of an user ... --->
	<cffunction access="public" name="GetWebOnlineStatus" returntype="struct" output="false">
		<cfargument name="userkey" type="string" required="true">
		
		<cfset var stReturn = StructNew()>
		<cfset var q_select_session_lastcontact = 0 />
		<!---
		
			0 = offline
			3 = online/offline (contact within the last 30 minutes)
			5 = online (contact within the last 10 minutes)
			10 = online (contact within the last 5 minutes)
			
			--->
		
		<cfinclude template="queries/q_select_session_lastcontact.cfm">
		
		<cfset stReturn.status = 0>
		<cfif IsDate(q_select_session_lastcontact.dt_lastcontact) is true>
		<cfset stReturn.lastcontactminutes = DateDiff("n", q_select_session_lastcontact.dt_lastcontact, now())>
		<cfset stReturn.lastcontact = q_select_session_lastcontact.dt_lastcontact>
		<cfelse>
		<cfset stReturn.lastcontactminutes = 9999>
		<cfset stReturn.lastcontact = CreateDateTime(1900, 12, 31, 0, 0, 0)>
		</cfif>
		
		
		<cfreturn stReturn>
	</cffunction>
	
	<!--- return the companykey of a user ... --->
	<cffunction access="public" name="GetCompanyKeyOfuser" output="false" returntype="string">
		<cfargument name="userkey" type="string" required="true">
		<cfset var q_select_companykey = 0 />
		
		<cfquery name="q_select_companykey" datasource="#request.a_str_db_users#">
		SELECT
			companykey
		FROM
			users
		WHERE
			entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
		;
		</cfquery>
	
		<cfreturn q_select_companykey.companykey>
	</cffunction>
	
	<!--- set photo data ... --->
	<cffunction access="public" name="SetUserPhoto" output="false" returntype="boolean">
		<!--- userkey ... --->
		<cfargument name="entrykey" type="string" required="true">
		<!--- photo data (the filename) --->
		<cfargument name="photofilename" type="string" required="true">
		<!--- type ... 0 = small; 1 = big --->
		<cfargument name="type" type="numeric" default="0">
		
		
		<cfreturn true>
	</cffunction>
	
	<!--- what should happen if an event is assigned to an user or a new task is created? --->
	<cffunction access="public" name="GetAlertOnNewItemsSettings" output="false" returntype="string">
		<cfargument name="userkey" type="string" required="true">
		<!--- service --->
		<cfargument name="servicekey" type="string" required="true">
		
		<!--- ok, here we go ... return the string containg the desired methods --->
		<cfreturn 'email'>
		
	</cffunction>
	
	<!--- disable/enable a user ... --->
	<cffunction access="public" name="UpdateAllowLoginStatus" output="false" returntype="boolean">
		<cfargument name="userkey" type="string" required="true" hint="the entrykey of the user">
		<cfargument name="companykey" type="string" required="true" hint="the companykey">
		<cfargument name="allowlogin" type="numeric" default="1" required="true" hint="1 = yes; -1 = no; 0= yes">
		
		<cfinclude template="queries/q_update_allowlogin.cfm">
			
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="GetAllowLoginStatus" output="false" returntype="boolean">
		<cfargument name="userkey" type="string" required="yes">
		
		<cfinclude template="queries/q_select_user_is_disabled.cfm">
		
		<cfreturn (q_select_user_is_disabled.allow_login IS 1)>
		
	</cffunction>
	
	<!--- update the password --->
	<cffunction access="public" name="UpdatePassword" output="false" returntype="boolean">
		<cfargument name="userkey" type="string" required="true">
		<cfargument name="companykey" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<cfargument name="updatepop3password" type="boolean" required="false" default="true">
		<cfargument name="updateimpassword" type="boolean" required="false" default="true">
		
		<cfset var q_update_pwd = 0 />
		<cfset var a = false />
		<cfset var stReturn = false />
		<cfset var a_bol_Return = False />
		
		<cfinclude template="queries/q_update_pwd.cfm">
		
		<!--- update the IM password ... --->		
		<cfinvoke component="#request.a_str_component_im#" method="UpdateIMPassword" returnvariable="a">
			<cfinvokeargument name="userkey" value="#arguments.userkey#">
			<cfinvokeargument name="password" value="#arguments.password#">
		</cfinvoke>		
		
		<cfif arguments.updatepop3password IS TRUE>
			<!--- update password in a) pop3_data and b) postfix/courier DB --->
			
			<!--- load username ... --->
			<cfinvoke component="cmp_load_userdata" method="LoadUserData" returnvariable="stReturn">
				<cfinvokeargument name="entrykey" value="#arguments.userkey#">
			</cfinvoke>
			
			<!--- invoke mailsystems component ... --->
			<cfinvoke component="/components/email/cmp_accounts" method="UpdateEmailPassword" returnvariable="a_bol_return">
				<cfinvokeargument name="emailaddress" value="#stReturn.query.username#">
				<cfinvokeargument name="password" value="#arguments.password#">
				<cfinvokeargument name="userkey" value="#arguments.userkey#">
			</cfinvoke>
			
			
		</cfif>
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="ForceSettingsReloadForUser" output="false" returntype="boolean">
		<cfargument name="userkey" type="string" required="true">
		
		<cfinclude template="queries/q_update_reloadpermissions.cfm">

		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="IsPhotoAssignedToUser" output="false" returntype="struct">
		<cfargument name="userkey" type="string" required="false" default="">
		<cfargument name="username" type="string" required="false" default="">
		
		<cfset var stReturn = StructNew() />
		<cfset var q_select_photo_settings = 0 />
		
		<cfif Len(arguments.username) IS 0 AND Len(arguments.userkey) IS 0>
			<cfreturn stReturn>
		</cfif>
		
		<cfinclude template="queries/q_select_photo_settings.cfm">
		
		<cfset stReturn.smallphotoavailable = q_select_photo_settings.smallphotoavaliable>
		<cfset stReturn.bigphotoavailable = q_select_photo_settings.bigphotoavaliable>
		<cfset stReturn.username = q_select_photo_settings.username>
		<cfset stReturn.entrykey = q_select_photo_settings.entrykey>
		
		<cfreturn stReturn>
	</cffunction>
	
	<cffunction access="public" name="GetFaxSignature" returntype="string" output="false">
		<cfargument name="userkey" type="string" required="true">
		<cfinclude template="queries/q_select_fax_signature.cfm">
		<cfreturn q_select_fax_signature.faxsignature>
	</cffunction>
	
	<cffunction access="public" name="SetFaxSignature" returntype="boolean" output="false">
		<cfargument name="userkey" type="string" required="true">
		<cfargument name="signature" type="string" required="true">
			<cfinclude template="queries/q_update_fax_signature.cfm">
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="SetFaxLogo" returntype="boolean" output="false">
		<cfargument name="userkey" type="string" required="true">
		<cfargument name="filename" type="string" required="true">
		<cfinclude template="queries/q_update_faxlogo.cfm">
		<cfreturn true>	
	</cffunction>
	
	<cffunction access="public" name="FaxLogoAvailableForUser" returntype="boolean" output="false">
		<cfargument name="userkey" type="string" required="true">
		<cfinclude template="queries/q_select_fax_logo_available.cfm">
		<cfreturn (q_select_fax_logo_available.recordcount IS 1)>
	</cffunction>
	
	<cffunction access="public" name="UpdateUserProductKey" output="false" returntype="boolean">
		<cfargument name="userkey" type="string" required="true">
		<cfargument name="productkey" type="string" required="true">
		<!--- was this account a trial account? --->
		<cfargument name="wastrialaccount" type="numeric" default="0" required="false">
		
		<cfif arguments.wastrialaccount IS 0>
			<!--- remove licence and check if one is avaiable ... --->
		</cfif>

		<cfinclude template="queries/q_update_user_productkey.cfm">
		
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="GetUserData" returntype="query" output="false"
			hint="load user data and return as query">
		<cfargument name="userkey" type="string" required="yes">
		<cfargument name="fields" type="string" required="no" default="">
		
		<cfinclude template="queries/q_select_user_data.cfm">
		
		<cfreturn q_select_user_data />
	</cffunction>
	
	<cffunction access="public" name="GetLanguageOfUser" output="false" returntype="numeric">
		<cfargument name="userkey" type="string" required="yes">
		<cfinclude template="queries/q_select_user_language.cfm">

		<cfreturn val(q_select_user_language.defaultlanguage)>
		
	</cffunction>
	
	<cffunction access="public" name="UpdateUserData" output="false" returntype="struct"
			hint="update user data">
		<cfargument name="userkey" type="string" required="true" hint="entrykey of user">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="newvalues" type="struct" required="true" hint="struct holding the new data">
		
		<cfset var stReturn = GenerateReturnStruct()>	
		
		<!--- <cfreturn SetReturnStructErrorCode(stReturn, 12502)>--->
		
		<!--- check security --->
		<cfset var a_bol_check_security = false>
		
		<!--- user itself, or admin or reseller ... TODO: finish checks! --->
		<cfset a_bol_check_security = (CompareNoCase(arguments.userkey, arguments.securitycontext.myuserkey) IS 0)>
		
		<cfif a_bol_check_security>
			<cfinclude template="queries/q_update_user_data.cfm">
		</cfif>

		<cfreturn SetReturnStructSuccessCode(stReturn)>
		
	</cffunction>

</cfcomponent>

