<cfcomponent displayname="fcbHistory mysql transport" hint="Will store a log into the database.">

	<cfset this.transports = structNew() />
	<cfset variables.levels = arrayNew(1) />

	<cffunction name="init" returntype="history">

		<!--- init the default transport --->
		<cfset attachTransport('farcry.plugins.fcbhistory.packages.lib.transport', {}) />

		<!--- init the default levels --->
		<cfset setLevels('info','warning','error') />

		<cfreturn this />

	</cffunction>

	<cffunction name="setLevels" returntype="void">
		
		<cfargument name="levels" type="string" required="true" />

		<!--- remove the old level accessors --->
		<!--- not sure how to do this, just yet --->

		<!--- store in variables.levels --->
		<cfset variables.levels = ListToArray(arguments.levels) />

		<!--- create proxy methods for dot access i.e. history.info() --->
		<cfloop array="#variables.levels#" index="level">
			<cfset this[level] = logProxy />
		</cfloop>

	</cffunction>

	<cffunction name="attachTransport" returntype="history">

		<cfargument name="transportPath" type="string" required="true" hint="The dot path to the transport component." />
		<cfargument name="options" type="struct" required="false" default="#structNew()#" hint="The options to pass to the transport." />

		<cfset var transport = CreateObject('component', arguments.transportPath).init(argumentCollection=arguments.options) />

		<cfif NOT StructKeyExists(transport, 'name') AND NOT isDefined('transport.create')>
			<cfthrow type="Application" message="Unknown transport with not create() method.">
		<cfelseif structKeyExists(this.transports, transport.name)>
			<cfthrow type="Application" message="The #transport.name# transport already attached.">
		</cfif>

		<cfset this.transports[transport.name] = transport />

		<cfreturn this />
		
	</cffunction>

	<cffunction name="removeTransport" returntype="history" hint="Remove the transport from the this.transports used in this logger">
		
		<cfargument name="transportPath" type="string" required="true" />

		<cfset var transport = CreateObject(arguments.transportPath) />

		<cfif StructKeyExists(transport, 'name')>
			<cfset structDelete(this.transports, transport.name) />
		</cfif>

		<cfreturn this />

	</cffunction>

	<cffunction name="logProxy" returntype="any">

		<cfargument name="message" type="string" required="true" />
		<cfargument name="reference" type="string" required="false" default="" />
		<cfargument name="metadata" type="any" required="false" default="" />

		<cfreturn this.log(getFunctionCalledName(), arguments.message, arguments.reference, arguments.metadata) />

	</cffunction>

	<cffunction name="log" returntype="history">
		
		<cfargument name="level" type="string" required="true" />
		<cfargument name="message" type="string" required="true" />
		<cfargument name="reference" type="string" required="false" default="" />
		<cfargument name="metadata" type="any" required="false" default="" />

		<cfset var logString = '' />

		<!--- pass the log to each transport --->
		<cfloop collection="#this.transports#" item="transport">
			<cfset logString = this.transports[transport].log(level, message, reference, metadata) />
			<cfdump var="#logString#" />
		</cfloop>

		<cfreturn this />

	</cffunction>

</cfcomponent>