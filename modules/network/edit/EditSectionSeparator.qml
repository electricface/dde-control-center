import QtQuick 2.1
import Deepin.Widgets 1.0

DSeparatorHorizontal {
    property BaseEditSection relatedSection
    visible: relatedSection.visible
}
