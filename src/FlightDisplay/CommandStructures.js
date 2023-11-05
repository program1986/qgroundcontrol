.pragma library


/*
### 命令列表
+ 1: SEND_CHECK   //发送检查框信息
+ 2: SET_MODE     //设置当前模式
+ 3: SET_STATUS   //设置当前状态
+ 4: GET_STATUS   //查询当前模式&状态
*/
const CommandList = {
    "SEND_CHECK": 1, //发送检查框信息
    "SET_MODE"
    : 2, //设置当前模式
    "SET_STATUS"
    : 3, //设置当前状态
    "GET_STATUS"
    : 4 //查询当前模式&状态
}


/* ---------------------------- SEND_CHECK --------------------------------------

命令ID：SEND_CHECK
说明：该命令向无人机发送检查区域Rect，当无人机处于Hover模式下收到该消息，会自动切换到Track模式/FixPoint状态，
其中rect_width/rect_height小于等于0时表示无框

1、请求msg （控制站发向无人机）
{
  header: 1234,    //服务ID
  serial: 0,       //请求序列号
  cmd: 1,          //命令ID
  param: {
    rect_x: 0,
    rect_y: 0,
    rect_width: 100,
    rect_height: 100
  }
}

2、回复msg （无人机发现控制站）
{
  header: 1234,    //服务ID
  serial: 0,       //请求序列号
  code: 512        //512:成功  >512:失败
};
*/
var SendCheckJsonObject = {
    "header": null, //服务ID
    "serial": null, //请求序列号
    "cmd": CommandList.SEND_CHECK, //命令ID
    "param"
    : {
        "rect_x": 0,
        "rect_y": 0,
        "rect_width": 0,
        "rect_height": 0
    }
}


/*---------------------- SET_MODE --------------------------------
命令ID：SET_MODE
说明：该命令向无人机发送设置模式命令，对于RESET操作，实现时对应时将模式设为Hover模式

1、请求msg
{
  header: 1234,    //服务ID
  serial: 5,       //请求序列号
  cmd: 2，         //命令ID
  param: {
    mode: 0 //0:Free自由模式 1:Track跟踪模式
  }
}

2、回复msg
{
  header: 1234,    //服务ID
  serial: 5,       //请求序列号
  code: 512        //512:成功  >512:失败
}


--------------------------SET_MODE ---------------------------------------------*/
var SetModeJsonObject = {
    "header": null,
    "serial"//服务ID
    : null,
    "cmd"//请求序列号
    : CommandList.SET_MODE,
    "param"//命令ID
    : {
        "mode": 0 //0:Free自由模式 1:Track跟踪模式
    }
}

/*---------------------SET_STATUS --------------------------------
1、请求msg

var SetModeJsonObject = {
  header: 1234,    //服务ID
  serial: 5,       //请求序列号
  cmd: 3,          //命令ID
  data: {
    status:0       //在跟踪模式下0:FixPoint 1:Follow 2:Hit
  }
}

2、回复msg

{
  header: 1234,    //服务ID
  serial: 5,       //请求序列号
  code: 512        //512:成功  >512:失败
}
----------------  SET_STATUS ------------------*/

var SetStatusJsonObject = {
  header: 1234,    //服务ID
  serial: 5,       //请求序列号
  cmd: CommandList.SET_STATUS,          //命令ID
  param: {
    status:0       //在跟踪模式下0:FixPoint 1:Follow 2:Hit
  }
}

/*----------- GET_STATUS -------------------------
命令ID：GET_STATUS
1、请求msg

{
  header: 1234,    //服务ID
  serial: 5,       //请求序列号
  cmd: 4           //命令ID
}

2、回复msg
{
  header: 1234,    //服务ID
  serial: 5,       //请求序列号
  code: 512,       //512:成功  >512:失败
  data: {
    mode: 0,       //0:Hover悬停模式 1:Track跟踪模式
    status:0       //不同模式下状态有不同含义，在跟踪模式下0:FixPoint 1:Follow 2:Hit
  }
}
-----------------GET_STATUS----------------------------------*/

var GetStatusJsonObject = {
  header: 1234,    //服务ID
  serial: 5,       //请求序列号
  cmd: CommandList.GET_STATUS           //命令ID
}


var sendCheckSerial =0;
var setStatusSerial =0;
var setModeSerial =0;

function setSendCheck(SendCheckJsonObject,startX,startY,width,height)
{

    SendCheckJsonObject.header = 1234
    SendCheckJsonObject.serial = sendCheckSerial
    SendCheckJsonObject.param.rect_x = startX
    SendCheckJsonObject.param.rect_y = startY
    SendCheckJsonObject.param.rect_width = width
    SendCheckJsonObject.param.rect_height = height
    sendCheckSerial++
}


function getSetStatusJson(status)
{

    SetStatusJsonObject.header = 1234
    SetStatusJsonObject.serial = setStatusSerial
    SetStatusJsonObject.param.status = status
    setStatusSerial++
    return JSON.stringify(SetStatusJsonObject)

}

function getModeJson(mode)
{
    SetModeJsonObject.head = 1234
    SetModeJsonObject.serial = setModeSerial
    SetStatusJsonObject.param.status = mode
    setModeSerial++
    return JSON.stringify(SetModeJsonObject)
}

// 导出结构定义
module.exports = {
    "SendCheckJsonObject": SendCheckJsonObject,
    "SetModeJsonObject": SetModeJsonObject,
    "SetStatusJsonObject": SetStatusJsonObject,
    "GetStatusJsonObject":GetStatusJsonObject
}
