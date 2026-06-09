import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs
import org.kde.kirigami as Kirigami

Kirigami.ScrollablePage {
    id: appearancePage
    
    // properties
    property alias cfg_useSystemShadow: useSystemShadow.checked
    property alias cfg_showDayOutline: showDayOutline.checked
    property alias cfg_dayOutlineColor: dayOutlineColor.color
    property alias cfg_showDateOutline: showDateOutline.checked
    property alias cfg_dateOutlineColor: dateOutlineColor.color
    property alias cfg_showTimeOutline: showTimeOutline.checked
    property alias cfg_timeOutlineColor: timeOutlineColor.color
    property alias cfg_show_day: showDay.checked
    property alias cfg_use_local_day_name: useLocalDayName.checked
    property alias cfg_show_date: showDate.checked
    property alias cfg_use_local_date_name: useLocalDateName.checked
    property alias cfg_show_time: showTime.checked
    property alias cfg_day_font_size: dayFontSize.value
    property alias cfg_date_font_size: dateFontSize.value
    property alias cfg_time_font_size: timeFontSize.value
    property alias cfg_day_letter_spacing: dayLetterSpacing.value
    property alias cfg_day_font_color: dayFontColor.color
    property alias cfg_date_letter_spacing: dateLetterSpacing.value
    property alias cfg_time_letter_spacing: timeLetterSpacing.value
    property alias cfg_time_font_color: timeFontColor.color
    property alias cfg_use_24_hour_format: use24HourFormat.checked
    property alias cfg_time_format: timeFormatField.text
    property alias cfg_time_character: timeCharacter.text
    property alias cfg_date_format: dateFormat.text
    property alias cfg_date_font_color: dateFontColor.color
    
    // Font properties
    property string cfg_fontFamilyDay
    property string cfg_fontFamilyDate
    property string cfg_fontFamilyTime
    
    // Font list (loaded on demand)
    property var fontFamilies: []
    property bool fontsLoaded: false
    
    function loadFonts() {
        if (!fontsLoaded) {
            fontFamilies = Qt.fontFamilies()
            fontsLoaded = true
        }
    }

    Kirigami.FormLayout {
        Title {
            title: i18n("Global Style")
        }
        RowLayout {
            Label {
                text: i18n("Use Soft System Shadow")
            }
            CheckBox {
                id: useSystemShadow
            }
        }
        RowLayout {
            Label {
                text: ""
            }
            Label {
                text: i18n("Note: Turn this off if you are using text outlines, otherwise they look blurry.")
                font.pointSize: -1
                font.pixelSize: 10
                opacity: 0.8
            }
        }
        Title {
            title: i18n("Day")
        }
        RowLayout {
            Label {
                text: i18n("Show Day")
            }
            CheckBox {
                id: showDay
            }
        }
        RowLayout {
            Label {
                text: i18n("Use local name")
            }
            CheckBox {
                id: useLocalDayName
            }
        }
        RowLayout {
            Label {
                text: i18n("Font Family")
            }
            ComboBox {
                id: dayFontComboBox
                editable: true
                model: fontFamilies
                onActivated: function(index) {
                    if (index >= 0 && fontsLoaded) {
                        cfg_fontFamilyDay = fontFamilies[index]
                    }
                }
                onAccepted: {
                    cfg_fontFamilyDay = editText
                }
                Component.onCompleted: {
                    editText = cfg_fontFamilyDay || "Anurati"
                    popup.aboutToShow.connect(function() {
                        loadFonts()
                        if (fontsLoaded && cfg_fontFamilyDay) {
                            currentIndex = fontFamilies.indexOf(cfg_fontFamilyDay)
                        }
                    })
                }
            }
        }
        RowLayout {
            Label {
                text: ""
            }
            Label {
                text: i18n("Default: Anurati")
                font.pointSize: -1
                font.pixelSize: 10
                opacity: 0.8
            }
        }
        NumberField {
            id: dayFontSize
            label: i18n("Font Size")
        }
        NumberField {
            id: dayLetterSpacing
            label: i18n("Letter Spacing")
        }
        ColorDial {
            id: dayFontColor
            color: cfg_day_font_color
        }
        RowLayout {
            Label {
                text: i18n("Show Outline")
            }
            CheckBox {
                id: showDayOutline
            }
        }
        ColorDial {
            id: dayOutlineColor
            color: cfg_dayOutlineColor
        }

        Title {
            title: i18n("Date")
        }
        RowLayout {
            Label {
                text: i18n("Show Date")
            }
            CheckBox {
                id: showDate
            }
        }
        RowLayout {
            Label {
                text: i18n("Use local name")
            }
            CheckBox {
                id: useLocalDateName
            }
        }
        RowLayout {
            Label {
                text: i18n("Font Family")
            }
            ComboBox {
                id: dateFontComboBox
                editable: true
                model: fontFamilies
                onActivated: function(index) {
                    if (index >= 0 && fontsLoaded) {
                        cfg_fontFamilyDate = fontFamilies[index]
                    }
                }
                onAccepted: {
                    cfg_fontFamilyDate = editText
                }
                Component.onCompleted: {
                    editText = cfg_fontFamilyDate || "Poppins"
                    popup.aboutToShow.connect(function() {
                        loadFonts()
                        if (fontsLoaded && cfg_fontFamilyDate) {
                            currentIndex = fontFamilies.indexOf(cfg_fontFamilyDate)
                        }
                    })
                }
            }
        }
        RowLayout {
            Label {
                text: ""
            }
            Label {
                text: i18n("Default: Poppins")
                font.pointSize: -1
                font.pixelSize: 10
                opacity: 0.8
            }
        }
        NumberField {
            id: dateFontSize
            label: i18n("Font Size")
        }
        NumberField {
            id: dateLetterSpacing
            label: i18n("Letter Spacing")
        }
        RowLayout {
            Label {
                text: i18n("Date format")
            }
            TextField {
                id: dateFormat
            }
        }
        ColorDial {
            id: dateFontColor
            color: cfg_date_font_color
        }
        RowLayout {
            Label {
                text: i18n("Show Outline")
            }
            CheckBox {
                id: showDateOutline
            }
        }
        ColorDial {
            id: dateOutlineColor
            color: cfg_dateOutlineColor
        }

        Title {
            title: i18n("Time")
        }
        RowLayout {
            Label {
                text: i18n("Show Time")
            }
            CheckBox {
                id: showTime
            }
        }
        RowLayout {
            Label {
                text: i18n("Font Family")
            }
            ComboBox {
                id: timeFontComboBox
                editable: true
                model: fontFamilies
                onActivated: function(index) {
                    if (index >= 0 && fontsLoaded) {
                        cfg_fontFamilyTime = fontFamilies[index]
                    }
                }
                onAccepted: {
                    cfg_fontFamilyTime = editText
                }
                Component.onCompleted: {
                    editText = cfg_fontFamilyTime || "Poppins"
                    popup.aboutToShow.connect(function() {
                        loadFonts()
                        if (fontsLoaded && cfg_fontFamilyTime) {
                            currentIndex = fontFamilies.indexOf(cfg_fontFamilyTime)
                        }
                    })
                }
            }
        }
        RowLayout {
            Label {
                text: ""
            }
            Label {
                text: i18n("Default: Poppins")
                font.pointSize: -1
                font.pixelSize: 10
                opacity: 0.8
            }
        }
        NumberField {
            id: timeFontSize
            label: i18n("Font Size")
        }
        NumberField {
            id: timeLetterSpacing
            label: i18n("Letter Spacing")
        }
        RowLayout {
            id: timeFormatRow
            HoverHandler { id: timeFormatHover }
            ToolTip.visible: timeFormatHover.hovered
            ToolTip.text: i18n("Use Qt time formats like 'hh:mm:ss', 'h:mm:ss AP', or 'HH:mm:ss'. h/H = 12h/24h (double letters zero-pad), m = minutes, s = seconds. Using seconds refreshes every second. Leave empty to keep the default 12/24h setting.")
            Label {
                text: i18n("Time format")
            }
            TextField {
                id: timeFormatField
                placeholderText: "hh:mm:ss | h:mm:ss AP | HH:mm:ss"
            }
        }
        RowLayout {
            id: use24Row
            HoverHandler { id: use24Hover }
            ToolTip.visible: use24Hover.hovered
            ToolTip.text: i18n("If enabled, the time will be shown in 24-hour format regardless of system settings. This is only applied when the Time format field is empty; a custom time format always takes priority.")
            Label {
                text: i18n("Use 24 hour format")
            }
            CheckBox {
                id: use24HourFormat
            }
        }
        RowLayout {
            Label {
                text: i18n("Style Character")
            }
            TextField {
                id: timeCharacter
                maximumLength: 1
            }
        }
        ColorDial {
            id: timeFontColor
            color: cfg_time_font_color
        }
        RowLayout {
            Label {
                text: i18n("Show Outline")
            }
            CheckBox {
                id: showTimeOutline
            }
        }
        ColorDial {
            id: timeOutlineColor
            color: cfg_timeOutlineColor
        }
    }
}
