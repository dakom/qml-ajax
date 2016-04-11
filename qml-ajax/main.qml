import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 1.5
import "qml/helpers"
import "qrc:/js/config.js" as Config

Window {
    id: root
    width: 1000
    height: 700
    property string currentView: "Start"
    visible: true

    Component.onCompleted: {
        Config.API.init({
                            loadView: root.loadView,
                            showStatusWait: statusDialog.showWait,
                            showStatusCode: statusDialog.showStatusCode
                        })
        loadView(currentView)
    }

    function loadView(viewName) {
        currentView = viewName

        loader.setSource("qrc:/qml/views/" + viewName + ".qml")
    }

    function closeStatus() {
        statusDialog.state = "Hidden"
    }

    Loader {
        id: loader
        anchors.fill: parent
        onLoaded: {
            loader.item.hasLoaded()
        }
    }

    StatusDialog {
        id: statusDialog
        z: 100
        anchors.fill: parent
    }
}
