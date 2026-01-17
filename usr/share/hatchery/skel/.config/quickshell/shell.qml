import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ShellRoot {
    id: root

    // Colors
    property color colorFg: "#a7a7a7"
    property color colorBg: "#202020"
    property color color0: "#2d2d2d"
    property color color8: "#605f61"
    property color color1: "#9d5b61"
    property color color9: "#9d5b61"
    property color color2: "#838d69"
    property color color10: "#838b69"
    property color color3: "#b38d6a"
    property color color11: "#b38d6a"
    property color color4: "#606d84"
    property color color12: "#606d84"
    property color color5: "#766577"
    property color color13: "#766577"
    property color color6: "#808fa0"
    property color color14: "#808fa0"
    property color color7: "#9c9a9a"
    property color color15: "#9c9a9a"

    // Fonts
    property string fontFamily: "Inter"
    property int fontSize: 20

    // Icons
    property list<string> icons: ["", "", "", "", "ﱘ", "", "", "", "", "睊", "直", "", "墳", "鈴", "凌", "﫼", "", "襤", "", ""]

    // Commands
    property list<string> launcherCmd: ["rofi", "-show", "drun"]
    property list<string> wifiCmd: ["xfce4-terminal", "-e", "nmtui"]
    property list<string> volumeCmd: ["pavucontrol"]
    property list<string> suspendCmd: ["sh", "-c", `systemctl suspend && swaylock -f -c 000000`]
    property list<string> rebootCmd: ["systemctl", "reboot"]
    property list<string> logoutCmd: ["hyprctl", "dispatch", "exit"]
    property list<string> lockCmd: ["swaylock", "-f", "-c", "000000"]
    property list<string> poweroffCmd: ["systemctl", "poweroff"]
    property list<string> installCmd: ["sudo", "-EH", "calamares"]

    // Workstation type (set to true or false if it's a laptop)
    property bool laptop: false

    // Max Brightness setting (get from brightnessctl in terminal)
    property int maxBrightness: 255

    // Wonky settings (conky replacement)
    property string wonkyFontFamily: "hack"
    property int wonkyFontSize: 16
    property color wonkyColor: "#808080"


    // Bind the pipewire node so its volume will be tracked
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    // Desktop widgets
    PanelWindow {
        id: background
        visible: true
        WlrLayershell.layer: WlrLayer.Background

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        // Desktop background color
        Rectangle {
            visible: true
            width: parent.width
            height: parent.height
            color: colorBg
        }

        // Logo
        Image {
            id: logo
            visible: true
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: -bar.width / 2
            source: "/usr/share/backgrounds/hatchery/hatchery.svg"
            width: 350
            height: 65
        }

        //Wonky (conky replacement)
        Rectangle {
            id: wonky
            visible: true
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 60
            anchors.rightMargin: 20
            width: childrenRect.width
            height: childrenRect.height
            color: colorBg
            Column {
                Row {
                    Text {
                        font {
                            family: wonkyFontFamily
                            pixelSize: wonkyFontSize
                        }
                        color: wonkyColor
                        text: "BASIC NAVIGATION"
                    }
                }
                Row {
                    Text {
                        font {
                            family: wonkyFontFamily
                            pixelSize: wonkyFontSize
                        }
                        color: wonkyColor
                        text: " "
                    }
                }
                Row {
                    Text {
                        font {
                            family: wonkyFontFamily
                            pixelSize: wonkyFontSize
                        }
                        color: wonkyColor
                        text: "ALT+P            run command"
                    }
                }
                Row {
                    Text {
                        font {
                            family: wonkyFontFamily
                            pixelSize: wonkyFontSize
                        }
                        color: wonkyColor
                        text: "ALT+SHIFT+ENTER  open terminal"
                    }
                }
                Row {
                    Text {
                        font {
                            family: wonkyFontFamily
                            pixelSize: wonkyFontSize
                        }
                        color: wonkyColor
                        text: "ALT+Q            close window"
                    }
                }
                Row {
                    Text {
                        font {
                            family: wonkyFontFamily
                            pixelSize: wonkyFontSize
                        }
                        color: wonkyColor
                        text: "ALT+1-6          switch between workspaces"
                    }
                }
                Row {
                    Text {
                        font {
                            family: wonkyFontFamily
                            pixelSize: wonkyFontSize
                        }
                        color: wonkyColor
                        text: "ALT+SHIFT+1-6    move window to workspace"
                    }
                }
                Row {
                    Text {
                        font {
                            family: wonkyFontFamily
                            pixelSize: wonkyFontSize
                        }
                        color: wonkyColor
                        text: "ALT+F12          show/hide this dialog"
                    }
                }
                Row {
                    Text {
                        font {
                            family: wonkyFontFamily
                            pixelSize: wonkyFontSize
                        }
                        color: wonkyColor
                        text: "ALT+SHIFT+Q      logout"
                    }
                }
            }
        }

        IpcHandler {
            target: "wonky"

            function toggleWonky(): bool {
                wonky.visible = wonky.visible ? false : true;
            }
        }
    }

    // Vertical Bar
    PanelWindow {
        id: bar

        anchors.top: true
        anchors.bottom: true
        anchors.left: true
        implicitWidth: 48
        color: colorBg

        // Launcher
        Text {
            id: launcher
            text: icons[6]
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 10
            color: color6
            font {
                family: fontFamily
                pixelSize: fontSize
            }
            MouseArea {
                anchors.fill: parent
                onClicked: Quickshell.execDetached(launcherCmd)
            }
        }

        // Workspaces
        Rectangle {
            radius: 5
            Layout.fillWidth: true
            height: childrenRect.height
            color: color0
            anchors.top: launcher.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 4
            anchors.topMargin: 10
            Column {
                padding: 5
                spacing: 5
                anchors.horizontalCenter: parent.horizontalCenter
                Repeater {
                    model: 6
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
                        property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                        text: icons[index]
                        color: isActive ? colorFg : (ws ? colorFg : color8)
                        font {
                            family: fontFamily
                            pixelSize: fontSize
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: Hyprland.dispatch("workspace " + (index + 1))
                        }
                    }
                }
            }
        }

        // Tray
        Rectangle {
            id: tray
            radius: 5
            Layout.fillWidth: true
            height: childrenRect.height
            color: color0
            anchors.bottom: clock.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 4
            anchors.bottomMargin: 10
            Column {
                padding: 5
                spacing: 5
                anchors.horizontalCenter: parent.horizontalCenter

                // Battery
                Column {
                    width: tray.width
                    spacing: 5
                    anchors.horizontalCenter: parent.horizontalCenter
                    HoverHandler {
                        id: batteryHoverHandler
                    }

                    Text {
                        id: battery
                        text: laptop ? (checkBattery.stdout.text.trim() <= 30 ? icons[7] : icons[8]) : icons[8]
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: laptop ? (checkBattery.stdout.text.trim() <= 30 ? color1 : color4) : color4
                        font {
                            family: fontFamily
                            pixelSize: fontSize
                        }
                        Process {
                            id: checkBattery
                            running: laptop ? true : false
                            command: ["sh", "-c", `cat /sys/class/power_supply/BAT0/capacity`]
                            stdout: StdioCollector {
                                onStreamFinished: batteryTooltipText.text = "Battery: " + text.trim() + "%"
                            }
                        }
                        Timer {
                            interval: 1000
                            running: laptop ? true : false
                            repeat: laptop ? true : false
                            onTriggered: laptop ? checkBattery.running = true : checkBattery.running = false
                        }
                    }
                }

                // Wifi
                Column {
                    width: tray.width
                    spacing: 5
                    anchors.horizontalCenter: parent.horizontalCenter
                    HoverHandler {
                        id: wifiHoverHandler
                    }
                    Text {
                        id: wifi
                        text: checkWifi.stdout.text.trim() === "up" ? icons[10] : icons[9]
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: color5
                        font {
                            family: fontFamily
                            pixelSize: fontSize
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: Quickshell.execDetached(wifiCmd)
                        }
                        Process {
                            id: checkWifi
                            running: true
                            command: ["sh", "-c", `cat /sys/class/net/w*/operstate`]
                            stdout: StdioCollector {}
                        }
                        Timer {
                            interval: 1000
                            running: true
                            repeat: true
                            onTriggered: checkWifi.running = true
                        }
                    }
                }

                // Brightness
                Column {
                    spacing: 5
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: tray.width

                    HoverHandler {
                        id: brightnessHoverHandler
                    }

                    Slider {
                        id: brightnessSlider
                        visible: laptop ? (brightnessHoverHandler.hovered ? true : false) : false
                        value: checkBrightness.text / maxBrightness
                        orientation: Qt.Vertical
                        anchors.horizontalCenter: parent.horizontalCenter

                        background: Rectangle {
                            implicitHeight: 80
                            implicitWidth: 10
                            height: parent.availableHeight
                            width: implicitWidth
                            anchors.horizontalCenter: parent.horizontalCenter
                            radius: 5
                            color: colorBg

                            Rectangle {
                                height: parent.height * brightnessSlider.value
                                width: parent.width
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.bottom: parent.bottom
                                color: color3
                                radius: 5
                            }
                        }

                        handle {
                            visible: false
                        }
                        onMoved: {
                            Quickshell.execDetached(["brightnessctl", "s", Math.floor(brightnessSlider.value * 100) + "%"]);
                        }
                    }

                    Process {
                        id: checkBrightness
                        running: laptop ? (brightnessHoverHandler.hovered ? true : true) : false
                        command: ["brightnessctl", "g"]
                        stdout: StdioCollector {
                            onStreamFinished: brightnessSlider.value = text / maxBrightness
                        }
                    }

                    Text {
                        id: brightness
                        text: icons[11]
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: color3
                        font {
                            family: fontFamily
                            pixelSize: fontSize
                        }
                    }
                }

                // Volume
                Column {
                    width: tray.width
                    spacing: 5
                    anchors.horizontalCenter: parent.horizontalCenter

                    HoverHandler {
                        id: volumeHoverHandler
                    }

                    Slider {
                        id: volumeSlider
                        visible: volumeHoverHandler.hovered ? true : false
                        value: Pipewire.defaultAudioSink?.audio.volume ?? 0
                        orientation: Qt.Vertical
                        anchors.horizontalCenter: parent.horizontalCenter

                        background: Rectangle {
                            implicitHeight: 80
                            implicitWidth: 10
                            height: parent.availableHeight
                            width: implicitWidth
                            anchors.horizontalCenter: parent.horizontalCenter
                            radius: 5
                            color: colorBg

                            Rectangle {
                                height: parent.height * (Pipewire.defaultAudioSink?.audio.volume ?? 0)
                                width: parent.width
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.bottom: parent.bottom
                                color: color2
                                radius: 5
                            }
                        }

                        handle {
                            visible: false
                        }
                        onMoved: {
                            Pipewire.defaultAudioSink.audio.volume = volumeSlider.value;
                        }
                    }

                    Text {
                        id: volume
                        text: icons[12]
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: color2
                        font {
                            family: fontFamily
                            pixelSize: fontSize
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: Quickshell.execDetached(volumeCmd)
                        }
                    }
                }
            }
        }

        // Clock
        Rectangle {
            id: clock
            radius: 5
            Layout.fillWidth: true
            height: childrenRect.height
            color: color0
            anchors.bottom: powermenu.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 4
            anchors.bottomMargin: 5
            Column {
                padding: 5
                spacing: 0
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    id: hour
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: colorFg
                    font {
                        family: fontFamily
                        pixelSize: fontSize
                    }
                    text: Qt.formatDateTime(new Date(), "HH")
                    Timer {
                        interval: 1000
                        running: true
                        repeat: true
                        onTriggered: hour.text = Qt.formatDateTime(new Date(), "HH")
                    }
                }

                Text {
                    id: minute
                    color: colorFg
                    font {
                        family: fontFamily
                        pixelSize: fontSize
                    }
                    text: Qt.formatDateTime(new Date(), "mm")
                    Timer {
                        interval: 1000
                        running: true
                        repeat: true
                        onTriggered: minute.text = Qt.formatDateTime(new Date(), "mm")
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    calendar.visible ? calendar.visible = false : calendar.visible = true;
                    grid.month = Qt.formatDateTime(new Date(), "M") - 1;
                    grid.year = Qt.formatDateTime(new Date(), "yyyy");
                    grid.year++;
                    grid.year--;
                }
            }
        }

        // Power Menu
        Column {
            id: powermenu
            padding: 5
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
            width: parent.width
            HoverHandler {
                id: powerHoverHandler
            }

            Text {
                id: suspend
                visible: powerHoverHandler.hovered ? true : false
                text: icons[13]
                anchors.horizontalCenter: parent.horizontalCenter
                color: color2
                font {
                    family: fontFamily
                    pixelSize: fontSize
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        popupWindowText.text = "Suspend this computer?";
                        popupWindowConfirm.text = "SUSPEND";
                        popupWindowCancel.text = "CANCEL";
                        popupWindowConfirm.color = color2;
                        installCmd = suspendCmd;
                        popupWindow.visible ? popupWindow.visible = false : popupWindow.visible = true;
                    }
                }
            }

            Text {
                id: reboot
                visible: powerHoverHandler.hovered ? true : false
                text: icons[14]
                anchors.horizontalCenter: parent.horizontalCenter
                color: color3
                font {
                    family: fontFamily
                    pixelSize: fontSize
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        popupWindowText.text = "Reboot this computer?";
                        popupWindowConfirm.text = "REBOOT";
                        popupWindowCancel.text = "CANCEL";
                        popupWindowConfirm.color = color3;
                        installCmd = rebootCmd;
                        popupWindow.visible ? popupWindow.visible = false : popupWindow.visible = true;
                    }
                }
            }

            Text {
                id: logout
                visible: powerHoverHandler.hovered ? true : false
                text: icons[15]
                anchors.horizontalCenter: parent.horizontalCenter
                color: color5
                font {
                    family: fontFamily
                    pixelSize: fontSize
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        popupWindowText.text = "Logout of this computer?";
                        popupWindowConfirm.text = "LOGOUT";
                        popupWindowCancel.text = "CANCEL";
                        popupWindowConfirm.color = color5;
                        installCmd = logoutCmd;
                        popupWindow.visible ? popupWindow.visible = false : popupWindow.visible = true;
                    }
                }
            }

            Text {
                id: lock
                visible: powerHoverHandler.hovered ? true : false
                text: icons[16]
                anchors.horizontalCenter: parent.horizontalCenter
                color: color4
                font {
                    family: fontFamily
                    pixelSize: fontSize
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: Quickshell.execDetached(lockCmd)
                }
            }

            Text {
                id: poweroff
                text: icons[17]
                anchors.horizontalCenter: parent.horizontalCenter
                color: color1
                font {
                    family: fontFamily
                    pixelSize: fontSize
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        popupWindowText.text = "Poweroff this computer?";
                        popupWindowConfirm.text = "POWEROFF";
                        popupWindowCancel.text = "CANCEL";
                        popupWindowConfirm.color = color1;
                        installCmd = poweroffCmd;
                        popupWindow.visible ? popupWindow.visible = false : popupWindow.visible = true;
                    }
                }
            }
        }

        // Battery tooltip
        PopupWindow {
            anchor.window: bar
            anchor.rect.x: bar.width + 5
            anchor.rect.y: tray.y + battery.parent.y
            implicitWidth: batteryTooltip.width
            implicitHeight: batteryTooltip.height
            visible: laptop ? (batteryHoverHandler.hovered ? true : false) : false
            color: colorBg
            Rectangle {
                id: batteryTooltip
                color: color0
                width: childrenRect.width
                height: childrenRect.height
                Text {
                    id: batteryTooltipText
                    font {
                        family: fontFamily
                        pixelSize: fontSize
                    }
                    color: colorFg
                    text: "Battery:"
                }
            }
        }

        // Wifi tooltip
        PopupWindow {
            anchor.window: bar
            anchor.rect.x: bar.width + 5
            anchor.rect.y: tray.y + wifi.parent.y
            implicitWidth: wifiTooltip.width
            implicitHeight: wifiTooltip.height
            visible: checkWifi.stdout.text.trim() === "up" ? (wifiHoverHandler.hovered ? true : false) : false
            color: colorBg
            Rectangle {
                id: wifiTooltip
                color: color0
                width: childrenRect.width
                height: childrenRect.height
                Text {
                    id: wifiTooltipText
                    font {
                        family: fontFamily
                        pixelSize: fontSize
                    }
                    color: colorFg
                    text: "Network:"
                }
            }
            Process {
                id: getSSID
                running: true
                command: ["sh", "-c", `nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2`]
                stdout: StdioCollector {
                    onStreamFinished: wifiTooltipText.text = "Network: " + text
                }
            }
            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: getSSID.running = true
            }
        }

        // Calendar
        PopupWindow {
            id: calendar
            anchor.window: bar
            anchor.rect.x: parentWindow.width + 20
            anchor.rect.y: parentWindow.height - height - 20
            implicitWidth: 400
            implicitHeight: 325
            visible: false
            color: colorBg

            property list<string> months: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

            Text {
                id: lastMonth
                anchors.right: month.left
                anchors.verticalCenter: month.verticalCenter
                anchors.rightMargin: 5
                color: color6
                font {
                    family: fontFamily
                    pixelSize: 12
                    bold: true
                }
                text: icons[18]
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        grid.month === 0 ? grid.year-- : grid.year;
                        grid.month === 0 ? grid.month = 11 : grid.month--;
                    }
                }
            }

            Text {
                id: month
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: 30
                anchors.leftMargin: 40
                color: color1
                font {
                    family: fontFamily
                    pixelSize: fontSize
                }
                text: calendar.months[grid.month]
            }

            Text {
                id: nextMonth
                anchors.left: month.right
                anchors.verticalCenter: month.verticalCenter
                anchors.leftMargin: 5
                color: color6
                font {
                    family: fontFamily
                    pixelSize: 12
                    bold: true
                }
                text: icons[19]
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        grid.month === 11 ? grid.year++ : grid.year;
                        grid.month === 11 ? grid.month = 0 : grid.month++;
                    }
                }
            }

            Text {
                id: lastYear
                anchors.right: year.left
                anchors.verticalCenter: year.verticalCenter
                anchors.rightMargin: 5
                color: color6
                font {
                    family: fontFamily
                    pixelSize: 12
                    bold: true
                }
                text: icons[18]
                MouseArea {
                    anchors.fill: parent
                    onClicked: grid.year--
                }
            }

            Text {
                id: year
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin: 30
                anchors.rightMargin: 40
                color: color1
                font {
                    family: fontFamily
                    pixelSize: fontSize
                }
                text: grid.year
            }

            Text {
                id: nextYear
                anchors.left: year.right
                anchors.verticalCenter: year.verticalCenter
                anchors.leftMargin: 5
                color: color6
                font {
                    family: fontFamily
                    pixelSize: 12
                    bold: true
                }
                text: icons[19]
                MouseArea {
                    anchors.fill: parent
                    onClicked: grid.year++
                }
            }

            DayOfWeekRow {
                id: day
                anchors.top: year.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: 15
                locale: grid.locale
                Layout.fillWidth: true
                leftPadding: 25
                rightPadding: 25
                delegate: Text {
                    text: shortName
                    font {
                        family: fontFamily
                        pixelSize: fontSize
                    }
                    color: color6
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    required property string shortName
                }
            }

            MonthGrid {
                id: grid
                anchors.top: day.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                locale: Qt.locale("en_US")
                Layout.fillWidth: true
                leftPadding: 25
                rightPadding: 25
                delegate: Text {
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: model.day
                    font {
                        family: fontFamily
                        pixelSize: fontSize
                    }
                    color: model.today ? color1 : (model.month === grid.month ? colorFg : color8)
                    required property var model
                }
            }
        }

        // Popup Window
        PopupWindow {
            id: popupWindow
            anchor.window: bar
            anchor.rect.x: screen.width / 2 - (width / 2)
            anchor.rect.y: screen.height / 2 - (height / 2)
            implicitWidth: 480
            implicitHeight: 120
            visible: false
            color: colorBg

            Text {
                id: popupWindowText
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 25
                color: colorFg
                font {
                    family: fontFamily
                    pixelSize: fontSize
                }
                text: "Install now or explore the live-session?"
            }

            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.bottomMargin: 15
                anchors.leftMargin: 35
                width: 190
                height: 35
                radius: 5
                color: color0

                Text {
                    id: popupWindowCancel
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: colorFg
                    font {
                        family: fontFamily
                        pixelSize: fontSize
                    }
                    text: "LIVE"
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: popupWindow.visible = false
                }
            }

            Rectangle {
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.bottomMargin: 15
                anchors.rightMargin: 35
                width: 190
                height: 35
                radius: 5
                color: color0

                Text {
                    id: popupWindowConfirm
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: colorFg
                    font {
                        family: fontFamily
                        pixelSize: fontSize
                    }
                    text: "INSTALL"
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        popupWindow.visible = false;
                        Quickshell.execDetached(installCmd);
                    }
                }
            }
        }
    }
}
