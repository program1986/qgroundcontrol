#include "SubscriberThread.h"
#include <nanomsg/nn.h>
#include <nanomsg/pubsub.h>
#include <iostream>

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
          //std::cout << "Received message: " << buf << std::endl;
          emit dataReady(QString(buf));
      }
    }
    nn_close(socket);
}
