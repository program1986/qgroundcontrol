import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.LocalStorage 2.0
import Qt.labs.settings 1.0


Item {
    visible: true


    Column {
        spacing: 10
        anchors.centerIn: parent

        property alias ipAddress: ipField.text
        property alias password: portField.text


        Row {
            Label {
                text: "Ip地址："
                color:"white"
            }

            TextField {
                // 输入框属性
                id: ipField
            }
        }

        Row {
            Label {
                text: "端口号："
                color:"white"
            }

            TextField {
                // 输入框属性
                id: portField


            }
        }

        Row {
            Button {
                text: "确定"
            }

            Button {
                text: "取消"
                // 按钮属性
            }
        }



        Settings {
                id: settings
                property string ipAddress
                property string port

                function storeSettings()
                {
                    settings.ipAddress = ipField.text
                    settings.port = portField.text
                    console.log("storeSettings")

                }

                function loadSettings()
                {
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
