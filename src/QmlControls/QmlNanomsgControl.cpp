#include "QmlNanomsgControl.h"
#include <nanomsg/bus.h>
#include <nanomsg/nn.h>
#include <nanomsg/pair.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <QDebug>
#include <QString>
#include <iostream>
#include <thread>
#include "StateReceiverThread.h"
#include <nanomsg/nn.h>
#include <nanomsg/pubsub.h>
#include <nanomsg/reqrep.h>

#define VBT_MSGID_COMMON_BASE                      (0x100)
#define VBT_MSGID_COMMON_STATUS                    (VBT_MSGID_COMMON_BASE | 0x00)
#define VBT_MSGID_COMMON_RESTART                   (VBT_MSGID_COMMON_BASE | 0x01)
#define VBT_MSGID_COMMON_SHUTDOWN                  (VBT_MSGID_COMMON_BASE | 0x02)
#define VBT_MSGID_COMMON_FORCEEXIT                 (VBT_MSGID_COMMON_BASE | 0x03)
#define VBT_MSGID_JSON                             (VBT_MSGID_COMMON_BASE | 0x1F)
#define VBT_MSGID_USER_BASE                        (VBT_MSGID_COMMON_BASE | 0x20)
#define VBT_MSGID_USER(user_id)                    (VBT_MSGID_USER_BASE + user_id)


QmlNanoMsgControl::QmlNanoMsgControl()

{

}

int QmlNanoMsgControl::aaa()
{
    qDebug()<<"hello";
    return 0;
}

 int aaa()
{
    return 0;
}


int QmlNanoMsgControl::StopService()
{
    ServiceStart = 0;
    return 0;
}

int QmlNanoMsgControl::startService(QString host, int port)
{
    char url[255];

    //char *url = (char*)"tcp://127.0.0.1:2021";
    QByteArray baHost = host.toLatin1();

    sprintf (url,"tcp://%s:%d",baHost.data(),port);

    printf("connect string=%s\n",url);
    client_sock = nn_socket(AF_SP, NN_REQ);
    if (client_sock  < 0)
    {
        printf("create server socket failed!\n");
        return -1;
    }

    if (nn_connect(client_sock, url) < 0) {
        printf("connect server sock failed!\r\n");
        nn_close(client_sock);
        return -1;
    }

    // 创建状态接收线程实例
    //receiverThread = new StateReceiverThread(client_sock);
    //receiverThread->start();

    //连接槽函数
    //QObject::connect(receiverThread, &StateReceiverThread::dataReady, this, &QmlNanoMsgControl::receiveData);

    qDebug()<<"client init success!\n";
    ServiceStart =1;
    return 0;
}

int QmlNanoMsgControl::connectPunlisher(QString host, int port)
{
    char url[255];

    QByteArray baHost = host.toLatin1();

    sprintf (url,"tcp://%s:%d",baHost.data(),port);

    printf("public connect string=%s\n",url);
    publishClientSocket = nn_socket(AF_SP, NN_SUB);
    if (publishClientSocket  < 0)
    {
        printf("Create subscriber socket failed!\n");
        return -1;
    }

    if (nn_connect(publishClientSocket, url) < 0) {
        printf("Connect publish server failed!\r\n");
        nn_close(publishClientSocket);
        return -1;
    }

    // 发布接收函数
    subscriberThread = new SubscriberThread(publishClientSocket);
    subscriberThread->start();

    //连接槽函数
    QObject::connect(subscriberThread, &SubscriberThread::dataReady, this, &QmlNanoMsgControl::receiveData);

    qDebug()<<"client init success!\n";
    ServiceStart = 1;
    return 0;

}

int QmlNanoMsgControl::StatusRecvThread(int sock)
{
    int rv;
    char buf[BUF_LEN];

    while(1)
    {
        int bytes;
        bytes = nn_recv(sock, &buf, NN_MSG, 0);
        if(bytes)
        {
            QString str(buf);
            //emit putMessageToQML(str);
        }
    }

    return (nn_shutdown(sock, rv));
}

int QmlNanoMsgControl::SendJsonCmd(QString jsonString)
{

    struct VBT_ReqInfo {
        uint16_t sender;
        uint16_t flag;
        uint16_t req_cmd;
        uint16_t req_info_size;
        uint8_t  req_info_data[];
    };

    struct VBT_ReqResult {
        uint16_t ret_code;  //512 ok
        uint16_t ret_info_size;
        uint8_t  ret_info_data[];
    };

    std::string json_str = jsonString.toStdString();;
    size_t json_str_len = jsonString.length();
    int             in_size=sizeof(VBT_ReqInfo) + json_str_len;
    VBT_ReqInfo     *in_call = (VBT_ReqInfo *)alloca(in_size);
    //int             out_size=0;
    //VBT_ReqResult   *out_ret;

    in_call->sender = (uint16_t)0;
    in_call->flag = (uint16_t)0;
    in_call->req_cmd = (uint16_t)VBT_MSGID_JSON;
    in_call->req_info_size = json_str_len;
    int8_t *detail = reinterpret_cast<int8_t *>(in_call->req_info_data);
    if(json_str_len > 0) memcpy(detail,json_str.data(),json_str_len);


    //out_ret = (VBT_ReqResult *)msg_request(&m_service_handle,(char *)in_call,in_size,&out_size,300);

    nn_send(client_sock, (char *)in_call,in_size, 0);

      /*if(out_ret ) {
        if(out_ret->ret_code == ApiSuccess && out_ret->ret_info_size > 0) {
            std::string errs;
            std::unique_ptr<Json::CharReader> const jsonReader(m_json_parser.newCharReader());
            bool res = jsonReader->parse((char *)out_ret->ret_info_data, (char *)out_ret->ret_info_data + out_ret->ret_info_size
                                         , &res_json, &errs);
            if (res && errs.empty()) {
                ret = (RETURN_CODE)out_ret->ret_code;
            }
        }
    */
    //nn_freemsg(buf);
    //nn_freemsg((char *)out_ret);

    return 0;


}


int QmlNanoMsgControl::sendMsg(QString str)
{



    qDebug()<<"sendMsg" << __func__<<__LINE__;
    if (ServiceStart==0)
    {
        printf("Service not Start\r\n");
        return 0;
    }

    SendJsonCmd(str);
    return 0;

    /*
    QByteArray ba = str.toLatin1();
    char *sendBufferHeader=ba.data();
    //增加发送头

    int json_str_len = str.length();

    int             in_size=sizeof(VBT_ReqInfo) + json_str_len;
    VBT_ReqInfo     *in_call = (VBT_ReqInfo *)alloca(in_size);

    in_call->sender = (uint16_t)0;
    in_call->flag = (uint16_t)0;
    in_call->req_cmd = (uint16_t)0x11F;
    in_call->req_info_size = json_str_len;
    int8_t *detail = reinterpret_cast<int8_t *>(in_call->req_info_data);
    if(json_str_len > 0) memcpy(detail,sendBufferHeader,json_str_len);

    nn_send(client_sock, detail, in_size, 0);

    //return nn_freemsg(detail);

    return 0;
    */
}

void QmlNanoMsgControl::receiveData(QString json)
{

    emit putMessageToQML(json);

}
