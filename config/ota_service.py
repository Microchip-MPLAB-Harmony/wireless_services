# coding: utf-8
"""*****************************************************************************
* Copyright (C) 2023 Microchip Technology Inc. and its subsidiaries.
*
* Subject to your compliance with these terms, you may use Microchip software
* and any derivatives exclusively with Microchip products. It is your
* responsibility to comply with third party license terms applicable to your
* use of third party software (including open source software) that may
* accompany Microchip software.
*
* THIS SOFTWARE IS SUPPLIED BY MICROCHIP "AS IS". NO WARRANTIES, WHETHER
* EXPRESS, IMPLIED OR STATUTORY, APPLY TO THIS SOFTWARE, INCLUDING ANY IMPLIED
* WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS FOR A
* PARTICULAR PURPOSE.
*
* IN NO EVENT WILL MICROCHIP BE LIABLE FOR ANY INDIRECT, SPECIAL, PUNITIVE,
* INCIDENTAL OR CONSEQUENTIAL LOSS, DAMAGE, COST OR EXPENSE OF ANY KIND
* WHATSOEVER RELATED TO THE SOFTWARE, HOWEVER CAUSED, EVEN IF MICROCHIP HAS
* BEEN ADVISED OF THE POSSIBILITY OR THE DAMAGES ARE FORESEEABLE. TO THE
* FULLEST EXTENT ALLOWED BY LAW, MICROCHIP'S TOTAL LIABILITY ON ALL CLAIMS IN
* ANY WAY RELATED TO THIS SOFTWARE WILL NOT EXCEED THE AMOUNT OF FEES, IF ANY,
* THAT YOU HAVE PAID DIRECTLY TO MICROCHIP FOR THIS SOFTWARE.
*****************************************************************************"""
import re

global ota_service_helpkeyword
global flashNames
global flash_start
global flash_size
global flash_erase_size
global otaServiceDualBankEnable

ota_service_helpkeyword = "mcc_h3_ota_service_configurations"

flash_start         = 0
flash_size          = 0
flash_erase_size    = 0

NvmMemoryNames      = ["NVM", "NVMCTRL", "EFC", "HEFC", "FCW"]
FlashNames          = ["FLASH", "IFLASH", "FCR_PFM"]

addr_space          = ATDF.getNode("/avr-tools-device-file/devices/device/address-spaces/address-space")
addr_space_children = addr_space.getChildren()

periphNode          = ATDF.getNode("/avr-tools-device-file/devices/device/peripherals")
peripherals         = periphNode.getChildren()

for mem_idx in range(0, len(addr_space_children)):
    mem_seg     = addr_space_children[mem_idx].getAttribute("name")
    mem_type    = addr_space_children[mem_idx].getAttribute("type")

    if ((any(x == mem_seg for x in FlashNames) == True) and (mem_type == "flash")):
        flash_start = int(addr_space_children[mem_idx].getAttribute("start"), 16)
        flash_size  = int(addr_space_children[mem_idx].getAttribute("size"), 16)

def handleMessage(messageID, args):

    result_dict = {}

    return result_dict

def setOTAMemEraseEnable(symbol, event):
    symbol.setValue(event["value"])

def generateHwCRCGeneratorSymbol(otaServiceComponent):
    global ota_service_helpkeyword
    hwCRC = False
    crcPeriphName = ""

    coreComponent = Database.getComponentByID("core")

    # Enable FCR if present
    for module in range (0, len(peripherals)):
        periphName = str(peripherals[module].getAttribute("name"))

        if(periphName == "FCR"):
            hwCRC = True
            crcPeriphName = "FCR"
            res = Database.activateComponents(["fcr"])

    # Enable PAC and DSU component if present
    if hwCRC != True:
        for module in range (0, len(peripherals)):
            if Variables.get("__TRUSTZONE_ENABLED") != None and Variables.get("__TRUSTZONE_ENABLED") == "true":
                hwCRC=False
                break

            periphName = str(peripherals[module].getAttribute("name"))
            if (periphName == "PAC"):
                coreComponent.getSymbolByID("PAC_USE").setValue(True)
                if (Database.getSymbolValue("core", "PAC_INTERRRUPT_MODE") != None):
                    coreComponent.getSymbolByID("PAC_INTERRRUPT_MODE").setValue(False)
            elif (periphName == "DSU"):
                res = Database.activateComponents(["dsu"])
                hwCRC = True
                crcPeriphName = "DSU"

    otaServiceHwCrc = otaServiceComponent.createBooleanSymbol("OTA_SERVICE_HW_CRC_GEN", None)
    otaServiceHwCrc.setHelp(ota_service_helpkeyword)
    otaServiceHwCrc.setLabel("Hardware CRC Generator")
    otaServiceHwCrc.setReadOnly(True)
    otaServiceHwCrc.setVisible(False)
    otaServiceHwCrc.setDefaultValue(hwCRC)

    otaServiceCrcPeriphUsed = otaServiceComponent.createStringSymbol("OTA_SERVICE_CRC_PERIPH_USED", None)
    otaServiceCrcPeriphUsed.setHelp(ota_service_helpkeyword)
    otaServiceCrcPeriphUsed.setLabel("CRC Peripheral Used")
    otaServiceCrcPeriphUsed.setReadOnly(True)
    otaServiceCrcPeriphUsed.setVisible(False)
    otaServiceCrcPeriphUsed.setDefaultValue(crcPeriphName)

def setBtlDualBankCommentVisible(symbol, event):
    symbol.setVisible(event["value"])

############## RTOS configurations ################
def genRtosTask(symbol, event):
    component = symbol.getComponent()

    gen_rtos_task = False

    if (Database.getSymbolValue("HarmonyCore", "SELECT_RTOS") != "BareMetal"):
        gen_rtos_task = True

    symbol.setEnabled(gen_rtos_task)

def showRTOSMenu(symbol, event):
    component = symbol.getComponent()

    show_rtos_menu = False

    if (Database.getSymbolValue("HarmonyCore", "SELECT_RTOS") != "BareMetal"):
        show_rtos_menu = True

    symbol.setVisible(show_rtos_menu)

def otaRtosMicriumOSIIIAppTaskVisibility(symbol, event):
    if (event["value"] == "MicriumOSIII"):
        symbol.setVisible(True)
    else:
        symbol.setVisible(False)

def otaRtosMicriumOSIIITaskOptVisibility(symbol, event):
    symbol.setVisible(event["value"])

def setVisibility(symbol, event):
    symbol.setVisible(event["value"])

def getActiveRtos():
    activeComponents = Database.getActiveComponentIDs()

    for i in range(0, len(activeComponents)):
        if (activeComponents[i] == "FreeRTOS"):
            return "FreeRTOS"
        elif (activeComponents[i] == "ThreadX"):
            return "ThreadX"
        elif (activeComponents[i] == "MicriumOSIII"):
            return "MicriumOSIII"
        elif (activeComponents[i] == "MbedOS"):
            return "MbedOS"

def generateRTOSSymbols(otaServiceComponent):

    enable_rtos_settings = False
    rtos_mode = Database.getSymbolValue("HarmonyCore", "SELECT_RTOS")

    if ((rtos_mode != None) and (rtos_mode != "BareMetal")):
        enable_rtos_settings = True

    # RTOS Settings
    otaServiceRTOSMenu = otaServiceComponent.createMenuSymbol("OTA_SERVICE_RTOS_MENU", None)
    otaServiceRTOSMenu.setLabel("RTOS settings")
    otaServiceRTOSMenu.setDescription("RTOS settings")
    otaServiceRTOSMenu.setVisible(enable_rtos_settings)
    otaServiceRTOSMenu.setDependencies(showRTOSMenu, ["HarmonyCore.SELECT_RTOS"])

    otaServiceRTOSStackSize = otaServiceComponent.createIntegerSymbol("OTA_SERVICE_RTOS_STACK_SIZE", otaServiceRTOSMenu)
    otaServiceRTOSStackSize.setLabel("Stack Size (in bytes)")
    otaServiceRTOSStackSize.setDefaultValue(4096)

    otaServiceRTOSMsgQSize = otaServiceComponent.createIntegerSymbol("OTA_SERVICE_RTOS_TASK_MSG_QTY", otaServiceRTOSMenu)
    otaServiceRTOSMsgQSize.setLabel("Maximum Message Queue Size")
    otaServiceRTOSMsgQSize.setDescription("A µC/OS-III task contains an optional internal message queue (if OS_CFG_TASK_Q_EN is set to DEF_ENABLED in os_cfg.h). This argument specifies the maximum number of messages that the task can receive through this message queue. The user may specify that the task is unable to receive messages by setting this argument to 0")
    otaServiceRTOSMsgQSize.setDefaultValue(0)
    otaServiceRTOSMsgQSize.setVisible(getActiveRtos() == "MicriumOSIII")
    otaServiceRTOSMsgQSize.setDependencies(otaRtosMicriumOSIIIAppTaskVisibility, ["HarmonyCore.SELECT_RTOS"])

    otaServiceRTOSTaskTimeQuanta = otaServiceComponent.createIntegerSymbol("OTA_SERVICE_RTOS_TASK_TIME_QUANTA", otaServiceRTOSMenu)
    otaServiceRTOSTaskTimeQuanta.setLabel("Task Time Quanta")
    otaServiceRTOSTaskTimeQuanta.setDescription("The amount of time (in clock ticks) for the time quanta when Round Robin is enabled. If you specify 0, then the default time quanta will be used which is the tick rate divided by 10.")
    otaServiceRTOSTaskTimeQuanta.setDefaultValue(0)
    otaServiceRTOSTaskTimeQuanta.setVisible(getActiveRtos() == "MicriumOSIII")
    otaServiceRTOSTaskTimeQuanta.setDependencies(otaRtosMicriumOSIIIAppTaskVisibility, ["HarmonyCore.SELECT_RTOS"])

    otaServiceRTOSTaskPriority = otaServiceComponent.createIntegerSymbol("OTA_SERVICE_RTOS_TASK_PRIORITY", otaServiceRTOSMenu)
    otaServiceRTOSTaskPriority.setLabel("Task Priority")
    otaServiceRTOSTaskPriority.setDefaultValue(1)

    otaServiceRTOSTaskDelay = otaServiceComponent.createBooleanSymbol("OTA_SERVICE_RTOS_USE_DELAY", otaServiceRTOSMenu)
    otaServiceRTOSTaskDelay.setLabel("Use Task Delay?")
    otaServiceRTOSTaskDelay.setDefaultValue(True)

    otaServiceRTOSTaskDelayVal = otaServiceComponent.createIntegerSymbol("OTA_SERVICE_RTOS_DELAY", otaServiceRTOSTaskDelay)
    otaServiceRTOSTaskDelayVal.setLabel("Task Delay")
    otaServiceRTOSTaskDelayVal.setDefaultValue(1)
    otaServiceRTOSTaskDelayVal.setVisible((otaServiceRTOSTaskDelay.getValue() == True))
    otaServiceRTOSTaskDelayVal.setDependencies(setVisibility, ["OTA_SERVICE_RTOS_USE_DELAY"])

    otaServiceRTOSTaskSpecificOpt = otaServiceComponent.createBooleanSymbol("OTA_SERVICE_RTOS_TASK_OPT_NONE", otaServiceRTOSMenu)
    otaServiceRTOSTaskSpecificOpt.setLabel("Task Specific Options")
    otaServiceRTOSTaskSpecificOpt.setDescription("Contains task-specific options. Each option consists of one bit. The option is selected when the bit is set. The current version of µC/OS-III supports the following options:")
    otaServiceRTOSTaskSpecificOpt.setDefaultValue(True)
    otaServiceRTOSTaskSpecificOpt.setVisible(getActiveRtos() == "MicriumOSIII")
    otaServiceRTOSTaskSpecificOpt.setDependencies(otaRtosMicriumOSIIIAppTaskVisibility, ["HarmonyCore.SELECT_RTOS"])

    otaServiceRTOSTaskStkChk = otaServiceComponent.createBooleanSymbol("OTA_SERVICE_RTOS_TASK_OPT_STK_CHK", otaServiceRTOSTaskSpecificOpt)
    otaServiceRTOSTaskStkChk.setLabel("Stack checking is allowed for the task")
    otaServiceRTOSTaskStkChk.setDescription("Specifies whether stack checking is allowed for the task")
    otaServiceRTOSTaskStkChk.setDefaultValue(True)
    otaServiceRTOSTaskStkChk.setDependencies(otaRtosMicriumOSIIITaskOptVisibility, ["OTA_SERVICE_RTOS_TASK_OPT_NONE"])

    otaServiceRTOSTaskStkClr = otaServiceComponent.createBooleanSymbol("OTA_SERVICE_RTOS_TASK_OPT_STK_CLR", otaServiceRTOSTaskSpecificOpt)
    otaServiceRTOSTaskStkClr.setLabel("Stack needs to be cleared")
    otaServiceRTOSTaskStkClr.setDescription("Specifies whether the stack needs to be cleared")
    otaServiceRTOSTaskStkClr.setDefaultValue(True)
    otaServiceRTOSTaskStkClr.setDependencies(otaRtosMicriumOSIIITaskOptVisibility, ["OTA_SERVICE_RTOS_TASK_OPT_NONE"])

    otaServiceRTOSTaskSaveFp = otaServiceComponent.createBooleanSymbol("OTA_SERVICE_RTOS_TASK_OPT_SAVE_FP", otaServiceRTOSTaskSpecificOpt)
    otaServiceRTOSTaskSaveFp.setLabel("Floating-point registers needs to be saved")
    otaServiceRTOSTaskSaveFp.setDescription("Specifies whether floating-point registers are saved. This option is only valid if the processor has floating-point hardware and the processor-specific code saves the floating-point registers")
    otaServiceRTOSTaskSaveFp.setDefaultValue(False)
    otaServiceRTOSTaskSaveFp.setDependencies(otaRtosMicriumOSIIITaskOptVisibility, ["OTA_SERVICE_RTOS_TASK_OPT_NONE"])

    otaServiceRTOSTaskNoTls = otaServiceComponent.createBooleanSymbol("OTA_SERVICE_RTOS_TASK_OPT_NO_TLS", otaServiceRTOSTaskSpecificOpt)
    otaServiceRTOSTaskNoTls.setLabel("TLS (Thread Local Storage) support needed for the task")
    otaServiceRTOSTaskNoTls.setDescription("If the caller doesn’t want or need TLS (Thread Local Storage) support for the task being created. If you do not include this option, TLS will be supported by default. TLS support was added in V3.03.00")
    otaServiceRTOSTaskNoTls.setDefaultValue(False)
    otaServiceRTOSTaskNoTls.setDependencies(otaRtosMicriumOSIIITaskOptVisibility, ["OTA_SERVICE_RTOS_TASK_OPT_NONE"])

    otaServiceSystemRtosTasksFile = otaServiceComponent.createFileSymbol("OTA_SERVICE_SYS_RTOS_TASK", None)
    otaServiceSystemRtosTasksFile.setType("STRING")
    otaServiceSystemRtosTasksFile.setOutputName("core.LIST_SYSTEM_RTOS_TASKS_C_DEFINITIONS")
    otaServiceSystemRtosTasksFile.setSourcePath("../wireless_system_services/common/system/rtos_tasks.c.ftl")
    otaServiceSystemRtosTasksFile.setMarkup(True)
    otaServiceSystemRtosTasksFile.setEnabled(enable_rtos_settings)
    otaServiceSystemRtosTasksFile.setDependencies(genRtosTask, ["HarmonyCore.SELECT_RTOS", "OTA_SERVICE_LIVE_UPDATE"])

def instantiateComponent(otaServiceComponent):
    global otaServiceDualBankEnable

    Database.activateComponents(["HarmonyCore"])

    # Enable "Generate Harmony Driver Common Files" option in MCC
    Database.sendMessage("HarmonyCore", "ENABLE_DRV_COMMON", {"isEnabled":True})

    # Enable "Generate Harmony System Service Common Files" option in MCC
    Database.sendMessage("HarmonyCore", "ENABLE_SYS_COMMON", {"isEnabled":True})

    otaServiceEnable = otaServiceComponent.createBooleanSymbol("OTA_SERVICE_ENABLE", None)
    otaServiceEnable.setVisible(False)
    otaServiceEnable.setDefaultValue(True)

    otaServiceDriverUsed = otaServiceComponent.createStringSymbol("DRIVER_USED", None)
    otaServiceDriverUsed.setHelp(ota_service_helpkeyword)
    otaServiceDriverUsed.setLabel("OTA Memory Used")
    otaServiceDriverUsed.setReadOnly(True)
    otaServiceDriverUsed.setDefaultValue("")

    generateHwCRCGeneratorSymbol(otaServiceComponent)

    otaServiceOTAMemEraseEnable = otaServiceComponent.createBooleanSymbol("OTA_MEM_ERASE_ENABLE", None)
    otaServiceOTAMemEraseEnable.setHelp(ota_service_helpkeyword)
    otaServiceOTAMemEraseEnable.setLabel("Enable Erase for OTA Memory")
    otaServiceOTAMemEraseEnable.setVisible(False)
    otaServiceOTAMemEraseEnable.setDefaultValue(False)
    otaServiceOTAMemEraseEnable.setReadOnly(True)
    otaServiceOTAMemEraseEnable.setDependencies(setOTAMemEraseEnable, ["ota_service_MEMORY_dependency_OTA:ERASE_ENABLE"])

    nvmMemoryName = ""
    for module in range (0, len(peripherals)):
        periphName = str(peripherals[module].getAttribute("name"))
        if ((any(x == periphName for x in NvmMemoryNames) == True)):
            nvmMemoryName = periphName
            break

    otaServiceNVMMemUsed = otaServiceComponent.createStringSymbol("NVM_MEM_USED", None)
    otaServiceNVMMemUsed.setHelp(ota_service_helpkeyword)
    otaServiceNVMMemUsed.setReadOnly(True)
    otaServiceNVMMemUsed.setVisible(False)
    otaServiceNVMMemUsed.setDefaultValue(nvmMemoryName)

    otaServiceDualBankEnable = False

    if (("SAME5" in Variables.get("__PROCESSOR")) or ("SAMD5" in Variables.get("__PROCESSOR"))):
        otaServiceDualBankEnable = True
    elif ("PIC32MZ" in Variables.get("__PROCESSOR")):
        if (re.match("PIC32MZ.[0-9]*EF", Variables.get("__PROCESSOR")) or
            re.match("PIC32MZ.[0-9]*DA", Variables.get("__PROCESSOR"))):
            otaServiceDualBankEnable = True
    elif ("PIC32MK" in Variables.get("__PROCESSOR")):
        if (re.match("PIC32MK.[0-9]*GPG", Variables.get("__PROCESSOR")) or
            re.match("PIC32MK.[0-9]*GPH", Variables.get("__PROCESSOR")) or
            re.match("PIC32MK.[0-9]*MCJ", Variables.get("__PROCESSOR")) or
            re.match("PIC32MK.[0-9]*MCA", Variables.get("__PROCESSOR"))):
            otaServiceDualBankEnable = False
        else:
            otaServiceDualBankEnable = True

    otaServiceDualBank = otaServiceComponent.createBooleanSymbol("OTA_SERVICE_DUAL_BANK", None)
    otaServiceDualBank.setHelp(ota_service_helpkeyword)
    otaServiceDualBank.setLabel("Use Dual Bank For Safe Flash Update")
    otaServiceDualBank.setDefaultValue(otaServiceDualBankEnable)
    otaServiceDualBank.setVisible(otaServiceDualBankEnable)
    otaServiceDualBank.setReadOnly(True)

    otaServiceDualBankComment = otaServiceComponent.createCommentSymbol("OTA_SERVICE_DUAL_BANK_COMMENT", None)
    otaServiceDualBankComment.setHelp(ota_service_helpkeyword)
    otaServiceDualBankComment.setLabel("!!! WARNING Only Half of the Flash memory will be available for Application !!!")
    otaServiceDualBankComment.setVisible(False)
    otaServiceDualBankComment.setDependencies(setBtlDualBankCommentVisible, ["OTA_SERVICE_DUAL_BANK"])

    otaServiceNumOfAppImage = otaServiceComponent.createIntegerSymbol("NUM_OF_APP_IMAGE", None)
    otaServiceNumOfAppImage.setHelp(ota_service_helpkeyword)
    otaServiceNumOfAppImage.setLabel("Number of application image storage")
    otaServiceNumOfAppImage.setDefaultValue(2)
    otaServiceNumOfAppImage.setMin(1)
    otaServiceNumOfAppImage.setMax(15)

    # Generate RTOS specific Symbols
    generateRTOSSymbols(otaServiceComponent)

    #################### Code Generation ####################
    configName = Variables.get("__CONFIGURATION_NAME")

    otaServiceFHSourceFile = otaServiceComponent.createFileSymbol("OTA_SERVICE_FH_SOURCE", None)
    otaServiceFHSourceFile.setSourcePath("../wireless_system_services/common/ota_service_file_handler.c.ftl")
    otaServiceFHSourceFile.setOutputName("ota_service_file_handler.c")
    otaServiceFHSourceFile.setMarkup(True)
    otaServiceFHSourceFile.setOverwrite(True)
    otaServiceFHSourceFile.setDestPath("/ota_service/")
    otaServiceFHSourceFile.setProjectPath("config/" + configName + "/ota_service/")
    otaServiceFHSourceFile.setType("SOURCE")

    otaServiceFHHeaderFile = otaServiceComponent.createFileSymbol("OTA_SERVICE_FH_HEADER", None)
    otaServiceFHHeaderFile.setSourcePath("../wireless_system_services/common/ota_service_file_handler.h.ftl")
    otaServiceFHHeaderFile.setOutputName("ota_service_file_handler.h")
    otaServiceFHHeaderFile.setMarkup(True)
    otaServiceFHHeaderFile.setOverwrite(True)
    otaServiceFHHeaderFile.setDestPath("/ota_service/")
    otaServiceFHHeaderFile.setProjectPath("config/" + configName + "/ota_service/")
    otaServiceFHHeaderFile.setType("HEADER")

    otaServiceControlBlockHeaderFile = otaServiceComponent.createFileSymbol("OTA_SERVICE_CONTROL_BLOCK_HEADER", None)
    otaServiceControlBlockHeaderFile.setSourcePath("../wireless_system_services/common/ota_service_control_block.h.ftl")
    otaServiceControlBlockHeaderFile.setOutputName("ota_service_control_block.h")
    otaServiceControlBlockHeaderFile.setMarkup(True)
    otaServiceControlBlockHeaderFile.setOverwrite(True)
    otaServiceControlBlockHeaderFile.setDestPath("/ota_service/")
    otaServiceControlBlockHeaderFile.setProjectPath("config/" + configName + "/ota_service/")
    otaServiceControlBlockHeaderFile.setType("HEADER")

    otaServiceSystemTasksFile = otaServiceComponent.createFileSymbol("OTA_SERVICE_SYS_TASK", None)
    otaServiceSystemTasksFile.setType("STRING")
    otaServiceSystemTasksFile.setOutputName("core.LIST_SYSTEM_TASKS_C_CALL_DRIVER_TASKS")
    otaServiceSystemTasksFile.setSourcePath("../wireless_system_services/common/system/tasks.c.ftl")
    otaServiceSystemTasksFile.setMarkup(True)

    otaServiceSystemDefFile = otaServiceComponent.createFileSymbol("OTA_SERVICE_SYS_DEF_HEADER", None)
    otaServiceSystemDefFile.setType("STRING")
    otaServiceSystemDefFile.setOutputName("core.LIST_SYSTEM_DEFINITIONS_H_INCLUDES")
    otaServiceSystemDefFile.setSourcePath("../wireless_system_services/common/system/definitions.h.ftl")
    otaServiceSystemDefFile.setMarkup(True)

    otaServiceSourceFile = otaServiceComponent.createFileSymbol("OTA_SERVICE_S", None)
    otaServiceSourceFile.setSourcePath("../wireless_system_services/common/ota_service.c")
    otaServiceSourceFile.setOutputName("ota_service.c")
    otaServiceSourceFile.setMarkup(False)
    otaServiceSourceFile.setOverwrite(True)
    otaServiceSourceFile.setDestPath("/ota_service/")
    otaServiceSourceFile.setProjectPath("config/" + configName + "/ota_service/")
    otaServiceSourceFile.setType("SOURCE")

    otaServiceHeaderFile = otaServiceComponent.createFileSymbol("OTA_SERVICE_H", None)
    otaServiceHeaderFile.setSourcePath("../wireless_system_services/common/ota_service.h")
    otaServiceHeaderFile.setOutputName("ota_service.h")
    otaServiceHeaderFile.setMarkup(False)
    otaServiceHeaderFile.setOverwrite(True)
    otaServiceHeaderFile.setDestPath("/ota_service/")
    otaServiceHeaderFile.setProjectPath("config/" + configName + "/ota_service/")
    otaServiceHeaderFile.setType("HEADER")

    otaServiceTransportSourceFile = otaServiceComponent.createFileSymbol("OTA_SERVICE_TRANSPORT_S", None)
    otaServiceTransportSourceFile.setSourcePath("../wireless_system_services/ble/ota_service_transport_ble.c")
    otaServiceTransportSourceFile.setOutputName("ota_service_transport_ble.c")
    otaServiceTransportSourceFile.setMarkup(False)
    otaServiceTransportSourceFile.setOverwrite(True)
    otaServiceTransportSourceFile.setDestPath("/ota_service/")
    otaServiceTransportSourceFile.setProjectPath("config/" + configName + "/ota_service/")
    otaServiceTransportSourceFile.setType("SOURCE")

    otaServiceTransportHeaderFile = otaServiceComponent.createFileSymbol("OTA_SERVICE_TRANSPORT_H", None)
    otaServiceTransportHeaderFile.setSourcePath("../wireless_system_services/ble/ota_service_transport_ble.h")
    otaServiceTransportHeaderFile.setOutputName("ota_service_transport_ble.h")
    otaServiceTransportHeaderFile.setMarkup(False)
    otaServiceTransportHeaderFile.setOverwrite(True)
    otaServiceTransportHeaderFile.setDestPath("/ota_service/")
    otaServiceTransportHeaderFile.setProjectPath("config/" + configName + "/ota_service/")
    otaServiceTransportHeaderFile.setType("HEADER")

    otaServiceConfigHeaderFile = otaServiceComponent.createFileSymbol("OTA_SERVICE_CONFIG_H", None)
    otaServiceConfigHeaderFile.setSourcePath("../wireless_system_services/common/ota_config.h")
    otaServiceConfigHeaderFile.setOutputName("ota_config.h")
    otaServiceConfigHeaderFile.setMarkup(False)
    otaServiceConfigHeaderFile.setOverwrite(True)
    otaServiceConfigHeaderFile.setDestPath("/ota_service/")
    otaServiceConfigHeaderFile.setProjectPath("config/" + configName + "/ota_service/")
    otaServiceConfigHeaderFile.setType("HEADER")

def onAttachmentConnected(source, target):
    global flash_erase_size
    global otaServiceDualBankEnable

    localComponent = source["component"]
    remoteComponent = target["component"]
    remoteID = remoteComponent.getID()
    srcID = source["id"]
    targetID = target["id"]

    if (srcID == "ota_service_MEMORY_dependency_OTA"):
        localComponent.getSymbolByID("DRIVER_USED").clearValue()
        localComponent.getSymbolByID("DRIVER_USED").setValue(remoteID.upper())

        localComponent.getSymbolByID("OTA_MEM_ERASE_ENABLE").setValue(remoteComponent.getSymbolValue("ERASE_ENABLE"))

        if remoteID.upper() == localComponent.getSymbolByID("NVM_MEM_USED").getValue():
            if otaServiceDualBankEnable == True:
                localComponent.getSymbolByID("OTA_SERVICE_DUAL_BANK").setValue(True)
                localComponent.getSymbolByID("NUM_OF_APP_IMAGE").setReadOnly(True)
                localComponent.getSymbolByID("NUM_OF_APP_IMAGE").clearValue()
            flash_erase_size = int(Database.getSymbolValue(remoteID, "FLASH_ERASE_SIZE"))
            Database.setSymbolValue(remoteID, "INTERRUPT_ENABLE", False)

        # Set the number of buffer descriptor for SST26 with SQI peripheral on PIC32MZ devices
        if(Database.getSymbolValue(remoteID, remoteID.upper() + "_NUM_BUFFER_DESC") != None):
            remoteComponent.getSymbolByID(remoteID.upper() + "_NUM_BUFFER_DESC").setValue((flash_erase_size/ 256))

def onAttachmentDisconnected(source, target):
    global flash_erase_size
    global otaServiceDualBankEnable

    localComponent = source["component"]
    remoteComponent = target["component"]
    remoteID = remoteComponent.getID()
    srcID = source["id"]
    targetID = target["id"]

    if (srcID == "ota_service_MEMORY_dependency_OTA"):
        flash_erase_size = 0
        if remoteID.upper() == localComponent.getSymbolByID("NVM_MEM_USED").getValue():
            if otaServiceDualBankEnable == True:
                localComponent.getSymbolByID("OTA_SERVICE_DUAL_BANK").setValue(False)
                localComponent.getSymbolByID("NUM_OF_APP_IMAGE").setReadOnly(False)
        localComponent.getSymbolByID("DRIVER_USED").clearValue()
        localComponent.getSymbolByID("OTA_MEM_ERASE_ENABLE").clearValue()
        Database.clearSymbolValue(remoteID, remoteID.upper() + "_NUM_BUFFER_DESC")

def finalizeComponent(otaServiceComponent):

    nvmMemoryName = ""

    for module in range (0, len(peripherals)):
        periphName = str(peripherals[module].getAttribute("name"))

        if ((any(x == periphName for x in NvmMemoryNames) == True)):
            nvmMemoryName = periphName.lower()
            break

    nvmMemoryCapabilityId = nvmMemoryName.upper() + "_MEMORY"

    nvmMemoryDependencyId = "ota_service_MEMORY_dependency_OTA"

    otaServiceActivateTable = [nvmMemoryName]
    otaServiceConnectTable  = [
        ["ota_service", nvmMemoryDependencyId, nvmMemoryName, nvmMemoryCapabilityId]
    ]

    res = Database.activateComponents(otaServiceActivateTable)
    res = Database.connectDependencies(otaServiceConnectTable)
