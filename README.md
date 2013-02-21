fcbHistory
=============

> fcbHistory is a logging framework, for anything and everything to do with logging within FarCry.

Features
--------

* Logs are persisted to the database, using json to store log data.

Dependencies
------------

* none

Basic usage
-----------

	<cfset stProperties = structNew() />
	<cfset data = structNew() />

	<!--- serialize properties into a json object --->
	<cfloop list="prop1,prop2,prop3,prop4" index="prop">
		<cfif len(this[prop])>
			<cfset data[prop] = this[prop] />
		</cfif>
	</cfloop>

	<!--- stringify json and define reference --->
	<cfset stProperties.data = serializeJSON(data) />
	<cfset stProperties.reference = 'reference string' />

	<!--- persist the log to the database --->
	<cfset result = application.fapi.getContentType('fcbLog').createData(stProperties = stProperties) />