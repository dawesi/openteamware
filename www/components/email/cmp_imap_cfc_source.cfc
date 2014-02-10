<cfcomponent>
    <!--- no need to recreate these every time, only using them for static vars and methods --->
    <cfset variables.mimeUtil = createObject("java","javax.mail.internet.MimeUtility")>
    <cfset variables.objFlag = CreateObject("Java", "javax.mail.Flags$Flag")>
    <cfset variables.objRecipientType = CreateObject("Java", "javax.mail.Message$RecipientType")>
    <cfset variables.fProfileItem = createObject("java","javax.mail.UIDFolder$FetchProfileItem")>
    <cfset variables.byteArray = repeatString(" ", 1000).getBytes()>
    <cfset variables.showTextHtmlAttachmentsInline = false>
    <!--- this is set here because I'm too lazy right now to figure
        out how to get it to work properly in the recursive function
        GetFolderStructure() and folderList()
        --->
    <cfset variables.sortOrder = 0>

    <cffunction name="Init" access="public" output="No" returnType="boolean"
        hint="Initialize this component and open a connection.">
        <cfargument name="username" type="string" required="Yes">
        <cfargument name="password" type="string" required="Yes">
        <cfargument name="imapServer" type="string" required="Yes">
        <cfargument name="port" type="numeric" required="No" default="143">
        <cfargument name="timeout" type="numeric" required="No" default="60">

        <!--- store these outside of this object --->
        <cfset session.username = arguments.username>
        <cfset session.password = arguments.password>
        <cfset session.imapServer = trim(arguments.imapServer)>
        <cfset session.imapPort = trim(arguments.port)>
        <cfset session.imapTimeout = trim(arguments.timeout)>
        
        <cfset getConnectedMailStore()>
        <cfreturn session.connection.isConnected()>

    </cffunction>

    <cffunction name="getFolderInfo" access="public" output="No" returntype="Struct"
        hint="Get information about a specific folder.">
        <cfargument name="folder" required="Yes" type="string">
        <cfset var objStore = getConnectedMailStore()>
        <cfset var objFolder = "">
        <Cfset var folderInfo = structNew()>
        <cftry>
            <cfset objFolder = OpenFolder(objStore, arguments.folder)>
            <cfset folderInfo.fullName = objFolder.getFullName()>
            <cfset folderInfo.name = objFolder.getName()>
            <cfset folderInfo.type = objFolder.getType()>
            <cfif folderInfo.type eq objFolder.HOLDS_FOLDERS>
                <cfset folderInfo.messageCount = 0>
                <cfset folderInfo.deletedMessageCount = 0>
                <cfset folderInfo.newMessageCount = 0>
                <cfset folderInfo.unreadMessageCount = 0>
                <cfset folderInfo.hasNewMessages = 0>
            <cfelse>
                <cfset folderInfo.messageCount = objFolder.getMessageCount()>
                <cfset folderInfo.deletedMessageCount = objFolder.getDeletedMessageCount()>
                <cfset folderInfo.newMessageCount = objFolder.getNewMessageCount()>
                <cfset folderInfo.unreadMessageCount = objFolder.getUnreadMessageCount()>
                <cfset folderInfo.hasNewMessages = objFolder.hasNewMessages()>
            </cfif>
            <cfset objFolder.close(false)>
            <cfcatch type="any">
                <cfset folderInfo.fullName = arguments.folder>
                <cfset folderInfo.name = arguments.folder>
                <cfset folderInfo.messageCount = 0>
                <cfset folderInfo.deletedMessageCount = 0>
                <cfset folderInfo.newMessageCount = 0>
                <cfset folderInfo.unreadMessageCount = 0>
                <cfset folderInfo.hasNewMessages = false>
            </cfcatch>
        </cftry>
        <cfreturn folderInfo>
    </cffunction>

    <cffunction name="folderList" access="public" output="No" returnType="query"
        hint="Get a list of folders.">
        <cfargument name="folder" required="No" default="Inbox" type="string">

        <cfset var objStore = getConnectedMailStore()>
        <cfset var columns = "foldername,foldertype,parent,msgcount,newmsgcount,unreadmsgcount,folderlevel,sortorder">
        <cfset var columnTypes = "varchar,integer,varchar,integer,integer,integer,integer,integer">
        <cfset var list = QueryNew(columns,columnTypes)>
        <cfset var objFolder = OpenFolder(objStore, arguments.folder, 0)>

        <cfset list = getFolderStructure(objFolder, "", list, 0)>
        <cfset variables.sortorder = 0>
        <cftry>
            <cfset objFolder.close(false)>
            <cfcatch type="any"></cfcatch>
        </cftry>
        <cfreturn list>
    </cffunction>
    
    <cffunction name="copyMessages" access="public" output="No" returnType="boolean"
        hint="Copy messages from one folder to another.">
        <cfargument name="folder" required="Yes" type="string">
        <cfargument name="messageNumber" required="Yes" type="string">
        <cfargument name="newFolder" required="Yes" type="string">

        <cfset var objStore = getConnectedMailStore()>
        <cfset var objFolder = OpenFolder(objStore, arguments.folder, true)>
        <cfset var Messages = GetMessages(objFolder, arguments.messageNumber)>
        <cfset var destFolder = objStore.getFolder(arguments.newFolder)>

        <cfif NOT destFolder.exists()>
            <!--- destination folder does not exist --->
            <cfset objFolder.close(true)>
            <cfthrow message="Unable to copy messages" detail="The destination folder, #arguments.newFolder#, does not exist.">
        <cfelseif destFolder.getType() eq destFolder.HOLDS_FOLDERS>
            <!--- destination folder cannot hold messages --->
            <cfset objFolder.close(true)>
            <cfthrow message="Unable to copy messages" detail="The destination folder, #arguments.newfolder#, cannot contain messages.">
        <cfelse>
            <cfset objFolder.copyMessages(Messages, destFolder)>
            <cfset objFolder.close(true)>
            <cfreturn "Yes">
        </cfif>
    </cffunction>
        
    <cffunction name="folderDelete" access="public" output="No" returntype="boolean"
        hint="Delete a folder.">
        <cfargument name="folder" required="Yes" type="string">
        <cfargument name="recurse" required="No" type="boolean" default="false">
        <cfset var objFolder = getConnectedMailStore().getFolder(arguments.Folder)>
        <cfset objFolder.delete(arguments.recurse)>
        <cfreturn not objFolder.exists()>
    </cffunction>

    <cffunction name="folderCreate" access="public" output="No" returntype="boolean"
        hint="Create a folder.">
        <cfargument name="folder" required="Yes" type="string">
        <cfset getConnectedMailStore().getFolder(arguments.Folder).create(true)>
        <cfreturn true>
    </cffunction>

    <cffunction name="folderRename" access="public" output="No" returntype="boolean"
        hint="Rename a folder.">
        <cfargument name="folder" required="Yes" type="string">
        <cfargument name="renameTo" required="Yes" type="string">

        <cfset var objStore = getConnectedMailStore()>
        <cfset var objFolder = OpenFolder(objStore, arguments.folder, true)>

        <cfset objFolder.close(true)>
        <cfreturn objFolder.renameTo(objStore.getFolder(arguments.renameTo))>
    </cffunction>
    
    <cffunction name="getMessageCount" access="public" output="No" returnType="numeric"
        hint="Returns the number of messages in a folder.">
        <cfargument name="folder" required="No" default="Inbox" type="string">

        <cfset var objStore = getConnectedMailStore()>
        <cfset var objFolder = OpenFolder(objStore, arguments.folder, 0)>
        <cfset var Messages = GetMessages(objFolder, "")>

        <cfset objFolder.close(false)>
        <cfreturn arraylen(Messages)>
    </cffunction>

    <cffunction name="listMessages" access="public" output="No" returnType="query"
        hint="Lists messages within a specified folder.">
        <cfargument name="folder" required="No" default="Inbox" type="string">
        <cfargument name="MessageNumber" required="No" default="" type="string">

        <cfset var objStore = getConnectedMailStore()>
        <cfset var objFolder = OpenFolder(objStore, arguments.folder, 0)>
        <cfset var Messages = GetMessages(objFolder, arguments.MessageNumber)>
        <cfset var Columns = "id,recvdate,from,messagenumber,replyto,subject,cc,to,body,txtBody,seen,answered,deleted,draft,flagged,recent,user,attach,html,size">
        <cfset var ColumnTypes = "integer,date,varchar,integer,varchar,varchar,varchar,varchar,varchar,varchar,bit,bit,bit,bit,bit,bit,bit,varchar,bit,integer">
        <cfset var qry_Messages = QueryNew(Columns,columnTypes)>

        <cfset var objMessage = "">
        <cfset var msgFrom = "">
        <cfset var msgTo = "">
        <cfset var msgFlags = "">
        <cfset var fp = createObject("java","javax.mail.FetchProfile")>
        
        <cfset fp.init()>
        <cfset fp.add(variables.fProfileItem.ENVELOPE)>
        <cfset fp.add(variables.fProfileItem.FLAGS)>
        <Cfset objFolder.fetch(Messages,fp)>

        <cfloop from="1" to="#arrayLen(Messages)#" step="1" index="index">
            <cfset objMessage = Messages[index]>
            <cfset msgFrom = objMessage.getFrom()>
            <cfset msgTo = objMessage.getRecipients(variables.objRecipientType.TO)>
            <cfif not isdefined("msgTo")>
                <cfset msgTo = ArrayNew(1)>
            </cfif>
            <cfset msgFlags = objMessage.getFlags().getSystemFlags()>

            <cfset queryAddRow(qry_Messages)>
            <cfset querySetCell(qry_Messages,"id", index)>
            <cfset querySetCell(qry_Messages,"recvdate", objMessage.getReceivedDate())>
            <cfset querySetCell(qry_Messages,"from", arrayToList(msgFrom))>
            <cfset querySetCell(qry_Messages,"messagenumber", objMessage.getMessageNumber())>
            <cfset querySetCell(qry_Messages,"subject", objMessage.getSubject())>
            <cfset querySetCell(qry_Messages,"to", arrayToList(msgTo))>
            <cfset querySetCell(qry_Messages,"size", objMessage.getSize())>
            <cfset querySetCell(qry_Messages,"seen", false)>
            <cfset querySetCell(qry_Messages,"answered", false)>
            <cfset querySetCell(qry_Messages,"deleted", false)>
            <cfset querySetCell(qry_Messages,"draft", false)>
            <cfset querySetCell(qry_Messages,"flagged", false)>
            <cfset querySetCell(qry_Messages,"user", false)>
            <cfset querySetCell(qry_Messages,"recent", false)>
            <cfloop from="1" to="#arrayLen(msgFlags)#" step="1" index="i">
                <cfif msgFlags[i] eq variables.objFlag.SEEN>
                    <cfset querySetCell(qry_Messages,"seen", true)>
                <cfelseif msgFlags[i] eq variables.objFlag.ANSWERED>
                    <cfset querySetCell(qry_Messages,"answered", true)>
                <cfelseif msgFlags[i] eq variables.objFlag.DELETED>
                    <cfset querySetCell(qry_Messages,"deleted", true)>
                <cfelseif msgFlags[i] eq variables.objFlag.DRAFT>
                    <cfset querySetCell(qry_Messages,"draft", true)>
                <cfelseif msgFlags[i] eq variables.objFlag.FLAGGED>
                    <cfset querySetCell(qry_Messages,"flagged", true)>
                <cfelseif msgFlags[i] eq variables.objFlag.USER>
                    <cfset querySetCell(qry_Messages,"user", true)>
                <cfelseif msgFlags[i] eq variables.objFlag.RECENT>
                    <cfset querySetCell(qry_Messages,"recent", true)>
                </cfif>
            </cfloop>
        </cfloop>
        <cfset objFolder.close(false)>
        <cfquery dbtype="query" name="qry_Messages">
            select * from qry_Messages
            order by id desc
        </cfquery>
        <cfreturn qry_Messages>
    </cffunction>

    <cffunction name="getMessage" access="public" output="Yes"
        hint="Get a specific message from a folder.">
        <cfargument name="folder" required="No" default="Inbox" type="string">
        <cfargument name="MessageNumber" required="No" default="1" type="numeric">
        <cfargument name="text" required="No" default="false" type="boolean">

        <cfset var objStore = getConnectedMailStore()> <!--- javax.mail.Store --->
        <cfset var objFolder = OpenFolder(objStore, arguments.folder, 0)> <!--- javax.mail.folder --->
        <cfset var Messages = GetMessages(objFolder, arguments.MessageNumber)><!--- array of com.sun.mail.imap.IMAPMessage (javax.mail.Message) --->
        <cfset var objMessage = "">

        <cfset var Columns = "id,recvdate,from,messagenumber,replyto,subject,cc,to,body,txtBody,seen,answered,deleted,draft,flagged,recent,user,attach,html,size">
        <cfset var ColumnTypes = "integer,date,varchar,integer,varchar,varchar,varchar,varchar,varchar,varchar,bit,bit,bit,bit,bit,bit,bit,varchar,bit,integer">
        <cfset var qry_Messages = QueryNew(Columns,columnTypes)>
        <cfset var msgFrom = "">
        <cfset var msgTo = "">
        <cfset var msgCC = "">
        <cfset var msgReplyTo = "">
        <cfset var msgFlags = "">
        <cfset var msgBody = "">
        <cfset var msgTxtBody = "">
        <cfset var msgAttachments = "">
        <cfset var msgIsHTML = false>
        
        <cfset var parts = arrayNew(2)>
        <cfset var i = 0>

        <cfif arrayLen(Messages) is 0>
            <Cfthrow message="Message Not Found" detail="The specified message number was not found in the specified folder.">
        </cfif>
        
        <cfset objMessage = Messages[1]><!--- com.sun.mail.imap.IMAPMessage (javax.mail.Message) --->
        
        <!--- envelope details and flags --->
        <cfset msgFrom = objMessage.getFrom()>
        <cfset msgTo = objMessage.getRecipients(variables.objRecipientType.TO)>
        <cfset msgCC = objMessage.getRecipients(variables.objRecipientType.CC)>
        <cfset msgReplyTo = objMessage.getReplyTo()>
        <cfset msgFlags = objMessage.getFlags().getSystemFlags()>

        <cfif (objMessage.isMimeType("text/*") AND NOT objMessage.isMimeType("text/rfc822-headers")) OR isSimpleValue(objMessage.getContent())>
            <!--- it is NOT a multipart message --->
            <cfset encoding = objMessage.getEncoding()>
            <!--- look for quoted-printable --->
            <cfset content = objMessage.getContent()>
            <cfset parts[1][1] = content>
            <cfif refindnocase("<html[0-9a-zA-Z= ""/:.]*>", content)>
                <cfset parts[1][2] = 2>
            <cfelse>
                <cfset parts[1][2] = 1>
            </cfif>        
        <cfelse>
            <cfset getPartsResult = getParts(objMessage)>
            <cfset parts = getPartsResult.parts>
            <cfset msgAttachments = getPartsResult.attachments>
        </cfif>

        <!--- compile the parts --->
        <!--- are there any HTML parts? --->
        <cfloop from="1" to="#arraylen(parts)#" index="i">
            <cfif parts[i][2] is 2>
                <cfset msgIsHtml = true>
            </cfif>
        </cfloop>
        <!--- compile the message body --->
        <cfloop from="1" to="#arraylen(parts)#" index="i">
            <cfif parts[i][2] is 2>
                <!--- only add HTML parts to the body --->
                <cfset msgBody = msgBody & parts[i][1]>
                <cfif arraylen(parts) gt i>
                    <cfset msgBody = msgBody & "<hr>">
                </cfif>
            <cfelse>
                <!--- only add text parts to txtBody --->
                <cfset msgTxtBody = msgTxtBody & htmlEditFormat(parts[i][1])>
            </cfif>
        </cfloop>
        <!--- add message to the return query --->
        <cfset queryAddRow(qry_Messages)>
        <cfset querySetCell(qry_Messages,"id", 1)>
        <cfset querySetCell(qry_Messages,"size", objMessage.getSize())>
        <cfset querySetCell(qry_Messages,"replyto", msgReplyTo)>
        <cfset querySetCell(qry_Messages,"recvdate", objMessage.getReceivedDate())>
        <cfset querySetCell(qry_Messages,"from", arrayToList(msgFrom))>
        <cfset querySetCell(qry_Messages,"messagenumber", objMessage.getMessageNumber())>
        <cfset querySetCell(qry_Messages,"subject", objMessage.getSubject())>
        <cfset querySetCell(qry_Messages,"to", arrayToList(msgTo))>
        <cfif isdefined("msgCC") AND isarray(msgCC)>
            <cfset querySetCell(qry_Messages,"cc", arrayToList(msgCC))>
        <cfelseif isdefined("msgCC")>
            <cfset querySetCell(qry_Messages,"cc", msgCC)>
        </cfif>
        <cfset querySetCell(qry_Messages,"body", msgBody)>
        <cfset querySetCell(qry_Messages,"txtBody", msgTxtBody)>
        <cfset querySetCell(qry_Messages,"html", msgIsHtml)>
        <cfset querySetCell(qry_Messages,"attach", msgAttachments)>
        <cfset querySetCell(qry_Messages,"seen", false)>
        <cfset querySetCell(qry_Messages,"answered", false)>
        <cfset querySetCell(qry_Messages,"deleted", false)>
        <cfset querySetCell(qry_Messages,"draft", false)>
        <cfset querySetCell(qry_Messages,"flagged", false)>
        <cfset querySetCell(qry_Messages,"user", false)>
        <cfset querySetCell(qry_Messages,"recent", false)>
        <cfloop from="1" to="#arrayLen(msgFlags)#" step="1" index="i">
            <cfif msgFlags[i] eq variables.objFlag.SEEN>
                <cfset querySetCell(qry_Messages,"seen", true)>
            <cfelseif msgFlags[i] eq variables.objFlag.ANSWERED>
                <cfset querySetCell(qry_Messages,"answered", true)>
            <cfelseif msgFlags[i] eq variables.objFlag.DELETED>
                <cfset querySetCell(qry_Messages,"deleted", true)>
            <cfelseif msgFlags[i] eq variables.objFlag.DRAFT>
                <cfset querySetCell(qry_Messages,"draft", true)>
            <cfelseif msgFlags[i] eq variables.objFlag.FLAGGED>
                <cfset querySetCell(qry_Messages,"flagged", true)>
            <cfelseif msgFlags[i] eq variables.objFlag.USER>
                <cfset querySetCell(qry_Messages,"user", true)>
            <cfelseif msgFlags[i] eq variables.objFlag.RECENT>
                <cfset querySetCell(qry_Messages,"recent", true)>
            </cfif>
        </cfloop>
        <cfset objFolder.close(false)>
        <cfreturn qry_Messages>
    </cffunction>

    <cffunction name="expunge" access="public" output="No" returntype="boolean"
        hint="Expunge deleted messages from a folder.">
        <cfargument name="folder" required="Yes" type="string">
        <cfset var objStore = getConnectedMailStore()>
        <cfset var objFolder = "">

        <cftry>
            <cfset objFolder = OpenFolder(objStore, arguments.folder, true)>
            <cfset objFolder.expunge()>
            <cfset objFolder.close(false)>
            <cfcatch type="any">
                <!--- folder cannot be expunged --->
            </cfcatch>
        </cftry>
        <cfreturn true>
    </cffunction>
    
    <cffunction name="delete" access="public" output="No" returntype="boolean"
        hint="Sets the message's DELETED flag.">
        <cfargument name="folder" required="Yes" type="string">
        <cfargument name="messageNumber" required="Yes" type="string">
        <cfargument name="value" required="Yes" type="boolean">

        <cfset var msgnum = 0>
        <cfset var objStore = getConnectedMailStore()>
        <cfset var objFolder = OpenFolder(objStore, arguments.folder, true)>
        
        <cfloop list="#listSort(messagenumber,"numeric","desc")#" index="msgnum">
            <cfif isNumeric(msgnum) and msgnum gt 0>
                <cfset setFlag(objFolder, msgnum, "DELETED", arguments.value)>
            </cfif>
        </cfloop>
        <cfset objFolder.close(false)>
        <cfreturn true>
    </cffunction>

    <cffunction name="setAnswered" access="public" output="No" returntype="boolean"
        hint="Sets the message's ANSWERED flag.">
        <cfargument name="folder" required="Yes" type="string">
        <cfargument name="messageNumber" required="Yes" type="string">
        <cfargument name="value" required="Yes" type="boolean">

        <cfset var objStore = getConnectedMailStore()>
        <cfset var objFolder = OpenFolder(objStore, arguments.folder, false)>

        <cfset setFlag(objFolder, arguments.messageNumber, "ANSWERED", arguments.value)>
        <cfset objFolder.close(false)>
        <cfreturn true>
    </cffunction>

    <cffunction name="setSeen" access="public" output="No" returntype="boolean"
        hint="Sets the message's SEEN flag.">
        <cfargument name="folder" required="Yes" type="string">
        <cfargument name="messageNumber" required="Yes" type="string">
        <cfargument name="value" required="Yes" type="boolean">

        <cfset var objStore = getConnectedMailStore()>
        <cfset var objFolder = OpenFolder(objStore, arguments.folder, false)>

        <cfset setFlag(objFolder, arguments.messageNumber, "SEEN", arguments.value)>
        <cfset objFolder.close(false)>
        <cfreturn true>
    </cffunction>

    <cffunction name="setDraft" access="public" output="No" returntype="boolean"
        hint="Sets the message's DRAFT flag.">
        <cfargument name="folder" required="Yes" type="string">
        <cfargument name="messageNumber" required="Yes" type="string">
        <cfargument name="value" required="Yes" type="boolean">

        <cfset var objStore = getConnectedMailStore()>
        <cfset var objFolder = OpenFolder(objStore, arguments.folder, false)>

        <cfset setFlag(objFolder, arguments.messageNumber, "DRAFT", arguments.value)>
        <cfset objFolder.close(false)>
        <cfreturn true>
    </cffunction>

    <cffunction name="setFlagged" access="public" output="No" returntype="boolean"
        hint="Sets the message's FLAGGED flag.">
        <cfargument name="folder" required="Yes" type="string">
        <cfargument name="messageNumber" required="Yes" type="string">
        <cfargument name="value" required="Yes" type="boolean">

        <cfset var objStore = getConnectedMailStore()>
        <cfset var objFolder = OpenFolder(objStore, arguments.folder, false)>

        <cfset setFlag(objFolder, arguments.messageNumber, "FLAGGED", arguments.value)>
        <cfset objFolder.close(false)>
        <cfreturn true>
    </cffunction>

    <cffunction name="setRecent" access="public" output="No" returntype="boolean"
        hint="Sets the message's RECENT flag.">
        <cfargument name="folder" required="Yes" type="string">
        <cfargument name="messageNumber" required="Yes" type="string">
        <cfargument name="value" required="Yes" type="boolean">

        <cfset var objStore = getConnectedMailStore()>
        <cfset var objFolder = OpenFolder(objStore, arguments.folder, false)>

        <cfset setFlag(objFolder, arguments.messageNumber, "RECENT", arguments.value)>
        <cfset objFolder.close(false)>
        <cfreturn true>
    </cffunction>

    <cffunction name="setUser" access="public" output="No" returntype="boolean"
        hint="Sets the message's USER flag.">
        <cfargument name="folder" required="Yes" type="string">
        <cfargument name="messageNumber" required="Yes" type="string">
        <cfargument name="value" required="Yes" type="boolean">

        <cfset var objStore = getConnectedMailStore()>
        <cfset var objFolder = OpenFolder(objStore, arguments.folder, false)>
        
        <cfset setFlag(objFolder, arguments.messageNumber, "USER", arguments.value)>
        <cfset objFolder.close(false)>
        <cfreturn true>
    </cffunction>
    
    <cffunction name="send" access="public" output="No" returntype="boolean">
        <cfargument name="to" required="Yes" type="string">
        <cfargument name="cc" required="Yes" type="string">
        <cfargument name="bcc" required="Yes" type="string">
        <cfargument name="subject" required="Yes" type="string">
        <cfargument name="body" required="Yes" type="string">
        <cfargument name="attachments" required="No" type="string" default="">

        <cfset var clsSession = createObject("Java", "javax.mail.Session")>
        <cfset var objProperties = createObject("Java", "java.util.Properties")>
        <cfset var msg = CreateObject("Java", "javax.mail.internet.MimeMessage")>
        <cfset var mmp = CreateObject("Java", "javax.mail.internet.MimeMultipart")>
        <cfset var mbp = CreateObject("Java", "javax.mail.internet.MimeBodyPart")>
        <cfset var dhl = CreateObject("Java", "javax.activation.DataHandler")>
        <cfset var fds = CreateObject("Java", "javax.activation.FileDataSource")>
        <cfset var add = CreateObject("Java", "javax.mail.internet.InternetAddress")>
        <cfset var trn = CreateObject("Java", "javax.mail.Transport")>
        <cfset var Timeout = application.imapTimeout * 1000>
        <cfset var index = "">
        <cfset var objFolder = "">
        <cfset var Messages = "">
        
        <cfset objProperties.init()>
        <cfset objProperties.put("mail.store.protocol", "imap")>
        <cfset objProperties.put("mail.imap.port", application.imapPort)>
        <cfset objProperties.put("mail.imap.connectiontimeout", Timeout)>
        <cfset objProperties.put("mail.imap.timeout", Timeout)>
        <cfset objSession = clssession.getInstance(objProperties)>
        <cfset objStore = getConnectedMailStore()>
        <cfset msg.init(objSession)>
        <cfset msg.setFrom(add.init(session.username))>
        <cfset msg.addRecipients(variables.objRecipientType.TO, add.parse(replace(arguments.to, ";", ", ", "ALL"), false))>
        <cfset msg.addRecipients(variables.objRecipientType.CC, add.parse(replace(arguments.cc, ";", ", ", "ALL"), false))>
        <cfset msg.addRecipients(variables.objRecipientType.BCC, add.parse(replace(arguments.bcc, ";", ", ", "ALL"), false))>
        <cfset msg.setSubject(arguments.subject)>
        <cfset msg.setText(arguments.body)>
        <cfset msg.setHeader("X-Mailer", "Koolwired IMAP Web Client (http://www.koolwired.com)")>
        <cfset msg.setSentDate(now())>
        <cfif len(arguments.attachments)>
            <cfset mbp.init()>
            <cfset mbp.setText(arguments.body)>
            <cfset mmp.addBodyPart(mbp)>
            <cfloop list="#arguments.attachments#" index="index">
                <cfset fds.init(getTempDirectory() & index)>
                <cfset mbp.init()>
                <cfset mbp.setDataHandler(dhl.init(fds))>
                <cfset mbp.setFileName(fds.getName())>
                <cfset mmp.addBodyPart(mbp)>
            </cfloop>
            <cfset msg.setContent(mmp)>
        </cfif>
        <cfset objFolder = OpenFolder(objStore, "Inbox.Sent", true, true)>
        <cfset Messages = ArrayNew(1)>
        <cfset Messages[1] = msg>
        <cfset objFolder.appendMessages(Messages)>
        <cfreturn true>
    </cffunction>
    
    <cffunction name="download" access="public" output="Yes"
        hint="Take a specific attachment from a message and return the details - along with the binary data.">
        <cfargument name="folder" required="Yes" type="string">
        <cfargument name="MessageNumber" required="Yes" type="numeric">
        <cfargument name="Attach" required="Yes" type="string">
        <cfargument name="includeData" required="no" type="boolean" default="true">
        <!---
            I think it's worth mentioning that this may not be very efficient for
            really big files because you end up writing the files twice.
        --->
        <cfset var objStore = getConnectedMailStore()>
        <cfset var objFolder = OpenFolder(objStore, arguments.folder, 0)>
        <cfset var Messages = GetMessages(objFolder, arguments.MessageNumber)>
        <cfset var attachment = StructNew()>
        <cfset var byteArray = repeatString(" ", 1000).getBytes()>
        <cfset var part = CreateObject("Java", "javax.mail.Part")>
        <cfset var i = 0>
        <cfset var fo = "">
        <cfset var fso = "">
        <cfset var in = "">
        <cfset var tempFile = "">
        <cfset var j = "">
        <cfset var fileContents = "">
        <cfset var messageParts = Messages[1].getContent()>
        <cfset var listfiles = "">
        
        <cfloop from="0" to="#messageParts.getCount() - 1#" index="i">
            <cfset part = messageParts.getBodyPart(javacast("int", i))>
            <cfif not(findnocase("text/text", part.getContentType())) and part.getFileName() is arguments.Attach>
                <cfset StructInsert(attachment, "name", part.getFileName())>
                <cfset StructInsert(attachment, "type", part.getContentType())>
                <cfset fo = createObject("Java", "java.io.File")>
                <cfset fso = createObject("Java", "java.io.FileOutputStream")>
                <cfset in = part.getInputStream()>
                <cfset randomize(second(now()) + minute(now()) * 60)>
                <cfset tempFile = getTempDirectory() & session.SessionID & "-" & randrange(1,100) & "-" & part.getFileName()>
                <cfset fo.init(tempFile)>
                <cfset fso.init(fo)>
                <cfset j = in.read(byteArray)>
                <cfloop condition="not(j is -1)">
                    <cfset fso.write(byteArray, 0, j)>
                    <cfset j = in.read(byteArray)>
                </cfloop>
                <cfset fso.close()>
                <cfif includeData>
                    <cffile action="READBINARY" file="#tempFile#" variable="fileContents">
                    <cffile action="DELETE" file="#tempFile#">
                    <cfset StructInsert(attachment, "data", fileContents)>
                    <cfset StructInsert(attachment, "length", ArrayLen(fileContents))>
                <cfelse>
                    <cfdirectory action="LIST" directory="#getDirectoryFromPath(tempFile)#" name="listFiles" filter="#getFileFromPath(tempFile)#">
                    <cfloop query="listfiles">
                        <cfif listFiles.name eq getFileFromPath(tempfile)>
                            <cfset StructInsert(attachment, "data", '')>
                            <cfset StructInsert(attachment, "length", size)>
                        </cfif>
                    </cfloop>
                </cfif>
            </cfif>
        </cfloop>
        <cfset objFolder.close(false)>
        <cfreturn attachment>
    </cffunction>


<!--- ################################################## --->
<!--- ################################################## --->
<!---                                                    --->
<!---                   PRIVATE METHODS                  --->
<!---                                                    --->
<!--- ################################################## --->
<!--- ################################################## --->

    <cffunction name="getConnectedMailStore" access="private" output="No"
        hint="Returns the existing mail store object that is in memory as long as the connection properties (username, server, port) are the same, or creates a new connected mail store object.">
        <cfset var connectionProperties = session.username & session.imapServer & session.imapPort>

        <cfif 
            isDefined("session.connectionProperties") 
            and session.connectionProperties eq connectionProperties 
            and isDefined("session.connection") 
            and not isSimpleValue(session.connection)
            and session.connection.isConnected()>
            <!---
                We have connection properties in session.
                They are the same as the connection properties we passed in.
                session.connection already exists
                and it's a mail store object
                and it's connected
                
                So, return the existing connection from the session scope.
            --->
            <cfreturn session.connection>
        <cfelse>
            <!--- get a new connected mail store and put it in the session scope --->
            <cfset session.connection = GetStore()>
            <!--- put the connection properties into the session scope --->
            <cfset session.connectionProperties = connectionProperties>
            <!--- return the new mail store --->
            <cfreturn session.connection>
        </cfif>
    </cffunction>

    <cffunction name="GetStore" access="private" output="No"
        hint="Gets a connected mail store object (ie, connect to server, authenticate, etc)">

        <cfset var clsSession = createObject("Java", "javax.mail.Session")>
        <cfset var objProperties = createObject("Java", "java.util.Properties")>
        <cfset var objStore = createObject("Java", "javax.mail.Store")>

        <cfif not structKeyExists(session,"username")>
            <!--- we're out of session! --->
            <cfthrow message="Session Time Out" detail="Your session has timed out and you are no longer connected.  Please log in again.">
        </cfif>
        <!--- set up the type of connection --->
        <cfset objProperties.init()>
        <cfset objProperties.put("mail.store.protocol", "imap")>
        <cfset objProperties.put("mail.imap.port", session.imapPort)>
        <cfset objProperties.put("mail.imap.connectiontimeout", session.imapTimeout * 1000)><!--- milliseconds --->
        <cfset objProperties.put("mail.imap.timeout", session.imapTimeout * 1000)><!--- milliseconds --->
        <!--- start the session --->
        <cfset objSession = clssession.getInstance(objProperties)>
        <!--- start the mailstore --->
        <cfset objStore = objsession.getStore()>
        <!--- connect and authenticate --->
        <cfset objStore.connect(session.imapServer, session.username, session.password)>
        <cfreturn objStore>
    </cffunction>
    
    <cffunction name="OpenFolder" access="private" output="No"
        hint="Opens a folder within a mail store and returns the folder object.">
        <cfargument name="objStore" required="Yes" type="any">
        <cfargument name="Folder" required="Yes" type="string">
        <cfargument name="ReadWrite" required="No" type="boolean" default="false">
        <cfargument name="Create" required="No" type="boolean" default="false">

        <cfset var objFolder = arguments.objStore.getFolder(arguments.Folder)>

        <cftry>
            <cfif NOT objFolder.exists() AND arguments.create>
                <cfset objFolder.create(true)>
            </cfif>
            <cfif ReadWrite>
                <cfset objFolder.open(objFolder.READ_WRITE)>
            <cfelse>
                <cfset objFolder.open(objFolder.READ_ONLY)>
            </cfif>
            <cfcatch type="any">
                <!--- folder cannot be opened --->
            </cfcatch>
        </cftry>
        <cfreturn objFolder>
    </cffunction>

    <cffunction name="GetMessages" access="private" output="No" returnType="array"
        hint="Retrieves messages from a folder, given a folder object and an optional comma separated list of message numbers.">
        <cfargument name="objFolder" required="Yes" type="any">
        <cfargument name="messageNumber" required="no" default="">

        <cfset var Messages = ArrayNew(1)>
        <cftry>
            <cfif ListLen(arguments.messageNumber) gt 0>
                <cfset Messages = arguments.objFolder.getMessages(ListToArray(arguments.messageNumber))>
            <cfelse>
                <cfset Messages = arguments.objFolder.getMessages()>
            </cfif>
            <cfcatch type="any">
                <!--- folder probably isn't allowed to cotnain messages --->
            </cfcatch>
        </cftry>
        <!--- array of javax.mail.Message --->
        <cfreturn Messages>
    </cffunction>

    <cffunction name="getFolderStructure" access="private" output="Yes" returntype="query"
        hint="Recursive method for returning the structure of a folder (including all subfolders).">
        <cfargument name="objFolder" required="Yes" type="any">
        <cfargument name="folder" required="yes" type="string">
        <cfargument name="list" required="yes" type="query">
        <cfargument name="level" required="Yes" type="numeric">
        <cfargument name="stack" required="no" type="array" default="#ArrayNew(1)#">
        
        <cfset var Folders = "">
        <cfset var i = "">
        <cfset var path = "">
        <cfset var msgcount = 0>
        <cfset var newmsgcount = 0>
        <cfset var unreadmsgcount = 0>
        
        <cfset variables.sortOrder = variables.sortOrder + 1>
        <cfif len(arguments.folder)>
            <!--- use the folder name to get the folder object --->
            <cfset arguments.objFolder = arguments.objFolder.getFolder(arguments.folder)>
        </cfif>
        <cfset Folders = arguments.objFolder.list()>
        <cfloop from="1" to="#ArrayLen(Folders)#" step="1" index="i">
            <cftry>
                <cfset path = arraytolist(arguments.stack, ".")>
                <cfif len(path)>
                    <cfset path = path & ".">
                </cfif>
                <cfset queryAddRow(arguments.list)>
                <cfset querySetCell(arguments.list, "foldername", Folders[i].getName())>
                <cfset querySetCell(arguments.list, "foldertype", Folders[i].getType())>
                <cfset querySetCell(arguments.list, "parent", path & Folders[i].getParent().getName())>
                <cfset querySetCell(arguments.list, "folderlevel", arguments.level)>
                <cfset querySetCell(arguments.list, "sortorder", variables.sortorder)>
                <cfif Folders[i].getType() eq Folders[i].HOLDS_FOLDERS>
                    <!--- folder doesn't contain messages --->
                    <cfset querySetCell(arguments.list, "msgcount", 0)>
                    <cfset querySetCell(arguments.list, "newmsgcount", 0)>
                    <cfset querySetCell(arguments.list, "unreadmsgcount", 0)>
                <cfelse>
                    <cftry>
                        <cfset msgcount = Folders[i].getMessageCount()>
                        <cfcatch type="any"><cfset msgcount = 0></cfcatch>
                    </cftry>
                    <cfset querySetCell(arguments.list, "msgcount", msgcount)>
                    <cfif msgcount lte 0>
                        <!--- if there are no messages, there won't be any
                            new or unread messages --->
                        <cfset querySetCell(arguments.list, "msgcount", 0)>
                        <cfset querySetCell(arguments.list, "msgcount", 0)>
                    <cfelse>
                        <cftry>
                            <cfset newmsgcount = Folders[i].getMessageCount()>
                            <cfcatch type="any"><cfset newmsgcount = 0></cfcatch>
                        </cftry>
                        <cfset querySetCell(arguments.list, "msgcount", newmsgcount)>
                        <cftry>
                            <cfset unreadmsgcount = Folders[i].getMessageCount()>
                            <cfcatch type="any"><cfset unreadmsgcount = 0></cfcatch>
                        </cftry>
                        <cfset querySetCell(arguments.list, "msgcount", unreadmsgcount)>
                    </cfif>
                </cfif>
                <cfcatch></cfcatch>
            </cftry>
            <cfset arguments.stack = push(arguments.stack, Folders[i].getParent().getName())>
            <cfset arguments.list = getFolderStructure(objFolder, Folders[i].getName(), arguments.list, arguments.level + 1, arguments.stack)>
            <cfset Folders = arguments.objFolder.list()>
            <cfset arguments.stack = pop(arguments.stack)>
        </cfloop>
        <cfreturn arguments.list>
    </cffunction>
    
    <cffunction name="setFlag" access="private" output="No"
        hint="Set an IMAP flag for a specific message or range of messages within the specified folder.">
        <cfargument name="objFolder" required="Yes" type="string">
        <cfargument name="messageNumber" required="Yes" type="string">
        <cfargument name="flag" required="Yes" type="string">
        <cfargument name="value" required="Yes" type="boolean">

        <cfset var Messages = GetMessages(arguments.objFolder, arguments.messageNumber)>
        <cfset var flags = CreateObject("Java", "javax.mail.Flags$Flag")>
        <cfset var i = 0>
        <cfset var objMessage = "">
        
        <cfloop from="1" to="#arrayLen(Messages)#" step="1" index="i">
            <cfset objMessage = Messages[i]>
            <cfset objMessage.setFlag(flags[flag], value)>
        </cfloop>
        <cfreturn true>
    </cffunction>

    <cffunction name="getParts" access="private" output="false" returnType="struct"
        hint="Get the parts of a message.">
        <cfargument name="objMultipart" type="any" required="yes">

        <cfset var retVal = structNew()>    
        <cfset var messageParts = objMultipart.getContent()>
        <cfset var i = 0>
        <cfset var j = 0>
        <cfset var partIndex = 0>
        <cfset var thisPart = "">
        <cfset var disposition = "">
        <cfset var contentType = "">
        <cfset var fo = "">
        <cfset var fso = "">
        <cfset var in = "">
        <cfset var tempFile = "">
        
        <cfset retVal.parts = ArrayNew(2)>
        <cfset retVal.attachments = "">
        

        <!--- get all the parts and put it into an array --->
        <!--- [1] = content, [2] = type --->
        <!--- type, 1=text, 2=html, 3=attachment --->
        <cfloop from="0" to="#messageParts.getCount() - 1#" index="i">
            <cfset partIndex = arraylen(retVal.parts) + 1>
            <cfset thisPart = messageParts.getBodyPart(javacast("int", i))>
            <!--- show all attachments as such --->
            <cfif len(thisPart.getFileName())>
                <cfset retVal.attachments = listappend(retVal.attachments, thisPart.getFileName(),chr(1))>
            </cfif>

            <cfif thisPart.isMimeType("multipart/*")>
                <cfset recurseResults = getParts(thisPart)>
                <cfset retVal.parts = push(retVal.parts, recurseResults.parts)>
                <cfset retVal.attachments = listAppend(retVal.attachments, recurseResults.attachments,chr(1))>
            <cfelse>
                <cfset disposition = thisPart.getDisposition()>
                <cfif not isdefined("disposition")> <!--- is javacast("null", "")> --->
                    <cfset contentType = thisPart.getContentType().toString()>
                    <cfif findNoCase("text/plain",contentType) is 1>
                        <cfset retVal.parts[partIndex][1] = thisPart.getContent()>
                        <cfset retVal.parts[partIndex][2] = "1">
                    <cfelseif findNoCase("text/html",contentType) is 1>
                        <!--- This shouldnt happen, at least i dont think --->
                        <!--- note, this should never happen because disposition WILL be defined for HTML parts --->
                        <cfset retVal.parts[partIndex][1] = thisPart.getContent()>
                        <cfset retVal.parts[partIndex][2] = "2">
                    <cfelse>
                        <!--- <cfdump var="other">
                        <cfset retVal.parts[i + 1][1] = "Other Content Type:" & contentType.toString() & "<br />" & part.getContent()>
                        <cfset retVal.parts[i + 1][2] = "3"> --->
                        <cfset fo = createObject("Java", "java.io.File")>
                        <cfset fso = createObject("Java", "java.io.FileOutputStream")>
                        <cfset in = thisPart.getInputStream()>
                        <cfset tempFile = getTempDirectory() & session.SessionID>
                        <cfset fo.init(tempFile)>
                        <cfset fso.init(fo)>
                        <cfset j = in.read(variables.byteArray)>
                        <cfloop condition="not(j is -1)">
                            <cfset fso.write(variables.byteArray, 0, j)>
                            <cfset j = in.read(variables.byteArray)>
                        </cfloop>
                        <cfset fso.close()>

                        <cffile action="READ" file="#tempFile#" variable="fileContents">
                        <cffile action="DELETE" file="#tempFile#">
                        <cfif findnocase("text/html", fileContents)>
                            <cfset theText = right(fileContents, len(fileContents) - refindnocase("\r\n\r\n", fileContents, findnocase("text/html", fileContents)))>
                            <cfif refind("--+=\S+--", theText)>
                                <cfset theText = left(theText, refind("--+=\S+--", theText) -1)>
                            </cfif>
                            <cfset retVal.parts[partIndex][1] = theText> <!--- replace(theText, "=20#chr(13)#", "~", "ALL")> --->
                            <cfset retVal.parts[partIndex][2] = "2">
                        <cfelse>
                            <cfset retVal.parts[partIndex][1] = fileContents>
                            <cfset retVal.parts[partIndex][2] = "3">
                            <!--- <cfdump var="#thisPart.getContentType()#  name='#thisPart.getFileName()#' #fileContents#"> --->
                        </cfif>
                    </cfif>
                <cfelseif variables.showTextHtmlAttachmentsInline>
                    <!--- 
                        inline attachments... we already put the filename in
                        the attachments list above, if there was one.  The
                        purpose of this section is to put inline text and HTML
                        attachments INLINE.  I'm personally against this, so
                        I added a "show text and html attachments inline" option.
                    --->
                    <cfif disposition.equalsIgnoreCase(thisPart.INLINE)>
                        <cfset contentType = thisPart.getContentType().toString()>
                        <cfif findNoCase("text/plain",contentType)>
                            <cfset retVal.parts[partIndex][1] = thisPart.getContent()>
                            <cfset retVal.parts[partIndex][2] = "1">
                        <cfelseif findNoCase("text/html",contentType)>
                            <!--- This shouldnt happen, at least i dont think --->
                            <cfset retVal.parts[partIndex][1] = thisPart.getContent()>
                            <cfset retVal.parts[partIndex][2] = "2">
                        <cfelse>
                            <!--- can't do inline attachments right now --->
                        </cfif>
                    <cfelse>
                        <!--- <cfset body = body & "<p>Other: " & disposition & "</p>"> --->
                    </cfif>
                <cfelse>
                    <!--- 
                        disposition is set, so it's an attachment,
                        but we're not putting *ANY* attachments inline
                        so don't do anything here
                    --->
                </cfif>
            </cfif>
        </cfloop>
        <cfreturn retVal>
    </cffunction>

    <cffunction name="push" access="private" output="yes"
        hint="Add a new item to the end of an array.">
        <cfargument name="stack" type="array" required="yes">
        <cfargument name="value" required="Yes" type="any">

        <cfset var retVal = arguments.stack>
        <cfset var i = 1>
        
        <cfif isArray(arguments.value)>
            <cfloop from="1" to="#arrayLen(arguments.value)#" step="1" index="i">
                <cfset arrayAppend(retVal, arguments.value[i])>
            </cfloop>
            <cfreturn retVal>
        <cfelse>
            <cfset arrayAppend(retVal, arguments.value)>
            <cfreturn retVal>
        </cfif>
    </cffunction>

    <cffunction name="pop" access="private" output="yes"
        hint="Remove the last item from an array.">
        <cfargument name="stack" type="array" required="yes">

        <cfset var retVal = stack>
        
        <cfif arraylen(retVal) gt 0>
            <cfset arraydeleteat(retVal, arraylen(retVal))>
        </cfif>
        <cfreturn retVal>
    </cffunction>

</cfcomponent>