TARGET = harbour-meecalc
CONFIG += sailfishapp
QMAKE_CXXFLAGS += -Wno-unused-parameter
QT += svg

CONFIG(debug, debug|release) {
  DEFINES += CALC_DEBUG=1
}

SOURCES += \
    src/main.cpp \
    src/CalcEngine.cpp

HEADERS += \
    src/CalcDebug.h \
    src/CalcEngine.h

OTHER_FILES += \
    qml/*.qml \
    qml/*.png \
    qml/*.svg \
    harbour-meecalc.desktop \
    rpm/harbour-meecalc.changes \
    rpm/harbour-meecalc.spec

# qtsvg

DEFINES += QT_STATIC QT_STATICPLUGIN
LIBS += -lz

QT_SVG_PLUGIN_DIR = qtsvg

INCLUDEPATH += \
  $$QT_SVG_PLUGIN_DIR

SOURCES += \
  $$QT_SVG_PLUGIN_DIR/qsvgiohandler.cpp \
  $$QT_SVG_PLUGIN_DIR/qsvgplugin.cpp

HEADERS += \
  $$QT_SVG_PLUGIN_DIR/qsvgiohandler.h \
  $$QT_SVG_PLUGIN_DIR/qsvgplugin.h

OTHER_FILES += \
  $$QT_SVG_PLUGIN_DIR/svg.json
