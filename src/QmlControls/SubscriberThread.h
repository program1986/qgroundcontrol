#ifndef SUBSCRIBERTHREAD_H
#define SUBSCRIBERTHREAD_H
#include <QThread>
#include <QObject>

class SubscriberThread : public QThread
{
    Q_OBJECT
public:
    SubscriberThread(int sock);

private:
    void receive();

    // QThread interface
public:
    void run() override;

private:
    int socket = -1 ;

signals:
    void dataReady(QString jsonString );
};

#endif // SUBSCRIBERTHREAD_H
