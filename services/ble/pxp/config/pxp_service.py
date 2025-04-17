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
 
global connectDependenciesLlsService, connectDependenciesIasService, connectDependenciesTpsService    

connectDependenciesLlsService = ['PROFILE_PXP', 'BLE_LLS_Dependency', 'SERVICE_LLS', 'BLE_LLS_Capability']
connectDependenciesIasService = ['PROFILE_PXP', 'BLE_IAS_Dependency', 'SERVICE_IAS', 'BLE_IAS_Capability']
connectDependenciesTpsService = ['PROFILE_PXP', 'BLE_TPS_Dependency', 'SERVICE_TPS', 'BLE_TPS_Capability']

global debugStatus
debugStatus = False

def debugPrint(printStatus, message):
    if printStatus:
        print(message)
 

######################end glonal settings####################

def pxpConfigBleStack():

    if((pxpMenuServer.getValue()== False) and (pxpMenuClient.getValue()== False)):
        debugPrint(debugStatus,'PXP BLE: config ble client server false')
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
    elif((pxpMenuServer.getValue()== True) and (pxpMenuClient.getValue()== True)):
        debugPrint(debugStatus,'PXP BLE: config ble client server True')
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
    elif((pxpMenuServer.getValue()== True) and (pxpMenuClient.getValue()== False)):
        debugPrint(debugStatus,'PXP BLE: config ble client False server True')
        if (Database.getSymbolValue("BLE_STACK_LIB", "BLE_BOOL_GATT_CLIENT") != False):
            Database.setSymbolValue("BLE_STACK_LIB", "BOOL_GCM_DD_INIT_DISC_IN_PER", False)
            Database.setSymbolValue("BLE_STACK_LIB", "BOOL_GCM_DD_INIT_DISC_IN_CNTRL", False)
            Database.setSymbolValue("BLE_STACK_LIB", "BLE_BOOL_GATT_CLIENT", False)
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
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_ADV_DATA_UDD_EN") != True):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADV_DATA_UDD_EN", True)

        Database.setSymbolValue("BLE_STACK_LIB", "GAP_DEV_NAME", "PXPR")
        Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADV_DATA_LOCAL_NAME", "PXPR")
        Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADV_DATA_UDD", "03030318")  

    elif((pxpMenuServer.getValue()== False) and (pxpMenuClient.getValue()== True)):
        debugPrint(debugStatus,'PXP BLE: config ble client True server False')
        if (Database.getSymbolValue("BLE_STACK_LIB", "BLE_BOOL_GATT_CLIENT") != True):
            Database.setSymbolValue("BLE_STACK_LIB", "BLE_BOOL_GATT_CLIENT", True)
            Database.setSymbolValue("BLE_STACK_LIB", "BOOL_GCM_DD_INIT_DISC_IN_CNTRL", True)

        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_SCAN") != True):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_SCAN", True)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_CENTRAL") != True):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_CENTRAL", True)

        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_ADVERTISING") != False):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADVERTISING", False)
        if (Database.getSymbolValue("BLE_STACK_LIB", "GAP_PERIPHERAL") != False):
            Database.setSymbolValue("BLE_STACK_LIB", "GAP_PERIPHERAL", False)
        
        Database.setSymbolValue("BLE_STACK_LIB", "GAP_DEV_NAME", "PXPM")




#client->monitor,server->reporter
def pxpMonitorConfig(symbol, event):
    debugPrint(debugStatus,'PXP BLE: monitor/client triggered')
    pxpConfigBleStack()       
    if event["id"] == "SS_PXP_BOOL_CLIENT":
        Database.setSymbolValue("PROFILE_PXP", "PXP_BOOL_CLIENT", event["value"])
        llsService = Database.getComponentByID("SERVICE_LLS") 
        if llsService == None and event["value"]:
            Database.activateComponents(["SERVICE_LLS"],"__ROOTVIEW",False)
            Database.connectDependencies([connectDependenciesLlsService])                      
    if event["id"] == "SS_PXP_CLIENT_IAS":
        Database.setSymbolValue("PROFILE_PXP", "PXP_CLIENT_IAS", event["value"])
        iasService = Database.getComponentByID("SERVICE_IAS") 
        if iasService == None and event["value"]:
            Database.activateComponents(["SERVICE_IAS"],"__ROOTVIEW",False)
            Database.connectDependencies([connectDependenciesIasService])        
    if event["id"] == "SS_PXP_CLIENT_TPS":
        Database.setSymbolValue("PROFILE_PXP", "PXP_CLIENT_TPS", event["value"])
        tpsService = Database.getComponentByID("SERVICE_TPS")
        if tpsService == None and event["value"]:
            Database.activateComponents(["SERVICE_TPS"],"__ROOTVIEW",False)
            Database.connectDependencies([connectDependenciesTpsService])

        

def pxpReporterConfig(symbol, event):
    debugPrint(debugStatus,'PXP BLE: reporter/server triggered')
    pxpConfigBleStack()
    if event["id"] == "SS_PXP_BOOL_SERVER":
        Database.setSymbolValue("PROFILE_PXP", "PXP_BOOL_SERVER", event["value"]) 
        if not event["value"] and  pxpMenuClient.getValue():
            Database.activateComponents(["SERVICE_LLS"],"__ROOTVIEW",False)
            Database.connectDependencies([connectDependenciesLlsService])

    if event["id"] == "SS_PXP_SERVER_IAS":
        Database.setSymbolValue("PROFILE_PXP", "PXP_SERVER_IAS", event["value"])
        if not event["value"] and  pxpMenuClient.getValue():
            Database.activateComponents(["SERVICE_IAS"],"__ROOTVIEW",False)
            Database.connectDependencies([connectDependenciesIasService])
    if event["id"] == "SS_PXP_SERVER_TPS":
        Database.setSymbolValue("PROFILE_PXP", "PXP_SERVER_TPS", event["value"])
        if not event["value"] and  pxpMenuClient.getValue():
            Database.activateComponents(["SERVICE_TPS"],"__ROOTVIEW",False)
            Database.connectDependencies([connectDependenciesTpsService])


        
def blePxpmFileEnable(symbol, event):    
    symbol.setEnabled(event["value"])

def blePxprFileEnable(symbol, event):    
    symbol.setEnabled(event["value"])

   


def setUIElements(globalsettings):

    fn = "setUIElements()"
    try:     
        # Config settings
        # menu symbol
        
        pxpServiceSetting = globalsettings.createMenuSymbol('PXP_SERVICE_CONFIG', None)
        pxpServiceSetting.setLabel('Service configuration')
        pxpServiceSetting.setVisible(True)
        pxpServiceSetting.setDescription("PXP config settings")
        

        #Enable app code
        
        booleanappcodebox = globalsettings.createBooleanSymbol('booleanappcode', None)
        booleanappcodebox.setLabel('Enable App Code Generation')
        booleanappcodebox.setDescription('Enable App Code Generation for generating sample code')
        booleanappcodebox.setDefaultValue(True)
        booleanappcodebox.setVisible(True)


        #################################################################
        ##################      Client Role Settings      ###############
        #################################################################

        # PXP clientconfig
        
        global pxpMenuClient
        
        pxpMenuClient = globalsettings.createBooleanSymbol('SS_PXP_BOOL_CLIENT', pxpServiceSetting)
        pxpMenuClient.setLabel('Enable Monitor Role')
        pxpMenuClient.setDefaultValue(False)
        pxpMenuClient.setDependencies(pxpMonitorConfig, ["SS_PXP_BOOL_CLIENT"])

        # Immediate Alert Service Enable
        global pxpmIas
        pxpmIas = globalsettings.createBooleanSymbol('SS_PXP_CLIENT_IAS', pxpMenuClient)
        pxpmIas.setLabel('Support Immediate Alert Service')
        pxpmIas.setDescription('Support Immediate Alert Service')
        pxpmIas.setDefaultValue(False)
        pxpmIas.setVisible(True)
        pxpmIas.setDependencies(pxpMonitorConfig, ["SS_PXP_CLIENT_IAS"])

        # TX Power Service Enable
        global pxpmTps
        pxpmTps = globalsettings.createBooleanSymbol('SS_PXP_CLIENT_TPS', pxpMenuClient)
        pxpmTps.setLabel('Support TX Power Service')
        pxpmTps.setDescription('Support TX Power Service')
        pxpmTps.setDefaultValue(False)
        pxpmTps.setVisible(True)
        pxpmTps.setDependencies(pxpMonitorConfig, ["SS_PXP_CLIENT_TPS"])

        
        #################################################################
        ##################      Server Role Settings      ###############
        #################################################################

        
        global pxpMenuServer
        pxpMenuServer = globalsettings.createBooleanSymbol('SS_PXP_BOOL_SERVER', pxpServiceSetting)
        pxpMenuServer.setLabel('Enable Reporter Role')
        pxpMenuServer.setDefaultValue(False)
        pxpMenuServer.setDependencies(pxpReporterConfig, ["SS_PXP_BOOL_SERVER"])

        
        # Immediate Alert Service Enable
        global pxprIas
        pxprIas = globalsettings.createBooleanSymbol('SS_PXP_SERVER_IAS', pxpMenuServer)
        pxprIas.setLabel('Enable Immediate Alert Service')
        pxprIas.setDescription('Enable Immediate Alert Service')
        pxprIas.setDefaultValue(False)
        pxprIas.setVisible(True)
        pxprIas.setDependencies(pxpReporterConfig, ["SS_PXP_SERVER_IAS"])

        
        # TX Power Service Enable
        global pxprTps
        pxprTps = globalsettings.createBooleanSymbol('SS_PXP_SERVER_TPS', pxpMenuServer)
        pxprTps.setLabel('Enable TX Power Service')
        pxprTps.setDescription('Enable TX Power Service')
        pxprTps.setDefaultValue(False)
        pxprTps.setVisible(True)
        pxprTps.setDependencies(pxpReporterConfig, ["SS_PXP_SERVER_TPS"])

    except Exception as e:
        exc_type, exc_obj, exc_tb = sys.exc_info()
        print ("%s Error on line number : %s : %s" %(fn, exc_tb.tb_lineno, e))



def instantiateComponent(blePxpConfigComp):
    global gsettings
    global clientValue
    global serverValue
    
    global enMonitor, monitorSprtIAS, monitorSprttTXPowerService
    global enReporter, reporterIAS, reporterTXPowerService

    global pxpProfile


    print('Load Module: *****#BLE PXP system service#*****')

    configName = Variables.get('__CONFIGURATION_NAME')
    processor = Variables.get('__PROCESSOR')
    print('Config Name: {} processor: {}'.format(configName, processor))
    print('Loading')
    print(Module.getPath())

    
    processor = Variables.get("__PROCESSOR")
    activeComponents = Database.getActiveComponentIDs()
    # print('**PXP BLE: calling components **')
    requiredComponents = ['wlsbleconfig','PROFILE_PXP']

    for r in requiredComponents:
        activeComponents = Database.getActiveComponentIDs()
        if r not in activeComponents:
            res = Database.activateComponents([r],"__ROOTVIEW",False)


    gsettings = blePxpConfigComp
    setUIElements(gsettings)

    global pxpmCbHeaderFile
    pxpmCbHeaderFile = blePxpConfigComp.createFileSymbol(None, None)
    pxpmCbHeaderFile.setSourcePath('services/ble/pxp/src/templates/pxpm/app_pxpm_callbacks.h.ftl')
    pxpmCbHeaderFile.setOutputName('app_pxpm_callbacks.h')
    pxpmCbHeaderFile.setOverwrite(True)
    pxpmCbHeaderFile.setDestPath('../../app_ble')
    pxpmCbHeaderFile.setProjectPath('app_ble')
    pxpmCbHeaderFile.setType('HEADER')
    pxpmCbHeaderFile.setEnabled(False)
    pxpmCbHeaderFile.setMarkup(True)
    pxpmCbHeaderFile.setDependencies(blePxpmFileEnable, ["SS_PXP_BOOL_CLIENT"])

    # global pxpmCbSourceFile
    pxpmCbSourceFile = blePxpConfigComp.createFileSymbol(None, None)
    pxpmCbSourceFile.setSourcePath('services/ble/pxp/src/templates/pxpm/app_pxpm_callbacks.c.ftl')
    pxpmCbSourceFile.setOutputName('app_pxpm_callbacks.c')
    pxpmCbSourceFile.setOverwrite(True)
    pxpmCbSourceFile.setDestPath('../../app_ble')
    pxpmCbSourceFile.setProjectPath('app_ble')
    pxpmCbSourceFile.setType('SOURCE')
    pxpmCbSourceFile.setEnabled(False)
    pxpmCbSourceFile.setMarkup(True)
    pxpmCbSourceFile.setDependencies(blePxpmFileEnable, ["SS_PXP_BOOL_CLIENT"])

    global pxpmHandlerHeaderFile
    pxpmHandlerHeaderFile = blePxpConfigComp.createFileSymbol(None, None)
    pxpmHandlerHeaderFile.setSourcePath('services/ble/pxp/src/templates/pxpm/app_pxpm_handler.h.ftl')
    pxpmHandlerHeaderFile.setOutputName('app_pxpm_handler.h')
    pxpmHandlerHeaderFile.setOverwrite(True)
    pxpmHandlerHeaderFile.setDestPath('../../app_ble/handlers')
    pxpmHandlerHeaderFile.setProjectPath('app_ble/handlers')
    pxpmHandlerHeaderFile.setType('HEADER')
    pxpmHandlerHeaderFile.setEnabled(False)
    pxpmHandlerHeaderFile.setMarkup(True)
    pxpmHandlerHeaderFile.setDependencies(blePxpmFileEnable, ["SS_PXP_BOOL_CLIENT"])

    global pxpmHandlerSourceFile
    pxpmHandlerSourceFile = blePxpConfigComp.createFileSymbol(None, None)
    pxpmHandlerSourceFile.setSourcePath('services/ble/pxp/src/templates/pxpm/app_pxpm_handler.c.ftl')
    pxpmHandlerSourceFile.setOutputName('app_pxpm_handler.c')
    pxpmHandlerSourceFile.setOverwrite(True)
    pxpmHandlerSourceFile.setDestPath('../../app_ble/handlers')
    pxpmHandlerSourceFile.setProjectPath('app_ble/handlers')
    pxpmHandlerSourceFile.setType('SOURCE')
    pxpmHandlerSourceFile.setEnabled(False)
    pxpmHandlerSourceFile.setMarkup(True)
    pxpmHandlerSourceFile.setDependencies(blePxpmFileEnable, ["SS_PXP_BOOL_CLIENT"])

    global pxprCbHeaderFile
    pxprCbHeaderFile = blePxpConfigComp.createFileSymbol(None, None)
    pxprCbHeaderFile.setSourcePath('services/ble/pxp/src/templates/pxpr/app_pxpr_callbacks.h.ftl')
    pxprCbHeaderFile.setOutputName('app_pxpr_callbacks.h')
    pxprCbHeaderFile.setOverwrite(True)
    pxprCbHeaderFile.setDestPath('../../app_ble')
    pxprCbHeaderFile.setProjectPath('app_ble')
    pxprCbHeaderFile.setType('HEADER')
    pxprCbHeaderFile.setEnabled(False)
    pxprCbHeaderFile.setMarkup(True)
    pxprCbHeaderFile.setDependencies(blePxprFileEnable, ["SS_PXP_BOOL_SERVER"])

    # global pxpmCbSourceFile
    pxprCbSourceFile = blePxpConfigComp.createFileSymbol(None, None)
    pxprCbSourceFile.setSourcePath('services/ble/pxp/src/templates/pxpr/app_pxpr_callbacks.c.ftl')
    pxprCbSourceFile.setOutputName('app_pxpr_callbacks.c')
    pxprCbSourceFile.setOverwrite(True)
    pxprCbSourceFile.setDestPath('../../app_ble')
    pxprCbSourceFile.setProjectPath('app_ble')
    pxprCbSourceFile.setType('SOURCE')
    pxprCbSourceFile.setEnabled(False)
    pxprCbSourceFile.setMarkup(True)
    pxprCbSourceFile.setDependencies(blePxprFileEnable, ["SS_PXP_BOOL_SERVER"])

    global pxprHandlerHeaderFile
    pxprHandlerHeaderFile = blePxpConfigComp.createFileSymbol(None, None)
    pxprHandlerHeaderFile.setSourcePath('services/ble/pxp/src/templates/pxpr/app_pxpr_handler.h.ftl')
    pxprHandlerHeaderFile.setOutputName('app_pxpr_handler.h')
    pxprHandlerHeaderFile.setOverwrite(True)
    pxprHandlerHeaderFile.setDestPath('../../app_ble/handlers')
    pxprHandlerHeaderFile.setProjectPath('app_ble/handlers')
    pxprHandlerHeaderFile.setType('HEADER')
    pxprHandlerHeaderFile.setEnabled(False)
    pxprHandlerHeaderFile.setMarkup(True)
    pxprHandlerHeaderFile.setDependencies(blePxprFileEnable, ["SS_PXP_BOOL_SERVER"])

    global pxprHandlerSourceFile
    pxprHandlerSourceFile = blePxpConfigComp.createFileSymbol(None, None)
    pxprHandlerSourceFile.setSourcePath('services/ble/pxp/src/templates/pxpr/app_pxpr_handler.c.ftl')
    pxprHandlerSourceFile.setOutputName('app_pxpr_handler.c')
    pxprHandlerSourceFile.setOverwrite(True)
    pxprHandlerSourceFile.setDestPath('../../app_ble/handlers')
    pxprHandlerSourceFile.setProjectPath('app_ble/handlers')
    pxprHandlerSourceFile.setType('SOURCE')
    pxprHandlerSourceFile.setEnabled(False)
    pxprHandlerSourceFile.setMarkup(True)
    pxprHandlerSourceFile.setDependencies(blePxprFileEnable, ["SS_PXP_BOOL_SERVER"])



    pxpKeyPressConf = blePxpConfigComp.createFileSymbol('APP_PXP_LONG_KEY_PRESS', None)
    pxpKeyPressConf.setType("STRING")
    pxpKeyPressConf.setOutputName("wlsbleconfig.WLS_BLE_APP_KEY_MSG_LONG_PRESS")
    pxpKeyPressConf.setSourcePath("services/ble/pxp/src/templates/add_pxp_long_keypress.c.ftl")
    pxpKeyPressConf.setMarkup(True)


    

    print('#############Pxp end of component ######################')


def loadServices():
    serviceIds = ['SERVICE_LLS','SERVICE_IAS','SERVICE_TPS']
    connectDependenciesServices = [connectDependenciesLlsService,connectDependenciesIasService,connectDependenciesTpsService]

    for r in serviceIds:
        activeComponents = Database.getActiveComponentIDs()
        if r not in activeComponents:
            res = Database.activateComponents([r],"__ROOTVIEW",False)
    
    # print("Connecting pxp dependecies\r\n")
    res = Database.connectDependencies(connectDependenciesServices)
        



        


def finalizeComponent(blePxpConfigComp):
    fn = "finalizeComponent()"
    pxpProfile = Database.getComponentByID("PROFILE_PXP")
    if (pxpProfile != None):

        ##########################################################################
        ##################      Default Client value Settings      ###############
        ##########################################################################

        clientValue = Database.getSymbolValue("PROFILE_PXP", "PXP_BOOL_CLIENT")
        monitorSprtIAS = Database.getSymbolValue("PROFILE_PXP", "PXP_CLIENT_IAS")
        monitorSprttTXPowerService = Database.getSymbolValue("PROFILE_PXP", "PXP_CLIENT_TPS")

        ##########################################################################
        ##################      Default Server Value Settings      ###############
        ##########################################################################

        serverValue = Database.getSymbolValue("PROFILE_PXP", "PXP_BOOL_SERVER")
        reporterIAS = Database.getSymbolValue("PROFILE_PXP", "PXP_SERVER_IAS")
        reporterTXPowerService = Database.getSymbolValue("PROFILE_PXP", "PXP_SERVER_TPS")

        #########################################################################
        #################              Settings values            ###############
        #########################################################################


        pxpMenuClient.setValue(clientValue)
        pxpmIas.setValue(monitorSprtIAS)
        pxpmTps.setValue(monitorSprttTXPowerService)

        pxpMenuServer.setValue(serverValue)
        pxprIas.setValue(reporterIAS)
        pxprTps.setValue(reporterTXPowerService)


        #########################################################################
        #################             symbol disabling         ###############
        #########################################################################

        profileClientIds = ['PXP_BOOL_CLIENT','PXP_CLIENT_IAS','PXP_CLIENT_TPS']
        profileServerIds = ['PXP_BOOL_SERVER','PXP_SERVER_IAS','PXP_SERVER_TPS']

        # symIDList = Database.getComponentSymbolIDs("myComponent")
        for r in profileClientIds:        
            enMonitor = pxpProfile.getSymbolByID(r)
            enMonitor.setReadOnly(True)
        for r in profileServerIds:
            enReporter = pxpProfile.getSymbolByID(r)    
            enReporter.setReadOnly(True)
        loadServices()
             
    else:
        print('**PXP BLE: PXP not available')
    print('Finalize Component')

def destroyComponent(blePxpConfigComp):
    fn = "destroyComponent()"
    pxpProfile = Database.getComponentByID("PROFILE_PXP")
    if (pxpProfile != None):
        try:
            profileClientIds = ['PXP_BOOL_CLIENT','PXP_CLIENT_IAS','PXP_CLIENT_TPS']
            profileServerIds = ['PXP_BOOL_SERVER','PXP_SERVER_IAS','PXP_SERVER_TPS']

            # symIDList = Database.getComponentSymbolIDs("myComponent")
            for r in profileClientIds:        
                enMonitor = pxpProfile.getSymbolByID(r)
                enMonitor.setReadOnly(False)
            for r in profileServerIds:
                enReporter = pxpProfile.getSymbolByID(r)    
                enReporter.setReadOnly(False)
        except Exception as e:
            exc_type, exc_obj, exc_tb = sys.exc_info()
            print ("%s Error on line number : %s : %s" %(fn, exc_tb.tb_lineno, e))
    else:
        print('**PXP BLE: PXP not available')     
    print('**PXP BLE: DestroyComponent') 