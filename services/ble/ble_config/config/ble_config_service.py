import string
import sys
from os import path
import glob
# from numberconv import addnumber
##############Global variables##################################

wirelessblepic32cx_bz2_family = {'WBZ451','WBZ450'}

wirelessblepic32cx_bz3_family = {'WBZ351','WBZ350'}


# Added only less devices to pic32m family for testing
attachedpic32m_family = {'PIC32MK0128MCA028',
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
#global configsetting,devicefamily,ppty1checkbox,ppty1integer 
global gsettings
global bleConfigEnableErrMsg
global bleConfigDeviceTypeFamily
global devFamily

######################end glonal settings####################

def getDeviceFamily():
    #processor = Variables.get("__PROCESSOR")

    if ("PIC32CX" in Variables.get("__PROCESSOR")) or ("WBZ" in Variables.get("__PROCESSOR")) or ("PIC32WM" in Variables.get("__PROCESSOR")):
        if "BZ2" in Variables.get("__PROCESSOR") or "WBZ45" in Variables.get("__PROCESSOR"):
            return "pic32cx_bz2_family"
        elif "BZ3" in Variables.get("__PROCESSOR") or "WBZ35" in Variables.get("__PROCESSOR"):
            return "pic32cx_bz3_family"
        else:
            return "Not Support"

def bleConfigHandleBoardChange(symbol, event):
    print("bleConfigHandleBoardChange...")
    if (event["value"] != "CUSTOM-BOARD"):
        shdBoardComp = "mainBoard_" + event["value"].replace("-", "_")
        print(shdBoardComp)
        Database.activateComponents([shdBoardComp],"__ROOTVIEW",False)
        
        processor = Variables.get("__PROCESSOR")
        if 'WBZ451' in processor or 'WBZ351' in processor:
            print("Standalone MCU device type")
        else:    
            # Set request message to configure the SHD
            Msg = "*Configure " + event["value"] + " . Attached under development."
            bleConfigEnableErrMsg.setLabel(Msg)
            bleConfigEnableErrMsg.setVisible(True)
                
    else:
        processor = Variables.get("__PROCESSOR")
        if 'WBZ451' in processor or 'WBZ351' in processor:
            print("Standalone MCU device type")
        else:
            bleConfigDeviceTypeFamily.setReadOnly(False)
            bleConfigDeviceTypeFamily.setValue("NONE")

def loadconfigmodule(globalsettings):
    
    global devFamily
    ble_helpkeyword = "mcc_h3_wireless_ble_config_app_service_configurations"
    configName = Variables.get('__CONFIGURATION_NAME')
    processor = Variables.get('__PROCESSOR')
    standalone = 0 
    attached = 1
    connectiontype = standalone
    devFamily = getDeviceFamily()
    print('Config Name: {} processor: {}'.format(configName, processor))

    appDeviceSelect = globalsettings.createStringSymbol('DEVICE_SELECT', None)
    appDeviceSelect.setVisible(False)
    appDeviceSelect.setReadOnly(True)
    appDeviceSelect.setDefaultValue(devFamily)


    # Config settings
    bleUsageConfigSetting = globalsettings.createMenuSymbol('WLS_BLE_USAGE_CONFIG', None)
    bleUsageConfigSetting.setLabel('Usage configuration')
    bleUsageConfigSetting.setVisible(True)
    bleUsageConfigSetting.setDescription("WME config settings")

    # Fetch SHD boards for the supported processor.
    processor = Variables.get("__PROCESSOR")
    shdPath = Variables.get("__MODULE_ROOT") + "/../shd"
    boardPath = path.join(shdPath, 'boards')
    
    import yaml
    mainBoardCompatibleList = []
    mainBoardFileList = glob.glob(path.join(boardPath, '*.yml'))
    for mainBoardFile in mainBoardFileList:
        try:
            mainBoardYaml = yaml.safe_load(open(mainBoardFile, 'r'))
            if mainBoardYaml['processor']['name'] == processor:
                mainBoardCompatibleList.append(mainBoardYaml['name'].upper())
        except Exception as error:
            print("SHD >> ERROR loading main board : {}".format(mainBoardFile))
            continue
    
    mainBoardCompatibleList.append("CUSTOM-BOARD")
                
    bleConfigBoard = globalsettings.createComboSymbol("WLS_BLE_CONFIG_BOARD", bleUsageConfigSetting, mainBoardCompatibleList)
    bleConfigBoard.setLabel("Select the target board")
    bleConfigBoard.setHelp(ble_helpkeyword)
    bleConfigBoard.setDefaultValue("CUSTOM-BOARD")
    bleConfigBoard.setDescription("Select the board for which the services are to be used. If its MCHP board the pin configurations are done automatically. For custom board the user has to take care of the pin configurations and other dependencies.")        
    bleConfigBoard.setDependencies(bleConfigHandleBoardChange, ["WLS_BLE_CONFIG_BOARD"])
    
    global bleConfigEnableErrMsg

    bleConfigEnableErrMsg = globalsettings.createCommentSymbol("BLE_WIFI_CONFIG_ERR", bleUsageConfigSetting)
    bleConfigEnableErrMsg.setLabel("**Placeholder for error display")
    bleConfigEnableErrMsg.setHelp(ble_helpkeyword)
    bleConfigEnableErrMsg.setVisible(False)

 
    if processor in wirelessblepic32cx_bz2_family:
        supportedDeviceList = ["PIC32CXBZ2"]
        defaultDevType = "PIC32CXBZ2"
        print('BLE Config: supportedDeviceList',supportedDeviceList)
        print('BLE Config: supportedDeviceType',defaultDevType)
    elif processor in wirelessblepic32cx_bz3_family:
        supportedDeviceList = ["PIC32CXBZ3"]
        defaultDevType = "PIC32CXBZ3"
    else:
        supportedDeviceList = ["Attached"]
        defaultDevType = "RNBD451" 

    global bleConfigDeviceTypeFamily

    bleConfigDeviceTypeFamily = globalsettings.createComboSymbol("WLS_BLE_CONFIG_DEVICE_TYPE_FAMILY", bleUsageConfigSetting, supportedDeviceList)
    bleConfigDeviceTypeFamily.setDefaultValue(defaultDevType)    
    bleConfigDeviceTypeFamily.setLabel("Target Wireless Device Type/Family")
    bleConfigDeviceTypeFamily.setHelp(ble_helpkeyword)    
    bleConfigDeviceTypeFamily.setDescription("Select the type of wireless device")
    # bleConfigDeviceTypeFamily.setDependencies(bleConfigHandleDevTypeChange, ["WLS_BLE_CONFIG_DEVICE_TYPE_FAMILY"])


    # Config settings 2
    bleServiceConfigSetting = globalsettings.createMenuSymbol('WLS_BLE_SERVICE_CONFIG', None)
    bleServiceConfigSetting.setLabel('Service configuration')
    bleServiceConfigSetting.setVisible(True)
    bleServiceConfigSetting.setDescription("WME config settings")


    #Property 1 Check box
    global booleanappcodebox
    booleanappcodebox = globalsettings.createBooleanSymbol('booleanappcode', None)
    booleanappcodebox.setLabel('Enable App Code Generation')
    booleanappcodebox.setDescription('Enable App Code Generation for generating sample code')
    booleanappcodebox.setDefaultValue(True)
    booleanappcodebox.setVisible(True)
     
    global linknumberbox
    linknumberbox = globalsettings.createIntegerSymbol('numberoflinks', bleServiceConfigSetting)
    linknumberbox.setLabel("Number of links")
    linknumberbox.setDescription("Set this value to more than one only for multilink application")
    linknumberbox.setMin(1)
    linknumberbox.setMax(3)
    linknumberbox.setDefaultValue(1)
    linknumberbox.setVisible(True)
    




def dep_callback(symbol, event):

    fn = "dep_callback()"
    try:
        print("::::::Inside dep_callback function::::::")

        print(event["value"])
        print(str(event))

        if event["id"] == "GAP_SCAN":
            print("::::Event ID: BLE_STACK_LIB.GAP_SCAN::::::")
            print("Event Value:", event["value"])
            gap_scan_id = event["source"].getSymbolByID("BLE_STACK_LIB.GAP_SCAN")
            print(":::: Value of Symbol gap_scan_id ::::", gap_scan_id)
            gap_scan_value = event["value"]
            wlsblegapscan.setValue(gap_scan_value)
            print(":::: Value of Symbol value ::::", gap_scan_value)

        if event["id"] == "GAP_PERIPHERAL":
            print("::::Event ID: BLE_STACK_LIB.GAP_PERIPHERAL::::::")
            print("Event Value:", event["value"])
            gap_peripheral_id = event["source"].getSymbolByID("BLE_STACK_LIB.GAP_PERIPHERAL")
            print(":::: Value of Symbol gap_peripheral_id ::::", gap_peripheral_id)
            gap_peripheral_value = event["value"]
            wlsblegapperipheral.setValue(gap_peripheral_value)
            print(":::: Value of Symbol value ::::", gap_peripheral_value)

        if event["id"] == "GAP_CENTRAL":
            print("::::Event ID: BLE_STACK_LIB.GAP_CENTRAL::::::")
            print("Event Value:", event["value"])
            gap_cental_id = event["source"].getSymbolByID("BLE_STACK_LIB.GAP_CENTRAL")
            print(":::: Value of Symbol gap_cental_id ::::", gap_cental_id)
            gap_cental_value = event["value"]
            wlsblagapcentral.setValue(gap_cental_value)
            print(":::: Value of Symbol value ::::", gap_cental_value)

        if event["id"] == "GAP_ADVERTISING":
            print("::::Event ID: BLE_STACK_LIB.GAP_ADVERTISING::::::")
            print("Event Value:", event["value"])
            gap_advertising_id = event["source"].getSymbolByID("BLE_STACK_LIB.GAP_ADVERTISING")
            print(":::: Value of Symbol trsp_server_id ::::", gap_advertising_id)
            gap_advertising_value = event["value"]
            wlsblegapadvertisement.setValue(gap_advertising_value)
            print(":::: Value of Symbol value ::::", gap_advertising_value)

        if event["id"] == "BOOL_GAP_EXT_SCAN":
            print("::::Event ID: BLE_STACK_LIB.BOOL_GAP_EXT_SCAN::::::")
            print("Event Value:", event["value"])
            gap_ext_scan_id = event["source"].getSymbolByID("BLE_STACK_LIB.BOOL_GAP_EXT_SCAN")
            print(":::: Value of Symbol gap_ext_scan_id ::::", gap_ext_scan_id)
            gap_ext_scan_value = event["value"]
            wlsblegapextscan.setValue(gap_ext_scan_value)
            print(":::: Value of Symbol value ::::", gap_ext_scan_value)

        if event["id"] == "BOOL_GAP_EXT_ADV":
            print("::::Event ID: BLE_STACK_LIB.BOOL_GAP_EXT_ADV::::::")
            print("Event Value:", event["value"])
            gap__ext_adv_id = event["source"].getSymbolByID("BLE_STACK_LIB.BOOL_GAP_EXT_ADV")
            print(":::: Value of Symbol trsp_server_id ::::", gap__ext_adv_id)
            gap__ext_adv_value = event["value"]
            wlsblegapextadv.setValue(gap__ext_adv_value)
            print(":::: Value of Symbol value ::::", gap__ext_adv_value)

        
        if event["id"] == "GAP_EXT_SCAN_PHY":
            print("::::Event ID: BLE_STACK_LIB.GAP_EXT_SCAN_PHY::::::")
            print("Event Value:", event["value"])
            ext_scan_phy_id = event["source"].getSymbolByID("BLE_STACK_LIB.GAP_EXT_SCAN_PHY")
            print(":::: Value of Symbol trsp_server_id ::::", ext_scan_phy_id)
            ext_scan_phy_value = event["value"]
            ext_scan_phy_value_str = str(ext_scan_phy_value)
            wlsblegapextscanphy.setValue(ext_scan_phy_value_str)
            print(":::: Value of Symbol value ::::", ext_scan_phy_value_str)
           
        if event["id"] == "GAP_PRI_ADV_PHY":
            print("::::Event ID: BLE_STACK_LIB.GAP_PRI_ADV_PHY::::::")
            print("Event Value:", event["value"])
            gap_pri_adv_phy_id = event["source"].getSymbolByID("BLE_STACK_LIB.GAP_PRI_ADV_PHY")
            print(":::: Value of Symbol trsp_server_id ::::", gap_pri_adv_phy_id)
            gap_pri_adv_phy_value = event["value"]
            gap_pri_adv_phy_value_str = str(gap_pri_adv_phy_value)
            wlsblegappriadvphy.setValue(gap_pri_adv_phy_value_str)
            print(":::: Value of Symbol value ::::", gap_pri_adv_phy_value_str)

        if event["id"] == "GAP_SEC_ADV_PHY":
            print("::::Event ID: BLE_STACK_LIB.GAP_SEC_ADV_PHY::::::")
            print("Event Value:", event["value"])
            gap_sec_adv_phy_id = event["source"].getSymbolByID("BLE_STACK_LIB.GAP_SEC_ADV_PHY")
            print(":::: Value of Symbol trsp_server_id ::::", gap_sec_adv_phy_id)
            gap_sec_adv_phy_value = event["value"]
            gap_sec_adv_phy_value_str = str(gap_sec_adv_phy_value)
            wlsblegapsecadvphy.setValue(gap_sec_adv_phy_value_str)
            print(":::: Value of Symbol value ::::", gap_sec_adv_phy_value_str)

        if event["id"] == "GAP_EXT_ADV_ADV_SET_2":
            print("::::Event ID: BLE_STACK_LIB.GAP_EXT_ADV_ADV_SET_2::::::")
            print("Event Value:", event["value"])
            gap_ext_ext_adv_set_2_id = event["source"].getSymbolByID("BLE_STACK_LIB.GAP_EXT_ADV_ADV_SET_2")
            print(":::: Value of Symbol trsp_server_id ::::", gap_ext_ext_adv_set_2_id)
            gap_ext_ext_adv_set_2_value = event["value"]
            wlsbleextextadvset2.setValue(gap_ext_ext_adv_set_2_value)
            print(":::: Value of Symbol value ::::", gap_ext_ext_adv_set_2_value)

        if event["id"] == "BOOL_L2CAP_CREDIT_FLOWCTRL":
            print("::::Event ID: BLE_STACK_LIB.BOOL_L2CAP_CREDIT_FLOWCTRL::::::")
            print("Event Value:", event["value"])
            l2cap_credit_flowctrl_id = event["source"].getSymbolByID("BLE_STACK_LIB.BOOL_L2CAP_CREDIT_FLOWCTRL")
            print(":::: Value of Symbol trsp_server_id ::::", l2cap_credit_flowctrl_id)
            l2cap_credit_flowctrl_value = event["value"]
            wlsblel2capcreditflowctrl.setValue(l2cap_credit_flowctrl_value)
            print(":::: Value of Symbol value ::::", l2cap_credit_flowctrl_value)

        if event["id"] == "GAP_SVC_PERI_PRE_CP":
            print("::::Event ID: BLE_STACK_LIB.GAP_SVC_PERI_PRE_CP::::::")
            print("Event Value:", event["value"])
            gap_svc_peri_pre_cp_id = event["source"].getSymbolByID("BLE_STACK_LIB.GAP_SVC_PERI_PRE_CP")
            print(":::: Value of Symbol trsp_server_id ::::", gap_svc_peri_pre_cp_id)
            gap_svc_peri_pre_cp_id_value = event["value"]
            wlsblegapsvcpericp.setValue(gap_svc_peri_pre_cp_id_value)
            print(":::: Value of Symbol value ::::", gap_svc_peri_pre_cp_id_value)

        if event["id"] == "GAP_ADV_TYPE":
            print("::::Event ID: BLE_STACK_LIB.GAP_ADV_TYPE::::::")
            print("Event Value:", event["value"])
            gap_adv_type_id = event["source"].getSymbolByID("BLE_STACK_LIB.GAP_ADV_TYPE")
            print(":::: Value of Symbol trsp_server_id ::::", gap_adv_type_id)
            gap_adv_type_id_value = event["value"]
            wlsblegapadvtype.setValue(gap_adv_type_id_value)
            print(":::: Value of Symbol value ::::", gap_adv_type_id_value)


        if event["id"] == "GAP_ADV_DATA_UDD":
            print("::::Event ID: BLE_STACK_LIB.GAP_ADV_DATA_UDD::::::")
            print("Event Value:", event["value"])
            gap_adv_data_udd_id = event["source"].getSymbolByID("BLE_STACK_LIB.GAP_ADV_DATA_UDD")
            print(":::: Value of Symbol trsp_server_id ::::", gap_adv_data_udd_id)
            gap_adv_data_udd_value = event["value"]
            wlsblegapadvdataudd.setValue(gap_adv_data_udd_value)
            print(":::: Value of Symbol value ::::", gap_adv_data_udd_value)

        if event["id"] == "TRSP_BOOL_CLIENT":
            print("::::Event ID: PROFILE_TRSP.TRSP_BOOL_CLIENT::::::")
            print("Event Value:", event["value"])
            trsp_client_id = event["source"].getSymbolByID("PROFILE_TRSP.TRSP_BOOL_CLIENT")
            print(":::: Value of Symbol trsp_client_id ::::", trsp_client_id)
            trsp_client_value = event["value"]
            wlsbletrspclient.setValue(trsp_client_value)
            print(":::: Value of Symbol value ::::", trsp_client_value)

        if event["id"] == "TRSP_BOOL_SERVER":
            print("::::Event ID: PROFILE_TRSP.TRSP_BOOL_SERVER::::::")
            print("Event Value:", event["value"])
            trsp_server_id = event["source"].getSymbolByID("PROFILE_TRSP.TRSP_BOOL_SERVER")
            print(":::: Value of Symbol trsp_server_id ::::", trsp_server_id)
            trsp_server_value = event["value"]
            wlsbletrspserver.setValue(trsp_server_value)
            print(":::: Value of Symbol value ::::", trsp_server_value)

        if event["id"] == "GAP_DSADV_EN":
            print("::::Event ID: BLE_STACK_LIB.GAP_DSADV_EN::::::")
            print("Event Value:", event["value"])
            gap_dsadv_en_id = event["source"].getSymbolByID("BLE_STACK_LIB.GAP_DSADV_EN")
            print(":::: Value of Symbol trsp_server_id ::::", gap_dsadv_en_id)
            gap_dsadv_en_value = event["value"]
            wlsblegapdsadven.setValue(gap_dsadv_en_value)
            print(":::: Value of Symbol value ::::", gap_dsadv_en_value)


    except Exception as e:
        exc_type, exc_obj, exc_tb = sys.exc_info()
        print ("%s Error on line number : %s : %s" %(fn, exc_tb.tb_lineno, e))


def updateParameters(bleConfigComp):
    fn = "updateParameters()"
    try:
        print ("[WME] ::::: In updateParameters ::::::::::::::::::::")
        global wlsblel2capcreditflowctrl, wlsblegapscan, wlsblegapperipheral, wlsblagapcentral, wlsbletrspclient, wlsbletrspserver, wlsblegapextscan, wlsblegapextscanphy, wlsblegapadvertisement, wlsblegapextadv
        global wlsblegapdsadven, wlsblegappriadvphy, wlsblegapsecadvphy, wlsbleextextadvset2, wlsblegapadvdataudd, wlsblegapsvcpericp, wlsblegapadvtype

        wlsblegapscan = bleConfigComp.createBooleanSymbol("WLS_BLE_GAP_SCAN", None)
        wlsblegapscan.setLabel("wls Scan")
        wlsblegapscan.setDefaultValue(False)
        wlsblegapscan.setVisible(False)

        wlsblegapperipheral = bleConfigComp.createBooleanSymbol("WLS_BLE_GAP_PERIPHERAL", None)
        wlsblegapperipheral.setLabel("wls Peripheral")
        wlsblegapperipheral.setDefaultValue(False)
        wlsblegapperipheral.setVisible(False)

        wlsblagapcentral = bleConfigComp.createBooleanSymbol("WLS_BLE_GAP_CENTRAL", None)
        wlsblagapcentral.setLabel("wls Central")
        wlsblagapcentral.setDefaultValue(False)
        wlsblagapcentral.setVisible(False)

        wlsblegapadvertisement = bleConfigComp.createBooleanSymbol("WLS_BLE_GAP_ADVERTISING", None)
        wlsblegapadvertisement.setLabel("wls Enable gap advertisement")
        wlsblegapadvertisement.setDefaultValue(False)
        wlsblegapadvertisement.setVisible(False)
 
        wlsblegapextscan = bleConfigComp.createBooleanSymbol("WLS_BLE_BOOL_GAP_EXT_SCAN", None)
        wlsblegapextscan.setLabel("wls ble ext scan enable")
        wlsblegapextscan.setDefaultValue(False)
        wlsblegapextscan.setVisible(False)

        wlsblegapextadv = bleConfigComp.createBooleanSymbol("WLS_BLE_BOOL_GAP_EXT_ADV", None)
        wlsblegapextadv.setLabel("wls Enable gap ext advertisement")
        wlsblegapextadv.setDefaultValue(False)
        wlsblegapextadv.setVisible(False)

        wlsblegapextscanphy = bleConfigComp.createStringSymbol("WLS_BLE_GAP_EXT_SCAN_PHY", None)
        wlsblegapextscanphy.setLabel("wls Enable ext scan phy")
        wlsblegapextscanphy.setDefaultValue("00")
        wlsblegapextscanphy.setVisible(False)

        wlsblegappriadvphy = bleConfigComp.createStringSymbol("WLS_BLE_GAP_PRI_ADV_PHY", None)
        wlsblegappriadvphy.setLabel("wls pri adv phy")
        wlsblegappriadvphy.setDefaultValue("00")
        wlsblegappriadvphy.setVisible(False)

        wlsblegapsecadvphy = bleConfigComp.createStringSymbol("WLS_BLE_GAP_SEC_ADV_PHY", None)
        wlsblegapsecadvphy.setLabel("wls sec adv phy")
        wlsblegapsecadvphy.setDefaultValue("00")
        wlsblegapsecadvphy.setVisible(False)

        wlsbleextextadvset2 = bleConfigComp.createBooleanSymbol("WLS_BLE_GAP_EXT_ADV_ADV_SET_2", None)
        wlsbleextextadvset2.setLabel("wls ble ext adv set 2")
        wlsbleextextadvset2.setDefaultValue(False)
        wlsbleextextadvset2.setVisible(False)

        
        wlsblel2capcreditflowctrl = bleConfigComp.createBooleanSymbol("WLS_BLE_BOOL_L2CAP_CREDIT_FLOWCTRL", None)
        wlsblel2capcreditflowctrl.setLabel("wls ble l2cap credit flowctrl")
        wlsblel2capcreditflowctrl.setDefaultValue(False)
        wlsblel2capcreditflowctrl.setVisible(False)

        wlsblegapsvcpericp = bleConfigComp.createBooleanSymbol("WLS_BLE_GAP_SVC_PERI_PRE_CP", None)
        wlsblegapsvcpericp.setLabel("wls ble gap svc peri pre cp")
        wlsblegapsvcpericp.setDefaultValue(False)
        wlsblegapsvcpericp.setVisible(False)

        wlsblegapadvtype = bleConfigComp.createIntegerSymbol("WLS_BLE_GAP_ADV_TYPE", None)
        wlsblegapadvtype.setLabel("wls ble gap adv type")
        wlsblegapadvtype.setDefaultValue(0)
        wlsblegapadvtype.setVisible(False)

        wlsblegapadvdataudd = bleConfigComp.createStringSymbol("WLS_BLE_GAP_ADV_DATA_UDD", None)
        wlsblegapadvdataudd.setLabel("wls ble User Defined Data")
        wlsblegapadvdataudd.setDefaultValue("00")
        wlsblegapadvdataudd.setVisible(False) 

        wlsbletrspclient = bleConfigComp.createBooleanSymbol("WLS_BLE_TRSP_CLIENT", None)
        wlsbletrspclient.setLabel("wls Enable Client Role for trsp")
        wlsbletrspclient.setDefaultValue(False)
        wlsbletrspclient.setVisible(False)

        wlsbletrspserver = bleConfigComp.createBooleanSymbol("WLS_BLE_TRSP_SERVER", None)
        wlsbletrspserver.setLabel("wls Enable Server Role for trsp")
        wlsbletrspserver.setDefaultValue(False)
        wlsbletrspserver.setVisible(False)

        wlsblegattclient = bleConfigComp.createBooleanSymbol("WLS_BLE_BOOL_GATT_CLIENT", None)
        wlsblegattclient.setLabel("wls Enable Client Role")
        wlsblegattclient.setDefaultValue(False)
        wlsblegattclient.setVisible(False)

        wlsblegapdsadven = bleConfigComp.createBooleanSymbol("WLS_BLE_GAP_DSADV_EN", None)
        wlsblegapdsadven.setLabel("wls Enable deep sleep")
        wlsblegapdsadven.setDefaultValue(False)
        wlsblegapdsadven.setVisible(False)

        wlsblecommentsymbol = bleConfigComp.createStringSymbol("WLS_BLE_COMMENT", None)
        wlsblecommentsymbol.setLabel("comments for code")
        wlsblecommentsymbol.setDefaultValue("/****generated sample application code****/")
        wlsblecommentsymbol.setVisible(False)

        wlsblesyssleepmodeen = bleConfigComp.createBooleanSymbol("WLS_BLE_SYS_SLEEP_MODE_EN", None)
        wlsblesyssleepmodeen.setLabel("wls ble sleep mode en")
        wlsblesyssleepmodeen.setDefaultValue(False)
        wlsblesyssleepmodeen.setVisible(False)

        print ("[WME] ::::: End ")
    except Exception as e:
        exc_type, exc_obj, exc_tb = sys.exc_info()
        print ("%s Error on line number : %s : %s" %(fn, exc_tb.tb_lineno, e))




def wmeblePxprEnable(symbol, event):

    try:

        if (booleanappcodebox.getValue() == True) and (
            (Database.getSymbolValue("PROFILE_PXP", "PXP_BOOL_SERVER") == True) 
            ):
            symbol.setEnabled(True)
        else:
            symbol.setEnabled(False)
    except Exception as e:
        exc_type, exc_obj, exc_tb = sys.exc_info()
        print ("%s Error on line number for trsps : %s : %s" %(fn, exc_tb.tb_lineno, e))



def wmebleAnpcEnable(symbol, event):

    try:

        if (booleanappcodebox.getValue() == True) and (
            (Database.getSymbolValue("PROFILE_ANP", "ANP_BOOL_CLIENT") == True) 
            ):
            symbol.setEnabled(True)
        else:
            symbol.setEnabled(False)

    except Exception as e:
        exc_type, exc_obj, exc_tb = sys.exc_info()
        print ("%s Error on line number for trsps : %s : %s" %(fn, exc_tb.tb_lineno, e))
 

def wmebleAnpsEnable(symbol, event):

    try:

        if (booleanappcodebox.getValue() == True) and (
            (Database.getSymbolValue("PROFILE_ANP", "ANP_BOOL_SERVER") == True) 
            ):
            symbol.setEnabled(True)
        else:
            symbol.setEnabled(False)

    except Exception as e:
        exc_type, exc_obj, exc_tb = sys.exc_info()
        print ("%s Error on line number for trsps : %s : %s" %(fn, exc_tb.tb_lineno, e))


def wmeblePxpmEnable(symbol, event):

    try:

        if (booleanappcodebox.getValue() == True) and (
            (Database.getSymbolValue("PROFILE_PXP", "PXP_BOOL_CLIENT") == True) 
            ):
            symbol.setEnabled(True)
        else:
            symbol.setEnabled(False)
    except Exception as e:
        exc_type, exc_obj, exc_tb = sys.exc_info()
        print ("%s Error on line number for trsps : %s : %s" %(fn, exc_tb.tb_lineno, e))


def wmebleThroughputEnable(symbol, event):

    try:

        if (booleanappcodebox.getValue() == True) and (
            (Database.getSymbolValue("BLE_STACK_LIB", "BOOL_L2CAP_CREDIT_FLOWCTRL") == True)
            ):
            symbol.setEnabled(True)
        else:
            symbol.setEnabled(False)

       

    except Exception as e:
        exc_type, exc_obj, exc_tb = sys.exc_info()
        print ("%s Error on line number for trsps : %s : %s" %(fn, exc_tb.tb_lineno, e))

   

def wmebleHogpEnable(symbol, event):

    try:

        if (booleanappcodebox.getValue() == True) and (
            (Database.getSymbolValue("PROFILE_HOGP", "HOGP_BOOL_SERVER") == True)
            ):
            symbol.setEnabled(True)
        else:
            symbol.setEnabled(False)

       

    except Exception as e:
        exc_type, exc_obj, exc_tb = sys.exc_info()
        print ("%s Error on line number for trsps : %s : %s" %(fn, exc_tb.tb_lineno, e))
        
  
    
# Define the callback function to handle the dependencies
def wmeblekeyEnable(symbol, event):

    try:

        if (booleanappcodebox.getValue() == True) and (
            (Database.getSymbolValue("PROFILE_ANP", "ANP_BOOL_CLIENT") == True) or
            (Database.getSymbolValue("PROFILE_ANP", "ANP_BOOL_SERVER") == True) or
            (Database.getSymbolValue("PROFILE_PXP", "PXP_BOOL_SERVER") == True) or
            (Database.getSymbolValue("PROFILE_PXP", "PXP_BOOL_CLIENT") == True) or
            (Database.getSymbolValue("PROFILE_ANCS", "ANCS_BOOL_CLIENT") == True) or
            (Database.getSymbolValue("PROFILE_HOGP", "HOGP_BOOL_SERVER") == True)
            ):
            symbol.setEnabled(True)
        else:
            symbol.setEnabled(False)

       

    except Exception as e:
        exc_type, exc_obj, exc_tb = sys.exc_info()
        print ("%s Error on line number for trsps : %s : %s" %(fn, exc_tb.tb_lineno, e))
  

def wmebleLedEnable(symbol, event):

    try:

        if(booleanappcodebox.getValue() == True) and ((Database.getSymbolValue("PROFILE_ANP", "ANP_BOOL_CLIENT") == True) or (Database.getSymbolValue("PROFILE_ANP", "ANP_BOOL_SERVER") == True) or (Database.getSymbolValue("PROFILE_PXP", "PXP_BOOL_SERVER") == True) or (Database.getSymbolValue("PROFILE_PXP", "PXP_BOOL_CLIENT") == True) or (Database.getSymbolValue("BLE_STACK_LIB", "BOOL_L2CAP_CREDIT_FLOWCTRL") == True) or (Database.getSymbolValue("PROFILE_ANCS", "ANCS_BOOL_CLIENT") == True) or (Database.getSymbolValue("PROFILE_HOGP", "HOGP_BOOL_SERVER") == True)  ):
            symbol.setEnabled(True)
        else:
            symbol.setEnabled(False)

       

    except Exception as e:
        exc_type, exc_obj, exc_tb = sys.exc_info()
        print ("%s Error on line number for trsps : %s : %s" %(fn, exc_tb.tb_lineno, e))
 
      
def wmebleTimerEnable(symbol, event):

    try:

        if(booleanappcodebox.getValue() == True) and ((Database.getSymbolValue("PROFILE_ANP", "ANP_BOOL_CLIENT") == True) or (Database.getSymbolValue("PROFILE_ANP", "ANP_BOOL_SERVER") == True) or (Database.getSymbolValue("PROFILE_PXP", "PXP_BOOL_SERVER") == True) or (Database.getSymbolValue("PROFILE_PXP", "PXP_BOOL_CLIENT") == True) or (Database.getSymbolValue("BLE_STACK_LIB", "BOOL_L2CAP_CREDIT_FLOWCTRL") == True) or (Database.getSymbolValue("PROFILE_ANCS", "ANCS_BOOL_CLIENT") == True) or (Database.getSymbolValue("PROFILE_HOGP", "HOGP_BOOL_SERVER") == True)  ):
            symbol.setEnabled(True)
        else:
            symbol.setEnabled(False)

       

    except Exception as e:
        exc_type, exc_obj, exc_tb = sys.exc_info()
        print ("%s Error on line number for trsps : %s : %s" %(fn, exc_tb.tb_lineno, e))
    # # Check the state of all dependencies
 
     

def wmebleError_defsEnable(symbol, event):
    try:

        if (booleanappcodebox.getValue() == True) and (
            (Database.getSymbolValue("PROFILE_ANP", "ANP_BOOL_CLIENT") == True) or
            (Database.getSymbolValue("PROFILE_ANP", "ANP_BOOL_SERVER") == True) or
            (Database.getSymbolValue("PROFILE_PXP", "PXP_BOOL_SERVER") == True) or
            (Database.getSymbolValue("PROFILE_PXP", "PXP_BOOL_CLIENT") == True) or
            (Database.getSymbolValue("BLE_STACK_LIB", "BOOL_L2CAP_CREDIT_FLOWCTRL") == True) or
            (Database.getSymbolValue("PROFILE_ANCS", "ANCS_BOOL_CLIENT") == True) or
            (Database.getSymbolValue("PROFILE_HOGP", "HOGP_BOOL_SERVER") == True)
            ):
            symbol.setEnabled(True)
        else:
            symbol.setEnabled(False)

    except Exception as e:
        exc_type, exc_obj, exc_tb = sys.exc_info()
        print ("%s Error on line number for trsps : %s : %s" %(fn, exc_tb.tb_lineno, e))
    # # Check the state of all dependencies
        

def wmebleModuleEnable(symbol, event):

    try:

        if (booleanappcodebox.getValue() == True) and (
            (Database.getSymbolValue("PROFILE_ANCS", "ANCS_BOOL_CLIENT") == True) or
            (Database.getSymbolValue("PROFILE_HOGP", "HOGP_BOOL_SERVER") == True)
            ):
            symbol.setEnabled(True)
        else:
            symbol.setEnabled(False)

    except Exception as e:
        exc_type, exc_obj, exc_tb = sys.exc_info()
        print ("%s Error on line number for trsps : %s : %s" %(fn, exc_tb.tb_lineno, e))


    # # Check the state of all dependencies

def handlerFilesCallback(symbol, event):
    # symbol.setMarkup(event["value"])
    print('Overwrite:',event["value"])  
    # symbol.setEnabled(event["value"])
    symbol.setOverwrite(event["value"])

def trspshandlerFilesCallback(symbol, event):
    try:
      

        if(Database.getSymbolValue("PROFILE_TRSP", "TRSP_BOOL_SERVER") == True):
            symbol.setEnabled(True)
        else:
            symbol.setEnabled(False)
       

    except Exception as e:
        exc_type, exc_obj, exc_tb = sys.exc_info()
        print ("%s Error on line number for trsps : %s : %s" %(fn, exc_tb.tb_lineno, e))

def trspchandlerFilesCallback(symbol, event):
    try:

        if(Database.getSymbolValue("PROFILE_TRSP", "TRSP_BOOL_CLIENT") == True):
            symbol.setEnabled(True)
        else:
            symbol.setEnabled(False)
       

    except Exception as e:
        exc_type, exc_obj, exc_tb = sys.exc_info()
        print ("%s Error on line number for trsps : %s : %s" %(fn, exc_tb.tb_lineno, e))

def ancshandlerFilesCallback(symbol, event):
    try:

        if(Database.getSymbolValue("PROFILE_ANCS", "ANCS_BOOL_CLIENT") == True):
            symbol.setEnabled(True)
        else:
            symbol.setEnabled(False)
       

    except Exception as e:
        exc_type, exc_obj, exc_tb = sys.exc_info()
        print ("%s Error on line number for trsps : %s : %s" %(fn, exc_tb.tb_lineno, e))

def anpshandlerFilesCallback(symbol, event):
    try:

        if(Database.getSymbolValue("PROFILE_ANP", "ANP_BOOL_SERVER") == True):
            symbol.setEnabled(True)
        else:
            symbol.setEnabled(False)
       

    except Exception as e:
        exc_type, exc_obj, exc_tb = sys.exc_info()
        print ("%s Error on line number for trsps : %s : %s" %(fn, exc_tb.tb_lineno, e))

def anpchandlerFilesCallback(symbol, event):
    try:

        if(Database.getSymbolValue("PROFILE_ANP", "ANP_BOOL_CLIENT") == True):
            symbol.setEnabled(True)
        else:
            symbol.setEnabled(False)
       

    except Exception as e:
        exc_type, exc_obj, exc_tb = sys.exc_info()
        print ("%s Error on line number for trsps : %s : %s" %(fn, exc_tb.tb_lineno, e))

def hogpshandlerFilesCallback(symbol, event):
    try:

        if(Database.getSymbolValue("PROFILE_HOGP", "HOGP_BOOL_SERVER") == True):
            symbol.setEnabled(True)
        else:
            symbol.setEnabled(False)
       

    except Exception as e:
        exc_type, exc_obj, exc_tb = sys.exc_info()
        print ("%s Error on line number for trsps : %s : %s" %(fn, exc_tb.tb_lineno, e))


def pxpmhandlerFilesCallback(symbol, event):
    try:

        if(Database.getSymbolValue("PROFILE_PXP", "PXP_BOOL_CLIENT") == True):
            symbol.setEnabled(True)
        else:
            symbol.setEnabled(False)
       

    except Exception as e:
        exc_type, exc_obj, exc_tb = sys.exc_info()
        print ("%s Error on line number for trsps : %s : %s" %(fn, exc_tb.tb_lineno, e))


def pxprhandlerFilesCallback(symbol, event):
    try:

        if(Database.getSymbolValue("PROFILE_PXP", "PXP_BOOL_SERVER") == True):
            symbol.setEnabled(True)
        else:
            symbol.setEnabled(False)
       

    except Exception as e:
        exc_type, exc_obj, exc_tb = sys.exc_info()
        print ("%s Error on line number for trsps : %s : %s" %(fn, exc_tb.tb_lineno, e))


def instantiateComponent(bleConfigComp):

    fn = "instantiateComponent()"
    print('Load Module: ########ble config##########')
    configName = Variables.get('__CONFIGURATION_NAME')
    processor = Variables.get('__PROCESSOR')
    print('Config Name: {} processor: {}'.format(configName, processor))
    print('Loading')
    print(Module.getPath())

    #print('{} ble_stack_load_lib: include {}'.format(n, name))
    wlsbleAddonPath = bleConfigComp.createSettingSymbol("BLE_ADDON_PATH_", None)
    wlsbleAddonPath.setValue("../src/app_ble/handlers")
    wlsbleAddonPath.setCategory("C32")
    wlsbleAddonPath.setKey("extra-include-directories")
    wlsbleAddonPath.setAppend(True, ";")
    wlsbleAddonPath.setEnabled(True)

    print('FInalising *** TEST FOR CONFIG')
    processor = Variables.get("__PROCESSOR")
    activeComponents = Database.getActiveComponentIDs()
    if( processor in wirelessblepic32cx_bz2_family):
        print('finalising component')
        requiredComponents = ['FreeRTOS','HarmonyCore','lib_wolfcrypt','lib_crypto','nvm','pdsSystem','pic32cx_bz2_devsupport','BLE_STACK_LIB']
    elif(processor in wirelessblepic32cx_bz3_family):
        print('finalizeComponent bz3')
        requiredComponents = ['FreeRTOS','HarmonyCore','nvm','pdsSystem','pic32cx_bz3_devsupport','BLE_STACK_LIB']

    for r in requiredComponents:
        activeComponents = Database.getActiveComponentIDs()
        if r not in activeComponents:
            res = Database.activateComponents([r],"__ROOTVIEW",False)

    if( processor in wirelessblepic32cx_bz2_family):
        res = Database.connectDependencies([['lib_crypto', 'LIB_CRYPTO_WOLFCRYPT_Dependency', 'lib_wolfcrypt', 'lib_wolfcrypt']])
    
    print('finalised')

    gsettings = bleConfigComp
    loadconfigmodule(gsettings)
    updateParameters(bleConfigComp)

  
   


    print('#############Entering Zero code ######################')

    '''  Dependency callbacks '''
     
    depSymbol1 = bleConfigComp.createIntegerSymbol("BLE_WME_APP" ,None)
    depSymbol1.setLabel("Dependent Symbol")
    depSymbol1.setReadOnly(True)
    depSymbol1.setDefaultValue(1)
    depSymbol1.setVisible(False)
    depSymbol1.setDependencies(dep_callback, [
        "BLE_STACK_LIB.GAP_SCAN",
        "BLE_STACK_LIB.GAP_PERIPHERAL", 
        "BLE_STACK_LIB.BOOL_GAP_EXT_SCAN", 
        "BLE_STACK_LIB.GAP_DEV_NAME", 
        "PROFILE_TRSP.TRSP_BOOL_CLIENT", 
        "PROFILE_TRSP.TRSP_BOOL_SERVER", 
        "BLE_STACK_LIB.GAP_CENTRAL", 
        "BLE_STACK_LIB.GAP_EXT_SCAN_PHY", 
        "BLE_STACK_LIB.GAP_ADVERTISING", 
        "BLE_STACK_LIB.BOOL_GAP_EXT_ADV", 
        "BLE_STACK_LIB.GAP_DSADV_EN", 
        "SERVICE_CMS.CMS_INT_SERVICE_COUNT", 
        "BLE_STACK_LIB.GAP_PRI_ADV_PHY", 
        "BLE_STACK_LIB.BOOL_L2CAP_CREDIT_FLOWCTRL",
        "BLE_STACK_LIB.GAP_ADV_DATA_UDD",
        "PROFILE_ANP.ANP_BOOL_SERVER",
        "BLE_STACK_LIB.GAP_EXT_ADV_ADV_SET_2",
        "BLE_STACK_LIB.GAP_SEC_ADV_PHY",
        "BLE_STACK_LIB.GAP_SVC_PERI_PRE_CP",
        "BLE_STACK_LIB.GAP_ADV_TYPE"
        ])


    
    try:

        devicesupportComponent = Database.getComponentByID("pic32cx_bz2_devsupport")
        if (devicesupportComponent != None):
            
            wmebledisableuseredits = devicesupportComponent.getSymbolByID('DISABLE_APP_CODE_GEN')
            wmebledisableuseredits_val = wmebledisableuseredits.getValue()
            print ("[WME] ::::: Value of DISABLE_APP_CODE_GEN from pic32cx_bz2_devsupport before  :::::", wmebledisableuseredits_val)
            if(Database.getSymbolValue("pic32cx_bz2_devsupport", "DISABLE_APP_CODE_GEN") == False):
                wmebledisableuseredits.setValue(True)
            
            updatedUserEditsSymbolValue = wmebledisableuseredits.getValue()
            print(" Value of DISABLE_APP_CODE_GEN from pic32cx_bz2_devsupport after ", updatedUserEditsSymbolValue)
            
        devicesupportComponent_bz3 = Database.getComponentByID("pic32cx_bz3_devsupport")
        if (devicesupportComponent_bz3 != None):
            
            wmebledisableusereditsforbz3 = devicesupportComponent_bz3.getSymbolByID('DISABLE_APP_CODE_GEN')
            wmebledisableuseredits_val_bz3 = wmebledisableusereditsforbz3.getValue()
            print ("[WME] ::::: Value of DISABLE_APP_CODE_GEN from pic32cx_bz3_devsupport before  :::::", wmebledisableuseredits_val_bz3)
            if(Database.getSymbolValue("pic32cx_bz3_devsupport", "DISABLE_APP_CODE_GEN") == False):
                wmebledisableusereditsforbz3.setValue(True)
            
            updatedUserEditsSymbolValue_bz3 = wmebledisableusereditsforbz3.getValue()
            print(" Value of DISABLE_APP_CODE_GEN from pic32cx_bz3_devsupport after ", updatedUserEditsSymbolValue_bz3)
 

        bleStackComponent = Database.getComponentByID("BLE_STACK_LIB")
        if (bleStackComponent != None):
            
            wmebledisableappcodegen = bleStackComponent.getSymbolByID('DISABLE_APP_CODE_GEN')
            wmebledisableappcodegen_val = wmebledisableappcodegen.getValue()
            print ("[WME] ::::: Value of DISABLE_APP_CODE_GEN before  :::::", wmebledisableappcodegen_val)
            if(Database.getSymbolValue("BLE_STACK_LIB", "DISABLE_APP_CODE_GEN") == False):
                wmebledisableappcodegen.setValue(True)
            
            updatedSymbolValue = wmebledisableappcodegen.getValue()
            print(" Value of DISABLE_APP_CODE_GEN after ", updatedSymbolValue)
           
            gapscanlocalNameEn = bleStackComponent.getSymbolByID('GAP_SCAN')
            gapscandata = gapscanlocalNameEn.getValue()
            print ("[WME] ::::: Value of get ble_gap_scan_symbol :::::", gapscanlocalNameEn)
            print ("[WME] ::::: Value of get ble_gap_scan_symbol :::::", gapscandata)
            wlsblegapscan.setValue(gapscandata)

            gapperipherallocalNameEn = bleStackComponent.getSymbolByID('GAP_PERIPHERAL')
            gapperipheraldata = gapperipherallocalNameEn.getValue()
            print ("[WME] ::::: Value of get ble_gap_scan_symbol :::::", gapperipherallocalNameEn)
            print ("[WME] ::::: Value of get ble_gap_scan_symbol :::::", gapperipheraldata)
            wlsblegapperipheral.setValue(gapperipheraldata)

            gapcentralLocalNameEn = bleStackComponent.getSymbolByID('GAP_CENTRAL')
            gapcentraldata = gapcentralLocalNameEn.getValue()
            print ("[WME] ::::: Value of get ble_gap_scan_symbol :::::", gapcentralLocalNameEn)
            print ("[WME] ::::: Value of get ble_gap_scan_symbol :::::", gapcentraldata)
            wlsblagapcentral.setValue(gapcentraldata)

            gapeadvertisementLocalNameEn = bleStackComponent.getSymbolByID('GAP_ADVERTISING')
            gapadvertisingdata = gapeadvertisementLocalNameEn.getValue()
            print ("[WME] ::::: Value of get ble_gap_scan_symbol :::::", gapeadvertisementLocalNameEn)
            print ("[WME] ::::: Value of get ble_gap_scan_symbol :::::", gapadvertisingdata)
            wlsblegapadvertisement.setValue(gapadvertisingdata)

            gapextscanLocalNameEn = bleStackComponent.getSymbolByID('BOOL_GAP_EXT_SCAN')
            gapextscandata = gapextscanLocalNameEn.getValue()
            print ("[WME] ::::: Value of get ble_gap_scan_symbol :::::", gapextscanLocalNameEn)
            print ("[WME] ::::: Value of get ble_gap_scan_symbol :::::", gapextscandata)
            wlsblegapextscan.setValue(gapextscandata)
            
            gapexteadvLocalNameEn = bleStackComponent.getSymbolByID('BOOL_GAP_EXT_ADV')
            gapextadvedata = gapexteadvLocalNameEn.getValue()
            print ("[WME] ::::: Value of get ble_gap_scan_symbol :::::", gapexteadvLocalNameEn)
            print ("[WME] ::::: Value of get ble_gap_scan_symbol :::::", gapextadvedata)
            wlsblegapextadv.setValue(gapextadvedata)

            gapextscanphyLocalNameEn = bleStackComponent.getSymbolByID('GAP_EXT_SCAN_PHY')
            gapextscanphydata = gapextscanphyLocalNameEn.getValue()
            print ("[WME] ::::: Value of get ble_gap_scan_symbol :::::", gapextscanphyLocalNameEn)
            print ("[WME] ::::: Value of get ble_gap_scan_symbol :::::", gapextscanphydata)
            # Convert gapextscanphydata to a string
            gapextscanphydata_str = str(gapextscanphydata)
            wlsblegapextscanphy.setValue(gapextscanphydata_str)

            gappriadvphyLocalNameEn = bleStackComponent.getSymbolByID('GAP_PRI_ADV_PHY')
            gappriadvphydata = gappriadvphyLocalNameEn.getValue()
            print ("[WME] ::::: Value of get ble_gap_scan_symbol :::::", gappriadvphyLocalNameEn)
            print ("[WME] ::::: Value of get ble_gap_scan_symbol :::::", gappriadvphydata)
            gappriadvphydata_str = str(gappriadvphydata)
            wlsblegappriadvphy.setValue(gappriadvphydata_str)

            gapsecadvphyLocalNameEn = bleStackComponent.getSymbolByID('GAP_SEC_ADV_PHY')
            gapsecadvphydata = gapsecadvphyLocalNameEn.getValue()
            print ("[WME] ::::: Value of get ble_gap_scan_symbol :::::", gapsecadvphyLocalNameEn)
            print ("[WME] ::::: Value of get ble_gap_scan_symbol :::::", gapsecadvphydata)
            gapsecadvphydata_str = str(gapsecadvphydata)
            wlsblegapsecadvphy.setValue(gapsecadvphydata_str)
            
            gapextadvadvset2LocalNameEn = bleStackComponent.getSymbolByID('GAP_EXT_ADV_ADV_SET_2')
            gapextadvadvset2data = gapextadvadvset2LocalNameEn.getValue()
            print ("[WME] ::::: Value of get ble_gap_scan_symbol :::::", gapextadvadvset2LocalNameEn)
            print ("[WME] ::::: Value of get ble_gap_scan_symbol :::::", gapextadvadvset2data)
            wlsbleextextadvset2.setValue(gapextadvadvset2data)

            l2capcreditflowctrlLocalNameEn = bleStackComponent.getSymbolByID('BOOL_L2CAP_CREDIT_FLOWCTRL')
            l2capcreditflowctrldata = l2capcreditflowctrlLocalNameEn.getValue()
            print ("[WME] ::::: Value of get l2capcreditflowctrldata :::::", l2capcreditflowctrlLocalNameEn)
            print ("[WME] ::::: Value of get l2capcreditflowctrldata :::::", l2capcreditflowctrldata)
            wlsblel2capcreditflowctrl.setValue(l2capcreditflowctrldata)

            gapsvcperiprecpLocalNameEn = bleStackComponent.getSymbolByID('GAP_SVC_PERI_PRE_CP')
            gapsvcperiprecpdata = gapsvcperiprecpLocalNameEn.getValue()
            print ("[WME] ::::: Value of get l2capcreditflowctrldata :::::", gapsvcperiprecpLocalNameEn)
            print ("[WME] ::::: Value of get l2capcreditflowctrldata :::::", gapsvcperiprecpdata)
            wlsblegapsvcpericp.setValue(gapsvcperiprecpdata)

            gapadvtypeLocalNameEn = bleStackComponent.getSymbolByID('GAP_ADV_TYPE')
            gapadvtypedata = gapadvtypeLocalNameEn.getValue()
            print ("[WME] ::::: Value of get l2capcreditflowctrldata :::::", gapadvtypeLocalNameEn)
            print ("[WME] ::::: Value of get l2capcreditflowctrldata :::::", gapadvtypedata)
            wlsblegapadvtype.setValue(gapadvtypedata)

            gapadvdatauddLocalNameEn = bleStackComponent.getSymbolByID('GAP_ADV_DATA_UDD')
            gapadvdataudddata = gapadvdatauddLocalNameEn.getValue()
            print ("[WME] ::::: Value of get gapadvdatauddLocalNameEn :::::", gapadvdatauddLocalNameEn)
            print ("[WME] ::::: Value of get gapadvdatauddLocalNameEn :::::", gapadvdataudddata)
            wlsblegapadvdataudd.setValue(gapadvdataudddata)
            

            gapdsadvenLocalNameEn = bleStackComponent.getSymbolByID('GAP_DSADV_EN')
            gapdsadvendata = gapdsadvenLocalNameEn.getValue()
            print ("[WME] ::::: Value of get ble_gap_scan_symbol :::::", gapdsadvenLocalNameEn)
            print ("[WME] ::::: Value of get ble_gap_scan_symbol :::::", gapdsadvendata)
            # gapdsadvendata_str = str(gapdsadvendata)
            wlsblegapdsadven.setValue(gapdsadvendata)

        transparentuartcomponent = Database.getComponentByID("PROFILE_TRSP")
        if (transparentuartcomponent != None):
            trspclientLocalNameEn = transparentuartcomponent.getSymbolByID('TRSP_BOOL_CLIENT')
            trspclientdata = trspclientLocalNameEn.getValue()
            print ("[WME] ::::: Value of get transparentuartsymbol_1 :::::", trspclientLocalNameEn)
            print ("[WME] ::::: Value of get transparentuartsymbol_1 :::::", trspclientdata)
            wlsbletrspclient.setValue(trspclientdata)


            trspserverLocalNameEn = transparentuartcomponent.getSymbolByID('TRSP_BOOL_SERVER')
            trspserverdata = trspserverLocalNameEn.getValue()
            print ("[WME] ::::: Value of get transparentuartsymbol_1 :::::", trspserverLocalNameEn)
            print ("[WME] ::::: Value of get transparentuartsymbol_1 :::::", trspserverdata)
            wlsbletrspserver.setValue(trspserverdata)

    except Exception as e:
        exc_type, exc_obj, exc_tb = sys.exc_info()
        print ("%s Error on line number : %s : %s" %(fn, exc_tb.tb_lineno, e))  



    component_name = Database.getComponentByID("pic32cx_bz2_devsupport")
    print ("[WME] ::::: component name :::::", component_name)
    try:
        wmelistfreertosincymbol = bleConfigComp.createFileSymbol('WME_SYS_HOOKS_INC', None)
        print("::::::::WME BLE COMPONENT FREERTOS TESTING ::::::: ", wmelistfreertosincymbol)
        wmelistfreertosincymbol.setType("STRING")
        wmelistfreertosincymbol.setOutputName("FreeRTOS.LIST_FREERTOS_HOOKS_C_INCLUDES")
        wmelistfreertosincymbol.setSourcePath("services/ble/ble_config/src/templates/wme_freertos_hook_include.c.ftl")
        wmelistfreertosincymbol.setMarkup(True)
    except Exception as e:
        print("::::::::ERROR on SYMBOL CREATION FILE LIST_FREERTOS_HOOKS_C_INCLUDES::::::: : %s" %(e))
    
    try:
        wmelistfreertosidletaskymbol = bleConfigComp.createFileSymbol('WME_SYS_HOOKS_IDLE_TASKS', None)
        print("::::::::WME BLE COMPONENT FREERTOS TESTING ::::::: ", wmelistfreertosidletaskymbol)
        wmelistfreertosidletaskymbol.setType("STRING")
        wmelistfreertosidletaskymbol.setOutputName("FreeRTOS.LIST_FREERTOS_HOOKS_C_CALL_APP_IDLE_TASKS")
        wmelistfreertosidletaskymbol.setSourcePath("services/ble/ble_config/src/templates/wme_freertos_idle_task.c.ftl")
        wmelistfreertosidletaskymbol.setMarkup(True)
    except Exception as e:
        print("::::::::ERROR on SYMBOL CREATION FILE LIST_FREERTOS_HOOKS_C_CALL_APP_IDLE_TASKS::::::: : %s" %(e))

    try:
        wmelistfreertosticktaskymbol = bleConfigComp.createFileSymbol('WME_SYS_HOOKS_TICK_TASKS', None)
        print("::::::::WME BLE COMPONENT FREERTOS TESTING ::::::: ", wmelistfreertosticktaskymbol)
        wmelistfreertosticktaskymbol.setType("STRING")
        wmelistfreertosticktaskymbol.setOutputName("FreeRTOS.LIST_FREERTOS_HOOKS_C_CALL_APP_TICK_TASKS")
        wmelistfreertosticktaskymbol.setSourcePath("services/ble/ble_config/src/templates/wls_ble_freertos_tick_task.c.ftl")
        wmelistfreertosticktaskymbol.setMarkup(True)
    except Exception as e:
        print("::::::::ERROR on SYMBOL CREATION FILE LIST_FREERTOS_HOOKS_C_CALL_APP_TICK_TASKS::::::: : %s" %(e))    

    try:
        wmelistsystemconfigsymbol = bleConfigComp.createFileSymbol('LIST_SYMBOL_CONFIG_H', None)
        print("::::::::WME BLE COMPONENT FREERTOS TESTING ::::::: ", wmelistsystemconfigsymbol)
        wmelistsystemconfigsymbol.setType("STRING")
        wmelistsystemconfigsymbol.setOutputName("core.LIST_SYSTEM_CONFIG_H_APPLICATION_CONFIGURATION")
        wmelistsystemconfigsymbol.setSourcePath("services/ble/ble_config/src/templates/wme_system_config_h.c.ftl")
        wmelistsystemconfigsymbol.setMarkup(True)
    except Exception as e:
        print("::::::::ERROR on SYMBOL CREATION FILE LIST_SYSTEM_CONFIG_H_APPLICATION_CONFIGURATION::::::: : %s" %(e))    
    try:
        wmebleadvanceappAppLedSourcefile = bleConfigComp.createFileSymbol(None, None)
        wmebleadvanceappAppLedSourcefile.setSourcePath('services/ble/ble_config/src/templates/app_led.c.ftl')
        wmebleadvanceappAppLedSourcefile.setOutputName('app_led.c')
        wmebleadvanceappAppLedSourcefile.setOverwrite(True)
        wmebleadvanceappAppLedSourcefile.setDestPath('../../')
        wmebleadvanceappAppLedSourcefile.setType('SOURCE')
        wmebleadvanceappAppLedSourcefile.setMarkup(True)
        wmebleadvanceappAppLedSourcefile.setEnabled(False)

        # Define the dependencies
        dependencies_led = ["PROFILE_ANP.ANP_BOOL_CLIENT", "PROFILE_HOGP.HOGP_BOOL_SERVER", "PROFILE_ANCS.ANCS_BOOL_CLIENT", "PROFILE_ANP.ANP_BOOL_SERVER", "PROFILE_PXP.PXP_BOOL_SERVER", "PROFILE_PXP.PXP_BOOL_CLIENT", "BLE_STACK_LIB.BOOL_L2CAP_CREDIT_FLOWCTRL"]

        # Set the dependencies for the file symbol
        wmebleadvanceappAppLedSourcefile.setDependencies(wmebleLedEnable, dependencies_led)
        print ("[WME] ::::: Generating app_led.c file ::::::::::::::::::::")
    except Exception as e:
        print("ERROR on  Generating app_led.c file : %s" %(e))
    try:
        wmebleadvanceAppLedHeaderfile = bleConfigComp.createFileSymbol(None, None)
        wmebleadvanceAppLedHeaderfile.setSourcePath('services/ble/ble_config/src/templates/app_led.h.ftl')
        wmebleadvanceAppLedHeaderfile.setOutputName('app_led.h')
        wmebleadvanceAppLedHeaderfile.setOverwrite(True)
        wmebleadvanceAppLedHeaderfile.setDestPath('../../')
        wmebleadvanceAppLedHeaderfile.setType('HEADER')
        wmebleadvanceAppLedHeaderfile.setMarkup(True)
        wmebleadvanceAppLedHeaderfile.setEnabled(False)
        # Define the dependencies
        # dependencies_led = ["PROFILE_ANP.ANP_BOOL_CLIENT", "PROFILE_HOGP.HOGP_BOOL_SERVER", "PROFILE_ANCS.ANCS_BOOL_CLIENT", "PROFILE_ANP.ANP_BOOL_SERVER", "PROFILE_PXP.PXP_BOOL_SERVER", "PROFILE_PXP.PXP_BOOL_CLIENT", "BLE_STACK_LIB.BOOL_L2CAP_CREDIT_FLOWCTRL"]

        # Set the dependencies for the file symbol
        wmebleadvanceAppLedHeaderfile.setDependencies(wmebleLedEnable, dependencies_led)
        print ("[WME] ::::: Generating app_led.h file ::::::::::::::::::::")
    except Exception as e:
        print("ERROR on  Generating app_led.c file : %s" %(e))

    try:
        wmebleadvanceAppKeySourcefile =  bleConfigComp.createFileSymbol(None, None)
        wmebleadvanceAppKeySourcefile.setSourcePath('services/ble/ble_config/src/templates/app_key.c.ftl')
        wmebleadvanceAppKeySourcefile.setOutputName('app_key.c')
        wmebleadvanceAppKeySourcefile.setOverwrite(True)
        wmebleadvanceAppKeySourcefile.setDestPath('../../')
        #wmebleadvanceAppKeySourcefile.setProjectPath('')
        wmebleadvanceAppKeySourcefile.setType('SOURCE')
        wmebleadvanceAppKeySourcefile.setMarkup(True)
        wmebleadvanceAppKeySourcefile.setEnabled(False)
        # Define the dependencies
        dependencies_key = ["booleanappcode", "PROFILE_ANP.ANP_BOOL_CLIENT", "PROFILE_HOGP.HOGP_BOOL_SERVER", "PROFILE_ANCS.ANCS_BOOL_CLIENT", "PROFILE_ANP.ANP_BOOL_SERVER", "PROFILE_PXP.PXP_BOOL_SERVER", "PROFILE_PXP.PXP_BOOL_CLIENT"]

        # Set the dependencies for the file symbol
        wmebleadvanceAppKeySourcefile.setDependencies(wmeblekeyEnable, dependencies_key)

        print ("[WME] ::::: Generating app_key.c file ::::::::::::::::::::")
    except Exception as e:
        print("ERROR on  Generating app_led.c file : %s" %(e))

    try:
        wmebleadvanceAppKeyHeaderfile = bleConfigComp.createFileSymbol(None, None)
        wmebleadvanceAppKeyHeaderfile.setSourcePath('services/ble/ble_config/src/templates/app_key.h.ftl')
        wmebleadvanceAppKeyHeaderfile.setOutputName('app_key.h')
        wmebleadvanceAppKeyHeaderfile.setOverwrite(True)
        wmebleadvanceAppKeyHeaderfile.setDestPath('../../')
        wmebleadvanceAppKeyHeaderfile.setType('HEADER')
        wmebleadvanceAppKeyHeaderfile.setMarkup(True)
        wmebleadvanceAppKeyHeaderfile.setEnabled(False)
        # Define the dependencies
        # dependencies_key = [ "booleanappcode", "PROFILE_ANP.ANP_BOOL_CLIENT", "PROFILE_HOGP.HOGP_BOOL_SERVER", "PROFILE_ANCS.ANCS_BOOL_CLIENT", "PROFILE_ANP.ANP_BOOL_SERVER", "PROFILE_PXP.PXP_BOOL_SERVER", "PROFILE_PXP.PXP_BOOL_CLIENT"]

        # Set the dependencies for the file symbol
        wmebleadvanceAppKeyHeaderfile.setDependencies(wmeblekeyEnable, dependencies_key)

        print ("[WME] ::::: Generating app_key.h file ::::::::::::::::::::")
    except Exception as e:
        print("ERROR on  Generating app_led.c file : %s" %(e))

    try:
        wmebleadvanceAppTimersourcefile = bleConfigComp.createFileSymbol(None, None)
        wmebleadvanceAppTimersourcefile.setSourcePath('services/ble/ble_config/src/templates/app_timer.c.ftl')
        wmebleadvanceAppTimersourcefile.setOutputName('app_timer.c')
        wmebleadvanceAppTimersourcefile.setOverwrite(True)
        wmebleadvanceAppTimersourcefile.setDestPath('../../')
        wmebleadvanceAppTimersourcefile.setType('SOURCE')
        wmebleadvanceAppTimersourcefile.setMarkup(True)
        wmebleadvanceAppTimersourcefile.setEnabled(False)
        dependencies_timer = ["PROFILE_ANP.ANP_BOOL_CLIENT", "PROFILE_HOGP.HOGP_BOOL_SERVER", "PROFILE_ANCS.ANCS_BOOL_CLIENT", "PROFILE_ANP.ANP_BOOL_SERVER", "PROFILE_PXP.PXP_BOOL_SERVER", "PROFILE_PXP.PXP_BOOL_CLIENT", "BLE_STACK_LIB.BOOL_L2CAP_CREDIT_FLOWCTRL"]

        # Set the dependencies for the file symbol
        wmebleadvanceAppTimersourcefile.setDependencies(wmebleTimerEnable, dependencies_timer)
        print ("[WME] ::::: Generating app_timer.c file ::::::::::::::::::::")
    except Exception as e:
        print("ERROR on  Generating app_timer.c file : %s" %(e))
    try:
        wmebleadvanceAppTimerHeaderfile = bleConfigComp.createFileSymbol(None, None)
        wmebleadvanceAppTimerHeaderfile.setSourcePath('services/ble/ble_config/src/templates/app_timer.h.ftl')
        wmebleadvanceAppTimerHeaderfile.setOutputName('app_timer.h')
        wmebleadvanceAppTimerHeaderfile.setOverwrite(True)
        wmebleadvanceAppTimerHeaderfile.setDestPath('../../')
        wmebleadvanceAppTimerHeaderfile.setType('HEADER')
        wmebleadvanceAppTimerHeaderfile.setMarkup(True)
        wmebleadvanceAppTimerHeaderfile.setEnabled(False)
        wmebleadvanceAppTimerHeaderfile.setDependencies(wmebleTimerEnable, dependencies_timer)
        print ("[WME] ::::: Generating app_timer.h file ::::::::::::::::::::")
    except Exception as e:
        print("ERROR on  Generating app_timer.h file : %s" %(e))
    try:
        wmebleadvanceAppErrorDefHeaderfile = bleConfigComp.createFileSymbol(None, None)
        wmebleadvanceAppErrorDefHeaderfile.setSourcePath('services/ble/ble_config/src/templates/app_error_defs.h.ftl')
        wmebleadvanceAppErrorDefHeaderfile.setOutputName('app_error_defs.h')
        wmebleadvanceAppErrorDefHeaderfile.setOverwrite(True)
        wmebleadvanceAppErrorDefHeaderfile.setDestPath('../../')
        wmebleadvanceAppErrorDefHeaderfile.setType('HEADER')
        wmebleadvanceAppErrorDefHeaderfile.setMarkup(True)
        wmebleadvanceAppErrorDefHeaderfile.setEnabled(False)
        dependencies_error_defs = ["PROFILE_ANP.ANP_BOOL_CLIENT", "PROFILE_HOGP.HOGP_BOOL_SERVER", "PROFILE_ANCS.ANCS_BOOL_CLIENT", "PROFILE_ANP.ANP_BOOL_SERVER", "PROFILE_PXP.PXP_BOOL_SERVER", "PROFILE_PXP.PXP_BOOL_CLIENT", "BLE_STACK_LIB.BOOL_L2CAP_CREDIT_FLOWCTRL"]

        # Set the dependencies for the file symbol
        wmebleadvanceAppErrorDefHeaderfile.setDependencies(wmebleError_defsEnable, dependencies_error_defs)
    except Exception as e:
        print("ERROR on  Generating app_error_defs.h file : %s" %(e))
    # try:
    #     wmebleadvanceAppModulesourcefile = bleConfigComp.createFileSymbol(None, None)
    #     wmebleadvanceAppModulesourcefile.setSourcePath('services/ble/ble_config/src/templates/app_module.c.ftl')
    #     wmebleadvanceAppModulesourcefile.setOutputName('app_module.c')
    #     wmebleadvanceAppModulesourcefile.setOverwrite(True)
    #     wmebleadvanceAppModulesourcefile.setDestPath('../../')
    #     wmebleadvanceAppModulesourcefile.setType('SOURCE')
    #     wmebleadvanceAppModulesourcefile.setMarkup(True)
    #     wmebleadvanceAppModulesourcefile.setEnabled(False)
    #     dependencies_module = [ "PROFILE_HOGP.HOGP_BOOL_SERVER", "PROFILE_ANCS.ANCS_BOOL_CLIENT"]

    #     # Set the dependencies for the file symbol
    #     wmebleadvanceAppModulesourcefile.setDependencies(wmebleModuleEnable, dependencies_module)
    #     print ("[WME] ::::: Generating app_module.c file ::::::::::::::::::::")

    #     wmebleadvanceAppModuleHeaderfile = bleConfigComp.createFileSymbol(None, None)
    #     wmebleadvanceAppModuleHeaderfile.setSourcePath('services/ble/ble_config/src/templates/app_module.h.ftl')
    #     wmebleadvanceAppModuleHeaderfile.setOutputName('app_module.h')
    #     wmebleadvanceAppModuleHeaderfile.setOverwrite(True)
    #     wmebleadvanceAppModuleHeaderfile.setDestPath('../../')
    #     wmebleadvanceAppModuleHeaderfile.setType('HEADER')
    #     wmebleadvanceAppModuleHeaderfile.setMarkup(True)
    #     wmebleadvanceAppModuleHeaderfile.setEnabled(False)
    #     wmebleadvanceAppModuleHeaderfile.setDependencies(wmebleModuleEnable, dependencies_module)
    #     print ("[WME] ::::: Generating app_module.h file ::::::::::::::::::::")

    # except Exception as e:
    #     print("ERROR on  Generating app_error_defs.h file : %s" %(e))

    try:
        # wlsbleappPxprHeaderfile = bleConfigComp.createFileSymbol(None, None)
        # wlsbleappPxprHeaderfile.setSourcePath('services/ble/ble_config/src/templates/pxpr/app_pxpr.h.ftl')
        # wlsbleappPxprHeaderfile.setOutputName('app_pxpr.h')
        # wlsbleappPxprHeaderfile.setOverwrite(True)
        # wlsbleappPxprHeaderfile.setDestPath('../../')
        # wlsbleappPxprHeaderfile.setType('HEADER')
        # wlsbleappPxprHeaderfile.setMarkup(True)
        # wlsbleappPxprHeaderfile.setEnabled(False)
        # # symbol.setEnabled(False)
        # wlsbleappPxprHeaderfile.setDependencies(wmeblePxprEnable, ["PROFILE_PXP.PXP_BOOL_SERVER"])

        # wlsbleAppPxprSourcefile = bleConfigComp.createFileSymbol(None, None)
        # wlsbleAppPxprSourcefile.setSourcePath('services/ble/ble_config/src/templates/pxpr/app_pxpr.c.ftl')
        # wlsbleAppPxprSourcefile.setOutputName('app_pxpr.c')
        # wlsbleAppPxprSourcefile.setOverwrite(True)
        # wlsbleAppPxprSourcefile.setDestPath('../../')
        # #wlsbleAppPxprSourcefile.setProjectPath('app_ble')
        # wlsbleAppPxprSourcefile.setType('SOURCE')
        # wlsbleAppPxprSourcefile.setMarkup(True)
        # wlsbleAppPxprSourcefile.setEnabled(False)
        # wlsbleAppPxprSourcefile.setDependencies(wmeblePxprEnable, ["PROFILE_PXP.PXP_BOOL_SERVER"])
        # print ("[WME] ::::: Generating app_pxpr_handler.c file ::::::::::::::::::::")

        wmebleadvanceAppConnSourcefile = bleConfigComp.createFileSymbol(None, None)
        wmebleadvanceAppConnSourcefile.setSourcePath('services/ble/ble_config/src/templates/hogp/app_conn.c.ftl')
        wmebleadvanceAppConnSourcefile.setOutputName('app_conn.c')
        wmebleadvanceAppConnSourcefile.setOverwrite(True)
        wmebleadvanceAppConnSourcefile.setDestPath('../../')
        wmebleadvanceAppConnSourcefile.setType('SOURCE')
        wmebleadvanceAppConnSourcefile.setMarkup(True)
        wmebleadvanceAppConnSourcefile.setEnabled(False)
        wmebleadvanceAppConnSourcefile.setDependencies(wmebleHogpEnable, ["PROFILE_HOGP.HOGP_BOOL_SERVER"])
        print ("[WME] ::::: Generating app_conn.c file ::::::::::::::::::::")

        wmebleadvanceAppConnHeaderfile = bleConfigComp.createFileSymbol(None, None)
        wmebleadvanceAppConnHeaderfile.setSourcePath('services/ble/ble_config/src/templates/hogp/app_conn.h.ftl')
        wmebleadvanceAppConnHeaderfile.setOutputName('app_conn.h')
        wmebleadvanceAppConnHeaderfile.setOverwrite(True)
        wmebleadvanceAppConnHeaderfile.setDestPath('../../')
        wmebleadvanceAppConnHeaderfile.setType('HEADER')
        wmebleadvanceAppConnHeaderfile.setMarkup(True)
        wmebleadvanceAppConnHeaderfile.setEnabled(False)
        wmebleadvanceAppConnHeaderfile.setDependencies(wmebleHogpEnable, ["PROFILE_HOGP.HOGP_BOOL_SERVER"])
        print ("[WME] ::::: Generating app_conn.h file ::::::::::::::::::::")

        # wlsbleAppAnpcSourceFile = bleConfigComp.createFileSymbol(None, None)
        # wlsbleAppAnpcSourceFile.setSourcePath('services/ble/ble_config/src/templates/anpc/app_anpc.c.ftl')
        # wlsbleAppAnpcSourceFile.setOutputName('app_anpc.c')
        # wlsbleAppAnpcSourceFile.setOverwrite(True)
        # wlsbleAppAnpcSourceFile.setDestPath('../../')
        # wlsbleAppAnpcSourceFile.setType('SOURCE')
        # wlsbleAppAnpcSourceFile.setMarkup(True)
        # wlsbleAppAnpcSourceFile.setEnabled(False)
        # wlsbleAppAnpcSourceFile.setDependencies(wmebleAnpcEnable, ["PROFILE_ANP.ANP_BOOL_CLIENT"])
        # print ("[WME] ::::: Generating app_anpc.c file ::::::::::::::::::::")




        # wlsbleAppAnpcHeaderFile = bleConfigComp.createFileSymbol(None, None)
        # wlsbleAppAnpcHeaderFile.setSourcePath('services/ble/ble_config/src/templates/anpc/app_anpc.h.ftl')
        # wlsbleAppAnpcHeaderFile.setOutputName('app_anpc.h')
        # wlsbleAppAnpcHeaderFile.setOverwrite(True)
        # wlsbleAppAnpcHeaderFile.setDestPath('../../')
        # wlsbleAppAnpcHeaderFile.setType('HEADER')
        # wlsbleAppAnpcHeaderFile.setMarkup(True)
        # wlsbleAppAnpcHeaderFile.setEnabled(False)
        # wlsbleAppAnpcHeaderFile.setDependencies(wmebleAnpcEnable, ["PROFILE_ANP.ANP_BOOL_CLIENT"])
        # print ("[WME] ::::: Generating app_anpc.h file ::::::::::::::::::::")


    except Exception as e:
        exc_type, exc_obj, exc_tb = sys.exc_info()
        print ("%s Error on line number : %s : %s" %(fn, exc_tb.tb_lineno, e))



    try:
        # device_info_component = Database.getComponentByID("SERVICE_DIS")
        # if (device_info_component != None):
        # wlsbleBlethroughputAppAdvSourcefile = bleConfigComp.createFileSymbol(None, None)
        # wlsbleBlethroughputAppAdvSourcefile.setSourcePath('services/ble/ble_config/src/templates/ble_throughput/app_adv.c.ftl')
        # wlsbleBlethroughputAppAdvSourcefile.setOutputName('app_adv.c')
        # wlsbleBlethroughputAppAdvSourcefile.setOverwrite(True)
        # wlsbleBlethroughputAppAdvSourcefile.setDestPath('../../')
        # wlsbleBlethroughputAppAdvSourcefile.setType('SOURCE')
        # wlsbleBlethroughputAppAdvSourcefile.setMarkup(True)
        # wlsbleBlethroughputAppAdvSourcefile.setEnabled(False)
        # wlsbleBlethroughputAppAdvSourcefile.setDependencies(wmebleThroughputEnable, ["BLE_STACK_LIB.BOOL_L2CAP_CREDIT_FLOWCTRL"])
        # print ("[WME] ::::: Generating app_adv.c file ::::::::::::::::::::")

        
        wlsbleBlethroughputAppTrpCommomSourcefile = bleConfigComp.createFileSymbol(None, None)
        wlsbleBlethroughputAppTrpCommomSourcefile.setSourcePath('services/ble/ble_config/src/templates/ble_throughput/app_trp_common.c.ftl')
        wlsbleBlethroughputAppTrpCommomSourcefile.setOutputName('app_trp_common.c')
        wlsbleBlethroughputAppTrpCommomSourcefile.setOverwrite(True)
        wlsbleBlethroughputAppTrpCommomSourcefile.setDestPath('../../')
        wlsbleBlethroughputAppTrpCommomSourcefile.setType('SOURCE')
        wlsbleBlethroughputAppTrpCommomSourcefile.setMarkup(True)
        wlsbleBlethroughputAppTrpCommomSourcefile.setEnabled(False)
        wlsbleBlethroughputAppTrpCommomSourcefile.setDependencies(wmebleThroughputEnable, ["BLE_STACK_LIB.BOOL_L2CAP_CREDIT_FLOWCTRL"])
        print ("[WME] ::::: Generating app_trp_common.c file ::::::::::::::::::::")

        # wlsbleBlethroughputAppTrpsSourcefile = bleConfigComp.createFileSymbol(None, None)
        # wlsbleBlethroughputAppTrpsSourcefile.setSourcePath('services/ble/ble_config/src/templates/ble_throughput/app_trps.c.ftl')
        # wlsbleBlethroughputAppTrpsSourcefile.setOutputName('app_trps.c')
        # wlsbleBlethroughputAppTrpsSourcefile.setOverwrite(True)
        # wlsbleBlethroughputAppTrpsSourcefile.setDestPath('../../')
        # wlsbleBlethroughputAppTrpsSourcefile.setType('SOURCE')
        # wlsbleBlethroughputAppTrpsSourcefile.setMarkup(True)
        # wlsbleBlethroughputAppTrpsSourcefile.setEnabled(False)
        # wlsbleBlethroughputAppTrpsSourcefile.setDependencies(wmebleThroughputEnable, ["BLE_STACK_LIB.BOOL_L2CAP_CREDIT_FLOWCTRL"])
        # print ("[WME] ::::: Generating app_trps.c file ::::::::::::::::::::")

        # wlsbleBlethroughputAppUtilitySourcefile = bleConfigComp.createFileSymbol(None, None)
        # wlsbleBlethroughputAppUtilitySourcefile.setSourcePath('services/ble/ble_config/src/templates/ble_throughput/app_utility.c.ftl')
        # wlsbleBlethroughputAppUtilitySourcefile.setOutputName('app_utility.c')
        # wlsbleBlethroughputAppUtilitySourcefile.setOverwrite(True)
        # wlsbleBlethroughputAppUtilitySourcefile.setDestPath('../../')
        # wlsbleBlethroughputAppUtilitySourcefile.setType('SOURCE')
        # wlsbleBlethroughputAppUtilitySourcefile.setMarkup(True)
        # wlsbleBlethroughputAppUtilitySourcefile.setEnabled(False)
        # wlsbleBlethroughputAppUtilitySourcefile.setDependencies(wmebleThroughputEnable, ["BLE_STACK_LIB.BOOL_L2CAP_CREDIT_FLOWCTRL"])
        # print ("[WME] ::::: Generating app_utility.c file ::::::::::::::::::::")


        # wlsbleBlethroughputAppAdvHeaderfile = bleConfigComp.createFileSymbol(None, None)
        # wlsbleBlethroughputAppAdvHeaderfile.setSourcePath('services/ble/ble_config/src/templates/ble_throughput/app_adv.h.ftl')
        # wlsbleBlethroughputAppAdvHeaderfile.setOutputName('app_adv.h')
        # wlsbleBlethroughputAppAdvHeaderfile.setOverwrite(True)
        # wlsbleBlethroughputAppAdvHeaderfile.setDestPath('../../')
        # wlsbleBlethroughputAppAdvHeaderfile.setType('HEADER')
        # wlsbleBlethroughputAppAdvHeaderfile.setMarkup(True)
        # wlsbleBlethroughputAppAdvHeaderfile.setEnabled(False)
        # wlsbleBlethroughputAppAdvHeaderfile.setDependencies(wmebleThroughputEnable, ["BLE_STACK_LIB.BOOL_L2CAP_CREDIT_FLOWCTRL"])
        # print ("[WME] ::::: Generating app_adv.h file ::::::::::::::::::::")


        wlsbleBlethroughputAppTrpCommomHeaderfile = bleConfigComp.createFileSymbol(None, None)
        wlsbleBlethroughputAppTrpCommomHeaderfile.setSourcePath('services/ble/ble_config/src/templates/ble_throughput/app_trp_common.h.ftl')
        wlsbleBlethroughputAppTrpCommomHeaderfile.setOutputName('app_trp_common.h')
        wlsbleBlethroughputAppTrpCommomHeaderfile.setOverwrite(True)
        wlsbleBlethroughputAppTrpCommomHeaderfile.setDestPath('../../')
        wlsbleBlethroughputAppTrpCommomHeaderfile.setType('HEADER')
        wlsbleBlethroughputAppTrpCommomHeaderfile.setMarkup(True)
        wlsbleBlethroughputAppTrpCommomHeaderfile.setEnabled(False)
        wlsbleBlethroughputAppTrpCommomHeaderfile.setDependencies(wmebleThroughputEnable, ["BLE_STACK_LIB.BOOL_L2CAP_CREDIT_FLOWCTRL"])
        print ("[WME] ::::: Generating app_trp_common.h file ::::::::::::::::::::")

        # wlsbleBlethroughputAppTrpsHeaderfile = bleConfigComp.createFileSymbol(None, None)
        # wlsbleBlethroughputAppTrpsHeaderfile.setSourcePath('services/ble/ble_config/src/templates/ble_throughput/app_trps.h.ftl')
        # wlsbleBlethroughputAppTrpsHeaderfile.setOutputName('app_trps.h')
        # wlsbleBlethroughputAppTrpsHeaderfile.setOverwrite(True)
        # wlsbleBlethroughputAppTrpsHeaderfile.setDestPath('../../')
        # wlsbleBlethroughputAppTrpsHeaderfile.setType('HEADER')
        # wlsbleBlethroughputAppTrpsHeaderfile.setMarkup(True)
        # wlsbleBlethroughputAppTrpsHeaderfile.setEnabled(False)
        # wlsbleBlethroughputAppTrpsHeaderfile.setDependencies(wmebleThroughputEnable, ["BLE_STACK_LIB.BOOL_L2CAP_CREDIT_FLOWCTRL"])
        # print ("[WME] ::::: Generating app_trps.h file ::::::::::::::::::::")

            
        # wlsbleBlethroughputAppUtilityHeaderfile = bleConfigComp.createFileSymbol(None, None)
        # wlsbleBlethroughputAppUtilityHeaderfile.setSourcePath('services/ble/ble_config/src/templates/ble_throughput/app_utility.h.ftl')
        # wlsbleBlethroughputAppUtilityHeaderfile.setOutputName('app_utility.h')
        # wlsbleBlethroughputAppUtilityHeaderfile.setOverwrite(True)
        # wlsbleBlethroughputAppUtilityHeaderfile.setDestPath('../../')
        # wlsbleBlethroughputAppUtilityHeaderfile.setType('HEADER')
        # wlsbleBlethroughputAppUtilityHeaderfile.setMarkup(True)
        # wlsbleBlethroughputAppUtilityHeaderfile.setEnabled(False)
        # wlsbleBlethroughputAppUtilityHeaderfile.setDependencies(wmebleThroughputEnable, ["BLE_STACK_LIB.BOOL_L2CAP_CREDIT_FLOWCTRL"])
        # print ("[WME] ::::: Generating app_utility.h file ::::::::::::::::::::")
    except Exception as e:
        print("ERROR on instantiateComponent : %s" %(e))

    # try:
    #     wlsbleAppAnpsSourcefile = bleConfigComp.createFileSymbol(None, None)
    #     wlsbleAppAnpsSourcefile.setSourcePath('services/ble/ble_config/src/templates/anps/app_anps.c.ftl')
    #     wlsbleAppAnpsSourcefile.setOutputName('app_anps.c')
    #     wlsbleAppAnpsSourcefile.setOverwrite(True)
    #     wlsbleAppAnpsSourcefile.setDestPath('../../')
    #     wlsbleAppAnpsSourcefile.setType('SOURCE')
    #     wlsbleAppAnpsSourcefile.setMarkup(True)
    #     wlsbleAppAnpsSourcefile.setEnabled(False)
    #     wlsbleAppAnpsSourcefile.setDependencies(wmebleAnpsEnable, ["PROFILE_ANP.ANP_BOOL_SERVER"])
    #     print ("[WME] ::::: Generating app_anps.c file ::::::::::::::::::::")

    #     wlsbleAppAnpsHeaderfile = bleConfigComp.createFileSymbol(None, None)
    #     wlsbleAppAnpsHeaderfile.setSourcePath('services/ble/ble_config/src/templates/anps/app_anps.h.ftl')
    #     wlsbleAppAnpsHeaderfile.setOutputName('app_anps.h')
    #     wlsbleAppAnpsHeaderfile.setOverwrite(True)
    #     wlsbleAppAnpsHeaderfile.setDestPath('../../')
    #     wlsbleAppAnpsHeaderfile.setType('HEADER')
    #     wlsbleAppAnpsHeaderfile.setMarkup(True)
    #     wlsbleAppAnpsHeaderfile.setEnabled(False)
    #     wlsbleAppAnpsHeaderfile.setDependencies(wmebleAnpsEnable, ["PROFILE_ANP.ANP_BOOL_SERVER"])
    #     print ("[WME] ::::: Generating app_timer.h file ::::::::::::::::::::")
    
    # except Exception as e:
    #         exc_type, exc_obj, exc_tb = sys.exc_info()
    #         print ("%s Error on line number : %s : %s" %(fn, exc_tb.tb_lineno, e))

    # try:
    #     wlsbleappPxpmSourcefile = bleConfigComp.createFileSymbol(None, None)
    #     wlsbleappPxpmSourcefile.setSourcePath('services/ble/ble_config/src/templates/pxpm/app_pxpm.c.ftl')
    #     wlsbleappPxpmSourcefile.setOutputName('app_pxpm.c')
    #     wlsbleappPxpmSourcefile.setOverwrite(True)
    #     wlsbleappPxpmSourcefile.setDestPath('../../')
    #     wlsbleappPxpmSourcefile.setType('SOURCE')
    #     wlsbleappPxpmSourcefile.setMarkup(True)
    #     wlsbleappPxpmSourcefile.setEnabled(False)
    #     wlsbleappPxpmSourcefile.setDependencies(wmeblePxpmEnable, ["PROFILE_PXP.PXP_BOOL_CLIENT"])
    #     print ("[WME] ::::: Generating app_pxpm.c file ::::::::::::::::::::")

    #     wlsbleappPxpmHeaderfile = bleConfigComp.createFileSymbol(None, None)
    #     wlsbleappPxpmHeaderfile.setSourcePath('services/ble/ble_config/src/templates/pxpm/app_pxpm.h.ftl')
    #     wlsbleappPxpmHeaderfile.setOutputName('app_pxpm.h')
    #     wlsbleappPxpmHeaderfile.setOverwrite(True)
    #     wlsbleappPxpmHeaderfile.setDestPath('../../')
    #     wlsbleappPxpmHeaderfile.setType('HEADER')
    #     wlsbleappPxpmHeaderfile.setMarkup(True)
    #     wlsbleappPxpmHeaderfile.setEnabled(False)
    #     wlsbleappPxpmHeaderfile.setDependencies(wmeblePxpmEnable, ["PROFILE_PXP.PXP_BOOL_CLIENT"])
    #     print ("[WME] ::::: Generating app_pxpm.h file ::::::::::::::::::::")

            
    # except Exception as e:
    #     exc_type, exc_obj, exc_tb = sys.exc_info()
    #     print ("%s Error on line number : %s : %s" %(fn, exc_tb.tb_lineno, e))



    # integration from here 

    wlsCallbackSourceFile = bleConfigComp.createFileSymbol(None, None)
    wlsCallbackSourceFile.setSourcePath("services/ble/ble_config/src/templates/callbacks/app_ble_callbacks.c.ftl")
    wlsCallbackSourceFile.setOutputName("app_ble_callbacks.c")
    wlsCallbackSourceFile.setDestPath('../../app_ble')
    wlsCallbackSourceFile.setOverwrite(True)
    wlsCallbackSourceFile.setProjectPath('app_ble')
    wlsCallbackSourceFile.setType('SOURCE')      
    wlsCallbackSourceFile.setEnabled(True)
    wlsCallbackSourceFile.setMarkup(True)

 
    wlsCallbackHeaderFile = bleConfigComp.createFileSymbol(None, None)
    wlsCallbackHeaderFile.setSourcePath("services/ble/ble_config/src/templates/callbacks/app_ble_callbacks.h.ftl")
    wlsCallbackHeaderFile.setOutputName("app_ble_callbacks.h")
    wlsCallbackHeaderFile.setDestPath('../../app_ble')
    wlsCallbackHeaderFile.setProjectPath('app_ble')
    wlsCallbackHeaderFile.setType('HEADER')
    wlsCallbackHeaderFile.setMarkup(True)
    wlsCallbackHeaderFile.setOverwrite(True)
    wlsCallbackHeaderFile.setEnabled(True)
 
    # BLE handler
    wlsHandlerSourceFile = bleConfigComp.createFileSymbol(None, None)
    wlsHandlerSourceFile.setSourcePath("services/ble/ble_config/src/templates/handlers/app_ble_handler.c.ftl")
    wlsHandlerSourceFile.setOutputName("app_ble_handler.c")
    wlsHandlerSourceFile.setDestPath('../../app_ble/handlers')
    wlsHandlerSourceFile.setProjectPath('app_ble/handlers')
    wlsHandlerSourceFile.setType('SOURCE')
    wlsHandlerSourceFile.setMarkup(True)
    wlsHandlerSourceFile.setOverwrite(True)
    wlsHandlerSourceFile.setEnabled(True)

    wlsblehandlerincludelist = bleConfigComp.createListSymbol("LIST_BLE_HANDLER_APP_INCLUDE", None)
    wlsblehandlergattlist = bleConfigComp.createListSymbol("LIST_GATT_EVT_HANDLER_APP_HANDLER", None)
    wlsblehandlergaplist = bleConfigComp.createListSymbol("LIST_GAP_EVT_HANDLER_APP_HANDLER", None)
   
    # Add app.c
    wlsappSourceFile = bleConfigComp.createFileSymbol("WLS_DEVICE_APP_C", None)
    wlsappSourceFile.setSourcePath('services/ble/ble_config/src/templates/app.c.ftl')
    wlsappSourceFile.setOutputName('app.c')
    wlsappSourceFile.setOverwrite(True)
    wlsappSourceFile.setDestPath('../../')
    wlsappSourceFile.setProjectPath('')
    wlsappSourceFile.setType('SOURCE')
    wlsappSourceFile.setEnabled(True)
    wlsappSourceFile.setMarkup(True)

    wlsbleappSourcefileIncludeList =  bleConfigComp.createListSymbol("WLS_BLE_LIST_DEV_SUPP_INCLUDE_C", None)
    wlsbleappSourcefileDataList =  bleConfigComp.createListSymbol("WLS_BLE_LIST_DEV_SUPP_DATA_C", None)
    wlsbleappSourcefileInitList =  bleConfigComp.createListSymbol("WLS_BLE_LIST_DEV_SUPP_INIT_C", None)
    wlsbleappSourcefileAppEntryList =  bleConfigComp.createListSymbol("WLS_BLE_LIST_DEV_SUPP_APP_ENTRY_C", None)
    wlsbleappSourcefileTaskEntryList =  bleConfigComp.createListSymbol("WLS_BLE_LIST_DEV_SUPP_TASK_ENTRY_C", None)
    wlsbleappSourcefileFunctionCallbackList =  bleConfigComp.createListSymbol("WLS_BLE_LIST_DEV_SUPP_CB_FUNC_C", None)
    wlsblekeyfuncshortpresslist = bleConfigComp.createListSymbol("WLS_BLE_APP_KEY_MSG_SHORT_PRESS", None)
    wlsblekeyfunclongpresslist = bleConfigComp.createListSymbol("WLS_BLE_APP_KEY_MSG_LONG_PRESS", None)
    wlsblekeyfunclongdoubleclick = bleConfigComp.createListSymbol("WLS_BLE_APP_KEY_MSG_DOUBLE_CLICK", None)

    try: 
        print(":::::::::::::::::::starting wme file symbol for WLS_BLE_LIST_DEV_SUPP_INCLUDE_C ::::::::::::::::::::::")
        wmesymbol_appinclude = bleConfigComp.createFileSymbol('WME_SYS_SUPP_INCLUDE', None)
        wmesymbol_appinclude.setType("STRING")
        wmesymbol_appinclude.setOutputName("wlsbleconfig.WLS_BLE_LIST_DEV_SUPP_INCLUDE_C")
        wmesymbol_appinclude.setSourcePath("services/ble/ble_config/src/templates/wme_include.c.ftl")
        wmesymbol_appinclude.setMarkup(True)
    except Exception as e:
        print("ERROR on SYMBOL CREATION FILE : %s" %(e))

    try:
        wmelistsymbol_appdata = bleConfigComp.createFileSymbol('WME_SYS_APP_DATA', None)
        print("::::::::WME BLE COMPONENT::::::: ", wmelistsymbol_appdata)
        wmelistsymbol_appdata.setType("STRING")
        wmelistsymbol_appdata.setOutputName("wlsbleconfig.WLS_BLE_LIST_DEV_SUPP_DATA_C")
        wmelistsymbol_appdata.setSourcePath("services/ble/ble_config/src/templates/app_wme_data.c.ftl")
        wmelistsymbol_appdata.setMarkup(True)

    except Exception as e:
        print("::::::::ERROR on SYMBOL CREATION FILE WLS_BLE_LIST_DEV_SUPP_DATA_C::::::: : %s" %(e))

    try:
        wmelistsymbol_appdevsuppinit = bleConfigComp.createFileSymbol('WME_SYS_INIT_APP_BLE', None)
        print("::::::::WME BLE COMPONENT::::::: ", wmelistsymbol_appdevsuppinit)
        wmelistsymbol_appdevsuppinit.setType("STRING")
        wmelistsymbol_appdevsuppinit.setOutputName("wlsbleconfig.WLS_BLE_LIST_DEV_SUPP_INIT_C")
        wmelistsymbol_appdevsuppinit.setSourcePath("services/ble/ble_config/src/templates/wme_app_init.c.ftl")
        wmelistsymbol_appdevsuppinit.setMarkup(True)
    except Exception as e:
        print("::::::::ERROR on SYMBOL CREATION FILE WLS_BLE_LIST_DEV_SUPP_INIT_C::::::: : %s" %(e))
    
    try:
        wmelistsymbol_appdevsuppinitentry = bleConfigComp.createFileSymbol('WME_SYS_INIT_APP_BLE_ENTRY', None)
        print("::::::::WME BLE COMPONENT::::::: ", wmelistsymbol_appdevsuppinitentry)
        wmelistsymbol_appdevsuppinitentry.setType("STRING")
        wmelistsymbol_appdevsuppinitentry.setOutputName("wlsbleconfig.WLS_BLE_LIST_DEV_SUPP_APP_ENTRY_C")
        wmelistsymbol_appdevsuppinitentry.setSourcePath("services/ble/ble_config/src/templates/wme_app_init_entry.c.ftl")
        wmelistsymbol_appdevsuppinitentry.setMarkup(True)
    except Exception as e:
        print("::::::::ERROR on SYMBOL CREATION FILE WLS_BLE_LIST_DEV_SUPP_APP_ENTRY_C::::::: : %s" %(e))

    try:
        wmelistsymbol_appsupptaskentry = bleConfigComp.createFileSymbol('WME_SYS_TASK_ENTRY', None)
        print("::::::::WME BLE COMPONENT::::::: ", wmelistsymbol_appsupptaskentry)
        wmelistsymbol_appsupptaskentry.setType("STRING")
        wmelistsymbol_appsupptaskentry.setOutputName("wlsbleconfig.WLS_BLE_LIST_DEV_SUPP_TASK_ENTRY_C")
        wmelistsymbol_appsupptaskentry.setSourcePath("services/ble/ble_config/src/templates/app_wme_service_task.c.ftl")
        wmelistsymbol_appsupptaskentry.setMarkup(True)

    except Exception as e:
        print("::::::::ERROR on SYMBOL CREATION FILE WLS_BLE_LIST_DEV_SUPP_TASK_ENTRY_C::::::: : %s" %(e))

    try:
        wmelistsymbol_appcbfunc = bleConfigComp.createFileSymbol('WME_SYS_CB_FUNC', None)
        print("::::::::WME BLE COMPONENT::::::: ", wmelistsymbol_appcbfunc)
        wmelistsymbol_appcbfunc.setType("STRING")
        wmelistsymbol_appcbfunc.setOutputName("wlsbleconfig.WLS_BLE_LIST_DEV_SUPP_CB_FUNC_C")
        wmelistsymbol_appcbfunc.setSourcePath("services/ble/ble_config/src/templates/app_wme_func.c.ftl")
        wmelistsymbol_appcbfunc.setMarkup(True)

    except Exception as e:
        print("::::::::ERROR on SYMBOL CREATION FILE WLS_BLE_LIST_DEV_SUPP_CB_FUNC_C::::::: : %s" %(e))

    # Add app.h
    wlsbleappHeaderFile = bleConfigComp.createFileSymbol(None, None)
    wlsbleappHeaderFile.setSourcePath('services/ble/ble_config/src/templates/app.h.ftl')
    wlsbleappHeaderFile.setOutputName('app.h')
    wlsbleappHeaderFile.setOverwrite(True)
    wlsbleappHeaderFile.setDestPath('../../')
    wlsbleappHeaderFile.setProjectPath('')
    wlsbleappHeaderFile.setType('HEADER')
    wlsbleappHeaderFile.setMarkup(True)
    wlsbleappHeaderFile.setEnabled(True)

    wlsbleappHeaderFileList = bleConfigComp.createListSymbol("WLS_BLE_LIST_DEV_SUPP_MSG_ID_H", None)

    try:
        wmelistsymbol_appdevmsgid = bleConfigComp.createFileSymbol('WME_SYS_MSG_ID', None)
        print("::::::::WME BLE COMPONENT::::::: ", wmelistsymbol_appdevmsgid)
        wmelistsymbol_appdevmsgid.setType("STRING")
        wmelistsymbol_appdevmsgid.setOutputName("wlsbleconfig.WLS_BLE_LIST_DEV_SUPP_MSG_ID_H")
        wmelistsymbol_appdevmsgid.setSourcePath("services/ble/ble_config/src/templates/wme_app.h.ftl")
        wmelistsymbol_appdevmsgid.setMarkup(True)
    except Exception as e:
        print("::::::::ERROR on SYMBOL CREATION FILE WLS_BLE_LIST_DEV_SUPP_MSG_ID_H::::::: : %s" %(e))
 
    wlsHandlerHeaderFile = bleConfigComp.createFileSymbol(None, None)
    wlsHandlerHeaderFile.setSourcePath("services/ble/ble_config/src/templates/handlers/app_ble_handler.h.ftl")
    wlsHandlerHeaderFile.setOutputName("app_ble_handler.h")
    wlsHandlerHeaderFile.setDestPath('../../app_ble/handlers')
    wlsHandlerHeaderFile.setProjectPath('app_ble/handlers')
    wlsHandlerHeaderFile.setType('HEADER')
    wlsHandlerHeaderFile.setMarkup(True)
    wlsHandlerHeaderFile.setOverwrite(True)
    wlsHandlerHeaderFile.setEnabled(True)
   
    
    wlsAppUtilityHeaderFile = bleConfigComp.createFileSymbol(None, None)
    wlsAppUtilityHeaderFile.setSourcePath("services/ble/ble_config/src/templates/app_utility.h.ftl")
    wlsAppUtilityHeaderFile.setOutputName("app_utility.h")
    wlsAppUtilityHeaderFile.setDestPath('../../')
    wlsAppUtilityHeaderFile.setProjectPath('')
    wlsAppUtilityHeaderFile.setType('HEADER')
    wlsAppUtilityHeaderFile.setMarkup(True)
    wlsAppUtilityHeaderFile.setOverwrite(True)
    wlsAppUtilityHeaderFile.setEnabled(True)
    
    wlsAppUtilitySourceFile = bleConfigComp.createFileSymbol(None, None)
    wlsAppUtilitySourceFile.setSourcePath("services/ble/ble_config/src/templates/app_utility.c.ftl")
    wlsAppUtilitySourceFile.setOutputName("app_utility.c")
    wlsAppUtilitySourceFile.setDestPath('../../')
    wlsAppUtilitySourceFile.setProjectPath('')
    wlsAppUtilitySourceFile.setType('SOURCE')
    wlsAppUtilitySourceFile.setMarkup(True)
    wlsAppUtilitySourceFile.setOverwrite(True)
    wlsAppUtilitySourceFile.setEnabled(True)

    wlsAppBleAdvConfig = bleConfigComp.createFileSymbol(None, None)
    wlsAppBleAdvConfig.setType("STRING")
    wlsAppBleAdvConfig.setOutputName("core.LIST_SYSTEM_CONFIG_H_APPLICATION_CONFIGURATION")
    wlsAppBleAdvConfig.setSourcePath("services/ble/ble_config/src/templates/app_configuration_ble.h.ftl")
    wlsAppBleAdvConfig.setMarkup(True)

