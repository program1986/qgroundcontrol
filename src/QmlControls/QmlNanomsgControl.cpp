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

QmlNanoMsgControl::QmlNanoMsgControl()

{
    if (ServiceStart==0)
    {
        StartService();
    }

    printf("Service  Start\r\n");
    ServiceStart =1;
}

int QmlNanoMsgControl::aaa()
{
    qDebug()<<"hello";
    return 0;
}

int QmlNanoMsgControl::StartService()
{
    char *url = (char*)"tcp://192.168.0.104:2021";
    client_sock = nn_socket(AF_SP, NN_PAIR);
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

    printf("client init success!\n");

    return 0;
}

int QmlNanoMsgControl::StopService()
{
    ServiceStart = 0;
    return 0;
}

int QmlNanoMsgControl::sendMsg(QString str)
{
    if (ServiceStart==0)
    {
        printf("Service not Start\r\n");
        return 0;
    }
    QByteArray ba = str.toLatin1(); // must
    char *sendBufferHeader=ba.data();


    /*if (nn_send(client_sock, sendBufferHeader, sizeof(sendBufferHeader), 1) < 0) {
        printf("send failed!\r\n");
        nn_close(client_sock);
        return -1;
    }
    */
    nn_send(client_sock, sendBufferHeader, sizeof(sendBufferHeader), 1);
    return 0;
}
