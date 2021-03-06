// This file is automatically generated, please don't edit manually.
import QtQuick 2.1
import Deepin.Widgets 1.0
import "../edit"

BaseEditSection { 
    id: sectionGeneral
    virtualSection: "vs-general"
    
    header.sourceComponent: EditDownArrowHeader{
        text: dsTr("General")
    }

    content.sourceComponent: Column { 
        EditLineSwitchButton {
            id: lineConnectionAutoconnect
            connectionSession: sectionGeneral.connectionSession
            availableSections: sectionGeneral.availableSections
            availableKeys: sectionGeneral.availableKeys
            connectionData: sectionGeneral.connectionData
            errors: sectionGeneral.errors
            section: "connection"
            key: "autoconnect"
            text: dsTr("Automatically connect")
        }
        EditLineSwitchButton {
            id: lineConnectionVkNoPermission
            connectionSession: sectionGeneral.connectionSession
            availableSections: sectionGeneral.availableSections
            availableKeys: sectionGeneral.availableKeys
            connectionData: sectionGeneral.connectionData
            errors: sectionGeneral.errors
            section: "connection"
            key: "vk-no-permission"
            text: dsTr("For All Users")
        }
    }
}
