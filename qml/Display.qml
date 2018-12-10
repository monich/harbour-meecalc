/*
 * Copyright (C) 2014-2018 Jolla Ltd.
 * Copyright (C) 2014-2018 Slava Monich <slava.monich@jolla.com>
 *
 * You may use this file under the terms of BSD license as follows:
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 *   1. Redistributions of source code must retain the above copyright
 *      notice, this list of conditions and the following disclaimer.
 *   2. Redistributions in binary form must reproduce the above copyright
 *      notice, this list of conditions and the following disclaimer in
 *      the documentation and/or other materials provided with the
 *      distribution.
 *   3. Neither the names of the copyright holders nor the names of its
 *      contributors may be used to endorse or promote products derived
 *      from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: display

    property alias text: displayText.text
    property color textColor: "#FF8600"
    property int minimumSize: 8
    property int maximumSize: 200

    signal textCopied(var text)
    signal pressed()

    function flash() {
        flashAnimation.restart()
    }

    Rectangle {
        id: background
        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        opacity: 0
        radius: height/10
        color: textColor
        width: displayText.paintedWidth
        height: displayText.paintedHeight
    }

    Text {
        id: displayText
        color: textColor
        anchors.fill: parent

        smooth: true
        font.bold: true

        Component.onCompleted: refitText()
        horizontalAlignment: Text.AlignRight;
        verticalAlignment: Text.AlignVCenter;

        onWidthChanged: refitText()
        onHeightChanged: refitText()
        onTextChanged: refitText()

        function refitText() {
            if (paintedHeight > 0 && paintedWidth > 0) {
                if (font.pixelSize % 2) font.pixelSize++
                while (paintedWidth > width || paintedHeight > height) {
                    if ((font.pixelSize -= 2) <= minimumSize)
                        break
                }
                while (paintedWidth < width && paintedHeight < height) {
                    font.pixelSize += 2
                }
                font.pixelSize -= 2
                if (font.pixelSize >= maximumSize) {
                    font.pixelSize = maximumSize
                    return
                }
            }
        }
    }

    SequentialAnimation{
        id: flashAnimation
        ParallelAnimation {
            ColorAnimation {
                target: displayText
                property: "color"
                easing.type: Easing.InOutQuad
                duration: 50
                from: textColor
                to: "black"
            }
            NumberAnimation {
                target: background
                property: "opacity"
                easing.type: Easing.InOutQuad
                duration: 50
                to: 0.6
            }
        }
        ParallelAnimation {
            ColorAnimation {
                target: displayText
                property: "color"
                easing.type: Easing.InOutQuad
                duration: 200
                from: "black"
                to: textColor
            }
            NumberAnimation {
                target: background
                properties: "opacity"
                easing.type: Easing.InOutQuad
                duration: 200
                to: 0.0
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onPressed: display.pressed()
        onPressAndHold: {
            if (displayText.text != "0") {
                Clipboard.text = text
                display.textCopied(displayText.text)
                display.flash()
            }
        }
    }
}
