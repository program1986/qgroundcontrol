#include "SubscriberThread.h"
#include <nanomsg/nn.h>
#include <nanomsg/pubsub.h>
#include <iostream>
#include <QDebug>

SubscriberThread::SubscriberThread(int sock):socket(sock)
{

}

void SubscriberThread::run()
{
    if (this->socket==-1) return ;
    std::cout << "Received run " << std::endl;
    receive();
    return ;
}

void SubscriberThread::receive()
{

    // 订阅所有消息
    nn_setsockopt(socket, NN_SUB, NN_SUB_SUBSCRIBE, "", 0);
    char buf[4096] = {0};
    while (true) {
        memset(buf,0,4096);
      int bytes = nn_recv(socket, buf, sizeof(buf), 0);
      if (bytes > 0) {
          //返回给qml
          //std::cout << "Received message: " << bytes << std::endl;
          //const QByteArray& buffer = QByteArray(buf);
          // 在这里转换成QString

          struct VBT_ReqInfo {
              uint16_t sender;
              uint16_t flag;
              uint16_t req_cmd;
              uint16_t req_info_size;
              uint8_t  req_info_data[];
          };

          const VBT_ReqInfo* reqInfo = (VBT_ReqInfo*)buf;
          QString reqInfoDataString = QString::fromUtf8((char*)(reqInfo->req_info_data));

          //qDebug()<<"String from Server:"<<reqInfoDataString;

          emit dataReady(reqInfoDataString);
      }
    }
    nn_close(socket);
}
