<cfcomponent extends="farcry.plugins.testmxunit.tests.FarcryTestCase">

	<!--- setup and teardown --->
	<cffunction name="setUp" returntype="void" access="public">

		<!--- let the framework do its thing --->
		<cfset super.setUp() />

		<!--- defined a standard email struct --->
		<cfscript>

			stData = {};
			stData.foo = 'bar';

			stDefault = {};
			stDefault.level = 'info';
			stDefault.reference = 'LogTest';
			stDefault.message = 'EmailTestCase';
			stDefault.metadata = SerializeJSON(stData);
		</cfscript>

	</cffunction>

	<cffunction name="should_create_log_within_database" returntype="void" access="public">

		<cfset var stLog = createTemporaryObject(
				typename = 'fcbLog',
				level = stDefault.level,
				message = stDefault.message,
				reference = stDefault.reference,
				metadata = stDefault.metadata
			) />

		<cfset assertContentTypeExists(typename = 'fcbLog') />
		<cfset assertObjectExists(typename = 'fcbLog', objectid = stLog.objectid) />
		<cfset assertEquals(stDefault.level, stLog.level) />
		<cfset assertEquals(stDefault.reference, stLog.reference) />
		<cfset assertEquals(stDefault.message, stLog.message) />

	</cffunction>
	
</cfcomponent>