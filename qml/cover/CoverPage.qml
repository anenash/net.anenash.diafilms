import QtQuick 2.4
import Sailfish.Silica 1.0

CoverBackground {
    CoverPlaceholder {
        id: frame
        anchors.centerIn: parent
        text: app.coverLabel
        icon.source: app.diafilmImage
        icon.height: 128 * Theme.pixelRatio
        icon.fillMode: Image.PreserveAspectFit
    }
}


