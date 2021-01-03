import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

Page {    
    id: page

    allowedOrientations: Orientation.All

    SilicaFlickable {
        PullDownMenu {
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("settings/SettingsPage.qml"))
            }
            MenuItem {
                text: qsTr("Refresh")
                onClicked: HafenschauProvider.refresh()
            }
            MenuItem {
                text: listView.showSearch ? qsTr("Hide search") : qsTr("Search")
                onClicked: {
                    listView.showSearch = !listView.showSearch

                    if (!listView.showSearch) {
                        searchField.focus = false
                        searchField.text = ""
                    }
                }
            }
        }

        anchors.fill: parent

        Column {
            id: header
            width: parent.width

            PageHeader {
                title: qsTr("Top News")
            }

            SearchField {
                id: searchField
                width: parent.width
                height: listView.showSearch ? implicitHeight : 0
                opacity: listView.showSearch ? 1 : 0
                onTextChanged: {
                    filterModel.setFilterFixedString(text)
                }

                EnterKey.onClicked: searchField.focus = false

                Connections {
                    target: listView
                    onShowSearchChanged: {
                        searchField.forceActiveFocus()
                    }
                }

                Behavior on height {
                    NumberAnimation { duration: 300 }
                }
                Behavior on opacity {
                    NumberAnimation { duration: 300 }
                }
            }
        }

        SilicaListView {
            property bool showSearch: false

            id: listView

            width: parent.width
            anchors.top: header.bottom
            anchors.bottom: parent.bottom

            clip: true

            model: NewsSortFilterModel {
                id: filterModel
                sourceModel: HafenschauProvider.newsModel()
            }

            delegate: ListItem {
                id: delegate

                contentHeight: contentRow.height + separatorBottom.height

                Row {
                    id: contentRow
                    x: Theme.horizontalPageMargin
                    width: parent.width - 2*x
                    spacing: Theme.paddingSmall

                    Image {
                        id: thumbnailImage

                        width: Theme.itemSizeExtraLarge
                        height: Theme.itemSizeExtraLarge * 1.4

                        fillMode: Image.PreserveAspectCrop

                        source: thumbnail.length > 0 ? thumbnail : "qrc:/images/dummy_image"
                        cache: true
                        smooth: true

                        BusyIndicator {
                            size: BusyIndicatorSize.Medium
                            anchors.centerIn: thumbnailImage
                            running: thumbnailImage.status != Image.Ready
                        }
                    }

                    Column {
                        id: column
                        width: parent.width - thumbnailImage.width - parent.spacing
                        spacing: Theme.paddingSmall

                        Label {
                            text: topline

                            width: parent.width
                            wrapMode: Text.WordWrap

                            font.pixelSize: Theme.fontSizeExtraSmall
                        }
                        Label {
                            text: title

                            width: parent.width
                            wrapMode: Text.WordWrap

                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.highlightColor
                        }
                        Label {
                            text: first_sentence
                            width: parent.width
                            wrapMode: Text.WordWrap

                            font.pixelSize: Theme.fontSizeExtraSmall
                        }
                    }
                }

                Separator {
                    id: separatorBottom
                    visible: index < listView.count
                    x: Theme.horizontalPageMargin
                    width: parent.width - 2*x
                    color: Theme.primaryColor
                }

                onClicked: {
                    if (news_type === News.WebView) {
                        //pageStack.push(Qt.resolvedUrl("../dialogs/OpenExternalUrlDialog.qml"), {url: HafenschauProvider.newsModel().newsAt(row).detailsWeb })
                        pageStack.push(Qt.resolvedUrl("WebViewPage.qml"), {url: HafenschauProvider.newsModel().newsAt(row).detailsWeb })
                    } else {
                        pageStack.push(Qt.resolvedUrl("ReaderPage.qml"), {news: HafenschauProvider.newsModel().newsAt(row)})
                    }
                }
            }
            VerticalScrollDecorator {}
        }
    }

    onStatusChanged: {
        if (status === PageStatus.Deactivating) {
            searchField.focus = false
            searchField.text = ""
            listView.showSearch = false
        }
    }
}
