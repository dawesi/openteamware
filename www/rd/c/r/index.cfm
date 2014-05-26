<!--- //

	Module:		Calendar
	Description:Invited person reacts to an invitation
	

// --->

<!--- eventkey 	--->
<cfparam name="url.e" type="string" default="">

<!--- parameter (f.e. the userkey) --->
<cfparam name="url.p" type="string" default="">

<!--- type (of parameter) --->
<cfparam name="url.t" type="numeric" default="0">

<!--- answer

	0 = NOT OK
	1= OK
	2 = maybe
	--->
<cfparam name="url.a" type="numeric" default="1">

<!--- redirect to new response form --->
<cflocation addtoken="no" url="../../../calendar/react/?e=#urlencodedformat(trim(url.e))#&p=#urlencodedformat(trim(url.p))#&t=#urlencodedformat(trim(url.t))#&a=#urlencodedformat(trim(url.a))#">


