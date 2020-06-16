#include "connectevent.h"

ConnectEvent::ConnectEvent()
{
}

ConnectEvent::~ConnectEvent()
{

}


void ConnectEvent::cppSignaltoQmlSlot()
{
	QObject::connect(this, SIGNAL(cppSignaltestData(QVariant)), mMainView, SLOT(qmlSlotTestData(QVariant)));//시그널과 슬롯을 연결해주는 connection
	slotTimerAlarm();
	timer = new QTimer();
	connect(timer, SIGNAL(timeout()), this, SLOT(slotTimerAlarm()));
    timer->start(500);

	exeC = false;
}

void ConnectEvent::setWindow(QQuickWindow* Window)
{
	mMainView = Window;//connection을 해주기 위해 윈도우를 등록

	cppSignaltoQmlSlot();//윈도우 등록과 동시에 connection 등록
}

void ConnectEvent::slotTimerAlarm()
{

    QTcpSocket socket;
    socket.connectToHost("127.0.0.1", 9999);


	if (!socket.waitForConnected(10*1000)) {
		return;
	}
	qDebug() << "Connected";

	char data[7];

	data[0] = 5;
	data[1] = 0;
	data[2] = 0;
	data[3] = 0;
	QByteArray hex=QByteArray::fromRawData(data,4);

	socket.write(hex);


    //qDebug() << "writed";

	data[0] = 's';
	data[1] = 'c';
	data[2] = 'a';
	data[3] = 'n';
	data[4] = '1';
	data[5] = '\0';
	hex=QByteArray::fromRawData(data,5);

	QByteArray data2;
	data2 = "scan1";
	socket.write(hex);

    //qDebug() << "writed";
	QByteArray s_data;
	qint64 n;
	socket.waitForReadyRead(10*1000);
	socket.read(data,4);//QString::fromUtf8(socket.readAll());
	//qDebug() << "recv : " << QString::fromUtf8(s_data);

	n = (qint64)(data[0] + (data[1]<<8) + (data[2] << 16));

	while (socket.bytesAvailable() < n) {
		if (!socket.waitForReadyRead(10*1000)) {
			return;
		}
	}
	s_data = socket.readAll();//QString::fromUtf8(socket.readAll());
    //qDebug() << "recv : " << QString::fromUtf8(s_data);

	emit cppSignaltestData(QString::fromUtf8(s_data));
}
