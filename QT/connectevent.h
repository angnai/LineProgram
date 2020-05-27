#ifndef CONNECTEVENT_H
#define CONNECTEVENT_H

#include <QQuickView>
#include <QObject>
#include <QTimer>
#include <QtNetwork>
class ConnectEvent : public QObject
{
public:
	Q_OBJECT//������ �� �߰��ؾ��ϴ����� �𸣰����� �߰��� ���ϸ� connection�Ҷ� ���� ����(���Ŀ� �˾� ������ �ϰڴ�.)

	//�׸��� Q_OBJECT �߰��� �� Build->Run qmake�� ������(�߿�!!)
public:
	bool exeC;
	ConnectEvent();
	~ConnectEvent();

	void cppSignaltoQmlSlot();//cpp���� �ñ׳��� ������ qml ���� �ޱ����� connection�� �صδ� �Լ�
	void setWindow(QQuickWindow* Window);
	QTimer *timer;
private:

	QQuickWindow* mMainView;
signals://Ŭ��������  signal��� �ϴ� ���
	void cppSignaltestData(QVariant);

public slots:
	void slotTimerAlarm();
};

#endif // CONNECTEVENT_H
