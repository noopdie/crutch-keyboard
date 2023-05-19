#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QString>
#include <qqml.h>

class BackEnd : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString userName READ userName WRITE setUserName NOTIFY userNameChanged)
     Q_PROPERTY(QString evnum READ evnum WRITE setEvnum)
    Q_PROPERTY(QString pressed READ pressed WRITE press NOTIFY pressChanged)
    Q_PROPERTY(QString released READ released WRITE release NOTIFY releaseChanged)
    Q_PROPERTY(QString closed READ closed WRITE close NOTIFY closeChanged)

    //QML_ELEMENT


public:
    explicit BackEnd(QObject *parent = nullptr);

    QString userName();
    QString evnum();
    QString closed();

    QString pressed();
    QString released();
    void setEvnum(const QString &evnum);
    void setUserName(const QString &userName);
    void press(const QString &userName);
    void release(const QString &userName);
    void close(const QString &closed);
    void prepare();
    QString readevent();

signals:
    void userNameChanged();
    void pressChanged();
    void closeChanged();
    void releaseChanged();

private:
   QString m_evnum;
};

#endif // BACKEND_H
