sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"debsahab/manageorders/test/integration/pages/PurchaseOrderSetList.gen",
	"debsahab/manageorders/test/integration/pages/PurchaseOrderSetObjectPage.gen",
	"debsahab/manageorders/test/integration/pages/PurchaseOrderItemsSetObjectPage.gen"
], function (JourneyRunner, PurchaseOrderSetListGenerated, PurchaseOrderSetObjectPageGenerated, PurchaseOrderItemsSetObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('debsahab/manageorders') + '/test/flp.html#app-preview',
        pages: {
			onThePurchaseOrderSetListGenerated: PurchaseOrderSetListGenerated,
			onThePurchaseOrderSetObjectPageGenerated: PurchaseOrderSetObjectPageGenerated,
			onThePurchaseOrderItemsSetObjectPageGenerated: PurchaseOrderItemsSetObjectPageGenerated
        },
        async: true
    });

    return runner;
});

