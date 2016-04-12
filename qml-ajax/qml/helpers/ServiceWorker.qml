import QtQuick 2.0
import "qrc:/js/api.js" as JSAPI

Item {
    id: root

    function callService(serviceURI, dataObj, callbacks, preventWaitWindow) {

        var serviceID = JSAPI.Services.createServiceInstance(callbacks);

        worker.sendMessage({
                               typ: "service",
                               serviceID: serviceID,
                               url: JSAPI.Globals.SERVICE_HOSTNAME + serviceURI,
                               dataObj: dataObj,
                               jwt: JSAPI.Services.loginJwt
                           })

        if(!preventWaitWindow) {
            JSAPI.Main.showStatusWait(function() {
                root.destroyService(serviceID);
            });
        }

        return serviceID


    }

    function destroyService(serviceID) {

        JSAPI.Services.deleteServiceInstance(serviceID);
        worker.sendMessage({
                               typ: "destroy_service",
                               serviceID: serviceID,

        });
    }

    WorkerScript {
        id: worker
        source: "qrc:/js/workers.js"
        onMessage: function gotMessage(msg) {

            if (msg.typ == "service") {
                var serviceID = msg.serviceID;
                var serviceInstance = JSAPI.Services.getServiceInstance(serviceID);

                if(!serviceInstance) {
                    console.log("service instance not found (hopefully you aborted it!): #" + serviceID);
                    return;
                }

                var retObj = msg.retObj

                if (retObj == null) {
                    if(serviceInstance.onFailFundamentalCallback !== null) {
                     serviceInstance.onFailFundamentalCallback();
                    } else {
                        JSAPI.Main.showStatusCode(JSAPI.Gobals.STATUS_CODES.LOST_INTERNET);
                    }
                } else if (!retObj.hasOwnProperty("myText")) {
                    //Theoretically we could parse different types of error returns here...
                    var failCode = retObj.hasOwnProperty("code") ? retObj.code : JSAPI.Globals.STATUS_CODES.LOST_INTERNET;

                    if (serviceInstance.onFailStatusCallback !== undefined) {
                        serviceInstance.onFailStatusCallback(failCode, retObj)
                    } else {
                        JSAPI.Main.showStatusCode(failCode)
                    }
                } else {
                    serviceInstance.onSuccessCallback(retObj)
                }

                destroyService(serviceID);

            }
        }
    }

}
