import QtQuick 2.15
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.12
import "CommandStructures.js" as CommandStructures
//import QmlNanoMsgControl 1.0


Item {
    Rectangle {
        id: rectangle
        x: 0
        y: 0
        width:  150
        height: 250
        radius:4
        border.width:2
        border.color:"#999999"
        color:"#000000"


        //QmlNanoMsgControl
        //{
        //      id: qmlNanoMsgControl
        //}

        ColumnLayout {
            id: columnLayout
            x: 0
            y: 0
            width: rectangle.width
            height: 169
            spacing: 5
            //anchors.fill: parent

            /*
            Button{
                id: buttonReset
                Layout.fillWidth: true
                text: qsTr("Reset")

            }
            */

            MyButton{
                id: reset
                text:"Reset"
                font.pixelSize: 36
                implicitWidth: parent.width
            }

            MyRadioButton{
                id: fixButton
                text:"Fix"
                checked: true
                font.pixelSize: 36
                onClicked:
                {
                    var status=CommandStructures.getSetStatusJson(0)
                    qmlNanoMsgControl.sendMsg(status)

                }
            }

           MyRadioButton{
                text:"Fllow"
                checked: false
                font.pixelSize: 36
                onClicked:
                {
                    var status=CommandStructures.getSetStatusJson(1)
                    qmlNanoMsgControl.sendMsg(status)
                }
            }

            MyRadioButton{
                text:"Hit"
                checked: false
                font.pixelSize: 36
                onClicked: {
                    var status=CommandStructures.getSetStatusJson(2)
                    qmlNanoMsgControl.sendMsg(status);
                }
            }


          }

    }

}
