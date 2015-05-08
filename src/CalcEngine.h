/*
  Copyright (C) 2014-2015 Jolla Ltd.
  Contact: Slava Monich <slava.monich@jolla.com>

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions
  are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS
  BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
  THE POSSIBILITY OF SUCH DAMAGE.
*/

#ifndef CALCENGINE_H
#define CALCENGINE_H

#include <QtQml>

class CalcEngine : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int maxDigits READ maxDigits WRITE setMaxDigits NOTIFY maxDigitsChanged)
    Q_PROPERTY(QString locale READ locale WRITE setLocale NOTIFY localeChanged)
    Q_PROPERTY(QString selectedOp READ selectedOp NOTIFY selectedOpChanged)
    Q_PROPERTY(QString text READ text NOTIFY textChanged)

    class StateChangeBlocker;
    friend class StateChangeBlocker;

public:
    explicit CalcEngine(QObject* aParent = NULL);

    static const QString OP_MULTIPLY;
    static const QString OP_DIVIDE;
    static const QString OP_MINUS;
    static const QString OP_PLUS;

    Q_INVOKABLE void clear();
    Q_INVOKABLE void digit(int aDigit);
    Q_INVOKABLE void fraction();
    Q_INVOKABLE void backspace();
    Q_INVOKABLE void plusminus();
    Q_INVOKABLE void operation(QString aOperation);
    Q_INVOKABLE void enter();

    void setMaxDigits(int aMaxDigits);
    int maxDigits() const;
    QString locale() const;
    void setLocale(QString aLocale);
    QString selectedOp() const;
    QString text() const;
    QVariantMap state() const;
    void setState(QVariantMap aState);

private:
    double currentNumber() const;
    bool perform(QString aOperation);
    void setSelectedOp(QString aOperation);
    void resetSelectedOp() { setSelectedOp(""); }
    void checkForNewInput();
    void setText(QString aText);
    void updateText();
    void stateChanged();
    void suspendStateChanges();
    void resumeStateChanges();

signals:
    void stateChanged(QVariantMap aState);
    void maxDigitsChanged(int aValue);
    void localeChanged(QString aValue);
    void selectedOpChanged(QString aValue);
    void textChanged(QString aValue);
    void oops();

private:
    int iMaxDigits;
    int iPrecision;
    quint64 iNumerator;
    quint64 iDenominator;
    bool iMinus;
    bool iNewInput;
    double iLeft;
    QString iText;
    QString iPendingOp;
    QString iSelectedOp;
    QLocale iLocale;
    int iStateChangesSuspended;
    bool iStateChanged;
};

QML_DECLARE_TYPE(CalcEngine)

#endif // CALCENGINE_H
