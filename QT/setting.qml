import QtQuick 2.9
import QtQuick.Window 2.2
//import QtQuick.Controls 1.6
import QtQuick.Controls 2.2
import ConnectEvent 1.0//등록한 클래스 타입을 import해준다.
import "."

Window {
	id: wind2
	width: 1024
	height: 600

	visible: true


	property var strArrayScanData;
	property var getDataCountAll: 1;
	property var indexCnt: 1;

	property var minHeight: 0;
	property var maxHeight : 2000;
	property var warningHeight : 230;
	property var errorHeight : 200;
	ConnectEvent {
		id:connectEvent
	}


	Frame{
		id:fr2
		width: 1024
		height: 600
		visible: false

		Button {
			id: button
			x: 350
			y: 405
			text: qsTr("OK")
			onClicked: {
				fr3.visible = true
				fr2.visible = false
			}
		}

		Button {
			id: button1
			x: 500
			y: 405
			text: qsTr("Cancel")
		}

	}


}





