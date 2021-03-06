// This file is automatically generated, please don't edit manually.
import QtQuick 2.1
import Deepin.Widgets 1.0
import "../edit"

BaseEditSection { 
    id: sectionVpnOpenvpnSecurity
    virtualSection: "vs-vpn-openvpn-security"
    
    header.sourceComponent: EditDownArrowHeader{
        text: dsTr("VPN Security")
    }

    content.sourceComponent: Column { 
        EditLineComboBox {
            id: lineAliasVpnOpenvpnSecurityCipher
            connectionSession: sectionVpnOpenvpnSecurity.connectionSession
            availableSections: sectionVpnOpenvpnSecurity.availableSections
            availableKeys: sectionVpnOpenvpnSecurity.availableKeys
            connectionData: sectionVpnOpenvpnSecurity.connectionData
            errors: sectionVpnOpenvpnSecurity.errors
            section: "alias-vpn-openvpn-security"
            key: "cipher"
            text: dsTr("Cipher")
        }
        EditLineComboBox {
            id: lineAliasVpnOpenvpnSecurityAuth
            connectionSession: sectionVpnOpenvpnSecurity.connectionSession
            availableSections: sectionVpnOpenvpnSecurity.availableSections
            availableKeys: sectionVpnOpenvpnSecurity.availableKeys
            connectionData: sectionVpnOpenvpnSecurity.connectionData
            errors: sectionVpnOpenvpnSecurity.errors
            section: "alias-vpn-openvpn-security"
            key: "auth"
            text: dsTr("HMAC Auth")
        }
    }
}
