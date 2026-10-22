// Includes relevant modules used by the QML
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami
import QtWebEngine

// Provides basic features needed for all kirigami applications
Kirigami.ApplicationWindow {
    // Unique identifier to reference this object
    id: root

    width: 600
    height: 600

    // Window title
    title: "Quiksearch"

    header: Controls.ToolBar {
        RowLayout {
            anchors.fill: parent
            spacing: Kirigami.Units.smallSpacing

            Controls.Button {
                icon.name: "go-previous"
                Controls.ToolTip.text: 'Go back'
                Controls.ToolTip.delay: Kirigami.Units.toolTipDelay
                Controls.ToolTip.visible: hovered
                onClicked: {
                    if (webEngineView.canGoBack)
                        webEngineView.goBack();
                }
            }

            Controls.Button {
                icon.name: "go-next"
                Controls.ToolTip.text: 'Go forward'
                Controls.ToolTip.delay: Kirigami.Units.toolTipDelay
                Controls.ToolTip.visible: hovered
                onClicked: {
                    if (webEngineView.canGoForward)
                        webEngineView.goForward();
                }
            }

            Controls.Button {
                icon.name: "reload"
                Controls.ToolTip.text: 'Reload page'
                Controls.ToolTip.delay: Kirigami.Units.toolTipDelay
                Controls.ToolTip.visible: hovered
                onClicked: {
                    webEngineView.reload();
                }
            }

            Kirigami.SearchField {
                id: searchField
                Layout.fillWidth: true
                autoAccept: false
                onAccepted: {
                    const input = text.trim();
                    if (input === '')
                        return;

                    if (input.startsWith('https://') || input.startsWith('https://')) {
                        webEngineView.url = input;
                    } else {
                        const query = encodeURIComponent(input);
                        const url = SettingsManager.searchEngine.replace('%s', query);
                        webEngineView.url = url;
                    }

                    webEngineView.forceActiveFocus();
                }
                onActiveFocusChanged: {
                    if (activeFocus) {
                        selectAll();
                    }
                }
            }

            Controls.Button {
                icon.name: "internet-web-browser"
                Controls.ToolTip.text: 'Open in defualt web browser'
                Controls.ToolTip.delay: Kirigami.Units.toolTipDelay
                Controls.ToolTip.visible: hovered
                onClicked: {
                    Qt.openUrlExternally(webEngineView.url);
                }
            }

            Controls.Button {
                icon.name: "settings"
                Controls.ToolTip.text: 'Settings'
                Controls.ToolTip.delay: Kirigami.Units.toolTipDelay
                Controls.ToolTip.visible: hovered
                onClicked: {
                    settingsDialog.open();
                }
            }
        }
    }

    // Set the first page that will be loaded when the app opens
    // This can also be set to an id of a Kirigami.Page
    pageStack.initialPage: Kirigami.Page {
        // Controls.Label {
        //     anchors.centerIn: parent
        //     text: 'Search anything...'
        // }

        WebEngineView {
            id: webEngineView
            anchors.fill: parent
            url: getSearchEngineBase()
            profile: WebEngineProfile {
                id: webEngineProfile
                storageName: 'QuiksearchStorage'
                offTheRecord: false
                persistentCookiesPolicy: WebEngineProfile.AllowPersistentCookies
            }
            onTitleChanged: {
                searchField.text = title;
            }

            function getSearchEngineBase(): string {
                try {
                    const url = SettingsManager.searchEngine;
                    const base = new URL(url).origin;
                    console.log('Base:', base);
                    return base;
                } catch (error) {
                    console.error(error);
                    return 'https://search.brave.com';
                }
            }
        }
    }

    SettingsDialog {
        id: settingsDialog
    }
}
