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

debugStatus = True

def debugPrint(printStatus, message):
    if printStatus:
        print(message)

'''
example usage
def debugPrint(printStatus, message):
    if printStatus:
        print(message)

# Example usage:
value = 42
debugPrint(True, f"The value is: {value}")
'''
######################end global settings####################

def trspshandlerFilesCallback(symbol, event):
    # if(Database.getSymbolValue("PROFILE_TRSP", "TRSP_BOOL_SERVER") == True):
    if(event["value"] == True):
        symbol.setEnabled(True)
    else:
        symbol.setEnabled(False)

def trspchandlerFilesCallback(symbol, event):
    # if(Database.getSymbolValue("PROFILE_TRSP", "TRSP_BOOL_CLIENT") == True):
    if(event["value"] == True):
        symbol.setEnabled(True)
    else:
        symbol.setEnabled(False)



def trspConfigBleStack():

    if((trspMenuServer.getValue()== False) and (trspMenuClient.getValue()== False)):
        debugPrint(debugStatus,'**TRP BLE: config ble client server false')
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_SCAN") != False):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_SCAN", False)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_CENTRAL") != False):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_CENTRAL", False)
        if (Database.getSymbolValue("BLE_STACK_LIB", "BLE_BOOL_GATT_CLIENT") != False):
            Database.setSymbolValue("BLE_STACK_LIB", "BLE_BOOL_GATT_CLIENT", False)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_ADVERTISING") != True):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADVERTISING", True)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_PERIPHERAL") != True):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_PERIPHERAL", True)
    elif((trspMenuServer.getValue()== True) and (trspMenuClient.getValue()== True)):
        debugPrint(debugStatus,'**TRP BLE: config ble client server True')
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_SCAN") != True):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_SCAN", True)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_CENTRAL") != True):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_CENTRAL", True)
        if (Database.getSymbolValue("BLE_STACK_LIB", "BLE_BOOL_GATT_CLIENT") != True):
            Database.setSymbolValue("BLE_STACK_LIB", "BLE_BOOL_GATT_CLIENT", True)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_ADVERTISING") != True):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADVERTISING", True)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_PERIPHERAL") != True):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_PERIPHERAL", True)
    elif((trspMenuServer.getValue()== True) and (trspMenuClient.getValue()== False)):
        debugPrint(debugStatus,'**TRP BLE: config ble client False server True')
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
    elif((trspMenuServer.getValue()== False) and (trspMenuClient.getValue()== True)):
        debugPrint(debugStatus,'**TRP BLE: config ble client True server False')
        if (Database.getSymbolValue("BLE_STACK_LIB", "BLE_BOOL_GATT_CLIENT") != True):
            Database.setSymbolValue("BLE_STACK_LIB", "BLE_BOOL_GATT_CLIENT", True)

        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_SCAN") != True):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_SCAN", True)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_CENTRAL") != True):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_CENTRAL", True)

        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_ADVERTISING") != False):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADVERTISING", False)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_PERIPHERAL") != False):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_PERIPHERAL", False)


def trspClientConfig(symbol, event):
    Database.setSymbolValue("PROFILE_TRSP", "TRSP_BOOL_CLIENT", event["value"])
    print('**TRP BLE: TRSP client**',event["value"])
    TrspServer = Database.getComponentByID("SERVICE_TRS")
    if (TrspServer == None and event["value"] == True):
        print('**TRP BLE: TRSP server enabled**',event["value"])
        Database.activateComponents(["SERVICE_TRS"],"__ROOTVIEW",False)
        Database.connectDependencies([['PROFILE_TRSP', 'BLE_TRS_Dependency', 'SERVICE_TRS', 'BLE_TRS_Capability']])
    trspConfigBleStack()



def trspServerConfig(symbol, event):
    Database.setSymbolValue("PROFILE_TRSP", "TRSP_BOOL_SERVER", event["value"])
    TrspServer = Database.getComponentByID("SERVICE_TRS")
    if (TrspServer == None and Database.getSymbolValue("PROFILE_TRSP", 'TRSP_BOOL_CLIENT') == True):
        Database.activateComponents(["SERVICE_TRS"],"__ROOTVIEW",False)
        Database.connectDependencies([['PROFILE_TRSP', 'BLE_TRS_Dependency', 'SERVICE_TRS', 'BLE_TRS_Capability']])
    trspConfigBleStack()

def loadconfigmodule(globalsettings):
    configName = Variables.get('__CONFIGURATION_NAME')
    processor = Variables.get('__PROCESSOR')
    standalone = 0 
    attached = 1
    connectiontype = standalone
    print('Config Name: {} processor: {}'.format(configName, processor))
      
    # Config settings
    # menu symbol
    debugPrint(debugStatus,'Debug:Loading menu symbol')
    serviceConfig = globalsettings.createMenuSymbol('config_set2', None)
    serviceConfig.setLabel('Service configuration')
    serviceConfig.setVisible(True)
    serviceConfig.setDescription("WME config settings")


    #Enable app code
    debugPrint(debugStatus,'Debug:Loading Enable app code')
    booleanappcodebox = globalsettings.createBooleanSymbol('booleanappcode', None)
    booleanappcodebox.setLabel('Enable App Code Generation')
    booleanappcodebox.setDescription('Enable App Code Generation for generating sample code')
    booleanappcodebox.setDefaultValue(True)
    booleanappcodebox.setVisible(True)


    #################################################################
    ##################      Client Role Settings      ###############
    #################################################################

    # Trp clientconfig
    debugPrint(debugStatus,'Debug:Loading TRP client*')
    global trspMenuClient
    
    trspMenuClient = globalsettings.createBooleanSymbol('SS_TRSP_BOOL_CLIENT', serviceConfig)
    trspMenuClient.setLabel('Enable Client Role')
    trspMenuClient.setDefaultValue(False)
    # trspMenuClient.setDependencies(trspClientConfig, ["SS_TRSP_BOOL_CLIENT"])
     
    #################################################################
    ##################      Server Role Settings      ###############
    #################################################################
    debugPrint(debugStatus,'Debug:Loading TRP server')
    global trspMenuServer
    trspMenuServer = globalsettings.createBooleanSymbol('SS_TRSP_BOOL_SERVER', serviceConfig)
    trspMenuServer.setLabel('Enable Server Role')
    trspMenuServer.setDefaultValue(False)
    # trspMenuServer.setDependencies(trspServerConfig, ["SS_TRSP_BOOL_SERVER"])

def destroyComponent(bletrpConfigComp):
    TrspProfile = Database.getComponentByID("PROFILE_TRSP")
    if (TrspProfile != None): 
        TrspProfile.getSymbolByID('TRSP_BOOL_CLIENT').setReadOnly(False)
        TrspProfile.getSymbolByID('TRSP_BOOL_SERVER').setReadOnly(False)
        

def finalizeComponent(bletrpConfigComp):
    fn = "finalizeComponent"
    debugPrint(debugStatus,'FInalising')
    try:       
        TrspProfile = Database.getComponentByID("PROFILE_TRSP")
        if (TrspProfile != None):
            debugPrint(debugStatus,'**TRP BLE: TRSP getting default value*^')
            trspClient = TrspProfile.getSymbolByID('TRSP_BOOL_CLIENT')
            clientValue = trspClient.getValue()
            print('**TRP BLE: Default clientValue:',clientValue)
            # readOnlyEnable.setReadOnly(True)
            trspServer = TrspProfile.getSymbolByID('TRSP_BOOL_SERVER')
            serverValue = trspServer.getValue()
            print('**TRP BLE: Default serverValue:',serverValue)

            if not trspClient.getReadOnly():
                # print('**TRP BLE: Setting value client readonly false:')
                trspClient.setReadOnly(True)
            if not trspServer.getReadOnly():    
                # print('**TRP BLE: Setting value server readonly false:')
                trspServer.setReadOnly(True)

            global trspMenuClient
            global trspMenuServer

            trspMenuClient.setDependencies(trspClientConfig, ["SS_TRSP_BOOL_CLIENT"])
            trspMenuServer.setDependencies(trspServerConfig, ["SS_TRSP_BOOL_SERVER"])

            print('**TRP BLE: Setting value a:',clientValue)
            if clientValue:
                trspMenuClient.setValue(clientValue)
            if serverValue: 
                trspMenuServer.setValue(serverValue)





            if clientValue:
                wlsHandlerTrspcSourceFile.setEnabled(True)
                wlsHandlerTrspcHeaderFile.setEnabled(True)
                wlsCallbackTrspcSourceFile.setEnabled(True)
                wlsCallbackTrspcHeaderFile.setEnabled(True)
            else:
                wlsHandlerTrspcSourceFile.setEnabled(False)
                wlsHandlerTrspcHeaderFile.setEnabled(False)
                wlsCallbackTrspcSourceFile.setEnabled(False)
                wlsCallbackTrspcHeaderFile.setEnabled(False)

            if serverValue:
                wlsHandlerTrspsSourceFile.setEnabled(True)
                wlsHandlerTrspsHeaderFile.setEnabled(True)
                wlsCallbackTrspsSourceFile.setEnabled(True)
                wlsCallbackTrspsHeaderFile.setEnabled(True)
            else:
                wlsHandlerTrspsSourceFile.setEnabled(False)
                wlsHandlerTrspsHeaderFile.setEnabled(False)
                wlsCallbackTrspsSourceFile.setEnabled(False)
                wlsCallbackTrspsHeaderFile.setEnabled(False)

            trspService = Database.getComponentByID("SERVICE_TRS")
            if(trspService != None):
                debugPrint(debugStatus,'**TRP BLE: Connect dependencies*^')
                res = Database.connectDependencies([['PROFILE_TRSP', 'BLE_TRS_Dependency', 'SERVICE_TRS', 'BLE_TRS_Capability']])
            else:
                debugPrint(debugStatus,'**TRP BLE: Activate and Connect dependencies*^')
                Database.activateComponents(["SERVICE_TRS"],"__ROOTVIEW",False)
                res = Database.connectDependencies([['PROFILE_TRSP', 'BLE_TRS_Dependency', 'SERVICE_TRS', 'BLE_TRS_Capability']])

        else:
            debugPrint(debugStatus,'TRP BLE: NO PROFILE_TRSP COMP*^')
    except Exception as e:
        exc_type, exc_obj, exc_tb = sys.exc_info()
        print ("%s Error on line number : %s : %s" %(fn, exc_tb.tb_lineno, e))  



def instantiateComponent(bletrpConfigComp):
    global gsettings
    global clientValue
    global serverValue

    global trspClient
    global trspServer
    global trspProfile

    clientValue = 0
    serverValue = 0

    debugPrint(debugStatus,'Load Module: *****BLE TRP system service*****')

    configName = Variables.get('__CONFIGURATION_NAME')
    processor = Variables.get('__PROCESSOR')
    print('Config Name: {} processor: {}'.format(configName, processor))
    debugPrint(debugStatus,'Loading')
    print(Module.getPath())

    debugPrint(debugStatus,'**TRP BLE: calling components**')
    processor = Variables.get("__PROCESSOR")
    activeComponents = Database.getActiveComponentIDs()

    debugPrint(debugStatus,'**TRP BLE: calling components**')
    #'SERVICE_TRS' ## use if required
    requiredComponents = ['wlsbleconfig','PROFILE_TRSP']

    for r in requiredComponents:
        activeComponents = Database.getActiveComponentIDs()
        if r not in activeComponents:
            res = Database.activateComponents([r],"__ROOTVIEW",False)
    debugPrint(debugStatus,'**TRP BLE: Components activated**')

    # res = Database.activateComponents(["wlsbleconfig","PROFILE_TRSP"],"__ROOTVIEW",False)
    # print('**TRP BLE: activate comp result*^',res)
    # res = Database.connectDependencies([['PROFILE_TRSP', 'BLE_TRS_Dependency', 'SERVICE_TRS', 'BLE_TRS_Capability']])
    # res = Database.connectDependencies([['PROFILE_TRSP', 'SERVICE_TRS']])

    gsettings = bletrpConfigComp
    loadconfigmodule(gsettings)

   
    
    
    # TrspProfile = Database.getComponentByID("PROFILE_TRSP")
    # if (TrspProfile != None):
    #     print('**TRP BLE: TRSP getting default value*^')
    #     trspClient = TrspProfile.getSymbolByID('TRSP_BOOL_CLIENT')
    #     clientValue = trspClient.getValue()
    #     print('**TRP BLE: Default clientValue:',clientValue)
    #     # readOnlyEnable.setReadOnly(True)
    #     trspServer = TrspProfile.getSymbolByID('TRSP_BOOL_SERVER')
    #     serverValue = trspServer.getValue()
    #     print('**TRP BLE: Default serverValue:',serverValue)
    #     gsettings = bletrpConfigComp
    #     loadconfigmodule(gsettings)
    #     trspClient.setReadOnly(True)
    #     trspServer.setReadOnly(True)

        #################################################################
        ##################        Add Source File         ###############
        #################################################################

    # BLE TRSPS handler
    global wlsHandlerTrspsSourceFile

    wlsHandlerTrspsSourceFile = bletrpConfigComp.createFileSymbol(None, None)
    source_path = "services/ble/trsp/src/templates/trsps/app_trsps_handler.c.ftl"
    print("Attempting to set source path: " + source_path)
    wlsHandlerTrspsSourceFile.setSourcePath(source_path)
    wlsHandlerTrspsSourceFile.setOutputName("app_trsps_handler.c")
    wlsHandlerTrspsSourceFile.setDestPath('../../app_ble/handlers')
    wlsHandlerTrspsSourceFile.setProjectPath('app_ble/handlers')
    wlsHandlerTrspsSourceFile.setType('SOURCE')
    wlsHandlerTrspsSourceFile.setMarkup(True)
    wlsHandlerTrspsSourceFile.setOverwrite(True)
    wlsHandlerTrspsSourceFile.setEnabled(False)
    wlsHandlerTrspsSourceFile.setDependencies(trspshandlerFilesCallback, [ "SS_TRSP_BOOL_SERVER"])

    global wlsHandlerTrspsHeaderFile
    wlsHandlerTrspsHeaderFile = bletrpConfigComp.createFileSymbol(None, None)
    wlsHandlerTrspsHeaderFile.setSourcePath("services/ble/trsp/src/templates/trsps/app_trsps_handler.h.ftl")
    wlsHandlerTrspsHeaderFile.setOutputName("app_trsps_handler.h")
    wlsHandlerTrspsHeaderFile.setDestPath('../../app_ble/handlers')
    wlsHandlerTrspsHeaderFile.setProjectPath('app_ble/handlers')
    wlsHandlerTrspsHeaderFile.setType('HEADER')
    wlsHandlerTrspsHeaderFile.setMarkup(True)
    wlsHandlerTrspsHeaderFile.setOverwrite(True)
    wlsHandlerTrspsHeaderFile.setEnabled(False)
    wlsHandlerTrspsHeaderFile.setDependencies(trspshandlerFilesCallback, ["SS_TRSP_BOOL_SERVER"])


    # BLE TRSPS handler callback
    global wlsCallbackTrspsSourceFile
    wlsCallbackTrspsSourceFile = bletrpConfigComp.createFileSymbol(None, None)
    wlsCallbackTrspsSourceFile.setSourcePath("services/ble/trsp/src/templates/trsps/app_trsps_callbacks.c.ftl")
    wlsCallbackTrspsSourceFile.setOutputName("app_trsps_callbacks.c")
    wlsCallbackTrspsSourceFile.setDestPath('../../app_ble')
    wlsCallbackTrspsSourceFile.setProjectPath('app_ble')
    wlsCallbackTrspsSourceFile.setType('SOURCE')
    wlsCallbackTrspsSourceFile.setMarkup(True)
    wlsCallbackTrspsSourceFile.setOverwrite(True)
    wlsCallbackTrspsSourceFile.setEnabled(False)
    wlsCallbackTrspsSourceFile.setDependencies(trspshandlerFilesCallback, ["SS_TRSP_BOOL_SERVER"])


    global wlsCallbackTrspsHeaderFile
    wlsCallbackTrspsHeaderFile = bletrpConfigComp.createFileSymbol(None, None)
    wlsCallbackTrspsHeaderFile.setSourcePath("services/ble/trsp/src/templates/trsps/app_trsps_callbacks.h.ftl")
    wlsCallbackTrspsHeaderFile.setOutputName("app_trsps_callbacks.h")
    wlsCallbackTrspsHeaderFile.setDestPath('../../app_ble')
    wlsCallbackTrspsHeaderFile.setProjectPath('app_ble')
    wlsCallbackTrspsHeaderFile.setType('HEADER')
    wlsCallbackTrspsHeaderFile.setMarkup(True)
    wlsCallbackTrspsHeaderFile.setOverwrite(True)
    wlsCallbackTrspsHeaderFile.setEnabled(False)
    wlsCallbackTrspsHeaderFile.setDependencies(trspshandlerFilesCallback,["SS_TRSP_BOOL_SERVER"])

    # BLE TRSPC handler

    global wlsHandlerTrspcSourceFile
    wlsHandlerTrspcSourceFile = bletrpConfigComp.createFileSymbol(None, None)
    wlsHandlerTrspcSourceFile.setSourcePath("services/ble/trsp/src/templates/trspc/app_trspc_handler.c.ftl")
    wlsHandlerTrspcSourceFile.setOutputName("app_trspc_handler.c")
    wlsHandlerTrspcSourceFile.setDestPath('../../app_ble/handlers')
    wlsHandlerTrspcSourceFile.setProjectPath('app_ble/handlers')
    wlsHandlerTrspcSourceFile.setType('SOURCE')
    wlsHandlerTrspcSourceFile.setMarkup(True)
    wlsHandlerTrspcSourceFile.setOverwrite(True)
    wlsHandlerTrspcSourceFile.setEnabled(False)
    wlsHandlerTrspcSourceFile.setDependencies(trspchandlerFilesCallback,["SS_TRSP_BOOL_CLIENT"])


    global wlsHandlerTrspcHeaderFile
    wlsHandlerTrspcHeaderFile = bletrpConfigComp.createFileSymbol(None, None)
    wlsHandlerTrspcHeaderFile.setSourcePath("services/ble/trsp/src/templates/trspc/app_trspc_handler.h.ftl")
    wlsHandlerTrspcHeaderFile.setOutputName("app_trspc_handler.h")
    wlsHandlerTrspcHeaderFile.setDestPath('../../app_ble/handlers')
    wlsHandlerTrspcHeaderFile.setProjectPath('app_ble/handlers')
    wlsHandlerTrspcHeaderFile.setType('HEADER')
    wlsHandlerTrspcHeaderFile.setMarkup(True)
    wlsHandlerTrspcHeaderFile.setOverwrite(True)
    wlsHandlerTrspcHeaderFile.setEnabled(False)
    wlsHandlerTrspcHeaderFile.setDependencies(trspchandlerFilesCallback,["SS_TRSP_BOOL_CLIENT"])

    #BLE TRSPC callback
    global wlsCallbackTrspcSourceFile
    wlsCallbackTrspcSourceFile = bletrpConfigComp.createFileSymbol(None, None)
    wlsCallbackTrspcSourceFile.setSourcePath("services/ble/trsp/src/templates/trspc/app_trspc_callbacks.c.ftl")
    wlsCallbackTrspcSourceFile.setOutputName("app_trspc_callbacks.c")
    wlsCallbackTrspcSourceFile.setDestPath('../../app_ble')
    wlsCallbackTrspcSourceFile.setProjectPath('app_ble')
    wlsCallbackTrspcSourceFile.setType('SOURCE')
    wlsCallbackTrspcSourceFile.setMarkup(True)
    wlsCallbackTrspcSourceFile.setOverwrite(True)
    wlsCallbackTrspcSourceFile.setEnabled(False)
    wlsCallbackTrspcSourceFile.setDependencies(trspchandlerFilesCallback,["SS_TRSP_BOOL_CLIENT"])

    global wlsCallbackTrspcHeaderFile
    wlsCallbackTrspcHeaderFile = bletrpConfigComp.createFileSymbol(None, None)
    wlsCallbackTrspcHeaderFile.setSourcePath("services/ble/trsp/src/templates/trspc/app_trspc_callbacks.h.ftl")
    wlsCallbackTrspcHeaderFile.setOutputName("app_trspc_callbacks.h")
    wlsCallbackTrspcHeaderFile.setDestPath('../../app_ble')
    wlsCallbackTrspcHeaderFile.setProjectPath('app_ble')
    wlsCallbackTrspcHeaderFile.setType('HEADER')
    wlsCallbackTrspcHeaderFile.setMarkup(True)
    wlsCallbackTrspcHeaderFile.setOverwrite(True)
    wlsCallbackTrspcHeaderFile.setEnabled(False)
    wlsCallbackTrspcHeaderFile.setDependencies(trspchandlerFilesCallback,["SS_TRSP_BOOL_CLIENT"])







    


    debugPrint(debugStatus,'#############Trp end of component ######################')

