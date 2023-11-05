import QtQuick 2.15
import QtQuick.Controls 2.1

RadioButton {
    id: control
    text: qsTr("RadioButton")
    checked: true


    indicator: Rectangle {
        implicitWidth: 26
        implicitHeight: 26
        x: control.leftPadding
        y: parent.height / 2 - height / 2
        radius: 13
        border.color: control.down ? "#17a81a" : "#21be2b"
        //color: control.down ? "#999999" : "#ffffff"
        Rectangle {
            width: 14
            height: 14
            x: 6
            y: 6
            radius: 7
            //color: control.down ? "#17a81a" : "#21be2b"
            color: control.down ? "#999999" : "#ffffff"
            visible: control.checked
        }
    }

    contentItem: Text {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        //color: control.down ? "#17a81a" : "#21be2b"
        color: control.down ? "#999999" : "#ffffff"
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
    }
}
