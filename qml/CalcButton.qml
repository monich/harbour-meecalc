/*
  Copyright (C) 2014 Jolla Ltd.
  Contact: Slava Monich <slava.monich@jolla.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0

MouseArea {
    id: button
    height: width

    property alias text: buttonText.text
    property bool selected: false
    property bool pressAnimationActive: false

    property color normalColor: "white"
    property color pressedColor: "black"
    property bool pressedState:  button.pressed || selected || pressAnimationActive

    Image {
        id: background
        anchors.fill: parent
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectFit
        source: Qt.resolvedUrl("meecalc-button-background.svg")
        smooth: true
    }

    Text {
        id: buttonText
        anchors.centerIn: parent
        font.pixelSize: parent.height * .7
        font.bold: true
        color: normalColor
    }

    states: [
        State {
            name: "pressed"
            when: pressedState
            PropertyChanges { target: background; opacity: 1 }
        },
        State {
            name: "normal"
            when: !pressedState
            PropertyChanges { target: background; opacity: 0 }
        }
    ]

    transitions: [
        Transition {
            from: "normal"
            to: "pressed"
            SequentialAnimation{
                PropertyAction {
                    target: button
                    property: "pressAnimationActive"
                    value: true
                }
                PropertyAction {
                    target: buttonText
                    property: "color"
                    value: pressedColor
                }
                NumberAnimation {
                    target: background
                    property: "opacity"
                    easing.type: Easing.OutCubic
                    duration: 50
                }
                PropertyAction {
                    target: button
                    property: "pressAnimationActive"
                    value: false
                }
            }
        },
        Transition {
            from: "pressed"
            to: "normal"
            SequentialAnimation{
                NumberAnimation {
                    properties: "opacity"
                    easing.type: Easing.InCubic
                    duration: 50
                }
                PropertyAction {
                    target: buttonText
                    property: "color"
                    value: normalColor
                }
            }
        }
    ]
}
