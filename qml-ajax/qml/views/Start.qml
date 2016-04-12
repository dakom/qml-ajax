import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 1.5
import QtQuick.Controls.Styles 1.4
import "../helpers"
import "qrc:/js/api.js" as JSAPI

Rectangle {
    id: root

    anchors.fill: parent

    function hasLoaded() {
        console.log("has loaded!")
    }

    ServiceWorker {
        id: serviceWorker
    }

    Rectangle {
        anchors.fill: parent
        color: "#ffffff"


        ColorButton {
            id: btn
            anchors.horizontalCenter: parent.horizontalCenter

            anchors.top: parent.top
            anchors.topMargin: 50
            width: 270
            height: 70
            buttonColor: "green"
            text: "Load AJAX"
            fontSize: 24

            onButtonClicked: {
                serviceWorker.callService(JSAPI.Globals.SERVICE_ENDPOINTS.ECHO, {
                                         json: JSON.stringify({
                                                               myText: input.text + "2"
                                                           })
                                     }, { onSuccessCallback: gotMessageBack2
                                     }
                                         )

                //notice what happens if you switch these around, the effects of closing are visually different
                //statusCallbackAfterClose() is always the most recent one, corresponding to user experience of one window
                //The way it is right now is correct, the second one corresponds to the version which shows the text visually
                //Closing will still do the console.log (i.e. gotMessageBack2())

                serviceWorker.callService(JSAPI.Globals.SERVICE_ENDPOINTS.ECHO, {
                                         json: JSON.stringify({
                                                               myText: input.text
                                                           })
                                     }, { onSuccessCallback: gotMessageBack
                                     }
                                         )


            }
        }

        TextField {
            id: input
            focus: true
            text: "Hello World!"
            width: 500
            height: 50
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: btn.bottom
            anchors.topMargin: 20
            font.pointSize: 20
            style: TextFieldStyle {

                textColor: "#2a2a2a"

            }
        }
    }

    function gotMessageBack(retObj) {
        JSAPI.Main.showStatusCode("You said: " + retObj.myText);
    }

    function gotMessageBack2(retObj) {
       console.log("Async test #2: " + retObj.myText);
    }
}
