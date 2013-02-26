fcbHistory
=============

> fcbHistory is a logging framework, for anything and everything to do with logging within FarCry.

Features
--------

- The logging framework comes with a default set of levels, and these are completely customiseable
- The logging framework also comes with two different transports, but you can create a new transport for any type of logging as required

Dependencies
------------

* none

Basic usage
-----------

	<!--- create an instance of a logger --->
	<cfset logger = CreateObject('farcry.plugins.fcbhistory.packages.lib.history').init() />

	<!--- remove the default transport which doesn't output anywhere at present --->
	<cfset logger.removeTransport('farcry.plugins.fcbhistory.packages.lib.transport') />

	<!--- attach a different transport, the fileTransport at this point --->
	<cfset logger.attachTransport('farcry.plugins.fcbhistory.packages.lib.fileTransport', {file: '#ExpandPath('./')#output.log'}) />

	<!--- log something! --->
	<cfset logger.log('info', 'message') />

### Levels

The default levels are:

- info
- warning
- error

There are level methods for logging, so rather than:

	<cfset logger.log('level', 'message') />

You can simply:

	<cfset logger.info('message') />
	<!--- or --->
	<cfset logger.warning('message') />
	<!--- or --->
	<cfset logger.error('message') />
