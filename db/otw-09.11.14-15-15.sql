# ************************************************************
# Sequel Pro SQL dump
# Version 4096
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# Host: 127.0.0.1 (MySQL 5.5.25a)
# Database: otw
# Generation Time: 2014-11-09 14:15:53 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table action_protocol
# ------------------------------------------------------------

DROP TABLE IF EXISTS `action_protocol`;

CREATE TABLE `action_protocol` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `createdbyuserkey` varchar(40) NOT NULL DEFAULT '',
  `userkey` varchar(40) NOT NULL DEFAULT '',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `servicekey` varchar(40) NOT NULL DEFAULT '',
  `information` text NOT NULL,
  `objectkey` varchar(40) NOT NULL DEFAULT '',
  `action` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table addressbook
# ------------------------------------------------------------

DROP TABLE IF EXISTS `addressbook`;

CREATE TABLE `addressbook` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(36) NOT NULL DEFAULT '',
  `firstname` varchar(255) NOT NULL DEFAULT '',
  `surname` varchar(255) NOT NULL DEFAULT '',
  `company` varchar(255) NOT NULL DEFAULT '',
  `department` varchar(255) NOT NULL DEFAULT '',
  `aposition` varchar(500) NOT NULL DEFAULT '',
  `userkey` varchar(36) NOT NULL,
  `birthday` datetime DEFAULT NULL,
  `categories` varchar(255) NOT NULL DEFAULT '',
  `lastemailcontact` datetime DEFAULT NULL,
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `b_street` varchar(255) NOT NULL DEFAULT '',
  `b_zipcode` varchar(50) NOT NULL DEFAULT '',
  `b_city` varchar(255) NOT NULL DEFAULT '',
  `b_telephone` varchar(255) NOT NULL DEFAULT '',
  `b_fax` varchar(255) NOT NULL DEFAULT '',
  `b_country` varchar(255) NOT NULL DEFAULT '',
  `b_mobile` varchar(255) NOT NULL DEFAULT '',
  `b_url` varchar(255) NOT NULL DEFAULT '',
  `b_iptelephone` varchar(255) NOT NULL DEFAULT '',
  `email_adr` varchar(255) NOT NULL,
  `p_city` varchar(255) NOT NULL DEFAULT '',
  `p_street` varchar(255) NOT NULL DEFAULT '',
  `p_zipcode` varchar(255) NOT NULL DEFAULT '',
  `p_country` varchar(255) NOT NULL DEFAULT '',
  `p_telephone` varchar(255) NOT NULL DEFAULT '',
  `p_fax` varchar(255) NOT NULL DEFAULT '',
  `p_iptelephone` varchar(255) NOT NULL DEFAULT '',
  `p_mobile` varchar(255) NOT NULL DEFAULT '',
  `p_url` varchar(255) NOT NULL DEFAULT '',
  `notice` text NOT NULL,
  `email_prim` varchar(255) NOT NULL DEFAULT '',
  `username` varchar(255) NOT NULL DEFAULT '',
  `reupdateavaliable` tinyint(4) NOT NULL DEFAULT '0',
  `archiveentry` tinyint(4) NOT NULL DEFAULT '0',
  `url` varchar(255) NOT NULL DEFAULT '',
  `dt_lastsmssent` datetime DEFAULT NULL,
  `dt_lastmodified` datetime DEFAULT NULL,
  `nickname` varchar(255) NOT NULL DEFAULT '',
  `icqnumber` varchar(50) NOT NULL DEFAULT '',
  `old_id` int(11) NOT NULL DEFAULT '0',
  `sex` int(11) NOT NULL DEFAULT '-1',
  `title` varchar(50) NOT NULL DEFAULT '',
  `lasteditedbyuserkey` varchar(50) NOT NULL DEFAULT '',
  `createdbyuserkey` varchar(50) NOT NULL DEFAULT '',
  `daylightsavinghoursoncreate` int(11) NOT NULL DEFAULT '0',
  `privatecontact` int(11) NOT NULL DEFAULT '0',
  `dt_lastcontact` datetime DEFAULT NULL,
  `parentcontactkey` varchar(50) NOT NULL DEFAULT '',
  `maincontact` int(11) NOT NULL DEFAULT '1',
  `contacttype` int(11) NOT NULL DEFAULT '0',
  `dt_remoteedit_last_update` datetime DEFAULT NULL,
  `criteria` varchar(255) NOT NULL DEFAULT '',
  `skypeusername` varchar(150) NOT NULL DEFAULT '',
  `lang` char(2) NOT NULL DEFAULT '',
  `rating_decisionmaker` tinyint(4) NOT NULL DEFAULT '-1',
  `rating_advisor` tinyint(4) NOT NULL DEFAULT '-1',
  `rating_tester` tinyint(4) NOT NULL DEFAULT '-1',
  `rating_sponsor` tinyint(4) NOT NULL DEFAULT '-1',
  `b_telephone_2` varchar(255) DEFAULT NULL,
  `nace_code` int(11) DEFAULT '0',
  `employees` int(11) DEFAULT NULL,
  `activity_count_followups` int(11) NOT NULL DEFAULT '0',
  `activity_count_appointments` int(11) NOT NULL DEFAULT '0',
  `activity_count_tasks` int(11) NOT NULL DEFAULT '0',
  `activity_count_salesprojects` int(11) NOT NULL DEFAULT '0',
  `superiorcontactkey` varchar(40) DEFAULT NULL,
  `photoavailable` int(11) NOT NULL DEFAULT '0',
  `ownfield1` varchar(500) DEFAULT NULL,
  `ownfield2` varchar(500) DEFAULT NULL,
  `ownfield3` varchar(500) DEFAULT NULL,
  `ownfield4` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `entrykey` (`entrykey`),
  KEY `userkey` (`userkey`),
  KEY `parentcontactkey` (`parentcontactkey`),
  KEY `index_b_city` (`b_city`),
  KEY `index_b_zipcode` (`b_zipcode`),
  KEY `index_b_country` (`b_country`),
  KEY `index_surname` (`surname`),
  KEY `index_company` (`company`),
  KEY `ind_criteria` (`criteria`),
  KEY `ind_contacttype` (`contacttype`),
  KEY `email_prim` (`email_prim`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table addressbook_outlook_data
# ------------------------------------------------------------

DROP TABLE IF EXISTS `addressbook_outlook_data`;

CREATE TABLE `addressbook_outlook_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `addressbookkey` varchar(50) NOT NULL DEFAULT '',
  `outlook_id` varchar(255) NOT NULL DEFAULT '',
  `program_id` varchar(255) NOT NULL DEFAULT '',
  `lastupdate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `addressbookkey` (`addressbookkey`,`program_id`),
  KEY `program_id` (`program_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table adminactions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `adminactions`;

CREATE TABLE `adminactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `userkey` varchar(50) NOT NULL DEFAULT '',
  `urlvariables` text NOT NULL,
  `formvariables` longtext NOT NULL,
  `resellerkey` varchar(50) NOT NULL DEFAULT '',
  `companykey` varchar(50) NOT NULL DEFAULT '',
  `href` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table alertsettings
# ------------------------------------------------------------

DROP TABLE IF EXISTS `alertsettings`;

CREATE TABLE `alertsettings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userkey` varchar(50) NOT NULL DEFAULT '',
  `servicekey` varchar(50) NOT NULL DEFAULT '',
  `objectkey` varchar(50) NOT NULL DEFAULT '',
  `events` varchar(255) NOT NULL DEFAULT 'create,change,delete',
  `notifyemail` int(11) NOT NULL DEFAULT '1',
  `notifysms` int(11) NOT NULL DEFAULT '0',
  `notifyreminder` int(11) NOT NULL DEFAULT '1',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table assigned_criteria
# ------------------------------------------------------------

DROP TABLE IF EXISTS `assigned_criteria`;

CREATE TABLE `assigned_criteria` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `criteria_id` int(11) NOT NULL DEFAULT '0',
  `servicekey` varchar(40) NOT NULL,
  `objectkey` varchar(40) NOT NULL,
  `createdbyuserkey` varchar(40) NOT NULL,
  `dt_created` datetime NOT NULL,
  `criteriakey` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `criteria_id` (`criteria_id`,`objectkey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table assigned_items
# ------------------------------------------------------------

DROP TABLE IF EXISTS `assigned_items`;

CREATE TABLE `assigned_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `servicekey` varchar(36) NOT NULL DEFAULT '',
  `objectkey` varchar(36) NOT NULL DEFAULT '',
  `userkey` varchar(36) NOT NULL DEFAULT '',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `comment` varchar(255) NOT NULL DEFAULT '',
  `createdbyuserkey` varchar(50) NOT NULL DEFAULT '',
  `default_contact` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `servicekey` (`servicekey`,`objectkey`,`userkey`),
  KEY `servicekey_2` (`servicekey`,`objectkey`),
  KEY `servicekey_3` (`servicekey`),
  KEY `objectkey` (`objectkey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table assignedcontacts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `assignedcontacts`;

CREATE TABLE `assignedcontacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contactkey` varchar(50) NOT NULL DEFAULT '',
  `userkey` varchar(50) NOT NULL DEFAULT '',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `createdbyuserkey` varchar(50) NOT NULL DEFAULT '',
  `furtherinformation` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `contactkey` (`contactkey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table avaliableactions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `avaliableactions`;

CREATE TABLE `avaliableactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `servicekey` varchar(50) NOT NULL DEFAULT '',
  `actionname` varchar(100) NOT NULL DEFAULT '',
  `entrykey` varchar(50) NOT NULL DEFAULT '',
  `parentkey` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table bookedservices
# ------------------------------------------------------------

DROP TABLE IF EXISTS `bookedservices`;

CREATE TABLE `bookedservices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(50) NOT NULL DEFAULT '',
  `companykey` varchar(50) NOT NULL DEFAULT '',
  `productkey` varchar(50) NOT NULL DEFAULT '',
  `paid` int(11) NOT NULL DEFAULT '0',
  `durationinmonths` int(11) NOT NULL DEFAULT '0',
  `totalamount` float NOT NULL DEFAULT '0',
  `dt_contractend` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `createdbyuserkey` varchar(50) NOT NULL DEFAULT '',
  `specialdiscount` int(11) NOT NULL DEFAULT '0',
  `productname` varchar(250) NOT NULL DEFAULT '',
  `quantity` int(11) NOT NULL DEFAULT '0',
  `unit` varchar(10) NOT NULL DEFAULT '',
  `comment` varchar(255) NOT NULL DEFAULT '',
  `settled` int(11) NOT NULL DEFAULT '0',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `currency` varchar(10) NOT NULL DEFAULT 'EUR',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table cached_ids
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cached_ids`;

CREATE TABLE `cached_ids` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parameters` varchar(40) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `userkey` varchar(40) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `servicekey` varchar(40) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `ids` longtext COLLATE latin1_general_ci NOT NULL,
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `data1` longtext COLLATE latin1_general_ci NOT NULL,
  `data2` longtext COLLATE latin1_general_ci NOT NULL,
  `debug_params` longtext COLLATE latin1_general_ci NOT NULL,
  `companykey` varchar(40) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `items_count` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `userkey` (`userkey`,`servicekey`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;



# Dump of table cal_remind
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cal_remind`;

CREATE TABLE `cal_remind` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(50) NOT NULL DEFAULT '',
  `userkey` varchar(50) NOT NULL DEFAULT '',
  `eventkey` varchar(50) NOT NULL DEFAULT '',
  `dt_remind` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `type` int(11) NOT NULL DEFAULT '0',
  `status` int(11) NOT NULL DEFAULT '0',
  `remind_email_adr` varchar(255) NOT NULL DEFAULT '',
  `eventtitle` varchar(255) NOT NULL DEFAULT '',
  `eventstart` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table calendar
# ------------------------------------------------------------

DROP TABLE IF EXISTS `calendar`;

CREATE TABLE `calendar` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(36) NOT NULL DEFAULT '',
  `userkey` varchar(50) NOT NULL DEFAULT '',
  `title` varchar(255) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `type` int(11) NOT NULL DEFAULT '0',
  `location` varchar(255) NOT NULL DEFAULT '',
  `date_start` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_end` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `repeat_start` datetime DEFAULT NULL,
  `repeat_until` datetime DEFAULT NULL,
  `priority` int(11) NOT NULL DEFAULT '2',
  `wholeday` int(11) NOT NULL DEFAULT '0',
  `repeat_type` int(11) NOT NULL DEFAULT '0',
  `repeat_day` int(11) NOT NULL DEFAULT '0',
  `repeat_month` int(11) NOT NULL DEFAULT '0',
  `meetingmemberscount` int(11) NOT NULL DEFAULT '0',
  `dt_lastmodified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `associatedurl` varchar(255) NOT NULL DEFAULT '',
  `categories` varchar(255) NOT NULL DEFAULT '',
  `repeat_weekday` int(11) NOT NULL DEFAULT '0',
  `repeat_day_1` int(11) NOT NULL DEFAULT '0',
  `repeat_day_2` int(11) NOT NULL DEFAULT '0',
  `repeat_day_3` int(11) NOT NULL DEFAULT '0',
  `repeat_day_4` int(11) NOT NULL DEFAULT '0',
  `repeat_day_5` int(11) NOT NULL DEFAULT '0',
  `repeat_day_6` int(11) NOT NULL DEFAULT '0',
  `repeat_day_7` int(11) NOT NULL DEFAULT '0',
  `privateevent` int(11) NOT NULL DEFAULT '0',
  `syncevent` int(11) NOT NULL DEFAULT '1',
  `calendarkey` varchar(50) NOT NULL DEFAULT '',
  `showtimeas` int(11) NOT NULL DEFAULT '0',
  `vcalendarkey` varchar(50) NOT NULL DEFAULT '',
  `projectkey` varchar(50) NOT NULL DEFAULT '',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `repeat_interval` int(11) NOT NULL DEFAULT '0',
  `repeat_weekdays` varchar(7) NOT NULL DEFAULT '',
  `lasteditedbyuserkey` varchar(50) NOT NULL DEFAULT '',
  `createdbyuserkey` varchar(50) NOT NULL DEFAULT '',
  `virtualcalendarkey` varchar(50) NOT NULL DEFAULT '',
  `utcdiffoncreation` int(11) NOT NULL DEFAULT '-1',
  `migrated` int(11) NOT NULL DEFAULT '0',
  `oldid` int(11) NOT NULL DEFAULT '0',
  `daylightsavinghoursoncreate` int(11) NOT NULL DEFAULT '0',
  `createdbysecretarykey` varchar(50) NOT NULL DEFAULT '',
  `done` int(11) NOT NULL DEFAULT '0',
  `color` varchar(10) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `entrykey` (`entrykey`),
  KEY `userkey` (`userkey`,`date_start`,`date_end`),
  KEY `userkey_2` (`userkey`,`date_start`,`repeat_until`),
  KEY `userkey_3` (`userkey`),
  KEY `repeat_type` (`repeat_type`),
  KEY `repeat_start` (`repeat_start`),
  KEY `repeat_until` (`repeat_until`),
  KEY `date_start` (`date_start`),
  KEY `date_end` (`date_end`),
  KEY `repeat_weekday` (`repeat_weekday`),
  KEY `id` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table calendar_outlook_data
# ------------------------------------------------------------

DROP TABLE IF EXISTS `calendar_outlook_data`;

CREATE TABLE `calendar_outlook_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `eventkey` varchar(50) NOT NULL DEFAULT '',
  `outlook_id` varchar(200) NOT NULL DEFAULT '',
  `program_id` varchar(200) NOT NULL DEFAULT '',
  `lastupdate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `eventkey` (`eventkey`,`program_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table calendar_shareddata
# ------------------------------------------------------------

DROP TABLE IF EXISTS `calendar_shareddata`;

CREATE TABLE `calendar_shareddata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(36) NOT NULL DEFAULT '',
  `createdbyuserkey` varchar(50) NOT NULL DEFAULT '',
  `eventkey` varchar(36) NOT NULL DEFAULT '',
  `workgroupkey` varchar(36) NOT NULL DEFAULT '',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `eventkey` (`eventkey`,`workgroupkey`),
  KEY `workgroupkey` (`workgroupkey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table companies
# ------------------------------------------------------------

DROP TABLE IF EXISTS `companies`;

CREATE TABLE `companies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `companyname` varchar(250) NOT NULL DEFAULT '',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `dt_trialphase_end` datetime DEFAULT NULL,
  `resellerkey` varchar(50) NOT NULL DEFAULT '0',
  `status` int(11) NOT NULL DEFAULT '1',
  `entrykey` varchar(50) NOT NULL DEFAULT '',
  `uidnumber` varchar(100) NOT NULL DEFAULT '',
  `description` varchar(250) NOT NULL DEFAULT '',
  `telephone` varchar(100) NOT NULL DEFAULT '',
  `customheader` varchar(250) NOT NULL DEFAULT '',
  `customss` varchar(250) NOT NULL DEFAULT '',
  `dt_contractstart` datetime DEFAULT NULL,
  `dt_contractend` datetime DEFAULT NULL,
  `domain` varchar(250) NOT NULL DEFAULT 'inbox.cc',
  `street` varchar(255) NOT NULL DEFAULT '',
  `city` varchar(255) NOT NULL DEFAULT '',
  `zipcode` varchar(50) NOT NULL DEFAULT '',
  `fax` varchar(255) NOT NULL DEFAULT '',
  `country` varchar(250) NOT NULL DEFAULT '',
  `countryisocode` varchar(10) NOT NULL DEFAULT '',
  `customerid` int(11) NOT NULL DEFAULT '20100',
  `email` varchar(250) NOT NULL DEFAULT '',
  `customertype` int(11) NOT NULL DEFAULT '1',
  `fbnumber` varchar(255) NOT NULL DEFAULT '',
  `customheaderincludedir` varchar(255) NOT NULL DEFAULT '',
  `shortname` varchar(50) NOT NULL DEFAULT '',
  `contactperson` varchar(150) NOT NULL DEFAULT '',
  `domains` varchar(255) NOT NULL DEFAULT 'inbox.cc',
  `dt_nextcontact` datetime DEFAULT NULL,
  `rating` tinyint(4) NOT NULL DEFAULT '3',
  `assignedtoreseller` int(11) NOT NULL DEFAULT '1',
  `reasonforregistration` varchar(255) NOT NULL DEFAULT '',
  `commentsonregistration` text,
  `billingcontact` text NOT NULL,
  `disabled` int(11) NOT NULL DEFAULT '0',
  `disabled_reason` text NOT NULL,
  `dt_disabled` datetime DEFAULT NULL,
  `datachecked` int(11) NOT NULL DEFAULT '0',
  `dt_datachecked_alert_set` datetime DEFAULT NULL,
  `datacheck_alert_set` int(11) NOT NULL DEFAULT '0',
  `oldpasswords` text NOT NULL,
  `parentcompanykey` varchar(50) NOT NULL DEFAULT '',
  `trialexpired` int(11) NOT NULL DEFAULT '0',
  `signupsource` varchar(255) NOT NULL DEFAULT '',
  `createdbyuserkey` varchar(50) NOT NULL DEFAULT '',
  `settlementinterval` int(11) NOT NULL DEFAULT '12',
  `dunninglevel` int(11) NOT NULL DEFAULT '0',
  `distributorkey` varchar(50) NOT NULL DEFAULT '',
  `generaltermsandconditions_accepted` int(11) NOT NULL DEFAULT '1',
  `autoorderontrialend` tinyint(4) NOT NULL DEFAULT '1',
  `httpreferer` varchar(255) NOT NULL DEFAULT '',
  `openinvoices` int(11) NOT NULL DEFAULT '0',
  `industry` varchar(255) NOT NULL DEFAULT '',
  `wddx_additional_data` longtext NOT NULL,
  `language` int(11) NOT NULL DEFAULT '0',
  `currency` varchar(10) NOT NULL DEFAULT 'EUR',
  `style` varchar(40) NOT NULL DEFAULT '',
  `company_default_categories` text NOT NULL,
  `settlement_type` int(11) NOT NULL DEFAULT '0',
  `allow_order_shop` int(11) NOT NULL DEFAULT '1',
  `enable_auto_renewal` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `entrykey` (`entrykey`),
  KEY `entrykey_2` (`entrykey`,`resellerkey`,`distributorkey`),
  KEY `generaltermsandconditions_accepted` (`generaltermsandconditions_accepted`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table companies_saved_data
# ------------------------------------------------------------

DROP TABLE IF EXISTS `companies_saved_data`;

CREATE TABLE `companies_saved_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `createdbyuserkey` varchar(50) NOT NULL DEFAULT '',
  `wddx` text NOT NULL,
  `companykey` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table company_custom_elements
# ------------------------------------------------------------

DROP TABLE IF EXISTS `company_custom_elements`;

CREATE TABLE `company_custom_elements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `companykey` varchar(40) NOT NULL DEFAULT '',
  `item_name` varchar(255) NOT NULL DEFAULT '',
  `content` text NOT NULL,
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `createdbyuserkey` varchar(40) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `companykey` (`companykey`,`item_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table companycontacts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `companycontacts`;

CREATE TABLE `companycontacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contacttype` int(11) NOT NULL DEFAULT '0',
  `companykey` varchar(50) NOT NULL DEFAULT '',
  `userkey` varchar(50) NOT NULL DEFAULT '',
  `user_level` int(11) NOT NULL DEFAULT '100',
  `permissions` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `companykey` (`companykey`),
  KEY `userkey` (`userkey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table companylogos
# ------------------------------------------------------------

DROP TABLE IF EXISTS `companylogos`;

CREATE TABLE `companylogos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `companykey` varchar(40) NOT NULL,
  `dt_created` datetime NOT NULL,
  `filetype` varchar(100) NOT NULL,
  `imagedata` longtext,
  `createdbyuserkey` varchar(40) NOT NULL,
  `entrykey` varchar(40) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `companykey` (`companykey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table connecteditems
# ------------------------------------------------------------

DROP TABLE IF EXISTS `connecteditems`;

CREATE TABLE `connecteditems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `projectkey` varchar(50) NOT NULL DEFAULT '',
  `servicekey` varchar(50) NOT NULL DEFAULT '',
  `objectkey` varchar(50) NOT NULL DEFAULT '',
  `objecttype` varchar(50) NOT NULL DEFAULT '',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `createdbyuserkey` varchar(50) NOT NULL DEFAULT '',
  `comment` varchar(255) NOT NULL DEFAULT '',
  `categories` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `projectkey` (`projectkey`,`servicekey`,`objectkey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table contact_links
# ------------------------------------------------------------

DROP TABLE IF EXISTS `contact_links`;

CREATE TABLE `contact_links` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(40) NOT NULL DEFAULT '',
  `source_entrykey` varchar(40) NOT NULL DEFAULT '',
  `dest_entrykey` varchar(40) NOT NULL DEFAULT '',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `createdbyuserkey` varchar(40) NOT NULL DEFAULT '',
  `connection_type` int(11) NOT NULL DEFAULT '0',
  `comment` varchar(255) NOT NULL DEFAULT '',
  `source_name` varchar(255) NOT NULL DEFAULT '',
  `dest_name` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `source_name` (`source_name`),
  KEY `dest_entrykey` (`dest_entrykey`),
  KEY `source_entrykey` (`source_entrykey`,`dest_entrykey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table crm_default_reports
# ------------------------------------------------------------

DROP TABLE IF EXISTS `crm_default_reports`;

CREATE TABLE `crm_default_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(36) NOT NULL,
  `reportname` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `groupname` varchar(255) NOT NULL,
  `basedonaddressbook` int(11) NOT NULL DEFAULT '1',
  `allow_select_fields` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table crm_reports
# ------------------------------------------------------------

DROP TABLE IF EXISTS `crm_reports`;

CREATE TABLE `crm_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(40) NOT NULL,
  `userkey` varchar(40) NOT NULL,
  `reportname` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `tablekey` varchar(40) NOT NULL,
  `dt_created` datetime NOT NULL,
  `dt_start` datetime NOT NULL,
  `dt_end` datetime NOT NULL,
  `date_field` varchar(100) NOT NULL,
  `displayfields` text NOT NULL,
  `specials` text NOT NULL,
  `interval` varchar(255) NOT NULL,
  `filter` text NOT NULL,
  `defaultreport` int(11) NOT NULL DEFAULT '0',
  `basedonaddressbook` int(11) NOT NULL,
  `allow_select_fields` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table crm_reports_output
# ------------------------------------------------------------

DROP TABLE IF EXISTS `crm_reports_output`;

CREATE TABLE `crm_reports_output` (
  `id` int(11) DEFAULT NULL,
  `entrykey` varchar(36) DEFAULT NULL,
  `reportkey` varchar(36) DEFAULT NULL,
  `dt_created` timestamp NULL DEFAULT NULL,
  `wddx` longtext,
  `userkey` varchar(36) DEFAULT NULL,
  `includefields` varchar(1000) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table crm_running_reports
# ------------------------------------------------------------

DROP TABLE IF EXISTS `crm_running_reports`;

CREATE TABLE `crm_running_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `reportkey` varchar(40) NOT NULL DEFAULT '',
  `entrykey` varchar(40) NOT NULL DEFAULT '',
  `userkey` varchar(40) NOT NULL DEFAULT '',
  `alert_user_by_email_when_finished` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `userkey` (`userkey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table crmcriteria
# ------------------------------------------------------------

DROP TABLE IF EXISTS `crmcriteria`;

CREATE TABLE `crmcriteria` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `companykey` varchar(40) NOT NULL DEFAULT '',
  `parent_id` int(11) NOT NULL DEFAULT '0',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `criterianame` varchar(255) NOT NULL DEFAULT '',
  `img` int(11) NOT NULL DEFAULT '0',
  `description` varchar(255) NOT NULL DEFAULT '',
  `servicekey` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `parent_id` (`parent_id`,`criterianame`,`companykey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table crmfiltersearchsettings
# ------------------------------------------------------------

DROP TABLE IF EXISTS `crmfiltersearchsettings`;

CREATE TABLE `crmfiltersearchsettings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(50) NOT NULL DEFAULT '',
  `userkey` varchar(50) NOT NULL DEFAULT '',
  `viewkey` varchar(50) NOT NULL DEFAULT '',
  `area` int(11) NOT NULL DEFAULT '0',
  `displayname` varchar(255) NOT NULL DEFAULT '',
  `internalfieldname` varchar(255) NOT NULL DEFAULT '',
  `internaldatatype` int(11) NOT NULL DEFAULT '0',
  `connector` int(11) NOT NULL DEFAULT '0',
  `operator` int(11) NOT NULL DEFAULT '0',
  `comparevalue` varchar(255) NOT NULL DEFAULT '',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `servicekey` varchar(50) NOT NULL DEFAULT '',
  `itemtype` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table crmfilterviews
# ------------------------------------------------------------

DROP TABLE IF EXISTS `crmfilterviews`;

CREATE TABLE `crmfilterviews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(40) NOT NULL DEFAULT '',
  `userkey` varchar(40) NOT NULL DEFAULT '',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `description` varchar(255) NOT NULL DEFAULT '',
  `viewname` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table crmsalesmappings
# ------------------------------------------------------------

DROP TABLE IF EXISTS `crmsalesmappings`;

CREATE TABLE `crmsalesmappings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(40) NOT NULL,
  `companykey` varchar(40) NOT NULL,
  `additionaldata_tablekey` varchar(40) NOT NULL,
  `dt_created` datetime NOT NULL,
  `createdbyuserkey` varchar(40) NOT NULL,
  `databasekey` varchar(40) NOT NULL,
  `userkey_data` varchar(40) NOT NULL,
  `activities_tablekey` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table custompermissions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `custompermissions`;

CREATE TABLE `custompermissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dt_created` datetime DEFAULT NULL,
  `createdbyuserkey` varchar(50) NOT NULL DEFAULT '',
  `entrykey` varchar(50) NOT NULL DEFAULT '',
  `workgroupkey` varchar(50) NOT NULL DEFAULT '',
  `userkey` varchar(50) NOT NULL DEFAULT '',
  `servicekey` varchar(50) NOT NULL DEFAULT '',
  `sectionkey` varchar(50) NOT NULL DEFAULT '',
  `objectkey` varchar(50) NOT NULL DEFAULT '',
  `allowedactions` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`,`entrykey`),
  KEY `entrykey` (`entrykey`),
  KEY `userkey` (`userkey`,`workgroupkey`),
  KEY `userkey_2` (`userkey`),
  KEY `workgroupkey` (`workgroupkey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table deleted_outlooksync_meta_data
# ------------------------------------------------------------

DROP TABLE IF EXISTS `deleted_outlooksync_meta_data`;

CREATE TABLE `deleted_outlooksync_meta_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userkey` varchar(40) NOT NULL DEFAULT '',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `wddx` longtext NOT NULL,
  `servicekey` varchar(40) NOT NULL DEFAULT '',
  `program_id` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table deleted_postings
# ------------------------------------------------------------

DROP TABLE IF EXISTS `deleted_postings`;

CREATE TABLE `deleted_postings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `deletedbyuserkey` varchar(40) NOT NULL DEFAULT '',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `wddx` longtext NOT NULL,
  `reason` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table deleteddata
# ------------------------------------------------------------

DROP TABLE IF EXISTS `deleteddata`;

CREATE TABLE `deleteddata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `servicekey` varchar(50) NOT NULL DEFAULT '',
  `datakey` varchar(50) NOT NULL DEFAULT '',
  `userkey` varchar(50) NOT NULL DEFAULT '',
  `wddxdata` longtext NOT NULL,
  `dt_deleted` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `title` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `dt_deleted` (`dt_deleted`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table directories
# ------------------------------------------------------------

DROP TABLE IF EXISTS `directories`;

CREATE TABLE `directories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(40) DEFAULT NULL,
  `directoryname` varchar(255) NOT NULL,
  `description` varchar(150) DEFAULT NULL,
  `userkey` varchar(40) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `createdbyuserkey` varchar(40) DEFAULT NULL,
  `lasteditedbyuserkey` varchar(40) NOT NULL,
  `filescount` int(11) NOT NULL DEFAULT '0',
  `displaytype` int(11) NOT NULL DEFAULT '0',
  `categories` varchar(200) DEFAULT NULL,
  `versioning` int(11) NOT NULL DEFAULT '0',
  `dt_lastmodified` datetime NOT NULL,
  `dt_created` datetime NOT NULL,
  `parentdirectorykey` varchar(40) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `entrykey` (`entrykey`),
  KEY `directoryname` (`directoryname`,`userkey`,`parentdirectorykey`),
  KEY `parentdirectorykey` (`parentdirectorykey`),
  KEY `userkey` (`userkey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table directories_shareddata
# ------------------------------------------------------------

DROP TABLE IF EXISTS `directories_shareddata`;

CREATE TABLE `directories_shareddata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dt_created` datetime NOT NULL,
  `workgroupkey` varchar(40) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `createdbyuserkey` varchar(40) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `directorykey` varchar(40) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `directorykey` (`directorykey`),
  KEY `directorykey_2` (`directorykey`,`workgroupkey`),
  KEY `workgroupkey` (`workgroupkey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table download_links
# ------------------------------------------------------------

DROP TABLE IF EXISTS `download_links`;

CREATE TABLE `download_links` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(50) NOT NULL DEFAULT '',
  `filelocation` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table editeddata
# ------------------------------------------------------------

DROP TABLE IF EXISTS `editeddata`;

CREATE TABLE `editeddata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `servicekey` varchar(50) NOT NULL DEFAULT '',
  `datakey` varchar(50) NOT NULL DEFAULT '',
  `userkey` varchar(50) NOT NULL DEFAULT '',
  `wddxdata` longtext NOT NULL,
  `dt_edited` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `title` varchar(255) NOT NULL DEFAULT '',
  `editedfields` text NOT NULL,
  `old_data_wddx` longtext NOT NULL,
  `new_data_wddx` longtext NOT NULL,
  `usercomment` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `datakey` (`datakey`),
  KEY `dt_edited` (`dt_edited`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table element_links
# ------------------------------------------------------------

DROP TABLE IF EXISTS `element_links`;

CREATE TABLE `element_links` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(40) NOT NULL DEFAULT '',
  `source_entrykey` varchar(40) NOT NULL DEFAULT '',
  `dest_entrykey` varchar(40) NOT NULL DEFAULT '',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `createdbyuserkey` varchar(40) NOT NULL DEFAULT '',
  `connection_type` varchar(250) NOT NULL DEFAULT '0',
  `comment` varchar(255) NOT NULL DEFAULT '',
  `source_name` varchar(255) NOT NULL DEFAULT '',
  `dest_name` varchar(255) NOT NULL DEFAULT '',
  `source_servicekey` varchar(40) NOT NULL DEFAULT '',
  `dest_servicekey` varchar(40) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `source_name` (`source_name`),
  KEY `dest_entrykey` (`dest_entrykey`),
  KEY `source_entrykey` (`source_entrykey`,`dest_entrykey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table email_signatures
# ------------------------------------------------------------

DROP TABLE IF EXISTS `email_signatures`;

CREATE TABLE `email_signatures` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(40) NOT NULL DEFAULT '',
  `userkey` varchar(40) NOT NULL DEFAULT '',
  `email_adr` varchar(100) NOT NULL DEFAULT '',
  `sig_type` int(11) NOT NULL DEFAULT '0',
  `sig_data` text NOT NULL,
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `title` varchar(255) NOT NULL DEFAULT '',
  `default_sig` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `userkey` (`userkey`),
  KEY `email_adr` (`email_adr`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table emailaliases
# ------------------------------------------------------------

DROP TABLE IF EXISTS `emailaliases`;

CREATE TABLE `emailaliases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `destinationaddress` varchar(255) NOT NULL DEFAULT '',
  `aliasaddress` varchar(255) NOT NULL DEFAULT '',
  `createdbyuserkey` varchar(50) NOT NULL DEFAULT '',
  `companykey` varchar(50) NOT NULL DEFAULT '',
  `userkey` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `aliasaddress` (`aliasaddress`),
  KEY `userkey` (`userkey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table emailattachments
# ------------------------------------------------------------

DROP TABLE IF EXISTS `emailattachments`;

CREATE TABLE `emailattachments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL DEFAULT '',
  `foldername` varchar(255) NOT NULL DEFAULT '',
  `uid` int(11) NOT NULL DEFAULT '0',
  `filename` varchar(255) NOT NULL DEFAULT '',
  `contenttype` varchar(255) NOT NULL DEFAULT '',
  `messageid` varchar(255) NOT NULL DEFAULT '',
  `filepath` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table emailmetainformation
# ------------------------------------------------------------

DROP TABLE IF EXISTS `emailmetainformation`;

CREATE TABLE `emailmetainformation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userkey` varchar(50) NOT NULL DEFAULT '',
  `username` varchar(255) NOT NULL DEFAULT '',
  `folder` varchar(255) NOT NULL DEFAULT '',
  `uid` int(11) NOT NULL DEFAULT '0',
  `messageid` varchar(255) NOT NULL DEFAULT '',
  `dt_created` datetime DEFAULT NULL,
  `subject` varchar(255) NOT NULL DEFAULT '',
  `reference_ids` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `userkey` (`userkey`,`folder`,`uid`),
  KEY `userkey_2` (`userkey`,`messageid`),
  KEY `userkey_3` (`userkey`,`reference_ids`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table exceptionlog
# ------------------------------------------------------------

DROP TABLE IF EXISTS `exceptionlog`;

CREATE TABLE `exceptionlog` (
  `entrykey` varchar(36) NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dt_created` datetime NOT NULL,
  `Message` varchar(500) NOT NULL,
  `data_wddx_error` longtext NOT NULL,
  `ip` varchar(40) NOT NULL,
  `hostname` varchar(255) NOT NULL,
  `data_wddx_cgi` longtext NOT NULL,
  `data_wddx_url` longtext NOT NULL,
  `data_wddx_session` longtext NOT NULL,
  `data_wddx_arguments` longtext NOT NULL,
  `data_wddx_form` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table exclusive_locks
# ------------------------------------------------------------

DROP TABLE IF EXISTS `exclusive_locks`;

CREATE TABLE `exclusive_locks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(40) COLLATE latin1_general_ci NOT NULL,
  `servicekey` varchar(40) COLLATE latin1_general_ci NOT NULL,
  `objectkey` varchar(40) COLLATE latin1_general_ci NOT NULL,
  `userkey` varchar(40) COLLATE latin1_general_ci NOT NULL,
  `dt_created` datetime NOT NULL,
  `dt_timeout` datetime NOT NULL,
  `comment` varchar(255) COLLATE latin1_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `servicekey` (`servicekey`,`objectkey`,`userkey`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;



# Dump of table explicit_moderators
# ------------------------------------------------------------

DROP TABLE IF EXISTS `explicit_moderators`;

CREATE TABLE `explicit_moderators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userkey` varchar(40) NOT NULL DEFAULT '',
  `forumkey` varchar(40) NOT NULL DEFAULT '',
  `dt_created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table failedlogins
# ------------------------------------------------------------

DROP TABLE IF EXISTS `failedlogins`;

CREATE TABLE `failedlogins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userkey` varchar(50) NOT NULL DEFAULT '',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ip` varchar(50) NOT NULL DEFAULT '',
  `reason` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table filterdata
# ------------------------------------------------------------

DROP TABLE IF EXISTS `filterdata`;

CREATE TABLE `filterdata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userkey` varchar(50) NOT NULL DEFAULT '',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `atype` varchar(50) NOT NULL DEFAULT '',
  `acompare` int(11) NOT NULL DEFAULT '0',
  `acomparsevalue` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table followups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `followups`;

CREATE TABLE `followups` (
  `entrykey` varchar(40) NOT NULL DEFAULT '',
  `servicekey` varchar(50) NOT NULL DEFAULT '',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `objectkey` varchar(255) DEFAULT NULL,
  `objecttitle` varchar(255) NOT NULL DEFAULT '',
  `userkey` varchar(50) NOT NULL DEFAULT '',
  `createdbyuserkey` varchar(50) NOT NULL DEFAULT '',
  `dt_due` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `comment` text NOT NULL,
  `done` tinyint(4) NOT NULL DEFAULT '0',
  `alert_email` int(11) NOT NULL DEFAULT '0',
  `followuptype` tinyint(4) unsigned NOT NULL DEFAULT '0',
  `priority` tinyint(4) NOT NULL DEFAULT '3',
  `alert_email_done` int(11) NOT NULL DEFAULT '0',
  `salesprojectkey` varchar(40) DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `categories` varchar(255) NOT NULL,
  PRIMARY KEY (`entrykey`),
  KEY `objectkey` (`objectkey`,`done`),
  KEY `objectkey_2` (`objectkey`),
  KEY `userkey` (`userkey`,`done`,`dt_due`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table foren
# ------------------------------------------------------------

DROP TABLE IF EXISTS `foren`;

CREATE TABLE `foren` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(50) NOT NULL DEFAULT '',
  `companykey` varchar(40) NOT NULL DEFAULT '',
  `forumname` varchar(255) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT '',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `createdbyuserkey` varchar(50) NOT NULL DEFAULT '',
  `dt_lastposting` datetime DEFAULT NULL,
  `announcementforum` int(11) NOT NULL DEFAULT '0',
  `publishpublic` int(11) NOT NULL DEFAULT '0',
  `admin_post_only` int(11) NOT NULL DEFAULT '0',
  `companynews_forum` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table foren_shareddata
# ------------------------------------------------------------

DROP TABLE IF EXISTS `foren_shareddata`;

CREATE TABLE `foren_shareddata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `forumkey` varchar(50) NOT NULL DEFAULT '',
  `workgroupkey` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `forumkey` (`forumkey`,`workgroupkey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table form_fields
# ------------------------------------------------------------

DROP TABLE IF EXISTS `form_fields`;

CREATE TABLE `form_fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(40) DEFAULT NULL,
  `formkey` varchar(40) DEFAULT NULL,
  `input_name` varchar(50) DEFAULT NULL,
  `datatype` varchar(50) DEFAULT 'string',
  `field_name` varchar(100) DEFAULT NULL,
  `internal_description` varchar(255) DEFAULT NULL,
  `addvalidation` int(11) NOT NULL DEFAULT '0',
  `defaultvalue` varchar(255) DEFAULT NULL,
  `parameters` varchar(255) DEFAULT NULL,
  `dt_created` datetime DEFAULT NULL,
  `options` text,
  `visible_description` varchar(255) DEFAULT NULL,
  `orderno` int(11) NOT NULL DEFAULT '0',
  `db_fieldname` varchar(255) DEFAULT NULL,
  `db_fieldname_selector_displayvalue` varchar(255) NOT NULL,
  `required` int(11) NOT NULL DEFAULT '0',
  `output_only` int(11) NOT NULL DEFAULT '0',
  `tr_id` varchar(255) DEFAULT NULL,
  `onchange` varchar(255) DEFAULT NULL,
  `CallBackFunctionName` varchar(255) DEFAULT NULL,
  `CallBackFunctionNameNecessaryArguments` varchar(255) DEFAULT NULL,
  `default_parameter_scope` varchar(5) NOT NULL DEFAULT 'url',
  `default_parameter_name` varchar(50) DEFAULT NULL,
  `colspan` int(11) NOT NULL DEFAULT '1',
  `css` varchar(255) DEFAULT NULL,
  `jsselectorfunction` varchar(255) DEFAULT NULL,
  `useuniversalselectorjsfunction` int(11) DEFAULT '0',
  `useuniversalselectorjsfunction_type` varchar(255) DEFAULT NULL,
  `ignorebydefault` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `formkey` (`formkey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table form_requests
# ------------------------------------------------------------

DROP TABLE IF EXISTS `form_requests`;

CREATE TABLE `form_requests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `requestkey` varchar(40) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `formkey` varchar(40) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `userkey` varchar(40) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `dt_created` datetime NOT NULL,
  `wddx_formdata` longtext,
  `data_used` int(11) NOT NULL,
  `action_type` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table forms
# ------------------------------------------------------------

DROP TABLE IF EXISTS `forms`;

CREATE TABLE `forms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `servicekey` varchar(40) DEFAULT NULL,
  `entrykey` varchar(40) DEFAULT NULL,
  `form_name` varchar(255) DEFAULT NULL,
  `dt_created` datetime DEFAULT NULL,
  `dt_lastmodified` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `query_name` varchar(255) DEFAULT NULL,
  `update_url` varchar(255) NOT NULL,
  `create_url` varchar(255) NOT NULL,
  `css_style` varchar(255) NOT NULL,
  `form_id` varchar(255) NOT NULL,
  `onsubmit` varchar(255) NOT NULL,
  `method` varchar(50) NOT NULL DEFAULT 'POST',
  `columns` int(11) NOT NULL DEFAULT '1',
  `autopickup` int(11) NOT NULL DEFAULT '0',
  `autopickup_functionname` varchar(255) NOT NULL,
  `db_datasource` varchar(120) NOT NULL,
  `db_table` varchar(120) NOT NULL,
  `db_primary` varchar(120) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `entrykey` (`entrykey`),
  KEY `servicekey` (`servicekey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table history
# ------------------------------------------------------------

DROP TABLE IF EXISTS `history`;

CREATE TABLE `history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(40) NOT NULL,
  `createdbyuserkey` varchar(40) NOT NULL,
  `objectkey` varchar(40) NOT NULL,
  `servicekey` varchar(40) NOT NULL,
  `dt_created` timestamp NULL DEFAULT NULL,
  `dt_lastmodified` datetime NOT NULL,
  `subject` varchar(255) NOT NULL,
  `comment` text NOT NULL,
  `item_type` int(11) NOT NULL,
  `projectkey` varchar(40) NOT NULL,
  `dt_created_internally` datetime NOT NULL,
  `categories` varchar(255) DEFAULT NULL,
  `linked_servicekey` varchar(40) NOT NULL,
  `linked_objectkey` varchar(255) NOT NULL,
  `hash_unique` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `objectkey` (`objectkey`,`servicekey`),
  KEY `hash_unique` (`hash_unique`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table im_alerts_2send
# ------------------------------------------------------------

DROP TABLE IF EXISTS `im_alerts_2send`;

CREATE TABLE `im_alerts_2send` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `msg` text NOT NULL,
  `recipient` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table importfieldmappings
# ------------------------------------------------------------

DROP TABLE IF EXISTS `importfieldmappings`;

CREATE TABLE `importfieldmappings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `jobkey` varchar(40) NOT NULL,
  `ibxfield_md5` varchar(100) DEFAULT NULL,
  `importfieldname` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table importjobs
# ------------------------------------------------------------

DROP TABLE IF EXISTS `importjobs`;

CREATE TABLE `importjobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(40) NOT NULL,
  `userkey` varchar(40) NOT NULL,
  `servicekey` varchar(40) NOT NULL,
  `dt_created` datetime NOT NULL,
  `table_wddx` longtext NOT NULL,
  `datatype` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table install_names
# ------------------------------------------------------------

DROP TABLE IF EXISTS `install_names`;

CREATE TABLE `install_names` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `install_name` varchar(255) NOT NULL DEFAULT '',
  `dt_lastmodified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `program_id` varchar(255) NOT NULL DEFAULT '',
  `userkey` varchar(50) NOT NULL DEFAULT '',
  `sessionkey` varchar(255) NOT NULL DEFAULT '',
  `version` varchar(255) NOT NULL DEFAULT '',
  `ip` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `userkey` (`userkey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table invoices
# ------------------------------------------------------------

DROP TABLE IF EXISTS `invoices`;

CREATE TABLE `invoices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `invoicenumber` varchar(50) NOT NULL DEFAULT '0',
  `companykey` varchar(50) NOT NULL DEFAULT '',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `bookedservices` text NOT NULL,
  `entrykey` varchar(50) NOT NULL DEFAULT '',
  `paid` int(11) NOT NULL DEFAULT '0',
  `internalinvoicenumber` int(11) NOT NULL DEFAULT '0',
  `invoiceyear` int(11) NOT NULL DEFAULT '2003',
  `invoicetotalsum` float NOT NULL DEFAULT '0',
  `invoicevatpercent` int(11) NOT NULL DEFAULT '20',
  `invoiceuidenabled` int(11) NOT NULL DEFAULT '0',
  `pdffile` longtext NOT NULL,
  `htmlcontent` longtext NOT NULL,
  `dt_due` datetime DEFAULT NULL,
  `comment` varchar(255) NOT NULL DEFAULT '',
  `dt_paid` datetime DEFAULT NULL,
  `paymethod` varchar(255) NOT NULL DEFAULT '',
  `invoicetotalsum_gross` int(11) NOT NULL DEFAULT '0',
  `dt_dunning1` datetime DEFAULT NULL,
  `dunninglevel` int(11) NOT NULL DEFAULT '0',
  `dt_dunning2` datetime DEFAULT NULL,
  `customerdisabled` int(11) NOT NULL DEFAULT '0',
  `invoicetype` int(11) NOT NULL DEFAULT '0',
  `createdbytype` int(11) NOT NULL DEFAULT '0',
  `cancelled` int(11) NOT NULL DEFAULT '0',
  `reason_cancelled` varchar(255) NOT NULL DEFAULT '',
  `cancelledbyuserkey` varchar(50) NOT NULL DEFAULT '',
  `dt_cancelled` datetime DEFAULT NULL,
  `invoicetotalsum_provision` int(11) NOT NULL DEFAULT '0',
  `currency` varchar(10) NOT NULL DEFAULT 'EUR',
  PRIMARY KEY (`id`),
  KEY `companykey` (`companykey`,`paid`,`dunninglevel`,`cancelled`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table langdata
# ------------------------------------------------------------

DROP TABLE IF EXISTS `langdata`;

CREATE TABLE `langdata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `langno` int(11) NOT NULL,
  `entryid` varchar(255) NOT NULL,
  `entryvalue` text NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `langno_2` (`langno`,`entryid`),
  KEY `langno` (`langno`),
  KEY `entryid` (`entryid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table licencehistory
# ------------------------------------------------------------

DROP TABLE IF EXISTS `licencehistory`;

CREATE TABLE `licencehistory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `companykey` varchar(50) NOT NULL DEFAULT '',
  `comment` text NOT NULL,
  `addseats` int(11) NOT NULL DEFAULT '0',
  `createdbyuserkey` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table licencing
# ------------------------------------------------------------

DROP TABLE IF EXISTS `licencing`;

CREATE TABLE `licencing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `companykey` varchar(50) NOT NULL DEFAULT '',
  `productkey` varchar(50) NOT NULL DEFAULT '',
  `availableseats` int(11) NOT NULL DEFAULT '0',
  `inuse` int(11) NOT NULL DEFAULT '0',
  `totalseats` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `companykey` (`companykey`,`productkey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table loginstat
# ------------------------------------------------------------

DROP TABLE IF EXISTS `loginstat`;

CREATE TABLE `loginstat` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userkey` varchar(50) NOT NULL DEFAULT '',
  `loginsection` int(11) NOT NULL DEFAULT '0',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ip` varchar(50) NOT NULL DEFAULT '',
  `urltoken` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `dt_created` (`dt_created`),
  KEY `userkey` (`userkey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table mailprofiles
# ------------------------------------------------------------

DROP TABLE IF EXISTS `mailprofiles`;

CREATE TABLE `mailprofiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(50) NOT NULL DEFAULT '',
  `userkey` varchar(50) NOT NULL DEFAULT '',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `createdbyuserkey` varchar(50) NOT NULL DEFAULT '',
  `accesstype` int(11) NOT NULL DEFAULT '0',
  `imaphost` varchar(255) NOT NULL DEFAULT '',
  `imapusername` varchar(255) NOT NULL DEFAULT '',
  `imappassword` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `userkey` (`userkey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table meetingmembers
# ------------------------------------------------------------

DROP TABLE IF EXISTS `meetingmembers`;

CREATE TABLE `meetingmembers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `eventkey` varchar(36) NOT NULL DEFAULT '',
  `parameter` varchar(255) NOT NULL DEFAULT '',
  `status` int(11) NOT NULL DEFAULT '0',
  `type` int(11) NOT NULL DEFAULT '0',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `dt_answered` datetime DEFAULT NULL,
  `comment` text,
  `createdbyuserkey` varchar(40) NOT NULL DEFAULT '',
  `entrykey` varchar(40) NOT NULL,
  `sendinvitation` int(11) NOT NULL DEFAULT '1',
  `temporary` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `ind_meetingmember` (`eventkey`,`parameter`,`type`,`temporary`),
  KEY `eventkey` (`eventkey`),
  KEY `type` (`type`,`status`,`eventkey`),
  KEY `eventkey_2` (`eventkey`),
  KEY `parameter` (`parameter`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table nace_codes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `nace_codes`;

CREATE TABLE `nace_codes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(40) DEFAULT NULL,
  `industry_name` varchar(255) NOT NULL,
  `lang` int(11) NOT NULL DEFAULT '0',
  `entrykey` varchar(40) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table newmailalerts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `newmailalerts`;

CREATE TABLE `newmailalerts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL DEFAULT '0',
  `accountid` int(11) NOT NULL DEFAULT '0',
  `type` int(11) DEFAULT NULL,
  `maxperday` int(11) DEFAULT NULL,
  `donetoday` int(11) DEFAULT NULL,
  `excludeadr` mediumtext,
  `enabled` int(11) DEFAULT NULL,
  `emailaddress` varchar(150) DEFAULT NULL,
  `privatemessagesonly` int(11) NOT NULL DEFAULT '0',
  `nonightalerts` int(11) NOT NULL DEFAULT '0',
  `tmp` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table oldversions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `oldversions`;

CREATE TABLE `oldversions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(40) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `filekey` varchar(40) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `dt_created` datetime NOT NULL,
  `createdbyuserkey` varchar(40) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `comment` text NOT NULL,
  `version` varchar(255) NOT NULL,
  `compressed` int(11) NOT NULL DEFAULT '0',
  `oldproperties` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `entrykey` (`entrykey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table outlooksettings
# ------------------------------------------------------------

DROP TABLE IF EXISTS `outlooksettings`;

CREATE TABLE `outlooksettings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL DEFAULT '0',
  `username` varchar(255) NOT NULL DEFAULT '',
  `datatype` int(11) NOT NULL DEFAULT '0',
  `filedata` longtext NOT NULL,
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `dt_lastrequested` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `program_id` varchar(255) NOT NULL DEFAULT '',
  `userkey` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table outlooksync
# ------------------------------------------------------------

DROP TABLE IF EXISTS `outlooksync`;

CREATE TABLE `outlooksync` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cfidcftoken` varchar(255) NOT NULL DEFAULT '',
  `href` varchar(255) NOT NULL DEFAULT '',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `hitcount` int(11) NOT NULL DEFAULT '0',
  `ip` varchar(50) NOT NULL DEFAULT '',
  `referer` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table outlooksync_app
# ------------------------------------------------------------

DROP TABLE IF EXISTS `outlooksync_app`;

CREATE TABLE `outlooksync_app` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `userkey` varchar(36) NOT NULL DEFAULT '',
  `session` longtext NOT NULL,
  `script_name` varchar(255) NOT NULL DEFAULT '',
  `query_string` text NOT NULL,
  `form` longtext NOT NULL,
  `ip` varchar(50) NOT NULL DEFAULT '',
  `exception` int(11) NOT NULL DEFAULT '0',
  `entrykey` varchar(40) NOT NULL DEFAULT '',
  `runtime` int(11) NOT NULL DEFAULT '0',
  `hostname` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table owncontactcards
# ------------------------------------------------------------

DROP TABLE IF EXISTS `owncontactcards`;

CREATE TABLE `owncontactcards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userkey` varchar(40) NOT NULL DEFAULT '',
  `contactkey` varchar(40) NOT NULL DEFAULT '',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `createdbyuserkey` varchar(40) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `ind_userkey` (`userkey`),
  UNIQUE KEY `userkey` (`userkey`,`contactkey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table performedactions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `performedactions`;

CREATE TABLE `performedactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(50) NOT NULL DEFAULT '',
  `servicekey` varchar(50) NOT NULL DEFAULT '',
  `sectionkey` varchar(50) NOT NULL DEFAULT '',
  `objectkey` varchar(50) NOT NULL DEFAULT '',
  `userkey` varchar(50) NOT NULL DEFAULT '',
  `actionname` varchar(50) NOT NULL DEFAULT '',
  `dt_done` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `failed` int(11) NOT NULL DEFAULT '0',
  `additionalinformation` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `objectkey` (`objectkey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table permissions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `permissions`;

CREATE TABLE `permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(50) NOT NULL DEFAULT '',
  `service` varchar(100) NOT NULL DEFAULT '',
  `object` varchar(100) NOT NULL DEFAULT '',
  `item` varchar(50) NOT NULL DEFAULT '',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `entrykey` (`entrykey`),
  KEY `entrykey_2` (`entrykey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table pop3_data
# ------------------------------------------------------------

DROP TABLE IF EXISTS `pop3_data`;

CREATE TABLE `pop3_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL DEFAULT '0',
  `emailadr` varchar(150) NOT NULL DEFAULT '',
  `deletemsgonserver` int(11) NOT NULL DEFAULT '0',
  `pop3server` varchar(250) NOT NULL DEFAULT '',
  `pop3username` varchar(250) NOT NULL DEFAULT '',
  `pop3password` varchar(250) NOT NULL DEFAULT '',
  `prim_email` int(11) NOT NULL DEFAULT '0',
  `docheck` int(11) NOT NULL DEFAULT '0',
  `confirmed` int(11) NOT NULL DEFAULT '0',
  `confirmcode` varchar(250) NOT NULL DEFAULT '',
  `lastuidl` varchar(250) NOT NULL DEFAULT '',
  `lasterror` int(11) NOT NULL DEFAULT '0',
  `sendawaymsg` int(11) NOT NULL DEFAULT '0',
  `lastcheck` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `errorcount` int(11) NOT NULL DEFAULT '0',
  `awaymsg` text,
  `displayname` varchar(250) NOT NULL DEFAULT '',
  `origin` int(11) NOT NULL DEFAULT '1',
  `autocheckeachhours` int(11) NOT NULL DEFAULT '0',
  `signature` text,
  `autocheckminutes` int(11) NOT NULL DEFAULT '0',
  `markcolor` varchar(50) NOT NULL DEFAULT '',
  `destinationfolder` varchar(250) NOT NULL DEFAULT 'INBOX',
  `hosttype` int(11) NOT NULL DEFAULT '0',
  `enabled` int(11) NOT NULL DEFAULT '0',
  `entrykey` varchar(50) NOT NULL DEFAULT '',
  `userkey` varchar(50) NOT NULL DEFAULT '',
  `port` int(11) NOT NULL DEFAULT '0',
  `usessl` int(11) NOT NULL DEFAULT '0',
  `oldpassword` varchar(255) NOT NULL DEFAULT '',
  `folderseparator` varchar(3) NOT NULL DEFAULT '.',
  PRIMARY KEY (`id`),
  KEY `ind_userid_emailadr` (`userid`,`emailadr`),
  KEY `userkey` (`userkey`,`emailadr`),
  KEY `userkey_2` (`userkey`),
  KEY `userkey_3` (`userkey`,`confirmed`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table productassignment_history
# ------------------------------------------------------------

DROP TABLE IF EXISTS `productassignment_history`;

CREATE TABLE `productassignment_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(40) NOT NULL,
  `dt_created` datetime NOT NULL,
  `createdbyuserkey` varchar(40) NOT NULL,
  `contactkey` varchar(40) NOT NULL,
  `productkey` varchar(40) NOT NULL,
  `quantity` int(11) NOT NULL,
  `comment` varchar(255) NOT NULL,
  `purchase_price` float NOT NULL,
  `retail_price` float NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table productgroups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `productgroups`;

CREATE TABLE `productgroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(40) NOT NULL,
  `companykey` varchar(40) NOT NULL,
  `productgroupname` varchar(255) NOT NULL,
  `dt_created` datetime NOT NULL,
  `createdbyuserkey` varchar(40) NOT NULL,
  `description` varchar(255) NOT NULL,
  `parentproductgroupentrykey` varchar(40) DEFAULT NULL,
  `category1` varchar(255) DEFAULT NULL,
  `category2` varchar(255) DEFAULT NULL,
  `lasteditedbyuserkey` varchar(40) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table productquantity
# ------------------------------------------------------------

DROP TABLE IF EXISTS `productquantity`;

CREATE TABLE `productquantity` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(40) NOT NULL,
  `userkey` varchar(40) NOT NULL,
  `productkey` varchar(40) NOT NULL,
  `quantity` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table products
# ------------------------------------------------------------

DROP TABLE IF EXISTS `products`;

CREATE TABLE `products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(40) NOT NULL,
  `companykey` varchar(40) NOT NULL,
  `dt_created` datetime NOT NULL,
  `createdbyuserkey` varchar(40) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `serialnumber` varchar(255) NOT NULL,
  `internalid` varchar(255) NOT NULL,
  `productgroupkey` varchar(40) NOT NULL,
  `lasteditedbyuserkey` varchar(40) NOT NULL,
  `productURL` varchar(255) DEFAULT NULL,
  `category1` varchar(255) DEFAULT NULL,
  `category2` varchar(255) DEFAULT NULL,
  `enabled` int(11) NOT NULL DEFAULT '1',
  `purchase_price` float NOT NULL,
  `retail_price` float NOT NULL,
  `vendorpartnumber` varchar(120) NOT NULL,
  `partnumber` varchar(120) NOT NULL,
  `defaultsupporttermindays` int(11) NOT NULL,
  `individualhandling` int(11) NOT NULL,
  `weight` int(11) NOT NULL,
  `productname` varchar(255) DEFAULT NULL,
  `itemindex` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `companykey` (`companykey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table productsassignedtocontact
# ------------------------------------------------------------

DROP TABLE IF EXISTS `productsassignedtocontact`;

CREATE TABLE `productsassignedtocontact` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(40) NOT NULL,
  `contactkey` varchar(40) NOT NULL,
  `projectkey` varchar(40) NOT NULL,
  `serialnumber` varchar(255) NOT NULL,
  `dt_created` datetime NOT NULL,
  `dt_added` datetime NOT NULL,
  `createdbyuserkey` varchar(40) NOT NULL,
  `supportstarts` datetime DEFAULT NULL,
  `supportends` datetime DEFAULT NULL,
  `comment` varchar(255) NOT NULL,
  `quantity` int(11) NOT NULL,
  `purchase_price` float NOT NULL,
  `retail_price` float NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table project_members
# ------------------------------------------------------------

DROP TABLE IF EXISTS `project_members`;

CREATE TABLE `project_members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `userkey` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table projects
# ------------------------------------------------------------

DROP TABLE IF EXISTS `projects`;

CREATE TABLE `projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `status` int(11) NOT NULL DEFAULT '0',
  `dt_begin` datetime DEFAULT NULL,
  `dt_end` datetime DEFAULT NULL,
  `parentprojectkey` varchar(50) NOT NULL DEFAULT '',
  `dt_created` datetime DEFAULT NULL,
  `priority` int(11) NOT NULL DEFAULT '0',
  `userkey` varchar(50) NOT NULL DEFAULT '',
  `projectleaderuserkey` varchar(50) NOT NULL DEFAULT '',
  `budget` int(11) NOT NULL DEFAULT '0',
  `percentdone` int(11) NOT NULL DEFAULT '0',
  `dt_due` datetime DEFAULT NULL,
  `userkeyleader` varchar(50) NOT NULL DEFAULT '',
  `entrykey` varchar(50) NOT NULL DEFAULT '',
  `categories` varchar(255) NOT NULL DEFAULT '',
  `dt_closing` datetime DEFAULT NULL,
  `probability` int(11) NOT NULL DEFAULT '0',
  `project_type` int(11) NOT NULL DEFAULT '0',
  `currency` varchar(10) NOT NULL DEFAULT 'EUR',
  `stage` int(11) NOT NULL DEFAULT '0',
  `sales` int(11) NOT NULL DEFAULT '0',
  `dt_lastmodified` datetime NOT NULL,
  `lead_source_id` varchar(255) DEFAULT NULL,
  `createdbyuserkey` varchar(40) NOT NULL,
  `contactkey` varchar(40) NOT NULL,
  `lead_source` int(11) NOT NULL DEFAULT '-1',
  `business_type` int(11) NOT NULL DEFAULT '0',
  `dt_closed` datetime DEFAULT NULL,
  `closed` int(11) NOT NULL DEFAULT '0',
  `closedbyuserkey` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `entrykey` (`entrykey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table projects_shareddata
# ------------------------------------------------------------

DROP TABLE IF EXISTS `projects_shareddata`;

CREATE TABLE `projects_shareddata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `projectkey` varchar(50) NOT NULL DEFAULT '',
  `workgroupkey` varchar(50) NOT NULL DEFAULT '',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table promocodes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `promocodes`;

CREATE TABLE `promocodes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `resellerkey` varchar(36) NOT NULL DEFAULT '',
  `code` int(11) NOT NULL DEFAULT '0',
  `codevalue` float NOT NULL DEFAULT '3',
  `dt_validuntil` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `dt_used` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `companykey` varchar(50) NOT NULL DEFAULT '',
  `used` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table promocodeusages
# ------------------------------------------------------------

DROP TABLE IF EXISTS `promocodeusages`;

CREATE TABLE `promocodeusages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `promocode` varchar(20) NOT NULL DEFAULT '',
  `dt_used` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `companykey` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table publicshares
# ------------------------------------------------------------

DROP TABLE IF EXISTS `publicshares`;

CREATE TABLE `publicshares` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `directorykey` varchar(40) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `userkey` varchar(40) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `type` int(11) NOT NULL DEFAULT '0',
  `password` varchar(255) NOT NULL,
  `dt_valid_until` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `directorykey` (`directorykey`),
  KEY `userkey` (`userkey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table publicshares_traffic
# ------------------------------------------------------------

DROP TABLE IF EXISTS `publicshares_traffic`;

CREATE TABLE `publicshares_traffic` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userkey` varchar(40) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `query_string` varchar(255) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `dt_created` datetime NOT NULL,
  `script_name` varchar(255) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `ip` varchar(50) NOT NULL,
  `http_referer` varchar(255) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table redata
# ------------------------------------------------------------

DROP TABLE IF EXISTS `redata`;

CREATE TABLE `redata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(36) NOT NULL DEFAULT '',
  `firstname` varchar(255) NOT NULL DEFAULT '',
  `surname` varchar(255) NOT NULL DEFAULT '',
  `company` varchar(255) NOT NULL DEFAULT '',
  `department` varchar(255) NOT NULL DEFAULT '',
  `aposition` varchar(255) NOT NULL DEFAULT '',
  `birthday` datetime DEFAULT NULL,
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `b_street` varchar(255) NOT NULL DEFAULT '',
  `b_zipcode` varchar(50) NOT NULL DEFAULT '',
  `b_city` varchar(255) NOT NULL DEFAULT '',
  `b_telephone` varchar(255) NOT NULL DEFAULT '',
  `b_fax` varchar(255) NOT NULL DEFAULT '',
  `b_country` varchar(255) NOT NULL DEFAULT '',
  `b_mobile` varchar(255) NOT NULL DEFAULT '',
  `b_url` varchar(255) NOT NULL DEFAULT '',
  `email_adr` text NOT NULL,
  `p_city` varchar(255) NOT NULL DEFAULT '',
  `p_street` varchar(255) NOT NULL DEFAULT '',
  `p_zipcode` varchar(255) NOT NULL DEFAULT '',
  `p_country` varchar(255) NOT NULL DEFAULT '',
  `p_telephone` varchar(255) NOT NULL DEFAULT '',
  `p_fax` varchar(255) NOT NULL DEFAULT '',
  `p_iptelephone` varchar(255) NOT NULL DEFAULT '',
  `p_mobile` varchar(255) NOT NULL DEFAULT '',
  `p_url` varchar(255) NOT NULL DEFAULT '',
  `notice` text NOT NULL,
  `email_prim` varchar(255) NOT NULL DEFAULT '',
  `username` varchar(255) NOT NULL DEFAULT '',
  `url` varchar(255) NOT NULL DEFAULT '',
  `nickname` varchar(255) NOT NULL DEFAULT '',
  `icqnumber` varchar(50) NOT NULL DEFAULT '',
  `sex` int(11) NOT NULL DEFAULT '-1',
  `title` varchar(50) NOT NULL DEFAULT '',
  `skypeusername` varchar(150) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `entrykey` (`entrykey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table refererdata
# ------------------------------------------------------------

DROP TABLE IF EXISTS `refererdata`;

CREATE TABLE `refererdata` (
  `id` int(11) DEFAULT NULL,
  `referer` varchar(500) DEFAULT NULL,
  `urltoken` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table registrationblacklist
# ------------------------------------------------------------

DROP TABLE IF EXISTS `registrationblacklist`;

CREATE TABLE `registrationblacklist` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `emailadr` varchar(255) NOT NULL DEFAULT '',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `reason` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `emailadr` (`emailadr`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table reminderalerts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `reminderalerts`;

CREATE TABLE `reminderalerts` (
  `userid` int(11) NOT NULL AUTO_INCREMENT,
  `dt_insert` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `newmailcount` int(11) NOT NULL DEFAULT '1',
  `lastfrom` varchar(250) NOT NULL DEFAULT '',
  `lastsubject` varchar(250) NOT NULL DEFAULT '',
  PRIMARY KEY (`userid`),
  KEY `userid` (`userid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table remoteedit
# ------------------------------------------------------------

DROP TABLE IF EXISTS `remoteedit`;

CREATE TABLE `remoteedit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(50) NOT NULL DEFAULT '',
  `userkey` varchar(50) NOT NULL DEFAULT '',
  `objectkey` varchar(50) NOT NULL DEFAULT '',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `dt_opened` datetime DEFAULT NULL,
  `languageID` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `objectkey` (`objectkey`),
  KEY `entrykey` (`entrykey`),
  KEY `userkey` (`userkey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table reseller
# ------------------------------------------------------------

DROP TABLE IF EXISTS `reseller`;

CREATE TABLE `reseller` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `entrykey` varchar(50) NOT NULL DEFAULT '',
  `country` varchar(250) NOT NULL DEFAULT '',
  `companyname` varchar(250) NOT NULL DEFAULT '',
  `parentid` int(11) NOT NULL DEFAULT '0',
  `parentkey` varchar(50) NOT NULL DEFAULT '',
  `delegaterights` int(11) NOT NULL DEFAULT '0',
  `userid` int(11) NOT NULL DEFAULT '0',
  `includefooter` varchar(250) NOT NULL DEFAULT '',
  `street` varchar(255) NOT NULL DEFAULT '',
  `zipcode` varchar(50) NOT NULL DEFAULT '',
  `city` varchar(255) NOT NULL DEFAULT '',
  `telephone` varchar(255) NOT NULL DEFAULT '',
  `emailadr` varchar(255) NOT NULL DEFAULT '',
  `domains` varchar(255) NOT NULL DEFAULT 'inbox.cc',
  `standardpercents` int(11) NOT NULL DEFAULT '30',
  `affiliatecode` varchar(15) NOT NULL DEFAULT '',
  `logo` varchar(255) NOT NULL DEFAULT '',
  `customercontact` text NOT NULL,
  `description` varchar(255) NOT NULL DEFAULT '',
  `partnertype` int(11) NOT NULL DEFAULT '0',
  `assignedzipcodes` text NOT NULL,
  `bankdetails` text NOT NULL,
  `companykey` varchar(50) NOT NULL DEFAULT '',
  `assignedareas` varchar(255) NOT NULL DEFAULT '',
  `issystempartner` int(11) NOT NULL DEFAULT '0',
  `isdistributor` int(11) NOT NULL DEFAULT '0',
  `isprojectpartner` int(11) NOT NULL DEFAULT '0',
  `distributorproductkey` varchar(50) NOT NULL DEFAULT '',
  `logopath` varchar(255) NOT NULL DEFAULT '',
  `contractingparty` int(11) NOT NULL DEFAULT '0',
  `isdealer` int(11) NOT NULL DEFAULT '0',
  `style` varchar(50) NOT NULL DEFAULT '',
  `smalllogopath` varchar(255) NOT NULL DEFAULT '',
  `default_settlement_type` int(11) NOT NULL DEFAULT '0',
  `allow_modify_settlement_type` int(11) NOT NULL DEFAULT '0',
  `homepage` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `parentkey` (`parentkey`),
  KEY `parentkey_2` (`parentkey`,`contractingparty`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table resellerusers
# ------------------------------------------------------------

DROP TABLE IF EXISTS `resellerusers`;

CREATE TABLE `resellerusers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resellerkey` varchar(40) NOT NULL DEFAULT '',
  `userkey` varchar(50) NOT NULL DEFAULT '0',
  `permissions` varchar(255) NOT NULL DEFAULT '',
  `contacttype` varchar(255) NOT NULL DEFAULT '0',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `createdbyuserkey` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `resellerkey` (`resellerkey`,`userkey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table resources
# ------------------------------------------------------------

DROP TABLE IF EXISTS `resources`;

CREATE TABLE `resources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(50) NOT NULL DEFAULT '',
  `companykey` varchar(50) NOT NULL DEFAULT '',
  `createdbyuserkey` varchar(50) NOT NULL DEFAULT '',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `title` varchar(255) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT '',
  `exclusive` int(11) NOT NULL DEFAULT '1',
  `workgroupkeys` varchar(255) NOT NULL DEFAULT '',
  `location` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table restrictlogins
# ------------------------------------------------------------

DROP TABLE IF EXISTS `restrictlogins`;

CREATE TABLE `restrictlogins` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `restrictiontype` int(11) DEFAULT NULL,
  `restrictionvalue` varchar(500) DEFAULT NULL,
  `active` int(11) DEFAULT NULL,
  `createdbyuserkey` varchar(36) DEFAULT NULL,
  `dt_created` datetime DEFAULT NULL,
  `direction` int(11) DEFAULT NULL,
  `rolekey` varchar(36) DEFAULT NULL,
  `cursize` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table rolepermissions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `rolepermissions`;

CREATE TABLE `rolepermissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `workgroupkey` varchar(50) NOT NULL DEFAULT '',
  `rolekey` varchar(50) NOT NULL DEFAULT '',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `servicekey` varchar(50) NOT NULL DEFAULT '',
  `allowedactions` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table roles
# ------------------------------------------------------------

DROP TABLE IF EXISTS `roles`;

CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(50) NOT NULL DEFAULT '',
  `rolename` varchar(250) NOT NULL DEFAULT '',
  `description` varchar(250) NOT NULL DEFAULT '',
  `workgroupkey` varchar(50) NOT NULL DEFAULT '',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `createdbyuserkey` varchar(50) NOT NULL DEFAULT '',
  `active` int(11) NOT NULL DEFAULT '1',
  `standardtype` int(11) NOT NULL DEFAULT '0',
  `standardallowedactions` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `entrykey` (`entrykey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table salesprojects
# ------------------------------------------------------------

DROP TABLE IF EXISTS `salesprojects`;

CREATE TABLE `salesprojects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(40) NOT NULL,
  `companykey` varchar(40) DEFAULT NULL,
  `userkey` varchar(40) DEFAULT NULL,
  `contactkey` varchar(40) NOT NULL,
  `dt_created` datetime NOT NULL,
  `comment` text NOT NULL,
  `offer_made` int(11) NOT NULL DEFAULT '0',
  `dt_offer_made` datetime DEFAULT NULL,
  `project_started` int(11) NOT NULL DEFAULT '0',
  `dt_project_start` datetime DEFAULT NULL,
  `dt_project_end` datetime DEFAULT NULL,
  `stage` int(11) DEFAULT '0',
  `sales` int(11) NOT NULL DEFAULT '0',
  `probability` int(11) NOT NULL DEFAULT '0',
  `createdbyuserkey` varchar(40) NOT NULL,
  `currency` varchar(5) NOT NULL,
  `title` varchar(255) NOT NULL,
  `project_result` int(11) NOT NULL DEFAULT '0',
  `lead_source` int(11) NOT NULL,
  `project_type` int(11) NOT NULL,
  `lead_source_id` varchar(255) DEFAULT NULL,
  `dt_closing` datetime DEFAULT NULL,
  `dt_lastmodified` datetime NOT NULL,
  `lastmodifiedbyuserkey` varchar(40) DEFAULT NULL,
  `responsibleuserkey` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `entrykey` (`entrykey`),
  KEY `contactkey` (`contactkey`),
  KEY `companykey` (`companykey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table salesprojects_assigned_contacts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `salesprojects_assigned_contacts`;

CREATE TABLE `salesprojects_assigned_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(40) NOT NULL,
  `createdbyuserkey` varchar(40) NOT NULL,
  `role_type` int(11) NOT NULL,
  `contactkey` varchar(40) NOT NULL,
  `comment` varchar(255) NOT NULL,
  `dt_created` datetime NOT NULL,
  `salesprojectentrykey` varchar(40) NOT NULL,
  `internal_user` int(11) NOT NULL DEFAULT '0',
  `contact_type` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table salesprojects_trend_history
# ------------------------------------------------------------

DROP TABLE IF EXISTS `salesprojects_trend_history`;

CREATE TABLE `salesprojects_trend_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(40) NOT NULL,
  `salesprojectentrykey` varchar(40) NOT NULL,
  `dt_created` datetime NOT NULL,
  `probability` int(11) NOT NULL,
  `sales` int(11) NOT NULL,
  `dt_project_start` datetime DEFAULT NULL,
  `createdbyuserkey` varchar(40) NOT NULL,
  `stage` int(11) NOT NULL DEFAULT '0',
  `dt_closing` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `salesprojectentrykey` (`salesprojectentrykey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table savedtaskviews
# ------------------------------------------------------------

DROP TABLE IF EXISTS `savedtaskviews`;

CREATE TABLE `savedtaskviews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(50) NOT NULL DEFAULT '',
  `userkey` varchar(50) NOT NULL DEFAULT '',
  `href` varchar(255) NOT NULL DEFAULT '',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `viewname` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table scenarioseen
# ------------------------------------------------------------

DROP TABLE IF EXISTS `scenarioseen`;

CREATE TABLE `scenarioseen` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL DEFAULT '0',
  `pagesection` varchar(70) NOT NULL DEFAULT '',
  `pagename` varchar(100) NOT NULL DEFAULT '',
  `timesseen` int(11) NOT NULL DEFAULT '0',
  `firstvisit` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `lastvisit` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `expires` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `param1` varchar(10) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`),
  KEY `ind_seen` (`userid`,`pagesection`,`pagename`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table scratchpad
# ------------------------------------------------------------

DROP TABLE IF EXISTS `scratchpad`;

CREATE TABLE `scratchpad` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL DEFAULT '0',
  `workgroup_id` int(11) NOT NULL DEFAULT '0',
  `subject` varchar(255) NOT NULL DEFAULT '',
  `serviceid` int(11) NOT NULL DEFAULT '0',
  `itemtype` int(11) NOT NULL DEFAULT '0',
  `notice` text NOT NULL,
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `dt_lastmodified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `projectid` int(11) NOT NULL DEFAULT '0',
  `userkey` varchar(40) NOT NULL DEFAULT '',
  `entrykey` varchar(40) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `userkey` (`userkey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table scratchpad_outlook_id
# ------------------------------------------------------------

DROP TABLE IF EXISTS `scratchpad_outlook_id`;

CREATE TABLE `scratchpad_outlook_id` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `outlook_id` varchar(255) NOT NULL DEFAULT '',
  `program_id` varchar(255) NOT NULL DEFAULT '',
  `lastupdate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `scratchpad_entrykey` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table secretarydefinitions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `secretarydefinitions`;

CREATE TABLE `secretarydefinitions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(50) NOT NULL DEFAULT '',
  `companykey` varchar(50) NOT NULL DEFAULT '',
  `userkey` varchar(50) NOT NULL DEFAULT '',
  `secretarykey` varchar(50) NOT NULL DEFAULT '',
  `dt_created` datetime DEFAULT NULL,
  `createdbyuserkey` varchar(50) NOT NULL DEFAULT '',
  `permission` varchar(50) NOT NULL DEFAULT 'deletecreatedbysecretary',
  PRIMARY KEY (`id`),
  UNIQUE KEY `userkey` (`userkey`,`secretarykey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table securityroles
# ------------------------------------------------------------

DROP TABLE IF EXISTS `securityroles`;

CREATE TABLE `securityroles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rolename` varchar(255) NOT NULL DEFAULT '',
  `entrykey` varchar(50) NOT NULL DEFAULT '',
  `companykey` varchar(50) NOT NULL DEFAULT '',
  `dt_created` datetime DEFAULT NULL,
  `createdbyuserkey` varchar(50) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT '',
  `allow_pda_login` int(11) NOT NULL DEFAULT '1',
  `allow_wap_login` int(11) NOT NULL DEFAULT '1',
  `allow_outlooksync` int(11) NOT NULL DEFAULT '1',
  `protocol_depth` int(11) NOT NULL DEFAULT '1',
  `allow_ftp_access` int(11) NOT NULL DEFAULT '1',
  `allow_mailaccessdata_access` int(11) NOT NULL DEFAULT '1',
  `allow_www_ssl_only` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table serverlog
# ------------------------------------------------------------

DROP TABLE IF EXISTS `serverlog`;

CREATE TABLE `serverlog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `AvgReqTime` int(11) NOT NULL DEFAULT '0',
  `DBHits` int(11) NOT NULL DEFAULT '0',
  `PageHits` int(11) NOT NULL DEFAULT '0',
  `ReqQueued` int(11) NOT NULL DEFAULT '0',
  `ReqRunning` int(11) NOT NULL DEFAULT '0',
  `ReqTimedOut` int(11) NOT NULL DEFAULT '0',
  `AvgQueueTime` int(11) NOT NULL DEFAULT '0',
  `BytesIn` bigint(20) NOT NULL DEFAULT '0',
  `BytesOut` bigint(20) NOT NULL DEFAULT '0',
  `AvgDBTime` int(11) NOT NULL DEFAULT '0',
  `dt_created` datetime DEFAULT NULL,
  `freeMemory` int(11) NOT NULL DEFAULT '0',
  `totalMemory` int(11) NOT NULL DEFAULT '0',
  `maxMemory` int(11) NOT NULL DEFAULT '0',
  `hostname` varchar(50) COLLATE latin1_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;



# Dump of table servicerequests
# ------------------------------------------------------------

DROP TABLE IF EXISTS `servicerequests`;

CREATE TABLE `servicerequests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `companykey` varchar(40) NOT NULL,
  `entrykey` varchar(40) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '0',
  `title` varchar(255) NOT NULL,
  `comment` text NOT NULL,
  `dt_created` datetime NOT NULL,
  `createdbyuserkey` varchar(40) NOT NULL,
  `closedbyuserkey` varchar(40) NOT NULL,
  `priority` int(11) NOT NULL DEFAULT '3',
  `ticketno` int(11) NOT NULL,
  `externalticketno` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table sessionkeys
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sessionkeys`;

CREATE TABLE `sessionkeys` (
  `id` varchar(50) NOT NULL DEFAULT '',
  `dt_expires` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `userid` int(11) NOT NULL DEFAULT '0',
  `dt_lastcontact` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `userkey` varchar(50) NOT NULL DEFAULT '',
  `ip` varchar(50) NOT NULL DEFAULT '',
  `appname` varchar(155) NOT NULL DEFAULT '',
  `struct_securitycontext` text,
  `struct_usersettings` text,
  `hitcount` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`,`userkey`),
  UNIQUE KEY `id` (`id`),
  KEY `userkey` (`userkey`),
  KEY `appname` (`appname`,`id`,`ip`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table shareddata
# ------------------------------------------------------------

DROP TABLE IF EXISTS `shareddata`;

CREATE TABLE `shareddata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(36) NOT NULL DEFAULT '',
  `addressbookkey` varchar(36) NOT NULL DEFAULT '',
  `workgroupkey` varchar(36) NOT NULL DEFAULT '',
  `createdbyuserkey` varchar(36) NOT NULL DEFAULT '',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `addressbookkey` (`addressbookkey`,`workgroupkey`),
  KEY `workgroupkey` (`workgroupkey`),
  KEY `addressbookkey_2` (`addressbookkey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table signup_saved_data
# ------------------------------------------------------------

DROP TABLE IF EXISTS `signup_saved_data`;

CREATE TABLE `signup_saved_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(40) NOT NULL DEFAULT '',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `firstname` varchar(255) NOT NULL DEFAULT '',
  `surname` varchar(255) NOT NULL DEFAULT '',
  `city` varchar(255) NOT NULL DEFAULT '',
  `zipcode` varchar(255) NOT NULL DEFAULT '',
  `street` varchar(255) NOT NULL DEFAULT '',
  `telnr` varchar(255) NOT NULL DEFAULT '',
  `email` varchar(255) NOT NULL DEFAULT '',
  `resellerkey` varchar(40) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table storagefiles
# ------------------------------------------------------------

DROP TABLE IF EXISTS `storagefiles`;

CREATE TABLE `storagefiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(40) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `userkey` varchar(40) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `filename` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `contenttype` varchar(255) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `filesize` bigint(20) NOT NULL,
  `storageunit` int(11) NOT NULL DEFAULT '0',
  `storagepath` varchar(255) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `storagefilename` varchar(255) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `categories` varchar(255) NOT NULL,
  `createdbyuserkey` varchar(40) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `dt_created` datetime NOT NULL,
  `dt_lastmodified` datetime NOT NULL,
  `parentdirectorykey` varchar(40) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `metainformation` text,
  `keywords` text,
  `lasteditedbyuserkey` varchar(40) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `locked` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `storagefilename` (`storagefilename`,`parentdirectorykey`),
  KEY `entrykey` (`entrykey`),
  KEY `filename` (`filename`),
  KEY `dt_created` (`dt_created`),
  KEY `dt_lastmodified` (`dt_lastmodified`),
  KEY `parentdirectorykey` (`parentdirectorykey`),
  KEY `userkey` (`userkey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table switchuserrelations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `switchuserrelations`;

CREATE TABLE `switchuserrelations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dt_created` datetime NOT NULL,
  `createdbyuserkey` varchar(40) NOT NULL,
  `userkey` varchar(40) NOT NULL,
  `otheruserkey` varchar(40) NOT NULL,
  `otherpassword_md5` varchar(100) NOT NULL,
  `comment` varchar(255) NOT NULL,
  `entrykey` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `userkey_2` (`userkey`,`otheruserkey`),
  KEY `userkey` (`userkey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table templates
# ------------------------------------------------------------

DROP TABLE IF EXISTS `templates`;

CREATE TABLE `templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `langno` int(11) NOT NULL,
  `template_name` varchar(255) NOT NULL,
  `dt_created` datetime NOT NULL,
  `html` int(11) NOT NULL,
  `section` varchar(50) NOT NULL,
  `entrykey` varchar(40) NOT NULL,
  `content` text NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `langno` (`langno`,`template_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table thumbnails
# ------------------------------------------------------------

DROP TABLE IF EXISTS `thumbnails`;

CREATE TABLE `thumbnails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `filekey` varchar(40) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `imagedata` longblob NOT NULL,
  `contenttype` varchar(255) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `dt_created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `filekey` (`filekey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table userphotos
# ------------------------------------------------------------

DROP TABLE IF EXISTS `userphotos`;

CREATE TABLE `userphotos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userkey` varchar(50) NOT NULL DEFAULT '',
  `photodata` longtext NOT NULL,
  `type` int(11) NOT NULL DEFAULT '0',
  `contenttype` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `userkey` (`userkey`,`type`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table userpreferences
# ------------------------------------------------------------

DROP TABLE IF EXISTS `userpreferences`;

CREATE TABLE `userpreferences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL DEFAULT '0',
  `entrysection` varchar(70) NOT NULL DEFAULT '',
  `entryname` varchar(155) NOT NULL DEFAULT '',
  `entryvalue1` text NOT NULL,
  `entryvalue2` varchar(255) NOT NULL DEFAULT '',
  `userkey` varchar(50) NOT NULL DEFAULT '',
  `md5_section_entryname` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `a_index_entry` (`entrysection`,`entryname`,`userid`),
  KEY `userid` (`userid`,`md5_section_entryname`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `userid` int(11) NOT NULL DEFAULT '0',
  `plz` varchar(50) NOT NULL DEFAULT '',
  `zipcode` varchar(50) NOT NULL DEFAULT '',
  `city` varchar(255) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `lasttimelogin` datetime DEFAULT NULL,
  `user_level` int(11) NOT NULL DEFAULT '0',
  `birthday` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `sex` int(11) NOT NULL DEFAULT '0',
  `day_start_hour` int(11) NOT NULL DEFAULT '0',
  `day_end_hour` int(11) NOT NULL DEFAULT '0',
  `username` varchar(255) NOT NULL DEFAULT '',
  `surname` varchar(255) NOT NULL DEFAULT '',
  `firstname` varchar(255) NOT NULL DEFAULT '',
  `email` varchar(255) NOT NULL DEFAULT '',
  `pwd` varchar(255) NOT NULL DEFAULT '',
  `address1` varchar(255) NOT NULL DEFAULT '',
  `signature` text,
  `date_subscr` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `allow_login` int(11) NOT NULL DEFAULT '1',
  `mobilenr` varchar(20) NOT NULL DEFAULT '',
  `account_type` int(11) NOT NULL DEFAULT '0',
  `account_checked` int(11) NOT NULL DEFAULT '0',
  `utcdiff` int(11) NOT NULL DEFAULT '0',
  `login_count` int(11) NOT NULL DEFAULT '0',
  `defaultlanguage` int(11) NOT NULL DEFAULT '0',
  `rating` int(11) NOT NULL DEFAULT '0',
  `stylesheet` varchar(50) NOT NULL DEFAULT '',
  `confirmlogout` int(11) NOT NULL DEFAULT '1',
  `daylightsavinghours` int(11) NOT NULL DEFAULT '0',
  `organization` varchar(100) NOT NULL DEFAULT '',
  `entrykey` varchar(40) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `companykey` varchar(50) NOT NULL DEFAULT '5CD14B02-EE6F-13D7-A7DDF2296ACA2C30',
  `activitystatus` int(11) NOT NULL DEFAULT '1',
  `country` varchar(255) NOT NULL DEFAULT '0',
  `reloadpermissions` int(11) NOT NULL DEFAULT '0',
  `smallphotoavaliable` int(11) NOT NULL DEFAULT '0',
  `bigphotoavaliable` int(11) NOT NULL DEFAULT '0',
  `accounttype` varchar(50) NOT NULL DEFAULT 'AD4262D0-98D5-D611-4763153818C89190',
  `productkey` varchar(50) NOT NULL DEFAULT 'AD4262D0-98D5-D611-4763153818C89190',
  `aposition` varchar(255) NOT NULL DEFAULT '',
  `department` varchar(255) NOT NULL DEFAULT '',
  `telephone` varchar(255) NOT NULL DEFAULT '',
  `securityrolekey` varchar(50) NOT NULL DEFAULT '',
  `title` varchar(255) NOT NULL DEFAULT '',
  `charset` varchar(20) NOT NULL DEFAULT 'UTF-8',
  `countryisocode` char(2) NOT NULL DEFAULT 'at',
  `style` varchar(40) NOT NULL DEFAULT '',
  `skypeusername` varchar(150) NOT NULL DEFAULT '',
  PRIMARY KEY (`userid`),
  UNIQUE KEY `entrykey` (`entrykey`),
  KEY `username` (`username`),
  KEY `companykey` (`companykey`),
  KEY `ind_username` (`username`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table users_saved_data
# ------------------------------------------------------------

DROP TABLE IF EXISTS `users_saved_data`;

CREATE TABLE `users_saved_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dt` datetime DEFAULT NULL,
  `userid` int(11) DEFAULT NULL,
  `username` varchar(160) DEFAULT NULL,
  `ip` varchar(50) DEFAULT NULL,
  `firstname` varchar(160) DEFAULT NULL,
  `surname` varchar(160) DEFAULT NULL,
  `plz` varchar(10) DEFAULT NULL,
  `city` varchar(160) DEFAULT NULL,
  `address1` varchar(160) DEFAULT NULL,
  `sex` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table various_crm_settings
# ------------------------------------------------------------

DROP TABLE IF EXISTS `various_crm_settings`;

CREATE TABLE `various_crm_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `companykey` varchar(40) NOT NULL DEFAULT '',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `createdbyuserkey` varchar(40) NOT NULL DEFAULT '',
  `setting_name` varchar(100) NOT NULL DEFAULT '',
  `setting_value` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `companykey` (`companykey`,`setting_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table versions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `versions`;

CREATE TABLE `versions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(40) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `filekey` varchar(40) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `dt_created` datetime NOT NULL,
  `createdbyuserkey` varchar(40) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `description` varchar(255) NOT NULL,
  `compressed` int(11) NOT NULL DEFAULT '0',
  `oldproperties` text NOT NULL,
  `version` int(11) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `filesize` bigint(20) NOT NULL,
  `contenttype` varchar(255) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `filekey` (`filekey`),
  KEY `entrykey` (`entrykey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table workgroup_members
# ------------------------------------------------------------

DROP TABLE IF EXISTS `workgroup_members`;

CREATE TABLE `workgroup_members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(50) NOT NULL DEFAULT '',
  `userkey` varchar(50) NOT NULL DEFAULT '',
  `workgroupkey` varchar(50) NOT NULL DEFAULT '',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `roles` varchar(255) NOT NULL DEFAULT '',
  `createdbyuserkey` varchar(50) NOT NULL DEFAULT '',
  `userid` int(11) NOT NULL DEFAULT '0',
  `group_id` int(11) NOT NULL DEFAULT '0',
  `username` varchar(255) NOT NULL DEFAULT '',
  `notification_cal_email` int(11) NOT NULL DEFAULT '1',
  `notification_cal_sms` int(11) NOT NULL DEFAULT '0',
  `notification_cal_icq` int(11) NOT NULL DEFAULT '0',
  `notification_adrb_email` int(11) NOT NULL DEFAULT '1',
  `permission_level` int(11) NOT NULL DEFAULT '0',
  `tmp` int(11) NOT NULL DEFAULT '0',
  `notification_email_adr` varchar(250) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `entrykey` (`entrykey`),
  KEY `workgroupkey` (`workgroupkey`,`userkey`),
  KEY `userkey` (`userkey`),
  KEY `workgroupkey_2` (`workgroupkey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table workgroups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `workgroups`;

CREATE TABLE `workgroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrykey` varchar(50) NOT NULL DEFAULT '',
  `companykey` varchar(50) NOT NULL DEFAULT '',
  `groupname` varchar(150) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT '',
  `dt_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `parentkey` varchar(50) NOT NULL DEFAULT '',
  `createdbyuserkey` varchar(50) NOT NULL DEFAULT '',
  `administrator` int(11) NOT NULL DEFAULT '0',
  `tmp` int(11) NOT NULL DEFAULT '0',
  `shortname` varchar(12) NOT NULL DEFAULT '',
  `colour` varchar(50) NOT NULL DEFAULT 'white',
  PRIMARY KEY (`id`),
  KEY `entrykey` (`entrykey`),
  KEY `parentkey` (`parentkey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
