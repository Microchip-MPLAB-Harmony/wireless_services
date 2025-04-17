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

import re

cssSvcMaxCount          = 5
cssSvcCpMaxCount        = 10

csSvcCharMaxHeaderLength    = 8
csSvcCharMaxFooterLength    = 6
cssCommandMaxCount          = 50

custSysSvcConfMenu          = []
custSysSvcName              = []
cssSvcCharMenu              = []
cpCommandHeaderByte         = []
cpCommandFooterByte         = []

cssConfigName               = ''

cssCommandHeaderByteType     = ["UNUSED","DELIMITER","DELIMITER_MSB",\
                               "SEQNUM","SEQNUM_MSB","OPCODE","OPCODE_MSB",\
                               "PAYLOAD_LEN","PAYLOAD_LEN_MSB"]

cssCommandFooterByteType    = ["UNUSED","CHECKSUM8","CHECKSUM16_MSB","CHECKSUM32_MSB",\
                               "CRC8","CRC16_MSB","CRC32_MSB","END_DELIMITER",\
                               "END_DELIMITER_MSB"]
################################################################################
#### Component ####
###############################################################################
def cssSvcConfMenuVisible(symbol, event):
    svcCount = event["value"]
    if svcCount > cssSvcMaxCount:
       svcCount = cssSvcMaxCount
    for count in range(0, cssSvcMaxCount):
        custSysSvcConfMenu[count].setVisible(False)

    for count in range(0, svcCount):
        custSysSvcConfMenu[count].setVisible(True)

def cssSvcNameConfig(symbol, event):
    svcName = event["value"]
    symbol.setValue(svcName)
    component = symbol.getComponent()
    numbers = re.findall(r'\d+', event["id"])
    numbers = [int(number) for number in numbers]
    svcCount = numbers[0]
    for svcchar in range(0, cssSvcCpMaxCount):
        updateDecodeFilesName(component,svcCount,svcchar,svcName)

def cssSvcCharConfMenuVisible(symbol, event):
    svcCharCount = event["value"]
    numbers = re.findall(r'\d+', event["id"])
    numbers = [int(number) for number in numbers]
    svcCount = numbers[0]
    svcCpCount = svcCharCount
    if svcCharCount > cssSvcCpMaxCount:
        svcCpCount = cssSvcCpMaxCount
    for cpcount in range(0, cssSvcCpMaxCount):
        cssSvcCharMenu[svcCount][cpcount].setVisible(False)
    for cpcount in range(0, svcCpCount):
        cssSvcCharMenu[svcCount][cpcount].setVisible(True)

def cssEscapeCharVisible(symbol, event):
    value = event["value"]
    if value == True:
       symbol.setVisible(True)
    else:
       symbol.setVisible(False)

def cssCommandMenuVisible(symbol, event):
    commandCount = event["value"]
    numbers = re.findall(r'\d+', event["id"])
    # Convert them to integers
    numbers = [int(number) for number in numbers]
    svcchar = numbers[1]
    svc = numbers[0]
    component = symbol.getComponent()
    commonIDStr = "CSS_MENU_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_COMMAND_MENU"
    for count in range(0, cssCommandMaxCount):
        component.getSymbolByID(commonIDStr + str(count)).setVisible(False)
    for count in range(0, commandCount):
        component.getSymbolByID(commonIDStr + str(count)).setVisible(True)

def cssCustomProtocolEnable(symbol, event):
    component  = symbol.getComponent()
    numbers = re.findall(r'\d+', event["id"])
    # Convert them to integers
    numbers = [int(number) for number in numbers]
    svcchar = numbers[1]
    svc = numbers[0]
    headerbytemenu = component.getSymbolByID("CSS_MENU_SVC_" + str(svc) + "_CP_HEADER" + str(svcchar))
    footerbytemenu = component.getSymbolByID("CSS_MENU_SVC_" + str(svc) + "_CP_FOOTER" + str(svcchar))
    datainfomenu = component.getSymbolByID("CSS_MENU_SVC_" + str(svc) + "_CP_COMMAND_DATA_INFO_" + str(svcchar))
    if event["value"] == True:
       headerbytemenu.setVisible(True)
       footerbytemenu.setVisible(True)
       datainfomenu.setVisible(True)
       
       cpCommandHeaderByte[svc][svcchar][0].setRange(cssCommandHeaderByteType)
       cpCommandHeaderByte[svc][svcchar][0].setValue("UNUSED")
       cpCommandHeaderByte[svc][svcchar][0].setVisible(True)
       cpCommandFooterByte[svc][svcchar][0].setRange(cssCommandFooterByteType)
       cpCommandFooterByte[svc][svcchar][0].setValue("UNUSED")
       cpCommandFooterByte[svc][svcchar][0].setVisible(True)

       enableDecodeFiles(component,svc,svcchar,True)
       enableCustSvcCharaProp(svc,svcchar,True)
    else:
       headerbytemenu.setVisible(False)
       footerbytemenu.setVisible(False)
       datainfomenu.setVisible(False)

       for bytecount in range(0, csSvcCharMaxHeaderLength):
        if(cpCommandHeaderByte[svc][svcchar][bytecount].getVisible()):
            cpCommandHeaderByte[svc][svcchar][bytecount].setRange(["UNUSED"])
            cpCommandHeaderByte[svc][svcchar][bytecount].setVisible(False)
        if(bytecount < csSvcCharMaxFooterLength):
            if(cpCommandFooterByte[svc][svcchar][bytecount].getVisible()):
                cpCommandFooterByte[svc][svcchar][bytecount].setRange(["UNUSED"])
                cpCommandFooterByte[svc][svcchar][bytecount].setVisible(False)

       enableDecodeFiles(component,svc,svcchar,False)
       enableCustSvcCharaProp(svc,svcchar,False)


def cpCommandHeaderByteSelect(symbol, event):
    # Storing functions in a list
    byteValue = event["value"]
    numbers = re.findall(r'\d+', event["id"])
    # Convert them to integers
    numbers = [int(number) for number in numbers]
    bytenumber = numbers[2]
    svcchar = numbers[1]
    svc = numbers[0]
    component  = symbol.getComponent()
    currlistvals = symbol.getValues()
    currlistlen = len(currlistvals)
    crcbytestartsymbol = component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_CRC_BYTE_START")
    headerlengthsymbol = component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_HEADER_LEN")
    if (bytenumber < csSvcCharMaxHeaderLength-1) and (byteValue != "UNUSED"):
       headerByteSelect(component,svc,svcchar,bytenumber,cpCommandHeaderByte[svc][svcchar],byteValue)
       listvals = cpCommandHeaderByte[svc][svcchar][bytenumber+1].getValues()
       numberofelements = len(listvals)
       if numberofelements == 1 and listvals[0] == "UNUSED":
          cpCommandHeaderByte[svc][svcchar][bytenumber+1].setVisible(False)
          headerlengthsymbol.setValue(bytenumber+1)
          crcbytestartsymbol.setMax(bytenumber)
       elif numberofelements == 1 and listvals[0] != "UNUSED":
          cpCommandHeaderByte[svc][svcchar][bytenumber+1].setVisible(True)
          headerlengthsymbol.setValue(bytenumber+2)
          crcbytestartsymbol.setMax(bytenumber+1)
       else:
          cpCommandHeaderByte[svc][svcchar][bytenumber+1].setVisible(True)

    elif (bytenumber < csSvcCharMaxHeaderLength-1) and (byteValue == "UNUSED") and (currlistlen > 1):
        headerlengthsymbol.setValue(bytenumber)
        commandinfosymbol = component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_COMMAND_COUNT")
        commandInfoSymbolVisible(commandinfosymbol,cpCommandHeaderByte[svc][svcchar][bytenumber],False)
        if bytenumber == 0:
           component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_DELIMITER").setVisible(False)
           component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_DELIMITER_MSB").setVisible(False)
           component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_DELIMITER_LSB").setVisible(False)
           crcbytestartsymbol.setMax(bytenumber)
        else:
           crcbytestartsymbol.setMax(bytenumber-1)
        for bytecount in range((bytenumber+1), csSvcCharMaxHeaderLength):
            if(cpCommandHeaderByte[svc][svcchar][bytecount].getVisible()):
               cpCommandHeaderByte[svc][svcchar][bytecount].setRange(["UNUSED"])
               cpCommandHeaderByte[svc][svcchar][bytecount].setVisible(False)

def cssCommandFooterByteSelect(symbol, event):
    enddelimitersymbol = []
    # Storing functions in a list
    byteValue = event["value"]
    numbers = re.findall(r'\d+', event["id"])
    # Convert them to integers
    numbers = [int(number) for number in numbers]
    bytenumber = numbers[2]
    svcchar = numbers[1]
    svc = numbers[0]
    component  = symbol.getComponent()
    currlistvals = symbol.getValues()
    currlistlen = len(currlistvals)
    footerlengthsymbol = component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_FOOTER_LEN")
    enddelimitersymbol.append(component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_END_DELIMITER"))
    enddelimitersymbol.append(component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_END_DELIMITER_MSB"))
    enddelimitersymbol.append(component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_END_DELIMITER_LSB"))
    if (bytenumber < csSvcCharMaxFooterLength-1) and (byteValue != "UNUSED"):
       footerByteSelect(component,svc,svcchar,bytenumber,cpCommandFooterByte[svc][svcchar],byteValue)
       listvals = cpCommandFooterByte[svc][svcchar][bytenumber+1].getValues()
       numberofelements = len(listvals)
       if numberofelements == 1 and listvals[0] == "UNUSED":
        #   cpCommandFooterByte[svc][svcchar][bytenumber+1].setVisible(False)
          for bytecount in range((bytenumber+1), csSvcCharMaxFooterLength):
            cpCommandFooterByte[svc][svcchar][bytecount].setVisible(False)
          footerlengthsymbol.setValue(bytenumber+1)
       elif numberofelements == 1 and listvals[0] != "UNUSED":
          cpCommandFooterByte[svc][svcchar][bytenumber+1].setVisible(True)
          if listvals[0] == "CHECKSUM32_BYTE3" or listvals[0] == "CRC32_BYTE3":
            footerlengthsymbol.setValue(bytenumber+4)
          else:
            footerlengthsymbol.setValue(bytenumber+2)
       else:
          cpCommandFooterByte[svc][svcchar][bytenumber+1].setVisible(True)
        #   footerlengthsymbol.setValue(bytenumber+1)

    elif (bytenumber < csSvcCharMaxFooterLength-1) and (byteValue == "UNUSED") and (currlistlen > 1):
        footerlengthsymbol.setValue(bytenumber)
        endDelimiterSymbolVisible(enddelimitersymbol,cpCommandFooterByte[svc][svcchar][bytenumber],False,False)
        if any(s.startswith("CRC") for s in currlistvals):
           component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_POLY").setVisible(False)
           component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_CRC_BYTE_START").setVisible(False)
        for bytecount in range((bytenumber+1), csSvcCharMaxFooterLength):
            if(cpCommandFooterByte[svc][svcchar][bytecount].getVisible()):
               cpCommandFooterByte[svc][svcchar][bytecount].setRange(["UNUSED"])
               cpCommandFooterByte[svc][svcchar][bytecount].setVisible(False)

def instantiateComponent(bleCssComp):
    print('custom_protocol_service')
    global cssConfigName
    cssConfigName = Variables.get("__CONFIGURATION_NAME")
    print cssConfigName
    processor = Variables.get("__PROCESSOR")
    print processor
    
    requiredComponents = ['wlsbleconfig','SERVICE_CMS']

    for r in requiredComponents:
        activeComponents = Database.getActiveComponentIDs()
        if r not in activeComponents:
            res = Database.activateComponents([r],"__ROOTVIEW",False)

    print('Config Name: {} processor: {}'.format(cssConfigName, processor))

    # Cusotom System config
    execfile(Module.getPath() + "services/ble/ble_custom_protocol/config/ble_custom_protocol_config.py")

    # Cusotom System file
    execfile(Module.getPath() + "services/ble/ble_custom_protocol/config/ble_custom_protocol_file.py")

    cpsServiceSetting = bleCssComp.createMenuSymbol('CPS_MENU_SERVICE_SETTING', None)
    cpsServiceSetting.setLabel('Service configuration')
    cpsServiceSetting.setVisible(True)
    cpsServiceSetting.setDescription("WME config settings")

    cssAppCode = bleCssComp.createBooleanSymbol('CSS_BOOL_APP_CODE_ENABLE', None)
    cssAppCode.setLabel('Enable App Code Generation')
    cssAppCode.setDescription('Enable App Code Generation for generating sample code')
    cssAppCode.setDefaultValue(True)
    cssAppCode.setVisible(True)
    
    for count in range(0, cssSvcMaxCount):
        custSysSvcConfMenu.append(count)
        custSysSvcConfMenu[count] = bleCssComp.createMenuSymbol("CSS_MENU_SERVICE_" + str(count), cpsServiceSetting)
        custSysSvcConfMenu[count].setLabel("Service" + str(count))
        custSysSvcConfMenu[count].setDescription("Service" + str(count))
        if (count == 0):
            custSysSvcConfMenu[count].setDependencies(cssSvcConfMenuVisible,["SERVICE_CMS:CMS_INT_SERVICE_COUNT"])
        custSysSvcConfMenu[count].setVisible(False)

        custSysSvcName.append(count)
        custSysSvcName[count] = bleCssComp.createStringSymbol("CSS_STR_SVC_NAME_" + str(count), custSysSvcConfMenu[count])
        custSysSvcName[count].setLabel("Service Name")
        custSysSvcName[count].setDescription("Service Name")
        custSysSvcName[count].setDefaultValue("svc" + str(count))
        custSysSvcName[count].setReadOnly(True)
        custSysSvcName[count].setDependencies(cssSvcNameConfig,["SERVICE_CMS:CMS_STR_SVC_NAME_" + str(count)])

        cpCommandHeaderByte00 = []
        cpCommandFooterByte00 = []
        cssSvcCharMenu0  = []
        for charCount in range(0, cssSvcCpMaxCount):
            cssSvcCharMenu0.append(charCount)
            cssSvcCharMenu0[charCount] = bleCssComp.createMenuSymbol("CSS_MENU_SVC_" + str(count) + "_CHAR_" + str(charCount), custSysSvcConfMenu[count])
            cssSvcCharMenu0[charCount].setLabel("Characteristic " + str(charCount))
            if (charCount == 0):
                cssSvcCharMenu0[0].setDependencies(cssSvcCharConfMenuVisible, ["SERVICE_CMS:CMS_INT_SVC_CHAR_COUNT_" + str(count)])
                cssSvcCharMenu0[0].setVisible(True)
            else:
                cssSvcCharMenu0[charCount].setVisible(False)
                
            cssCpEnable = bleCssComp.createBooleanSymbol("CSS_BOOL_SVC_" + str(count) + "_CP_" + str(charCount) + "_COMMAND", cssSvcCharMenu0[charCount])
            cssCpEnable.setLabel("Custom Protocol")
            cssCpEnable.setDefaultValue(False)
            cssCpEnable.setDependencies(cssCustomProtocolEnable,["CSS_BOOL_SVC_" + str(count) + "_CP_" + str(charCount) + "_COMMAND"])

            ##cssCommandHeader
            cssCommandHeader = bleCssComp.createMenuSymbol("CSS_MENU_SVC_" + str(count) + "_CP_HEADER" + str(charCount), cssCpEnable)
            cssCommandHeader.setLabel("Header")
            cssCommandHeader.setDescription("Header")
            cssCommandHeader.setVisible(False)

            ##cpCommandHeaderLength
            cssCommandHeaderLength = bleCssComp.createIntegerSymbol("CSS_INT_SVC_" + str(count) + "_CP_" + str(charCount) + "_HEADER_LEN", cssCommandHeader)
            cssCommandHeaderLength.setLabel("Header length")
            cssCommandHeaderLength.setDescription("Header length")
            cssCommandHeaderLength.setMin(0)
            cssCommandHeaderLength.setMax(csSvcCharMaxHeaderLength)
            cssCommandHeaderLength.setDefaultValue(0)
            cssCommandHeaderLength.setVisible(False)
            cssCommandHeaderLength.setReadOnly(True)

            cpCommandHeaderByte0 = []
            for headerbyteCount in range(0, csSvcCharMaxHeaderLength):
                cpCommandHeaderByte0.append(headerbyteCount)
                cpCommandHeaderByte0[headerbyteCount] = bleCssComp.createComboSymbol("CSS_INT_SVC_" + str(count) + "_CP_" + str(charCount) + "HEADER_BYTE_" + str(headerbyteCount), cssCommandHeader,["UNUSED"])
                cpCommandHeaderByte0[headerbyteCount].setLabel("Byte_" + str(headerbyteCount))
                if (headerbyteCount == 0):
                    cpCommandHeaderByte0[headerbyteCount].setRange(cssCommandHeaderByteType)
                    cpCommandHeaderByte0[headerbyteCount].setVisible(True)
                else:
                    cpCommandHeaderByte0[headerbyteCount].setVisible(False)
                cpCommandHeaderByte0[headerbyteCount].setDefaultValue("UNUSED")
                cpCommandHeaderByte0[headerbyteCount].setDependencies(cpCommandHeaderByteSelect, ["CSS_INT_SVC_" + str(count) + "_CP_" + str(charCount) + "HEADER_BYTE_" + str(headerbyteCount)])


            cpCommandHeaderByte00.append(cpCommandHeaderByte0)

            cssCommandFooter = bleCssComp.createMenuSymbol("CSS_MENU_SVC_" + str(count) + "_CP_FOOTER" + str(charCount), cssCpEnable)
            cssCommandFooter.setLabel("Footer")
            cssCommandFooter.setDescription("Footer")
            cssCommandFooter.setVisible(False)

            cssCommandFooterLength = bleCssComp.createIntegerSymbol("CSS_INT_SVC_" + str(count) + "_CP_" + str(charCount) + "_FOOTER_LEN", cssCommandFooter)
            cssCommandFooterLength.setLabel("Footer length")
            cssCommandFooterLength.setDescription("Footer length")
            cssCommandFooterLength.setMin(0)
            cssCommandFooterLength.setMax(csSvcCharMaxFooterLength)
            cssCommandFooterLength.setDefaultValue(0)
            cssCommandFooterLength.setVisible(False)
            cssCommandFooterLength.setReadOnly(True)

            cpCommandFooterByte0 = []
            for footerbyteCount in range(0, csSvcCharMaxFooterLength):
                cpCommandFooterByte0.append(footerbyteCount)
                cpCommandFooterByte0[footerbyteCount] = bleCssComp.createComboSymbol("CSS_INT_SVC_" + str(count) + "_CP_" + str(charCount) + "FOOTER_BYTE_" + str(footerbyteCount), cssCommandFooter,["UNUSED"])
                cpCommandFooterByte0[footerbyteCount].setLabel("Byte_"+ str(footerbyteCount))
                if (footerbyteCount == 0):
                    cpCommandFooterByte0[footerbyteCount].setRange(cssCommandFooterByteType)
                    cpCommandFooterByte0[footerbyteCount].setVisible(True)
                else:
                    cpCommandFooterByte0[footerbyteCount].setVisible(False)
                cpCommandFooterByte0[footerbyteCount].setDefaultValue("UNUSED")
                cpCommandFooterByte0[footerbyteCount].setDependencies(cssCommandFooterByteSelect, ["CSS_INT_SVC_" + str(count) + "_CP_" + str(charCount) + "FOOTER_BYTE_" + str(footerbyteCount)])
            
            cpCommandFooterByte00.append(cpCommandFooterByte0)

            cssCommandDataInfo = bleCssComp.createMenuSymbol("CSS_MENU_SVC_" + str(count) + "_CP_COMMAND_DATA_INFO_" + str(charCount), cssCpEnable)
            cssCommandDataInfo.setLabel("Data Info")
            cssCommandDataInfo.setDescription("Data Info")
            cssCommandDataInfo.setVisible(False)

            cssCommandEscEnable = bleCssComp.createBooleanSymbol("CSS_BOOL_SVC_" + str(count) + "_CP_" + str(charCount) + "_ESCCHAR_ENABLE", cssCommandDataInfo)
            cssCommandEscEnable.setLabel("Escape Character Enable")
            cssCommandEscEnable.setDefaultValue(False)
            cssCommandEscEnable.setVisible(True)

            cpCommandEscChar = bleCssComp.createHexSymbol("CSS_HEX_SVC_" + str(count) + "_CP_" + str(charCount) + "_ESCCHAR", cssCommandEscEnable)
            cpCommandEscChar.setLabel("Escape Character")
            cpCommandEscChar.setMin(0)
            cpCommandEscChar.setMax(0xFF)
            cpCommandEscChar.setDefaultValue(0x0E)
            cpCommandEscChar.setVisible(False)
            cpCommandEscChar.setDependencies(cssEscapeCharVisible, ["CSS_BOOL_SVC_" + str(count) + "_CP_" + str(charCount) + "_ESCCHAR_ENABLE"])

            cssCommandHeaderdelimiter = bleCssComp.createHexSymbol("CSS_INT_SVC_" + str(count) + "_CP_" + str(charCount) + "_DELIMITER", cssCommandDataInfo)
            cssCommandHeaderdelimiter.setLabel("Delimiter")
            cssCommandHeaderdelimiter.setDescription("Delimiter")
            cssCommandHeaderdelimiter.setMin(0)
            cssCommandHeaderdelimiter.setMax(0xFF)
            cssCommandHeaderdelimiter.setDefaultValue(0xAB)
            cssCommandHeaderdelimiter.setVisible(False)

            cssCommandHeaderdelimitermsb = bleCssComp.createHexSymbol("CSS_INT_SVC_" + str(count) + "_CP_" + str(charCount) + "_DELIMITER_MSB", cssCommandDataInfo)
            cssCommandHeaderdelimitermsb.setLabel("Delimiter MSB")
            cssCommandHeaderdelimitermsb.setDescription("Delimiter MSB")
            cssCommandHeaderdelimitermsb.setMin(0)
            cssCommandHeaderdelimitermsb.setMax(0xFF)
            cssCommandHeaderdelimitermsb.setDefaultValue(0xAB)
            cssCommandHeaderdelimitermsb.setVisible(False)

            cssCommandHeaderdelimiterlsb = bleCssComp.createHexSymbol("CSS_INT_SVC_" + str(count) + "_CP_" + str(charCount) + "_DELIMITER_LSB", cssCommandDataInfo)
            cssCommandHeaderdelimiterlsb.setLabel("Delimiter LSB")
            cssCommandHeaderdelimiterlsb.setDescription("Delimiter LSB")
            cssCommandHeaderdelimiterlsb.setMin(0)
            cssCommandHeaderdelimiterlsb.setMax(0xFF)
            cssCommandHeaderdelimiterlsb.setDefaultValue(0xCD)
            cssCommandHeaderdelimiterlsb.setVisible(False)

            cssCommandHeaderenddelimiter = bleCssComp.createHexSymbol("CSS_INT_SVC_" + str(count) + "_CP_" + str(charCount) + "_END_DELIMITER", cssCommandDataInfo)
            cssCommandHeaderenddelimiter.setLabel("END Delimiter")
            cssCommandHeaderenddelimiter.setDescription("END Delimiter")
            cssCommandHeaderenddelimiter.setMin(0)
            cssCommandHeaderenddelimiter.setMax(0xFF)
            cssCommandHeaderenddelimiter.setDefaultValue(0xEF)
            cssCommandHeaderenddelimiter.setVisible(False)

            cssCommandHeaderenddelimitermsb = bleCssComp.createHexSymbol("CSS_INT_SVC_" + str(count) + "_CP_" + str(charCount) + "_END_DELIMITER_MSB", cssCommandDataInfo)
            cssCommandHeaderenddelimitermsb.setLabel("END Delimiter MSB")
            cssCommandHeaderenddelimitermsb.setDescription("END Delimiter MSB")
            cssCommandHeaderenddelimitermsb.setMin(0)
            cssCommandHeaderenddelimitermsb.setMax(0xFF)
            cssCommandHeaderenddelimitermsb.setDefaultValue(0xEF)
            cssCommandHeaderenddelimitermsb.setVisible(False)

            cssCommandHeaderenddelimiterlsb = bleCssComp.createHexSymbol("CSS_INT_SVC_" + str(count) + "_CP_" + str(charCount) + "_END_DELIMITER_LSB", cssCommandDataInfo)
            cssCommandHeaderenddelimiterlsb.setLabel("END Delimiter LSB")
            cssCommandHeaderenddelimiterlsb.setDescription("END Delimiter LSB")
            cssCommandHeaderenddelimiterlsb.setMin(0)
            cssCommandHeaderenddelimiterlsb.setMax(0xFF)
            cssCommandHeaderenddelimiterlsb.setDefaultValue(0x01)
            cssCommandHeaderenddelimiterlsb.setVisible(False)

            cssCommandCRCPoly = bleCssComp.createHexSymbol("CSS_INT_SVC_" + str(count) + "_CP_" + str(charCount) + "_POLY", cssCommandDataInfo)
            cssCommandCRCPoly.setLabel("CRC Poly")
            cssCommandCRCPoly.setDescription("CRC Poly")
            cssCommandCRCPoly.setMin(0)
            cssCommandCRCPoly.setDefaultValue(0xFFFFFFFF)
            cssCommandCRCPoly.setVisible(False)

            cssCommandCRCByteStart = bleCssComp.createIntegerSymbol("CSS_INT_SVC_" + str(count) + "_CP_" + str(charCount) + "_CRC_BYTE_START", cssCommandDataInfo)
            cssCommandCRCByteStart.setLabel("CRC/Checksum Start Byte")
            cssCommandCRCByteStart.setDescription("CRC/Checksum Start Byte")
            cssCommandCRCByteStart.setMin(0)
            cssCommandCRCByteStart.setMax(0)
            cssCommandCRCByteStart.setDefaultValue(0)
            cssCommandCRCByteStart.setVisible(False)

            cssCommandCount = bleCssComp.createIntegerSymbol("CSS_INT_SVC_" + str(count) + "_CP_" + str(charCount) + "_COMMAND_COUNT", cssCommandDataInfo)
            cssCommandCount.setLabel("Number of Commands")
            cssCommandCount.setDescription("Number of Commands")
            cssCommandCount.setMin(1)
            cssCommandCount.setMax(cssCommandMaxCount)
            cssCommandCount.setDefaultValue(1)
            cssCommandCount.setVisible(False)

            for commandCount in range(0, cssCommandMaxCount):
                cssCommandMenu = bleCssComp.createMenuSymbol("CSS_MENU_SVC_" + str(count) + "_CP_" + str(charCount) + "_COMMAND_MENU" + str(commandCount), cssCommandCount)
                cssCommandMenu.setLabel("Command" + str(commandCount+1))
                cssCommandMenu.setDescription("Command" + str(commandCount+1))
                if (commandCount == 0):
                    cssCommandMenu.setVisible(True)
                    cssCommandMenu.setDependencies(cssCommandMenuVisible, ["CSS_INT_SVC_" + str(count) + "_CP_" + str(charCount) + "_COMMAND_COUNT"])
                else:
                    cssCommandMenu.setVisible(False)

                cssCommandName = bleCssComp.createStringSymbol("CSS_STR_SVC_" + str(count) + "_CP_" + str(charCount) + "COMMAND_NAME" + str(commandCount), cssCommandMenu)
                cssCommandName.setLabel("Command Name")
                cssCommandName.setDescription("Command Name")
                cssCommandName.setDefaultValue("command" + str(commandCount+1))
                cssCommandName.setVisible(True)

                cssCommandID = bleCssComp.createHexSymbol("CSS_HEX_SVC_" + str(count) + "_CP_" + str(charCount) + "COMMAND_ID" + str(commandCount), cssCommandMenu)
                cssCommandID.setLabel("Opcode")
                cssCommandID.setDescription("Operational code")
                cssCommandID.setMin(0)
                cssCommandID.setDefaultValue(commandCount+1)
                cssCommandID.setVisible(True)

            createDecodeFileSymbols(bleCssComp,count,charCount)

        cpCommandHeaderByte.append(cpCommandHeaderByte00)
        cpCommandFooterByte.append(cpCommandFooterByte00)
        cssSvcCharMenu.append(cssSvcCharMenu0)
        
    createWriteHandlerFileSymbols(bleCssComp)

def destroyComponent(bleCssComp):
    cmsComponent = Database.getComponentByID("SERVICE_CMS")
    if (cmsComponent != None):
        for svc in range(0, cssSvcMaxCount):
            for svcchar in range(0, cssSvcCpMaxCount):
                cpEnable = bleCssComp.getSymbolByID("CSS_BOOL_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_COMMAND")
                if(cpEnable.getValue()):
                    cmsComponent.getSymbolByID("CMS_BOOL_SVC_" + str(svc) + "_CHAR_" + str(svcchar) + "_PROP_WRITE_CMD").setReadOnly(False)
                    cmsComponent.getSymbolByID("CMS_BOOL_SVC_" + str(svc) + "_CHAR_" + str(svcchar) + "_PROP_WRITE_REQ").setReadOnly(False)
                    cmsComponent.getSymbolByID("CMS_BOOL_SVC_" + str(svc)  + "_CHAR_" + str(svcchar) + "_PROP_NOTIFY").setReadOnly(False)
                    cmsComponent.getSymbolByID("CMS_BOOL_SVC_" + str(svc) + "_CHAR_" + str(svcchar) + "_SETTING_VAR").setReadOnly(False)

def finalizeComponent(bleCssComp):
    Database.activateComponents(["rtc"],"__ROOTVIEW",False)
    if 'pic32cx_bz2_devsupport' in Database.getActiveComponentIDs():
        Database.connectDependencies([['pic32cx_bz2_devsupport', 'RTC_Module', 'rtc', 'RTC_TMR']])
    elif 'pic32cx_bz3_devsupport' in Database.getActiveComponentIDs():
        Database.connectDependencies([['pic32cx_bz3_devsupport', 'RTC_Module', 'rtc', 'RTC_TMR']])
    configCustomService()