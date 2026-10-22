import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami

Kirigami.Dialog {
    id: root
    title: 'Settings'

    standardButtons: Kirigami.Dialog.Ok | Kirigami.Dialog.Cancel

    preferredWidth: Kirigami.Units.gridUnit * 20

    onAccepted: {
        SettingsManager.saveSearchEngine(searchEngineField.text);
    }

    ColumnLayout {
        spacing: Kirigami.Units.largeSpacing
        Layout.fillWidth: true

        Kirigami.FormLayout {
            Layout.fillWidth: true

            Controls.TextField {
                id: searchEngineField
                Kirigami.FormData.label: 'Search engine:'
                text: SettingsManager.searchEngine
            }
        }
    }
}
