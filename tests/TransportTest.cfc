<cfcomponent extends="farcry.plugins.testmxunit.tests.FarcryTestCase">

	<cfimport path="farcry.plugins.fcbhistory.packages.lib.transport" />

	<!--- setup and teardown --->
	<cffunction name="setUp" returntype="void" access="public">

		<!--- let the framework do its thing --->
		<cfset super.setUp() />

	</cffunction>

	<cffunction name="should_generate_a_string_without_timestamp" returntype="void" access="public">

		<cfset var transport = new transport(timestamp = false) />
		<cfset assertEquals('info: (reference) message', transport.log('info', 'message', 'reference')) />

	</cffunction>

	<cffunction name="should_generate_a_string_without_a_reference" returntype="void" access="public">

		<cfset var transport = new transport(timestamp = false) />
		<cfset assertEquals('info: message', transport.log('info', 'message')) />

	</cffunction>

	<cffunction name="should_generate_a_string_with_a_string_metadata" returntype="void" access="public">

		<cfset var transport = new transport(timestamp = false) />
		<cfset assertEquals('info: (reference) message : metadata', transport.log('info', 'message', 'reference', 'metadata')) />

	</cffunction>

	<cffunction name="should_generate_a_string_with_a_json_metadata" returntype="void" access="public">

		<cfset var transport = new transport(timestamp = false) />
		<cfset var json = serializeJSON({type:'json'}) />
		<cfset assertEquals('info: (reference) message : {"type":"json"}', transport.log('info', 'message', 'reference', json)) />

	</cffunction>

	<cffunction name="should_generate_a_string_with_metadata_and_no_reference" returntype="void" access="public">

		<cfset var transport = new transport(timestamp = false) />
		<cfset assertEquals('info: message : metadata', transport.log('info', 'message', '', 'metadata')) />

	</cffunction>
	
</cfcomponent>