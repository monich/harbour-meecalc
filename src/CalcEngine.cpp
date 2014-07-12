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

#include "CalcDebug.h"
#include "CalcEngine.h"

const QString CalcEngine::OP_MULTIPLY("\u00d7");
const QString CalcEngine::OP_DIVIDE("\u00f7");
const QString CalcEngine::OP_MINUS("-");
const QString CalcEngine::OP_PLUS("+");

CalcEngine::CalcEngine(QObject* aParent) :
    QObject(aParent),
    iMaxDigits(12),
    iLocale(QLocale::system())
{
    clear();
}

void CalcEngine::setMaxDigits(int aMaxDigits)
{
    if (iMaxDigits != aMaxDigits && aMaxDigits > 0) {
        iMaxDigits = aMaxDigits;
        emit maxDigitsChanged(aMaxDigits);
    }
}

int CalcEngine::maxDigits() const
{
    return iMaxDigits;
}

QString CalcEngine::locale() const
{
    return iLocale.name();
}

void CalcEngine::setLocale(QString aLocale)
{
    QString prevName = iLocale.name();
    iLocale = QLocale(aLocale);
    QString newName = iLocale.name();
    if (newName != prevName) {
        localeChanged(newName);
        updateText();
    }
}

QString CalcEngine::selectedOp() const
{
    return iSelectedOp;
}

void CalcEngine::setSelectedOp(QString aOperation)
{
    if (iSelectedOp != aOperation) {
        iSelectedOp = aOperation;
        selectedOpChanged(aOperation);
    }
}

QString CalcEngine::text() const
{
    return iText;
}

void CalcEngine::setText(QString aText)
{
    if (iText != aText) {
        iText = aText;
        textChanged(aText);
    }
}

void CalcEngine::updateText()
{
    QString text;
    if (iPrecision < 0) {
        text = iLocale.toString(iNumerator);
    } else if (iPrecision == 0) {
        text = iLocale.toString(iNumerator) + iLocale.decimalPoint();
    } else {
        double x = ((double)iNumerator/(double)iDenominator);
        text = iLocale.toString(x, 'f', iPrecision);
    }
    if (iMinus) text = QString("-") + text;
    setText(text);
}

void CalcEngine::clear()
{
    QDEBUG("clearing state");
    iNumerator = 0;
    iDenominator = 1;
    iPrecision = -1;
    iMinus = false;
    iNewInput = true;
    iLeft = 0.0;
    iPendingOp.clear();
    resetSelectedOp();
    updateText();
}

double CalcEngine::currentNumber() const
{
    double x = ((double)iNumerator/(double)iDenominator);
    return iMinus ? (-x) : x;
}

void CalcEngine::digit(int aDigit)
{
    QDEBUG(aDigit);

    if (iNewInput || !iSelectedOp.isEmpty()) {
        // We started typing new number
        iLeft = currentNumber();
        iNumerator = 0;
        iDenominator = 1;
        iPrecision = -1;
        iMinus = false;
        iNewInput = false;
        iPendingOp = iSelectedOp;
        resetSelectedOp();
    }

    // Check for overflow
    quint64 num = iNumerator * 10 + aDigit;
    if ((num-aDigit)/10 != iNumerator) {
        QDEBUG("overflow");
        emit oops();
    } else {
        QString str(QString::number(num));
        if (str.length() > iMaxDigits) {
            QDEBUG("too many digits:" << str.length());
            emit oops();
        } else {
            iNumerator = num;
            if (iPrecision >= 0) {
                iPrecision++;
                iDenominator *= 10;
                QDEBUG(iNumerator<<"/"<<iDenominator<<"("<<iPrecision<<")");
            } else {
                QDEBUG(iNumerator);
            }
            updateText();
        }
    }
}

void CalcEngine::fraction()
{
    QDEBUG("");
    if (iPrecision < 0) {
        iPrecision = 0;
        iDenominator = 1;
        updateText();
    } else {
        emit oops();
    }
}

void CalcEngine::backspace()
{
    if (!iSelectedOp.isEmpty()) {
        resetSelectedOp();
    } else if (iPrecision == 0) {
        QDEBUG("taking out decimal point");
        iPrecision--;
        iDenominator = 1;
        iMinus = false;
        updateText();
    } else if (iNumerator > 0) {
        iNumerator /= 10;
        if (iNumerator == 0) iMinus = false;
        if (iPrecision > 0) {
            iDenominator /= 10;
            iPrecision--;
        }
        QDEBUG(iNumerator);
        updateText();
    } else {
        QDEBUG("nothing to do");
    }
}

void CalcEngine::plusminus()
{
    if (iNumerator || iPrecision >= 0) {
        QDEBUG(iMinus);
        iMinus = !iMinus;
        updateText();
    } else {
        QDEBUG("zero");
    }
}

void CalcEngine::operation(QString aOperation)
{
    QDEBUG(aOperation);
    if (iSelectedOp == aOperation) {
        resetSelectedOp();
    } else {
        if (!iPendingOp.isEmpty()) {
            QDEBUG("performing pending operation");
            if (perform(iPendingOp)) {
                iPendingOp.clear();
            } else {
                emit oops();
            }
        }
        setSelectedOp(aOperation);
    }
}

void CalcEngine::enter()
{
    if (!iPendingOp.isEmpty()) {
        QDEBUG("performing pending operation");
        if (perform(iPendingOp)) {
            iPendingOp.clear();
        } else {
            emit oops();
        }
    } else if (!iSelectedOp.isEmpty()) {
        QDEBUG("performing selected operation");
        iLeft = currentNumber();
        if (perform(iSelectedOp)) {
            resetSelectedOp();
        } else {
            emit oops();
        }
    } else {
        QDEBUG("nothing to do");
    }
}

bool CalcEngine::perform(QString aOperation)
{
    double result, right = currentNumber();
    if (aOperation == OP_DIVIDE) {
        if (right == 0.0) {
            QDEBUG("division by zero");
            return false;
        }
        result = iLeft / right;
        QDEBUG(iLeft << "/" << right << "=" << result);
    } else if (aOperation == OP_MULTIPLY) {
        result = iLeft * right;
        QDEBUG(iLeft << "*" << right << "=" << result);
    } else if (aOperation == OP_MINUS) {
        result = iLeft - right;
        QDEBUG(iLeft << "-" << right << "=" << result);
    } else if (aOperation == OP_PLUS) {
        result = iLeft + right;
        QDEBUG(iLeft << "+" << right << "=" << result);
    } else {
        QDEBUG("unexpected operation" << aOperation);
        return false;
    }

    bool minus = (result < 0.0);
    if (minus) result = -result;
    double ipart;
    modf(result, &ipart);
    QString str(QString::number((quint64)ipart));
    if (str.length() > iMaxDigits) {
        QDEBUG("too many digits");
        emit oops();
        return false;
    } else {
        str = QString::number(result, 'f', iMaxDigits-str.length());
        while (str.endsWith('0')) str = str.left(str.length()-1);
        if (str.endsWith('.')) str = str.left(str.length()-1);
        int pos = str.indexOf('.');
        iDenominator = 1;
        if (pos > 0) {
            iPrecision = str.length()-1 - pos;
            for (int i=0; i<iPrecision; i++) {
                result *= 10;
                iDenominator *= 10;
            }
            modf(result, &ipart);
        } else {
            QASSERT(pos < 0);
            iPrecision = -1;
        }
        iNumerator = (quint64)ipart;
        iMinus = minus;
        QDEBUG("(" << iPrecision << ")" << (minus ? '-' : '+') <<
            iNumerator << "/" << iDenominator);
        updateText();
        iNewInput = true;
        return true;
    }
}
