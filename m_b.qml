import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 1.6
Window {
	visible: true
	width: 1024
	height: 600
	title: qsTr("Hello World")

	property var strArray2;
	property var pointValue;
	//var pointValue = new Array(10)

	function qmlSlotTestData(data){//slot으로 등록한 함수
		//console.log("qmlSlotTestData data:" + data);
		var strArray=data.toString().split("\r\n");

		var n = parseInt(strArray[0]);
		pointValue = new Array(10)

		for(var i=1; i<=n ; i++)
		{
			var strsplit=strArray[i].toString().split("\t");
			//console.log(strArray[i]);
			pointValue[i-1] = parseInt(strsplit[1]);
		}

		strArray2 = strArray;

	}
	Timer {
		interval: 100
		running: true
		triggeredOnStart: true
		repeat: true
		onTriggered: root.requestPaint()
	}


	Canvas {
		id: root
		// canvas size
		width: 1024; height: 600
		scale: 1
		z: 0
		rotation: 180
		// handler to override for drawing
		onPaint: {
			// get context to draw with
			var ctx = getContext("2d")
			ctx.fillStyle = "blue"//Qt.rgba(0, 0, 255, 1);
			ctx.fillRect(0, 0, width, height);

			// setup the stroke
			ctx.lineWidth = 2
			ctx.strokeStyle = "white"
			// setup the fill
			ctx.fillStyle = "steelblue"
			// begin a new path to draw
			ctx.beginPath()

			ctx.moveTo(0,0)
			/*for(var i=0;i<10;i++){
				ctx.lineTo(1024-(i*),pointValue[10-i])

			}*/
			var posX;

			for(var i=0;i<15;i++)
			{
				posX = i*70;
				ctx.lineTo(posX,pointValue[i])
				console.log(posX + " " + pointValue[i]);
			}
			ctx.lineTo(980,0)
			/*


			ctx.lineTo(140,70)
			ctx.lineTo(210,30)
			ctx.lineTo(280,90)
			ctx.lineTo(350,120)
			ctx.lineTo(420,70)
			ctx.lineTo(490,340)
			ctx.lineTo(560,600)
			ctx.lineTo(630,200)
			ctx.lineTo(700,20)
			ctx.lineTo(770,700)
			ctx.lineTo(840,80)
			ctx.lineTo(910,50)
			ctx.lineTo(980,50)
			ctx.lineTo(980,0)
			*/
			ctx.closePath()
			// fill using fill style
			ctx.fill()
			// stroke using line width and stroke style
			ctx.stroke()

			var ctx2 = getContext("2d")
			ctx2.beginPath()
			ctx2.fillStyle = "white"//Qt.rgba(255, 255, 255, 1)
			ctx.moveTo(0,0)
			for(var i=0;i<15;i++)
			{
				posX = i*70;
				ctx2.arc(posX,pointValue[i] , 5, 0, 2*Math.PI)
				ctx.moveTo(posX,pointValue[i])

				console.log(posX + " " + pointValue[i]);
			}
			/*
			ctx2.arc(0,50 , 5, 0, 2*Math.PI)
			ctx.moveTo(0,50)
			ctx2.arc(70,20 , 5, 0, 2*Math.PI)
			ctx.moveTo(70,20)
			ctx2.arc(140,70, 5, 0, 2*Math.PI)
			ctx.moveTo(140,70)
			ctx2.arc(210,30, 5, 0, 2*Math.PI)
			ctx.moveTo(210,30)
			ctx2.arc(280,90, 5, 0, 2*Math.PI)
			ctx.moveTo(280,90)
			ctx2.arc(350,120 , 5, 0, 2*Math.PI)
			ctx.moveTo(350,120)
			ctx2.arc(420,70 , 5, 0, 2*Math.PI)
			ctx.moveTo(420,70)
			ctx2.arc(490,340 , 5, 0, 2*Math.PI)
			ctx.moveTo(490,340)
			ctx2.arc(560,600 , 5, 0, 2*Math.PI)
			ctx.moveTo(560,600)
			ctx2.arc(630,200 , 5, 0, 2*Math.PI)
			ctx.moveTo(630,200)
			ctx2.arc(700,20 , 5, 0, 2*Math.PI)
			ctx.moveTo(700,20)
			ctx2.arc(770,700 , 5, 0, 2*Math.PI)
			ctx.moveTo(770,700)
			ctx2.arc(840,80 , 5, 0, 2*Math.PI)
			ctx.moveTo(840,80)
			ctx2.arc(910,50 , 5, 0, 2*Math.PI)
			ctx.moveTo(910,50)
			ctx2.arc(980,50 , 5, 0, 2*Math.PI)
			ctx.moveTo(980,50)
			*/
			ctx2.closePath()
			ctx2.fill()
		}

		Text {
			id: label1
			x: 931
			y: 435
			text: qsTr("Warning Value")
			rotation: 180
			font.pixelSize: 12
		}

		Text {
			id: label2
			x: 931
			y: 417
			text: qsTr("Error Value")
			rotation: 180
			font.pixelSize: 12
		}

		Text {
			id: warningVal
			x: 890
			y: 435
			text: qsTr("Text")
			rotation: 180
			font.pixelSize: 12
		}

		Text {
		  id: errorVal
		  x: 890
		  y: 417
		  text: qsTr("Text")
		  rotation: 180
		  font.pixelSize: 12
		}
	}

	Canvas {
		id: line1
		y: 600-120
		// canvas size
		width: 1024; height: 20
		scale: 1
		onPaint: {
			// get context to draw with
			var ctx = getContext("2d")
			ctx.strokeStyle = "yellow"
			ctx.lineWidth = 4
			ctx.lineCap = "round"
			ctx.lineJoin = "round"
			ctx.setLineDash( [ 1, 4 ] )

			ctx.beginPath()
			ctx.moveTo(0, 0)
			ctx.lineTo(1024, 0)
			ctx.stroke()
		}
		MouseArea {
			id: mouseArea1
			anchors.fill: parent
			drag.target: parent
			drag.axis: "YAxis"
			drag.minimumY: 0
			drag.maximumY: 600
			drag.filterChildren: true

			//onMouseYChanged: {
			//	line1.y = 300
			//}
			onReleased: {
				warningVal.text = parent.y//qsTr("angnaiS")
				line1.y = 600-120
			}
		}
	}

	Canvas {
		id: line2
		y: 600-80
		width: 1024; height: 20
		scale: 1
		onPaint: {
			// get context to draw with
			var ctx = getContext("2d")
			ctx.strokeStyle = "red"
			ctx.lineWidth = 4
			ctx.lineCap = "round"
			ctx.lineJoin = "round"
			ctx.setLineDash( [ 1, 4 ] )

			ctx.beginPath()
			ctx.moveTo(0, 0)
			ctx.lineTo(1024, 0)
			ctx.stroke()
		}
		MouseArea {
			id: mouseArea2
			anchors.fill: parent
			drag.target: parent
			drag.axis: "YAxis"
			drag.minimumY: 0
			drag.maximumY: 600
			drag.filterChildren: true

			//onMouseYChanged: {
			//	line1.y = 300
			//}
			onReleased: {
				errorVal.text = parent.y//qsTr("angnaiS")
				line2.y = 600-80
			}
		}
	}
}

/*##^##
Designer {
	D{i:1;anchors_height:600;anchors_width:1024}
}
##^##*/
