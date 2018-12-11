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

MouseArea {
    id: button
    property string iconSourcePrefix
    property string iconSourceSuffix
    signal repeat()

    onPressedChanged: {
        if (pressed) {
            repeatDelayTimer.restart()
        } else {
            repeatDelayTimer.stop()
            repeatTimer.stop()
        }
    }

    Image {
        id: image
        anchors.centerIn: parent
        width: parent.width
        sourceSize.width: parent.width
        fillMode: Image.PreserveAspectFit
        source: iconSourcePrefix + Qt.resolvedUrl("meecalc-backspace.svg") + iconSourceSuffix
        smooth: true
    }

    Timer {
        id: repeatDelayTimer
        interval: 250
        repeat: false
        onTriggered: repeatTimer.restart()
    }

    Timer {
        id: repeatTimer
        interval: 100
        repeat: true
        onTriggered: button.repeat()
    }

    states: [
        State {
            name: "pressed"
            when: pressed
            PropertyChanges { target: image; opacity: 1 }
        },
        State {
            name: "normal"
            when: !pressed
            PropertyChanges { target: image; opacity: 0.6 }
        }
    ]

    transitions: [
        Transition {
            NumberAnimation {
                properties: "opacity"
                easing.type: Easing.OutQuad
                duration: 50
            }
        }
    ]
}
