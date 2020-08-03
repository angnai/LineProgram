#ifndef CONNECTEVENT_H
#define CONNECTEVENT_H

#include <QQuickView>
#include <QObject>
#include <QTimer>
#include <QtNetwork>
#include <iostream>
using namespace std;

class ConnectEvent : public QObject
{
public:
    Q_OBJECT
#define ONLINE_DEF
public:
	bool exeC;
    int isTrans;
	ConnectEvent();
	~ConnectEvent();

    void cppSignaltoQmlSlot();
	void setWindow(QQuickWindow* Window);
	QTimer *timer;

	QString val1122;

    Q_INVOKABLE void qmlTestDataAll(void);
    Q_INVOKABLE QString qmlTestDataGet(void);
    Q_INVOKABLE void qmlIndexDataAll(int nIndexA);
    Q_INVOKABLE void qmlSetTrans(int nSet);

private:
	QQuickWindow* mMainView;
signals:
	void cppSignaltestData(QVariant);
public slots:
	void slotTimerAlarm();

};

#endif // CONNECTEVENT_H
