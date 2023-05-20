TEMPLATE = app
QT += gui quick
INCLUDEPATH += .
DEFINES += QT_DEPRECATED_WARNINGS
SOURCES += main.cpp \
    backend.cpp
RESOURCES += qml.qrc

HEADERS += \
    backend.h

CONFIG += qmltypes
QML_IMPORT_NAME = io.qt.examples.backend
QML_IMPORT_MAJOR_VERSION = 1

