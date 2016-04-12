.pragma library

var Globals = (function() {
    return {

        SERVICE_HOSTNAME: "http://jsfiddle.net/",
        SERVICE_ENDPOINTS: {
            ECHO: "echo/json",
        },

        STATUS_CODES: {
            WAIT: "WAIT",
            LOST_INTERNET: "LOST_INTERNET",
        },
    }
}());

var Utils = (function() {
    return {
        generateRandomID: function() {
            function s4() {
                return Math.floor((1 + Math.random()) * 0x10000)
                    .toString(16)
                    .substring(1);
            }
            return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
                s4() + '-' + s4() + s4() + s4();
        },
    }
}());

var Services = (function() {
    var serviceInstances = {};
    var loginJwt = ''; // could be used for authentication-based ajax requests

    return {
        createServiceInstance: function(serviceInfo) {
            var serviceID
            do {
                serviceID = Utils.generateRandomID();
            } while (serviceInstances.hasOwnProperty(serviceID));

            if (!serviceInfo) {
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

        loginJwt: loginJwt,
    }
}());

var Main = (function() {
    var mainCallbacks;

    return {

        init: function(_mainCallbacks) {
            mainCallbacks = _mainCallbacks;
        },

        loadView: function(viewName) {
            mainCallbacks.loadView(viewName);
        },
        showStatusWait: function(callbackAfterClose) {
            mainCallbacks.statusCallbackAfterClosed = callbackAfterClose;
            mainCallbacks.showStatusWait();
        },
        showStatusCode: function(code, callbackAfterClose) {
            mainCallbacks.statusCallbackAfterClosed = callbackAfterClose;

            mainCallbacks.showStatusCode(code);
        },
        statusCallbackAfterClose: function() {
            if (mainCallbacks.statusCallbackAfterClosed !== undefined && mainCallbacks.statusCallbackAfterClosed !== null) {
                console.log("Oohhh... we're supposed to do something when closing now... could be anything, maybe abort?");
                mainCallbacks.statusCallbackAfterClosed();
            } else {
                console.log("Not doing anything after closed, other than hiding the window!");
            }
        },

        closeStatus: function() {
            mainCallbacks.closeStatus();
        },
    }
}())

var Locale = (function() {
    return {
        getStringFromStatusCode: function(code) {
            switch (code) {
                case Globals.STATUS_CODES.LOST_INTERNET:
                    return qsTr("Lost internet connection, please try again")
                case Globals.STATUS_CODES.WAIT:

                    return qsTr("Please Wait...")
                case Globals.STATUS_CODES.AUTH:

                    return qsTr("You have been signed out, please sign in!")

                default:
                    return code
            }
        },
    }
}());
