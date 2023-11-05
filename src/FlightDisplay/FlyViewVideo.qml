

/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/
import QtQuick 2.12
import QtQuick.Controls 2.0

import QGroundControl 1.0
import QGroundControl.Controls 1.0
import QGroundControl.Controllers 1.0
import QGroundControl.ScreenTools 1.0
import QmlNanoMsgControl 1.0
import QtQuick.LocalStorage 2.0
import Qt.labs.settings 1.0

import "CommandStructures.js" as CommandStructures

Item {
    id: _root
    visible: QGroundControl.videoManager.hasVideo

    //VISBOT_MODE_HOVER 0
    //VISBOT_MODE_TRACK 1
    property string controlStatus: "VISBOT_MODE_HOVER"

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



    //显示跟踪框
    Canvas {
        id: trackRect
        width: parent.width
        height: parent.height

        property int count: 0
        property real trackStartX: 0
        property real trackStartY: 0
        property real trackHeitht: 100
        property real trackWidth: 100
        property var parsedData

        Item {
            id: alarm
            width: parent.width
            height: parent.height

            Rectangle {
                id: dialog
                color: "#80000000"
                x: 0
                y: parent.height / 2
                width: 300
                height: 50
                border.color: "white"
                radius: 10
                visible: false
                anchors.centerIn: parent
                Text {
                    id: dialogText
                    text: ""
                    color: "white"
                    font.pixelSize: 20
                    anchors.centerIn: parent
                }
            }

            function showDialog(text) {
                dialogText.text = text
                dialog.visible = true
            }

            function hideDialog() {
                dialogText.text = ""
                dialog.visible = false
            }
        }

        onPaint: {

            var ctx = getContext('2d')
            ctx.reset()

            // 获取alarminfo
            var alarmInfo = parsedData.data.alarm_info
            if (alarmInfo !== undefined && alarmInfo !== null
                    && alarmInfo !== "") {
                alarm.showDialog(alarmInfo)
            } else {
                alarm.hideDialog()
            }

            //解析Object
            var objectArray = parsedData.data.object_array
            for (var i = 0; i < objectArray.length; i++) {
                var object = objectArray[i]

                var objectId = object.object_id
                var objectName = object.object_name
                var objectConf = object.object_conf
                var rectColor = object.rect_color


                var rectX = object.rect_x

                //y不用重定位
                var rectY = (object.rect_y/720)*parent.height


                var rectWidth = 0
                var rectHeight =0

                /*
                此处需要调整增加x的偏移量。
                算法是
                1） 如果QGroundControl.videoManager.videoSize.height和parent.height都不是0，
                    用parent.height/QGroundControl.videoManager.videoSize.height 得出比例
                    scaleFactor

                2） 用 scaleFactor * QGroundControl.videoManager.videoSize.width 得出目前屏幕实际的
                   realVideoWidth，
                3) （parent.width - realVideoWidth）/2 即x的零偏


                console.log(QGroundControl.videoManager.videoSize.height)
                console.log(parent.height)

                console.log(QGroundControl.videoManager.videoSize.width)
                console.log(parent.width)
                */

                var xOffset = 0
                if (QGroundControl.videoManager.videoSize.height!==0){

                    var scaleFactor=parent.height/QGroundControl.videoManager.videoSize.height
                    var realVideoWidth = scaleFactor*QGroundControl.videoManager.videoSize.width
                    xOffset = (parent.width - realVideoWidth)/2

                    rectWidth = object.rect_width*scaleFactor
                    rectHeight = object.rect_height*scaleFactor

                    console.log("xOffset:",xOffset)

                }


                rectX = xOffset+rectX*scaleFactor;
                //画矩形
                ctx.lineWidth = 5
                ctx.beginPath()
                ctx.strokeStyle = rectColor
                ctx.rect(rectX, rectY, rectWidth, rectHeight)
                ctx.stroke()

                //写文本
                ctx.fillStyle = rectColor
                ctx.font = '44px "PingFang SC",Roboto, sans-serif'

                var text = objectName + "/" + objectConf.toString().slice(0, objectConf.toString().indexOf('.') + 4)
                var textWidth = ctx.measureText(text).width
                var textX = rectX + (rectWidth - textWidth) / 2
                var textY = rectY - 5
                // 调整文本位置
                ctx.fillText(text, textX, textY)

            }

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
            ctx.reset()
            canvas.requestPaint()
        }

        onPaint: {

            var ctx = getContext('2d')
            ctx.reset()
            if (startX == -1)
                return

            ctx.lineWidth = 5
            ctx.strokeStyle = "blue"
            ctx.beginPath()

            //清除屏幕
            ctx.moveTo(startX, startY)
            lastX = area.mouseX
            lastY = area.mouseY

            //画矩形
            ctx.rect(startX, startY, lastX - startX, lastY - startY)
            ctx.stroke()
        }


        MouseArea {
            id: area
            anchors.fill: parent

            property var json

            onPressed: {
                canvas.startX = mouseX
                canvas.startY = mouseY
                console.log("MouseX:",mouseX)
                 console.log("MouseY:",mouseY)
            }
            onPositionChanged: {
                canvas.requestPaint()
            }
            onReleased: {
                if (Math.abs(canvas.startX - mouseX) > 10 && Math.abs(
                            canvas.startY - mouseY) > 10)

                {
                    //todo: 增加sx的偏移计算
                    var sx = Math.min(canvas.startX, mouseX)
                    console.log("sx:",sx)
                    var tmpy=Math.min(canvas.startY, mouseY)
                    var sy = (tmpy/parent.height)*720
                    var rect_width = 0
                    var rect_height = 0
                    var xOffset = 0

                    if (QGroundControl.videoManager.videoSize.height!==0){

                        var scaleFactor=parent.height/QGroundControl.videoManager.videoSize.height
                        var realVideoWidth = scaleFactor*QGroundControl.videoManager.videoSize.width
                        xOffset = (parent.width - realVideoWidth)/2
                        console.log("xOffset:",xOffset)

                    }



                    sx = sx/scaleFactor -xOffset
                    if (sx<0 ) {
                        sx = xOffset
                    }
                    //求宽高
                    rect_width = Math.abs(canvas.startX - mouseX)/scaleFactor
                    rect_height = Math.abs(canvas.startY - mouseY)/scaleFactor

                    CommandStructures.setSendCheck(
                                CommandStructures.SendCheckJsonObject,
                                sx, sy, rect_width, rect_height)
                    json = JSON.stringify(CommandStructures.SendCheckJsonObject)
                    console.log(json)

                    qmlNanoMsgControl.sendMsg(json)

                }
                canvas.startX = -1
                canvas.requestPaint()
            }
        }

    }

    /*
    Button{
        height: 300
        width:300
        text:"Click"
        onClicked: {
            console.log(QGroundControl.videoManager.videoSize.height)
            console.log(parent.height)

            console.log(QGroundControl.videoManager.videoSize.width)
            console.log(parent.width)

        }
    }
    */

    ProximityRadarVideoView {
        anchors.fill: parent
        vehicle: QGroundControl.multiVehicleManager.activeVehicle
    }

    ObstacleDistanceOverlayVideo {
        id: obstacleDistance
        showText: pipState.state === pipState.fullState
    }

    QmlNanoMsgControl {
        id: qmlNanoMsgControl
        Component.onCompleted: {
            console.log("QmlNanoMsgControl load completed!")
            console.log("address:" + settings.ipAddress + " " + "port" + settings.port)
            qmlNanoMsgControl.startService(settings.ipAddress, settings.port)
        }
    }

    //publish 接收函数
    QmlNanoMsgControl {
        id: publisherMsgControl
        Component.onCompleted: {
            console.log("publisherMsgControl load completed!")
            //console.log(settings.ipAddress)
            console.log("status address:" + settings.statusIpAddress + " "
                        + "port" + settings.statusPort)
            publisherMsgControl.connectPunlisher(settings.statusIpAddress,
                                                 settings.statusPort)
        }

        onPutMessageToQML: {
            //print("json from server="+json)
            var parsedData = JSON.parse(json)
            trackRect.parsedData = parsedData

            //console.log("controlStatus="+controlStatus)
            //console.log("parsedData.cmd="+parsedData.cmd)
            //跟踪框
            if (parsedData.cmd===1)
            {
                trackRect.requestPaint()
            }

            if (parsedData.cmd===2)
            {
                console.log("mode="+parsedData.data.mode)
                if (parsedData.data.mode===0)
                {

                    controlStatus = "VISBOT_MODE_HOVER"
                }

                if (parsedData.data.mode===1)
                {

                    controlStatus = "VISBOT_MODE_TRACK"
                }
            }
        }
    }


    //VISBOT_MODE_HOVER 0
    //VISBOT_MODE_TRACK 1
    SelectControl {

        id: selectControl
        x: _root.width - selectControl.width
        //anchors.centerIn: parent
        anchors.top: parent.top
        anchors.right: parent.right
        //y: 180
        visible: controlStatus === "VISBOT_MODE_TRACK" // 如果状态为 "select"，显示 SelectControl
    }

    InitialControl {
        id: initialControl
        x: _root.width - selectControl.width
        //anchors.centerIn: parent
        //y: 180
        anchors.top: parent.top
        anchors.right: parent.right
        visible: controlStatus === "VISBOT_MODE_HOVER" // 如果状态为 "initial"，显示 InitialControl
    }

    //增加进入全屏的按钮

    /*
    Button {
        width: 400
        height:400
        onClicked: {
            //QGroundControl.videoManager.setfullScreen = true
            //QGroundControl.settingsManager.flyViewSettings.
            console.log(QGroundControl.videoManager.videoSize.width)
            console.log(parent.height)
            QGroundControl.videoManager.fullScreen=true
            console.log(QGroundControl.videoManager.fullScreen)
        }

    }*/




    Settings {
        id: settings
        property string ipAddress
        property string port
        property string statusIpAddress
        property string statusPort
    }


}
