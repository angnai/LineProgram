#include "ConnectEvent.h"

ConnectEvent::ConnectEvent()
{
    qDebug() <<"angnai!!!";
	qmlRegisterType<ConnectEvent>("ConnectEvent", 1, 0, "ConnectEvent");//class�� qml���� ����ϱ� ���ؼ� ������ִ� �κ�
    isTrans = 1;

}

ConnectEvent::~ConnectEvent()
{

}


void ConnectEvent::cppSignaltoQmlSlot()
{
	QObject::connect(this, SIGNAL(cppSignaltestData(QVariant)), mMainView, SLOT(qmlSlotTestData(QVariant)));//�ñ׳ΰ� ������ �������ִ� connection
	slotTimerAlarm();
	timer = new QTimer();
	connect(timer, SIGNAL(timeout()), this, SLOT(slotTimerAlarm()));
	timer->start(300);

	exeC = false;
}

void ConnectEvent::setWindow(QQuickWindow* Window)
{
	mMainView = Window;//connection�� ���ֱ� ���� �����츦 ���
#ifdef ONLINE_DEF
	cppSignaltoQmlSlot();//������ ��ϰ� ���ÿ� connection ���
#endif
}

void ConnectEvent::qmlTestDataAll(void)
{
#ifdef ONLINE_DEF

    if(isTrans == 0 )return;

	QTcpSocket socket;
	socket.connectToHost("127.0.0.1", 9999);


	if (!socket.waitForConnected(10*1000)) {
		return;
	}
	//qDebug() << "Connected";

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
	data[4] = '4';
	data[5] = '\0';
	hex=QByteArray::fromRawData(data,5);
	socket.write(hex);

	QByteArray s_data;
	qint64 n;
	socket.waitForReadyRead(10*1000);
	socket.read(data,4);//QString::fromUtf8(socket.readAll());
	//qDebug() << "recv : " << QString::fromUtf8(s_data);

	n = (qint64)(data[0] + (data[1]<<8) + (data[2] << 16) + (data[3] << 24));

	while (socket.bytesAvailable() < n) {
		if (!socket.waitForReadyRead(10*1000)) {
			return;
		}
	}
	s_data = socket.readAll();//QString::fromUtf8(socket.readAll());
	//qDebug() << "recv : " << QString::fromUtf8(s_data);


	val1122 = s_data;
    qDebug() <<"end11";
#else
	val1122 = "2\r\n2020-07-18 16:52:47\t222\t0\t0\t97\r\n2020-07-18 16:53:47\t444\t111\t222\t983";
#endif


}

QString ConnectEvent::qmlTestDataGet(void)
{
	return val1122;
}

void ConnectEvent::qmlIndexDataAll(int nIndexA)
{

    QTcpSocket socket;
    socket.connectToHost("127.0.0.1", 9999);


    if (!socket.waitForConnected(10*1000)) {
        return;
    }
    //qDebug() << "Connected";

    char data[30];

    data[0] = 9;
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
    data[4] = '5';
    data[5] = ((nIndexA/1000)%10)+'0';
    data[6] = ((nIndexA/100)%10)+'0';
    data[7] = ((nIndexA/10)%10)+'0';
    data[8] = ((nIndexA/1)%10)+'0';
    data[9] = '\0';
    hex=QByteArray::fromRawData(data,9);
    socket.write(hex);

    QByteArray s_data;
    qint64 n;
    socket.waitForReadyRead(10*1000);
    socket.read(data,4);//QString::fromUtf8(socket.readAll());
    qDebug() << "recv : " << QString::fromUtf8(data);

    n = (qint64)(data[0] + (data[1]<<8) + (data[2] << 16) + (data[3] << 24));

    while (socket.bytesAvailable() < n) {
        if (!socket.waitForReadyRead(10*1000)) {
            return;
        }
    }
    s_data = socket.readAll();//QString::fromUtf8(socket.readAll());
    qDebug() << "recv : " << QString::fromUtf8(s_data);


    val1122 = s_data;
    qDebug() <<"end11";
    socket.close();
}

void ConnectEvent::qmlSetTrans(int nSet)
{
    isTrans = nSet;
}

void ConnectEvent::slotTimerAlarm()
{

    QTcpSocket socket;
    socket.connectToHost("127.0.0.1", 9999);


	if (!socket.waitForConnected(10*1000)) {
		return;
	}
    //qDebug() << "Connected";

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
	socket.write(hex);

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
