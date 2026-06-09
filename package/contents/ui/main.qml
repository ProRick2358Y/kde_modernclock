import QtQml
import QtQuick
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
    id: root
    
    // Dynamically switch between the system shadow and a clean background
    Plasmoid.backgroundHints: plasmoid.configuration.useSystemShadow ? (PlasmaCore.Types.ShadowBackground | PlasmaCore.Types.ConfigurableBackground) : PlasmaCore.Types.ConfigurableBackground
    
    // loading fonts
    FontLoader {
        id: font_anurati
        source: "../fonts/Anurati.otf"
    }
    FontLoader {
        id: font_poppins
        source: "../fonts/Poppins.ttf"
    }
    

    // setting preferred size
    preferredRepresentation: fullRepresentation
    fullRepresentation: Item {

        // Set a flexible layout that lets you resize the box on your desktop
        implicitWidth: 400
        implicitHeight: 200

        Layout.minimumWidth: 100
        Layout.minimumHeight: 50

        // Updating time every minute (or second if format includes seconds)
        Plasma5Support.DataSource {
            id: dataSource
            engine: "time"
            connectedSources: ["Local"]
            intervalAlignment: Plasma5Support.Types.AlignToMinute
            interval: 60000

            property bool use24HourFormat: plasmoid.configuration.use_24_hour_format
            property string timeCharacter: plasmoid.configuration.time_character
            property string dateFormat: plasmoid.configuration.date_format
            property string timeFormat: plasmoid.configuration.time_format
            property bool useLocalDayName: plasmoid.configuration.use_local_day_name
            property bool useLocalDateName: plasmoid.configuration.use_local_date_name
            property bool usesSeconds: false
            
            readonly property string default24HourFormat: "hh:mm"
            readonly property string default12HourFormat: "hh:mm AP"
            readonly property int secondInterval: 1000
            readonly property int minuteInterval: 60000
            
            function currentTimeFormat() {
                var customFormat = timeFormat ? timeFormat.trim() : ""
                return (customFormat && customFormat.length > 0) ? customFormat : (use24HourFormat ? default24HourFormat : default12HourFormat)
            }
            
            function updateIntervalForFormat(format) {
                // Qt time format uses 's' or 'ss' for seconds; adjust refresh cadence when seconds are present.
                var needsSeconds = /s{1,2}/.test(format)
                if (needsSeconds !== usesSeconds) {
                    usesSeconds = needsSeconds
                    interval = needsSeconds ? secondInterval : minuteInterval
                    intervalAlignment = needsSeconds ? Plasma5Support.Types.NoAlignment : Plasma5Support.Types.AlignToMinute
                }
            }
            
            function formatTimeSafely(date) {
                var format = currentTimeFormat()
                updateIntervalForFormat(format)
                var formatted = ""
                try {
                    formatted = Qt.formatTime(date, format)
                } catch (e) {
                    formatted = ""
                }
                if (formatted === "") {
                    format = use24HourFormat ? default24HourFormat : default12HourFormat
                    updateIntervalForFormat(format)
                    formatted = Qt.formatTime(date, format)
                }
                return formatted
            }

            onDataChanged: {
                var curDate = dataSource.data["Local"]["DateTime"]
                var formattedTime = formatTimeSafely(curDate)
                
                // Day name - localized or english
                if (useLocalDayName) {
                    display_day.text = curDate.toLocaleString(Qt.locale(), "dddd").toUpperCase()
                } else {
                    display_day.text = Qt.formatDate(curDate, "dddd").toUpperCase()
                }
                
                // Date - localized or english
                if (useLocalDateName) {
                    display_date.text = curDate.toLocaleString(Qt.locale(), dateFormat).toUpperCase()
                } else {
                    display_date.text = Qt.formatDate(curDate, dateFormat).toUpperCase()
                }
                
                display_time.text = timeCharacter + " " + formattedTime + " " + timeCharacter
            }
            
            onUse24HourFormatChanged: {
                updateIntervalForFormat(currentTimeFormat())
                dataChanged()
            }
            onTimeCharacterChanged: dataChanged()
            onDateFormatChanged: dataChanged()
            onUseLocalDayNameChanged: dataChanged()
            onUseLocalDateNameChanged: dataChanged()
            onTimeFormatChanged: {
                updateIntervalForFormat(currentTimeFormat())
                dataChanged()
            }
            
            Component.onCompleted: updateIntervalForFormat(currentTimeFormat())

            
        }

        // Main Content Container
        Item {
            id: container
            anchors.centerIn: parent
            width: parent.width
            height: parent.height

            // 1. The Day Name
            PlasmaComponents.Label {
                id: display_day
                visible: plasmoid.configuration.show_day
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                horizontalAlignment: Text.AlignHCenter

                // FIX: Explicitly limit the height of the label to cut off the font padding
                // This forces the "container" to end where the letters end
                height: implicitHeight * 0.75

                font.pixelSize: plasmoid.configuration.day_font_size
                font.letterSpacing: plasmoid.configuration.day_letter_spacing
                font.family: plasmoid.configuration.fontFamilyDay || font_anurati.name
                color: plasmoid.configuration.day_font_color
                style: plasmoid.configuration.showDayOutline ? Text.Outline : Text.Normal
                styleColor: plasmoid.configuration.showDayOutline ? plasmoid.configuration.dayOutlineColor : "transparent"

                fontSizeMode: Text.Fit
                minimumPixelSize: 12
            }

            // 2. The Date
            PlasmaComponents.Label {
                id: display_date
                visible: plasmoid.configuration.show_date

                // FIX: Anchor to the bottom of the (now smaller) Day label
                // And use a more aggressive margin to pull it up
                anchors.top: display_day.bottom
                anchors.topMargin: -10

                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                horizontalAlignment: Text.AlignHCenter

                font.pixelSize: plasmoid.configuration.date_font_size
                font.letterSpacing: plasmoid.configuration.date_letter_spacing
                font.family: plasmoid.configuration.fontFamilyDate || font_poppins.name
                color: plasmoid.configuration.date_font_color
                style: plasmoid.configuration.showDateOutline ? Text.Outline : Text.Normal
                styleColor: plasmoid.configuration.showDateOutline ? plasmoid.configuration.dateOutlineColor : "transparent"
            }

            // 3. The Time
            PlasmaComponents.Label {
                id: display_time
                visible: plasmoid.configuration.show_time
                // Anchor to the BOTTOM of the Date label
                anchors.top: display_date.bottom
                anchors.topMargin: 0
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                horizontalAlignment: Text.AlignHCenter

                font.pixelSize: plasmoid.configuration.time_font_size
                font.family: plasmoid.configuration.fontFamilyTime || font_poppins.name
                color: plasmoid.configuration.time_font_color
                font.letterSpacing: plasmoid.configuration.time_letter_spacing
                style: plasmoid.configuration.showTimeOutline ? Text.Outline : Text.Normal
                styleColor: plasmoid.configuration.showTimeOutline ? plasmoid.configuration.timeOutlineColor : "transparent"
            }
        }
    }
}
