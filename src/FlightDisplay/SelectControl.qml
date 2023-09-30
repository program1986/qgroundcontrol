import QtQuick 2.15
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.12

//import QmlNanoMsgControl 1.0


Item {
    Rectangle {
        id: rectangle
        x: 0
        y: 0
        width:  77
        height: 169
        radius:5
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
            spacing: 0
            ///anchors.fill: parent

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
                implicitWidth: parent.width
            }

            MyRadioButton{
                id: fixButton
                text:"Fix"
                checked: true
                font.pixelSize: 12
            }

           MyRadioButton{
                text:"Fllow"
                checked: false
                font.pixelSize: 12
            }

            MyRadioButton{
                text:"Hit"
                checked: false
                font.pixelSize: 12
            }

            //fix


            /*
            RadioButton {
                id: radioButtonFix
                text: qsTr("Fix")

                contentItem: Text{
                            text: parent.text
                            color: "red"
                }

                onCanceled: {
                    qmlNanoMsgControl.sendMsg("xxxx");
                }
            }


            RadioButton {
                id: radioButtonFllow
                text: qsTr("Fllow")
            }

            RadioButton {
                id: radioButtonHit
                text: qsTr("Hit")
            }
*/
          }

    }

}
