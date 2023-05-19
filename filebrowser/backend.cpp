
#include <QTextStream>
#include <QProcess>
#include "backend.h"
#include "unistd.h"
BackEnd::BackEnd(QObject *parent) :
    QObject(parent)
{
}
QString BackEnd::evnum() {
    return BackEnd::m_evnum;
}

void BackEnd::setEvnum(const QString &evnum)
{
BackEnd::m_evnum = evnum;
}
void BackEnd::prepare()
{


    QProcess OProcess;
    QString Command = "/bin/sh";
    QStringList args2 = {"/vkb-event.sh"};
    QTextStream cout(stdout);
  //  cout << args[1];
   OProcess.execute(Command,args2);


}

QString BackEnd::readevent()
{
    QProcess OProcess;
    QString Command = "/bin/cat";
    QStringList args2 = {"/vkb-event"};
    QTextStream cout(stdout);
  //  cout << args[1];
   OProcess.start(Command,args2);
   OProcess.waitForFinished();
   QString num;
   QStringList out;
   num = OProcess.readAllStandardOutput();
   out = num.split("event");
   //cout << out[1];
   out[1].chop(1);
   BackEnd::setEvnum(out[1]);
   //cout << BackEnd::evnum();
  return BackEnd::evnum();


}
void BackEnd::close(const QString &closed)
{
    QProcess OProcess;
    QString Command = "/bin/cat";
    QStringList args = {"/vkb-event-pid"};
    QTextStream cout(stdout);
  //  cout << args[1];
   OProcess.start(Command,args);
   OProcess.waitForFinished();
   QString pid = OProcess.readAllStandardOutput();
   pid.chop(1);
   cout << OProcess.readAllStandardOutput();
   QString Command2 = "/bin/kill";
   QStringList args2 = {pid};
   OProcess.execute(Command2,args2);
}


QString BackEnd::userName()
{
 //   return m_userName;
}

QString BackEnd::pressed()
{
 //   return m_userName;
}
QString BackEnd::closed()
{
 //   return m_userName;
}
QString BackEnd::released()
{
 //   return m_userName;
}


void BackEnd::setUserName(const QString &userName)
{
/**
    QProcess OProcess;
    QString Command;    //Contains the command to be executed
    QStringList args;   //Contains arguments of the command
    Command = "ls";
    args<<"-l"<<"/home/jingos";

    OProcess.start(Command,args,QIODevice::ReadOnly); //Starts execution of command
    OProcess.waitForFinished();                       //Waits for execution to complete

    QString StdOut      =   OProcess.readAllStandardOutput();  //Reads standard output
    QString StdError    =   OProcess.readAllStandardError();   //Reads standard error
    QTextStream cout(stdout);
    cout<<"\n Printing the standard output..........\n";
    cout<<endl<<StdOut;
    cout<<"\n Printing the standard error..........\n";
    cout<<endl<<StdError;

    cout<<"\n\n";
**/

    //m_userName = userName;
   // QTextStream out(stdout);
    //out << userName;
   // emit userNameChanged();
    QString num = BackEnd::readevent();
    QProcess OProcess;
    QString Command = "/usr/bin/evemu-event";
    QStringList args = {"/dev/input/event" + num, "--type", "EV_KEY", "--code", "KEY_" + userName, "--value", "1", "--sync"};
    QStringList args2 = {"/dev/input/event" + num, "--type", "EV_KEY", "--code", "KEY_" + userName, "--value", "0", "--sync"};
    QTextStream cout(stdout);
    OProcess.execute(Command,args);
    OProcess.execute(Command,args2);

}

void BackEnd::press(const QString &pressed)
{
    QString num = BackEnd::readevent();
    QProcess OProcess;
    QString Command = "/usr/bin/evemu-event";
    QStringList args2 = {"/dev/input/event" + num, "--type", "EV_KEY", "--code", "KEY_" + pressed, "--value", "1", "--sync"};
   OProcess.execute(Command,args2);

    QTextStream cout(stdout);
    //cout << BackEnd::readevent();
}

void BackEnd::release(const QString &released)
{
    QProcess OProcess;
    QString num = BackEnd::readevent();
    QString Command = "/usr/bin/evemu-event";
    QStringList args2 = {"/dev/input/event" + num, "--type", "EV_KEY", "--code", "KEY_" + released, "--value", "0", "--sync"};
    QTextStream cout(stdout);
  //  cout << args[1];
   // cout << "/dev/input/event" + backend.evnum;
    OProcess.execute(Command,args2);

  //  QTextStream cout(stdout);
    //cout << "release" << released;

}


