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
global enableCustSvcCharaProp
def enableCustSvcCharaProp(svc,svcchar,enable):
   cmsComponent = Database.getComponentByID("SERVICE_CMS")
   if (cmsComponent != None):
      wrcmd = cmsComponent.getSymbolByID("CMS_BOOL_SVC_" + str(svc) + "_CHAR_" + str(svcchar) + "_PROP_WRITE_CMD")
      wrreq = cmsComponent.getSymbolByID("CMS_BOOL_SVC_" + str(svc) + "_CHAR_" + str(svcchar) + "_PROP_WRITE_REQ")
      notify = cmsComponent.getSymbolByID("CMS_BOOL_SVC_" + str(svc)  + "_CHAR_" + str(svcchar) + "_PROP_NOTIFY")
      varlen = cmsComponent.getSymbolByID("CMS_BOOL_SVC_" + str(svc) + "_CHAR_" + str(svcchar) + "_SETTING_VAR")
      maxlen = cmsComponent.getSymbolByID("CMS_INT_SVC_" + str(svc) + "_CHAR_" + str(svcchar) + "_LEN")
      wrcmd.setValue(enable)
      wrcmd.setReadOnly(enable)
      wrreq.setValue(enable)
      wrreq.setReadOnly(enable)
      notify.setValue(enable)
      notify.setReadOnly(enable)
      varlen.setValue(enable)
      varlen.setReadOnly(enable)
      if enable == True:
         maxlen.setValue(247)
      else:
         maxlen.setValue(1)



global commandInfoSymbolVisible
def commandInfoSymbolVisible(commandinfosymbol,byteelement,visible):
    if visible == True:
       commandinfosymbol.setVisible(True)
    else:
      if commandinfosymbol.getVisible() == True:
         listRange = byteelement.getValues()
         if any(s.startswith("OPCODE") for s in listRange):
            commandinfosymbol.setVisible(False)

global endDelimiterSymbolVisible
def endDelimiterSymbolVisible(enddelimitersymbol,byteelement,visible,visiblemsb):
    if visible == True:
       enddelimitersymbol[0].setVisible(True)
       enddelimitersymbol[1].setVisible(False)
       enddelimitersymbol[2].setVisible(False)
    elif visiblemsb == True:
       enddelimitersymbol[0].setVisible(False)
       enddelimitersymbol[1].setVisible(True)
       enddelimitersymbol[2].setVisible(True)
    else:
       listRange = byteelement.getValues()
       if any(s.startswith("END_DELIMITER") for s in listRange):
          enddelimitersymbol[0].setVisible(False)
          enddelimitersymbol[1].setVisible(False)
          enddelimitersymbol[2].setVisible(False)
    
global configCustomService
def configCustomService():
    cmsComponent = Database.getComponentByID("SERVICE_CMS")
    if (cmsComponent != None):
        cmsSvccount = cmsComponent.getSymbolByID('CMS_INT_SERVICE_COUNT')
        svcCount = cmsSvccount.getValue()
        if svcCount > cssSvcMaxCount:
           svcCount = cssSvcMaxCount
        for count in range(0, cssSvcMaxCount):
            custSysSvcConfMenu[count].setVisible(False)

        for count in range(0, svcCount):
            cmsSvcname = cmsComponent.getSymbolByID('CMS_STR_SVC_NAME_' + str(count)).getValue()
            custSysSvcName[count].setValue(cmsSvcname)
            custSysSvcConfMenu[count].setVisible(True)
            svcCharCount = cmsComponent.getSymbolByID('CMS_INT_SVC_CHAR_COUNT_' + str(count)).getValue()
            svcCpCount = svcCharCount
            if svcCharCount > cssSvcCpMaxCount:
                svcCpCount = cssSvcCpMaxCount
            for cpcount in range(0, cssSvcCpMaxCount):
                cssSvcCharMenu[count][cpcount].setVisible(False)
            for cpcount in range(0, svcCpCount):
                cssSvcCharMenu[count][cpcount].setVisible(True)
            if svcCount == 1 and svcCpCount == 1:
               serUUID = cmsComponent.getSymbolByID('CMS_STR_SVC_UUID_0')
               charUUID = cmsComponent.getSymbolByID('CMS_STR_SVC_0_CHAR_0_UUID')
               if serUUID.getValue() == '0000' and charUUID.getValue() == '0000':
                  serUUID.setValue('144d508b1543489787489227dfcb15b0')
                  charUUID.setValue('da6dc1884bf646928734214fdf2ca1e4')
    bleStackComponent = Database.getComponentByID("BLE_STACK_LIB")
    if (bleStackComponent != None):
        sleepModeEN = bleStackComponent.getSymbolByID('BLE_SYS_SLEEP_MODE_EN')
        sleepModeEN.setValue(True)
        Database.setSymbolValue("BLE_STACK_LIB", "GAP_ADV_DATA_LOCAL_NAME","ble_cps_app")


global headerByteSelect
def headerByteSelect(component,svc,svcchar,bytenumber,byteelement,bytevalue):
    commandinfosymbol = component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_COMMAND_COUNT")
    if bytevalue == "DELIMITER":
       commandInfoSymbolVisible(commandinfosymbol,byteelement[bytenumber],False)
       cpCommandHeaderByteTypeFiltered = [item for item in cssCommandHeaderByteType if item not in ["DELIMITER", "DELIMITER_MSB"]]
       component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_DELIMITER").setVisible(True)
       component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_DELIMITER_MSB").setVisible(False)
       component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_DELIMITER_LSB").setVisible(False)
       byteelement[1].setRange(cpCommandHeaderByteTypeFiltered)
       byteelement[1].setValue("UNUSED")

    elif bytevalue == "DELIMITER_MSB":
       commandInfoSymbolVisible(commandinfosymbol,byteelement[bytenumber],False)
       component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_DELIMITER").setVisible(False)
       component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_DELIMITER_MSB").setVisible(True)
       byteelement[1].setRange(["DELIMITER_LSB"])

    elif bytevalue == "DELIMITER_LSB":
        cpCommandHeaderByteTypeFiltered = byteelement[0].getValues()
        cpCommandHeaderByteTypeFiltered = [item for item in cpCommandHeaderByteTypeFiltered if item not in ["DELIMITER", "DELIMITER_MSB"]]
        component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_DELIMITER_LSB").setVisible(True)
        byteelement[2].setRange(cpCommandHeaderByteTypeFiltered)
        byteelement[2].setValue("UNUSED")

    elif bytevalue == "SEQNUM":
        commandInfoSymbolVisible(commandinfosymbol,byteelement[bytenumber],False)
        if bytenumber == 0:
           component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_DELIMITER").setVisible(False)
           component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_DELIMITER_MSB").setVisible(False)
           component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_DELIMITER_LSB").setVisible(False)
           cpCommandHeaderByteTypeFiltered = [item for item in cssCommandHeaderByteType if item not in ["DELIMITER", "DELIMITER_MSB",\
                                                                                                        "SEQNUM","SEQNUM_MSB"]]
           #cpCommandHeaderByteTypeFiltered = [item for item in cpCommandHeaderByteTypeFiltered if not item.endswith("LSB")]
        else:
           if bytenumber == 1:
              component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_DELIMITER_LSB").setVisible(False)
           cpCommandHeaderByteTypeFiltered = byteelement[bytenumber].getValues()
           cpCommandHeaderByteTypeFiltered = [item for item in cpCommandHeaderByteTypeFiltered if item not in ["SEQNUM", "SEQNUM_MSB"]]
        byteelement[bytenumber+1].setRange(cpCommandHeaderByteTypeFiltered)
        byteelement[bytenumber+1].setValue("UNUSED")
    
    elif bytevalue == "SEQNUM_MSB":
        commandInfoSymbolVisible(commandinfosymbol,byteelement[bytenumber],False)
        if bytenumber == 0:
           component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_DELIMITER").setVisible(False)
           component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_DELIMITER_MSB").setVisible(False)
           component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_DELIMITER_LSB").setVisible(False)
        else:
           if bytenumber == 1:
              component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_DELIMITER_LSB").setVisible(False)
        byteelement[bytenumber+1].setRange(["SEQNUM_LSB"])

    elif bytevalue == "SEQNUM_LSB":
        cpCommandHeaderByteTypeFiltered = byteelement[bytenumber-1].getValues()
        if bytenumber == 1:
           component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_DELIMITER_LSB").setVisible(False)
           cpCommandHeaderByteTypeFiltered = [item for item in cpCommandHeaderByteTypeFiltered if item not in ["DELIMITER", "DELIMITER_MSB"]]
        cpCommandHeaderByteTypeFiltered = [item for item in cpCommandHeaderByteTypeFiltered if item not in ["SEQNUM", "SEQNUM_MSB"]]
        byteelement[bytenumber+1].setRange(cpCommandHeaderByteTypeFiltered)
        byteelement[bytenumber+1].setValue("UNUSED")
    
    elif bytevalue == "OPCODE":
        commandInfoSymbolVisible(commandinfosymbol,byteelement[bytenumber],True)
        if bytenumber == 0:
            component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_DELIMITER").setVisible(False)
            component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_DELIMITER_MSB").setVisible(False)
            component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_DELIMITER_LSB").setVisible(False)
            cpCommandHeaderByteTypeFiltered = [item for item in cssCommandHeaderByteType if item not in ["DELIMITER", "DELIMITER_MSB",\
                                                                                                        "OPCODE","OPCODE_MSB"]]
            #cpCommandHeaderByteTypeFiltered = [item for item in cpCommandHeaderByteTypeFiltered if not item.endswith("LSB")]
        else:
            if bytenumber == 1:
               component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_DELIMITER_LSB").setVisible(False)
            cpCommandHeaderByteTypeFiltered = byteelement[bytenumber].getValues()
            cpCommandHeaderByteTypeFiltered = [item for item in cpCommandHeaderByteTypeFiltered if item not in ["OPCODE", "OPCODE_MSB"]]
        byteelement[bytenumber+1].setRange(cpCommandHeaderByteTypeFiltered)
        byteelement[bytenumber+1].setValue("UNUSED")
    
    elif bytevalue == "OPCODE_MSB":
        commandInfoSymbolVisible(commandinfosymbol,byteelement[bytenumber],True)
        if bytenumber == 0:
           component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_DELIMITER").setVisible(False)
           component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_DELIMITER_MSB").setVisible(False)
           component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_DELIMITER_LSB").setVisible(False)
        else:
           if bytenumber == 1:
              component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_DELIMITER_LSB").setVisible(False)
        byteelement[bytenumber+1].setRange(["OPCODE_LSB"])
    
    elif bytevalue == "OPCODE_LSB":
        cpCommandHeaderByteTypeFiltered = byteelement[bytenumber-1].getValues()
        if bytenumber == 1:
           component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_DELIMITER_LSB").setVisible(False)
           cpCommandHeaderByteTypeFiltered = [item for item in cpCommandHeaderByteTypeFiltered if item not in ["DELIMITER", "DELIMITER_MSB"]]
        cpCommandHeaderByteTypeFiltered = [item for item in cpCommandHeaderByteTypeFiltered if item not in ["OPCODE", "OPCODE_MSB"]]
        byteelement[bytenumber+1].setRange(cpCommandHeaderByteTypeFiltered)
        byteelement[bytenumber+1].setValue("UNUSED")

    elif bytevalue == "PAYLOAD_LEN":
        commandInfoSymbolVisible(commandinfosymbol,byteelement[bytenumber],False)
        if bytenumber == 0:
           component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_DELIMITER").setVisible(False)
           component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_DELIMITER_MSB").setVisible(False)
           component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_DELIMITER_LSB").setVisible(False)
           cpCommandHeaderByteTypeFiltered = [item for item in cssCommandHeaderByteType if item not in ["DELIMITER", "DELIMITER_MSB",\
                                                                                                     "PAYLOAD_LEN","PAYLOAD_LEN_MSB"]]
        else:
           if bytenumber == 1:
              component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_DELIMITER_LSB").setVisible(False)
           cpCommandHeaderByteTypeFiltered = byteelement[bytenumber].getValues()
           cpCommandHeaderByteTypeFiltered = [item for item in cpCommandHeaderByteTypeFiltered if item not in ["PAYLOAD_LEN", "PAYLOAD_LEN_MSB"]]
        byteelement[bytenumber+1].setRange(cpCommandHeaderByteTypeFiltered)
        byteelement[bytenumber+1].setValue("UNUSED")
    
    elif bytevalue == "PAYLOAD_LEN_MSB":
        commandInfoSymbolVisible(commandinfosymbol,byteelement[bytenumber],False)
        if bytenumber == 0:
           component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_DELIMITER").setVisible(False)
           component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_DELIMITER_MSB").setVisible(False)
           component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_DELIMITER_LSB").setVisible(False)
        else:
           if bytenumber == 1:
              component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_DELIMITER_LSB").setVisible(False)
        byteelement[bytenumber+1].setRange(["PAYLOAD_LEN_LSB"])
    
    elif bytevalue == "PAYLOAD_LEN_LSB":
        cpCommandHeaderByteTypeFiltered = byteelement[bytenumber-1].getValues()
        if bytenumber == 1:
           component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_DELIMITER_LSB").setVisible(False)
           cpCommandHeaderByteTypeFiltered = [item for item in cpCommandHeaderByteTypeFiltered if item not in ["DELIMITER", "DELIMITER_MSB"]]
        cpCommandHeaderByteTypeFiltered = [item for item in cpCommandHeaderByteTypeFiltered if item not in ["PAYLOAD_LEN", "PAYLOAD_LEN_MSB"]]
        byteelement[bytenumber+1].setRange(cpCommandHeaderByteTypeFiltered)
        byteelement[bytenumber+1].setValue("UNUSED")

global footerByteSelect
def footerByteSelect(component,svc,svcchar,bytenumber,byteelement,bytevalue):
    enddelimitersymbol = []
    polysymbol = component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_POLY")
    crcstartsymbol = component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_CRC_BYTE_START")
    enddelimitersymbol.append(component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_END_DELIMITER"))
    enddelimitersymbol.append(component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_END_DELIMITER_MSB"))
    enddelimitersymbol.append(component.getSymbolByID("CSS_INT_SVC_" + str(svc) + "_CP_" + str(svcchar) + "_END_DELIMITER_LSB"))
    if bytevalue == "CHECKSUM8":
       polysymbol.setVisible(False)
       crcstartsymbol.setVisible(True)
       endDelimiterSymbolVisible(enddelimitersymbol,byteelement[bytenumber],False,False)
       byteelement[bytenumber+1].setRange(["UNUSED"])
       footerByteTypeFiltered = [item for item in cssCommandFooterByteType if item not in ["CHECKSUM8","CHECKSUM16_MSB","CHECKSUM32_MSB",\
                                                                                           "CRC8","CRC16_MSB","CRC32_MSB"]]
       byteelement[bytenumber+1].setRange(footerByteTypeFiltered)
       byteelement[bytenumber+1].setValue("UNUSED")

    elif bytevalue == "CHECKSUM16_MSB":
         polysymbol.setVisible(False)
         crcstartsymbol.setVisible(True)
         endDelimiterSymbolVisible(enddelimitersymbol,byteelement[bytenumber],False,False)
         byteelement[bytenumber+1].setRange(["CHECKSUM16_LSB"])

    elif bytevalue == "CHECKSUM16_LSB":
         byteelement[bytenumber+1].setRange(["UNUSED"])
         footerByteTypeFiltered = byteelement[bytenumber-1].getValues()
         footerByteTypeFiltered = [item for item in footerByteTypeFiltered if item not in ["CHECKSUM8","CHECKSUM16_MSB","CHECKSUM32_MSB",\
                                                                                           "CRC8","CRC16_MSB","CRC32_MSB"]]
         byteelement[bytenumber+1].setRange(footerByteTypeFiltered)
         byteelement[bytenumber+1].setValue("UNUSED")

    elif bytevalue == "CHECKSUM32_MSB":
         polysymbol.setVisible(False)
         crcstartsymbol.setVisible(True)
         endDelimiterSymbolVisible(enddelimitersymbol,byteelement[bytenumber],False,False)
         byteelement[bytenumber+1].setRange(["CHECKSUM32_BYTE3"])
    
    elif bytevalue == "CHECKSUM32_BYTE3":
         byteelement[bytenumber+1].setRange(["UNUSED"])
         byteelement[bytenumber+1].setRange(["CHECKSUM32_BYTE2"])

    elif bytevalue == "CHECKSUM32_BYTE2":
         byteelement[bytenumber+1].setRange(["UNUSED"])
         byteelement[bytenumber+1].setRange(["CHECKSUM32_LSB"])
    
    elif bytevalue == "CHECKSUM32_LSB":
         byteelement[bytenumber+1].setRange(["UNUSED"])
         footerByteTypeFiltered = byteelement[bytenumber-3].getValues()
         footerByteTypeFiltered = [item for item in footerByteTypeFiltered if item not in ["CHECKSUM8","CHECKSUM16_MSB","CHECKSUM32_MSB",\
                                                                                           "CRC8","CRC16_MSB","CRC32_MSB"]]
         byteelement[bytenumber+1].setRange(footerByteTypeFiltered)
         byteelement[bytenumber+1].setValue("UNUSED")

    elif bytevalue == "CRC8":
         polysymbol.setMax(0xFF)
         polysymbol.setVisible(True)
         crcstartsymbol.setVisible(True)
         endDelimiterSymbolVisible(enddelimitersymbol,byteelement[bytenumber],False,False)
         byteelement[bytenumber+1].setRange(["UNUSED"])
         footerByteTypeFiltered = [item for item in cssCommandFooterByteType if item not in ["CHECKSUM8","CHECKSUM16_MSB","CHECKSUM32_MSB",\
                                                                                             "CRC8","CRC16_MSB","CRC32_MSB"]]
         byteelement[bytenumber+1].setRange(footerByteTypeFiltered)
         byteelement[bytenumber+1].setValue("UNUSED")

    elif bytevalue == "CRC16_MSB":
         polysymbol.setVisible(True)
         polysymbol.setMax(0xFFFF)
         crcstartsymbol.setVisible(True)
         endDelimiterSymbolVisible(enddelimitersymbol,byteelement[bytenumber],False,False)
         byteelement[bytenumber+1].setRange(["CRC16_LSB"])

    elif bytevalue == "CRC16_LSB":
         byteelement[bytenumber+1].setRange(["UNUSED"])
         footerByteTypeFiltered = byteelement[bytenumber-1].getValues()
         footerByteTypeFiltered = [item for item in footerByteTypeFiltered if item not in ["CHECKSUM8","CHECKSUM16_MSB","CHECKSUM32_MSB",\
                                                                                           "CRC8","CRC16_MSB","CRC32_MSB"]]
         byteelement[bytenumber+1].setRange(footerByteTypeFiltered)
         byteelement[bytenumber+1].setValue("UNUSED")

    elif bytevalue == "CRC32_MSB":
         polysymbol.setVisible(True)
         polysymbol.setMax(0xFFFFFFFF)
         crcstartsymbol.setVisible(True)
         endDelimiterSymbolVisible(enddelimitersymbol,byteelement[bytenumber],False,False)
         byteelement[bytenumber+1].setRange(["CRC32_BYTE3"])
    
    elif bytevalue == "CRC32_BYTE3":
         byteelement[bytenumber+1].setRange(["UNUSED"])
         byteelement[bytenumber+1].setRange(["CRC32_BYTE2"])

    elif bytevalue == "CRC32_BYTE2":
         byteelement[bytenumber+1].setRange(["UNUSED"])
         byteelement[bytenumber+1].setRange(["CRC32_LSB"])
    
    elif bytevalue == "CRC32_LSB":
         byteelement[bytenumber+1].setRange(["UNUSED"])
         footerByteTypeFiltered = byteelement[bytenumber-3].getValues()
         footerByteTypeFiltered = [item for item in footerByteTypeFiltered if item not in ["CHECKSUM8","CHECKSUM16_MSB","CHECKSUM32_MSB",\
                                                                                           "CRC8","CRC16_MSB","CRC32_MSB"]]
         byteelement[bytenumber+1].setRange(footerByteTypeFiltered)
         byteelement[bytenumber+1].setValue("UNUSED")

    elif bytevalue == "END_DELIMITER":
         endDelimiterSymbolVisible(enddelimitersymbol,byteelement[bytenumber],True,False)
         listRange = byteelement[bytenumber].getValues()
         if any(s.startswith("CRC") for s in listRange):
            polysymbol.setVisible(False)
            crcstartsymbol.setVisible(False)
         byteelement[bytenumber+1].setRange(["UNUSED"])

    elif bytevalue == "END_DELIMITER_MSB":
         endDelimiterSymbolVisible(enddelimitersymbol,byteelement[bytenumber],False,True)
         listRange = byteelement[bytenumber].getValues()
         if any(s.startswith("CRC") for s in listRange):
            polysymbol.setVisible(False)
            crcstartsymbol.setVisible(False)
         byteelement[bytenumber+1].setRange(["END_DELIMITER_LSB"])

    elif bytevalue == "END_DELIMITER_LSB":
         byteelement[bytenumber+1].setRange(["UNUSED"])