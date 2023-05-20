#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QWindow>
#include <QQmlContext>
#include "backend.h"
#include <iostream>
#include <thread>
#include <QTextStream>

class CursorPosProvider : public QObject
{
    Q_OBJECT
public:
    explicit CursorPosProvider(QObject *parent = nullptr) : QObject(parent)
    {
    }
    virtual ~CursorPosProvider() = default;

    Q_INVOKABLE QPointF cursorPos()
    {
        return QCursor::pos();
    }
};

class Utils: public QObject{
    Q_OBJECT
public:
    using QObject::QObject;
    Q_INVOKABLE void setAttrs(QWindow *window){
   //window->setFlags(Qt::WindowStaysOnTopHint |  Qt::FramelessWindowHint);
    }
};

void task1()
{
    BackEnd backend;
    backend.prepare();
}
void task2()
{
    BackEnd backend;
    backend.readevent();
}


int main(int argc, char *argv[])
{
    std::thread t1(task1);
//std::thread t2(task2);

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    Utils utils;
    qmlRegisterType<BackEnd>("io.qt.examples.backend", 1, 0, "BackEnd");
    QQmlApplicationEngine engine;
    CursorPosProvider mousePosProvider;

    engine.rootContext()->setContextProperty("mousePosition", &mousePosProvider);
    engine.rootContext()->setContextProperty("Utils", &utils);

    const QUrl mainQml(QStringLiteral("qrc:/main.qml"));

    // Catch the objectCreated signal, so that we can determine if the root component was loaded
    // successfully. If not, then the object created from it will be null. The root component may
    // get loaded asynchronously.
    const QMetaObject::Connection connection = QObject::connect(
                &engine, &QQmlApplicationEngine::objectCreated,
                &app, [&](QObject *object, const QUrl &url) {
            if (url != mainQml)
            return;

            if (!object)
            app.exit(-1);
            else
            QObject::disconnect(connection);
}, Qt::QueuedConnection);

    engine.load(mainQml);

   app.exec();
}
#include "main.moc"

