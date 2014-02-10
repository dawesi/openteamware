<!--- //

	Module:		Application Framework
	
// --->

<!--- global --->
<cfset stReturn.properties.IsTestingServer = ReadPropertiesFileProperty('Configuration', 'IsTestingServer', '0')>
<cfset stReturn.properties.Version = ReadPropertiesFileProperty('Configuration', 'Version', '2007')>
<cfset stReturn.properties.DefaultDomain = ReadPropertiesFileProperty('Configuration', 'DefaultDomain', 'openTeamware.com')>
<cfset stReturn.properties.InternalIPs = ReadPropertiesFileProperty('Configuration', 'InternalIPs', '62.99.232.51')>
<cfset stReturn.properties.ConfigurationDirectory = ReadPropertiesFileProperty('Configuration', 'ConfigurationDirectory', GetDirectoryFromPath( GetCurrentTemplatePath() ) & '../../../configuration/') />
<cfset stReturn.properties.DefaultLanguage = ReadPropertiesFileProperty('Configuration', 'DefaultLanguage', '0')>
<cfset stReturn.properties.DefaultDatabaseSystem = ReadPropertiesFileProperty('Configuration', 'DefaultDatabaseSystem', 'mysql') />

<!--- paths --->
<cfset stReturn.properties.LocalTempDirectory = ReadPropertiesFileProperty('Paths', 'LocalTempDirectory', '/tmp/otw/')>
<cfset stReturn.properties.GlobalTempDirectory = ReadPropertiesFileProperty('Paths', 'GlobalTempDirectory', '/tmp/otw/')>
<cfset stReturn.properties.wwwroot = ReadPropertiesFileProperty('Paths', 'wwwroot', '/mnt/www-source/www.openTeamWare.com/')>
<cfset stReturn.properties.StorageDirectory = ReadPropertiesFileProperty('Paths', 'StorageDirectory', '/mnt/filestorage/storagenew/')>
<cfset stReturn.properties.DataReplicationDirectory = ReadPropertiesFileProperty('Paths', 'DataReplicationDirectory', '/mnt/filestorage/datareplication/')>

<!--- mail --->
<cfset stReturn.properties.DefaultMailServer = ReadPropertiesFileProperty('Mail', 'DefaultMailServer', 'mail.openTeamware.com')>
<cfset stReturn.properties.DefaultIMAPServer = ReadPropertiesFileProperty('Mail', 'DefaultIMAPServer', 'imap.openTeamware.com')>
<cfset stReturn.properties.SpoolDirectory1 = ReadPropertiesFileProperty('Mail', 'SpoolDirectory1', '/mnt/mailspool01/')>
<cfset stReturn.properties.SpoolDirectory2 = ReadPropertiesFileProperty('Mail', 'SpoolDirectory2', '/mnt/freespool01/')>
<cfset stReturn.properties.MailSpeedEnabled = ReadPropertiesFileProperty('Mail', 'MailSpeedEnabled', '0')>

<!--- various --->
<cfset stReturn.properties.PixelLocation = ReadPropertiesFileProperty('Various', 'PixelLocation', '/mnt/www-source/www.openTeamWare.com/images/space_1_1.gif') />
<cfset stReturn.properties.IMServername = ReadPropertiesFileProperty('Various', 'IMServername', 'im.openTeamware.com') />
<cfset stReturn.properties.SMSDefaultSender = ReadPropertiesFileProperty('Various', 'SMSDefaultSender', 'openTeamWare') />
<cfset stReturn.properties.GoogleMapsAPIKey = ReadPropertiesFileProperty('Various', 'GoogleMapsAPIKey', '') />

<!--- error handling --->
<cfset stReturn.properties.EmailReportsEnabled = ReadPropertiesFileProperty('Error', 'EmailReportsEnabled', '1')>
<cfset stReturn.properties.NotifyEmail = ReadPropertiesFileProperty('Error', 'NotifyEmail', 'hp@openTeamware.com')>

<!--- script URLS --->
<cfset stReturn.properties.GenerateProcmailConfigScript = ReadPropertiesFileProperty('Scripts', 'GenerateProcmailConfigScript', 'http://database01.admin.openTeamware.com/cgi-bin/createprocmailrc.pl?username=')>
<cfset stReturn.properties.CreateMailDirScript = ReadPropertiesFileProperty('Scripts', 'CreateMailDirScript', 'http://database01.admin.openTeamware.com/cgi-bin/createmaildir.pl?username=')>
<cfset stReturn.properties.UpdateMaildirSizeScript = ReadPropertiesFileProperty('Scripts', 'UpdateMaildirSizeScript', 'http://database01.admin.openTeamware.com/cgi-bin/updatemaildirsize?username=')>