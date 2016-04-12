var WorkerServices = (function () {
    var serviceXHRList = {

    }

    return {
        Call: function (serviceID, url, dataObj, jwt) {
            var xhr = new XMLHttpRequest()

            serviceXHRList[serviceID] = xhr

            xhr.onreadystatechange = function () {
                if (xhr.readyState == xhr.DONE) {
                    var retObj = null

                    if (xhr.status == 200) {
                        console.log("GOT RESPONSE: " + xhr.responseText)
                        retObj = JSON.parse(xhr.responseText)
                    } else {


                        //Kinda useless in a way... also fires on abort()
                        // console.log("FATAL FAIL FROM " + url)
                        //   console.log("Status: " + xhr.status + ", Status Text: " + xhr.statusText);
                    }

                    WorkerScript.sendMessage({
                                                 typ: "service",
                                                 serviceID: serviceID,
                                                 retObj: retObj
                                             })
                }
            }

            xhr.open("POST", url, true) // only async supported

            if (jwt && jwt != '') {
                xhr.setRequestHeader("Authorization", "Bearer " + jwt)
            }

            var postString = ''
            for (var key in dataObj) {
                if (dataObj.hasOwnProperty(key)) {
                    if (postString != '') {
                        postString += '&'
                    }
                    postString += key + "=" + encodeURIComponent(dataObj[key])
                }
            }

            console.log("Posting to " + url + "?" + postString)

            if (postString != '') {
                xhr.setRequestHeader("Content-type",
                                     "application/x-www-form-urlencoded")
                xhr.setRequestHeader("Content-length", postString.length)
                xhr.send(postString)
            } else {
                xhr.send()
            }
        },
        Destroy: function (serviceID) {
            var xhr = serviceXHRList[serviceID]
            if (xhr) {
                console.log("Aborting service id #" + serviceID)
                xhr.abort()
            } else {
                console.log("NOT Aborting service id #" + serviceID
                            + "(most likely this was already aborted before or finished the call)")
            }

            delete serviceXHRList[serviceID]
        }
    }
}());

WorkerScript.onMessage = function (msg) {

    switch (msg.typ) {
    case "service":
        WorkerServices.Call(msg.serviceID, msg.url, msg.dataObj, msg.jwt)
        break
    case "destroy_service":
        WorkerServices.Destroy(msg.serviceID)
        break
    default:
        console.log("unknown type! " + msg.typ)
        break
    }
}
