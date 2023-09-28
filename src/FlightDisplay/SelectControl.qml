import QtQuick 2.15
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.12
Item {
    Rectangle {
        id: rectangle
        x: 0
        y: 0
        width:  77
        height: 208
        radius:5
        border.width:2
        border.color:"#999999"

        ColumnLayout {
            id: columnLayout
            anchors.fill: parent

            Button{
                id: buttonReset
                Layout.fillWidth: true
                text: qsTr("Reset")
            }

            RadioButton {
                id: radioButtonFix
                text: qsTr("Fix")
            }

            RadioButton {
                id: radioButtonFllow
                text: qsTr("Fllow")
            }

            RadioButton {
                id: radioButtonHit
                text: qsTr("Hit")
            }
        }


    }

}
