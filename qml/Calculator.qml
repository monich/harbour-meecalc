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
    id: calculator
    implicitWidth: buttons.width

    property var engine
    property color buttonTextColor: "white"
    property string iconSourcePrefix
    property string iconSourceSuffix

    readonly property int buttonSize: height/8
    readonly property int paddingSmall: Math.max(height/160,3)
    readonly property int paddingMedium: Math.max(height/80,2)
    readonly property int paddingLarge: Math.max(height/40,1)
    readonly property int gap: paddingLarge + paddingSmall

    signal textCopied(var text)
    signal buttonPressed()

    Connections {
        target: engine
        onOops: {
            console.log("oops")
            display.flash()
        }
    }

    Item {
        anchors {
            top: parent.top
            bottom: buttons.top
            left: parent.left
            right: parent.right
            bottomMargin: paddingSmall
        }

        Display {
            id: display
            text: engine.text
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
                right: backspace.left
                rightMargin: paddingLarge
            }
            onTextCopied: calculator.textCopied(text)
            onPressed: calculator.buttonPressed()
        }
        Backspace {
            id: backspace
            width: buttonSize/2
            iconSourcePrefix: calculator.iconSourcePrefix
            iconSourceSuffix: calculator.iconSourceSuffix
            anchors {
                top: parent.top
                bottom: parent.bottom
                right: parent.right
            }
            onPressed: {
                engine.backspace()
                calculator.buttonPressed()
            }
            onRepeat: engine.backspace()
        }
    }

    Column {
        id: buttons
        spacing: paddingSmall
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
        }

        Image {
            height: sourceSize.height
            width: parent.width - 2*paddingSmall
            anchors.horizontalCenter: parent.horizontalCenter
            source: "meecalc-separator-background.svg"
            fillMode: Image.TileHorizontally
        }

        Row {
            spacing: gap
            CalcButton {
                normalColor: buttonTextColor
                width: buttonSize
                text: "C"
                onPressed: {
                    engine.clear()
                    calculator.buttonPressed()
                }
            }
            CalcButton {
                id: divideButton
                normalColor: buttonTextColor
                width: buttonSize
                text: OP_DIVIDE
                onPressed: {
                    engine.operation(text)
                    calculator.buttonPressed()
                }
                selected: engine.selectedOp === text
            }
            CalcButton {
                id: multiplyButton
                normalColor: buttonTextColor
                width: buttonSize
                text: OP_MULTIPLY
                onPressed: {
                    engine.operation(text)
                    calculator.buttonPressed()
                }
                selected: engine.selectedOp === text
            }
        }
        Row {
            spacing: gap
            height: buttonSize + gap
            CalcButton {
                normalColor: buttonTextColor
                width: buttonSize
                text: "\u00b1"
                onPressed: {
                    engine.plusminus()
                    calculator.buttonPressed()
                }
            }
            CalcButton {
                id: minusButton
                normalColor: buttonTextColor
                width: buttonSize
                text: OP_MINUS
                onPressed: {
                    engine.operation(text)
                    calculator.buttonPressed()
                }
                selected: engine.selectedOp === text
            }
            CalcButton {
                id: plusButton
                normalColor: buttonTextColor
                width: buttonSize
                text: OP_PLUS
                onPressed: {
                    engine.operation(text)
                    calculator.buttonPressed()
                }
                selected: engine.selectedOp === text
            }
        }
        Row {
            spacing: gap
            CalcButton {
                normalColor: buttonTextColor
                width: buttonSize
                text: "7"
                onPressed: {
                    engine.digit(Number(text))
                    calculator.buttonPressed()
                }
            }
            CalcButton {
                normalColor: buttonTextColor
                width: buttonSize
                text: "8"
                onPressed: {
                    engine.digit(Number(text))
                    calculator.buttonPressed()
                }
            }
            CalcButton {
                normalColor: buttonTextColor
                width: buttonSize
                text: "9"
                onPressed: {
                    engine.digit(Number(text))
                    calculator.buttonPressed()
                }
            }
        }
        Row {
            spacing: gap
            CalcButton {
                normalColor: buttonTextColor
                width: buttonSize
                text: "4"
                onPressed: {
                    engine.digit(Number(text))
                    calculator.buttonPressed()
                }
            }
            CalcButton {
                normalColor: buttonTextColor
                width: buttonSize
                text: "5"
                onPressed: {
                    engine.digit(Number(text))
                    calculator.buttonPressed()
                }
            }
            CalcButton {
                normalColor: buttonTextColor
                width: buttonSize
                text: "6"
                onPressed: {
                    engine.digit(Number(text))
                    calculator.buttonPressed()
                }
            }
        }
        Row {
            spacing: gap
            CalcButton {
                normalColor: buttonTextColor
                width: buttonSize
                text: "1"
                onPressed: {
                    engine.digit(Number(text))
                    calculator.buttonPressed()
                }
            }
            CalcButton {
                normalColor: buttonTextColor
                width: buttonSize
                text: "2"
                onPressed: {
                    engine.digit(Number(text))
                    calculator.buttonPressed()
                }
            }
            CalcButton {
                normalColor: buttonTextColor
                width: buttonSize
                text: "3"
                onPressed: {
                    engine.digit(Number(text))
                    calculator.buttonPressed()
                }
            }
        }
        Row {
            spacing: gap
            CalcButton {
                normalColor: buttonTextColor
                width: buttonSize
                text: "0"
                onPressed: {
                    engine.digit(Number(text))
                    calculator.buttonPressed()
                }
            }
            CalcButton {
                normalColor: buttonTextColor
                width: buttonSize
                text: Qt.locale().decimalPoint
                onPressed: {
                    engine.fraction()
                    calculator.buttonPressed()
                }
            }
            CalcButton {
                width: buttonSize
                text: "="
                normalColor: "#ef9608"
                onPressed: {
                    engine.enter()
                    calculator.buttonPressed()
                }
            }
        }
    }
}
