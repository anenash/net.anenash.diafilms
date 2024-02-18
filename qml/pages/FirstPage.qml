/*
  Copyright (C) 2022 - 2023
  Contact: Alexander Nenashev <anenash@gmail.com>
*/

import QtQuick 2.4
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0

import net.anenash.SearchProxy 1.0


Page {
    id: page

    property string searchFieldText: ""
    property string diafilmsCount: ""

    orientation: Orientation.Portrait
    allowedOrientations: Orientation.Portrait
/*
    onOrientationChanged: {
        if (orientation === Orientation.Portrait || orientation === Orientation.PortraitInverted ) {
            gameBoard.source = "TtrsPortrait.qml"
        } else if (orientation === Orientation.Landscape || orientation === Orientation.LandscapeInverted) {
            gameBoard.source = "TtrsLandscape.qml"
        }
    }
    */
    XmlListModel {
        id: diafilmsList

        source: "http://www.diafilmy.su/dia-list.php"
        query: "/data/post"
        XmlRole { name: "diafilmId"; query: "id/string()" }
        XmlRole { name: "category"; query: "string-join(cat, ',')" }
        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "url"; query: "url/string()" }
        XmlRole { name: "img"; query: "img/string()" }
        XmlRole { name: "year"; query: "year/string()" }
        onStatusChanged: {
            if(status === XmlListModel.Ready) {
                console.log(JSON.stringify(diafilmsList))
                if (diafilmsList.count === 0) diafilmsList.reload()
                diafilmsCount = diafilmsList.count
                filteredModel.sortData()
                busyIndicator.running = false
                headerItem.visible = true
                listView.visible = true
            } else if (status === XmlListModel.Error) {
                console.error("Error: XmlListModel", errorString())
                diafilmsList.reload()
            } else if (status === XmlListModel.Null) {
                console.error("Error: XmlListModel Null")
                diafilmsList.reload()
            }
        }
    }

    SearchProxyModel {
        id: filteredModel

        sourceModel: diafilmsList
        sortRoleName: 'category'
        searchRoles: [ 'category', 'title', 'year' ]
        searchPattern: searchFieldText
    }

    SilicaFlickable {

        anchors.fill: parent

        BusyIndicator {
            id: busyIndicator

            running: true
            size: BusyIndicatorSize.Large
            anchors.centerIn: parent
        }

        PullDownMenu {
            id: pullDownMenu

            enabled: headerItem.visible
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("About.qml"));
            }
        }
        Column {
            id: headerItem

            anchors {
                top: parent.top
            }

            visible: false
            width: page.width
            PageHeader {
                id:pageHeader

                title: qsTr("Filmstrips (%1)").arg(diafilmsCount)
            }

            SearchField {
                id: searchField

                width: parent.width
                placeholderText: qsTr("Filmstrip name...")
                onTextChanged: {
                    searchFieldText = text
                }

                EnterKey.enabled: searchField.text.length >= 1

                Connections {
                    target: listView

                    onCountChanged: {
                        diafilmsCount = listView.count
                        if (searchFieldText.length > 0) {
                            searchField.focus = true
                            searchField.forceActiveFocus()
                        }
                    }
                }
            }
        }

        SilicaListView {
            id: listView

            anchors {
                top: headerItem.bottom
                left: parent.left
                leftMargin: Theme.paddingMedium
                right: parent.right
                rightMargin: Theme.paddingMedium
                bottom: parent.bottom
            }

            visible: false
            clip: true
            spacing: Theme.paddingSmall
            model: filteredModel

            section {
                property: "category"
                criteria: ViewSection.FullString
                delegate: SectionHeader {
                    text: section
                }
            }
            delegate: BackgroundItem {
                id: delegate

                anchors.margins: Theme.paddingLarge
                contentHeight: Theme.itemSizeExtraLarge
                height: Theme.itemSizeExtraLarge

                _backgroundColor: Theme.rgba(Theme.primaryColor, Theme.opacityFaint)
                contentItem.radius: 20

                Item {
                    id: imageContainer

                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                    }
                    height: Theme.itemSizeLarge
                    width: height * 2
                    Image {
                        id: imgItem

                        anchors.centerIn: parent
                        sourceSize.height: Theme.itemSizeLarge
                        fillMode: Image.PreserveAspectFit
                        source: img
                        onWidthChanged: console.warn("width", width)
                        onStatusChanged: {
                            if (Image.Error === status) {
                                source = ""
                            }
                        }
                    }
                }
                Label {
                    id: diafilmTitle
                    text: title + " (" + year + ")"
                    anchors {
                        left: imageContainer.right
                        leftMargin: Theme.paddingSmall
                        right: parent.right
                        rightMargin: Theme.paddingMedium
                        verticalCenter: imageContainer.verticalCenter
                    }
                    color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                    wrapMode: Text.WordWrap
                    maximumLineCount: 3
                    font.pixelSize: Theme.fontSizeSmall
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        Qt.inputMethod.hide()
                    }

                    onClicked: {
                        app.coverLabel = title
                        app.diafilmImage = img
                        pageStack.push(Qt.resolvedUrl("SecondPage.qml"), {diafilmId: diafilmId, diafilmTitle: title})
                    }
                }
            }
            VerticalScrollDecorator {}
        }
    }
}
