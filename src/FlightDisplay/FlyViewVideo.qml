

/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/
import QtQuick 2.12

import QGroundControl 1.0
import QGroundControl.Controls 1.0
import QGroundControl.Controllers 1.0
import QGroundControl.ScreenTools 1.0
import QmlNanoMsgControl 1.0

import "CommandStructures.js" as CommandStructures

Item {
    id: _root
    visible: QGroundControl.videoManager.hasVideo

    property Item pipState: videoPipState
    QGCPipState {
        id: videoPipState
        pipOverlay: _pipOverlay
        isDark: true

        onWindowAboutToOpen: {
            QGroundControl.videoManager.stopVideo()
            videoStartDelay.start()
        }

        onWindowAboutToClose: {
            QGroundControl.videoManager.stopVideo()
            videoStartDelay.start()
        }

        onStateChanged: {
            if (pipState.state !== pipState.fullState) {
                QGroundControl.videoManager.fullScreen = false
            }
        }
    }

    Timer {
        id: videoStartDelay
        interval: 2000
        running: false
        repeat: false
        onTriggered: QGroundControl.videoManager.startVideo()
    }

    //-- Video Streaming
    FlightDisplayViewVideo {
        id: videoStreaming
        anchors.fill: parent
        useSmallFont: _root.pipState.state !== _root.pipState.fullState
        visible: QGroundControl.videoManager.isGStreamer
    }
    //-- UVC Video (USB Camera or Video Device)
    Loader {
        id: cameraLoader
        anchors.fill: parent
        visible: !QGroundControl.videoManager.isGStreamer
        source: QGroundControl.videoManager.uvcEnabled ? "qrc:/qml/FlightDisplayViewUVC.qml" : "qrc:/qml/FlightDisplayViewDummy.qml"
    }

    QGCLabel {
        text: qsTr("Double-click to exit full screen")
        font.pointSize: ScreenTools.largeFontPointSize
        visible: QGroundControl.videoManager.fullScreen
                 && flyViewVideoMouseArea.containsMouse
        anchors.centerIn: parent

        onVisibleChanged: {
            if (visible) {
                labelAnimation.start()
            }
        }

        PropertyAnimation on opacity {
            id: labelAnimation
            duration: 10000
            from: 1.0
            to: 0.0
            easing.type: Easing.InExpo
        }
    }

    //新增的按钮功能 reset/fix/fllow/hit  其中后3个是互斥开关。



    Canvas {
        id: canvas
        width: parent.width
        height: parent.height

        property real startX
        property real startY
        property real lastX
        property real lastY


        //清除屏幕
        function clear() {
                    var ctx = getContext('2d')
                    ctx.reset();
                    canvas.requestPaint();
                }


        onPaint: {

            var ctx = getContext('2d')
            ctx.reset();

            ctx.lineWidth = 5
            ctx.strokeStyle = "blue"
            ctx.beginPath()

            //清除屏幕

            ctx.moveTo(startX, startY)
            lastX = area.mouseX
            lastY = area.mouseY

            //画矩形
            ctx.rect(startX,startY,lastX-startX,lastY-startY);
            ctx.stroke();

        }

        //QmlNanoMsgControl
        //{
        //      id: qmlNanoMsgControl
        //}

        MouseArea {
            id: area
            anchors.fill: parent

            property var json

            onPressed: {
                canvas.startX = mouseX
                canvas.startY = mouseY
                console.log("MouseX")
            }
            onPositionChanged: {
                canvas.requestPaint()
            }
            onReleased: {
                CommandStructures.setSendCheck(CommandStructures.SendCheckJsonObject,canvas.startX,canvas.startY,mouseX,mouseY)
                json = JSON.stringify(CommandStructures.SendCheckJsonObject)
                console.log(json)
                qmlNanoMsgControl.sendMsg(json)
            }


        }


    }



    ProximityRadarVideoView {
        anchors.fill: parent
        vehicle: QGroundControl.multiVehicleManager.activeVehicle
    }

    ObstacleDistanceOverlayVideo {
        id: obstacleDistance
        showText: pipState.state === pipState.fullState
    }





}
