import QtQuick 2.0
import "qrc:/js/config.js" as Config

Item {
    id: root
    property string hostname: Config.API.getHostname();



    function callService(serviceURI, dataObj, callbacks, preventWaitWindow) {

        var serviceID = Config.API.createServiceInstance(callbacks);

        worker.sendMessage({
                               typ: "service",
                               serviceID: serviceID,
                               url: root.hostname + serviceURI,
                               dataObj: dataObj,
                               jwt: Config.API.getJwt()
                           })

        if(!preventWaitWindow) {
            Config.API.showStatusWait(function() {
                root.destroyService(serviceID);
            });
        }

        return serviceID


    }

    function destroyService(serviceID) {

        Config.API.deleteServiceInstance(serviceID);
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
                var serviceInstance = Config.API.getServiceInstance(serviceID);

                if(!serviceInstance) {
                    console.log("service instance not found (hopefully you aborted it!): #" + serviceID);
                    return;
                }

                var retObj = msg.retObj

                console.log(retObj);

                if (retObj == null) {
                    if(serviceInstance.onFailFundamentalCallback !== null) {
                     serviceInstance.onFailFundamentalCallback();
                    } else {
                        Config.API.showStatusCode(Config.API.STATUS_CODE.LOST_INTERNET);
                    }
                } else if (!retObj.hasOwnProperty("myText")) {
                    //Theoretically we could parse different types of error returns here...
                    var failCode = retObj.hasOwnProperty("code") ? retObj.code : Config.API.STATUS_CODE.LOST_INTERNET;

                    if (serviceInstance.onFailStatusCallback !== undefined) {
                        serviceInstance.onFailStatusCallback(failCode, retObj)
                    } else {
                        Config.API.showStatusCode(failCode)
                    }
                } else {
                    serviceInstance.onSuccessCallback(retObj)
                }

                destroyService(serviceID);

            }
        }
    }

}
