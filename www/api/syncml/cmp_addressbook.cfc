<cfcomponent output='false'>

	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<cfset sServiceKey = "52227624-9DAA-05E9-0892A27198268072">
	
	<cfsetting requesttimeout="20000">
	
	<cffunction access="remote" name="CreateContact" output="false" returntype="boolean" hint="insert a new contact">
		<!--- entrykey ... --->
		<cfargument name="entrykey" type="string" required="true" hint="the desired entrykey (UUID)">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		
		<cfargument name="firstname" type="string" required="false" default="" hint="First name">
		<cfargument name="surname" type="string" required="false" default="" hint="Surname">
		<cfargument name="company" type="string" required="false" default="">
		<cfargument name="department" type="string" required="false" default="">
		<cfargument name="position" type="string" required="false" default="">
		<cfargument name="title" type="string" required="false" default="">
		<cfargument name="sex" type="numeric" required="false" default="-1" hint="0 = male; 1 = female; -1 = unknown (default)">
		<cfargument name="email_prim" type="string" required="false" default="">
		<cfargument name="email_adr" type="string" required="false" default="">
		<cfargument name="birthday" type="string" required="false" default="" hint="birthday (in ts{...} format)">
		<cfargument name="categories" type="string" required="false" default="">
		
		<cfargument name="b_street" type="string" required="false" default="">
		<cfargument name="b_city" type="string" required="false" default="">
		<cfargument name="b_zipcode" type="string" required="false" default="">
		<cfargument name="b_country" type="string" required="false" default="">
		<cfargument name="b_telephone" type="string" required="false" default="">
		<cfargument name="b_fax" type="string" required="false" default="">
		<cfargument name="b_mobile" type="string" required="false" default="">
		<cfargument name="b_url" type="string" required="false" default="">		
		
		<cfargument name="p_street" type="string" required="false" default="">
		<cfargument name="p_city" type="string" required="false" default="">
		<cfargument name="p_zipcode" type="string" required="false" default="">
		<cfargument name="p_country" type="string" required="false" default="">
		<cfargument name="p_telephone" type="string" required="false" default="">
		<cfargument name="p_fax" type="string" required="false" default="">
		<cfargument name="p_mobile" type="string" required="false" default="">
		<cfargument name="p_url" type="string" required="false" default="">				
		
		<cfargument name="notice" type="string" required="false" default="">
		<cfargument name="archiveentry" type="numeric" default="0" required="false">
		
		<cfargument name="sender" type="string" default="user" required="no" hint="sender of item (internal use only) ... f.e. SyncML, webservice, ...">
		
		<cfargument name="contacttype" type="numeric" default="0" required="no" hint="0 = contact (default); 1 = account (organisation)">
		<cfargument name="parentcontactkey" type="string" default="" required="no" hint="entrykey of parent contact">
		
		<!--- invoke component ... --->		
		<cfinvoke argumentcollection="#arguments#" component="#application.components.cmp_addressbook#" method="CreateContact" returnvariable="a_bol_return"/>
		
		<cfreturn a_bol_return>	
	</cffunction>
	
	<cffunction access="remote" name="DeleteContact" output="false" returntype="boolean" hint="Delete a contact ... returns true if successfully deleted">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="entrykey" type="string" required="true" hint="entrykey of item">
		<cfargument name="usersettings" type="struct" required="true">
		<!--- load contact and check security ... --->
		<!--- delete outlook sync information too? --->
		<cfargument name="clearoutlooksyncmetadata" type="boolean" required="false" default="true" hint="clear meta data too (default = true)">		
		<cfargument name="sender" type="string" default="user" required="no" hint="sender of this operation (f.e. syncml, outlooksync, ...)">
		
		<cfinvoke argumentcollection="#arguments#" component="#application.components.cmp_addressbook#" method="DeleteContact" returnvariable="a_bol_return"/>
		
		<cfreturn a_bol_return>		
	</cffunction>
	
	<cffunction access="remote" name="GetAllContacts" output="false" returntype="struct">
		<!--- check access and so on ... --->
		<cfargument name="securitycontext" type="struct" required="true">
		<!--- orderby ... --->
		<cfargument name="orderby" type="string" default="" required="false" hint="order by certain field">
		<!--- OPTIONS ... load associacted with a project ... --->
		<cfargument name="loadoptions" type="struct" required="false" default="#StructNew()#" hint="various loading options">
		<!--- list of fields to load ... by default we load only some fields ... --->
		<cfargument name="fieldlist" type="string" required="false" default="firstname,surname,email_prim,entrykey" hint="field list to load">
		<!--- search/filter ... --->
		<cfargument name="filter" type="struct" required="false" default="#StructNew()#" hint="filter/search items">
		<!--- usersettings ... --->
		<cfargument name="usersettings" type="struct" required="true">
		<!--- load full data (for outlook synchronisation) --->
		<cfargument name="loadfulldata" type="boolean" required="false" default="false" hint="load all available fields (especially for outlookSync)">
		<!--- load distinct categories? --->
		<cfargument name="loaddistinctcategories" type="boolean" required="false" default="true" hint="create a structure holding the distinct categories">
		<!--- load utc times? --->
		<cfargument name="convert_lastcontact_utc" type="boolean" required="no" default="true" hint="return user timezone based timestamps instead of UTC">
		<!--- crm filters --->
		<cfargument name="crmfilter" type="struct" required="no" default="#StructNew()#" hint="crm filters">
		<!--- load data from own database associated with this contact? --->
		<cfargument name="loadowndatafields" type="boolean" default="false" required="no">	
		
		<cfinvoke argumentcollection="#arguments#" component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn"/>
		
		<cfreturn stReturn>
				
	</cffunction>		
	
	<cffunction access="remote" name="UpdateContact" output="false" returntype="boolean" hint="update a contact">
		<!--- the entrykey ... --->
		<cfargument name="entrykey" type="string" required="true" hint="entrykey of contact">
		<!--- security context ... --->
		<cfargument name="securitycontext" type="struct" required="true">		
		
		<cfargument name="usersettings" type="struct" required="true">
		<!--- the new values ... --->
		<cfargument name="newvalues" type="struct" required="true" hint="CFMX structure holding the data to update ... field names are the same as in createContact">
		<!--- update lastmodified? --->
		<cfargument name="updatelastmodified" type="boolean" required="false" default="true" hint="update the lastmodified property">
		<!--- sender ... --->
		<cfargument name="sender" type="string" default="user" required="no" hint="sender of this operation">	
		
		<cfinvoke argumentcollection="#arguments#" component="#application.components.cmp_addressbook#" method="UpdateContact" returnvariable="a_bol_return"/>
		
		<cfreturn a_bol_return>
				
	</cffunction>
	
	<cffunction access="remote" name="GetContact" output="false" returntype="struct">
		<cfargument name="entrykey" type="string" required="true" hint="entrykey of the contact">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="loadphoto" type="boolean" default="true" required="false">
		<cfargument name="loadcrmdata" type="boolean" default="false" required="no" hint="load the crm data (own query in the return strucutre)">
		
		<cfinvoke argumentcollection="#arguments#" component="#application.components.cmp_addressbook#" method="GetContact" returnvariable="stReturn"/>
		
		<cfreturn stReturn>
				
	</cffunction>
</cfcomponent>