TARGET = harbour-meecalc
CONFIG += sailfishapp
QMAKE_CXXFLAGS += -Wno-unused-parameter -Wno-psabi
QT += svg

CONFIG(debug, debug|release) {
  DEFINES += CALC_DEBUG=1
}

SOURCES += \
    src/main.cpp \
    src/CalcEngine.cpp \
    src/CalcState.cpp

HEADERS += \
    src/CalcDebug.h \
    src/CalcEngine.h \
    src/CalcState.h

OTHER_FILES += \
    qml/*.qml \
    qml/*.svg \
    harbour-meecalc.desktop \
    rpm/harbour-meecalc.changes \
    rpm/harbour-meecalc.spec
