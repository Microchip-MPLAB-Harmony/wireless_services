<#assign CSS_SVC_NAME_ID = "CSS_STR_SVC_NAME_" + CSS_SVC>
<#assign CSS_SVC_NAME_VALUE = CSS_SVC_NAME_ID?eval>
<#assign CSS_SVC_HEADER_LEN_ID = "CSS_INT_SVC_" + CSS_SVC + "_CP_" + CSS_CP + "_HEADER_LEN">
<#assign CSS_SVC_HEADER_LEN_VALUE = CSS_SVC_HEADER_LEN_ID?eval>
<#assign CSS_SVC_FOOTER_LEN_ID = "CSS_INT_SVC_" + CSS_SVC + "_CP_" + CSS_CP + "_FOOTER_LEN">
<#assign CSS_SVC_FOOTER_LEN_VALUE = CSS_SVC_FOOTER_LEN_ID?eval>
<#assign CSS_SVC_ESCCHAR_ENABLE_ID = "CSS_BOOL_SVC_" + CSS_SVC + "_CP_" + CSS_CP + "_ESCCHAR_ENABLE">
<#assign CSS_SVC_ESCCHAR_ENABLE_VALUE = CSS_SVC_ESCCHAR_ENABLE_ID?eval>
<#assign CSS_SVC_FNVAR_NAME_VALUE = "BLE_CPS_" + CSS_SVC_NAME_VALUE?upper_case + CSS_CP + "_DECODE">
<#assign CSS_SVC_LFNVAR_NAME_VALUE = "ble_cps_" + CSS_SVC_NAME_VALUE?lower_case + CSS_CP + "_decode">
<#assign cssheaderbyteList = [] />
<#assign cssfooterbyteList = [] />
<#assign cssdelimiter = {"index": 0,"byteValue": "UNUSED"}>
<#assign cssseqnum = {"index": 0,"byteValue": "UNUSED"}>
<#assign cssopcode = {"index": 0,"byteValue": "UNUSED"}>
<#assign csslen = {"index": 0,"byteValue": "UNUSED"}>
<#assign csschecksum = {"index": 0,"byteValue": "UNUSED"}>
<#assign csscrc = {"index": 0,"byteValue": "UNUSED"}>
<#assign cssenddelimiter = {"index": 0,"byteValue": "UNUSED"}>
<#if (CSS_SVC_HEADER_LEN_VALUE > 0)>
  <#list 0..(CSS_SVC_HEADER_LEN_VALUE - 1) as i>
    <#assign CSS_SVC_BYTE_ID = "CSS_INT_SVC_" + CSS_SVC + "_CP_" + CSS_CP + "HEADER_BYTE_" + i>
    <#assign CSS_SVC_BYTE_VALUE = CSS_SVC_BYTE_ID?eval>
    <#if CSS_SVC_BYTE_VALUE == "DELIMITER">
      <#assign cssdelimiter = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
      <#assign cssheaderbyteList = cssheaderbyteList + [{"index": i,"byteValue": CSS_SVC_BYTE_VALUE}]>
    <#elseif CSS_SVC_BYTE_VALUE == "DELIMITER_MSB">
      <#assign cssdelimiter = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
      <#assign cssheaderbyteList = cssheaderbyteList + [{"index": i,"byteValue": CSS_SVC_BYTE_VALUE}]>
    <#elseif CSS_SVC_BYTE_VALUE == "SEQNUM">
      <#assign cssseqnum = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
      <#assign cssheaderbyteList = cssheaderbyteList + [{"index": i,"byteValue": CSS_SVC_BYTE_VALUE}]>
    <#elseif CSS_SVC_BYTE_VALUE == "SEQNUM_MSB">
      <#assign cssseqnum = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
      <#assign cssheaderbyteList = cssheaderbyteList + [{"index": i,"byteValue": CSS_SVC_BYTE_VALUE}]>
    <#elseif CSS_SVC_BYTE_VALUE == "OPCODE">
      <#assign cssopcode = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
      <#assign cssheaderbyteList = cssheaderbyteList + [{"index": i,"byteValue": CSS_SVC_BYTE_VALUE}]>
    <#elseif CSS_SVC_BYTE_VALUE == "OPCODE_MSB">
      <#assign cssopcode = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
      <#assign cssheaderbyteList = cssheaderbyteList + [{"index": i,"byteValue": CSS_SVC_BYTE_VALUE}]>
    <#elseif CSS_SVC_BYTE_VALUE == "PAYLOAD_LEN">
      <#assign csslen = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
      <#assign cssheaderbyteList = cssheaderbyteList + [{"index": i,"byteValue": CSS_SVC_BYTE_VALUE}]>
    <#elseif CSS_SVC_BYTE_VALUE == "PAYLOAD_LEN_MSB">
      <#assign csslen = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
      <#assign cssheaderbyteList = cssheaderbyteList + [{"index": i,"byteValue": CSS_SVC_BYTE_VALUE}]>
    </#if>
  </#list>
</#if>
<#if (CSS_SVC_FOOTER_LEN_VALUE > 0)>
  <#list 0..(CSS_SVC_FOOTER_LEN_VALUE - 1) as i>
    <#assign CSS_SVC_BYTE_ID = "CSS_INT_SVC_" + CSS_SVC + "_CP_" + CSS_CP + "FOOTER_BYTE_" + i>
    <#assign CSS_SVC_BYTE_VALUE = CSS_SVC_BYTE_ID?eval>
    <#if CSS_SVC_BYTE_VALUE == "CHECKSUM8">
      <#assign csschecksum = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
      <#assign cssfooterbyteList = cssfooterbyteList + [{"index": i, "byteValue": CSS_SVC_BYTE_VALUE}]>
    <#elseif CSS_SVC_BYTE_VALUE == "CHECKSUM16_MSB">
      <#assign csschecksum = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
      <#assign cssfooterbyteList = cssfooterbyteList + [{"index": i, "byteValue": CSS_SVC_BYTE_VALUE}]>
    <#elseif CSS_SVC_BYTE_VALUE == "CHECKSUM32_MSB">
      <#assign csschecksum = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
      <#assign cssfooterbyteList = cssfooterbyteList + [{"index": i, "byteValue": CSS_SVC_BYTE_VALUE}]>
    <#elseif CSS_SVC_BYTE_VALUE == "CRC8">
      <#assign csscrc = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
      <#assign cssfooterbyteList = cssfooterbyteList + [{"index": i, "byteValue": CSS_SVC_BYTE_VALUE}]>
    <#elseif CSS_SVC_BYTE_VALUE == "CRC16_MSB">
      <#assign csscrc = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
      <#assign cssfooterbyteList = cssfooterbyteList + [{"index": i, "byteValue": CSS_SVC_BYTE_VALUE}]>
    <#elseif CSS_SVC_BYTE_VALUE == "CRC32_MSB">
      <#assign csscrc = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
      <#assign cssfooterbyteList = cssfooterbyteList + [{"index": i, "byteValue": CSS_SVC_BYTE_VALUE}]>
    <#elseif CSS_SVC_BYTE_VALUE == "END_DELIMITER">
      <#assign cssenddelimiter = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
      <#assign cssfooterbyteList = cssfooterbyteList + [{"index": i, "byteValue": CSS_SVC_BYTE_VALUE}]>
    <#elseif CSS_SVC_BYTE_VALUE == "END_DELIMITER_MSB">
      <#assign cssenddelimiter = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
      <#assign cssfooterbyteList = cssfooterbyteList + [{"index": i, "byteValue": CSS_SVC_BYTE_VALUE}]>
    </#if>
  </#list>
</#if>
//DOM-IGNORE-BEGIN
/*******************************************************************************
* Copyright (C) 2024 Microchip Technology Inc. and its subsidiaries.
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
*******************************************************************************/
//DOM-IGNORE-END

/*******************************************************************************
  BLE Custom System Service Source File

  Company:
    Microchip Technology Inc.

  File Name:
    ${CSS_SVC_LFNVAR_NAME_VALUE}.c

  Summary:
    This file contains functions for decoding BLE data packets.
	
  Description:
    This file contains functions for decoding BLE data packets.
 *******************************************************************************/


// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************
#include "${CSS_SVC_LFNVAR_NAME_VALUE}.h"

// *****************************************************************************
// *****************************************************************************
// Section: Local Variables
// *****************************************************************************
// *****************************************************************************
static ${CSS_SVC_FNVAR_NAME_VALUE}_Cb_T bleCpsCallback;
<#if cssdelimiter.byteValue != "UNUSED" || csslen.byteValue != "UNUSED" || cssenddelimiter.byteValue != "UNUSED">
  <#if cssseqnum.byteValue == "SEQNUM">
static uint8_t currentSeqNum = 0;
  <#elseif cssseqnum.byteValue == "SEQNUM_MSB">
static uint16_t currentSeqNum = 0;
  </#if>
</#if>

// *****************************************************************************
// *****************************************************************************
// Section: Functions
// *****************************************************************************
// *****************************************************************************
<#if cssdelimiter.byteValue == "DELIMITER">

static uint16_t ${CSS_SVC_LFNVAR_NAME_VALUE}_GetDataLenUsingDelim(uint8_t* p_data,  uint16_t length)
{
  uint16_t dataSize = ${CSS_SVC_FNVAR_NAME_VALUE}_DELIM_LEN;
<#if CSS_SVC_ESCCHAR_ENABLE_VALUE == true>
  uint8_t escape = 0;

  for (uint16_t i = ${CSS_SVC_FNVAR_NAME_VALUE}_DELIM_LEN; i < length; ++i) 
  {
    if (escape) {
        escape = 0;
    } else if (p_data[i] == ${CSS_SVC_FNVAR_NAME_VALUE}_ESCCHAR) { /*Escape character*/
        escape = 1;
    } else if (p_data[i] == ${CSS_SVC_FNVAR_NAME_VALUE}_DELIMITER) { /*Delimiter*/
        break;
    }
    dataSize++;
  }
<#else>

  for (uint16_t i = ${CSS_SVC_FNVAR_NAME_VALUE}_DELIM_LEN; i < length; i++) 
  {
    if (p_data[i] == ${CSS_SVC_FNVAR_NAME_VALUE}_DELIMITER) {
        break;
    }
    dataSize++;
  }
</#if>
  return dataSize;
}
<#elseif cssdelimiter.byteValue == "DELIMITER_MSB">

static uint16_t ${CSS_SVC_LFNVAR_NAME_VALUE}_GetDataLenUsingDelim(uint8_t* p_data,  uint16_t length)
{
  uint16_t dataSize = ${CSS_SVC_FNVAR_NAME_VALUE}_DELIM_LEN;
<#if CSS_SVC_ESCCHAR_ENABLE_VALUE == true>
  uint8_t escape = 0;

  for (uint16_t i = ${CSS_SVC_FNVAR_NAME_VALUE}_DELIM_LEN; i < length; ++i) 
  {
    if (escape) {
        escape = 0;
    } else if (p_data[i] == ${CSS_SVC_FNVAR_NAME_VALUE}_ESCCHAR) { /*Escape character*/
        escape = 1;
    } else if (p_data[i] == ${CSS_SVC_FNVAR_NAME_VALUE}_DELIMITER_MSB && p_data[i+1] == ${CSS_SVC_FNVAR_NAME_VALUE}_DELIMITER_LSB) { // Delimiter
        break;
    }
    dataSize++;
  }
<#else>

  for (uint16_t i = ${CSS_SVC_FNVAR_NAME_VALUE}_DELIM_LEN; i < length; i++) 
  {
    if (p_data[i] == ${CSS_SVC_FNVAR_NAME_VALUE}_DELIMITER_MSB && p_data[i+1] == ${CSS_SVC_FNVAR_NAME_VALUE}_DELIMITER_LSB) {
        break;
    }
    dataSize++;
  }
</#if>

  return dataSize;
}
<#else>
  <#if cssenddelimiter.byteValue == "END_DELIMITER">

static uint16_t ${CSS_SVC_LFNVAR_NAME_VALUE}_GetDataLenUsingEndDelim(uint8_t* p_data,  uint16_t length)
{
  uint16_t dataSize = 0;
    <#if CSS_SVC_ESCCHAR_ENABLE_VALUE == true>
  uint8_t escape = 0;

  for (uint16_t i = 0; i < length; ++i) 
  {
    if (escape) {
        escape = 0;
    } else if (p_data[i] == ${CSS_SVC_FNVAR_NAME_VALUE}_ESCCHAR) { /*Escape character*/
        escape = 1;
    } else if (p_data[i] == ${CSS_SVC_FNVAR_NAME_VALUE}_END_DELIMITER) { /*Delimiter*/
        break;
    }
    dataSize++;
  }
    <#else>

  for (uint16_t i = 0; i < length; i++) 
  {
    if (p_data[i] == ${CSS_SVC_FNVAR_NAME_VALUE}_END_DELIMITER) {
        break;
    }
    dataSize++;
  }
    </#if>
  return dataSize;
}
  <#elseif cssenddelimiter.byteValue == "END_DELIMITER_MSB">

static uint16_t ${CSS_SVC_LFNVAR_NAME_VALUE}_GetDataLenUsingEndDelim(uint8_t* p_data,  uint16_t length)
{
  uint16_t dataSize = 0;
    <#if CSS_SVC_ESCCHAR_ENABLE_VALUE == true>
  uint8_t escape = 0;

  for (uint16_t i = 0; i < length; ++i) 
  {
    if (escape) {
        escape = 0;
    } else if (p_data[i] == ${CSS_SVC_FNVAR_NAME_VALUE}_ESCCHAR) { /*Escape character*/
        escape = 1;
    } else if (p_data[i] == ${CSS_SVC_FNVAR_NAME_VALUE}_END_DELIMITER_MSB && p_data[i+1] == ${CSS_SVC_FNVAR_NAME_VALUE}_END_DELIMITER_LSB) { // Delimiter
        break;
    }
    dataSize++;
  }
    <#else>

  for (uint16_t i = 0; i < length; i++) 
  {
    if (p_data[i] == ${CSS_SVC_FNVAR_NAME_VALUE}_END_DELIMITER_MSB && p_data[i+1] == ${CSS_SVC_FNVAR_NAME_VALUE}_END_DELIMITER_LSB) {
        break;
    }
    dataSize++;
  }
    </#if>

  return dataSize;
}
  </#if>
</#if>
<#if cssdelimiter.byteValue != "UNUSED" || csslen.byteValue != "UNUSED" || cssenddelimiter.byteValue != "UNUSED">
  <#if csschecksum.byteValue == "CHECKSUM8">

static uint8_t ${CSS_SVC_LFNVAR_NAME_VALUE}_Checksum8(uint8_t* p_data, uint16_t length) 
{
  uint8_t checksum = 0;
  if(bleCpsCallback.bleCpsErrorCheckCb == NULL)
  {
    for (uint16_t i = 0; i < length; ++i) {
        checksum += p_data[i];
    }
  }
  else
  {
    checksum = bleCpsCallback.bleCpsErrorCheckCb(p_data,length);
  }
  return checksum;
}
  <#elseif csschecksum.byteValue == "CHECKSUM16_MSB">

static uint16_t ${CSS_SVC_LFNVAR_NAME_VALUE}_Checksum16(uint8_t* p_data, uint16_t length) 
{
  uint16_t checksum = 0;
  if(bleCpsCallback.bleCpsErrorCheckCb == NULL)
  {
    for (uint16_t i = 0; i < length; ++i) {
        checksum += p_data[i];
    }
  }
  else
  {
    checksum = bleCpsCallback.bleCpsErrorCheckCb(p_data,length);
  }

  return checksum;
}
  <#elseif csschecksum.byteValue == "CHECKSUM32_MSB">

uint32_t ${CSS_SVC_LFNVAR_NAME_VALUE}_Checksum32(uint8_t* p_data, uint16_t length) 
{
  uint32_t checksum = 0;
  if(bleCpsCallback.bleCpsErrorCheckCb == NULL)
  {
    for (uint16_t i = 0; i < length; ++i) {
        checksum += p_data[i];
    }
  }
  else
  {
    checksum = bleCpsCallback.bleCpsErrorCheckCb(p_data,length);
  }
  return checksum;
}
  </#if>
  <#if csscrc.byteValue == "CRC8">

static uint8_t ${CSS_SVC_LFNVAR_NAME_VALUE}_Crc8(uint8_t* p_data, uint16_t length) 
{
  uint8_t crc = ${CSS_SVC_FNVAR_NAME_VALUE}_CRC_INIT_VAL; // Initial value
  if(bleCpsCallback.bleCpsErrorCheckCb == NULL)
  {
    uint8_t polynomial = ${CSS_SVC_FNVAR_NAME_VALUE}_CRC_POLY; // CRC-8 polynomial

    for (uint16_t i = 0; i < length; i++) {
        crc ^= p_data[i]; // XOR byte into least significant byte of crc

        for (uint8_t j = 0; j < 8; j++) {
            if (crc & 0x80) {
                crc = (crc << 1) ^ polynomial;
            } 
            else {
                crc <<= 1;
            }
        }
    }
  }
  else
  {
    crc = bleCpsCallback.bleCpsErrorCheckCb(p_data,length);
  }

  return crc;
}
  <#elseif csscrc.byteValue == "CRC16_MSB">

static uint16_t ${CSS_SVC_LFNVAR_NAME_VALUE}_Crc16(uint8_t* p_data, uint16_t length) 
{
  uint16_t crc = ${CSS_SVC_FNVAR_NAME_VALUE}_CRC_INIT_VAL; // Initial value
  if(bleCpsCallback.bleCpsErrorCheckCb == NULL)
  {
    uint16_t polynomial = ${CSS_SVC_FNVAR_NAME_VALUE}_CRC_POLY;

    for (uint16_t i = 0; i < length; i++) {
        crc ^= (uint16_t)p_data[i] << 8; // XOR byte into the top byte of crc

        for (uint8_t j = 0; j < 8; j++) {
            if (crc & 0x8000) {
                crc = (crc << 1) ^ polynomial;
            } else {
                crc <<= 1;
            }
        }
    }
  }
  else
  {
    crc = bleCpsCallback.bleCpsErrorCheckCb(p_data,length);
  }

  return crc;
}
  <#elseif csscrc.byteValue == "CRC32_MSB">

static uint32_t ${CSS_SVC_LFNVAR_NAME_VALUE}_Crc32(uint8_t* p_data, uint16_t length) 
{
  uint32_t crc = ${CSS_SVC_FNVAR_NAME_VALUE}_CRC_INIT_VAL; // Initial value
  if(bleCpsCallback.bleCpsErrorCheckCb == NULL)
  {
    uint32_t polynomial = ${CSS_SVC_FNVAR_NAME_VALUE}_CRC_POLY; // Polynomial used in CRC-32

    for (uint16_t i = 0; i < length; i++) {
        crc ^= p_data[i];
        for (uint8_t j = 0; j < 8; j++) {
            if (crc & 1) {
                crc = (crc >> 1) ^ polynomial;
            } else {
                crc >>= 1;
            }
        }
    }
    crc = ~crc;
  }
  else
  {
    crc = bleCpsCallback.bleCpsErrorCheckCb(p_data,length);
  }

  return crc;
}
  </#if>
  <#if cssseqnum.byteValue == "SEQNUM">

static uint32_t ${CSS_SVC_LFNVAR_NAME_VALUE}_SequenceCheck(uint8_t receivedSeqNum) 
{
  uint32_t result = ${CSS_SVC_FNVAR_NAME_VALUE}_SEQ_CHECK_SUCCESS;
  if(bleCpsCallback.bleCpsSeqCheckCb == NULL)
  {
    /*Check if received sequence number is within expected range*/
    if (receivedSeqNum == currentSeqNum) 
    {
      /*Valid sequence number*/
      currentSeqNum = (currentSeqNum + 1) % (${CSS_SVC_FNVAR_NAME_VALUE}_SEQ_MAX + 1);  /*Update currentSeqNum to the next expected value*/
      result = ${CSS_SVC_FNVAR_NAME_VALUE}_SEQ_CHECK_SUCCESS;
    }
    else
    {
      /*Invalid sequence number*/
      result = ${CSS_SVC_FNVAR_NAME_VALUE}_SEQ_CHECK_FAIL;
    }
  }
  else
  {
    result = bleCpsCallback.bleCpsSeqCheckCb(receivedSeqNum);
  }
  return result;
}
  <#elseif cssseqnum.byteValue == "SEQNUM_MSB">

static uint32_t ${CSS_SVC_LFNVAR_NAME_VALUE}_SequenceCheck(uint16_t receivedSeqNum) 
{
  uint32_t result = ${CSS_SVC_FNVAR_NAME_VALUE}_SEQ_CHECK_SUCCESS;
  if(bleCpsCallback.bleCpsSeqCheckCb == NULL)
  {
    /*Check if received sequence number is within expected range*/
    if (receivedSeqNum == currentSeqNum) 
    {
      /*Valid sequence number*/
      currentSeqNum = (currentSeqNum + 1) % (${CSS_SVC_FNVAR_NAME_VALUE}_SEQ_MAX + 1);  /*Update currentSeqNum to the next expected value*/
      result = ${CSS_SVC_FNVAR_NAME_VALUE}_SEQ_CHECK_SUCCESS;
    }
    else
    {
      /*Invalid sequence number*/
      result = ${CSS_SVC_FNVAR_NAME_VALUE}_SEQ_CHECK_FAIL;
    }
  }
  else
  {
    result = bleCpsCallback.bleCpsSeqCheckCb(receivedSeqNum);
  }
  return result;
}
  </#if>
  <#if cssopcode.byteValue != "UNUSED">
static void ${CSS_SVC_LFNVAR_NAME_VALUE}_ActonHandler(${CSS_SVC_FNVAR_NAME_VALUE}_Packet_T packetData)
{
  bool cmdFound = false;
  uint16_t idx = 0;
  for(idx =0; idx<${CSS_SVC_FNVAR_NAME_VALUE}_COMMAND_COUNT; idx++)
  {
      if(bleCpsCallback.bleCpsActionCbTable[idx].CmdId == (uint16_t)packetData.opcode)
      {
          cmdFound = true;
          break;
      }
  }
  
  if(cmdFound)
  {
    <#if cssseqnum.byteValue != "UNUSED">
    if(${CSS_SVC_LFNVAR_NAME_VALUE}_SequenceCheck(packetData.seqNum))
    {
      if (bleCpsCallback.bleCpsErrorCb != NULL)
      {
        bleCpsCallback.bleCpsErrorCb(${CSS_SVC_FNVAR_NAME_VALUE}_ERROR_SEQUENCE);
      }
    }
    else
    {
      if(bleCpsCallback.bleCpsActionCbTable[idx].fnPtr != NULL)
      {
          bleCpsCallback.bleCpsActionCbTable[idx].fnPtr(packetData.payload, (uint16_t)packetData.payloadLen);
      }
    }
    <#else>
      if(bleCpsCallback.bleCpsActionCbTable[idx].fnPtr != NULL)
      {
          bleCpsCallback.bleCpsActionCbTable[idx].fnPtr(packetData.payload, (uint16_t)packetData.payloadLen);
      }
    </#if>
  }
  else
  {
      if (bleCpsCallback.bleCpsErrorCb != NULL)
      {
        bleCpsCallback.bleCpsErrorCb(${CSS_SVC_FNVAR_NAME_VALUE}_NOT_VALID_OPCODE);
      }
  }
}
  <#else>
static void ${CSS_SVC_LFNVAR_NAME_VALUE}_ActonHandler(${CSS_SVC_FNVAR_NAME_VALUE}_Packet_T packetData)
{
    <#if cssseqnum.byteValue != "UNUSED">
  if(${CSS_SVC_LFNVAR_NAME_VALUE}_SequenceCheck(packetData.seqNum))
  {
    if (bleCpsCallback.bleCpsErrorCb != NULL)
    {
      bleCpsCallback.bleCpsErrorCb(${CSS_SVC_FNVAR_NAME_VALUE}_ERROR_SEQUENCE);
    }
  }
    </#if>
  if (bleCpsCallback.bleCpsActionCb != NULL)
  {
    bleCpsCallback.bleCpsActionCb(packetData.payload, (uint16_t)packetData.payloadLen);
  }
}
  </#if>
</#if>
<#if (cssdelimiter.byteValue != "UNUSED" || csslen.byteValue != "UNUSED") && CSS_SVC_ESCCHAR_ENABLE_VALUE == true>

  <#if csslen.byteValue == "PAYLOAD_LEN">
static void ${CSS_SVC_LFNVAR_NAME_VALUE}_RemoveEscChar(uint8_t* payload, uint8_t payloadLen, uint8_t *actPayload, uint8_t* actPayloadLen)
  <#else>
static void ${CSS_SVC_LFNVAR_NAME_VALUE}_RemoveEscChar(uint8_t* payload, uint16_t payloadLen, uint8_t *actPayload, uint16_t* actPayloadLen)
  </#if>
{
    uint16_t j = 0;
    for (uint16_t i = 0; i < payloadLen; i++) 
    {
        if ((payload[i] == ${CSS_SVC_FNVAR_NAME_VALUE}_ESCCHAR) && ((i + 1) < payloadLen)) 
        {
            i++;
        }
        if(payload[i] != ${CSS_SVC_FNVAR_NAME_VALUE}_ESCCHAR)
        {
            actPayload[j++] = payload[i];
        }
    }
    *actPayloadLen = j;
}
</#if>

void ${CSS_SVC_FNVAR_NAME_VALUE}_DeviceDisconnected(void)
{
<#if cssdelimiter.byteValue != "UNUSED" || csslen.byteValue != "UNUSED" || cssenddelimiter.byteValue != "UNUSED">
  <#if cssseqnum.byteValue != "UNUSED">
  currentSeqNum = 0;
  </#if>
</#if>
  if (bleCpsCallback.bleCpsDisconnectedCb != NULL)
  {
    bleCpsCallback.bleCpsDisconnectedCb();
  }
}

void ${CSS_SVC_FNVAR_NAME_VALUE}_CmdDecode(uint16_t packetLen,uint8_t* p_packet)
{
<#if cssdelimiter.byteValue != "UNUSED" || csslen.byteValue != "UNUSED" || cssenddelimiter.byteValue != "UNUSED">
  ${CSS_SVC_FNVAR_NAME_VALUE}_Packet_T packetFrame;
  <#if CSS_SVC_ESCCHAR_ENABLE_VALUE == true>
  ${CSS_SVC_FNVAR_NAME_VALUE}_ActData_T actData;
  </#if>
  uint16_t offset = 0U;
  if(packetLen < ${CSS_SVC_FNVAR_NAME_VALUE}_MIN_PACKET_LEN)
  {
    if (bleCpsCallback.bleCpsErrorCb != NULL)
    {
      bleCpsCallback.bleCpsErrorCb(${CSS_SVC_FNVAR_NAME_VALUE}_INVALID_PACKET);
    }
  }

  while ((offset < packetLen) && ((packetLen - offset) >= ${CSS_SVC_FNVAR_NAME_VALUE}_MIN_PACKET_LEN)) 
  {
    uint16_t packetStartOffset = offset;
  <#if (CSS_SVC_HEADER_LEN_VALUE > 0)>
    <#if cssdelimiter.byteValue == "DELIMITER">
    uint16_t packetLenDelim = 0U;
    if(p_packet[offset] != ${CSS_SVC_FNVAR_NAME_VALUE}_DELIMITER)
    {
      if (bleCpsCallback.bleCpsErrorCb != NULL)
      {
        bleCpsCallback.bleCpsErrorCb(${CSS_SVC_FNVAR_NAME_VALUE}_ERROR_DELIMITER);
      }
      return;
    }
    packetLenDelim = ${CSS_SVC_LFNVAR_NAME_VALUE}_GetDataLenUsingDelim(&p_packet[offset], packetLen - offset);
    
      <#if cssenddelimiter.byteValue == "END_DELIMITER">
    if (p_packet[offset + (packetLenDelim-1U)] != ${CSS_SVC_FNVAR_NAME_VALUE}_END_DELIMITER)
    {
      if (bleCpsCallback.bleCpsErrorCb != NULL)
      {
        bleCpsCallback.bleCpsErrorCb(${CSS_SVC_FNVAR_NAME_VALUE}_ERROR_END_DELIMITER);
      }
      return;
    } 
      <#elseif cssenddelimiter.byteValue == "END_DELIMITER_MSB">
    if ((p_packet[offset + (packetLenDelim-2U)] != ${CSS_SVC_FNVAR_NAME_VALUE}_END_DELIMITER_MSB) || \
        (p_packet[offset + (packetLenDelim-1U)] != ${CSS_SVC_FNVAR_NAME_VALUE}_END_DELIMITER_LSB))
    {
      if (bleCpsCallback.bleCpsErrorCb != NULL)
      {
        bleCpsCallback.bleCpsErrorCb(${CSS_SVC_FNVAR_NAME_VALUE}_ERROR_END_DELIMITER);
      }
      return;
    }
      </#if>
    offset += ${CSS_SVC_FNVAR_NAME_VALUE}_DELIM_LEN;
    <#elseif cssdelimiter.byteValue == "DELIMITER_MSB">
    uint16_t packetLenDelim = 0;
    if((p_packet[offset] != ${CSS_SVC_FNVAR_NAME_VALUE}_DELIMITER_MSB) || \
        (p_packet[offset + 1U] != ${CSS_SVC_FNVAR_NAME_VALUE}_DELIMITER_LSB))
    {
      if (bleCpsCallback.bleCpsErrorCb != NULL)
      {
        bleCpsCallback.bleCpsErrorCb(${CSS_SVC_FNVAR_NAME_VALUE}_ERROR_DELIMITER);
      }
      return;
    }
    packetLenDelim = ${CSS_SVC_LFNVAR_NAME_VALUE}_GetDataLenUsingDelim(&p_packet[offset], packetLen - offset);
    
      <#if cssenddelimiter.byteValue == "END_DELIMITER">
    if (p_packet[offset + (packetLenDelim-1U)] != ${CSS_SVC_FNVAR_NAME_VALUE}_END_DELIMITER)
    {
        if (bleCpsCallback.bleCpsErrorCb != NULL)
        {
          bleCpsCallback.bleCpsErrorCb(${CSS_SVC_FNVAR_NAME_VALUE}_ERROR_END_DELIMITER);
        }
        return;
    }
      <#elseif cssenddelimiter.byteValue == "END_DELIMITER_MSB">
    if ((p_packet[offset + (packetLenDelim-2)] != ${CSS_SVC_FNVAR_NAME_VALUE}_END_DELIMITER_MSB) || \
        (p_packet[offset + (packetLenDelim-1)] != ${CSS_SVC_FNVAR_NAME_VALUE}_END_DELIMITER_LSB))
    {
      if (bleCpsCallback.bleCpsErrorCb != NULL)
      {
        bleCpsCallback.bleCpsErrorCb(${CSS_SVC_FNVAR_NAME_VALUE}_ERROR_END_DELIMITER);
      }
      return;
    }
      </#if>
    offset += ${CSS_SVC_FNVAR_NAME_VALUE}_DELIM_LEN;
    <#else>
      <#if cssenddelimiter.byteValue == "END_DELIMITER" || cssenddelimiter.byteValue == "END_DELIMITER_MSB">
    uint16_t packetLenDelim = ${CSS_SVC_LFNVAR_NAME_VALUE}_GetDataLenUsingEndDelim(&p_packet[offset], packetLen - offset);
    packetLenDelim += ${CSS_SVC_FNVAR_NAME_VALUE}_ENDDELIM_LEN;
      </#if>
    </#if>

    <#list cssheaderbyteList as byte>
      <#if byte.byteValue == "SEQNUM">
    packetFrame.seqNum = p_packet[offset];
    offset += ${CSS_SVC_FNVAR_NAME_VALUE}_SEQNUM_LEN;
      <#elseif byte.byteValue == "SEQNUM_MSB">
    packetFrame.seqNum = ((uint16_t)p_packet[offset]<<8) | ((uint16_t)p_packet[offset+1]);
    offset += ${CSS_SVC_FNVAR_NAME_VALUE}_SEQNUM_LEN;

      <#elseif byte.byteValue == "OPCODE">
    packetFrame.opcode = p_packet[offset];
    offset += ${CSS_SVC_FNVAR_NAME_VALUE}_OPCODE_LEN;
      <#elseif byte.byteValue == "OPCODE_MSB">
    packetFrame.opcode = ((uint16_t)p_packet[offset]<<8) | ((uint16_t)p_packet[offset+1]);
    offset += ${CSS_SVC_FNVAR_NAME_VALUE}_OPCODE_LEN;

      <#elseif byte.byteValue == "PAYLOAD_LEN">
    packetFrame.payloadLen = p_packet[offset];
        <#if cssdelimiter.byteValue != "UNUSED" || cssenddelimiter.byteValue != "UNUSED">
          <#if CSS_SVC_ESCCHAR_ENABLE_VALUE == true>
    if((packetFrame.payloadLen + ${CSS_SVC_FNVAR_NAME_VALUE}_MIN_PACKET_LEN) > (uint8_t)packetLenDelim)
          <#else>
    if((packetFrame.payloadLen + ${CSS_SVC_FNVAR_NAME_VALUE}_MIN_PACKET_LEN) != (uint8_t)packetLenDelim)
          </#if>
    {
      if (bleCpsCallback.bleCpsErrorCb != NULL)
      {
        bleCpsCallback.bleCpsErrorCb(${CSS_SVC_FNVAR_NAME_VALUE}_ERROR_LENGTH);
      }
      return;    
    }
    
        </#if>
    offset += ${CSS_SVC_FNVAR_NAME_VALUE}_PAYLOADLEN_LEN;
      <#elseif byte.byteValue == "PAYLOAD_LEN_MSB">
    packetFrame.payloadLen = ((uint16_t)p_packet[offset]<<8) | ((uint16_t)p_packet[offset+1]);
        <#if cssdelimiter.byteValue != "UNUSED" || cssenddelimiter.byteValue != "UNUSED">
          <#if CSS_SVC_ESCCHAR_ENABLE_VALUE == true>
    if((packetFrame.payloadLen + ${CSS_SVC_FNVAR_NAME_VALUE}_MIN_PACKET_LEN) > packetLenDelim)
          <#else>
    if((packetFrame.payloadLen + ${CSS_SVC_FNVAR_NAME_VALUE}_MIN_PACKET_LEN) != packetLenDelim)
          </#if>
    {
      if (bleCpsCallback.bleCpsErrorCb != NULL)
      {
        bleCpsCallback.bleCpsErrorCb(${CSS_SVC_FNVAR_NAME_VALUE}_ERROR_LENGTH);
      }
      return;    
    }
        </#if>
    offset += ${CSS_SVC_FNVAR_NAME_VALUE}_PAYLOADLEN_LEN;
      <#else>
      </#if>
    </#list>
  </#if>
  <#if (cssdelimiter.byteValue != "UNUSED" || cssenddelimiter.byteValue != "UNUSED")>
    <#if csslen.byteValue == "PAYLOAD_LEN">
    packetFrame.payloadLen = (uint8_t)(packetLenDelim - ${CSS_SVC_FNVAR_NAME_VALUE}_MIN_PACKET_LEN);
    <#else>
    packetFrame.payloadLen = packetLenDelim - ${CSS_SVC_FNVAR_NAME_VALUE}_MIN_PACKET_LEN;
    </#if>
  </#if>
    offset +=packetFrame.payloadLen;
  <#if (CSS_SVC_FOOTER_LEN_VALUE > 0)>
    <#list cssfooterbyteList as byte>
      <#if byte.byteValue == "CHECKSUM8">
    packetFrame.checksum8 = p_packet[offset];
    if(packetFrame.checksum8 != ${CSS_SVC_LFNVAR_NAME_VALUE}_Checksum8(&p_packet[packetStartOffset + ${CSS_SVC_FNVAR_NAME_VALUE}_CHECKSUM_BYTE_START],offset - (packetStartOffset + ${CSS_SVC_FNVAR_NAME_VALUE}_CHECKSUM_BYTE_START)))
    {
      if (bleCpsCallback.bleCpsErrorCb != NULL)
      {
        bleCpsCallback.bleCpsErrorCb(${CSS_SVC_FNVAR_NAME_VALUE}_ERROR_CHECKSUM);
      }
      return; 
    }
    offset += ${CSS_SVC_FNVAR_NAME_VALUE}_CHECKSUM_LEN;
      <#elseif byte.byteValue == "CHECKSUM16_MSB">
    packetFrame.checksum16 = ((uint16_t)p_packet[offset]<<8) | ((uint16_t)p_packet[offset+1]);
    if(packetFrame.checksum16 != ${CSS_SVC_LFNVAR_NAME_VALUE}_Checksum16(&p_packet[packetStartOffset + ${CSS_SVC_FNVAR_NAME_VALUE}_CHECKSUM_BYTE_START],offset - (packetStartOffset + ${CSS_SVC_FNVAR_NAME_VALUE}_CHECKSUM_BYTE_START)))
    {
      if (bleCpsCallback.bleCpsErrorCb != NULL)
      {
        bleCpsCallback.bleCpsErrorCb(${CSS_SVC_FNVAR_NAME_VALUE}_ERROR_CHECKSUM);
      }
      return; 
    }
    offset += ${CSS_SVC_FNVAR_NAME_VALUE}_CHECKSUM_LEN;
      <#elseif byte.byteValue == "CHECKSUM32_MSB">
    packetFrame.checksum32 = ((uint32_t)p_packet[offset]<<24) | ((uint32_t)p_packet[offset+1]<<16) | \
                              ((uint32_t)p_packet[offset+2]<<8) | ((uint32_t)p_packet[offset+3]);
    if(packetFrame.checksum32 != ${CSS_SVC_LFNVAR_NAME_VALUE}_Checksum32(&p_packet[packetStartOffset + ${CSS_SVC_FNVAR_NAME_VALUE}_CHECKSUM_BYTE_START],offset - (packetStartOffset + ${CSS_SVC_FNVAR_NAME_VALUE}_CHECKSUM_BYTE_START)))
    {
      if (bleCpsCallback.bleCpsErrorCb != NULL)
      {
        bleCpsCallback.bleCpsErrorCb(${CSS_SVC_FNVAR_NAME_VALUE}_ERROR_CHECKSUM);
      }
      return; 
    }
    offset += ${CSS_SVC_FNVAR_NAME_VALUE}_CHECKSUM_LEN;
      <#elseif byte.byteValue == "CRC8">
    packetFrame.crc8 = p_packet[offset];
    if(packetFrame.crc8 != ${CSS_SVC_LFNVAR_NAME_VALUE}_Crc8(&p_packet[packetStartOffset + ${CSS_SVC_FNVAR_NAME_VALUE}_CRC_BYTE_START],offset - (packetStartOffset + ${CSS_SVC_FNVAR_NAME_VALUE}_CRC_BYTE_START)))
    {
      if (bleCpsCallback.bleCpsErrorCb != NULL)
      {
        bleCpsCallback.bleCpsErrorCb(${CSS_SVC_FNVAR_NAME_VALUE}_ERROR_CRC);
      }
      return; 
    }
    offset += ${CSS_SVC_FNVAR_NAME_VALUE}_CRC_LEN;
      <#elseif byte.byteValue == "CRC16_MSB">
    packetFrame.crc16 = ((uint16_t)p_packet[offset]<<8) | ((uint16_t)p_packet[offset+1]);
    if(packetFrame.crc16 != ${CSS_SVC_LFNVAR_NAME_VALUE}_Crc16(&p_packet[packetStartOffset + ${CSS_SVC_FNVAR_NAME_VALUE}_CRC_BYTE_START],offset - (packetStartOffset + ${CSS_SVC_FNVAR_NAME_VALUE}_CRC_BYTE_START)))
    {
      if (bleCpsCallback.bleCpsErrorCb != NULL)
      {
        bleCpsCallback.bleCpsErrorCb(${CSS_SVC_FNVAR_NAME_VALUE}_ERROR_CRC);
      }
      return; 
    }
    offset += ${CSS_SVC_FNVAR_NAME_VALUE}_CRC_LEN;
      <#elseif byte.byteValue == "CRC32_MSB">
    packetFrame.crc32 = ((uint32_t)p_packet[offset]<<24) | ((uint32_t)p_packet[offset+1]<<16) | \
                              ((uint32_t)p_packet[offset+2]<<8) | ((uint32_t)p_packet[offset+3]);
    if(packetFrame.crc32 != ${CSS_SVC_LFNVAR_NAME_VALUE}_Crc32(&p_packet[packetStartOffset + ${CSS_SVC_FNVAR_NAME_VALUE}_CRC_BYTE_START],offset - (packetStartOffset + ${CSS_SVC_FNVAR_NAME_VALUE}_CRC_BYTE_START)))
    {
      if (bleCpsCallback.bleCpsErrorCb != NULL)
      {
        bleCpsCallback.bleCpsErrorCb(${CSS_SVC_FNVAR_NAME_VALUE}_ERROR_CRC);
      }
      return; 
    }
    offset += ${CSS_SVC_FNVAR_NAME_VALUE}_CRC_LEN;
      <#elseif byte.byteValue == "END_DELIMITER">
    offset += ${CSS_SVC_FNVAR_NAME_VALUE}_ENDDELIM_LEN;
      <#elseif byte.byteValue == "END_DELIMITER_MSB">
    offset += ${CSS_SVC_FNVAR_NAME_VALUE}_ENDDELIM_LEN;
      </#if>
    </#list>
  </#if>
  
  <#if CSS_SVC_ESCCHAR_ENABLE_VALUE == true>
      ${CSS_SVC_LFNVAR_NAME_VALUE}_RemoveEscChar(&p_packet[packetStartOffset+${CSS_SVC_FNVAR_NAME_VALUE}_HEADER_LEN],packetFrame.payloadLen, actData.payload, &actData.payloadLen);
      packetFrame.payloadLen = actData.payloadLen;
      packetFrame.payload = actData.payload;
  <#else>
      packetFrame.payload = &p_packet[packetStartOffset+${CSS_SVC_FNVAR_NAME_VALUE}_HEADER_LEN];
  </#if>
      ${CSS_SVC_LFNVAR_NAME_VALUE}_ActonHandler(packetFrame);
  }
<#else>
  if (bleCpsCallback.bleCpsActionCb != NULL)
  {
    bleCpsCallback.bleCpsActionCb(p_packet, packetLen);
  }
</#if>
}

void ${CSS_SVC_FNVAR_NAME_VALUE}_CallbackRegister(${CSS_SVC_FNVAR_NAME_VALUE}_Cb_T callback)
{
  (void)memcpy(&bleCpsCallback,&callback,sizeof(${CSS_SVC_FNVAR_NAME_VALUE}_Cb_T));
}