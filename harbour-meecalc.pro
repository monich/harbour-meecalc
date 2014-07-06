TARGET = harbour-meecalc
CONFIG += sailfishapp
QMAKE_CXXFLAGS += -Wno-unused-parameter
QT += svg
QTPLUGIN += qsvg

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
