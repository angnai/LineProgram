import QtQuick 2.9
import QtQuick.Window 2.2
//import QtQuick.Controls 1.6
import QtQuick.Controls 2.2
import ConnectEvent 1.0

Window {
	id:win1
    visible: true
    width: 1024
    height: 600
    x: 0
    y: 0
    title: qsTr("Hello World")
    visibility: "Maximized"    // does not hide the windows taskbar
    //visibility: "FullScreen" // does     hide the windows taskbar
    flags: Qt.FramelessWindowHint|Qt.Window // frameless, but with an icon on the windows taskbar

    property var strArray2;
    property var pointValue;
    property var pointValue2;
    property var pointValue3;
    property var tValue;
    property var indexval;
	property var minHeight: 0;
    property var maxHeight : 2000;
    property var warningHeight : 230;
    property var errorHeight : 200;
    property var pointVar;
    property bool mbImageClicked : true;
    property string strVmm: "{0} mm"
    property string strV: "{0}"
    property var exitCnt : 0;

	property var setYear;
	property var setMonth;
	property var setDay;
	property var setHour;
	property var setMin;


	property var strArrayScanData;
	property var getDataCountAll: 1;
    property var indexCnt: 1;
    property var indexCnt1: 1;

	property var start1stval: 0;
	property var start2ndval: 0;
	property var start3rdval: 0;

	property var sel1stval: 0;
	property var sel2ndval: 0;
	property var sel3rdval: 0;

	property var selectWindow: 0;

	ConnectEvent {
		id:connectEvent
	}

    //var pointValue = new Array(20)

    function qmlSlotTestData(data){//slot으로 등록한 함수
        //console.log("qmlSlotTestData data:" + data);
        var strArray=data.toString().split("\r\n");
        if(strArray == "") return

        pointVar = parseInt(strArray[0]);
        pointValue = new Array(7)
        pointValue2 = new Array(7)
        pointValue3 = new Array(7)
        indexval = new Array(7)
        tValue = new Array(7)

        for(var i=1; i<=pointVar ; i++)
        {
            var strsplit=strArray[i].toString().split("\t");
            //console.log(strArray[i]);
            tValue[i-1] = (strsplit[0]);
            tValue[i-1] = tValue[i-1].substring(11, 19);
            pointValue[i-1] = parseInt(strsplit[1]);
            pointValue2[i-1] = parseInt(strsplit[2]);
            pointValue3[i-1] = parseInt(strsplit[3]);
            indexval[i-1] = parseInt(strsplit[4]);
        }

        img12.x = 148 + 75*(pointVar-1);
        img12.y = 280-img12.height;

        //pointVar;

        lb_img6_1.text = "\n%1".arg((warningHeight/100).toFixed(2))
        lb_img6_2.text ="\n%1".arg((errorHeight/100).toFixed(2))
        lb_img7.text = "\n%1mm".arg((pointValue[pointVar-1]/100).toFixed(2))
        lb_img8.text = "\n%1mm".arg((pointValue2[pointVar-1]/100).toFixed(2))
        lb_img9.text = "\n%1mm".arg((pointValue3[pointVar-1]/100).toFixed(2))
        lb_img10_1.text = "\n%1 mm".arg((warningHeight/100).toFixed(2))
        lb_img10_2.text = "\n%1 mm".arg((warningHeight/100).toFixed(2))
        lb_img10_3.text = "\n%1 mm".arg((warningHeight/100).toFixed(2))
        lb_img11_1.text = "\n%1 mm".arg((errorHeight/100).toFixed(2))
        lb_img11_2.text = "\n%1 mm".arg((errorHeight/100).toFixed(2))
        lb_img11_3.text = "\n%1 mm".arg((errorHeight/100).toFixed(2))

        root.requestPaint()
    }
    /*
    Timer {
        interval: 100
        running: true
        triggeredOnStart: true
        repeat: true
        onTriggered: root.requestPaint()
    }
    */

	Frame {
		id: fr2
		x: 0
		y: 0
		width: 1024
		height: 600
		padding: 0
		rightPadding: 0
		leftPadding: 0
		bottomPadding: 0
		topPadding: 0

		Image {
			id: img0
			x: 0
			y: 0
			width: 1024
			height: 600
			source: "../image/BG.png"
		}

		Canvas {
			id: root
			// canvas size
			width: 1024; height: 600
			scale: 1
			x:0
			y: 0
			z: 0

			// handler to override for drawing
			onPaint: {
				// get context to draw with
				x: 35
				y: 244
				width: 636
				height: 334



				var ctx = getContext("2d")
				var ctx2 = getContext("2d")

				ctx.drawImage('qrc:/../image/left_box.png', 35, 244)
				ctx.save()

				// setup the stroke

				var posX;
				var AddPosX;
				var middlePosY,minPosY,Height;
				var PosYVal;

				AddPosX = 75
				middlePosY = 468;
				minPosY = 496;
				Height = (middlePosY-300);

				ctx.lineWidth = 2



				// begin a new path to draw
				ctx.beginPath()
				ctx.strokeStyle = "rgb(150,175,173)"
				ctx2.fillStyle = "rgb(150,175,173)"

				posX = 164;
				if(pointValue[0] < errorHeight) ctx.moveTo(posX,minPosY);
				else if(pointValue[0] < warningHeight) ctx.moveTo(posX,middlePosY);
				else ctx.moveTo(posX,middlePosY-(Height*((pointValue[0]-warningHeight)/(maxHeight-warningHeight))));

				for(var i=0;i<7;i++)
				{
					if(pointValue[i] < errorHeight) ctx.lineTo(posX,minPosY);
					else if(pointValue[i] < warningHeight) ctx.lineTo(posX,middlePosY);
					else ctx.lineTo(posX, middlePosY-(Height*((pointValue[i]-warningHeight)/(maxHeight-warningHeight))).toFixed(0));
					posX = posX+AddPosX;
					//console.log(pointValue[i],middlePosY-(Height*((pointValue[i]-warningHeight)/(maxHeight-warningHeight))).toFixed(0));
				}
				ctx.stroke()

				ctx2.beginPath()
				posX = 164;
				for(var i=0;i<7;i++)
				{
					if(pointValue[i] < errorHeight) PosYVal = minPosY;
					else if(pointValue[i] < warningHeight) PosYVal = middlePosY;
					else PosYVal = middlePosY-(Height*((pointValue[i]-warningHeight)/(maxHeight-warningHeight)));

					ctx2.arc(posX,PosYVal , 10, 0, 2*Math.PI)
					ctx.moveTo(posX,pointValue[i])
					posX = posX+AddPosX;
				}
				ctx2.closePath()
				ctx2.fill()




				// begin a new path to draw
				ctx.beginPath()
				ctx.strokeStyle = "rgb(68,119,114)"
				ctx2.fillStyle = "rgb(68,119,114)"

				posX = 164;
				if(pointValue2[0] < errorHeight) ctx.moveTo(posX,minPosY);
				else if(pointValue2[0] < warningHeight) ctx.moveTo(posX,middlePosY);
				else ctx.moveTo(posX,middlePosY-(Height*((pointValue2[0]-warningHeight)/(maxHeight-warningHeight))));

				for(var i=0;i<7;i++)
				{
					if(pointValue2[i] < errorHeight) ctx.lineTo(posX,minPosY);
					else if(pointValue2[i] < warningHeight) ctx.lineTo(posX,middlePosY);
					else ctx.lineTo(posX,middlePosY-(Height*((pointValue2[i]-warningHeight)/(maxHeight-warningHeight))));
					posX = posX+AddPosX;
				}
				ctx.stroke()

				ctx2.beginPath()
				posX = 164;
				for(var i=0;i<7;i++)
				{
					if(pointValue2[i] < errorHeight) PosYVal = minPosY;
					else if(pointValue2[i] < warningHeight) PosYVal = middlePosY;
					else PosYVal = middlePosY-(Height*((pointValue2[i]-warningHeight)/(maxHeight-warningHeight)));

					ctx2.arc(posX,PosYVal , 10, 0, 2*Math.PI)
					ctx.moveTo(posX,pointValue2[i])
					posX = posX+AddPosX;
				}
				ctx2.closePath()
				ctx2.fill()




				// begin a new path to draw
				ctx.beginPath()
				ctx.strokeStyle = "rgb(46,74,72)"
				ctx2.fillStyle = "rgb(46,74,72)"

				posX = 164;
				if(pointValue3[0] < errorHeight) ctx.moveTo(posX,minPosY);
				else if(pointValue3[0] < warningHeight) ctx.moveTo(posX,middlePosY);
				else ctx.moveTo(posX,middlePosY-(Height*((pointValue3[0]-warningHeight)/(maxHeight-warningHeight))));

				for(var i=0;i<7;i++)
				{
					if(pointValue3[i] < errorHeight) ctx.lineTo(posX,minPosY);
					else if(pointValue3[i] < warningHeight) ctx.lineTo(posX,middlePosY);
					else ctx.lineTo(posX,middlePosY-(Height*((pointValue3[i]-warningHeight)/(maxHeight-warningHeight))));
					posX = posX+AddPosX;
				}
				ctx.stroke()

				ctx2.beginPath()
				posX = 164;
				for(var i=0;i<7;i++)
				{
					if(pointValue3[i] < errorHeight) PosYVal = minPosY;
					else if(pointValue3[i] < warningHeight) PosYVal = middlePosY;
					else PosYVal = middlePosY-(Height*((pointValue3[i]-warningHeight)/(maxHeight-warningHeight)));

					ctx2.arc(posX,PosYVal , 10, 0, 2*Math.PI)
					ctx.moveTo(posX,pointValue3[i])
					posX = posX+AddPosX;
				}
				ctx2.closePath()
				ctx2.fill()
			}

		}


		Button {
			id: bt1
			x: 778
			y: 160
			width: 208
			height: 88
			background: Image
			{
				source: "../image/h8.png"
			}

			Text {
				id: lb_bt1
				font.family:"Roboto"
				color:"#425c59"
                text: qsTr("-")
				anchors.centerIn: parent
				font.pixelSize: 18
			}

			onClicked: {
				console.log("onClicked!!! mbImageClicked == true")
			}
		}

		Button {
			id: bt2
			x: 778
			y: 248
			width: 208
			height: 88
			background: Image
			{
				source: "../image/h8.png"
			}

			Text {
				id: lb_bt2
				font.family:"Roboto"
				color:"#425c59"
                text: qsTr("-")
				anchors.centerIn: parent
				font.pixelSize: 18
			}

			onClicked: {
				console.log("onClicked!!! mbImageClicked == true")
				img1.text = "bt2"
			}
		}

		Button {
			id: bt3
			x: 690
			y: 456
			width: 316
			height: 104
			background: Image
			{
				//anchors.verticalCenter: parent.verticalCenter
				//anchors.horizontalCenter: parent.horizontalCenter
				source: mbImageClicked ? "../image/h9.png" : "../image/h5.png";
			}

			onClicked: {
				console.log("onClicked!!! mbImageClicked == true")
				if(mbImageClicked) mbImageClicked = false
				else mbImageClicked = true
			}
		}

		Image {
			id: img1
			x: 778
			y: 336
			width: 208
			height: 104
			source: "../image/h2.png"

			Text {
				id: lb_img1
				font.family:"Roboto"
				color:"#425c59"
                text: qsTr("\n\n mm   mm   mm")
				anchors.centerIn: parent
                font.pixelSize: 13
			}
		}

		Button {
			id: img2
			x: 690
			y: 160
			width: 97
			height: 88

			background: Image
			{
				//source: mbImageClicked ? "../image/h9.png" : "../image/h5.png";
				source: "../image/h7.png"
			}

			onClicked: {
				list112.text = "-"
				list113.text = "-"
				selectWindow = 1
				fr3.visible = true
				fr2.visible = false
			}
		}

		Button {
			id: img3
			x: 690
			y: 248
			width: 97
			height: 88

			background: Image
			{
				//source: mbImageClicked ? "../image/h9.png" : "../image/h5.png";
				source: "../image/h11.png"
			}

			onClicked: {
				list112.text = "-"
				list113.text = "-"
				selectWindow = 0
				fr3.visible = true
				fr2.visible = false
			}
		}

		Image {
			id: img4
			x: 690
			y: 336
			width: 97
			height: 104
			source: "../image/h6.png"
		}

		Button {
			id: bt5
			x: 690
			y: 60
			width: 296
			height: 104
			background: Image
			{
				//source: mbImageClicked ? "../image/h9.png" : "../image/h5.png";
				source: "../image/h4.png"
			}

			onClicked: {
				radioButton.checked = true
				valtxtMin.text = minHeight.toString();
				valtxtMax.text = maxHeight.toString();
				valtxtWarning.text = warningHeight.toString();
				valtxtError.text = errorHeight.toString();

				elementsadf.text = (parseFloat(parseInt(valtxtMin.text)/100).toFixed(2)).toString() + "mm"
				elementsadf1.text = (parseFloat(parseInt(valtxtMax.text)/100).toFixed(2)).toString() + "mm"
				elementsadf2.text = (parseFloat(parseInt(valtxtWarning.text)/100).toFixed(2)).toString() + "mm"
				elementsadf3.text = (parseFloat(parseInt(valtxtError.text)/100).toFixed(2)).toString() + "mm"

				fr4.visible = true
				fr2.visible = false
			}
		}

		Image {
			id: img12
			x: 690
			y: 60
			width: 32
			height: 20
			source: "../image/point.png"
		}


		Image {
			id: img7
			x: 154
			y: 50
			width: 168
			height: 104
			source: "../image/p1.png"
			Text {
				id: lb_img7
				font.family:"Roboto"
				color:"white"
				text: "\n%1mm".arg((pointValue[pointVar-1]/100).toFixed(2))
				anchors.centerIn: parent

				font.pixelSize: 20
			}

			MouseArea{
				anchors.fill: parent
				onClicked: {
					exitCnt++;
					if(exitCnt>10){
						Qt.callLater(Qt.quit);
					}
				}
			}

		}
		Image {
			id: img8
			x: 321
			y: 50
			width: 168
			height: 104
			source: "../image/p2.png"
			Text {
				id: lb_img8
				text: "\n%1mm".arg((pointValue2[pointVar-1]/100).toFixed(2))
				font.family:"Roboto"
				color:"white"
				anchors.centerIn: parent

				font.pixelSize: 20
			}

		}
		Image {
			id: img9
			x: 488
			y: 50
			width: 168
			height: 104
			source: "../image/p3.png"
			Text {
				id: lb_img9
				text: "\n%1mm".arg((pointValue3[pointVar-1]/100).toFixed(2))
				font.family:"Roboto"
				color:"white"
				anchors.centerIn: parent

				font.pixelSize: 20
			}

		}
		Image {
			id: img10
			x: 50
			y: 150
			width: 606
			height: 64
			source: "../image/h1.png"
		}
		Image {
			id: img11
			x: 50
			y: 198
			width: 606
			height: 64
			source: "../image/h10.png"
		}

		Text {
			id: lb_img10_1
			text: "\n%1 mm".arg((warningHeight/100).toFixed(2))
			x:200
			y:143
			font.family:"Roboto"
			color:"white"

			font.pixelSize: 19
		}
		Text {
			id: lb_img10_2
			text: "\n%1 mm".arg((warningHeight/100).toFixed(2))
			x:367
			y:143
			font.family:"Roboto"
			color:"white"
			font.pixelSize: 19
		}
		Text {
			id: lb_img10_3
			text: "\n%1 mm".arg((warningHeight/100).toFixed(2))
			x:534
			y:143
			font.family:"Roboto"
			color:"white"

			font.pixelSize: 19
		}


		Text {
			id: lb_img11_1
			text: "\n%1 mm".arg((errorHeight/100).toFixed(2))
			x:200
			y:192
			font.family:"Roboto"
			color:"white"

			font.pixelSize: 19
		}
		Text {
			id: lb_img11_2
			text: "\n%1 mm".arg((errorHeight/100).toFixed(2))
			x:367
			y:192
			font.family:"Roboto"
			color:"white"

			font.pixelSize: 19
		}
		Text {
			id: lb_img11_3
			text: "\n%1 mm".arg((errorHeight/100).toFixed(2))
			x:534
			y:192
			font.family:"Roboto"
			color:"white"

			font.pixelSize: 19
		}
		Text {
			id: lb_img6_1
			x: 80+35
			y: 181+244
			font.family:"Roboto"
			color:"#FCD467"
			font.pixelSize: 16
			text: "\n%1".arg((warningHeight/100).toFixed(2))
		}
		Text {
			id: lb_img6_2
			x: 80+35
			y: 207+244
			font.family:"Roboto"
			color:"#E26F5C"
			font.pixelSize: 16
			text: "\n%1".arg((errorHeight/100).toFixed(2))
		}
	}




	Frame {
		id: fr1
		width: 1024
		height: 600
		x: 0
		y: 0
		visible: false
		Text {
			id: comboBox0
			x: 50
			y: 141
			width: 100
			text:"20"
			horizontalAlignment: Text.AlignRight
			font.pointSize: 100
			font.family:"Roboto"
		}

		Text {
			id: comboBox1
			x: 400
			y: 141
			width: 100
			text:"1"
			horizontalAlignment: Text.AlignRight
			font.pointSize: 100
			font.family:"Roboto"

		}

		Text {
			id: comboBox2
			x: 750
			y: 141
			width: 100
			text:"1"
			horizontalAlignment: Text.AlignRight
			font.pointSize: 100
			font.family:"Roboto"
		}

		Text {
			id: comboBox3
			x: 250
			y: 400
			width: 100
			text:"0"
			horizontalAlignment: Text.AlignRight
			font.pointSize: 100
			font.family:"Roboto"
		}

		Text {
			id: comboBox4
			x: 550
			y: 400
			width: 100
			text:"0"
			horizontalAlignment: Text.AlignRight
			font.pointSize: 100
			font.family:"Roboto"
		}

		Text {
			id: element
			x: 87
			y: 105
			text: qsTr("Year")
			renderType: Text.QtRendering
			elide: Text.ElideNone
			font.pixelSize: 30
		}

		Text {
			id: element1
			x: 415
			y: 105
			text: qsTr("Month")
			font.pixelSize: 30
		}

		Text {
			id: element2
			x: 788
			y: 105
			text: qsTr("Day")
			font.pixelSize: 30
		}

		Text {
			id: element3
			x: 250
			y: 364
			text: qsTr("Hour")
			font.pixelSize: 30
		}

		Text {
			id: element4
			x: 550
			y: 364
			text: qsTr("Minute")
			font.pixelSize: 30
		}


		Button {
			id: button3
			x: 828
			y: 334
			width: 150
			height: 90
			text: qsTr("OK")

			onClicked: {

				lb_bt2.text = "20"+comboBox0.text+"/"+comboBox1.text+"/"+comboBox2.text+" "+comboBox3.text+":"+comboBox4.text

				fr1.visible = false
				fr2.visible = true
			}
		}

		Button {
			id: button4
			x: 828
			y: 460
			width: 150
			height: 90
			text: qsTr("Cancel")

			onClicked: {

				fr1.visible = false
				fr2.visible = true
			}
		}



		Button {
			id: bt70
			x: 183
			y: 141
			width: 80
			height: 70
			text: qsTr("UP")
			onClicked: {
				if((parseInt(comboBox0.text)+1) < 100) comboBox0.text = (parseInt(comboBox0.text)+1).toString()
				if(comboBox0.text.length == 1) comboBox0.text = "0"+comboBox0.text
			}
		}
		Button {
			id: bt71
			x: 184
			y: 220
			width: 80
			height: 70
			text: qsTr("DOWN")
			onClicked: {
				if((parseInt(comboBox0.text)-1) > 0) comboBox0.text = (parseInt(comboBox0.text)-1).toString()
				if(comboBox0.text.length == 1) comboBox0.text = "0"+comboBox0.text
			}
		}



		Button {
			id: bt72
			x: 550
			y: 141
			width: 80
			height: 70
			text: qsTr("UP")
			onClicked: {
				if((parseInt(comboBox1.text)+1) < 13) comboBox1.text = (parseInt(comboBox1.text)+1).toString()
				if(comboBox1.text.length == 1) comboBox1.text = "0"+comboBox1.text
			}
		}
		Button {
			id: bt73
			x: 550
			y: 220
			width: 80
			height: 70
			text: qsTr("DOWN")
			onClicked: {
				if((parseInt(comboBox1.text)-1) > 0) comboBox1.text = (parseInt(comboBox1.text)-1).toString()
				if(comboBox1.text.length == 1) comboBox1.text = "0"+comboBox1.text
			}
		}



		Button {
			id: bt74
			x: 884
			y: 141
			width: 80
			height: 70
			text: qsTr("UP")
			onClicked: {
				if((parseInt(comboBox2.text)+1) < 32) comboBox2.text = (parseInt(comboBox2.text)+1).toString()
				if(comboBox2.text.length == 1) comboBox2.text = "0"+comboBox2.text
			}
		}
		Button {
			id: bt75
			x: 884
			y: 220
			width: 80
			height: 70
			text: qsTr("DOWN")
			onClicked: {
				if((parseInt(comboBox2.text)-1) > 0) comboBox2.text = (parseInt(comboBox2.text)-1).toString()
				if(comboBox2.text.length == 1) comboBox2.text = "0"+comboBox2.text
			}
		}



		Button {
			id: bt76
			x: 384
			y: 400
			width: 80
			height: 70
			text: qsTr("UP")
			onClicked: {
				if((parseInt(comboBox3.text)+1) < 24) comboBox3.text = (parseInt(comboBox3.text)+1).toString()
				if(comboBox3.text.length == 1) comboBox3.text = "0"+comboBox3.text
			}
		}
		Button {
			id: bt77
			x: 384
			y: 479
			width: 80
			height: 70
			text: qsTr("DOWN")
			onClicked: {
				if((parseInt(comboBox3.text)-1) > -1) comboBox3.text = (parseInt(comboBox3.text)-1).toString()
				if(comboBox3.text.length == 1) comboBox3.text = "0"+comboBox3.text
			}
		}



		Button {
			id: bt78
			x: 684
			y: 400
			width: 80
			height: 70
			text: qsTr("UP")
			onClicked: {
				if((parseInt(comboBox4.text)+1) < 60) comboBox4.text = (parseInt(comboBox4.text)+1).toString()
				if(comboBox4.text.length == 1) comboBox4.text = "0"+comboBox4.text
			}
		}
		Button {
			id: bt79
			x: 684
			y: 479
			width: 80
			height: 70
			text: qsTr("DOWN")
			onClicked: {
				if((parseInt(comboBox4.text)-1) > -1) comboBox4.text = (parseInt(comboBox4.text)-1).toString()
				if(comboBox4.text.length == 1) comboBox4.text = "0"+comboBox4.text
			}
		}
	}

	Frame{
		id:fr3
		width: 1024
		height: 600
		visible: false

		Text {
			id: element112
			x: 78
			y: 14
			text: qsTr("DateTime")
			renderType: Text.QtRendering
			elide: Text.ElideNone
			font.pixelSize: 30
		}

		Text {
			id: element113
			x: 78
			y: 163
			text: qsTr("Data")
			font.pixelSize: 30
		}

		Text {
			id: list112
			x: 78
			y: 50
			width: 778
			height: 118
			text:"-"
			horizontalAlignment: Text.AlignRight
			font.pointSize: 60
			font.family:"Roboto"
		}

		Text {
			id: list113
			x: 72
			y: 204
			width: 756
			height: 81
			text:"-"
			horizontalAlignment: Text.AlignLeft
            font.pointSize: 40
			font.family:"Roboto"

		}


		Button {
			id: buttonS_OK
			x: 828
			y: 334
			width: 150
			height: 90
			text: qsTr("OK")

			onClicked: {
				if(list112.text == "-"){
					if(selectWindow == 0){
						if(lb_bt2.text == "-"){
							start1stval = 0
							start2ndval = 0
							start3rdval = 0
						}
					}
					else{
						if(lb_bt1.text == "-"){
							sel1stval = 0
							sel2ndval = 0
							sel3rdval = 0
						}
					}

				}
				else{
					var split1stvar;
					var split2ndvar;
					if(selectWindow == 0){
						lb_bt2.text = "20"+list112.text.substring(2,4)+"/"+list112.text.substring(5,7)+"/"+list112.text.substring(8,10)+" "+list112.text.substring(11,13)+":"+list112.text.substring(14,16)

						start1stval = parseInt(valTextT1.text)
						start2ndval = parseInt(valTextT2.text)
						start3rdval = parseInt(valTextT3.text)

						console.log("start ="+start1stval)
						console.log("start ="+start2ndval)
						console.log("start ="+start3rdval)
					}
					else{
						lb_bt1.text = "20"+list112.text.substring(2,4)+"/"+list112.text.substring(5,7)+"/"+list112.text.substring(8,10)+" "+list112.text.substring(11,13)+":"+list112.text.substring(14,16)

						sel1stval = parseInt(valTextT1.text)
						sel2ndval = parseInt(valTextT2.text)
						sel3rdval = parseInt(valTextT3.text)


                        lb_img1.text = "\r\n" + parseFloat((start1stval-sel1stval)/100).toFixed(2) + "mm " + parseFloat((start2ndval-sel2ndval)/100).toFixed(2) + "mm " + parseFloat((start3rdval-sel3rdval)/100).toFixed(2) + "mm";
						console.log("sel ="+sel1stval)
						console.log("sel ="+sel2ndval)
						console.log("sel ="+sel3rdval)
					}
				}

				fr3.visible = false
				fr2.visible = true
			}
		}

		Button {
			id: buttonS_CANCEL
			x: 828
			y: 460
			width: 150
			height: 90
			text: qsTr("Cancel")

			onClicked: {
				fr3.visible = false
				fr2.visible = true
			}
		}


		Text {
			id:valTextT1
			visible: false
			text: qsTr("0")
		}
		Text {
			id:valTextT2
			visible: false
			text: qsTr("0")
		}
		Text {
			id:valTextT3
			visible: false
			text: qsTr("0")
		}



		Button {
			id: bt113
			x: 78
			y: 326
			width: 150
			height: 100
			text: qsTr("UP")
			onClicked: {
				if(list112.text == "-")return

                var strsplit;
                if(selectWindow == 0){
                    if((indexCnt+1) <= getDataCountAll) indexCnt = indexCnt + 1
                    strsplit=strArrayScanData[indexCnt].toString().split("\t");
                }
                else{
                    if((indexCnt1+1) <= getDataCountAll) indexCnt1 = indexCnt1 + 1
                    strsplit=strArrayScanData[indexCnt1].toString().split("\t");
                }

				list112.text = strsplit[0];
				list113.text = parseFloat(parseInt(strsplit[1])/100).toFixed(2) + "mm / " + parseFloat(parseInt(strsplit[2])/100).toFixed(2) + "mm / " + parseFloat(parseInt(strsplit[3])/100).toFixed(2) + "mm"

				valTextT1.text = strsplit[1];
				valTextT2.text = strsplit[2];
				valTextT3.text = strsplit[3];
			}
		}
		Button {
			id: bt114
			x: 78
			y: 443
			width: 150
			height: 100
			text: qsTr("DOWN")
			onClicked: {
				if(list112.text == "-")return
                var strsplit
                if(selectWindow == 0){
                    if((indexCnt-1) > 0) indexCnt = indexCnt -1
                    strsplit=strArrayScanData[indexCnt].toString().split("\t");
                }
                else{
                    if((indexCnt1-1) > 0) indexCnt1 = indexCnt1 -1
                    strsplit=strArrayScanData[indexCnt1].toString().split("\t");

                }


				list112.text = strsplit[0];
				list113.text = parseFloat(parseInt(strsplit[1])/100).toFixed(2) + "mm / " + parseFloat(parseInt(strsplit[2])/100).toFixed(2) + "mm / " + parseFloat(parseInt(strsplit[3])/100).toFixed(2) + "mm"

				valTextT1.text = strsplit[1];
				valTextT2.text = strsplit[2];
				valTextT3.text = strsplit[3];
			}
		}

		Button {
			id: bt115
			x: 375
			y: 443
			width: 150
			height: 100
			text: qsTr("SCAN")

			onClicked: {
				connectEvent.qmlTestDataAll()

				var getDataStr;
				getDataStr = connectEvent.qmlTestDataGet()

				strArrayScanData = getDataStr.toString().split("\r\n");
				if(strArrayScanData == "") return

				getDataCountAll = parseInt(strArrayScanData[0]);
                var strsplit;
                if(selectWindow == 0){
                    if(getDataCountAll < indexCnt) indexCnt = getDataCountAll;
                    strsplit=strArrayScanData[indexCnt].toString().split("\t");
                }
                else{
                    if(getDataCountAll < indexCnt1) indexCnt1 = getDataCountAll;
                    strsplit=strArrayScanData[indexCnt1].toString().split("\t");
                }


				list112.text = strsplit[0];
				list113.text = parseFloat(parseInt(strsplit[1])/100).toFixed(2) + "mm / " + parseFloat(parseInt(strsplit[2])/100).toFixed(2) + "mm / " + parseFloat(parseInt(strsplit[3])/100).toFixed(2) + "mm"

				valTextT1.text = strsplit[1];
				valTextT2.text = strsplit[2];
				valTextT3.text = strsplit[3];
			}
		}
	}

	Frame{
		id:fr4
		width: 1024
		height: 600
		visible: false

		Button {
			id: fr4_btok
			x: 828
			y: 334
			width: 150
			height: 90
			text: qsTr("OK")

			onClicked: {
				minHeight = parseInt(valtxtMin.text);
				maxHeight = parseInt(valtxtMax.text);
				warningHeight = parseInt(valtxtWarning.text);
				errorHeight = parseInt(valtxtError.text)

				fr4.visible = false
				fr2.visible = true
			}
		}

		Button {
			id: fr4_btcancel
			x: 828
			y: 460
			width: 150
			height: 90
			text: qsTr("Cancel")

			onClicked: {
				valtxtMin.text = minHeight.toString();
				valtxtMax.text = maxHeight.toString();
				valtxtWarning.text = warningHeight.toString();
				valtxtError.text = errorHeight.toString();

				fr4.visible = false
				fr2.visible = true
			}
		}


		RadioButton {
			id: radioButton
			x: 78
			y: 25
			text: qsTr("최소")
			font.family:"Roboto"
			font.pointSize: 50
		}

		RadioButton {
			id: radioButton1
			x: 78
			y: 125
			text: qsTr("최대")
			font.family:"Roboto"
			font.pointSize: 50
		}

		RadioButton {
			id: radioButton2
			x: 78
			y: 225
			text: qsTr("경고")
			font.family:"Roboto"
			font.pointSize: 50
		}

		RadioButton {
			id: radioButton3
			x: 78
			y: 325
			text: qsTr("위험")
			font.family:"Roboto"
			font.pointSize: 50
		}

		Text {
		  id: elementsadf
		  x: 297
		  y: 41
		  font.family:"Roboto"
		  text: qsTr("00.00")
		  font.pixelSize: 50
		}

		Text {
		  id: elementsadf1
		  x: 297
		  y: 141
		  font.family:"Roboto"
		  text: qsTr("01.00")
		  font.pixelSize: 50
		}

		Text {
		  id: elementsadf2
		  x: 297
		  y: 241
		  font.family:"Roboto"
		  text: qsTr("02.00")
		  font.pixelSize: 50
		}

		Text {
		  id: elementsadf3
		  x: 297
		  y: 341
		  font.family:"Roboto"
		  text: qsTr("03.00")
		  font.pixelSize: 50
		}

		Text {
			id: valtxtMin
			text: qsTr("0")
			visible: false
		}
		Text {
			id: valtxtMax
			text: qsTr("0")
			visible: false
		}
		Text {
			id: valtxtWarning
			text: qsTr("0")
			visible: false
		}
		Text {
			id: valtxtError
			text: qsTr("0")
			visible: false
		}

		Button {
			id: bt1mmUP
			x: 579
			y: 69
			width: 160
			height: 100
			text: qsTr("1mm UP")
			font.family:"Roboto"
			font.pointSize: 15
			onClicked: {
				if(radioButton.checked){
					if(parseInt(valtxtMin.text)+100 < 10000){
						valtxtMin.text = (parseInt(valtxtMin.text)+100).toString()
					}
				}
				else if(radioButton1.checked){
					if(parseInt(valtxtMax.text)+100 < 10000){
						valtxtMax.text = (parseInt(valtxtMax.text)+100).toString()
					}
				}
				else if(radioButton2.checked){
					if(parseInt(valtxtWarning.text)+100 < 10000){
						valtxtWarning.text = (parseInt(valtxtWarning.text)+100).toString()
					}
				}
				else if(radioButton3.checked){
					if(parseInt(valtxtError.text)+100 < 10000){
						valtxtError.text = (parseInt(valtxtError.text)+100).toString()
					}
				}

				elementsadf.text = (parseFloat(parseInt(valtxtMin.text)/100).toFixed(2)).toString() + "mm"
				elementsadf1.text = parseFloat(parseInt(valtxtMax.text)/100).toFixed(2) + "mm"
				elementsadf2.text = parseFloat(parseInt(valtxtWarning.text)/100).toFixed(2) + "mm"
				elementsadf3.text = parseFloat(parseInt(valtxtError.text)/100).toFixed(2) + "mm"
			}
		}

		Button {
			id: bt1mmDOWN
			x: 579
			y: 182
			width: 160
			height: 100
			text: qsTr("1mm DOWN")
			font.family:"Roboto"
			font.pointSize: 15
			onClicked: {
				if(radioButton.checked){
					if(parseInt(valtxtMin.text)-100 > -1){
						valtxtMin.text = (parseInt(valtxtMin.text)-100).toString()
					}
					else valtxtMin.text = "0"
				}
				else if(radioButton1.checked){
					if(parseInt(valtxtMax.text)-100 > -1){
						valtxtMax.text = (parseInt(valtxtMax.text)-100).toString()
					}
					else valtxtMax.text = "0"
				}
				else if(radioButton2.checked){
					if(parseInt(valtxtWarning.text)-100 > -1){
						valtxtWarning.text = (parseInt(valtxtWarning.text)-100).toString()
					}
					else valtxtWarning.text = "0"
				}
				else if(radioButton3.checked){
					if(parseInt(valtxtError.text)-100 > -1){
						valtxtError.text = (parseInt(valtxtError.text)-100).toString()
					}
					else valtxtError.text = "0"
				}

				elementsadf.text = (parseFloat(parseInt(valtxtMin.text)/100).toFixed(2)).toString() + "mm"
				elementsadf1.text = parseFloat(parseInt(valtxtMax.text)/100).toFixed(2) + "mm"
				elementsadf2.text = parseFloat(parseInt(valtxtWarning.text)/100).toFixed(2) + "mm"
				elementsadf3.text = parseFloat(parseInt(valtxtError.text)/100).toFixed(2) + "mm"
			}
		}

		Button {
			id: bt0001mmUP
			x: 776
			y: 69
			width: 160
			height: 100
			text: qsTr("0.01mm UP")
			font.family:"Roboto"
			font.pointSize: 15
			onClicked: {
				if(radioButton.checked){
					if(parseInt(valtxtMin.text)+1 < 10000){
						valtxtMin.text = (parseInt(valtxtMin.text)+1).toString()
					}
				}
				else if(radioButton1.checked){
					if(parseInt(valtxtMax.text)+1 < 10000){
						valtxtMax.text = (parseInt(valtxtMax.text)+1).toString()
					}
				}
				else if(radioButton2.checked){
					if(parseInt(valtxtWarning.text)+1 < 10000){
						valtxtWarning.text = (parseInt(valtxtWarning.text)+1).toString()
					}
				}
				else if(radioButton3.checked){
					if(parseInt(valtxtError.text)+1 < 10000){
						valtxtError.text = (parseInt(valtxtError.text)+1).toString()
					}
				}

				elementsadf.text = (parseFloat(parseInt(valtxtMin.text)/100).toFixed(2)).toString() + "mm"
				elementsadf1.text = parseFloat(parseInt(valtxtMax.text)/100).toFixed(2) + "mm"
				elementsadf2.text = parseFloat(parseInt(valtxtWarning.text)/100).toFixed(2) + "mm"
				elementsadf3.text = parseFloat(parseInt(valtxtError.text)/100).toFixed(2) + "mm"
			}
		}

		Button {
			id: bt0001mmDOWN
			x: 776
			y: 182
			width: 160
			height: 100
			text: qsTr("0.01mm DOWN")
			font.family:"Roboto"
			font.pointSize: 15
			onClicked: {
				if(radioButton.checked){
					if(parseInt(valtxtMin.text)-1 > -1){
						valtxtMin.text = (parseInt(valtxtMin.text)-1).toString()
					}
					else valtxtMin.text = "0"
				}
				else if(radioButton1.checked){
					if(parseInt(valtxtMax.text)-1 > -1){
						valtxtMax.text = (parseInt(valtxtMax.text)-1).toString()
					}
					else valtxtMax.text = "0"
				}
				else if(radioButton2.checked){
					if(parseInt(valtxtWarning.text)-1 > -1){
						valtxtWarning.text = (parseInt(valtxtWarning.text)-1).toString()
					}
					else valtxtWarning.text = "0"
				}
				else if(radioButton3.checked){
					if(parseInt(valtxtError.text)-1 > -1){
						valtxtError.text = (parseInt(valtxtError.text)-1).toString()
					}
					else valtxtError.text = "0"
				}

				elementsadf.text = (parseFloat(parseInt(valtxtMin.text)/100).toFixed(2)).toString() + "mm"
				elementsadf1.text = parseFloat(parseInt(valtxtMax.text)/100).toFixed(2) + "mm"
				elementsadf2.text = parseFloat(parseInt(valtxtWarning.text)/100).toFixed(2) + "mm"
				elementsadf3.text = parseFloat(parseInt(valtxtError.text)/100).toFixed(2) + "mm"
			}
		}
	}
}



/*##^##
Designer {
	D{i:1;anchors_height:600;anchors_width:1024}
}
##^##*/
