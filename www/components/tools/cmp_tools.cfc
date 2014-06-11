<!--- //

	Module:        Tools
	Description:   Various tool functions
	

// --->

<cfcomponent output="false">
	
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<cffunction access="public" name="GetContentTypeByFilename" output="false" returntype="string"
			hint="return content type">
		<cfargument name="filePath" type="string" required="true">
		
		<cfset var sReturn = '' />
		
		<cfset sReturn = getPageContext().getServletContext().getMimeType( arguments.filePath ) />
		
		<cfif NOT IsDefined( 'sReturn' )>
			<cfreturn 'application/octet-stream' />
		<cfelse>
			<cfreturn sReturn />
		</cfif>

	</cffunction>
	
	<cffunction access="public" name="GetMobileDeviceProperties" output="false" returntype="query">
		<cfargument name="httpheaders" type="struct" required="yes" hint="http request headers">
		
		<cfset var a_struct_headers = arguments.httpheaders />
		<cfset var a_str_profile_url = '' />

		<cfif StructKeyExists(a_struct_headers, 'x-wap-profile')>
			<cfset a_str_profile_url = ReplaceNoCase(a_struct_headers['x-wap-profile'], '"', '', 'ALL') />
		<cfelseif StructKeyExists(a_struct_headers, 'profile')>
			<cfset a_str_profile_url = ReplaceNoCase(a_struct_headers['profile'], '"', '', 'ALL') />
		<cfelse>
			<!--- vielleicht mal vom user agent herleiten ... --->
			<cfset a_str_profile_url = 'dummy://does_not_exist' />
		</cfif>
		
		<!--- if parameters exist, ignore them --->
		<cfif FindNoCase(', ', a_str_profile_url) GT 0>
			<cfset a_str_profile_url = Mid(a_str_profile_url, 1, (FindNoCase(', ', a_str_profile_url) - 1)) />
		</cfif>
		
		<cflog text="profile: #a_str_profile_url#" type="Information" log="Application" file="ib_pda">
		
		<cfinclude template="utils/inc_check_mobile_client.cfm">
		
		<cfreturn q_select_wap_profile />
	</cffunction>
	
	<cffunction access="public" name="GenerateLinkToItem" output="false" returntype="string"
			hint="generate a link to an object based on servicekey, entrykey and title">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="servicekey" type="string" required="yes">
		<cfargument name="title" type="string" required="yes">
		<cfargument name="objectkey" type="string" required="yes">
		<cfargument name="format" type="string" required="no" default="html" hint="text or html">
		
		<cfset var sReturn = '' />
		<cfset var a_str_base_url = application.components.cmp_customize.GetCustomStyleData(usersettings = arguments.usersettings, entryname = 'main').BaseURL />
		
		<cfinclude template="utils/inc_generate_link_to_item.cfm">
		
		<cfreturn sReturn>

	</cffunction>
	
	<cffunction access="public" name="AbortIfNotLoggedIn" output="false" returntype="void"
			hint="abort request if not logged in ...">
				
		<cfif NOT StructKeyExists(request, 'stSecurityContext')>
			<cfabort/>
		</cfif>
		
	</cffunction>
	
	<cffunction access="public" name="DoThrowException" output="false" returntype="void"
			hint="throw an exception (mainly used for cfscripts)">
		<cfargument name="message" type="string" required="true"
			hint="message to fire">
			
		<cfthrow message="#arguments.message#" />
			
	</cffunction>
	
	<cffunction access="public" name="SetCookie" returntype="boolean" output="false"
			hint="Set a client cookie">
		<cfargument name="name" type="string" required="true"
			hint="Name of the cookie">
		<cfargument name="value" type="string" required="true"
			hint="value of the cookie">
		<cfargument name="expires" type="string" required="true"
			hint="when does this cookie expire?">
			
		<cfcookie name="#arguments.name#" value="#arguments.value#" expires="#arguments.expires#">
			
		<cfreturn true />	

	</cffunction>
		
	<cffunction access="public" name="ReadXMLFileAndReturnQuery" returntype="query"
			hint="read a XML file database and return the file">
		<cfargument name="filename" type="string"
			hint="point to location">
			
		<cfset var a_str_xml = '' />
		
		<cfif NOT FileExists(arguments.filename)>
			<cfthrow message="read xml database exception: file not found #arguments.filename#. Please check your configuration" />
		</cfif>
		
		<cftry>
		<cffile action="read" charset="utf-8" file="#arguments.filename#" variable="a_str_xml">
		<cfcatch type="any">
			<cfthrow message="read xml database exception: file not found">
		</cfcatch>
		</cftry>
			
		<cfreturn application.components.cmp_datatypeconvert.XMLToQUery(XMLParse(a_str_xml)) />
		
	</cffunction>
	
	<cffunction access="public" name="ReturnStoredXMLDatabaseAsQuery" output="false" returntype="query"
			hint="Load file in xml.databases directory and return as query">
		<cfargument name="fulltablename" type="string" required="true"
			hint="full table name with database name, e.g. myapp.testtable">
		
		<cfset var sFilename = application.a_struct_appsettings.properties.CONFIGURATIONDIRECTORY & ReturnDirSeparatorOfCurrentOS() & 'xml.databases' & ReturnDirSeparatorOfCurrentOS() & arguments.fulltablename & '.xml'>	
		
		<cfreturn ReadXMLFileAndReturnQuery(sFilename) />
		
	</cffunction>
	
	<cffunction access="public" name="ReturnComponentByServicekey" returntype="any" output="false"
			hint="create and return a component by the given servicekey">
		<cfargument name="servicekey" type="string" required="true"
			hint="the servicekey">
			
		<cfswitch expression="#arguments.servicekey#">
			<cfcase value="52227624-9DAA-05E9-0892A27198268072">
				<cfreturn application.components.cmp_addressbook />
			</cfcase>
			<cfcase value="66A3CE92-923A-0620-7656393EA07FAB3B">
				<cfreturn application.components.cmp_forum />
			</cfcase>
			<cfcase value="52228B55-B4D7-DFDF-4AC7CFB5BDA95AC5">
				<cfreturn application.components.cmp_email />
			</cfcase>
			<cfcase value="5222B55D-B96B-1960-70BF55BD1435D273">
				<cfreturn application.components.cmp_calendar />
			</cfcase>
			<cfcase value="5222ECD3-06C4-3804-E92ED804C82B68A2">
				<cfreturn application.components.cmp_storage />
			</cfcase>	
			<cfcase value="7E68B84A-BB31-FCC0-56E6125343C704EF">
				<cfreturn application.components.cmp_crmsales />
			</cfcase>
			<cfcase value="followups">
				<cfreturn application.components.cmp_followups />
			</cfcase>	
			<cfcase value="5137784B-C09F-24D5-396734F6193D879D">
				<cfreturn application.components.cmp_projects />
			</cfcase>	
			<cfcase value="94B39162-C7B4-5158-7A8C67BCF820D9E5">
				<cfreturn application.components.cmp_products />
			</cfcase>		
		</cfswitch>

	</cffunction>
	
	<cffunction access="public" name="GetImagePathForContentType" output="false" returntype="string">
		<cfargument name="contenttype" type="string" required="true">
		
		<cfset var sReturn = '' />
		<cfset var a_str_img_path = '' />
		
		<cfswitch expression="#arguments.contenttype#">
			
			<cfcase value="application/x-ms-excel,application/vnd.ms-excel" delimiters=",">
			<cfset a_str_img_path = '/images/si/page_excel.png' />
			</cfcase>
	
			<cfcase value="audio/mpeg">
			<cfset a_str_img_path = '/images/si/music.png' />
			</cfcase>
			
			<cfcase value="application/pdf,application/x-pdf">
			<cfset a_str_img_path = '/images/si/page_white_acrobat.png' />		
			</cfcase>
	
			<cfcase value="application/msword">
			<cfset a_str_img_path = '/images/si/page_white_word.png' />				
			</cfcase>
	
			<cfcase value="application/x-zip-compressed,application/x-compressed" delimiters=",">
			<cfset a_str_img_path = '/images/si/page_white_compressed.png' />	
			</cfcase>
	
			<cfcase value="text/plain">
			<cfset a_str_img_path = '/images/si/text_align_left.png' />	
			</cfcase>
	
			<cfcase value="text/html">
			<cfset a_str_img_path = '/images/si/page_white_world.png' />	
			</cfcase>
	
			<cfcase value="image/jpeg,image/pjpeg" delimiters=",">
			<cfset a_str_img_path = '/images/si/photo.png' />
			</cfcase>
		
			<cfcase  value="text/calendar">
			<cfset a_str_img_path = '/images/si/calendar.png' />
			</cfcase>
		
			<cfdefaultcase>
			<cfset a_str_img_path = '/images/si/page_attach.png' />
			</cfdefaultcase>
	
		</cfswitch>
		
		<cfset sReturn = '<img src="' & a_str_img_path & '" alt="" class="si_img" />' />
		
		<cfreturn sReturn />
		
	</cffunction>

	<!--- generate row of an editing table with several properties 
	
	TODO: KICK OUT --->
	<cffunction output="false" access="public" name="GenerateEditingTableRow" returntype="string">
		<cfargument name="datatype" type="string" default="string" hint="boolean,string,integer,float,date,memo,options">
		<cfargument name="tr_id" type="string" default="" hint="if needed, id for the created tr">
		<cfargument name="field_name" type="string" default="" hint="name of field">
		<cfargument name="input_name" type="string" default="" hint="name of input field">
		<cfargument name="input_value" type="string" default="" hint="value of input field">
		<cfargument name="output_only" type="boolean" default="false" hint="if true, only output, no input field">
		<cfargument name="add_validation" type="boolean" required="no" default="false" hint="add validation routine">
		<cfargument name="options" type="array" required="no" default="#ArrayNew(1)#" hint="array with structures (these are the available options)">
		<cfargument name="required" type="boolean" required="no" default="false">
		<cfargument name="platform" type="string" required="no" default="www" hint="www, pda, wap">
		<cfargument name="parameters" type="string" required="no" default="" hint="various parameters ...">
		
		<cfset var sReturn = '' />
		
		<cfinclude template="utils/inc_generate_edit_table_row.cfm">
		
		<cfreturn sReturn />
	</cffunction>
	
	<cffunction access="public" name="ReturnDatabaseFieldsOfService" returntype="query" output="false"
				hint="return the database fields used by a service">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="servicekey" type="string" required="true" hint="entrykey of service">
		
		<cfset var q_select_fields = QueryNew('fieldname,displayname,description,datatype,maxsize,name_md5', 'VarChar,VarChar,VarChar,Integer,Integer,Varchar') />
		
		<cfinclude template="utils/inc_return_service_db_fields.cfm">
		
		<cfreturn q_select_fields />
	</cffunction>
	
	<cffunction access="private" name="AddDatabaseFieldsInformationRecord" returntype="query" hint="add a records to information">
		<cfargument name="q" type="query" hint="the query">
		<cfargument name="fieldname" type="string" required="true">
		<cfargument name="displayname" type="string" required="false">
		<cfargument name="description" type="string" required="false" default="">
		<cfargument name="datatype" type="numeric" default="0">
		<cfargument name="maxsize" type="numeric" default="0">
		
		<cfset var q_select_fields = arguments.q />
		
		
		<cfset QueryAddRow(q_select_fields, 1)>
		<cfset QuerySetCell(q_select_fields, 'fieldname', arguments.fieldname, q_select_fields.recordcount)>
		<cfset QuerySetCell(q_select_fields, 'displayname', arguments.displayname, q_select_fields.recordcount)>
		<cfset QuerySetCell(q_select_fields, 'description', arguments.description, q_select_fields.recordcount)>
		<cfset QuerySetCell(q_select_fields, 'datatype', arguments.datatype, q_select_fields.recordcount)>
		<cfset QuerySetCell(q_select_fields, 'maxsize', arguments.maxsize, q_select_fields.recordcount)>
		<cfset QuerySetCell(q_select_fields, 'name_md5', Hash(arguments.fieldname), q_select_fields.recordcount)>
				
		<cfreturn q_select_fields>
	</cffunction>
	
	<!--- arguments.options above ... add an element to the array holding the elements --->
	<cffunction access="public" name="AddOptionToInputElementOptions" returntype="array">
		<cfargument name="array_holding_data" type="array" required="yes">
		<cfargument name="name" type="string" required="yes">
		<cfargument name="value" type="string" required="yes">

		<cfset var a_arr_return = arguments.array_holding_data />
		<cfset var ii = ArrayLen(a_arr_return) + 1>
		
		<cfset a_arr_return[ii] = StructNew()>
		<cfset a_arr_return[ii].name = arguments.name>
		<cfset a_arr_return[ii].value = arguments.value>
		
		<!--- return now --->
		<cfreturn a_arr_return />
	</cffunction>

	<!--- generate a page scroller --->
	<cffunction access="public" output="false" name="GeneratePageScroller" returntype="string">
		<cfargument name="servicekey" type="string" required="yes"
			hint="entrykey of service">
		<cfargument name="step" type="numeric" default="10" required="no"
			hint="steps">
		<cfargument name="recordcount" type="numeric" required="yes"
			hint="number of records">
		<cfargument name="current_record" type="numeric" required="yes"
			hint="number of current record">
		<cfargument name="current_url" type="string" required="yes"
			hint="the current url (cgi.QUERY_STRING only!!)">
		<cfargument name="url_tag_name" type="string" default="startrow" required="no"
			hint="tag name of startrow in the url string">
		<cfargument name="center" type="boolean" required="no" default="true">
		<cfargument name="hide_if_not_enough_data_for_scroller" type="boolean" default="false" required="no"
			hint="do not display scroller if only a few records">
		<cfargument name="main_template_filename" type="string" required="no" default="index.cfm"
			hint="the name of the main template file name used for the generated links">

		<cfset var sReturn = '' />
		<!--- do we have a javascript URL instead of an ordenary URL ... --->
		<cfset var a_bol_js_link = (FindNoCase('javascript:', arguments.current_url) IS 1) />
		
		<!--- if only a few items ... hide scroller --->
		<cfif (arguments.recordcount LTE arguments.step) AND arguments.hide_if_not_enough_data_for_scroller>
			<cfreturn '' />
		</cfif>
		
		<cfinclude template="utils/inc_generate_page_scroller.cfm">
		
		<cfreturn sReturn />		
	</cffunction>
	
	<!--- // parse data posted by background operation --->
	<cffunction access="public" name="ParseBackgroundOperationRequest" returntype="struct" output="false"
			hint="parse the request posted to a background operation routine">
		<cfargument name="request" type="string" required="true"
			hint="the xml request as string ...">
			
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var a_str_index = '' />
		
		<cfif NOT IsXML(arguments.request)>
			<cfreturn SetReturnStructErrorCode(stReturn, 5100) />
		</cfif>
		
		<cfset stReturn.data = application.components.cmp_datatypeconvert.xmltostruct(xmlparse(arguments.request).data) />
		
		<cfloop list="#StructKeyList(stReturn.data)#" index="a_str_index">
			<cfset stReturn.data[a_str_index] = UrlDecode(stReturn.data[a_str_index]) />
		</cfloop>
	
		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>

	<cffunction access="public" name="GetFullCountryNameFromISOCode" output="false" returntype="string">
		<cfargument name="isocode" type="string" default="at" required="true" hint="The name of the country">
		
		<cfswitch expression="#arguments.isocode#">
			<cfcase value="at">
			<cfreturn 'Oesterreich' />
			</cfcase>
			<cfcase value="de">
			<cfreturn 'Deutschland' />
			</cfcase>
			<cfcase value="ch">
			<cfreturn 'Schweiz' />
			</cfcase>
			
			<cfdefaultcase>
			<cfreturn arguments.isocode />
			</cfdefaultcase>
		</cfswitch>
	
	</cffunction>
	

	<cffunction name="CSVToQueryEx"
		access="public"
		returntype="query"
		output="false"
		hint="Converts the given CSV string to a query.">
	 
		<!--- Define arguments. --->
		<cfargument
			name="CSV"
			type="string"
			required="true"
			hint="This is the CSV string that will be manipulated."
			/>
	 
		<cfargument
			name="Delimiter"
			type="string"
			required="false"
			default=","
			hint="This is the delimiter that will separate the fields within the CSV value."
			/>
	 
		<cfargument
			name="Qualifier"
			type="string"
			required="false"
			default=""""
			hint="This is the qualifier that will wrap around fields that have special characters embeded."
			/>
	 
	 
		<!--- Define the local scope. --->
		<cfset var LOCAL = StructNew() />
	 
	 
		<!---
			When accepting delimiters, we only want to use the first
			character that we were passed. This is different than
			standard ColdFusion, but I am trying to make this as
			easy as possible.
		--->
		<cfset ARGUMENTS.Delimiter = Left( ARGUMENTS.Delimiter, 1 ) />
	 
		<!---
			When accepting the qualifier, we only want to accept the
			first character returned. Is is possible that there is
			no qualifier being used. In that case, we can just store
			the empty string (leave as-is).
		--->
		<cfif Len( ARGUMENTS.Qualifier )>
	 
			<cfset ARGUMENTS.Qualifier = Left( ARGUMENTS.Qualifier, 1 ) />
	 
		</cfif>
	 
	 
		<!---
			Set a variable to handle the new line. This will be the
			character that acts as the record delimiter.
		--->
		<cfset LOCAL.LineDelimiter = Chr( 10 ) />
	 
	 
		<!---
			We want to standardize the line breaks in our CSV value.
			A "line break" might be a return followed by a feed or
			just a line feed. We want to standardize it so that it
			is just a line feed. That way, it is easy to check
			for later (and it is a single character which makes our
			life 1000 times nicer).
		--->
		<cfset ARGUMENTS.CSV = ARGUMENTS.CSV.ReplaceAll(
			"\r?\n",
			LOCAL.LineDelimiter
			) />
	 
	 
		<!---
			Let's get an array of delimiters. We will need this when
			we are going throuth the tokens and building up field
			values. To do this, we are going to strip out all
			characters that are NOT delimiters and then get the
			character array of the string. This should put each
			delimiter at it's own index.
		--->
		<cfset LOCAL.Delimiters = ARGUMENTS.CSV.ReplaceAll(
			"[^\#ARGUMENTS.Delimiter#\#LOCAL.LineDelimiter#]+",
			""
			)
	 
			<!---
				Get character array of delimiters. This will put
				each found delimiter in its own index (that should
				correspond to the tokens).
			--->
			.ToCharArray()
			/>
	 
	 
		<!---
			Add a blank space to the beginning of every theoretical
			field. This will help in make sure that ColdFusion /
			Java does not skip over any fields simply because they
			do not have a value. We just have to be sure to strip
			out this space later on.
	 
			First, add a space to the beginning of the string.
		--->
		<cfset ARGUMENTS.CSV = (" " & ARGUMENTS.CSV) />
	 
		<!--- Now add the space to each field. --->
		<cfset ARGUMENTS.CSV = ARGUMENTS.CSV.ReplaceAll(
			"([\#ARGUMENTS.Delimiter#\#LOCAL.LineDelimiter#]{1})",
			"$1 "
			) />
	 
	 
		<!---
			Break the CSV value up into raw tokens. Going forward,
			some of these tokens may be merged, but doing it this
			way will help us iterate over them. When splitting the
			string, add a space to each token first to ensure that
			the split works properly.
	 
			BE CAREFUL! Splitting a string into an array using the
			Java String::Split method does not create a COLDFUSION
			ARRAY. You cannot alter this array once it has been
			created. It can merely be referenced (read only).
	 
			We are splitting the CSV value based on the BOTH the
			field delimiter and the line delimiter. We will handle
			this later as we build values (this is why we created
			the array of delimiters above).
		--->
		<cfset LOCAL.Tokens = ARGUMENTS.CSV.Split(
			"[\#ARGUMENTS.Delimiter#\#LOCAL.LineDelimiter#]{1}"
			) />
	 
	 
		<!---
			Set up the default records array. This will be a full
			array of arrays, but for now, just create the parent
			array with no indexes.
		--->
		<cfset LOCAL.Rows = ArrayNew( 1 ) />
	 
		<!---
			Create a new active row. Even if we don't end up adding
			any values to this row, it is going to make our lives
			more smiple to have it in existence.
		--->
		<cfset ArrayAppend(
			LOCAL.Rows,
			ArrayNew( 1 )
			) />
	 
		<!---
			Set up the row index. THis is the row to which we are
			actively adding value.
		--->
		<cfset LOCAL.RowIndex = 1 />
	 
	 
		<!---
			Set the default flag for wether or not we are in the
			middle of building a value across raw tokens.
		--->
		<cfset LOCAL.IsInValue = false />
	 
	 
		<!---
			Loop over the raw tokens to start building values. We
			have no sense of any row delimiters yet. Those will
			have to be checked for as we are building up each value.
		--->
		<cfloop
			index="LOCAL.TokenIndex"
			from="1"
			to="#ArrayLen( LOCAL.Tokens )#"
			step="1">
	 
	 
			<!---
				Get the current field index. This is the current
				index of the array to which we might be appending
				values (for a multi-token value).
			--->
			<cfset LOCAL.FieldIndex = ArrayLen(
				LOCAL.Rows[ LOCAL.RowIndex ]
				) />
	 
			<!---
				Get the next token. Trim off the first character
				which is the empty string that we added to ensure
				proper splitting.
			--->
			<cfset LOCAL.Token = LOCAL.Tokens[ LOCAL.TokenIndex ].ReplaceFirst(
				"^.{1}",
				""
				) />
	 
	 
			<!---
				Check to see if we have a field qualifier. If we do,
				then we might have to build the value across
				multiple fields. If we do not, then the raw tokens
				should line up perfectly with the real tokens.
			--->
			<cfif Len( ARGUMENTS.Qualifier )>
	 
	 
				<!---
					Check to see if we are currently building a
					field value that has been split up among
					different delimiters.
				--->
				<cfif LOCAL.IsInValue>
	 
	 
					<!---
						ASSERT: Since we are in the middle of
						building up a value across tokens, we can
						assume that our parent FOR loop has already
						executed at least once. Therefore, we can
						assume that we have a previous token value
						ALREADY in the row value array and that we
						have access to a previous delimiter (in
						our delimiter array).
					--->
	 
					<!---
						Since we are in the middle of building a
						value, we replace out double qualifiers with
						a constant. We don't care about the first
						qualifier as it can ONLY be an escaped
						qualifier (not a field qualifier).
					--->
					<cfset LOCAL.Token = LOCAL.Token.ReplaceAll(
						"\#ARGUMENTS.Qualifier#{2}",
						"{QUALIFIER}"
						) />
	 
	 
					<!---
						Add the token to the value we are building.
						While this is not easy to read, add it
						directly to the results array as this will
						allow us to forget about it later. Be sure
						to add the PREVIOUS delimiter since it is
						actually an embedded delimiter character
						(part of the whole field value).
					--->
					<cfset LOCAL.Rows[ LOCAL.RowIndex ][ LOCAL.FieldIndex ] = (
						LOCAL.Rows[ LOCAL.RowIndex ][ LOCAL.FieldIndex ] &
						LOCAL.Delimiters[ LOCAL.TokenIndex - 1 ] &
						LOCAL.Token
						) />
	 
	 
					<!---
						Now that we have removed the possibly
						escaped qualifiers, let's check to see if
						this field is ending a multi-token
						qualified value (its last character is a
						field qualifier).
					--->
					<cfif (Right( LOCAL.Token, 1 ) EQ ARGUMENTS.Qualifier)>
	 
						<!---
							Wooohoo! We have reached the end of a
							qualified value. We can complete this
							value and move onto the next field.
							Remove the trailing quote.
	 
							Remember, we have already added to token
							to the results array so we must now
							manipulate the results array directly.
							Any changes made to LOCAL.Token at this
							point will not affect the results.
						--->
						<cfset LOCAL.Rows[ LOCAL.RowIndex ][ LOCAL.FieldIndex ] = LOCAL.Rows[ LOCAL.RowIndex ][ LOCAL.FieldIndex ].ReplaceFirst( ".{1}$", "" ) />
	 
						<!---
							Set the flag to indicate that we are no
							longer building a field value across
							tokens.
						--->
						<cfset LOCAL.IsInValue = false />
	 
					</cfif>
	 
	 
				<cfelse>
	 
	 
					<!---
						We are NOT in the middle of building a field
						value which means that we have to be careful
						of a few special token cases:
	 
						1. The field is qualified on both ends.
						2. The field is qualified on the start end.
					--->
	 
					<!---
						Check to see if the beginning of the field
						is qualified. If that is the case then either
						this field is starting a multi-token value OR
						this field has a completely qualified value.
					--->
					<cfif (Left( LOCAL.Token, 1 ) EQ ARGUMENTS.Qualifier)>
	 
	 
						<!---
							Delete the first character of the token.
							This is the field qualifier and we do
							NOT want to include it in the final value.
						--->
						<cfset LOCAL.Token = LOCAL.Token.ReplaceFirst(
							"^.{1}",
							""
							) />
	 
						<!---
							Remove all double qualifiers so that we
							can test to see if the field has a
							closing qualifier.
						--->
						<cfset LOCAL.Token = LOCAL.Token.ReplaceAll(
							"\#ARGUMENTS.Qualifier#{2}",
							"{QUALIFIER}"
							) />
	 
						<!---
							Check to see if this field is a
							self-closer. If the first character is a
							qualifier (already established) and the
							last character is also a qualifier (what
							we are about to test for), then this
							token is a fully qualified value.
						--->
						<cfif (Right( LOCAL.Token, 1 ) EQ ARGUMENTS.Qualifier)>
	 
							<!---
								This token is fully qualified.
								Remove the end field qualifier and
								append it to the row data.
							--->
							<cfset ArrayAppend(
								LOCAL.Rows[ LOCAL.RowIndex ],
								LOCAL.Token.ReplaceFirst(
									".{1}$",
									""
									)
								) />
	 
						<cfelse>
	 
							<!---
								This token is not fully qualified
								(but the first character was a
								qualifier). We are buildling a value
								up across differen tokens. Set the
								flag for building the value.
							--->
							<cfset LOCAL.IsInValue = true />
	 
							<!--- Add this token to the row. --->
							<cfset ArrayAppend(
								LOCAL.Rows[ LOCAL.RowIndex ],
								LOCAL.Token
								) />
	 
						</cfif>
	 
	 
					<cfelse>
	 
	 
						<!---
							We are not dealing with a qualified
							field (even though we are using field
							qualifiers). Just add this token value
							as the next value in the row.
						--->
						<cfset ArrayAppend(
							LOCAL.Rows[ LOCAL.RowIndex ],
							LOCAL.Token
							) />
	 
	 
					</cfif>
	 
	 
				</cfif>
	 
	 
				<!---
					As a sort of catch-all, let's remove that
					{QUALIFIER} constant that we may have thrown
					into a field value. Do NOT use the FieldIndex
					value as this might be a corrupt value at
					this point in the token iteration.
				--->
				<cfset LOCAL.Rows[ LOCAL.RowIndex ][ ArrayLen( LOCAL.Rows[ LOCAL.RowIndex ] ) ] = Replace(
					LOCAL.Rows[ LOCAL.RowIndex ][ ArrayLen( LOCAL.Rows[ LOCAL.RowIndex ] ) ],
					"{QUALIFIER}",
					ARGUMENTS.Qualifier,
					"ALL"
					) />
	 
	 
			<cfelse>
	 
	 
				<!---
					Since we don't have a qualifier, just use the
					current raw token as the actual value. We are
					NOT going to have to worry about building values
					across tokens.
				--->
				<cfset ArrayAppend(
					LOCAL.Rows[ LOCAL.RowIndex ],
					LOCAL.Token
					) />
	 
	 
			</cfif>
	 
	 
	 
			<!---
				Check to see if we have a next delimiter and if we
				do, is it going to start a new row? Be cautious that
				we are NOT in the middle of building a value. If we
				are building a value then the line delimiter is an
				embedded value and should not percipitate a new row.
			--->
			<cfif (
				(NOT LOCAL.IsInValue) AND
				(LOCAL.TokenIndex LT ArrayLen( LOCAL.Tokens )) AND
				(LOCAL.Delimiters[ LOCAL.TokenIndex ] EQ LOCAL.LineDelimiter)
				)>
	 
				<!---
					The next token is indicating that we are about
					start a new row. Add a new array to the parent
					and increment the row counter.
				--->
				<cfset ArrayAppend(
					LOCAL.Rows,
					ArrayNew( 1 )
					) />
	 
				<!--- Increment row index to point to next row. --->
				<cfset LOCAL.RowIndex = (LOCAL.RowIndex + 1) />
	 
			</cfif>
	 
		</cfloop>
	 
	 
		<!---
			ASSERT: At this point, we have parsed the CSV into an
			array of arrays (LOCAL.Rows). Now, we can take that
			array of arrays and convert it into a query.
		--->
	 
	 
		<!---
			To create a query that fits this array of arrays, we
			need to figure out the max length for each row as
			well as the number of records.
	 
			The number of records is easy - it's the length of the
			array. The max field count per row is not that easy. We
			will have to iterate over each row to find the max.
	 
			However, this works to our advantage as we can use that
			array iteration as an opportunity to build up a single
			array of empty string that we will use to pre-populate
			the query.
		--->
	 
		<!--- Set the initial max field count. --->
		<cfset LOCAL.MaxFieldCount = 0 />
	 
		<!---
			Set up the array of empty values. As we iterate over
			the rows, we are going to add an empty value to this
			for each record (not field) that we find.
		--->
		<cfset LOCAL.EmptyArray = ArrayNew( 1 ) />
	 
	 
		<!--- Loop over the records array. --->
		<cfloop
			index="LOCAL.RowIndex"
			from="1"
			to="#ArrayLen( LOCAL.Rows )#"
			step="1">
	 
			<!--- Get the max rows encountered so far. --->
			<cfset LOCAL.MaxFieldCount = Max(
				LOCAL.MaxFieldCount,
				ArrayLen(
					LOCAL.Rows[ LOCAL.RowIndex ]
					)
				) />
	 
			<!--- Add an empty value to the empty array. --->
			<cfset ArrayAppend(
				LOCAL.EmptyArray,
				""
				) />
	 
		</cfloop>
	 
	 
		<!---
			ASSERT: At this point, LOCAL.MaxFieldCount should hold
			the number of fields in the widest row. Additionally,
			the LOCAL.EmptyArray should have the same number of
			indexes as the row array - each index containing an
			empty string.
		--->
	 
	 
		<!---
			Now, let's pre-populate the query with empty strings. We
			are going to create the query as all VARCHAR data
			fields, starting off with blank. Then we will override
			these values shortly.
		--->
		<cfset LOCAL.Query = QueryNew( "" ) />
	 
		<!---
			Loop over the max number of fields and create a column
			for each records.
		--->
		<cfloop
			index="LOCAL.FieldIndex"
			from="1"
			to="#LOCAL.MaxFieldCount#"
			step="1">
	 
			<!---
				Add a new query column. By using QueryAddColumn()
				rather than QueryAddRow() we are able to leverage
				ColdFusion's ability to add row values in bulk
				based on an array of values. Since we are going to
				pre-populate the query with empty values, we can
				just send in the EmptyArray we built previously.
			--->
			<cfset QueryAddColumn(
				LOCAL.Query,
				"COLUMN_#LOCAL.FieldIndex#",
				"varchar",
				LOCAL.EmptyArray
				) />
	 
		</cfloop>
	 
	 
		<!---
			ASSERT: At this point, our return query LOCAL.Query
			contains enough columns and rows to handle all the
			data that we have stored in our array of arrays.
		--->
	 
	 
		<!---
			Loop over the array to populate the query with
			actual data. We are going to have to loop over
			each row and then each field.
		--->
		<cfloop
			index="LOCAL.RowIndex"
			from="1"
			to="#ArrayLen( LOCAL.Rows )#"
			step="1">
	 
			<!--- Loop over the fields in this record. --->
			<cfloop
				index="LOCAL.FieldIndex"
				from="1"
				to="#ArrayLen( LOCAL.Rows[ LOCAL.RowIndex ] )#"
				step="1">
	 
				<!---
					Update the query cell. Remember to cast string
					to make sure that the underlying Java data
					works properly.
				--->
				<cfset LOCAL.Query[ "COLUMN_#LOCAL.FieldIndex#" ][ LOCAL.RowIndex ] = JavaCast(
					"string",
					LOCAL.Rows[ LOCAL.RowIndex ][ LOCAL.FieldIndex ]
					) />
	 
			</cfloop>
	 
		</cfloop>
	 
	 
		<!---
			Our query has been successfully populated.
			Now, return it.
		--->
		<cfreturn LOCAL.Query />
	 
	</cffunction>

	<cffunction access="public" name="GetElementLinksFromTo" output="false" returntype="query" hint="">
		<cfargument name="entrykey" type="string" required="true">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="filter" type="struct" required="no" default="#StructNew()#">
		
		<!---<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="element links" type="html">
		<cfdump var="#arguments#">
		</cfmail>--->
		
		<cfinclude template="queries/q_select_element_links.cfm">
		<cfreturn q_select_element_links>
		
	</cffunction>
	
	<cffunction access="public" name="CreateElementLink" output="false" returntype="boolean">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="source_servicekey" type="string" required="yes">
		<cfargument name="source_entrykey" type="string" required="yes">
		<cfargument name="source_displayname" type="string" required="yes">
		<cfargument name="dest_servicekey" type="string" required="yes">
		<cfargument name="dest_entrykey" type="string" required="yes">
		<cfargument name="dest_displayname" type="string" required="yes">	
		<cfargument name="comment" type="string" required="no" default="">
		<cfargument name="connection_type" type="string" required="yes">	
		
		<cfinclude template="queries/q_insert_element_link.cfm">
		
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="DeleteElementLink" output="false" returntype="boolean">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="entrykey" type="string" required="yes" hint="entrykey of the link">
		
		<cfinclude template="queries/q_delete_element_link.cfm">
		
		<cfreturn true>		
	</cffunction>
	
	<cffunction access="public" name="GetHostName" returntype="string" output="false"
			hint="Return the hostname for a given IP address">
		<cfargument name="address" type="string" required="true"
			hint="IP address">
		
		<cfscript>
		var iaclass="";
		var addr="";
		iaclass=CreateObject("java", "java.net.InetAddress");
			
		// Get address
		addr=iaclass.getByName(arguments.address);
		</cfscript>

		<cfreturn addr.getHostName() />
		
	</cffunction>
	
</cfcomponent>



