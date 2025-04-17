import string
import sys
# from numberconv import addnumber
##############Global variables##################################
pic32cx_bz2_family = {'PIC32CX1012BZ25048',
                      'PIC32CX1012BZ25032',
                      'PIC32CX1012BZ24032',
                      'WBZ451',
                      'WBZ450',
                       }

pic32cx_bz3_family = {'PIC32CX5109BZ31032',
                      'PIC32CX5109BZ31048',
                      'WBZ351',
                      'WBZ350',
                       }


# Added only less devices to pic32m family for testing
pic32m_family = {'PIC32MK0128MCA028',
                 'PIC32MK0128MCA032',
                 'PIC32MK0128MCA048',
                 'PIC32MK0256GPG048',
                 'PIC32MK0256GPG064',
                 'PIC32MK0256GPG048',
                 'PIC32MK0256GPH048',
                 'PIC32MK0256GPH064',
                 'PIC32MK0256MCJ048',
                 'PIC32MK0256MCJ064',
                  }
 

######################end glonal settings####################
debugStatus = False

def debugPrint(printStatus, message):
    if printStatus:
        print(message)



def ancsConfigBleStack(ancsValue):
    # debugPrint(debugStatus,'**ANCS BLE :ANCS BLE config :*',ancsValue)
    # Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADVERTISING", ancsValue)
    # Database.setSymbolValue("BLE_STACK_LIB", "GAP_PERIPHERAL", ancsValue)
    if(ancsMenuClient.getValue()== True):
        debugPrint(debugStatus,'**ANCS BLE: config ble client True')
        if (Database.getSymbolValue("BLE_STACK_LIB", "BLE_BOOL_GATT_CLIENT") != True):
            debugPrint(debugStatus,'**ANCS BLE: config ble BLE_BOOL_GATT_CLIENT True')
            Database.setSymbolValue("BLE_STACK_LIB", "BLE_BOOL_GATT_CLIENT", True)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_ADVERTISING") != True):
            debugPrint(debugStatus,'**ANCS BLE: config ble GAP_ADVERTISING True')
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADVERTISING", True)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_PERIPHERAL") != True):
            debugPrint(debugStatus,'**ANCS BLE: config ble GAP_PERIPHERAL True')
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_PERIPHERAL", True)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_ADV_DATA_UDD_EN") != True):
            debugPrint(debugStatus,'**ANCS BLE: config ble GAP_ADV_DATA_UDD_EN True')
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADV_DATA_UDD_EN", True)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_SCAN_RSP_DATA_UDD_EN") != True):
            debugPrint(debugStatus,'**ANCS BLE: config ble GAP_SCAN_RSP_DATA_UDD_EN True')
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_SCAN_RSP_DATA_UDD_EN", True)
        if ((Database.getSymbolValue("BLE_STACK_LIB", "BOOL_GCM_DD_INIT_DISC_IN_PER") != True)) and (Database.getSymbolValue("BLE_STACK_LIB", "BLE_BOOL_GATT_CLIENT") != False):
            debugPrint(debugStatus,'**ANCS BLE: config ble BOOL_GCM_DD_INIT_DISC_IN_PER True')
            Database.setSymbolValue("BLE_STACK_LIB", "BOOL_GCM_DD_INIT_DISC_IN_PER", True)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_SCAN_RSP_DATA_LOCAL_NAME_EN") != False):
            debugPrint(debugStatus,'**ANCS BLE: config ble GAP_SCAN_RSP_DATA_LOCAL_NAME_EN False')
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_SCAN_RSP_DATA_LOCAL_NAME_EN", False) 
        if (Database.getSymbolValue("BLE_STACK_LIB", "BLE_BOOL_GATT_CLIENT") != False) and (Database.getSymbolValue("BLE_STACK_LIB", "BOOL_GCM_DD_INIT_DISC_IN_CNTRL") == True):
            debugPrint(debugStatus,'**ANCS BLE: config ble BOOL_GCM_DD_INIT_DISC_IN_CNTRL False')
            Database.setSymbolValue("BLE_STACK_LIB", "BOOL_GCM_DD_INIT_DISC_IN_CNTRL", False) 
        Database.setSymbolValue("BLE_STACK_LIB", "GAP_DEV_NAME", "M-Dev")
        Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADV_DATA_LOCAL_NAME", "M-Dev")
        Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADV_DATA_UDD", "1115D0002D121E4B0FA4994ECEB531F40579")
        Database.setSymbolValue("BLE_STACK_LIB", "GAP_SCAN_RSP_DATA_UDD", "020A09")

        
    else:
        debugPrint(debugStatus,'**ANCS BLE: config ble client False')
        if (Database.getSymbolValue("BLE_STACK_LIB", "BLE_BOOL_GATT_CLIENT") != True):
            Database.setSymbolValue("BLE_STACK_LIB", "BLE_BOOL_GATT_CLIENT", True)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_ADVERTISING") != True):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADVERTISING", True)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_PERIPHERAL") != True):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_PERIPHERAL", True)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_ADV_DATA_UDD_EN") != False):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADV_DATA_UDD_EN", False)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_SCAN_RSP_DATA_UDD_EN") != False):
            debugPrint(debugStatus,'**ANCS BLE: config ble GAP_SCAN_RSP_DATA_UDD_EN False')
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_SCAN_RSP_DATA_UDD_EN", False)
        if ((Database.getSymbolValue("BLE_STACK_LIB", "BOOL_GCM_DD_INIT_DISC_IN_PER") != False)) and (Database.getSymbolValue("BLE_STACK_LIB", "BLE_BOOL_GATT_CLIENT") != False):
            debugPrint(debugStatus,'**ANCS BLE: config ble BOOL_GCM_DD_INIT_DISC_IN_PER False')
            Database.setSymbolValue("BLE_STACK_LIB", "BOOL_GCM_DD_INIT_DISC_IN_PER", False)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_SCAN_RSP_DATA_LOCAL_NAME_EN") != True):
            debugPrint(debugStatus,'**ANCS BLE: config ble GAP_SCAN_RSP_DATA_LOCAL_NAME_EN True')
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_SCAN_RSP_DATA_LOCAL_NAME_EN", True) 
        if (Database.getSymbolValue("BLE_STACK_LIB", "BLE_BOOL_GATT_CLIENT") != False) and (Database.getSymbolValue("BLE_STACK_LIB", "BOOL_GCM_DD_INIT_DISC_IN_CNTRL") != True):
            debugPrint(debugStatus,'**ANCS BLE: config ble BOOL_GCM_DD_INIT_DISC_IN_CNTRL True')
            Database.setSymbolValue("BLE_STACK_LIB", "BOOL_GCM_DD_INIT_DISC_IN_CNTRL", True)
        
        Database.setSymbolValue("BLE_STACK_LIB", "GAP_DEV_NAME", "Microchip")
        Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADV_DATA_LOCAL_NAME", "pic32cx-bz")
        Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADV_DATA_UDD", "00")
        Database.setSymbolValue("BLE_STACK_LIB", "GAP_SCAN_RSP_DATA_UDD", "00")


def ancsClientConfig(symbol, event):
    # print('**ANCS BLE :ANCS triggered client enabled :*',event["value"])
    Database.setSymbolValue("PROFILE_ANCS", "ANCS_BOOL_CLIENT", event["value"])
    ancsConfigBleStack(event["value"])

def bleAncsFileEnable(symbol, event):
    # print('**ANCS BLE :check file trigger')
    if  ancsMenuClient.getValue():
        symbol.setEnabled(True)
    else:
        symbol.setEnabled(False)
    
   


def setUIElements(globalsettings):
    configName = Variables.get('__CONFIGURATION_NAME')
    processor = Variables.get('__PROCESSOR')
    standalone = 0 
    attached = 1
    connectiontype = standalone
    print('Config Name: {} processor: {}'.format(configName, processor))
      
    # Config settings
    # menu symbol
    # print('ANCS BLE :Loading menu symbol')
    serviceConfig = globalsettings.createMenuSymbol('SERVICE_CONFIG', None)
    serviceConfig.setLabel('Service configuration')
    serviceConfig.setVisible(True)
    serviceConfig.setDescription("WME config settings")


    #Enable app code
    # print('ANCS BLE :Loading Enable app code')
    booleanappcodebox = globalsettings.createBooleanSymbol('booleanappcode', None)
    booleanappcodebox.setLabel('Enable App Code Generation')
    booleanappcodebox.setDescription('Enable App Code Generation for generating sample code')
    booleanappcodebox.setDefaultValue(True)
    booleanappcodebox.setVisible(True)

    #################################################################
    ##################      Client Role Settings      ###############
    #################################################################

    # ANCS clientconfig
    # print('ANCS BLE :Loading ancs client*')
    global ancsMenuClient
    
    ancsMenuClient = globalsettings.createBooleanSymbol('SS_ANCS_BOOL_CLIENT', serviceConfig)
    ancsMenuClient.setLabel('Enable Client Role')
    ancsMenuClient.setDefaultValue(False)
    ancsMenuClient.setVisible(True)
    ancsMenuClient.setDependencies(ancsClientConfig, ["SS_ANCS_BOOL_CLIENT"])

   


def finalizeComponent(bleAncsConfigComp):
    # print('FInalising')
    global enClient,ancsProfile
    ancsProfile = Database.getComponentByID("PROFILE_ANCS")
    if (ancsProfile != None):

        ##########################################################################
        ##################      Default Client value Settings      ###############
        ##########################################################################

        clientValue = Database.getSymbolValue("PROFILE_ANCS", "ANCS_BOOL_CLIENT")
        # print('**ANCS BLE: Default ClientValue:',clientValue)

        ##########################################################################
        ##################                  Set  readonly          ###############
        ##########################################################################
        # print('**ANCS BLE: symbols disabling')
        enClient = ancsProfile.getSymbolByID('ANCS_BOOL_CLIENT')
        enClient.setReadOnly(True)

        #set value
        ancsMenuClient.setValue(clientValue)

    else:
        print('**ANCS BLE: ANCS not available##')
    # print('finalised')

def destroyComponent(bleanpConfigComp):
    global enClient
    enClient.setReadOnly(False)



def instantiateComponent(bleAncsConfigComp):
    global gsettings
    global clientValue


    print('Load Module: *****BLE ANCS App service*****')

    configName = Variables.get('__CONFIGURATION_NAME')
    processor = Variables.get('__PROCESSOR')
    print('Config Name: {} processor: {}'.format(configName, processor))
    print('Loading')
    print(Module.getPath())

    # print('**ANCS BLE: calling components**')
    processor = Variables.get("__PROCESSOR")
    activeComponents = Database.getActiveComponentIDs()
    # print('**ANCS BLE: calling components**')
    requiredComponents = ['wlsbleconfig','PROFILE_ANCS']        

    for r in requiredComponents:
        activeComponents = Database.getActiveComponentIDs()
        if r not in activeComponents:
            res = Database.activateComponents([r],"__ROOTVIEW",False)

    
    ##########################################################################
    ##################                  UI elements            ###############
    ##########################################################################

    gsettings = bleAncsConfigComp
    setUIElements(gsettings)


    ##########################################################################
    ##################            Adding source file           ###############
    ##########################################################################


    global ancsHandlerSourceFile
    ancsHandlerSourceFile = bleAncsConfigComp.createFileSymbol(None, None)
    ancsHandlerSourceFile.setSourcePath("services/ble/ancs/src/templates/app_ancs_handler.c.ftl")
    ancsHandlerSourceFile.setOutputName("app_ancs_handler.c")
    ancsHandlerSourceFile.setDestPath('../../app_ble/handlers')
    ancsHandlerSourceFile.setProjectPath('app_ble/handlers')
    ancsHandlerSourceFile.setType('SOURCE')
    ancsHandlerSourceFile.setMarkup(True)
    ancsHandlerSourceFile.setOverwrite(True)
    ancsHandlerSourceFile.setEnabled(False)
    ancsHandlerSourceFile.setDependencies(bleAncsFileEnable,["SS_ANCS_BOOL_CLIENT"])

    global ancsHandlerHeaderFile
    ancsHandlerHeaderFile = bleAncsConfigComp.createFileSymbol(None, None)
    ancsHandlerHeaderFile.setSourcePath("services/ble/ancs/src/templates/app_ancs_handler.h.ftl")
    ancsHandlerHeaderFile.setOutputName("app_ancs_handler.h")
    ancsHandlerHeaderFile.setDestPath('../../app_ble/handlers')
    ancsHandlerHeaderFile.setProjectPath('app_ble/handlers')
    ancsHandlerHeaderFile.setType('HEADER')
    ancsHandlerHeaderFile.setMarkup(True)
    ancsHandlerHeaderFile.setOverwrite(True)
    ancsHandlerHeaderFile.setEnabled(False)
    ancsHandlerHeaderFile.setDependencies(bleAncsFileEnable,["SS_ANCS_BOOL_CLIENT"])


    global ancsCallbackSourceFile
    ancsCallbackSourceFile = bleAncsConfigComp.createFileSymbol(None, None)
    ancsCallbackSourceFile.setSourcePath("services/ble/ancs/src/templates/app_ancs_callbacks.c.ftl")
    ancsCallbackSourceFile.setOutputName("app_ancs_callbacks.c")
    ancsCallbackSourceFile.setDestPath('../../app_ble')
    ancsCallbackSourceFile.setProjectPath('app_ble')
    ancsCallbackSourceFile.setType('SOURCE')
    ancsCallbackSourceFile.setMarkup(True)
    ancsCallbackSourceFile.setOverwrite(True)
    ancsCallbackSourceFile.setEnabled(False)
    ancsCallbackSourceFile.setDependencies(bleAncsFileEnable,["SS_ANCS_BOOL_CLIENT"])
 
 
    global ancsCallbackHeaderFile
    ancsCallbackHeaderFile = bleAncsConfigComp.createFileSymbol(None, None)
    ancsCallbackHeaderFile.setSourcePath("services/ble/ancs/src/templates/app_ancs_callbacks.h.ftl")
    ancsCallbackHeaderFile.setOutputName("app_ancs_callbacks.h")
    ancsCallbackHeaderFile.setDestPath('../../app_ble')
    ancsCallbackHeaderFile.setProjectPath('app_ble')
    ancsCallbackHeaderFile.setType('HEADER')
    ancsCallbackHeaderFile.setMarkup(True)
    ancsCallbackHeaderFile.setOverwrite(True)
    ancsCallbackHeaderFile.setEnabled(False)
    ancsCallbackHeaderFile.setDependencies(bleAncsFileEnable,["SS_ANCS_BOOL_CLIENT"])

    ancsKeyPressConfigTemplates = [('APP_ANCS_SHORT_KEY_PRESS', 'WLS_BLE_APP_KEY_MSG_SHORT_PRESS', 'add_ancs_short_keypress.c.ftl'),
                ('APP_ANCS_LONG_KEY_PRESS', 'WLS_BLE_APP_KEY_MSG_LONG_PRESS', 'add_ancs_long_keypress.c.ftl'),
                ('APP_ANCS_DOUBLE_KEY_PRESS', 'WLS_BLE_APP_KEY_MSG_DOUBLE_CLICK', 'add_ancs_double_keypress.c.ftl')]

    n = 0
    ancskeypressconf = []
    for I, L, F in ancsKeyPressConfigTemplates:
        ancskeypressconf.append(bleAncsConfigComp.createFileSymbol(I, None))
        ancskeypressconf[n].setType('STRING')
        ancskeypressconf[n].setOutputName('wlsbleconfig.'+ L)
        ancskeypressconf[n].setSourcePath('services/ble/ancs/src/templates/' + F)
        ancskeypressconf[n].setMarkup(True)
        n = n + 1


    print('#############ANCS end of component ######################')

