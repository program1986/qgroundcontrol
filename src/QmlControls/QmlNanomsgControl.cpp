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

int QmlNanoMsgControl::sendMsg(QString str)
{
    qDebug()<<"sendMsg" << __func__<<__LINE__;
    if (ServiceStart==0)
    {
        printf("Service not Start\r\n");
        return 0;
    }
    qDebug()<<__LINE__;

    QByteArray ba = str.toLatin1(); // must
    char *sendBufferHeader=ba.data();
    qDebug()<<__LINE__<<":"<<client_sock;

    qDebug()<<__LINE__<<":"<<sendBufferHeader;
    nn_send(client_sock, sendBufferHeader, strlen(sendBufferHeader), 0);
    return 0;
}

void QmlNanoMsgControl::receiveData(QString data)
{
    //qDebug() << "received data from server:" << data;
    emit putMessageToQML(data);
}
