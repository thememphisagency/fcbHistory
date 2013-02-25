<cfcomponent displayname="fcbHistory base transport" hint="Base transport that all other transports should inherit from.">

	<cfset this.name = 'transport' />
	<cfset this.timestamp = this.getTimestamp />

	<cffunction name="init" returntype="transport">

		<cfargument name="timestamp" type="any" required="false" default="#this.getTimestamp#"  />

		<cfset this.timestamp = arguments.timestamp />

		<cfreturn this />

	</cffunction>

	<cffunction name="log" returntype="string">
		
		<cfargument name="level" type="string" required="true" />
		<cfargument name="message" type="string" required="true" />
		<cfargument name="reference" type="string" required="false" default="" />
		<cfargument name="metadata" type="any" required="false" default="" />

		<cfset var sReturn = arguments.level />

		<!--- generate the timestamp, unless false --->
		<cfif isBoolean(this.timestamp) || this.timestamp EQ this.getTimestamp || isCustomFunction(this.timestamp)>
			<cfset sReturn = sReturn & ' [' & this.timestamp() & ']' />
		</cfif>

		<cfset sReturn = sReturn & ':' />

		<cfif len(arguments.reference)>
			<cfset sReturn = sReturn & ' (' & arguments.reference & ')' />
		</cfif>

		<cfset sReturn = sReturn & ' ' & arguments.message />

		<cfif isSimpleValue(arguments.metadata) AND len(arguments.metadata)>

			<cfset sReturn = sReturn & ' : ' & arguments.metadata />
			
		<cfelseif NOT isSimpleValue(arguments.metadata)>

			<cfset sReturn = sReturn & ' : ' & serializeJSON(arguments.metadata) />

		</cfif>

		<cfreturn sReturn />

	</cffunction>

	<cffunction name="getTimestamp" returntype="string" access="public">
		
		<cfreturn dateFormat(now(), 'yyyy-dd-mm') & ' ' & timeFormat(now(), 'hh:mm:ss') />

	</cffunction>

</cfcomponent>