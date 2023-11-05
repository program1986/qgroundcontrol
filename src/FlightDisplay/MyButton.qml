import QtQuick 2.15
import QtQuick.Controls 2.1

Button {
    id: control
    text: qsTr("Button")

    contentItem: Text {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        //color: control.down ? "#17a81a" : "#21be2b"
        color: control.down ? "#999999" : "#ffffff"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        //implicitWidth: 100
        //implicitHeight: 40
        opacity: enabled ? 0 : 0.3
        color: control.down ? "#999999" : "#ffffff"
        //border.color: control.down ? "#17a81a" : "#21be2b"
        border.width: 1
        radius: 2
    }
}
