import QtQuick 2.9
import QtQuick.Window 2.2
//import QtQuick.Controls 1.6
import QtQuick.Controls 2.2

Window {
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
    property var maxHeight : 2000;
    property var warningHeight : 230;
    property var errorHeight : 200;
    property var pointVar;
    property bool mbImageClicked : true;
    property string strVmm: "{0} mm"
    property string strV: "{0}"
    property var exitCnt : 0;


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
            text: qsTr("2020/07/08 07:12")
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
            text: qsTr("2020/07/08 07:12")
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
            text: qsTr("\n\n2.5 mm 3.5 mm 5.2 mm")
            anchors.centerIn: parent
            font.pixelSize: 15
        }
    }

    Image {
        id: img2
        x: 690
        y: 160
        width: 97
        height: 88
        source: "../image/h7.png"
    }

    Image {
        id: img3
        x: 690
        y: 248
        width: 97
        height: 88
        source: "../image/h11.png"
    }

    Image {
        id: img4
        x: 690
        y: 336
        width: 97
        height: 104
        source: "../image/h6.png"
    }

    Image {
        id: img5
        x: 690
        y: 60
        width: 296
        height: 104
        source: "../image/h4.png"
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

/*##^##
Designer {
    D{i:1;anchors_height:600;anchors_width:1024}
}
##^##*/
