sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"leave/test/integration/pages/LeaveRequestsList",
	"leave/test/integration/pages/LeaveRequestsObjectPage"
], function (JourneyRunner, LeaveRequestsList, LeaveRequestsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('leave') + '/test/flp.html#app-preview',
        pages: {
			onTheLeaveRequestsList: LeaveRequestsList,
			onTheLeaveRequestsObjectPage: LeaveRequestsObjectPage
        },
        async: true
    });

    return runner;
});

