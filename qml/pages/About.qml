import QtQuick 2.4
import Sailfish.Silica 1.0


Page {
    id: page
    orientation: Orientation.Portrait
    allowedOrientations: Orientation.Portrait
    anchors.margins: Theme.paddingLarge

    Column {
        id: column

        width: parent.width * 0.9
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: Theme.paddingLarge
        spacing: Theme.paddingLarge

        PageHeader {
            title: qsTr("About")
        }
        Label {
            id: aboutDiafilm
            width: parent.width
            color: Theme.highlightColor
            anchors.margins: Theme.paddingLarge
            horizontalAlignment: Text.AlignJustify
            wrapMode: Text.WordWrap
            text: qsTr("The filmstrip was a common form of still image instructional multimedia.\nFrom the 1940s to 1980s, filmstrips provided an easy and inexpensive alternative to 16mm projector educational films, requiring very little storage space and being very quick to rewind for the next use. Filmstrips were large and durable, and rarely needed splicing. They are still used in some areas.")
        }
        Label {
            id: firstParagraph
            width: parent.width
            color: Theme.highlightColor
            anchors.margins: Theme.paddingLarge
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            text: qsTr("All filmstrip can be found at the ") + "<a href=\"http://www.diafilmy.su\">diafilmy.su</a>"
            onLinkActivated: {
                Qt.openUrlExternally(link);
            }
        }
    }

}
