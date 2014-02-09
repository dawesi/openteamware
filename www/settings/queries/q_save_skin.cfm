<!--- //
	save skin settings to database
	
	
	scope: session,form
	
	// --->

<cfquery name="q_save_skin" datasource="myPerson">
<!--- delete old --->
DELETE FROM Skins WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">;
<!--- insert new now --->
INSERT INTO Skins
(userid,SkinName,Description,ScreenshotURL,dt_created,PublicSkin,
BodyBackgroundColor,BodyBackgroundImage,FontFamily,Fontsize,Fontcolor,
Linkcolor,HeaderTopBackgroundcolor,headerLeftBackgroundcolor,HeaderleftDarkBackgroundColor,
BorderColor)
VALUES
(<cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmName#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmDescription#">,
'',
current_timestamp,
0,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmBackgroundcolor#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmBackgroundImage#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmFontfamily#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmFontsize#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmFontColor#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmLinkColor#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmHeaderTop#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmHeaderLeftLight#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmHeaderLeftDark#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmControlBorders#">);
</cfquery>