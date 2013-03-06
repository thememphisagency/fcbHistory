<cfcomponent extends="transport" displayname="fcbHistory file transport" hint="A transport that will append to a file.">

	<cfset this.name = 'fileTransport' />
	<cfset this.timestamp = this.getTimestamp />
	<cfset this.file = '' />

	<cffunction name="init" returntype="transport">

		<cfargument name="file" type="string" required="true" />
		<cfargument name="timestamp" type="any" required="false" default="#this.getTimestamp#"  />

		<!--- make the file if it doesn't exist --->
		<cfset this.file = arguments.file />
		<cfif NOT fileExists(arguments.file)>
			<cffile action="write" file="#arguments.file#" output="File created on #dateFormat(now(), 'yyyy-dd-mm')# at #timeFormat(now(), 'hh:mm')#." addnewline="true" charset="utf-8">
		</cfif>

		<!--- use default to make this.timestamp default to the getTimestamp method within this CFC --->
		<cfset this.timestamp = arguments.timestamp />

		<cfreturn this />

	</cffunction>

	<cffunction name="log" returntype="string">
		
		<cfargument name="level" type="string" required="true" />
		<cfargument name="message" type="string" required="true" />
		<cfargument name="reference" type="string" required="false" default="" />
		<cfargument name="metadata" type="any" required="false" default="" />

		<cfset var sReturn = super.log(arguments.level, arguments.message, arguments.reference, arguments.metadata) />

		<!--- now save it to disk --->
		<cffile action="append" file="#this.file#" output="#sReturn#" addnewline="true">

		<!--- now that we've built the string, return it --->
		<cfreturn sReturn />

	</cffunction>

</cfcomponent>