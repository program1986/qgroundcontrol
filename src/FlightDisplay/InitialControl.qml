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
    width: 220
    height: 350
    property int currentStatus
    property SlideButtom locker

    function scanSetChecked(isChecked) {
            scan.checked = isChecked
    }

    function noScanSetChecked(isChecked) {
            noscan.checked = isChecked
    }

    //property alias scanSetChecked: scanSetChecked

    Rectangle {
        id: rectangle
        radius: 4
        width:parent.width
        height:parent.height
        border.width: 2
        border.color: "#999999"
        color: "#000000"
        opacity: 1
        Layout.fillWidth: true
        Layout.fillHeight: true


        ColumnLayout {
            id: columnLayout
            x: 0
            y: 0
            width: _root.width
            height: parent.height
            spacing: 15

            MyButton{
                id: fullScreen
                text: QGroundControl.videoManager.fullScreen ? "Resume" : "Full"
                implicitWidth: parent.width
                font.pixelSize: 50
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
                font.pixelSize: 50
                implicitWidth: parent.width
            }

            MyRadioButton {

                id: noscan
                text: "NoScan"
                checked: true
                font.pixelSize: 50
                onClicked: {
                    //var status = CommandStructures.getSetStatusJson(0)
                    //qmlNanoMsgControl.sendMsg(status)
                    locker.visible = true
                    currentStatus = 0
                }


            }

            MyRadioButton {
                id:scan
                text: "Scan"
                checked: false
                font.pixelSize: 50
                onClicked: {
                    locker.visible = true
                    currentStatus = 1
                    //var status = CommandStructures.getSetStatusJson(1)
                    //qmlNanoMsgControl.sendMsg(status)

                }


            }


        }


    }


}
