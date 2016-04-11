import QtQuick 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 1.5

Button {
    id: root
    property string buttonColor
    property double fontSize
    signal buttonClicked

    property string gradientColorStart: {
        switch (buttonColor) {
        case "green":
            return "#03E20F"
        case "red":
            return "#E2033C"
        default:
            return buttonColor
        }
    }

    property string gradientColorStop: {
        switch (buttonColor) {
        case "green":
            return "#03A007"
        case "red":
            return "#A00313"
        default:
            return buttonColor
        }
    }



    style: ButtonStyle {
        background: Rectangle {
            radius: 5
            gradient: Gradient {
                id: bgGradient
                GradientStop {
                    position: 0
                    color: root.gradientColorStart
                }
                GradientStop {
                    position: 1
                    color: root.gradientColorStop
                }
            }
        }
        label: Text {

            text: root.text
            font.pointSize: root.fontSize

            color: "white"
            wrapMode: Text.WordWrap
            font.family: "Arial"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: (containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor)
        onClicked: {
            root.buttonClicked()
        }
    }
}
