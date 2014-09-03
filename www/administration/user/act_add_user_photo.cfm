<!---

	--->

<cfparam name="form.frmphotosmall" type="string" default="">
<cfparam name="form.frmphotobig" type="string" default="">


<cfif Len(form.frmphotosmall) GT 0>
	<cfset sFilename = getTempDirectory() & request.a_str_dir_separator & CreateUUID()>
	<cffile action="upload" destination="#sFilename#" filefield="form.frmphotosmall" nameconflict="makeunique">

	<cffile action="readbinary" file="#sFilename#" variable="a_str_data">

	<!--- delete old photo --->
	<cfquery name="q_delete_old_photo">
	DELETE FROM
		userphotos
	WHERE
		(userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmentrykey#">)
		AND
		(type = 0)
	;
	</cfquery>

	<cfquery name="q_insert_data">
	INSERT INTO userphotos
	(photodata,type,userkey,contenttype)
	VALUES
	('#tobase64(a_str_data)#',
	0,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmentrykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#file.ContentType#/#file.ContentSubType#">);
	</cfquery>

	<cfquery name="q_update_user">
	UPDATE
		users
	SET
		smallphotoavaliable = 1
	WHERE
		entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmentrykey#">
	;
	</cfquery>

</cfif>

<cfif Len(form.frmphotobig) GT 0>
<h1>go</h1>
	<cfset sFilename = getTempDirectory() & request.a_str_dir_separator & CreateUUID()>
	<cffile action="upload" destination="#sFilename#" filefield="form.frmphotobig" nameconflict="makeunique">

	<cffile action="readbinary" file="#sFilename#" variable="a_str_data">

	<cfquery name="q_delete_old_photo">
	DELETE FROM
		userphotos
	WHERE
		(userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmentrykey#">)
		AND
		(type = 1)
	;
	</cfquery>

	<cfquery name="q_insert_data">
	INSERT INTO userphotos
	(photodata,type,userkey,contenttype)
	VALUES
	('#tobase64(a_str_data)#',
	1,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmentrykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#file.ContentType#/#file.ContentSubType#">);
	</cfquery>

	<cfquery name="q_update_user">
	UPDATE
		users
	SET
		bigphotoavaliable = 1
	WHERE
		entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmentrykey#">
	;
	</cfquery>

</cfif>

<cflocation addtoken="no" url="#ReturnRedirectURL()#">