<cfcomponent output="false" extends="farcry.core.packages.types.types" displayname="fcbHistory mysql transport" hint="Will store a log into the database." bObjectBroker="false" bSystem="true" bAudit="false" bRefObjects="false">

	<cfproperty name="transports" type="array" />
	<cfproperty name="levels" type="array" />

	<cffunction name="init">
		
		<!--- init the default transport --->

		<!--- init the default levels --->
		<cfset setLevels('info','warning','error') />

	</cffunction>

	<cffunction name="setLevels" returntype="void">
		
		<cfargument name="levels" type="string" required="true" />

		<!--- remove the old level accessors --->
		<!--- not sure how to do this, just yet --->

		<!--- store in this.levels --->
		<cfset this.levels = ListToArray(arguments.levels) />

		<!--- create proxy methods for dot access i.e. history.info() --->
		<cfloop array="#this.levels#" index="level">
			<cfset this[level] = logProxy />
		</cfloop>

	</cffunction>

	<cffunction name="logProxy" returntype="boolean">
		
		<cfdump var="logProxy" />

		<cfreturn true />

	</cffunction>

	<cffunction name="log" returntype="boolean">
		
		<cfargument name="level" type="string" required="true" />
		<cfargument name="reference" type="string" required="false" default="" />
		<cfargument name="message" type="string" required="true" />
		<cfargument name="metadata" type="any" required="false" default="" />

		<cfreturn true />

	</cffunction>

</cfcomponent>