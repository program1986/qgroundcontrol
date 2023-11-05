import QtQuick 2.15
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.12
import "CommandStructures.js" as CommandStructures


Item {
    id:_root
    x: 0
    y: 0
    width: 300
    height: 400
    Rectangle {
        id: rectangle
        radius: 4
        width:parent.width
        height:parent.height
        border.width: 2
        border.color: "#999999"
        color: "#000000"
        opacity:1
        Layout.fillWidth: true
        Layout.fillHeight: true
        ColumnLayout {
            id: columnLayout
            x: 0
            y: 0
            width: _root.width
            height: 300
            spacing: 5

            MyButton {
                id: reset
                text: "Reset"
                font.pixelSize: 50
                implicitWidth: parent.width
                onClicked: {
                    var mode = CommandStructures.getModeJson(0)
                    qmlNanoMsgControl.sendMsg(mode)
                }
            }

            MyRadioButton {
                id: fixButton
                text: "Fix"
                checked: true
                font.pixelSize: 50
                onClicked: {
                    var status = CommandStructures.getSetStatusJson(0)
                    qmlNanoMsgControl.sendMsg(status)
                }
            }

            MyRadioButton {
                text: "Fllow"
                checked: false
                font.pixelSize: 50
                onClicked: {
                    var status = CommandStructures.getSetStatusJson(1)
                    qmlNanoMsgControl.sendMsg(status)
                }
            }

            MyRadioButton {
                text: "Hit"
                checked: false
                font.pixelSize: 50
                onClicked: {
                    var status = CommandStructures.getSetStatusJson(2)
                    qmlNanoMsgControl.sendMsg(status)
                }
            }
        }
    }
}
