<!--- //

	Component:	Cache
	Description:Administrate cache component for caching
				various settings, connections and so on ...
				
				Examples of things to store:
				
				- IMAP connections
				- Queries
				- ...
				
				We store everything in Application scope so that
				session scope is kept clean
				
	

// --->

<cfcomponent name="Cache Component" output="false">
	
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<cffunction access="public" name="AddOrUpdateInCacheStore" output="false" returntype="struct"
			hint="Add or update an element stored in the cache">
		<cfargument name="hashid" type="string" required="true"
			hint="unique cache ID">
		<cfargument name="store" type="string" required="false" default="application"
			hint="which store to use for caching ... application, session or database">
		<cfargument name="datatostore" type="any" required="true"
			hint="Data to store (query, IMAP connection, struct, ...)">
		<cfargument name="expires_minutes" type="numeric" default="10" required="false"
			hint="expired in n minutes">
		<cfargument name="description" type="string" required="false" default=""
			hint="optional: a short description ...">
		<cfargument name="built_in_datatostore_type" type="string" default="" required="false"
			hint="is it a special type of data to store where pre defined procecured should take place when removed from cache">
		<cfargument name="updatetimeout_only_if_found" default="false" type="boolean"
			hint="update the expiration time only if found ... do not set new data">
			
		<cfset var a_return_struct = GenerateReturnStruct() />
		
		
		<cfif Len(arguments.hashid) IS 0>
			<cfreturn SetReturnStructErrorCode(a_return_struct, 999) />
		</cfif>
		
		<cfif ElementExistsInCache(arguments.hashid)>
			
			<!--- update only the timeout but do not re-store data ... --->
			<cfif arguments.updatetimeout_only_if_found>
				<cflock scope="Application" timeout="3" type="exclusive">
					<cfset application.cache.cache_expire_information[arguments.hashid] = DateAdd('n', arguments.expires_minutes, Now()) />
					<cfreturn SetReturnStructSuccessCode(a_return_struct) />
				</cflock>
			</cfif>
			
			<cfset RemoveElementFromCache(arguments.hashid) />
		</cfif>
		
		<!--- store information in cache ... --->
		<cflock scope="Application" timeout="10" type="exclusive">
			
			<!--- create structure ... --->
			<cfset application.cache.cached_elements[arguments.hashid] = StructNew() />
			
			<!--- data to store ... --->
			<cfset application.cache.cached_elements[arguments.hashid].data = arguments.datatostore />
			
			<!--- description ... --->
			<cfset application.cache.cached_elements[arguments.hashid].cache_description = arguments.description & ' (created ' & Now() & ')' />
			
			<!--- the timeout ... --->
			<cfset application.cache.cached_elements[arguments.hashid].cache_timeout = arguments.expires_minutes />
			
			<!--- pre-defined data? ... --->
			<cfset application.cache.cached_elements[arguments.hashid].cache_built_in_datatostore_type = arguments.built_in_datatostore_type />
			
			<!--- expiration date ... --->
			<cfset application.cache.cache_expire_information[arguments.hashid] = DateAdd('n', arguments.expires_minutes, Now()) />
			
		</cflock>
		
		<cfreturn SetReturnStructSuccessCode(a_return_struct) />
	</cffunction>
	
	<cffunction access="public" name="RemoveElementFromCache" output="false" returntype="boolean"
			hint="delete an element in cache scope">
		<cfargument name="hashid" type="string" required="true"
			hint="unique id">
			
		<cfset var a_bol_exists = ElementExistsInCache(arguments.hashid) />
		<cfset var a_struct_data = 0 />
		
		
		<cflog application="false" file="ib_cache" log="Application" text="Exists #arguments.hashid#? #a_bol_exists#">
		
		<!--- if it does not exist, exit ... --->
		<cfif NOT a_bol_exists>
			<cfreturn false />
		</cfif>
		
		<cflock name="lck#CreateUUID()#" timeout="30" type="exclusive">
			<cfset a_struct_data = application.cache.cached_elements[arguments.hashid] />
		</cflock>
		
		<cflog application="false" file="ib_cache" log="Application" text="Special type? #a_struct_data.cache_built_in_datatostore_type#">
		
		<cfswitch expression="#a_struct_data.cache_built_in_datatostore_type#">
			<cfcase value="imap_connection">
				<cftry>
					<cfset application.cache.cached_elements[arguments.hashid].data.store.close() />
				<cfcatch type="any">
				</cfcatch>
				</cftry>
			</cfcase>
		</cfswitch>
			
		<cflock scope="Application" type="exclusive" timeout="10">
			<cfset StructDelete(application.cache.cached_elements, arguments.hashid) />
			<cfset StructDelete(application.cache.cache_expire_information, arguments.hashid) />
		</cflock>

		<cfreturn true />
	</cffunction>
	
	<cffunction access="public" name="ElementExistsInCache" output="false" returntype="boolean"
			hint="return true of element exists">
		<cfargument name="hashid" type="string" required="true"
			hint="unique id">
			
		<cfset var a_bol_return = false />
			
		<cflock scope="Application" timeout="3" type="readonly">
			<cfset a_bol_return = StructKeyExists(application.cache.cached_elements, arguments.hashid) />
		</cflock>
		
		<cfreturn a_bol_return />
		
	</cffunction>
	
	<cffunction access="public" name="DoCleanup" output="false" returntype="boolean"
			hint="exec a cleanup">
		
		<cfset var a_struct_expired = 0 />
		<cfset var a_str_item = '' />
		
		
		<cflog application="false" file="ib_cache" log="Application" text="Starting cache cleanup">
		
		<cflock scope="application" type="readonly" timeout="10">
			<cfset a_struct_expired = Duplicate(application.cache.cache_expire_information) />
		</cflock>
		
		<cflog application="false" file="ib_cache" log="Application" text="Starting cache cleanup">
		
		<cfloop list="#StructKeyList(a_struct_expired)#" index="a_str_item">
			<cflog application="false" file="ib_cache" log="Application" text="Checking: #a_struct_expired[a_str_item]# vs #Now()#">
			<cfif a_struct_expired[a_str_item] LT Now()>
				<!--- remove ... --->
				<cfset RemoveElementFromCache(a_str_item) />
				<cflog application="false" file="ib_cache" log="Application" text="Removing item #a_str_item#">
			</cfif>
		</cfloop>
		
		<cfreturn true />

	</cffunction>
	
	<cffunction access="public" name="CheckAndReturnStoredCacheElement" output="false" returntype="struct"
			hint="try to find element and return">
		<cfargument name="hashid" type="string" required="true"
			hint="unique id">
		<cfargument name="update_expire_time" type="boolean" default="true" required="false"
			hint="update the expire time?">
		
		<cfset var a_return_struct = GenerateReturnStruct() />
		<cfset var a_bol_elem_exists = ElementExistsInCache(arguments.hashid) />
		
		<cfif a_bol_elem_exists>	
				
			<!--- update timeout? ... --->
			<cfif arguments.update_expire_time>
				
				<cflock scope="Application" timeout="10" type="exclusive">
					
					<!--- found? update! ... --->
					<cfif StructKeyExists(application.cache.cache_expire_information, arguments.hashid)>
						<cfset application.cache.cache_expire_information[arguments.hashid] = DateAdd('n', application.cache.cached_elements[arguments.hashid].cache_timeout, Now()) />
					</cfif>
					
				</cflock>			
				
			</cfif>
			
			<!--- return cached structure ... --->
			<cflock scope="Application" type="readonly" timeout="3">
				
				<!--- set return data ... --->
				<cfset a_return_struct.data = application.cache.cached_elements[arguments.hashid].data />				
			</cflock>
			
		</cfif>
		
		<!--- return the result ... true or false --->
		<cfif a_bol_elem_exists>
			<cfreturn SetReturnStructSuccessCode(a_return_struct) />
		<cfelse>
			<cfreturn SetReturnStructErrorCode(a_return_struct, 0) />
		</cfif>
		
	</cffunction>
	
</cfcomponent>

