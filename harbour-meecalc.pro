NAME = meecalc
PREFIX = harbour
TARGET = $${PREFIX}-$${NAME}
CONFIG += sailfishapp
QMAKE_CXXFLAGS += -Wno-unused-parameter -Wno-psabi
LIBS += -ldl

CONFIG(debug, debug|release) {
    DEFINES += HARBOUR_DEBUG=1
}

TARGET_DATA_DIR = /usr/share/$${TARGET}

SOURCES += \
    src/main.cpp \
    src/CalcEngine.cpp \
    src/CalcState.cpp

SOURCES += \
    harbour-lib/src/HarbourJson.cpp

HEADERS += \
    src/CalcEngine.h \
    src/CalcState.h

HEADERS += \
    harbour-lib/include/HarbourDebug.h \
    harbour-lib/include/HarbourJson.h

INCLUDEPATH += \
    harbour-lib/include

HARBOUR_QML_COMPONENTS = \
    harbour-lib/qml/HarbourHighlightIcon.qml

OTHER_FILES += \
    $${HARBOUR_QML_COMPONENTS} \
    qml/*.qml \
    qml/*.svg \
    translations/*.ts \
    icons/*.svg \
    *.md \
    *.desktop \
    LICENSE \
    rpm/harbour-meecalc.changes \
    rpm/harbour-meecalc.spec

harbour_qml_components.files = $${HARBOUR_QML_COMPONENTS}
harbour_qml_components.path = $${TARGET_DATA_DIR}/qml/harbour
INSTALLS += harbour_qml_components

# Icons
ICON_SIZES = 86 108 128 172 256
for(s, ICON_SIZES) {
    icon_target = icon$${s}
    icon_dir = icons/$${s}x$${s}
    $${icon_target}.files = $${icon_dir}/$${TARGET}.png
    $${icon_target}.path = /usr/share/icons/hicolor/$${s}x$${s}/apps
    equals(PREFIX, "openrepos") {
        $${icon_target}.extra = cp $${icon_dir}/harbour-$${NAME}.png $$eval($${icon_target}.files)
        $${icon_target}.CONFIG += no_check_exist
    }
    INSTALLS += $${icon_target}
}

# Translations
TRANSLATIONS_PATH = /usr/share/$${TARGET}/translations
TRANSLATION_SOURCES = $${_PRO_FILE_PWD_}/qml

defineTest(addTrFile) {
    in = $${_PRO_FILE_PWD_}/translations/$${PREFIX}-$$1
    out = $${OUT_PWD}/translations/$${PREFIX}-$$1

    s = $$replace(1,-,_)
    lupdate_target = lupdate_$$s
    lrelease_target = lrelease_$$s

    $${lupdate_target}.commands = lupdate -noobsolete $${TRANSLATION_SOURCES} -ts \"$${in}.ts\" && \
        mkdir -p \"$${OUT_PWD}/translations\" &&  [ \"$${in}.ts\" != \"$${out}.ts\" ] && \
        cp -af \"$${in}.ts\" \"$${out}.ts\" || :

    $${lrelease_target}.target = $${out}.qm
    $${lrelease_target}.depends = $${lupdate_target}
    $${lrelease_target}.commands = lrelease -idbased \"$${out}.ts\"

    QMAKE_EXTRA_TARGETS += $${lrelease_target} $${lupdate_target}
    PRE_TARGETDEPS += $${out}.qm
    qm.files += $${out}.qm

    export($${lupdate_target}.commands)
    export($${lrelease_target}.target)
    export($${lrelease_target}.depends)
    export($${lrelease_target}.commands)
    export(QMAKE_EXTRA_TARGETS)
    export(PRE_TARGETDEPS)
    export(qm.files)
}

LANGUAGES = de fi fr nl ru sv

addTrFile($${NAME})
for(l, LANGUAGES) {
    addTrFile($${NAME}-$$l)
}

qm.path = $$TRANSLATIONS_PATH
qm.CONFIG += no_check_exist
INSTALLS += qm
