import QtQuick 2.0
import "qrc:/js/config.js" as Config

Item {
    id: root
    anchors.fill: parent
    property double targetOpacity: 1.0

    state: "Hidden"

    function showStatusCode(code) {
        textField.text = Config.API.getStringFromStatusCode(code)
        root.state = "Visible"
    }

    function showWait() {
        textField.text = Config.API.getStringFromStatusCode(
                    Config.API.STATUS_CODE.WAIT)
        root.state = "Visible"
    }

    Rectangle {
        anchors.fill: parent
        color: "#ffffff"
        MouseArea {
            anchors.fill: parent
        }

        Text {
            id: textField
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignTop
            textFormat: Text.StyledText
            font.family: "Arial"
            font.pointSize: 24
            color: "#2a2a2a"
            wrapMode: Text.WordWrap
        }

        ColorButton {
            id: closeButton
            anchors.right: parent.right
            anchors.rightMargin: 5

            anchors.top: parent.top
            anchors.topMargin: 5
            width: 270
            height: 70
            buttonColor: "red"
            text: "STOP"
            fontSize: 24

            onButtonClicked: {
                root.state = "Hidden"
                root.closed
                Config.API.statusCallbackAfterClose()
            }
        }
    }
    states: [
        State {
            name: "Visible"
            PropertyChanges {
                target: root
                opacity: targetOpacity
            }
            PropertyChanges {
                target: root
                visible: true
            }
        },
        State {
            name: "Hidden"
            PropertyChanges {
                target: root
                opacity: 0.0
            }
            PropertyChanges {
                target: root
                visible: false
            }
        }
    ]

    transitions: [
        Transition {
            from: "Visible"
            to: "Hidden"

            SequentialAnimation {
                NumberAnimation {
                    target: root
                    property: "opacity"
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
            }
        },
        Transition {
            from: "Hidden"
            to: "Visible"
            SequentialAnimation {
                NumberAnimation {
                    target: root
                    property: "opacity"
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
            }
        }
    ]
}
