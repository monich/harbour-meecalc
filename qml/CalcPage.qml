/*
 * Copyright (C) 2014-2021 Jolla Ltd.
 * Copyright (C) 2014-2021 Slava Monich <slava.monich@jolla.com>
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
 *      notice, this list of conditions and the following disclaimer
 *      in the documentation and/or other materials provided with the
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
import QtFeedback 5.0
import Sailfish.Silica 1.0
import org.nemomobile.notifications 1.0

Page {
    property alias engine: calculator.engine

    ThemeEffect {
        id: buzz

        effect: ThemeEffect.Press
    }

    Notification {
        id: notification

        //: Shown when display text has been copied to clipboard
        //% "Copied to clipboard"
        previewBody: qsTrId("calculator-notification-text_copied")
        Component.onCompleted: {
            if ("icon" in notification) {
                notification.icon = "icon-s-clipboard"
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    Calculator {
        id: calculator

        x: Theme.paddingLarge
        y: Theme.paddingLarge
        width: parent.width - 2 * x
        height: parent.height - 2 * y
        onTextCopied: {
            notification.publish()
            buzz.play()
        }
        onButtonPressed: {
            notification.close()
            buzz.play()
        }
    }
}
