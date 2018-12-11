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

#include "CalcEngine.h"
#include "CalcState.h"

#include "HarbourImageProvider.h"
#include "HarbourTheme.h"

#include <sailfishapp.h>

#include <QtGui>
#include <QtQuick>
#include <QStandardPaths>

#define MEECALC_APP "harbour-meecalc"

int main(int argc, char *argv[])
{
    QGuiApplication* app = SailfishApp::application(argc, argv);

    qmlRegisterType<CalcEngine>("harbour.meecalc", 1, 0, "CalcEngine");

    QString statePath(QStandardPaths::writableLocation(
         QStandardPaths::GenericDataLocation) +
         QStringLiteral("/" MEECALC_APP "/") +
         QStringLiteral("state.json"));
    CalcState* state = new CalcState(statePath, app);
    CalcEngine* calcEngine = new CalcEngine(app);
    calcEngine->setState(state->state());
    QObject::connect(calcEngine, SIGNAL(stateChanged(QVariantMap)),
        state, SLOT(onStateChanged(QVariantMap)));

    // Load translations
    QLocale locale;
    QTranslator* translator = new QTranslator(app);
    QString transDir = SailfishApp::pathTo("translations").toLocalFile();
    QString transFile("harbour-meecalc");
    if (translator->load(locale, transFile, "-", transDir) ||
        translator->load(transFile, transDir)) {
        app->installTranslator(translator);
    } else {
        qWarning() << "Failed to load translator for" << locale;
        delete translator;
    }

    QQuickView* view = SailfishApp::createView();
    QQmlEngine* engine = view->engine();
    QString imageProvider("meecalc");
    engine->addImageProvider(imageProvider, new HarbourImageProvider);

    QQmlContext* root = view->rootContext();
    root->setContextProperty("ImageProvider", imageProvider);
    root->setContextProperty("HarbourTheme", new HarbourTheme(app));
    root->setContextProperty("OP_MULTIPLY", CalcEngine::OP_MULTIPLY);
    root->setContextProperty("OP_DIVIDE", CalcEngine::OP_DIVIDE);
    root->setContextProperty("OP_MINUS", CalcEngine::OP_MINUS);
    root->setContextProperty("OP_PLUS", CalcEngine::OP_PLUS);
    root->setContextProperty("Engine", calcEngine);

    view->setSource(SailfishApp::pathTo(QString("qml/main.qml")));
    view->show();
    int result = app->exec();
    state->saveNow();
    delete view;
    delete app;
    return result;
}
