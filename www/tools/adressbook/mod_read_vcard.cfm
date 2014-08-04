<cfparam name="Caller.FirstName" default="">

<cfparam name="Caller.LastName" default="">

<cfparam name="Caller.Organization" default="">

<cfparam name="Caller.Department" default="">

<cfparam name="Caller.Title" default="">

<cfparam name="Caller.Home_Address1" default="">

<cfparam name="Caller.Home_City" default="">

<cfparam name="Caller.Home_State" default="">

<cfparam name="Caller.Home_PostalCode" default="">

<cfparam name="Caller.Home_Country" default="">

<cfparam name="Caller.Work_Address1" default="">

<cfparam name="Caller.Work_City" default="">

<cfparam name="Caller.Work_State" default="">

<cfparam name="Caller.Work_PostalCode" default="">

<cfparam name="Caller.Work_Country" default="">

<cfparam name="Caller.HomePhone" default="">

<cfparam name="Caller.MobilePhone" default="">

<cfparam name="Caller.WorkPhone" default="">

<cfparam name="Caller.WorkFax" default="">

<cfparam name="Caller.PrefEmail" default="">

<cfparam name="Caller.Email" default="">

<cfif IsDefined("ATTRIBUTES.File") IS "No">

<h1>Error</h1><p>You must enter a value for &quot;File&quot;, which is the local path to the vCard file you wish to read. Example = File=&quot;c:\vcards\ChrisGetner.vcf&quot;</p>

<cfelse>



<cffile action="READ" file=#ATTRIBUTES.File# variable="RawContents" charset="iso-8859-1">

<cfset StartText=ArrayNew(1)>

<cfset Start=ArrayNew(1)>

<cfset SubContents=ArrayNew(1)>

<cfset SubContents2=ArrayNew(1)>

<cfset BeginStart=1>

<cfset StartText[1]='FN:'>

<cfset StartText[2]='N:'>

<cfset StartText[3]='ORG:'>

<cfset StartText[4]='TITLE:'>

<cfset StartText[5]='EMAIL;PREF;INTERNET:'>

<cfset StartText[6]='EMAIL;INTERNET:'>

<cfset StartText[7]='TEL;WORK;VOICE:'>

<cfset StartText[8]='TEL;HOME;VOICE:'>

<cfset StartText[9]='TEL;CELL;VOICE:'>

<cfset StartText[10]='TEL;WORK;FAX:'>

<cfset StartText[11]='ADR;'>

<cfset BeginStart=max(FindNoCase('BEGIN:VCARD', RawContents,1)+11,FindNoCase('VERSION', RawContents,1)+7)>



<cfloop index="index" from="1" to="11" step="1">

<cfset Start[index]=FindNoCase(StartText[index], RawContents,BeginStart)>

	<cfif Start[index] IS NOT 0>

		<cfset EndText=#Chr(10)#>

		<cfset Length=Len(StartText[index])>

		<cfset End=FindNoCase(EndText, RawContents, Start[index])>

		<cfset Contents=Mid(RawContents, Start[index]+Length, End-Start[index]-Length)>

		<cfif index IS 2>

			<cfif Start[2] LESS THAN Start[1]>

				<cfset Caller.FirstName=GetToken(Contents,2,';')>

				<cfset Caller.LastName=GetToken(Contents,1,';')>

			<cfelse>

				<cfset Caller.FirstName=GetToken(Contents,1)>

				<cfset Caller.LastName=GetToken(Contents,2)>

			</cfif>

		</cfif>

		<cfif index IS 3>

			<cfset Caller.Organization=GetToken(Contents,1,';')>

			<cfset Caller.Department=GetToken(Contents,2,';')>

		</cfif>

		<cfif index IS 4>

			<cfset Caller.Title=Contents>

		</cfif>

		<cfif index IS 5>

			<cfset Caller.PrefEmail=Contents>

		</cfif>

		<cfif index IS 6>

			<cfset Caller.Email=Contents>

		</cfif>

		<cfif index IS 7>

			<cfset Caller.WorkPhone=Contents>

		</cfif>

		<cfif index IS 8>

			<cfset Caller.HomePhone=Contents>

		</cfif>

		<cfif index IS 9>

			<cfset Caller.MobilePhone=Contents>

		</cfif>

		<cfif index IS 10>

			<cfset Caller.WorkFax=Contents>

		</cfif>

		<cfif index IS 11>

			<cfset ContentFrag=GetToken(Contents,2,':')>

				<cfloop index="kount" from="1" to="7" step="1">

					<cfset break=Find(';',ContentFrag,1)>

						<cfif break IS 1>

							<cfset SubContents[kount]=''>

						<cfelse>

							<cfif break IS 0>

								<cfset break=len(ContentFrag)+1>

							</cfif>

							<cfset SubContents[kount]=Mid(ContentFrag,1,break-1)>

						</cfif>

						<cfset Sizer=len(ContentFrag)>

						<cfif kount LESS THAN 7><cfif (Sizer-break) GREATER THAN 0><cfset ContentFrag=Right(ContentFrag,Sizer-break)></cfif></cfif>

				</cfloop>

			<cfif FindNoCase('HOME',Contents) GREATER THAN 0>

				<cfset Caller.Home_Country=SubContents[7]>

				<cfset Caller.Home_PostalCode=SubContents[6]>

				<cfset Caller.Home_State=SubContents[5]>

				<cfset Caller.Home_City=SubContents[4]>

				<cfset Address=SubContents[1]&SubContents[2]&SubContents[3]>

				<cfif FindNoCase('=0D=0A',Address) GREATER THAN 0>

					<cfset Address=Replace(Address,'=0D=0A',';')>

				</cfif>

				<cfset Caller.Home_Address1=GetToken(Address,1,';')>

				<cfset Caller.Home_Address2=GetToken(Address,2,';')>

			</cfif>

			<cfif FindNoCase('WORK',Contents) GREATER THAN 0>

				<cfset Caller.Work_Country=SubContents[7]>

				<cfset Caller.Work_PostalCode=SubContents[6]>

				<cfset Caller.Work_State=SubContents[5]>

				<cfset Caller.Work_City=SubContents[4]>

				<cfset Address=SubContents[1]&SubContents[2]&SubContents[3]>

				<cfif FindNoCase('=0D=0A',Address) GREATER THAN 0>

					<cfset Address=Replace(Address,'=0D=0A',';')>

				</cfif>

				<cfset Caller.Work_Address1=GetToken(Address,1,';')>

				<cfset Caller.Work_Address2=GetToken(Address,2,';')>

			</cfif>

			<cfif FindNoCase(StartText[index], RawContents,Start[index]+4) IS NOT 0>

				<cfset End=FindNoCase(EndText, RawContents, FindNoCase(StartText[index], RawContents,Start[index]+4))>

				<cfset Contents2=Mid(RawContents, FindNoCase(StartText[index], RawContents,Start[index]+4)+Length, End-FindNoCase(StartText[index], RawContents,Start[index]+4)-Length)>

				<cfset ContentFrag=GetToken(Contents2,2,':')>

				<cfloop index="kount" from="1" to="7" step="1">

					<cfset break=Find(';',ContentFrag,1)>

						<cfif break IS 1>

							<cfset SubContents2[kount]=''>

						<cfelse>

							<cfif break IS 0>

								<cfset break=len(ContentFrag)+1>

							</cfif>

							<cfset SubContents2[kount]=Mid(ContentFrag,1,break-1)>

						</cfif>

						<cfset Sizer=len(ContentFrag)>

						<cfif kount LESS THAN 7 AND (Sizer-break GT 0)><cfset ContentFrag=Right(ContentFrag,Sizer-break)></cfif>

				</cfloop>

				<cfif FindNoCase('HOME',Contents2) GREATER THAN 0>

					<cfset Caller.Home_Country=SubContents2[7]>

					<cfset Caller.Home_PostalCode=SubContents2[6]>

					<cfset Caller.Home_State=SubContents2[5]>

					<cfset Caller.Home_City=SubContents2[4]>

					<cfset Address=SubContents2[1]&SubContents2[2]&SubContents2[3]>

					<cfif FindNoCase('=0D=0A',Address) GREATER THAN 0>

						<cfset Address=Replace(Address,'=0D=0A',';')>

					</cfif>

					<cfset Caller.Home_Address1=GetToken(Address,1,';')>

					<cfset Caller.Home_Address2=GetToken(Address,2,';')>

				</cfif>

				<cfif FindNoCase('WORK',Contents2) GREATER THAN 0>

					<cfset Caller.Work_Country=SubContents2[7]>

					<cfset Caller.Work_PostalCode=SubContents2[6]>

					<cfset Caller.Work_State=SubContents2[5]>

					<cfset Caller.Work_City=SubContents2[4]>

					<cfset Address=SubContents2[1]&SubContents2[2]&SubContents2[3]>

					<cfif FindNoCase('=0D=0A',Address) GREATER THAN 0>

						<cfset Address=Replace(Address,'=0D=0A',';')>

					</cfif>

					<cfset Caller.Work_Address1=GetToken(Address,1,';')>

					<cfset Caller.Work_Address2=GetToken(Address,2,';')>

				</cfif>

			</cfif>

		</cfif>

	</cfif>

</cfloop>

</cfif>