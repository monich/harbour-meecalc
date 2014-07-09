TARGET = harbour-meecalc
CONFIG += sailfishapp
QMAKE_CXXFLAGS += -Wno-unused-parameter

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
    src/SvgPlugin.json \
    harbour-meecalc.desktop \
    rpm/harbour-meecalc.changes \
    rpm/harbour-meecalc.spec

# qtsvg

QT_SVG_RENDERER_DIR = qtsvg/src/svg

DEFINES += QT_STATIC QT_STATICPLUGIN
LIBS += -lz

INCLUDEPATH += \
  $$QT_SVG_RENDERER_DIR \
  qtsvg/private/QtCore \
  qtsvg/private/QtGui \

SOURCES += \
  $$QT_SVG_RENDERER_DIR/qsvggraphics.cpp \
  $$QT_SVG_RENDERER_DIR/qsvghandler.cpp \
  $$QT_SVG_RENDERER_DIR/qsvgnode.cpp \
  $$QT_SVG_RENDERER_DIR/qsvgstructure.cpp \
  $$QT_SVG_RENDERER_DIR/qsvgstyle.cpp \
  $$QT_SVG_RENDERER_DIR/qsvgfont.cpp \
  $$QT_SVG_RENDERER_DIR/qsvgtinydocument.cpp \
  $$QT_SVG_RENDERER_DIR/qsvgrenderer.cpp

#  $$QT_SVG_RENDERER_DIR/qsvgwidget.cpp \
#  $$QT_SVG_RENDERER_DIR/qgraphicssvgitem.cpp \
#  $$QT_SVG_RENDERER_DIR/qsvggenerator.cpp

HEADERS += \
  $$QT_SVG_RENDERER_DIR/qsvggraphics_p.h \
  $$QT_SVG_RENDERER_DIR/qsvghandler_p.h \
  $$QT_SVG_RENDERER_DIR/qsvgnode_p.h \
  $$QT_SVG_RENDERER_DIR/qsvgstructure_p.h \
  $$QT_SVG_RENDERER_DIR/qsvgstyle_p.h \
  $$QT_SVG_RENDERER_DIR/qsvgfont_p.h \
  $$QT_SVG_RENDERER_DIR/qsvgtinydocument_p.h \
  $$QT_SVG_RENDERER_DIR/qsvgrenderer.h \
  $$QT_SVG_RENDERER_DIR/qtsvgglobal.h

#  $$QT_SVG_RENDERER_DIR/qsvgwidget.h \
#  $$QT_SVG_RENDERER_DIR/qgraphicssvgitem.h \
#  $$QT_SVG_RENDERER_DIR/qsvggenerator.h \

QT_SVG_PLUGIN_DIR = qtsvg/src/plugins/imageformats/svg

INCLUDEPATH += \
  $$QT_SVG_PLUGIN_DIR

SOURCES += \
  src/SvgPlugin.cpp \
  $$QT_SVG_PLUGIN_DIR/qsvgiohandler.cpp

HEADERS += \
  src/SvgPlugin.h \
  $$QT_SVG_PLUGIN_DIR/qsvgiohandler.h
