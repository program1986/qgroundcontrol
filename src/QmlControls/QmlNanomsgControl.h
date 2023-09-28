#ifndef QMLNANOMSGCONTROL_H
#define QMLNANOMSGCONTROL_H
#include <QObject>

/**
 * @brief NanoMsg QML 实现
 */

#define BUF_LEN 100

class QmlNanoMsgControl : public QObject
{
    Q_OBJECT

public:
    //explicit QmlNanoMsgControl(QObject *parent = nullptr);
    explicit QmlNanoMsgControl();
    Q_INVOKABLE int aaa();
    Q_INVOKABLE int sendMsg(QString str);


private:
    int ServiceStart = 0;
    int client_sock = 0;
private:
    /**
     * @brief 启动服务
     * @return
     */
    int StartService();
    int StopService();

};

#endif // QMLNANOMSGCONTROL_H
