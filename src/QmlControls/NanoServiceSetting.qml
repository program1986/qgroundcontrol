/*
 * 服务器地址设置界面
 *
 * 该QML文件用于设置服务器的地址。
 * 用户可以在此界面输入服务器的地址信息，并保存设置。
 *
 * 作者: 史敬威
 * 创建日期: 2022年10月10日
 */


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
        spacing: 10

        // 命令服务器
        property alias ipAddress: ipField.text
        property alias password: portField.text

        //状态服务器
        property alias statusIpAddress: statusIpField.text
        property alias statusPort: statusPortField.text


        x: 0
        y: 144
        width: parent.width
        height: 100
        anchors.left: parent.left
        anchors.right: parent.right
        layer.enabled: false
        anchors.rightMargin: 0
        anchors.leftMargin: 0

        //命令服务器设置
        Label {
            text: "命令服务器设置"
        }

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

        //状态服务器设置

        Label {
            text: "状态服务器设置"
        }

        RowLayout {

            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter // 居中对齐
            Layout.leftMargin: 10 // 设置左边距

            Label {
                text: "IP地址："
            }

            TextField {
                // 输入框属性
                id: statusIpField
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
                id: statusPortField
                Layout.fillWidth: true
            }
        }




        Settings {
            id: settings
            property string ipAddress
            property string port

            property string  statusIpAddress
            property string  statusPort

            function storeSettings() {
                settings.ipAddress = ipField.text
                settings.port = portField.text
                settings.statusIpAddress = statusIpField.text
                settings.statusPort = statusPortField.text
                console.log("storeSettings")
            }

            function loadSettings() {
                ipField.text = settings.ipAddress
                portField.text = settings.port

                statusIpField.text = settings.statusIpAddress
                statusPortField.text = settings.statusPort
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
