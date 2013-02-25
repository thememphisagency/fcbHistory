<cfcomponent extends="farcry.plugins.testmxunit.tests.FarcryTestCase">

	<cfimport path="farcry.plugins.fcbhistory.packages.lib.history" />

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
			stDefault.message = 'Default log message string.';
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

	<cffunction name="should_throw_on_missing_parameters" returntype="void" access="public" mxunit:expectedException="Application">
		
		<cfset var oHistory = new history() />

		<cfset assertTrue(oHistory.log()) />

	</cffunction>

	<cffunction name="create_a_log_by_a_default_level_accessor" returntype="void" access="public">

		<cfset var oHistory = new history() />
		<cfset assertEquals(oHistory, oHistory.info('This is my info')) />

	</cffunction>

	<cffunction name="create_a_log_by_a_custom_level_accessor" returntype="void" access="public">

		<cfset var oHistory = new history() />
		<cfset oHistory.setLevels('customLevel') />

		<cfset assertEquals(oHistory, oHistory.customLevel('This is my info')) />

	</cffunction>

	<cffunction name="test_default_transport" returntype="void" access="public">
		
		<cfset var oHistory = new history() />
		<cfset var logString = oHistory.log(level = stDefault.level, message = stDefault.message) />

		<cfset assertEquals(oHistory, logString) />

	</cffunction>
	
</cfcomponent>