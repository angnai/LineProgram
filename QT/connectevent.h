#ifndef CONNECTEVENT_H
#define CONNECTEVENT_H

#include <QQuickView>
#include <QObject>
#include <QTimer>
#include <QtNetwork>
class ConnectEvent : public QObject
{
public:
	Q_OBJECT//솔직히 왜 추가해야하는지는 모르겠지만 추가를 안하면 connection할때 에러 난다(추후에 알아 보도록 하겠다.)

	//그리고 Q_OBJECT 추가한 후 Build->Run qmake를 해주자(중요!!)
public:
	bool exeC;
	ConnectEvent();
	~ConnectEvent();

	void cppSignaltoQmlSlot();//cpp에서 시그널을 날리고 qml 에서 받기위해 connection을 해두는 함수
	void setWindow(QQuickWindow* Window);
	QTimer *timer;
private:

	QQuickWindow* mMainView;
signals://클래스에서  signal등록 하는 방법
	void cppSignaltestData(QVariant);

public slots:
	void slotTimerAlarm();
};

#endif // CONNECTEVENT_H
