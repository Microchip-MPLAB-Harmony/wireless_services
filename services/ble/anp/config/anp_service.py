import string
import sys
# from numberconv import addnumber
##############Global variables##################################


######################end glonal settings####################

def anpConfigBLEStack():
    if(anpBoolClient.getValue()) and not (anpBoolServer.getValue()):
        if (Database.getSymbolValue("BLE_STACK_LIB", "BLE_BOOL_GATT_CLIENT") != True):
            Database.setSymbolValue("BLE_STACK_LIB", "BLE_BOOL_GATT_CLIENT", True)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_SCAN") != False):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_SCAN", False)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_CENTRAL") != False):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_CENTRAL", False)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_ADVERTISING") != True):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADVERTISING", True)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_PERIPHERAL") != True):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_PERIPHERAL", True)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_SCAN_RSP_DATA_LOCAL_NAME_EN") != False):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_SCAN_RSP_DATA_LOCAL_NAME_EN", False) 
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_SCAN_RSP_DATA_UDD_EN") != True):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_SCAN_RSP_DATA_UDD_EN", True)
        if ((Database.getSymbolValue("BLE_STACK_LIB", "BOOL_GCM_DD_INIT_DISC_IN_PER") != True)) and (Database.getSymbolValue("BLE_STACK_LIB", "BLE_BOOL_GATT_CLIENT") != False):
            Database.setSymbolValue("BLE_STACK_LIB", "BOOL_GCM_DD_INIT_DISC_IN_PER", True)
            Database.setSymbolValue("BLE_STACK_LIB", "BOOL_GCM_DD_INIT_DISC_IN_CNTRL", False)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_ADV_DATA_UDD_EN") != True):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADV_DATA_UDD_EN", True)

        Database.setSymbolValue("BLE_STACK_LIB", "GAP_DEV_NAME", "ANPC-DEV")
        Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADV_DATA_LOCAL_NAME", "ANPC-DEV")
        Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADV_DATA_UDD", "03031118")
        Database.setSymbolValue("BLE_STACK_LIB", "GAP_SCAN_RSP_DATA_UDD", "020A09")

    if not (anpBoolClient.getValue()) and (anpBoolServer.getValue()):
        if (Database.getSymbolValue("BLE_STACK_LIB", "BLE_BOOL_GATT_CLIENT") != False):
            Database.setSymbolValue("BLE_STACK_LIB", "BOOL_GCM_DD_INIT_DISC_IN_PER", False)
            Database.setSymbolValue("BLE_STACK_LIB", "BOOL_GCM_DD_INIT_DISC_IN_CNTRL", False)
            Database.setSymbolValue("BLE_STACK_LIB", "BLE_BOOL_GATT_CLIENT", False)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_SCAN") != True):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_SCAN", True)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_CENTRAL") != True):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_CENTRAL", True)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_ADVERTISING") != False):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADVERTISING", False)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_PERIPHERAL") != False):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_PERIPHERAL", False)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_SCAN_RSP_DATA_LOCAL_NAME_EN") != False):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_SCAN_RSP_DATA_LOCAL_NAME_EN", False) 
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_SCAN_RSP_DATA_UDD_EN") != False):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_SCAN_RSP_DATA_UDD_EN", False)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_ADV_DATA_UDD_EN") != False):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADV_DATA_UDD_EN", False)


        Database.setSymbolValue("BLE_STACK_LIB", "GAP_DEV_NAME", "ANPS-DEV")
        Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADV_DATA_LOCAL_NAME", "00")
        Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADV_DATA_UDD", "00")
        Database.setSymbolValue("BLE_STACK_LIB", "GAP_SCAN_RSP_DATA_UDD", "00")
    
    if not (anpBoolClient.getValue()) and not (anpBoolServer.getValue()):
        if (Database.getSymbolValue("BLE_STACK_LIB", "BLE_BOOL_GATT_CLIENT") != True):
            Database.setSymbolValue("BLE_STACK_LIB", "BLE_BOOL_GATT_CLIENT", True)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_ADVERTISING") != True):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADVERTISING", True)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_PERIPHERAL") != True):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_PERIPHERAL", True)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_ADV_DATA_UDD_EN") != False):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADV_DATA_UDD_EN", False)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_SCAN_RSP_DATA_UDD_EN") != False):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_SCAN_RSP_DATA_UDD_EN", False)
        if ((Database.getSymbolValue("BLE_STACK_LIB", "BOOL_GCM_DD_INIT_DISC_IN_PER") != False)) and (Database.getSymbolValue("BLE_STACK_LIB", "BLE_BOOL_GATT_CLIENT") != False):
            Database.setSymbolValue("BLE_STACK_LIB", "BOOL_GCM_DD_INIT_DISC_IN_PER", False)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_SCAN_RSP_DATA_LOCAL_NAME_EN") != True):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_SCAN_RSP_DATA_LOCAL_NAME_EN", True) 
        if (Database.getSymbolValue("BLE_STACK_LIB", "BLE_BOOL_GATT_CLIENT") != False) and (Database.getSymbolValue("BLE_STACK_LIB", "BOOL_GCM_DD_INIT_DISC_IN_CNTRL") != True):
            Database.setSymbolValue("BLE_STACK_LIB", "BOOL_GCM_DD_INIT_DISC_IN_CNTRL", True)
        
        Database.setSymbolValue("BLE_STACK_LIB", "GAP_DEV_NAME", "Microchip")
        Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADV_DATA_LOCAL_NAME", "pic32cx-bz")
        Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADV_DATA_UDD", "00")
        Database.setSymbolValue("BLE_STACK_LIB", "GAP_SCAN_RSP_DATA_UDD", "00")

    if (anpBoolClient.getValue()) and (anpBoolServer.getValue()):
        if (Database.getSymbolValue("BLE_STACK_LIB", "BLE_BOOL_GATT_CLIENT") != True):
            Database.setSymbolValue("BLE_STACK_LIB", "BLE_BOOL_GATT_CLIENT", True)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_ADVERTISING") != True):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADVERTISING", True)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_PERIPHERAL") != True):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_PERIPHERAL", True)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_ADV_DATA_UDD_EN") != False):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADV_DATA_UDD_EN", False)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_SCAN_RSP_DATA_UDD_EN") != False):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_SCAN_RSP_DATA_UDD_EN", False)
        if ((Database.getSymbolValue("BLE_STACK_LIB", "BOOL_GCM_DD_INIT_DISC_IN_PER") != False)) and (Database.getSymbolValue("BLE_STACK_LIB", "BLE_BOOL_GATT_CLIENT") != False):
            Database.setSymbolValue("BLE_STACK_LIB", "BOOL_GCM_DD_INIT_DISC_IN_PER", False)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_SCAN_RSP_DATA_LOCAL_NAME_EN") != True):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_SCAN_RSP_DATA_LOCAL_NAME_EN", True) 
        if (Database.getSymbolValue("BLE_STACK_LIB", "BLE_BOOL_GATT_CLIENT") != False) and (Database.getSymbolValue("BLE_STACK_LIB", "BOOL_GCM_DD_INIT_DISC_IN_CNTRL") != True):
            Database.setSymbolValue("BLE_STACK_LIB", "BOOL_GCM_DD_INIT_DISC_IN_CNTRL", True)
        
        Database.setSymbolValue("BLE_STACK_LIB", "GAP_DEV_NAME", "Microchip")
        Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADV_DATA_LOCAL_NAME", "pic32cx-bz")
        Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADV_DATA_UDD", "00")
        Database.setSymbolValue("BLE_STACK_LIB", "GAP_SCAN_RSP_DATA_UDD", "00")

def anpClientConfig(symbol, event):
    value = event["value"]

    anpService = Database.getComponentByID("SERVICE_ANS")
    if (anpService == None and event["value"] == True):
        Database.activateComponents(["SERVICE_ANS"],"__ROOTVIEW",False)
        Database.connectDependencies([['PROFILE_ANP', 'BLE_ANS_Dependency', 'SERVICE_ANS', 'BLE_ANS_Capability']])
    
    anpConfigBLEStack()

 
    anpProfile = Database.getComponentByID("PROFILE_ANP")
    if (anpProfile != None):
        anpClient = anpProfile.getSymbolByID('ANP_BOOL_CLIENT')
        anpClient.setValue(value)

    if value == True:
        anpcCbHeaderFile.setEnabled(True)
        anpcCbSourceFile.setEnabled(True)
        anpcHandlerHeaderFile.setEnabled(True)
        anpcHandlerSourceFile.setEnabled(True)
    else:
        anpcCbHeaderFile.setEnabled(False)
        anpcCbSourceFile.setEnabled(False)
        anpcHandlerHeaderFile.setEnabled(False)
        anpcHandlerSourceFile.setEnabled(False)
    

def anpServerConfig(symbol, event):
    value = event["value"]

    anpConfigBLEStack()
    
    anpProfile = Database.getComponentByID("PROFILE_ANP")
    if (anpProfile != None):
        anpServer = anpProfile.getSymbolByID('ANP_BOOL_SERVER')
        anpServer.setValue(value)
    
    anpService = Database.getComponentByID("SERVICE_ANS")
    if (anpService == None and anpBoolClient.getValue() == True):
        Database.activateComponents(["SERVICE_ANS"],"__ROOTVIEW",False)
        Database.connectDependencies([['PROFILE_ANP', 'BLE_ANS_Dependency', 'SERVICE_ANS', 'BLE_ANS_Capability']])
    

    if value == True:
        anpsCbHeaderFile.setEnabled(True)
        anpsCbSourceFile.setEnabled(True)
        anpsHandlerHeaderFile.setEnabled(True)
        anpsHandlerSourceFile.setEnabled(True)
    else:
        anpsCbHeaderFile.setEnabled(False)
        anpsCbSourceFile.setEnabled(False)
        anpsHandlerHeaderFile.setEnabled(False)
        anpsHandlerSourceFile.setEnabled(False)
    


def loadconfigmodule(globalsettings):
    # Anp config
    anp_configsetting = globalsettings.createMenuSymbol('ANPSS_MENU_CONFIGSET', None)
    anp_configsetting.setLabel('Service configuration')
    anp_configsetting.setVisible(True)
    anp_configsetting.setDescription("ANP Service configuration")

    # anpAppCode = globalsettings.createBooleanSymbol('ANPSS_BOOL_APP_CODE_ENABLE', anp_configsetting)
    global anpAppCode
    anpAppCode = globalsettings.createBooleanSymbol('booleanappcode', None)
    anpAppCode.setLabel('Enable App Code Generation')
    anpAppCode.setDescription('Enable App Code Generation for generating sample code')
    anpAppCode.setDefaultValue(True)
    anpAppCode.setVisible(True)

    #################################################################
    ##################      Client Role Settings      ###############
    #################################################################

    # ANP clientconfig
    global anpBoolClient
    anpBoolClient = globalsettings.createBooleanSymbol('ANPSS_BOOL_CLIENT', anp_configsetting)
    anpBoolClient.setLabel('Enable Client Role')
    anpBoolClient.setDefaultValue(False)
    anpBoolClient.setDependencies(anpClientConfig, ["ANPSS_BOOL_CLIENT"])
     
    #################################################################
    ##################      Server Role Settings      ###############
    #################################################################
    global anpBoolServer
    anpBoolServer = globalsettings.createBooleanSymbol('ANPSS_BOOL_SERVER', anp_configsetting)
    anpBoolServer.setLabel('Enable Server Role')
    anpBoolServer.setDefaultValue(False)
    anpBoolServer.setDependencies(anpServerConfig, ["ANPSS_BOOL_SERVER"])

    global anpsCbHeaderFile
    anpsCbHeaderFile = globalsettings.createFileSymbol(None, None)
    anpsCbHeaderFile.setSourcePath('services/ble/anp/src/templates/callbacks/anps/app_anps_callbacks.h.ftl')
    anpsCbHeaderFile.setOutputName('app_anps_callbacks.h')
    anpsCbHeaderFile.setOverwrite(True)
    anpsCbHeaderFile.setDestPath('../../app_ble')
    anpsCbHeaderFile.setProjectPath('app_ble')
    anpsCbHeaderFile.setType('HEADER')
    anpsCbHeaderFile.setEnabled(False)
    anpsCbHeaderFile.setMarkup(True)

    global anpsCbSourceFile
    anpsCbSourceFile = globalsettings.createFileSymbol(None, None)
    anpsCbSourceFile.setSourcePath('services/ble/anp/src/templates/callbacks/anps/app_anps_callbacks.c.ftl')
    anpsCbSourceFile.setOutputName('app_anps_callbacks.c')
    anpsCbSourceFile.setOverwrite(True)
    anpsCbSourceFile.setDestPath('../../app_ble')
    anpsCbSourceFile.setProjectPath('app_ble')
    anpsCbSourceFile.setType('SOURCE')
    anpsCbSourceFile.setEnabled(False)
    anpsCbSourceFile.setMarkup(True)

    global anpcCbHeaderFile
    anpcCbHeaderFile = globalsettings.createFileSymbol(None, None)
    anpcCbHeaderFile.setSourcePath('services/ble/anp/src/templates/callbacks/anpc/app_anpc_callbacks.h.ftl')
    anpcCbHeaderFile.setOutputName('app_anpc_callbacks.h')
    anpcCbHeaderFile.setOverwrite(True)
    anpcCbHeaderFile.setDestPath('../../app_ble')
    anpcCbHeaderFile.setProjectPath('app_ble')
    anpcCbHeaderFile.setType('HEADER')
    anpcCbHeaderFile.setEnabled(False)
    anpcCbHeaderFile.setMarkup(True)

    global anpcCbSourceFile
    anpcCbSourceFile = globalsettings.createFileSymbol(None, None)
    anpcCbSourceFile.setSourcePath('services/ble/anp/src/templates/callbacks/anpc/app_anpc_callbacks.c.ftl')
    anpcCbSourceFile.setOutputName('app_anpc_callbacks.c')
    anpcCbSourceFile.setOverwrite(True)
    anpcCbSourceFile.setDestPath('../../app_ble')
    anpcCbSourceFile.setProjectPath('app_ble')
    anpcCbSourceFile.setType('SOURCE')
    anpcCbSourceFile.setEnabled(False)
    anpcCbSourceFile.setMarkup(True)

    global anpsHandlerHeaderFile
    anpsHandlerHeaderFile = globalsettings.createFileSymbol(None, None)
    anpsHandlerHeaderFile.setSourcePath('services/ble/anp/src/templates/handlers/anps/app_anps_handler.h.ftl')
    anpsHandlerHeaderFile.setOutputName('app_anps_handler.h')
    anpsHandlerHeaderFile.setOverwrite(True)
    anpsHandlerHeaderFile.setDestPath('../../app_ble/handlers')
    anpsHandlerHeaderFile.setProjectPath('app_ble/handlers')
    anpsHandlerHeaderFile.setType('HEADER')
    anpsHandlerHeaderFile.setEnabled(False)
    anpsHandlerHeaderFile.setMarkup(True)

    global anpsHandlerSourceFile
    anpsHandlerSourceFile = globalsettings.createFileSymbol(None, None)
    anpsHandlerSourceFile.setSourcePath('services/ble/anp/src/templates/handlers/anps/app_anps_handler.c.ftl')
    anpsHandlerSourceFile.setOutputName('app_anps_handler.c')
    anpsHandlerSourceFile.setOverwrite(True)
    anpsHandlerSourceFile.setDestPath('../../app_ble/handlers')
    anpsHandlerSourceFile.setProjectPath('app_ble/handlers')
    anpsHandlerSourceFile.setType('SOURCE')
    anpsHandlerSourceFile.setEnabled(False)
    anpsHandlerSourceFile.setMarkup(True)

    global anpcHandlerHeaderFile
    anpcHandlerHeaderFile = globalsettings.createFileSymbol(None, None)
    anpcHandlerHeaderFile.setSourcePath('services/ble/anp/src/templates/handlers/anpc/app_anpc_handler.h.ftl')
    anpcHandlerHeaderFile.setOutputName('app_anpc_handler.h')
    anpcHandlerHeaderFile.setOverwrite(True)
    anpcHandlerHeaderFile.setDestPath('../../app_ble/handlers')
    anpcHandlerHeaderFile.setProjectPath('app_ble/handlers')
    anpcHandlerHeaderFile.setType('HEADER')
    anpcHandlerHeaderFile.setEnabled(False)
    anpcHandlerHeaderFile.setMarkup(True)

    global anpcHandlerSourceFile
    anpcHandlerSourceFile = globalsettings.createFileSymbol(None, None)
    anpcHandlerSourceFile.setSourcePath('services/ble/anp/src/templates/handlers/anpc/app_anpc_handler.c.ftl')
    anpcHandlerSourceFile.setOutputName('app_anpc_handler.c')
    anpcHandlerSourceFile.setOverwrite(True)
    anpcHandlerSourceFile.setDestPath('../../app_ble/handlers')
    anpcHandlerSourceFile.setProjectPath('app_ble/handlers')
    anpcHandlerSourceFile.setType('SOURCE')
    anpcHandlerSourceFile.setEnabled(False)
    anpcHandlerSourceFile.setMarkup(True)

    anpKeyPressConfigTemplates = [('APP_ANP_SHORT_KEY_PRESS', 'WLS_BLE_APP_KEY_MSG_SHORT_PRESS', 'add_anp_short_keypress.c.ftl'),
                    ('APP_ANP_LONG_KEY_PRESS', 'WLS_BLE_APP_KEY_MSG_LONG_PRESS', 'add_anp_long_keypress.c.ftl')]

    n = 0
    anpkeypressconf = []
    for I, L, F in anpKeyPressConfigTemplates:
        anpkeypressconf.append(globalsettings.createFileSymbol(I, None))
        anpkeypressconf[n].setType('STRING')
        anpkeypressconf[n].setOutputName('wlsbleconfig.'+ L)
        anpkeypressconf[n].setSourcePath('services/ble/anp/src/templates/' + F)
        anpkeypressconf[n].setMarkup(True)
        n = n + 1

def instantiateComponent(bleanpConfigComp):
    global gsettings

    print('Load Module: *****BLE ANP system service*****')

    configName = Variables.get('__CONFIGURATION_NAME')
    processor = Variables.get('__PROCESSOR')
    print('Config Name: {} processor: {}'.format(configName, processor))
    print('Loading')
    print(Module.getPath())

    print('**ANP BLE: calling components**')
    processor = Variables.get("__PROCESSOR")
    activeComponents = Database.getActiveComponentIDs()
    requiredComponents = ['wlsbleconfig','PROFILE_ANP']

    for r in requiredComponents:
        activeComponents = Database.getActiveComponentIDs()
        if r not in activeComponents:
            res = Database.activateComponents([r],"__ROOTVIEW",False)   
        
    gsettings = bleanpConfigComp
    loadconfigmodule(gsettings)

def finalizeComponent(bleanpConfigComp):
    anpProfile = Database.getComponentByID("PROFILE_ANP")
    if (anpProfile != None):
        anpClient = anpProfile.getSymbolByID('ANP_BOOL_CLIENT')
        clientValue = anpClient.getValue()
        
        anpServer = anpProfile.getSymbolByID('ANP_BOOL_SERVER')
        serverValue = anpServer.getValue()
        
        anpBoolClient.setValue(clientValue)
        anpBoolServer.setValue(serverValue)
        
        anpClient.setReadOnly(True)
        anpServer.setReadOnly(True)
        
        if serverValue == True:
            anpsCbHeaderFile.setEnabled(True)
            anpsCbSourceFile.setEnabled(True)
            anpsHandlerHeaderFile.setEnabled(True)
            anpsHandlerSourceFile.setEnabled(True)
        else:
            anpsCbHeaderFile.setEnabled(False)
            anpsCbSourceFile.setEnabled(False)
            anpsHandlerHeaderFile.setEnabled(False)
            anpsHandlerSourceFile.setEnabled(False)
            
        if clientValue == True:
            anpcCbHeaderFile.setEnabled(True)
            anpcCbSourceFile.setEnabled(True)
            anpcHandlerHeaderFile.setEnabled(True)
            anpcHandlerSourceFile.setEnabled(True)
        else:
            anpcCbHeaderFile.setEnabled(False)
            anpcCbSourceFile.setEnabled(False)
            anpcHandlerHeaderFile.setEnabled(False)
            anpcHandlerSourceFile.setEnabled(False)

            anpService = Database.getComponentByID("SERVICE_ANS")
            if(anpService != None):
                print("Connecting dependecies\r\n")
                res = Database.connectDependencies([['PROFILE_ANP', 'BLE_ANS_Dependency', 'SERVICE_ANS', 'BLE_ANS_Capability']])
            else:
                print("Activating Service\r\n")
                Database.activateComponents(["SERVICE_ANS"],"__ROOTVIEW",False)
                res = Database.connectDependencies([['PROFILE_ANP', 'BLE_ANS_Dependency', 'SERVICE_ANS', 'BLE_ANS_Capability']])
    else:
        print('**ANP BLE: ANP not available##')

def destroyComponent(bleanpConfigComp):
    anpProfile = Database.getComponentByID("PROFILE_ANP")
    if (anpProfile != None):
        anpClient = anpProfile.getSymbolByID('ANP_BOOL_CLIENT')
        anpClient.setReadOnly(False)
        
        anpServer = anpProfile.getSymbolByID('ANP_BOOL_SERVER')
        anpServer.setReadOnly(False)
