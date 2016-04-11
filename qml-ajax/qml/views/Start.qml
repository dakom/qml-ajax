import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 1.5
import QtQuick.Controls.Styles 1.4
import "../helpers"
import "qrc:/js/config.js" as Config

Rectangle {
    id: root

    anchors.fill: parent

    function hasLoaded() {
        console.log("has loaded!")
    }

    ServiceWorker {
        id: services
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
                services.callService(Config.API.SERVICES.ECHO, {
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
        Config.API.showStatusCode("You said: " + retObj.myText);
    }
}
