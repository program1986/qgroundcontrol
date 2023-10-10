import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.LocalStorage 2.0
import Qt.labs.settings 1.0
import QtQuick.Controls.Material 2.0
import QtQuick.Layouts 1.12

Item {
    id: item1
    visible: true

    Rectangle {
        x: 0
        y: 0

        width: parent.width
        height: parent.height
        color: "white"
    }
    ColumnLayout {
        spacing: 37

        property alias ipAddress: ipField.text
        property alias password: portField.text
        x: 0
        y: 144
        width: parent.width
        height: 100
        anchors.left: parent.left
        anchors.right: parent.right
        layer.enabled: false
        anchors.rightMargin: 0
        anchors.leftMargin: 0

        RowLayout {

            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter // 居中对齐
            Layout.leftMargin: 10 // 设置左边距

            Label {
                text: "Ip地址："
            }

            TextField {
                // 输入框属性
                id: ipField
                Layout.fillWidth: true
            }
        }

        RowLayout {

            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter // 居中对齐
            Layout.leftMargin: 10 // 设置左边距

            Label {
                text: "端口号："
            }

            TextField {
                // 输入框属性
                id: portField
                Layout.fillWidth: true
            }
        }

        Settings {
            id: settings
            property string ipAddress
            property string port

            function storeSettings() {
                settings.ipAddress = ipField.text
                settings.port = portField.text
                console.log("storeSettings")
            }

            function loadSettings() {
                ipField.text = settings.ipAddress
                portField.text = settings.port
            }
        }

        Component.onCompleted: {
            settings.loadSettings()
        }

        Component.onDestruction: {
            settings.storeSettings()
        }
    }
}
