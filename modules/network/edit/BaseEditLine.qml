import QtQuick 2.1
import Deepin.Widgets 1.0

DBaseLine {
    id: editLine
    objectName: "BaseEditLine"
    
    property var connectionSession
    property var availableSections
    property var availableKeys
    property var connectionData
    property var errors
    property string section
    property string key
    property string text
    property var cacheValue // cache value between ConnectionSession and widget
    
    // if true, don't compare cache value with backend when setting key
    property bool setKeyAlways: false 
    
    signal widgetShown
    visible: false
    Binding on visible {
        value: isKeyAvailable()
    }
    onVisibleChanged: {
        if (visible) {
            if (cacheValue === undefined) {
                // get cacheValue when it is undefined
                updateCacheValue()
            } else if (alwaysUpdate) {
                // get cacheValue if property "alwaysUpdate" is true
                updateCacheValue()
            } else {
                // reset key if cacheValue already defined
                setKey(cacheValue)
            }
            widgetShown()
        }
        print("-> BaseEditLine.onVisibleChanged", visible ? "(show)" : "(hide)", section, key, cacheValue) // TODO test
    }
    Component.onCompleted: {
        if (visible) {
            // send widgetShown() signal is need here
            widgetShown()
        }
    }
    
    // colors
    color: dconstants.contentBgColor
    property color normalColor: dconstants.fgColor
    property color normalBorderColor: dconstants.contentBgColor
    property color errorColor: "#F48914"
    
    // update cacheValue even if other key changed
    property bool alwaysUpdate: false
    Connections {
        target: connectionSession
        onConnectionDataChanged: {
            if (visible && alwaysUpdate) {
                updateCacheValue()
            }
        }
    }
    
    // error state
    property bool showErrorConditon: false // will be true when widget focus changed or save button pressed
    property bool showError: showErrorConditon && isValueError()
    Connections {
        target: rightLoader.item
        onActiveFocusChanged: {
            print("-> onActiveFocusChanged", section, key, rightLoader.item.activeFocus) // TODO test
            if (!rightLoader.item.activeFocus) {
                showErrorConditon = true
            }
        }
    }
    onShowErrorChanged: {
        if (showError) {
            for (var p = parent;; p = p.parent) {
                if (p) {
                    if (p.objectName == "BaseEditSection") {
                        p.expandSection()
                        break
                    }
                } else {
                    break
                }
            }
        }
    }
    
    rightLoader.focus: true     // TODO fix active focus issue
    leftMargin: contentLeftMargin
    leftLoader.sourceComponent: DssH2{
        text: editLine.text
    }
    
    function setKey(v) {
        cacheValue = v
        if (cacheValue === getKey() && !setKeyAlways) {
            return
        }
        print("-> BaseEditLine.setKey()", section, key, cacheValue) // TODO test
        connectionSession.SetKey(section, key, marshalJSON(cacheValue))
    }

    function getKey() {
        return unmarshalJSON(connectionSession.GetKey(section, key))
    }
    
    function updateCacheValue() {
        cacheValue = getKey()
        // print("-> updateCacheValue()", section, key, cacheValue) // TODO test
    }
    
    function isKeyAvailable() {
        return getIndexFromArray(section, availableSections) != -1 && getIndexFromArray(key, availableKeys[section]) != -1
    }
    
    function isValueError() {
        if (!errors) {
            return false
        }
        if (errors[section] && errors[section][key]) {
            return true
        }
        return false
    }
    
    function getAvailableValues() {
        var valuesJSON = connectionSession.GetAvailableValues(section, key);
        var values = unmarshalJSON(valuesJSON)
        return values
    }
    
    function getAvailableValuesValue() {
        var values = getAvailableValues()
        var valuesValue = []
        for (var i=0; i<values.length; i++) {
            valuesValue.push(values[i].Value)
        }
        return valuesValue
    }
    
    function getAvailableValuesText() {
        var values = getAvailableValues()
        var valuesText = []
        for (var i=0; i<values.length; i++) {
            valuesText.push(values[i].Text)
        }
        return valuesText
    }
    
    function getAvailableValuesTextByValue() {
        var values = getAvailableValues()
        if (values == null) {
            // values is null here so this function should not be
            // called in this case
            print("-> [WARNING] getAvailableValuesTextByValue: values is null,", values, section, key, cacheValue) //TODO test
            return ""
        }
        for (var i=0; i<values.length; i++) {
            if (values[i].Value === cacheValue) {
                return values[i].Text
            }
        }
        print("-> [WARNING] getAvailableValuesTextByValue:", values, section, key, cacheValue) //TODO test
        return ""
    }
    
    function getAvailableValuesIndex() {
        var values = getAvailableValues()
        if (values == null) {
            return -1
        }
        for (var i=0; i<values.length; i++) {
            if (values[i].Value === cacheValue) {
                return i
            }
        }
        return -1
    }
    
    function checkKey() {
        print("-> check key", section, key, cacheValue) // TODO test
        showErrorConditon = true
    }
}
