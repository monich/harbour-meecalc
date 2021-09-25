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
import Sailfish.Silica 1.0

Item {
    id: calculator

    implicitWidth: 3 * buttonSize + 2 + Theme.paddingSmall

    property var engine
    property color foregroundColor: "white"

    readonly property int buttonSize: Math.floor(height/8)
    readonly property int sizeTiny: Math.max(Math.floor(height/1024),1)

    signal textCopied(var text)
    signal buttonPressed()

    Connections {
        target: engine
        onOops: display.flash()
    }

    Item {
        anchors {
            top: parent.top
            bottom: buttons.top
            left: parent.left
            right: parent.right
        }

        Display {
            id: display
            text: engine.text
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
                right: backspace.left
                rightMargin: Theme.paddingLarge
            }
            onTextCopied: calculator.textCopied(text)
            onPressed: calculator.buttonPressed()
        }

        Backspace {
            id: backspace
            width: buttonSize/2
            foregroundColor: calculator.foregroundColor
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

        spacing: Theme.paddingSmall
        width: parent.width
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
        }

        Rectangle {
            width: parent.width
            height: sizeTiny * 2
            anchors.horizontalCenter: parent.horizontalCenter
            color: foregroundColor
            opacity: 0.2

            Rectangle {
                y: sizeTiny
                width: parent.width
                height: sizeTiny
                color: foregroundColor
                opacity: 0.6
            }
        }

        Grid {
            rows: 6
            columns: 3
            rowSpacing: Math.min((calculator.height - (rows + 1) * buttonSize) / (rows + 2))
            columnSpacing: Math.min((calculator.width - columns * buttonSize) / (columns + 1))
            x: columnSpacing

            CalcButton {
                normalColor: foregroundColor
                width: buttonSize
                text: "C"
                onPressed: {
                    engine.clear()
                    calculator.buttonPressed()
                }
            }

            CalcButton {
                normalColor: foregroundColor
                width: buttonSize
                text: OP_DIVIDE
                onPressed: {
                    engine.operation(text)
                    calculator.buttonPressed()
                }
                selected: engine.selectedOp === text
            }

            CalcButton {
                normalColor: foregroundColor
                width: buttonSize
                text: OP_MULTIPLY
                onPressed: {
                    engine.operation(text)
                    calculator.buttonPressed()
                }
                selected: engine.selectedOp === text
            }

            // -------------------------------------

            CalcButton {
                normalColor: foregroundColor
                width: buttonSize
                text: "\u00b1"
                onPressed: {
                    engine.plusminus()
                    calculator.buttonPressed()
                }
            }

            CalcButton {
                normalColor: foregroundColor
                width: buttonSize
                text: OP_MINUS
                onPressed: {
                    engine.operation(text)
                    calculator.buttonPressed()
                }
                selected: engine.selectedOp === text
            }

            CalcButton {
                normalColor: foregroundColor
                width: buttonSize
                text: OP_PLUS
                onPressed: {
                    engine.operation(text)
                    calculator.buttonPressed()
                }
                selected: engine.selectedOp === text
            }

            // -------------------------------------

            CalcButton {
                normalColor: foregroundColor
                width: buttonSize
                text: "7"
                onPressed: {
                    engine.digit(Number(text))
                    calculator.buttonPressed()
                }
            }

            CalcButton {
                normalColor: foregroundColor
                width: buttonSize
                text: "8"
                onPressed: {
                    engine.digit(Number(text))
                    calculator.buttonPressed()
                }
            }

            CalcButton {
                normalColor: foregroundColor
                width: buttonSize
                text: "9"
                onPressed: {
                    engine.digit(Number(text))
                    calculator.buttonPressed()
                }
            }

            // -------------------------------------

            CalcButton {
                normalColor: foregroundColor
                width: buttonSize
                text: "4"
                onPressed: {
                    engine.digit(Number(text))
                    calculator.buttonPressed()
                }
            }

            CalcButton {
                id: digit5

                normalColor: foregroundColor
                width: buttonSize
                text: "5"
                onPressed: {
                    engine.digit(Number(text))
                    calculator.buttonPressed()
                }
            }

            CalcButton {
                normalColor: foregroundColor
                width: buttonSize
                text: "6"
                onPressed: {
                    engine.digit(Number(text))
                    calculator.buttonPressed()
                }
            }

            // -------------------------------------

            CalcButton {
                normalColor: foregroundColor
                width: buttonSize
                text: "1"
                onPressed: {
                    engine.digit(Number(text))
                    calculator.buttonPressed()
                }
            }

            CalcButton {
                normalColor: foregroundColor
                width: buttonSize
                text: "2"
                onPressed: {
                    engine.digit(Number(text))
                    calculator.buttonPressed()
                }
            }

            CalcButton {
                normalColor: foregroundColor
                width: buttonSize
                text: "3"
                onPressed: {
                    engine.digit(Number(text))
                    calculator.buttonPressed()
                }
            }

            // -------------------------------------

            CalcButton {
                normalColor: foregroundColor
                width: buttonSize
                text: "0"
                onPressed: {
                    engine.digit(Number(text))
                    calculator.buttonPressed()
                }
            }

            CalcButton {
                normalColor: foregroundColor
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
