<cfcomponent output="true" extends="transport" displayname="fcbHistory base transport" hint="Base transport that all other transports should inherit from.">

	<cfset this.name = 'consoleTransport' />
	<cfset this.timestamp = this.getTimestamp />

	<cffunction name="init" returntype="consoleTransport">

		<cfset super.init(argumentCollection=arguments) />

		<cfreturn this />

	</cffunction>

	<cffunction name="log" returntype="string">
		
		<cfargument name="level" type="string" required="true" />
		<cfargument name="message" type="string" required="true" />
		<cfargument name="reference" type="string" required="false" default="" />
		<cfargument name="metadata" type="any" required="false" default="" />

		<cfset var sReturn = super.log(arguments.level, arguments.message, arguments.reference, arguments.metadata) />

		<cfreturn sReturn />

	</cffunction>

</cfcomponent>