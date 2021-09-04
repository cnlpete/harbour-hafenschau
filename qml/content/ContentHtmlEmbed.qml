import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components/"

BackgroundItem {
    property ContentItem item

    visible: titleLabel.text.length > 0
    width: parent.width
    height: columnBox.height

    Column {
        id: columnBox
        x: Theme.horizontalPageMargin
        width: parent.width - 2*x
        spacing: Theme.paddingMedium

        Separator {
            width: parent.width
            color: Theme.highlightBackgroundColor
        }

        RemoteImage {
            placeholderUrl: "/usr/share/harbour-hafenschau/images/webcontent.png"
        }

        Label {
            width: parent.width

            font.pixelSize: Theme.fontSizeMedium
            wrapMode: Text.WordWrap
            color: Theme.highlightColor
        }

        Separator {
            width: parent.width
            color: Theme.highlightBackgroundColor
        }
    }

    onClicked: pageStack.push(Qt.resolvedUrl("../pages/WebViewPage.qml"), { url: item.value })
}
