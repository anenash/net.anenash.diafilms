/*
  Copyright (C) 2022
  Contact: Alexander Nenashev <anenash@gmail.com>
*/

import QtQuick 2.4
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0


Page {
    id: page

    orientation: Orientation.Landscape
    allowedOrientations: Orientation.Landscape

    property string diafilmId
    property string diafilmTitle: "Empty"

    XmlListModel {
        id:  listModel
        namespaceDeclarations: "declare namespace content=\"http://purl.org/rss/1.0/modules/content/\";" + "declare namespace dc=\"http://purl.org/dc/elements/1.1/\";"
        source: "http://www.diafilmy.su/dia.php?id=" + diafilmId
        query: "/data/imgs/img"
        XmlRole { name: "frame_source"; query: "string()" }
    }

    SilicaListView {
        id: listView

        model: listModel
        anchors.fill: parent
        snapMode: ListView.SnapOneItem
        delegate: Item {
            id: imgBackgroundItem
            width: page.width
            height: listView.height

            Image {
                id: imgItem

                anchors.centerIn: parent
                anchors.fill: parent

                fillMode: Image.PreserveAspectFit
                source: frame_source
                BusyIndicator {
                    id: busyIndicator
                    running: true
                    visible: true
                    size: BusyIndicatorSize.Large
                    anchors.centerIn: parent
                }
                onStatusChanged: {
                    if(status === Image.Ready) {
                        busyIndicator.running = false
                    }
                }
            }

        }
    }
}
