# coding: utf-8
##############################################################################
# Copyright (C) 2024 Microchip Technology Inc. and its subsidiaries.
#
# Subject to your compliance with these terms, you may use Microchip software
# and any derivatives exclusively with Microchip products. It is your
# responsibility to comply with third party license terms applicable to your
# use of third party software (including open source software) that may
# accompany Microchip software.
#
# THIS SOFTWARE IS SUPPLIED BY MICROCHIP "AS IS". NO WARRANTIES, WHETHER
# EXPRESS, IMPLIED OR STATUTORY, APPLY TO THIS SOFTWARE, INCLUDING ANY IMPLIED
# WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS FOR A
# PARTICULAR PURPOSE.
#
# IN NO EVENT WILL MICROCHIP BE LIABLE FOR ANY INDIRECT, SPECIAL, PUNITIVE,
# INCIDENTAL OR CONSEQUENTIAL LOSS, DAMAGE, COST OR EXPENSE OF ANY KIND
# WHATSOEVER RELATED TO THE SOFTWARE, HOWEVER CAUSED, EVEN IF MICROCHIP HAS
# BEEN ADVISED OF THE POSSIBILITY OR THE DAMAGES ARE FORESEEABLE. TO THE
# FULLEST EXTENT ALLOWED BY LAW, MICROCHIP'S TOTAL LIABILITY ON ALL CLAIMS IN
# ANY WAY RELATED TO THIS SOFTWARE WILL NOT EXCEED THE AMOUNT OF FEES, IF ANY,
# THAT YOU HAVE PAID DIRECTLY TO MICROCHIP FOR THIS SOFTWARE.
##############################################################################
global updateDecodeFilesName
def updateDecodeFilesName(component,svc,cp,svcname):
    decodeheader = component.getSymbolByID("CSS_SVC_" + str(svc) + "_CP_DECODE_HEADER_" + str(cp))
    decodesource = component.getSymbolByID("CSS_SVC_" + str(svc) + "_CP_DECODE_SOURCE_" + str(cp))
    cmdhandlerheader = component.getSymbolByID("CSS_SVC_" + str(svc) + "_CP_CMDHANDLER_HEADER_" + str(cp))
    cmdhandlersource = component.getSymbolByID("CSS_SVC_" + str(svc) + "_CP_CMDHANDLER_SOURCE_" + str(cp))
    decodeheader.setOutputName('ble_cps_'+ svcname.lower() + str(cp)+'_decode.h')
    decodesource.setOutputName('ble_cps_'+ svcname.lower() + str(cp)+'_decode.c')
    cmdhandlerheader.setOutputName('app_wls_cps_'+ svcname.lower() + str(cp)+'_action_handler.h')
    cmdhandlersource.setOutputName('app_wls_cps_'+ svcname.lower() + str(cp)+'_action_handler.c')

global enableDecodeFiles
def enableDecodeFiles(component,svc,cp,value):
    decodeheader = component.getSymbolByID("CSS_SVC_" + str(svc) + "_CP_DECODE_HEADER_" + str(cp))
    decodesource = component.getSymbolByID("CSS_SVC_" + str(svc) + "_CP_DECODE_SOURCE_" + str(cp))
    cmdhandlerheader = component.getSymbolByID("CSS_SVC_" + str(svc) + "_CP_CMDHANDLER_HEADER_" + str(cp))
    cmdhandlersource = component.getSymbolByID("CSS_SVC_" + str(svc) + "_CP_CMDHANDLER_SOURCE_" + str(cp))
    if value == True:
        svcname = custSysSvcName[svc].getValue()
        decodeheader.setOutputName('ble_cps_'+ svcname.lower() + str(cp)+'_decode.h')
        decodesource.setOutputName('ble_cps_'+ svcname.lower() + str(cp)+'_decode.c')
        cmdhandlerheader.setOutputName('app_wls_cps_'+ svcname.lower() + str(cp)+'_action_handler.h')
        cmdhandlersource.setOutputName('app_wls_cps_'+ svcname.lower() + str(cp)+'_action_handler.c')
    decodeheader.setEnabled(value)
    decodesource.setEnabled(value)
    cmdhandlerheader.setEnabled(value)
    cmdhandlersource.setEnabled(value)

global createDecodeFileSymbols
def createDecodeFileSymbols(component,svc,cp):
    cssDecodeHeaderFile = component.createFileSymbol("CSS_SVC_" + str(svc) + "_CP_DECODE_HEADER_" + str(cp), None)
    cssDecodeHeaderFile.setSourcePath('services/ble/ble_custom_protocol/src/templates/ble_cps_decode.h.ftl')
    cssDecodeHeaderFile.setOverwrite(True)
    cssDecodeHeaderFile.setDestPath('wireless/services/ble/cps')
    cssDecodeHeaderFile.setProjectPath('config/' + cssConfigName + '/wireless/services/ble/cps')
    cssDecodeHeaderFile.setType('HEADER')
    cssDecodeHeaderFile.setEnabled(False)
    cssDecodeHeaderFile.setMarkup(True)
    cssDecodeHeaderFile.addMarkupVariable("CSS_SVC",str(svc))
    cssDecodeHeaderFile.addMarkupVariable("CSS_CP",str(cp))

    cssDecodeSourceFile = component.createFileSymbol("CSS_SVC_" + str(svc) + "_CP_DECODE_SOURCE_" + str(cp), None)
    cssDecodeSourceFile.setSourcePath('services/ble/ble_custom_protocol/src/templates/ble_cps_decode.c.ftl')
    cssDecodeSourceFile.setOverwrite(True)
    cssDecodeSourceFile.setDestPath('wireless/services/ble/cps')
    cssDecodeSourceFile.setProjectPath('config/' + cssConfigName + '/wireless/services/ble/cps')
    cssDecodeSourceFile.setType('SOURCE')
    cssDecodeSourceFile.setEnabled(False)
    cssDecodeSourceFile.setMarkup(True)
    cssDecodeSourceFile.addMarkupVariable("CSS_SVC",str(svc))
    cssDecodeSourceFile.addMarkupVariable("CSS_CP",str(cp))

    cssCmdHandlerHeaderFile = component.createFileSymbol("CSS_SVC_" + str(svc) + "_CP_CMDHANDLER_HEADER_" + str(cp), None)
    cssCmdHandlerHeaderFile.setSourcePath('services/ble/ble_custom_protocol/src/templates/app_ble_cps_action_handler.h.ftl')
    cssCmdHandlerHeaderFile.setOverwrite(True)
    cssCmdHandlerHeaderFile.setDestPath('../../')
    cssCmdHandlerHeaderFile.setType('HEADER')
    cssCmdHandlerHeaderFile.setEnabled(False)
    cssCmdHandlerHeaderFile.setMarkup(True)
    cssCmdHandlerHeaderFile.addMarkupVariable("CSS_SVC",str(svc))
    cssCmdHandlerHeaderFile.addMarkupVariable("CSS_CP",str(cp))

    cssCmdHandlerSourceFile = component.createFileSymbol("CSS_SVC_" + str(svc) + "_CP_CMDHANDLER_SOURCE_" + str(cp), None)
    cssCmdHandlerSourceFile.setSourcePath('services/ble/ble_custom_protocol/src/templates/app_ble_cps_action_handler.c.ftl')
    cssCmdHandlerSourceFile.setOverwrite(True)
    cssCmdHandlerSourceFile.setDestPath('../../')
    cssCmdHandlerSourceFile.setType('SOURCE')
    cssCmdHandlerSourceFile.setEnabled(False)
    cssCmdHandlerSourceFile.setMarkup(True)
    cssCmdHandlerSourceFile.addMarkupVariable("CSS_SVC",str(svc))
    cssCmdHandlerSourceFile.addMarkupVariable("CSS_CP",str(cp))

global createWriteHandlerFileSymbols
def createWriteHandlerFileSymbols(component):
    cssWriteHandlerHeaderFile = component.createFileSymbol("CSS_SVC_BLE_WRITE_HANDLER_HEADER", None)
    cssWriteHandlerHeaderFile.setSourcePath('services/ble/ble_custom_protocol/src/templates/ble_cps_handler.h.ftl')
    cssWriteHandlerHeaderFile.setOutputName('ble_cps_handler.h')
    cssWriteHandlerHeaderFile.setOverwrite(True)
    cssWriteHandlerHeaderFile.setDestPath('wireless/services/ble/cps')
    cssWriteHandlerHeaderFile.setProjectPath('config/' + cssConfigName + '/wireless/services/ble/cps')
    cssWriteHandlerHeaderFile.setType('HEADER')
    cssWriteHandlerHeaderFile.setEnabled(True)
    cssWriteHandlerHeaderFile.setMarkup(True)

    cssWriteHandlerSourceFile = component.createFileSymbol("CSS_SVC_BLE_WRITE_HANDLER_SOURCE", None)
    cssWriteHandlerSourceFile.setSourcePath('services/ble/ble_custom_protocol/src/templates/ble_cps_handler.c.ftl')
    cssWriteHandlerSourceFile.setOutputName('ble_cps_handler.c')
    cssWriteHandlerSourceFile.setOverwrite(True)
    cssWriteHandlerSourceFile.setDestPath('wireless/services/ble/cps')
    cssWriteHandlerSourceFile.setProjectPath('config/' + cssConfigName + '/wireless/services/ble/cps')
    cssWriteHandlerSourceFile.setType('SOURCE')
    cssWriteHandlerSourceFile.setEnabled(True)
    cssWriteHandlerSourceFile.setMarkup(True)
    cssWriteHandlerSourceFile.addMarkupVariable("CSS_SVC_MAX_COUNT",str(cssSvcMaxCount))
    cssWriteHandlerSourceFile.addMarkupVariable("CSS_CP_MAX_COUNT",str(cssSvcCpMaxCount))

    # Add app code
    cssAppBleConfigTemplates = [('CSS_APP_BLE_HANDLER_INCLUDE', 'LIST_BLE_HANDLER_APP_INCLUDE', 'app_add_cps_handler_include.c.ftl'),
                        ('CSS_APP_GAP_HANDLER', 'LIST_GAP_EVT_HANDLER_APP_HANDLER', 'app_add_cps_gap_handler.c.ftl'),
                        ('CSS_APP_GATT_HANDLER', 'LIST_GATT_EVT_HANDLER_APP_HANDLER', 'app_add_cps_gatt_handler.c.ftl'),
                        ('CSS_APP_INIT', 'WLS_BLE_LIST_DEV_SUPP_INIT_C', 'app_add_cps_init.c.ftl'),
                        ('CSS_APP_INCLUDE', 'WLS_BLE_LIST_DEV_SUPP_INCLUDE_C', 'app_add_cps_include.c.ftl')]

    n = 0
    cssAppBleConf = []
    for I, L, F in cssAppBleConfigTemplates:
        cssAppBleConf.append(component.createFileSymbol(I, None))
        cssAppBleConf[n].setType('STRING')
        cssAppBleConf[n].setOutputName('wlsbleconfig.'+ L)
        cssAppBleConf[n].setSourcePath('services/ble/ble_custom_protocol/src/templates/' + F)
        cssAppBleConf[n].setMarkup(True)
        n = n + 1