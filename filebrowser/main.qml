import QtQuick 2.12
import QtQuick.Shapes 1.12
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Window 2.3
import io.qt.examples.backend 1.0

Window {
    id: window
    visible: true
    opacity: 1
    width: 640

    height: 310
    flags: Qt.Popup | Qt.WindowStaysOnTopHint |  Qt.FramelessWindowHint
    Component.onCompleted: { Utils.setAttrs(window);
    }
    x: screen.width / 2 - 640/2
    y: screen.height / 2 - 310/2
    title: qsTr("Stack")
    color: "#55143737"
    property bool password: false
    signal accepted(string text);   // onAccepted: print('onAccepted', text)
    signal rejected();              // onRejected: print('onRejected')
    property double rowSpacing:     0.01 * width  // horizontal spacing between keyboard
    property double columnSpacing:  0.02 * height // vertical   spacing between keyboard
    property bool   shift:          false
    property bool   ctrl:          false
    property bool  ru: false
        property bool   alt:          false
        property bool   caps:          false
    property bool   symbols:        false
    property double wwidth:        0
    property string repeatkey
    property double wheight: 0
    property double wx: 0
    property double wy: 0
    property bool wmax: false
    property bool minimized: false
    property double columns:        10
    property double rows:           5
property int colwidth: keyboard.width / 15
    property int colheight: keyboard.height / rows - columnSpacing

    BackEnd {
        id: backend
    }

    function toggleMaximized() {
        if (window.visibility === Window.Maximized) {
            window.showNormal();
        } else {
            window.showMaximized();
        }
    }
    MouseArea {
         id: borderMouseRegion

         property var clickPos
         anchors.fill: parent
         onPressed: {
             clickPos = { x: mouse.x, y: mouse.y }
         }
         onPositionChanged: {

             var e = ''
             if ((mousePosition.cursorPos().x - window.x) / window.width < 0.30) { e += 'left' }
             if ((mousePosition.cursorPos().x - window.x) / window.width > 0.70) { e += 'right' }
             if ((mousePosition.cursorPos().y - window.y) / window.height < 0.30) { e += 'top' }
             if ((mousePosition.cursorPos().y - window.y) / window.height > 0.70) { e += 'bottom' }
             var ex;
             var ey;
             switch(e) {
             case 'left':
             ex = window.x;
             window.x = mousePosition.cursorPos().x - clickPos.x;
             window.width -= window.x - ex;
             break
             case 'right':
             window.width = mouse.x
             break
             case 'top':
             ey = window.y;
             window.y = mousePosition.cursorPos().y - clickPos.y;
            window.height -= window.y - ey;
             break
             case 'bottom':
             window.height = mouse.y;
             break
             case 'lefttop':
                 ex = window.x;
                 window.x = mousePosition.cursorPos().x - clickPos.x;
                 window.width -= window.x - ex;
                 ey = window.y;
                 window.y = mousePosition.cursorPos().y - clickPos.y;
                window.height -= window.y - ey;
             break
             case 'leftbottom':
                 ex = window.x;
                 window.x = mousePosition.cursorPos().x - clickPos.x;
                 window.width -= window.x - ex;
                 window.height = mouse.y;
                 break
             case 'righttop':
                              window.width = mouse.x
                 ey = window.y;
                 window.y = mousePosition.cursorPos().y - clickPos.y;
                window.height -= window.y - ey;
                 break
             case 'rightbottom':
             window.width = mouse.x
            window.height = mouse.y;
                 break
             }
         }
    }
    /**
    DragHandler {
        id: resizeHandler
        grabPermissions: TapHandler.TakeOverForbidden
        target: null
        onActiveChanged: if (active) {
            const p = resizeHandler.centroid.position;
            let e = 0;
            if (p.x / width < 0.10) { e |= Qt.LeftEdge }
            if (p.x / width > 0.90) { e |= Qt.RightEdge }
            if (p.y / height < 0.10) { e |= Qt.TopEdge }
            if (p.y / height > 0.90) { e |= Qt.BottomEdge }
            console.log("RESIZING", e);
            window.startSystemResize(e);
        }
    }
**/
    Page {
        anchors.fill: parent
        background: none
        anchors.margins: window.visibility === Window.Windowed ? 15 : 0
        header: Item {
            height: 30
            Item {
                id: lol
                anchors.fill: parent
                MouseArea {
                     id: titleBarMouseRegion
                     property var clickPos
                     anchors.fill: parent
                     onPressed: {
                         clickPos = { x: mouse.x, y: mouse.y }
                     }
                     onPositionChanged: {
                         window.x = mousePosition.cursorPos().x - clickPos.x
                         window.y = mousePosition.cursorPos().y - clickPos.y
                     }
                }
                RowLayout {
                    anchors.left: parent.left
                    spacing: 3
                    anchors.bottom: parent.bottom
                    ToolButton {
                        id: toolButton
                        background: Rectangle {
                            color: "#fff"

                            opacity: 0.4
                            radius: 10
                        }

                        leftPadding: 10
                        rightPadding: 10
                        visible: minimized ? false : true;
                        text: "\u2630"

                        font.pixelSize: Qt.application.font.pixelSize * 1.6
                        onClicked: drawer.open()
                    }
                }

                RowLayout {
                    spacing: 7
                    anchors.right: parent.right
                   anchors.bottom: parent.bottom
                    anchors.rightMargin: 5
                    ToolButton {
                        background: Rectangle {
                            color: "#fff"
                            opacity: 0.4
                            radius: 50
                        }
                        leftPadding: 14
                        rightPadding: 14
                        text: !minimized ? "🗕" : "🗖"
                        font.pixelSize: Qt.application.font.pixelSize * 1.5
                        onClicked: {
                            if (!minimized) {
                            wwidth = window.width;
                             wheight = window.height;
                                wx = window.x;
                                wy = window.y;
                                window.width = 100;
                                window.height = 30;
                                window.x += wwidth - 100
                                minimized = true
                                if (maxButton.text == "🗖") {

                                    window.toggleMaximized()
                                    wmax = false;
                                } else {
                                    wmax = true;
                                }

                            } else  {
                                minimized = false;
                                window.width = wwidth;
                                window.x -= wwidth - 100
                                window.height = wheight
                                if (!wmax) window.toggleMaximized();
                            }
                        }
                    }
                    ToolButton {
                        id: maxButton
                        background: Rectangle {
                            color: "#fff"
                            opacity: 0.4
                            radius: 50
                        }
                        leftPadding: 12
                        rightPadding: 12
                        text: window.visibility == Window.Maximized ? "🗗" : "🗖"
                        visible: minimized ? false : true;
                        font.pixelSize: Qt.application.font.pixelSize * 1.5
                        onClicked: { window.toggleMaximized()
                         wmax = !wmax
                        }
                    }
                    ToolButton {
                        text: "🗙"
                        background: Rectangle {
                            color: "#fff"
                            opacity: 0.4
                            radius: 50
                        }
                        leftPadding: 14
                        rightPadding: 14
                        visible: minimized ? false : true;
                        font.pixelSize: Qt.application.font.pixelSize * 1.5
                        onClicked: {
                            backend.closed = "Duh";
                            window.close()
                        }
                    }
                }
            }
        }

        Drawer {
            id: drawer
            width: window.width * 0.66
            background: Rectangle {
                color: "#143737"
                opacity: 0.97
                radius: 10
            }

            Component.onCompleted: {
                this.contentItem.color = "white"
            }
            height: window.height
            interactive: window.visibility !== Window.Windowed || position > 0


//                 Component.onCompleted: ()=> Utils.setAttrs(window);

}
       Page {
            id: view
visible: minimized ? false : true;
        // public


        // private
            width: parent.width;  height: parent.height // default size


            MouseArea {anchors.fill: parent} // don't allow touches to pass to MouseAreas underneath
background: none
Timer {
    id: remover
    interval: 1000
    running: false
    repeat: true
    onTriggered: function() { this.interval = 70; view.clicked(repeatkey) }
}
            Page {
                width: parent.width;  height: 0.98 * parent.height
                anchors.bottom: parent.bottom
                background: none
                Page { // keys
                    id: keyboard
                    anchors {fill: parent; leftMargin: columnSpacing}
background: none
                    Column {
                        spacing: columnSpacing
                        Row { // 1234567890
                            spacing: rowSpacing
                            Repeater {

                                model: [
                                    {text:  (ru) ? 'ё' : '`', sym: (ru) ? 'Ё' : '~', width: '1'},
                                     {text: '1', sym: '!', width: 1},
                                     {text: '2', sym: (ru) ? '"' : '@',  width: 1},
                                     {text: '3', sym: (ru) ? '№' : '#',  width: 1},
                                     {text: '4', sym: (ru) ? ';' : '$',  width: 1},
                                     {text: '5', sym: '%',  width: 1},
                                     {text: '6', sym: (ru) ? ':' : '^',  width: 1},
                                     {text: '7', sym: (ru) ? '?' : "\uFE60",  width: 1},
                                     {text: '8', sym: (ru) ? '*' : '*',  width: 1},
                                     {text: '9', sym:'(',  width: 1},
                                     {text: '0', sym: (ru) ? 'й' : ')',  width: 1},
                                     {text: '-', sym : '_', width: 1},
                                    {text: '=', sym: '+', width: 1}
                                ]

                                delegate: Button {
                                    focus:true
                                    Keys.onPressed: (e)=> {window.toggleMximized()}

                                    background: Rectangle {
                                        color: "#fff"
                                        opacity: 0.4
                                        radius: this.height / 6
                                    }

                                    text: (shift) ? modelData.sym : modelData.text
                                    width: colwidth
                                    height: colheight
                                    onClicked: view.clicked((modelData.t) ? modelData.t : modelData.text)
                                    onPressed: if (!modelData.norepeat) { remover.interval = 700; remover.running = true; repeatkey = (modelData.t) ? modelData.t : modelData.text}
                                    onReleased: remover.running = false
                                    font.pixelSize: this.height / 2
                                }
                            }
                        }

                        Row { // qwertyuiop
                            spacing: rowSpacing

                            Repeater {
                                model: [

                                     {text: 'TAB', symbol: '+',      width: 1},
                                     {t: 'q', text: (ru) ? 'й' : 'q', symbol: '+',      width: 1},
                                     {t: 'w', text: (ru) ? 'ц' : 'w', symbol: '\u00D7', width: 1}, // MULTIPLICATION SIGN
                                     {t: 'e', text: (ru) ? 'у' : 'e', symbol: '\u00F7', width: 1}, // DIVISION SIGN
                                     {t: 'r', text: (ru) ? 'к' : 'r', symbol:      '=', width: 1},
                                     {t: 't', text: (ru) ? 'е' : 't', symbol:      '/', width: 1},
                                     {t: 'y', text: (ru) ? 'н' : 'y', symbol:      '_', width: 1},
                                     {t: 'u', text: (ru) ? 'г' : 'u', symbol:      '<', width: 1},
                                     {t: 'i', text: (ru) ? 'ш' : 'i', symbol:      '>', width: 1},
                                     {t: 'o', text: (ru) ? 'щ' : 'o', symbol:      '[', width: 1},
                                     {t:'p', text: (ru) ? 'з' : 'p', symbol:      ']', width: 1},
                                    {t: '[', text: (ru) ? 'х' : '[', sym: '{', width: 1},
                                    {t: ']',text: (ru) ? 'ъ' : ']', sym: '}', width: 1},
                                    {text: '\\', sym: '|', width: 1}
                                ]

                                delegate: Button {
                                    background: Rectangle {
                                        color: "#fff"
                                        opacity: 0.4
                                        radius: this.height / 6
                                    }

                                    text: ((shift || caps) && !(caps && shift)) ? ((modelData.sym) ? modelData.sym : modelData.text.toUpperCase()) :  modelData.text
                                    width: keyboard.width / 16.5 * modelData.width
                                    height: colheight
                                    font.pixelSize:  (modelData.text.toUpperCase() === 'TAB') ? this.height / 5 : this.height / 2
                                    onClicked: view.clicked((modelData.t) ? modelData.t : modelData.text)
                                    onPressed: if (!modelData.norepeat) { remover.interval = 700; remover.running = true; repeatkey = (modelData.t) ? modelData.t : modelData.text}
                                    onReleased: remover.running = false

                                }
                            }
                        }

                        Row { // asdfghjkl
                            spacing: rowSpacing

                            Repeater {
                                model: [
                                    {norepeat: true, text: (caps) ? 'CAPS' : 'caps', width: 1},
                                     {t: 'a', text: (ru) ? 'ф' : 'a', symbol: '!', width: 1},
                                     {t: 's', text: (ru) ? 'ы' : 's', symbol: '@', width: 1},
                                     {t: 'd', text: (ru) ? 'в' : 'd', symbol: '#', width: 1},
                                     {t: 'f', text: (ru) ? 'а' : 'f', symbol: '$', width: 1},
                                     {t: 'g', text: (ru) ? 'п' : 'g', symbol: '%', width: 1},
                                     {t: 'h', text: (ru) ? 'р' : 'h', symbol: '&', width: 1},
                                     {t: 'j', text: (ru) ? 'о' : 'j', symbol: '*', width: 1},
                                     {t: 'k', text: (ru) ? 'л' : 'k', symbol: '(', width: 1},
                                     {t: 'l', text: (ru) ? 'д' : 'l', symbol: ')', width: 1},
                                    {t: ';', text: (ru) ? 'ж' : ';', sym:  (ru) ? 'Ж' : ':', width: 1},
                                    {t: "'", text: (ru) ? 'э' : "'", sym: (ru) ? 'Э' : '"', width: 1},
                                    {text: '\u21E6', symbol: '\u21E6', width: 1}, // LEFTWARDS ARROW (backspace)
                                ]
                                delegate: Button {
                                    background: Rectangle {
                                        color: "#fff"
                                        opacity: 0.4
                                        radius: this.height / 6
                                    }
                                    text: ((shift || caps) && !(caps && shift)) ? ((modelData.sym) ? modelData.sym : modelData.text.toUpperCase()) :  modelData.text
                                    width: colwidth * modelData.width
                                    height: colheight
                                    font.pixelSize: (modelData.norepeat) ? this.height / 5 : this.height / 2;
                                    onClicked: view.clicked((modelData.t) ? modelData.t : modelData.text)

                                    onPressed: if (!modelData.norepeat) { remover.interval = 700; remover.running = true; repeatkey = (modelData.t) ? modelData.t : modelData.text}
                                    onReleased: remover.running = false

                                }
                            }

                        }

                        Row { // zxcvbnm
                            spacing: rowSpacing

                            Repeater {

                                model: [
                                     {text: '\u21E7', symbol:       '', width: 1.5, norepeat: true}, // UPWARDS ARROW (shift)
                                     {t: 'z', text: (ru) ? 'я' : 'z',      symbol:      '-', width: 1},
                                     {t: 'x', text: (ru) ? 'ч' : 'x',      symbol:      "'", width: 1},
                                     {t: 'c', text: (ru) ? 'с' : 'c',      symbol:      '"', width: 1},
                                     {t: 'v', text: (ru) ? 'м' : 'v',      symbol:      ':', width: 1},
                                     {t: 'b', text: (ru) ? 'и' : 'b',      symbol:      ';', width: 1},
                                     {t: 'n', text: (ru) ? 'т' : 'n',      symbol:      ',', width: 1},
                                     {t: 'm', text: (ru) ? 'ь' : 'm',      symbol:      '?', width: 1},
                                    {t: ',', text: (ru) ? 'б' : ',', sym: (ru) ? 'Б' : '<', width: 1},
                                    {t: '.', text: (ru) ? 'ю' : '.', sym: (ru) ? 'Ю' : '>', width: 1},
                                    {t: '/', text: (ru) ? '.' : '/', sym: (ru) ? ',' : '?', width: 1},
                                     {text:            '\u21B5', width: 1.5}, // DOWNWARDS ARROW WITH CORNER LEFTWARDS (enter)
                                ]
                                delegate: Button {
                                    background: Rectangle {
                                        color: "#fff"
                                        opacity: 0.4
                                        radius: this.height / 6
                                    }
                                    text: symbols? modelData.symbol: ((shift || caps) && !(caps && shift)) ? modelData.text.toUpperCase():  modelData.text
                                    width: colwidth * modelData.width
                                    height: colheight
                                    enabled: text == '\u2190'? textInput.text: true // LEFTWARDS ARROW (backspace)
                                    font.pixelSize: this.height / 2
                                    onClicked: view.clicked((modelData.t) ? modelData.t : modelData.text)
                                    onPressed: if (!modelData.norepeat) { remover.interval = 700; remover.running = true; repeatkey = (modelData.t) ? modelData.t : modelData.text}
                                    onReleased: remover.running = false
                                }
                            }
                        }

                        Row { // space
                            spacing: rowSpacing

                            Repeater {
                                model: [
                                     {text: (ctrl) ? 'CTRL'  : 'ctrl', width: 1, norepeat: true},
                                    {text: (alt) ? 'ALT' : 'alt', width: 1, norepeat: true},
                                     {text:                 ' ', width: 4}, // space
                                     {text:                 '\u2190', width: 1},
                                     {text:                 '\u2192', width: 1},
                                     {text:                 '\u2191', width: 1},
                                     {text:                 '\u2193', width: 1},
                                ]
                                delegate: Button {
                                    background: Rectangle {
                                        color: "#fff"
                                        opacity: 0.4
                                        radius: this.height / 6
                                    }
                                    text:    (shift && modelData.sym) ? modelData.sym : modelData.text
                                    width: keyboard.width / 11 * modelData.width
                                    height: colheight
                                    enabled: text == '\u21B5'? textInput.text: true // DOWNWARDS ARROW WITH CORNER LEFTWARDS (enter)
                                    font.pixelSize: this.height / 3
                                    onClicked: view.clicked(modelData.text)
                                    onPressed: if (!modelData.norepeat) { remover.interval = 700; remover.running = true; repeatkey = (modelData.t) ? modelData.t : modelData.text}
                                    onReleased: remover.running = false
                                }
                            }
                        }
                }
                }
            }

            signal clicked(string text)
            onClicked: {
                if(     text == '\u21E6') { // LEFTWARDS ARROW (backspace)
                text = 'BACKSPACE'
                }
                //else if(text == '@#' )     symbols = true
                //if(text == '\u2191') text = 'LEFTSHFT'
                if(text == 'AB'   )   symbols = false
                if(text == '\u21B5')  text = 'ENTER' // DOWNWARDS ARROW WITH CORNER LEFTWARDS (enter)
                if(text == ' ') text = 'SPACE';
                if(text == '-') text = 'MINUS';
                if(text == '_') text = 'MINUS';
                if(text == '=') text = 'EQUAL';
                if(text == '+') text = 'EQUAL';
                if(text == '`') text = 'GRAVE';
                if(text == '~') text = 'GRAVE';
                if(text == ',') text = 'COMMA'
                if(text == '.') text = 'DOT'
                if(text == '\u2190')  text = 'LEFT'
                if(text == '\u2192')  text = 'RIGHT'
                if(text == '\u2191')  text = 'UP'
                if(text == '\u2193')  text = 'DOWN'
                if (text == '[') text = 'LEFTBRACE'
                if (text == ']') text = 'RIGHTBRACE'
                if (text == '\\') text = 'BACKSLASH'
                if (text == ';') text = 'SEMICOLON'
                if (text == '/') text = 'SLASH'
                if (text == "'") text = 'APOSTROPHE'

                if(text == 'CTRL' || text == 'ctrl') {
                    text = 'LEFTCTRL'
                    if (!shift) backend.pressed = 'LEFTCTRL';
                    else backend.released = 'LEFTCTRL'
                     ctrl = !ctrl
                } else
                    if(text == 'ALT' || text == 'alt') {
                        text = 'LEFTALT'
                        if (!alt) backend.pressed = 'LEFTALT';
                        else backend.released = 'LEFTALT'
                         alt = !alt
                    } else
                        if(text == 'CAPS' || text == 'caps') {
                            text = 'CAPSLOCK';
                                backend.userName = 'CAPSLOCK';
                                caps = !caps;
                            console.log(caps);
                        } else
            if(text == '\u21E7') {
               if (!shift) backend.pressed = 'LEFTSHIFT';
               else backend.released = 'LEFTSHIFT'
                shift = !shift
            }// UPWARDS ARROW (shift)
                else {
                 // insert text)
                    backend.userName = text.toUpperCase();
                if (shift && text != 'UP' && text != 'DOWN' && text != 'RIGHT' && text != 'LEFT' && !ctrl) {
                    shift = false // momentary
                    backend.released = 'LEFTSHIFT'
                }
                if (ctrl) {
                    ctrl = false // momentary
                    backend.released = 'LEFTCTRL'
                     shift = false;
                }
                if (alt) {
                    alt = false;
                    backend.released = 'LEFTALT'
                    shift = false;
                }
}
                if (alt && shift) ru = !ru;
            }
        }

}
}
