#ifndef QMLNANOMSGCONTROL_H
#define QMLNANOMSGCONTROL_H
#include "StateReceiverThread.h"
#include "SubscriberThread.h"

#include <QObject>

/**
 * @brief NanoMsg QML 实现
 */

#define BUF_LEN 500

class QmlNanoMsgControl : public QObject {
  Q_OBJECT

public:
  // explicit QmlNanoMsgControl(QObject *parent = nullptr);
  explicit QmlNanoMsgControl();
  Q_INVOKABLE int aaa();
  Q_INVOKABLE int sendMsg(QString str);
  Q_INVOKABLE int startService(QString host, int port);
  Q_INVOKABLE int connectPunlisher(QString host, int port);

signals:
  /**
   * @brief 将服务器接收的数据发到qml模块
   * @param json 接收到json串
   */
  void putMessageToQML(const QString json);

public slots:
  void receiveData(QString json);

private:
  int ServiceStart = 0;
  int client_sock = 0;
  int publishClientSocket = 0;
  QThread *thread1;
  StateReceiverThread *receiverThread;
  SubscriberThread *subscriberThread;
  int SendJsonCmd(QString jsonString);
private:

  int StopService();

  /**
   * @brief StatusRecvThread 状态接收线程
   * @param sock 连接Socket
   * @return
   */
  static int StatusRecvThread(int sock);
};

#endif // QMLNANOMSGCONTROL_H
