.pragma library

var API = (function () {
    var hostname = "http://jsfiddle.net/";
    var locale = '';
    var jwt = '';
    var mainCallbacks;

    var serviceInstances = {};

    var statusCallbackAfterClosed;

    var SERVICES = {
        ECHO: "echo/json",

    }

    var STATUS_CODE = {
        WAIT: "WAIT",
        LOST_INTERNET: "LOST_INTERNET",

    }

    function generateRandomID() {
      function s4() {
        return Math.floor((1 + Math.random()) * 0x10000)
          .toString(16)
          .substring(1);
      }
      return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
        s4() + '-' + s4() + s4() + s4();
    }

    return {
        getHostname: function() {
            return hostname;
        },

        init: function (_mainCallbacks) {
            mainCallbacks = _mainCallbacks;
        },

        createServiceInstance: function(serviceInfo) {
            var serviceID
            do {
                serviceID = generateRandomID();
            } while(serviceInstances.hasOwnProperty(serviceID));

             if(!serviceInfo) {
                serviceInfo = {}
             }

            serviceInstances[serviceID] = serviceInfo;

            console.log("CREATED SERVICE INSTANCE #" + serviceID);
            return serviceID;
        },

        getServiceInstance: function(serviceID) {
            return serviceInstances[serviceID];
        },

        deleteServiceInstance: function(serviceID) {
            console.log("DELETED SERVICE INSTANCE #" + serviceID);
            delete serviceInstances[serviceID];
        },

        loadView: function (viewName) {
            mainCallbacks.loadView(viewName);
        },
        showStatusWait: function (callbackAfterClose) {
            statusCallbackAfterClosed = callbackAfterClose;
            mainCallbacks.showStatusWait();
        },
        showStatusCode: function (code, callbackAfterClose) {
            statusCallbackAfterClosed = callbackAfterClose;

            mainCallbacks.showStatusCode(code);
        },
        statusCallbackAfterClose: function() {

            if(statusCallbackAfterClosed !== undefined && statusCallbackAfterClosed !== null) {
                console.log("Oohhh... we're supposed to do something when closing now... could be anything, maybe abort?");
                statusCallbackAfterClosed();
            } else {
                console.log("Not doing anything after closed, other than hiding the window!");
            }
        },

        closeStatus: function () {
            mainCallbacks.closeStatus();
        },



        setJwt: function (_jwt) {
            jwt = _jwt
        },
        getJwt: function () {
            return jwt
        },

        getStringFromStatusCode: function (code) {
            switch (code) {
            case STATUS_CODE.LOST_INTERNET:
                return qsTr("Lost internet connection, please try again")
            case STATUS_CODE.WAIT:

                return qsTr("Please Wait...")
            case STATUS_CODE.AUTH:

                return qsTr("You have been signed out, please sign in!")

            default:
                return code
            }
        },
        SERVICES: SERVICES,
        STATUS_CODE: STATUS_CODE,

    }
}())
