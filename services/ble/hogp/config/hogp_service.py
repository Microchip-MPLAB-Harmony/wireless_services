import string
import sys
import struct
# from numberconv import addnumber
##############Global variables##################################


######################end glonal settings####################
def hogpConfigBLEStack(value):
    bleStack = Database.getComponentByID("BLE_STACK_LIB")
    if (bleStack != None):
        if value == True:
            print("True Value")
            byte_data = b'\x00\x00\x00\x00\x00\x00\x03\xC1'
            appearance_long_int = struct.unpack('>Q', byte_data)[0]
            Database.setSymbolValue("BLE_STACK_LIB", "BLE_SYS_SLEEP_MODE_EN", True)
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_DEV_NAME", "Microchip Keyboard")
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_SVC_APPEARANCE",appearance_long_int)
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_SVC_PERI_PRE_CP",True)
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADV_DATA_LOCAL_NAME","Microchip Keyboard")
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADV_DATA_UDD_EN",True)
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADV_DATA_UDD","0319C10303031218")
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_SCAN_RSP_DATA_LOCAL_NAME_EN",False)
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_SCAN_RSP_DATA_UDD_EN",True)
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_SCAN_RSP_DATA_UDD","020A09")
            if(Database.getComponentByID("SERVICE_BAS") != None):
                Database.setSymbolValue("SERVICE_BAS", "BAS_NOTIFY_ENABLE", True)
            if (Database.getComponentByID("SERVICE_HIDS") != None):
                Database.setSymbolValue("SERVICE_HIDS", "HIDS_DEVICE_TYPE", 1)
        else:
            print("False Value")
            byte_data = b'\x00\x00\x00\x00\x00\x00\x00\x00'
            appearance_long_int = struct.unpack('>Q', byte_data)[0]
            Database.setSymbolValue("BLE_STACK_LIB", "BLE_SYS_SLEEP_MODE_EN", False)
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_DEV_NAME", "Microchip")
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_SVC_APPEARANCE",appearance_long_int)
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_SVC_PERI_PRE_CP",False)
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADV_DATA_LOCAL_NAME","pic32cx-bz")
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADV_DATA_UDD_EN",False)
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADV_DATA_UDD","00")
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_SCAN_RSP_DATA_LOCAL_NAME_EN",True)
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_SCAN_RSP_DATA_UDD_EN",False)
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_SCAN_RSP_DATA_UDD","00")
            if(Database.getComponentByID("SERVICE_BAS") != None):
                Database.setSymbolValue("SERVICE_BAS", "BAS_NOTIFY_ENABLE", False)
            if (Database.getComponentByID("SERVICE_HIDS") != None):
                Database.setSymbolValue("SERVICE_HIDS", "HIDS_DEVICE_TYPE", 0)

def hogpServerConfig(symbol, event):
    value = event["value"]
    
    hogpProfile = Database.getComponentByID("PROFILE_HOGP")
    if (hogpProfile != None):
        hogpServer = hogpProfile.getSymbolByID('HOGP_BOOL_SERVER')
        hogpServer.setValue(event["value"])
    
    if value == True:
        hogpsCbHeaderFile.setEnabled(True)
        hogpsCbSourceFile.setEnabled(True)
        hogpsHandlerHeaderFile.setEnabled(True)
        hogpsHandlerSourceFile.setEnabled(True)
    else:
        hogpsCbHeaderFile.setEnabled(False)
        hogpsCbSourceFile.setEnabled(False)
        hogpsHandlerHeaderFile.setEnabled(False)
        hogpsHandlerSourceFile.setEnabled(False)
    
    hogpConfigBLEStack(value)



def loadconfigmodule(globalsettings):
    # hogp config
    hogp_configsetting = globalsettings.createMenuSymbol('HOGPS_MENU_CONFIGSET', None)
    hogp_configsetting.setLabel('Service configuration')
    hogp_configsetting.setVisible(True)
    hogp_configsetting.setDescription("HOGP Service configuration")

    hogpAppCode = globalsettings.createBooleanSymbol('booleanappcode', None)
    hogpAppCode.setLabel('Enable App Code Generation')
    hogpAppCode.setDescription('Enable App Code Generation for generating sample code')
    hogpAppCode.setDefaultValue(True)
    hogpAppCode.setVisible(True)
     
    #################################################################
    ##################      Server Role Settings      ###############
    #################################################################
    global hogpBoolServer
    
    hogpBoolServer = globalsettings.createBooleanSymbol('HOGP_BOOL_SERVER', hogp_configsetting)
    hogpBoolServer.setLabel('Enable Server Role')
    hogpBoolServer.setDefaultValue(False)
    hogpBoolServer.setDependencies(hogpServerConfig, ["HOGP_BOOL_SERVER"])
    
    global hogpsCbHeaderFile
    hogpsCbHeaderFile = globalsettings.createFileSymbol(None, None)
    hogpsCbHeaderFile.setSourcePath('services/ble/hogp/src/templates/callbacks/hogps/app_hogps_callbacks.h.ftl')
    hogpsCbHeaderFile.setOutputName('app_hogps_callbacks.h')
    hogpsCbHeaderFile.setOverwrite(True)
    hogpsCbHeaderFile.setDestPath('../../app_ble')
    hogpsCbHeaderFile.setProjectPath('app_ble')
    hogpsCbHeaderFile.setType('HEADER')
    hogpsCbHeaderFile.setEnabled(True)
    hogpsCbHeaderFile.setMarkup(True)
    
    global hogpsCbSourceFile
    hogpsCbSourceFile = globalsettings.createFileSymbol(None, None)
    hogpsCbSourceFile.setSourcePath('services/ble/hogp/src/templates/callbacks/hogps/app_hogps_callbacks.c.ftl')
    hogpsCbSourceFile.setOutputName('app_hogps_callbacks.c')
    hogpsCbSourceFile.setOverwrite(True)
    hogpsCbSourceFile.setDestPath('../../app_ble')
    hogpsCbSourceFile.setProjectPath('app_ble')
    hogpsCbSourceFile.setType('SOURCE')
    hogpsCbSourceFile.setEnabled(True)
    hogpsCbSourceFile.setMarkup(True)

    global hogpsHandlerHeaderFile
    hogpsHandlerHeaderFile = globalsettings.createFileSymbol(None, None)
    hogpsHandlerHeaderFile.setSourcePath('services/ble/hogp/src/templates/handlers/hogps/app_hogps_handler.h.ftl')
    hogpsHandlerHeaderFile.setOutputName('app_hogps_handler.h')
    hogpsHandlerHeaderFile.setOverwrite(True)
    hogpsHandlerHeaderFile.setDestPath('../../app_ble/handlers')
    hogpsHandlerHeaderFile.setProjectPath('app_ble/handlers')
    hogpsHandlerHeaderFile.setType('HEADER')
    hogpsHandlerHeaderFile.setEnabled(False)
    hogpsHandlerHeaderFile.setMarkup(True)

    global hogpsHandlerSourceFile
    hogpsHandlerSourceFile = globalsettings.createFileSymbol(None, None)
    hogpsHandlerSourceFile.setSourcePath('services/ble/hogp/src/templates/handlers/hogps/app_hogps_handler.c.ftl')
    hogpsHandlerSourceFile.setOutputName('app_hogps_handler.c')
    hogpsHandlerSourceFile.setOverwrite(True)
    hogpsHandlerSourceFile.setDestPath('../../app_ble/handlers')
    hogpsHandlerSourceFile.setProjectPath('app_ble/handlers')
    hogpsHandlerSourceFile.setType('SOURCE')
    hogpsHandlerSourceFile.setEnabled(False)
    hogpsHandlerSourceFile.setMarkup(True)

    anpKeyPressConfigTemplates = [('APP_HOGP_SHORT_KEY_PRESS', 'WLS_BLE_APP_KEY_MSG_SHORT_PRESS', 'add_hogp_short_keypress.c.ftl'),
                    ('APP_HOGP_LONG_KEY_PRESS', 'WLS_BLE_APP_KEY_MSG_LONG_PRESS', 'add_hogp_long_keypress.c.ftl')]

    n = 0
    anpkeypressconf = []
    for I, L, F in anpKeyPressConfigTemplates:
        anpkeypressconf.append(globalsettings.createFileSymbol(I, None))
        anpkeypressconf[n].setType('STRING')
        anpkeypressconf[n].setOutputName('wlsbleconfig.'+ L)
        anpkeypressconf[n].setSourcePath('services/ble/hogp/src/templates/' + F)
        anpkeypressconf[n].setMarkup(True)
        n = n + 1

def instantiateComponent(blehogpConfigComp):
    global gsettings
    global serverValue

    serverValue = 0

    print('Load Module: *****BLE HOGP system service*****')

    configName = Variables.get('__CONFIGURATION_NAME')
    processor = Variables.get('__PROCESSOR')
    print('Config Name: {} processor: {}'.format(configName, processor))
    print('Loading')
    print(Module.getPath())

    print('**HOGP BLE: calling components**')
    processor = Variables.get("__PROCESSOR")
    activeComponents = Database.getActiveComponentIDs()
    requiredComponents = ['wlsbleconfig','SERVICE_HIDS','SERVICE_BAS','PROFILE_HOGP','SERVICE_DIS']

    for r in requiredComponents:
        activeComponents = Database.getActiveComponentIDs()
        if r not in activeComponents:
            res = Database.activateComponents([r],"__ROOTVIEW",False)
            
    gsettings = blehogpConfigComp
    loadconfigmodule(gsettings)

def finalizeComponent(bleanpConfigComp):
    Database.activateComponents(["rtc"],"__ROOTVIEW",False)
    if 'pic32cx_bz2_devsupport' in Database.getActiveComponentIDs():
        Database.connectDependencies([['pic32cx_bz2_devsupport', 'RTC_Module', 'rtc', 'RTC_TMR']])
    elif 'pic32cx_bz3_devsupport' in Database.getActiveComponentIDs():
        Database.connectDependencies([['pic32cx_bz3_devsupport', 'RTC_Module', 'rtc', 'RTC_TMR']])

    hogpProfile = Database.getComponentByID("PROFILE_HOGP")
    if (hogpProfile != None):
        hogpServer = hogpProfile.getSymbolByID('HOGP_BOOL_SERVER')
        serverValue = hogpServer.getValue()

        hogpBoolServer.setValue(serverValue)
        
        hogpServer.setReadOnly(True)
        
    else:
        print('**HOGP BLE: HOGP not available##')

def destroyComponent(bleanpConfigComp):
    hogpProfile = Database.getComponentByID("PROFILE_HOGP")
    if (hogpProfile != None):
        hogpServer = hogpProfile.getSymbolByID('HOGP_BOOL_SERVER')
        hogpServer.setReadOnly(False)
