<cfcomponent displayname="fcbHistory base transport" hint="Base transport that all other transports should inherit from.">

	<cfset this.name = 'transport' />
	<cfset this.timestamp = this.getTimestamp />

	<cffunction name="init" returntype="transport">

		<cfargument name="timestamp" type="any" required="false" default="#this.getTimestamp#"  />

		<!--- use default to make this.timestamp default to the getTimestamp method within this CFC --->
		<cfset this.timestamp = arguments.timestamp />

		<cfreturn this />

	</cffunction>

	<cffunction name="log" returntype="string">
		
		<cfargument name="level" type="string" required="true" />
		<cfargument name="message" type="string" required="true" />
		<cfargument name="reference" type="string" required="false" default="" />
		<cfargument name="metadata" type="any" required="false" default="" />

		<!--- 'info' --->
		<cfset var sReturn = arguments.level />

		<!--- generate the timestamp, unless false
		append ' [2013-01-01 00:00:00]' to read 'info [2013-01-01 00:00:00]' --->
		<cfif isBoolean(this.timestamp) || this.timestamp EQ this.getTimestamp || isCustomFunction(this.timestamp)>
			<cfset sReturn = sReturn & ' [' & this.timestamp() & ']' />
		</cfif>

		<!--- append ':' to read 'info [2013-01-01 00:00:00]:' --->
		<cfset sReturn = sReturn & ':' />

		<!--- optionally append 'reference' to read 'info [2013-01-01 00:00:00]: (reference)' --->
		<cfif len(arguments.reference)>
			<cfset sReturn = sReturn & ' (' & arguments.reference & ')' />
		</cfif>

		<!--- append message to read 'info [2013-01-01 00:00:00]: (reference) message' --->
		<cfset sReturn = sReturn & ' ' & arguments.message />

		<!--- optionally append metadata to read 'info [2013-01-01 00:00:00]: (reference) message : metadata' --->
		<cfif isSimpleValue(arguments.metadata) AND len(arguments.metadata)>
			<cfset sReturn = sReturn & ' : ' & arguments.metadata />
		<cfelseif NOT isSimpleValue(arguments.metadata)>
			<cfset sReturn = sReturn & ' : ' & serializeJSON(arguments.metadata) />
		</cfif>

		<!--- now that we've built the string, return it --->
		<cfreturn sReturn />

	</cffunction>

	<!--- return a simple timestamp --->
	<cffunction name="getTimestamp" returntype="string" access="public">
		
		<cfreturn dateFormat(now(), 'yyyy-dd-mm') & ' ' & timeFormat(now(), 'hh:mm:ss') />

	</cffunction>

</cfcomponent>