<!--- //

	Component:	Lang
	Description:Manage language ...
	

// --->

<cfcomponent output='false'>
	
	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
	<cfinclude template="/common/app/inc_lang.cfm">
	
	<cfset request.a_str_include_dir_templates = '/mnt/www-source/www.openTeamWare.com/common/lang/langdata/' />
	
	<cffunction access="public" name="TemplateExists" returntype="boolean" output="false"
			hint="check if a certain template exists ... at least in german (language 0)">
		<cfargument name="section" type="string" required="yes"
			hint="name of section">
		<cfargument name="template_name" type="string" required="yes"
			hint="name of template">
		<cfargument name="langno" type="numeric" required="yes"
			hint="language number">
				
		<!--- try to select template properties ... --->		
		<cfinclude template="queries/q_select_template_properties.cfm">
		
		<cfif (q_select_template_properties.recordcount IS 0)>
			
			<cfif (arguments.langno GT 0)>	
							
				<!--- return the german template --->
				<cfreturn TemplateExists(section = arguments.section, langno = 0, template_name = arguments.template_name)>
				
			<cfelse>
			
				<!--- we're already in the german section ... return FALSE - template does NOT exist --->
				<cfreturn false />
				
			</cfif>
			
		<cfelse>
		
			<!--- ok, exists! --->
			<cfreturn true />
			
		</cfif>
		
	</cffunction>
	
	<cffunction access="public" name="GetTemplateIncludePath" returntype="string" output="false"
			hint="return the absolute include path for a template">
		<cfargument name="section" type="string" required="yes"
			hint="name of section">
		<cfargument name="langno" type="numeric" required="yes"
			hint="id of language">
		<cfargument name="template_name" type="string" required="yes"
			hint="name of template">
		
		<cfset var sFilename = '' />
		<cfset var sFilename_return = '' />
		
		<!--- load from database --->
		<cfinclude template="queries/q_select_template_properties.cfm">
		
		<!--- if no template is found, return the german template --->
		<cfif (q_select_template_properties.recordcount IS 0)>
		
			<cfif (arguments.langno GT 0)>		
						
				<!--- return the german template --->
				<cfreturn GetTemplateIncludePath(section = arguments.section, langno = 0, template_name = arguments.template_name)>
				
			<cfelse>
			
				<!--- we're already in the german section ... return an empty string ... --->

				<cfinclude template="utils/inc_check_dummy_file.cfm">
				<cflog file="ib_error" application="true" type="information" log="Application" text="template #arguments.template_name# of language #arguments.langno# does not exist">
				<cfreturn GetTempDirectory() & '/dummy_template.cfm' />
				
			</cfif>
			
		</cfif> 
		
		<!--- the return filename ... --->
		<cfset sFilename_return = GetTempDirectory() & '/template_' & q_select_template_properties.entrykey & '.cfm' />
		
		<cfif q_select_template_properties.recordcount IS 0>
			
			<!--- return a dummy file ... --->
			<cfinclude template="utils/inc_check_dummy_file.cfm">
			
			<!--- return the dummy file ... --->
			<cfreturn GetTempDirectory() & '/dummy_template.cfm' />
			
		</cfif>
		
		
		<cfif NOT FileExists(sFilename)>
			
			<!--- handle file ... --->
			<cfset sFilename = request.a_str_temp_directory_local & request.a_str_dir_separator & 'template_' & q_select_template_properties.entrykey & '.cfm' />
		
			<cfinclude template="utils/inc_prepare_template.cfm">
			
		</cfif>
		
		<!--- return string ... based on --->
		<cfreturn sFilename_return />
	</cffunction>
	
	<cffunction access="public" name="GetLangValExt" returntype="string" output="false"
			hint="get translation value by entryid and language number">
		<cfargument name="entryid" type="string" required="yes">
		<cfargument name="langno" type="numeric" default="0" required="no">
		
		<!--- check if structure exists in the application scope ... --->
		<cfif IsDefined('Application') AND
			  StructKeyExists(Application.langdata, 'lang'&arguments.langno) AND
			  StructkeyExists(Application.langdata['lang'&arguments.langno], arguments.entryid)>
			<!--- return the element of the application scope ... --->
			
			<cfreturn GetLangValByLangNo(arguments.langno, arguments.entryid) />
			
		<cfelse>
		
			<!--- make a database lookup --->
			<cfinclude template="queries/q_select_lang_item.cfm">
			<cfreturn q_select_lang_item.entryvalue />
			
		</cfif>
		
	</cffunction>
	
	<cffunction name="ReadTranslationsFromCSV" output="false" returntype="boolean"
			hint="read translation from csv file and insert into database">
		
		<cfset var sFilename = application.a_struct_appsettings.properties.CONFIGURATIONDIRECTORY & ReturnDirSeparatorOfCurrentOS() & 'lang' & ReturnDirSeparatorOfCurrentOS() & 'langdata.csv' />	

		<cfif Not FileExists(sFilename)>
			
			<cfreturn false />
			
		</cfif>
		
		<cfinclude template="queries/q_delete_old_translations.cfm">
		
		<cfinclude template="utils/inc_import_csv.cfm">
			
		<cfreturn true />
	</cffunction>
	
	<cffunction access="public" name="LoadTranslationData" output="false" returntype="boolean"
			hint="Load the translation from database and write to app cache">
		<cfargument name="langno" type="numeric" required="true"
			hint="number of language">
			
		<cfset var q_select_translation_data = 0 />
		
			
		<cfinclude template="queries/q_select_translation_data.cfm">
		
		<cflock timeout="30" throwontimeout="No" type="EXCLUSIVE" scope="APPLICATION">
			
		<cfif StructKeyExists(application.langdata, 'lang' & arguments.langno)>
			<cfset StructDelete(application.langdata, 'lang' & arguments.langno) />
		</cfif>
		
		<cfset application.langdata['lang' & arguments.langno] = StructNew() />
		
		<cfoutput query="q_select_translation_data">
			<cfset StructInsert(application.langdata['lang' & arguments.langno], q_select_translation_data.entryid, q_select_translation_data.entryvalue, true) />
		</cfoutput>
		
		</cflock>
		
		<cfreturn true />
	
	</cffunction>
	
	<cffunction access="public" name="GetLanguageNumberByShortName" returntype="numeric" output="false"
			hint="return the lang number by the ISO-code">
		<cfargument name="langcode" type="string" required="true"
			hint="lang iso code">

		<cfswitch expression="#arguments.langcode#">
			<cfcase value="de">
				<cfreturn 0 />
			</cfcase>
			<cfcase value="en">
				<cfreturn 1 />
			</cfcase>
			<cfcase value="cz">
				<cfreturn 2 />
			</cfcase>
			<cfcase value="sk">
				<cfreturn 3 />
			</cfcase>
			<cfcase value="pl">
				<cfreturn 4 />
			</cfcase>
			<cfcase value="ro">
				<cfreturn 5 />
			</cfcase>
			<cfdefaultcase>
				<cfreturn 0 />
			</cfdefaultcase>
		</cfswitch>

	</cffunction>

	
	<cffunction access="public" name="GetLanguageShortNameByNumber" returntype="string" output="false"
			hint="return the lang shortcode by the internal lang number">
		<cfargument name="langid" type="numeric" required="true"
			hint="lang number">

		<cfswitch expression="#arguments.langid#">
			<cfcase value="0">
				<cfreturn 'de' />
			</cfcase>
			<cfcase value="1">
				<cfreturn 'en' />
			</cfcase>
			<cfcase value="2">
				<cfreturn 'cz' />
			</cfcase>
			<cfcase value="3">
				<cfreturn 'sk' />
			</cfcase>
			<cfcase value="4">
				<cfreturn 'pl' />
			</cfcase>
			<cfcase value="5">
				<cfreturn 'ro' />
			</cfcase>
			<cfdefaultcase>
				<cfreturn 'de' />
			</cfdefaultcase>
		</cfswitch>

	</cffunction>

</cfcomponent>

