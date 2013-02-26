<cfcomponent displayname="fcbHistory mysql transport" hint="Will store a log into the database.">

	<cfset this.transports = structNew() />
	<cfset variables.levels = arrayNew(1) />

	<cffunction name="init" returntype="history">

		<cfargument name="transports" type="array" required="false" />
		<cfargument name="levels" type="array" required="false" default="#['info','warning','error']#" />

		<!--- have we been supplied an array of transports? --->
		<cfif isDefined('arguments.transports') AND isValid("array", arguments.transports)>

			<cfloop array="#arguments.transports#" index="transport">
				
				<!--- each transport (struct) in the transports array must define the path to the transport class, in a property named transport --->
				<cfif NOT isDefined('transport.transport')>
					<cfthrow type="Application" message="Each transport should passed to the init method should provide a transport property containing a path to the transport class." />
				</cfif>

				<!--- set an empty options struct if nothing was passed in, just allows us to easily reference it --->
				<cfparam name="transport.options" default="#structNew()#" />

				<!--- attach the transport --->
				<cfset attachTransport(transport.transport, transport.options) />

			</cfloop>

		<!--- init the default transport --->
		<cfelse>
			<cfset attachTransport('farcry.plugins.fcbhistory.packages.lib.transport', {}) />
		</cfif>

		<!--- init the levels (default as per the argument, or custom as passed through to init) --->
		<cfset setLevels(arguments.levels) />

		<cfreturn this />

	</cffunction>

	<cffunction name="setLevels" returntype="void" hint="Set the levels used by the logger.">
		
		<cfargument name="levels" type="array" required="true" />

		<!--- remove the old level accessors --->
		<!--- not sure how to do this, just yet --->

		<!--- store in variables.levels --->
		<cfset variables.levels = arguments.levels />

		<!--- create proxy methods for dot access i.e. history.info() --->
		<cfloop array="#variables.levels#" index="level">
			<cfset this[level] = logProxy />
		</cfloop>

	</cffunction>

	<cffunction name="attachTransport" returntype="history" hint="Used to attach a new transport to the logger (loggers can handle multiple transports)">

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

	<cffunction name="logProxy" returntype="any" access="package">

		<cfargument name="message" type="string" required="true" />
		<cfargument name="reference" type="string" required="false" default="" />
		<cfargument name="metadata" type="any" required="false" default="" />

		<cfreturn this.log(getFunctionCalledName(), arguments.message, arguments.reference, arguments.metadata) />

	</cffunction>

	<cffunction name="log" returntype="history" hint="Used to log a message with the logger. You can also log using the level-named methods i.e. logger.info('message').">
		
		<cfargument name="level" type="string" required="true" />
		<cfargument name="message" type="string" required="true" />
		<cfargument name="reference" type="string" required="false" default="" />
		<cfargument name="metadata" type="any" required="false" default="" />

		<cfset var logString = '' />

		<!--- pass the log to each transport --->
		<cfloop collection="#this.transports#" item="transport">
			<cfset logString = this.transports[transport].log(level, message, reference, metadata) />
		</cfloop>

		<cfreturn this />

	</cffunction>

</cfcomponent>