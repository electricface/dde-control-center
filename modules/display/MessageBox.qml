/****************************************************************************
**
**  Copyright (C) 2011~2014 Deepin, Inc.
**                2011~2014 Kaisheng Ye
**
**  Author:     Kaisheng Ye <kaisheng.ye@gmail.com>
**  Maintainer: Kaisheng Ye <kaisheng.ye@gmail.com>
**
**  This program is free software: you can redistribute it and/or modify
**  it under the terms of the GNU General Public License as published by
**  the Free Software Foundation, either version 3 of the License, or
**  any later version.
**
**  This program is distributed in the hope that it will be useful,
**  but WITHOUT ANY WARRANTY; without even the implied warranty of
**  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
**  GNU General Public License for more details.
**
**  You should have received a copy of the GNU General Public License
**  along with this program.  If not, see <http://www.gnu.org/licenses/>.
**
****************************************************************************/

import QtQuick 2.1
import QtQuick.Window 2.1
import Deepin.Locale 1.0
import Deepin.Widgets 1.0
import DBus.Com.Deepin.Daemon.Display 1.0
import "../shared"

DWindow {
    id: messageBox
    color: "transparent"
    flags: Qt.Tool | Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint

    x: screenSize.x + (screenSize.width - width)/2
    y: screenSize.y + (screenSize.height - height)/2

    width: 300
    height: 120

    function showDialog(){
        rootWindow.clickedToHide = false
        countdown.restart()
        messageBox.show()
    }

    function hideDialog(){
        messageBox.hide()
        countdown.reset()
        rootWindow.clickedToHide = true
    }

    Timer {
        id: countdown
        property int totalTime: 30

        function reset(){
            countdown.stop()
            totalTime = 30
        }

        running: false
        repeat: true
        interval: 1000
        onTriggered: {
            if(totalTime > 1){
                totalTime = totalTime - 1
            }
            else{
                displayId.ResetChanges()
                hideDialog()
            }
        }
    }

    DialogBox {
        id: window
        anchors.fill: parent
        radius: 5

        DDragableArea{
            anchors.fill: parent
            window: messageBox
        }

        DssH1{
            id: messageLabel
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 20
            color: "white"
            text: dsTr("Do you want to keep these display settings?")
            font.pixelSize: 14
        }

        DssH3{
            anchors.top: messageLabel.bottom
            anchors.topMargin: 6
            anchors.left: messageLabel.left

            color: dconstants.fgColor
            text: dsTr("Reverting to previous display settings in <font color='#F48914'>%1</font> seconds.").arg(countdown.totalTime)
            font.pixelSize: 12
        }

        Row {
            anchors.right: parent.right
            anchors.rightMargin: 6
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 6
            spacing: 6

            DTransparentButton {
                text: dsTr("Keep Changes")
                onClicked: {
                    displayId.SaveChanges()
                    hideDialog()
                }
            }

            DTransparentButton {
                text: dsTr("Revert")
                onClicked: {
                    displayId.ResetChanges()
                    hideDialog()
                }
            }
        }
    }
}
