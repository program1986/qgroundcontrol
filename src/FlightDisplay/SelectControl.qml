import QtQuick 2.15
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.12
import "CommandStructures.js" as CommandStructures
import QGroundControl 1.0
import QGroundControl.Controls 1.0
import QGroundControl.Controllers 1.0
import QGroundControl.ScreenTools 1.0

Item {
    id:_root
    x: 0
    y: 0
    width: 170
    height: 400

    property int currentStatus
    property SlideButtom locker


    function fixSetChecked(isChecked) {
            fixButton.checked = isChecked
    }

    function fllowSetChecked(isChecked) {
            fllowButton.checked = isChecked
    }

    function hitSetChecked(isChecked) {
            hitButton.checked = isChecked
    }

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
            width: parent.width
            height: parent.height
            spacing: 15

            MyButton{
                id: fullScreen
                text: QGroundControl.videoManager.fullScreen ? "Resume" : "Full"
                implicitWidth: parent.width
                font.pixelSize: 45
                onClicked: {
                    if(text==='Full'){
                            QGroundControl.videoManager.fullScreen=true
                            return
                    }
                    if (text==='Resume') {
                            QGroundControl.videoManager.fullScreen = false
                        return
                    }
                }
            }

            MyButton {
                id: reset
                text: "Reset"
                font.pixelSize: 45
                implicitWidth: parent.width
                onClicked: {
                    var mode = CommandStructures.getModeJson(0)
                    qmlNanoMsgControl.sendMsg(mode)
                    //currentStatus = 0
                    //locker.visible = false

                }
            }

            MyRadioButton {
                id: fixButton
                text: "Fix"
                checked: true
                font.pixelSize: 45
                onClicked: {
                    //var status = CommandStructures.getSetStatusJson(0)
                    //qmlNanoMsgControl.sendMsg(status)

                    currentStatus = 0
                    locker.visible = true
                    locker.hint = "Fix"
                }
            }

            MyRadioButton {
                id:fllowButton
                text: "Fllow"
                checked: false
                font.pixelSize: 45
                onClicked: {
                    //var status = CommandStructures.getSetStatusJson(1)
                    //qmlNanoMsgControl.sendMsg(status)
                    currentStatus = 1
                    locker.visible = true
                    locker.hint = "Fllow"
                }
            }

            MyRadioButton {
                id:hitButton
                text: "Hit"
                checked: false
                font.pixelSize: 45
                onClicked: {
                    //var status = CommandStructures.getSetStatusJson(2)
                    //qmlNanoMsgControl.sendMsg(status)

                    currentStatus = 2
                    locker.visible = true
                    locker.hint = "Hit"

                }
            }
        }
    }
}
