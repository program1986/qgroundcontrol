#include "StateReceiverThread.h"
#include <nanomsg/bus.h>
#include <nanomsg/nn.h>
#include <nanomsg/pair.h>

#include <QDebug>

StateReceiverThread::StateReceiverThread(int socket)
{
    this->socket = socket;
}

void StateReceiverThread::run()
{

    if (this->socket==1) return ;

    int rv;
    char buf[BUF_LEN];

    while(1)
    {
        int bytes;
        bytes = nn_recv(this->socket, buf, BUF_LEN, 0);
        if(bytes)
        {
            //const QByteArray& buffer = QByteArray(buf);
            emit dataReady(buf,bytes);
        }
    }
    nn_shutdown(this->socket, rv);
    return ;
}


