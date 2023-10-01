#ifndef QMLNANOMSGCONTROL_H
#define QMLNANOMSGCONTROL_H
#include <QObject>
#include "StateReceiverThread.h"

/**
 * @brief NanoMsg QML 实现
 */

#define BUF_LEN 500

class QmlNanoMsgControl : public QObject
{
    Q_OBJECT

public:
    //explicit QmlNanoMsgControl(QObject *parent = nullptr);
    explicit QmlNanoMsgControl();
    Q_INVOKABLE int aaa();
    Q_INVOKABLE int sendMsg(QString str);

signals:
    /**
     * @brief 将服务器接收的数据发到qml模块
     * @param json 接收到json串
     */
    void putMessageToQML(const QString json);

public slots:
    void receiveData(QString data);

private:
    int ServiceStart = 0;
    int client_sock = 0;
    QThread* thread1;
    StateReceiverThread *receiverThread;
private:

    int StartService();
    int StopService();

    /**
     * @brief StatusRecvThread 状态接收线程
     * @param sock 连接Socket
     * @return
     */
    static int StatusRecvThread(int sock);
};

#endif // QMLNANOMSGCONTROL_H
