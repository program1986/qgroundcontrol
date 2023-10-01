#ifndef STATERECEIVERTHREAD_H
#define STATERECEIVERTHREAD_H

#include <QThread>
#define BUF_LEN 500

class StateReceiverThread : public QThread
{

    Q_OBJECT
public:
    StateReceiverThread(int socket);
public:
    void run() override;

signals:
   void dataReady(QString data);
private:
    int socket = -1 ;


};

#endif // STATERECEIVERTHREAD_H
