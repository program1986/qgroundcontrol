import QtQuick 2.15
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.12
import "CommandStructures.js" as CommandStructures


Item {
    id:_root
    x: 0
    y: 0
    width: 350
    height: 400
    Rectangle {
        id: rectangle
        radius: 4
        width:parent.width
        height:parent.height
        border.width: 2
        border.color: "#999999"
        color: "#000000"
        Layout.fillWidth: true
        Layout.fillHeight: true
        ColumnLayout {
            id: columnLayout
            x: 0
            y: 0
            width: _root.width
            height: 169
            spacing: 5

            MyButton {
                id: reset
                text: "Reset"
                font.pixelSize: 64
                implicitWidth: parent.width
            }

            MyRadioButton {
                id: nosccan
                text: "NOSCAN"
                checked: true
                font.pixelSize: 64
                onClicked: {
                    var status = CommandStructures.getSetStatusJson(0)
                    qmlNanoMsgControl.sendMsg(status)
                }
            }

            MyRadioButton {
                id:scan
                text: "SCAN"
                checked: false
                font.pixelSize: 64
                onClicked: {
                    var status = CommandStructures.getSetStatusJson(1)
                    qmlNanoMsgControl.sendMsg(status)
                }
            }


        }
    }
}
