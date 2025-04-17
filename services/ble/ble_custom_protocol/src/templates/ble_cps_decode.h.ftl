<#assign CSS_SVC_COMMAND_COUNT_ID = "CSS_INT_SVC_" + CSS_SVC + "_CP_" + CSS_CP + "_COMMAND_COUNT">
<#assign CSS_SVC_COMMAND_COUNT_VALUE = CSS_SVC_COMMAND_COUNT_ID?eval>
<#assign CSS_SVC_NAME_ID = "CSS_STR_SVC_NAME_" + CSS_SVC>
<#assign CSS_SVC_NAME_VALUE = CSS_SVC_NAME_ID?eval>
<#assign CSS_SVC_HEADER_LEN_ID = "CSS_INT_SVC_" + CSS_SVC + "_CP_" + CSS_CP + "_HEADER_LEN">
<#assign CSS_SVC_HEADER_LEN_VALUE = CSS_SVC_HEADER_LEN_ID?eval>
<#assign CSS_SVC_FOOTER_LEN_ID = "CSS_INT_SVC_" + CSS_SVC + "_CP_" + CSS_CP + "_FOOTER_LEN">
<#assign CSS_SVC_FOOTER_LEN_VALUE = CSS_SVC_FOOTER_LEN_ID?eval>
<#assign CSS_SVC_ESCCHAR_ENABLE_ID = "CSS_BOOL_SVC_" + CSS_SVC + "_CP_" + CSS_CP + "_ESCCHAR_ENABLE">
<#assign CSS_SVC_ESCCHAR_ENABLE_VALUE = CSS_SVC_ESCCHAR_ENABLE_ID?eval>
<#assign CSS_SVC_ESCCHAR_ID = "CSS_HEX_SVC_" + CSS_SVC + "_CP_" + CSS_CP + "_ESCCHAR">
<#assign CSS_SVC_ESCCHAR_VALUE = CSS_SVC_ESCCHAR_ID?eval>
<#assign CSS_SVC_FNVAR_NAME_VALUE = "BLE_CPS_" + CSS_SVC_NAME_VALUE?upper_case + CSS_CP + "_DECODE">
<#assign CSS_SVC_LFNVAR_NAME_VALUE = "ble_cps_" + CSS_SVC_NAME_VALUE?lower_case + CSS_CP + "_decode">
<#assign cssdelimiter = {"index": 0,"byteValue": "UNUSED"}>
<#assign cssseqnum = {"index": 0,"byteValue": "UNUSED"}>
<#assign cssopcode = {"index": 0,"byteValue": "UNUSED"}>
<#assign csslen = {"index": 0,"byteValue": "UNUSED"}>
<#assign csschecksum = {"index": 0,"byteValue": "UNUSED"}>
<#assign csscrc = {"index": 0,"byteValue": "UNUSED"}>
<#assign cssenddelimiter = {"index": 0,"byteValue": "UNUSED"}>
<#assign minPacketLen = CSS_SVC_HEADER_LEN_VALUE + CSS_SVC_FOOTER_LEN_VALUE>
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

/*******************************************************************************
  BLE Custom System Service Header File

  Company:
    Microchip Technology Inc.

  File Name:
    ${CSS_SVC_LFNVAR_NAME_VALUE}.h

  Summary:
    This file contains functions for decoding BLE data packets.
	
  Description:
    This file contains functions for decoding BLE data packets.
 *******************************************************************************/
#ifndef ${CSS_SVC_FNVAR_NAME_VALUE}_H
#define ${CSS_SVC_FNVAR_NAME_VALUE}_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

extern "C" {

#endif
// DOM-IGNORE-END

// *****************************************************************************
// *****************************************************************************
// Section: Macros
// *****************************************************************************
// *****************************************************************************
<#if (CSS_SVC_HEADER_LEN_VALUE > 0)>
  <#list 0..(CSS_SVC_HEADER_LEN_VALUE - 1) as i>
    <#assign CSS_SVC_BYTE_ID = "CSS_INT_SVC_" + CSS_SVC + "_CP_" + CSS_CP + "HEADER_BYTE_" + i>
    <#assign CSS_SVC_BYTE_VALUE = CSS_SVC_BYTE_ID?eval>
    <#if CSS_SVC_BYTE_VALUE == "DELIMITER">
      <#assign cssdelimiter = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
#define ${CSS_SVC_FNVAR_NAME_VALUE}_DELIM_LEN          1U
    <#elseif CSS_SVC_BYTE_VALUE == "DELIMITER_MSB">
      <#assign cssdelimiter = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
#define ${CSS_SVC_FNVAR_NAME_VALUE}_DELIM_LEN          2U
    <#elseif CSS_SVC_BYTE_VALUE == "SEQNUM">
      <#assign cssseqnum = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
#define ${CSS_SVC_FNVAR_NAME_VALUE}_SEQNUM_LEN         1U
    <#elseif CSS_SVC_BYTE_VALUE == "SEQNUM_MSB">
      <#assign cssseqnum = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
#define ${CSS_SVC_FNVAR_NAME_VALUE}_SEQNUM_LEN         2U
    <#elseif CSS_SVC_BYTE_VALUE == "OPCODE">
      <#assign cssopcode = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
#define ${CSS_SVC_FNVAR_NAME_VALUE}_OPCODE_LEN         1U
    <#elseif CSS_SVC_BYTE_VALUE == "OPCODE_MSB">
      <#assign cssopcode = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
#define ${CSS_SVC_FNVAR_NAME_VALUE}_OPCODE_LEN         2U
    <#elseif CSS_SVC_BYTE_VALUE == "PAYLOAD_LEN">
      <#assign csslen = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
#define ${CSS_SVC_FNVAR_NAME_VALUE}_PAYLOADLEN_LEN     1U
    <#elseif CSS_SVC_BYTE_VALUE == "PAYLOAD_LEN_MSB">
      <#assign csslen = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
#define ${CSS_SVC_FNVAR_NAME_VALUE}_PAYLOADLEN_LEN     2U
    <#else>
    </#if>
  </#list>
</#if>
<#if (CSS_SVC_FOOTER_LEN_VALUE > 0)>
  <#list 0..(CSS_SVC_FOOTER_LEN_VALUE - 1) as i>
    <#assign CSS_SVC_BYTE_ID = "CSS_INT_SVC_" + CSS_SVC + "_CP_" + CSS_CP + "FOOTER_BYTE_" + i>
    <#assign CSS_SVC_BYTE_VALUE = CSS_SVC_BYTE_ID?eval>
    <#if CSS_SVC_BYTE_VALUE == "CHECKSUM8">
      <#assign csschecksum = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
#define ${CSS_SVC_FNVAR_NAME_VALUE}_CHECKSUM_LEN       1U
    <#elseif CSS_SVC_BYTE_VALUE == "CHECKSUM16_MSB">
      <#assign csschecksum = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
#define ${CSS_SVC_FNVAR_NAME_VALUE}_CHECKSUM_LEN       2U
    <#elseif CSS_SVC_BYTE_VALUE == "CHECKSUM32_MSB">
      <#assign csschecksum = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
#define ${CSS_SVC_FNVAR_NAME_VALUE}_CHECKSUM_LEN       4U
    <#elseif CSS_SVC_BYTE_VALUE == "CRC8">
      <#assign csscrc = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
#define ${CSS_SVC_FNVAR_NAME_VALUE}_CRC_LEN            1U
    <#elseif CSS_SVC_BYTE_VALUE == "CRC16_MSB">
      <#assign csscrc = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
#define ${CSS_SVC_FNVAR_NAME_VALUE}_CRC_LEN            2U
    <#elseif CSS_SVC_BYTE_VALUE == "CRC32_MSB">
      <#assign csscrc = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
#define ${CSS_SVC_FNVAR_NAME_VALUE}_CRC_LEN            4U
    <#elseif CSS_SVC_BYTE_VALUE == "END_DELIMITER">
      <#assign cssenddelimiter = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
#define ${CSS_SVC_FNVAR_NAME_VALUE}_ENDDELIM_LEN       1U
    <#elseif CSS_SVC_BYTE_VALUE == "END_DELIMITER_MSB">
      <#assign cssenddelimiter = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
#define ${CSS_SVC_FNVAR_NAME_VALUE}_ENDDELIM_LEN       2U
    <#else>
    </#if>
  </#list>
</#if>

<#if (CSS_SVC_HEADER_LEN_VALUE > 0) || (CSS_SVC_FOOTER_LEN_VALUE > 0)>
#define ${CSS_SVC_FNVAR_NAME_VALUE}_HEADER_LEN         ${CSS_SVC_HEADER_LEN_VALUE}U
#define ${CSS_SVC_FNVAR_NAME_VALUE}_FOOTER_LEN         ${CSS_SVC_FOOTER_LEN_VALUE}U
#define ${CSS_SVC_FNVAR_NAME_VALUE}_MIN_PACKET_LEN     ${minPacketLen}U
</#if>
<#if cssdelimiter.byteValue == "DELIMITER">
  <#assign CSS_SVC_DELIMITER_ID = "CSS_INT_SVC_" + CSS_SVC + "_CP_" + CSS_CP + "_DELIMITER">
  <#assign CSS_SVC_DELIMITER_VALUE = CSS_SVC_DELIMITER_ID?eval>

#define ${CSS_SVC_FNVAR_NAME_VALUE}_DELIMITER      0x${CSS_SVC_DELIMITER_VALUE?upper_case}U
<#elseif cssdelimiter.byteValue == "DELIMITER_MSB">
  <#assign CSS_SVC_DELIMITER_MSB_ID = "CSS_INT_SVC_" + CSS_SVC + "_CP_" + CSS_CP + "_DELIMITER_MSB">
  <#assign CSS_SVC_DELIMITER_MSB_VALUE = CSS_SVC_DELIMITER_MSB_ID?eval>
  <#assign CSS_SVC_DELIMITER_LSB_ID = "CSS_INT_SVC_" + CSS_SVC + "_CP_" + CSS_CP + "_DELIMITER_LSB">
  <#assign CSS_SVC_DELIMITER_LSB_VALUE = CSS_SVC_DELIMITER_LSB_ID?eval>

#define ${CSS_SVC_FNVAR_NAME_VALUE}_DELIMITER_MSB 0x${CSS_SVC_DELIMITER_MSB_VALUE?upper_case}U
#define ${CSS_SVC_FNVAR_NAME_VALUE}_DELIMITER_LSB 0x${CSS_SVC_DELIMITER_LSB_VALUE?upper_case}U
</#if>
<#if cssseqnum.byteValue == "SEQNUM">

#define ${CSS_SVC_FNVAR_NAME_VALUE}_SEQ_MAX           255U
#define ${CSS_SVC_FNVAR_NAME_VALUE}_SEQ_CHECK_SUCCESS 0U
#define ${CSS_SVC_FNVAR_NAME_VALUE}_SEQ_CHECK_FAIL    1U
<#elseif cssseqnum.byteValue == "SEQNUM_MSB">

#define ${CSS_SVC_FNVAR_NAME_VALUE}_SEQ_MAX           65535U
#define ${CSS_SVC_FNVAR_NAME_VALUE}_SEQ_CHECK_SUCCESS 0U
#define ${CSS_SVC_FNVAR_NAME_VALUE}_SEQ_CHECK_FAIL    1U
</#if>
<#if csschecksum.byteValue == "CHECKSUM8" || csschecksum.byteValue == "CHECKSUM16_MSB" || csschecksum.byteValue == "CHECKSUM32_MSB">
  <#assign CSS_SVC_CHECKSUM_BYTE_START_ID = "CSS_INT_SVC_" + CSS_SVC + "_CP_" + CSS_CP + "_CRC_BYTE_START">
  <#assign CSS_SVC_CHECKSUM_BYTE_START_VALUE = CSS_SVC_CHECKSUM_BYTE_START_ID?eval>

#define ${CSS_SVC_FNVAR_NAME_VALUE}_CHECKSUM_BYTE_START   ${CSS_SVC_CHECKSUM_BYTE_START_VALUE}
</#if>
<#if csscrc.byteValue == "CRC8" || csscrc.byteValue == "CRC16_MSB" || csscrc.byteValue == "CRC32_MSB">
  <#assign CSS_SVC_CRC_POLY_ID = "CSS_INT_SVC_" + CSS_SVC + "_CP_" + CSS_CP + "_POLY">
  <#assign CSS_SVC_CRC_POLY_VALUE = CSS_SVC_CRC_POLY_ID?eval>
  <#assign CSS_SVC_CRC_BYTE_START_ID = "CSS_INT_SVC_" + CSS_SVC + "_CP_" + CSS_CP + "_CRC_BYTE_START">
  <#assign CSS_SVC_CRC_BYTE_START_VALUE = CSS_SVC_CRC_BYTE_START_ID?eval>

#define ${CSS_SVC_FNVAR_NAME_VALUE}_CRC_POLY         0x${CSS_SVC_CRC_POLY_VALUE?upper_case}U
#define ${CSS_SVC_FNVAR_NAME_VALUE}_CRC_BYTE_START   ${CSS_SVC_CRC_BYTE_START_VALUE}U
</#if>
<#if csscrc.byteValue == "CRC8"> 
#define ${CSS_SVC_FNVAR_NAME_VALUE}_CRC_INIT_VAL     0xFFU
<#elseif csscrc.byteValue == "CRC16_MSB">
#define ${CSS_SVC_FNVAR_NAME_VALUE}_CRC_INIT_VAL     0xFFFFU
<#elseif csscrc.byteValue == "CRC32_MSB">
#define ${CSS_SVC_FNVAR_NAME_VALUE}_CRC_INIT_VAL     0xFFFFFFFFU
</#if>

<#if cssenddelimiter.byteValue == "END_DELIMITER">
  <#assign CSS_SVC_END_DELIMITER_ID = "CSS_INT_SVC_" + CSS_SVC + "_CP_" + CSS_CP + "_END_DELIMITER">
  <#assign CSS_SVC_END_DELIMITER_VALUE = CSS_SVC_END_DELIMITER_ID?eval>

#define ${CSS_SVC_FNVAR_NAME_VALUE}_END_DELIMITER 0x${CSS_SVC_END_DELIMITER_VALUE?upper_case}U
<#elseif cssenddelimiter.byteValue == "END_DELIMITER_MSB">
  <#assign CSS_SVC_END_DELIMITER_MSB_ID = "CSS_INT_SVC_" + CSS_SVC + "_CP_" + CSS_CP + "_END_DELIMITER_MSB">
  <#assign CSS_SVC_END_DELIMITER_MSB_VALUE = CSS_SVC_END_DELIMITER_MSB_ID?eval>
  <#assign CSS_SVC_END_DELIMITER_LSB_ID = "CSS_INT_SVC_" + CSS_SVC + "_CP_" + CSS_CP + "_END_DELIMITER_LSB">
  <#assign CSS_SVC_END_DELIMITER_LSB_VALUE = CSS_SVC_END_DELIMITER_LSB_ID?eval>

#define ${CSS_SVC_FNVAR_NAME_VALUE}_END_DELIMITER_MSB 0x${CSS_SVC_END_DELIMITER_MSB_VALUE?upper_case}U
#define ${CSS_SVC_FNVAR_NAME_VALUE}_END_DELIMITER_LSB 0x${CSS_SVC_END_DELIMITER_LSB_VALUE?upper_case}U
</#if>
<#if CSS_SVC_ESCCHAR_ENABLE_VALUE == true>

#define ${CSS_SVC_FNVAR_NAME_VALUE}_ESCCHAR 0x${CSS_SVC_ESCCHAR_VALUE?upper_case}U
</#if>
<#if cssopcode.byteValue != "UNUSED">

#define ${CSS_SVC_FNVAR_NAME_VALUE}_COMMAND_COUNT ${CSS_SVC_COMMAND_COUNT_VALUE}U
</#if>

// *****************************************************************************
// *****************************************************************************
// Section: Data Types
// *****************************************************************************
// *****************************************************************************
<#if cssdelimiter.byteValue != "UNUSED" || csslen.byteValue != "UNUSED" || cssenddelimiter.byteValue != "UNUSED">
typedef enum ${CSS_SVC_FNVAR_NAME_VALUE}_ErrorType_T
{
  ${CSS_SVC_FNVAR_NAME_VALUE}_NO_ERROR  = 0x00U,
  <#if cssdelimiter.byteValue == "DELIMITER" || cssdelimiter.byteValue == "DELIMITER_MSB">
  ${CSS_SVC_FNVAR_NAME_VALUE}_ERROR_DELIMITER,
  </#if>
  <#if cssseqnum.byteValue == "SEQNUM" || cssseqnum.byteValue == "SEQNUM_MSB">
  ${CSS_SVC_FNVAR_NAME_VALUE}_ERROR_SEQUENCE,
  </#if>
  <#if cssopcode.byteValue == "OPCODE" || cssopcode.byteValue == "OPCODE_MSB">
  ${CSS_SVC_FNVAR_NAME_VALUE}_NOT_VALID_OPCODE,
  </#if>
  <#if csslen.byteValue == "PAYLOAD_LEN" || csslen.byteValue == "PAYLOAD_LEN_MSB">
  ${CSS_SVC_FNVAR_NAME_VALUE}_ERROR_LENGTH,
  </#if>
  <#if csschecksum.byteValue == "CHECKSUM8" || csschecksum.byteValue == "CHECKSUM16_MSB" || csschecksum.byteValue == "CHECKSUM32_MSB">
  ${CSS_SVC_FNVAR_NAME_VALUE}_ERROR_CHECKSUM,
  </#if>
  <#if csscrc.byteValue == "CRC8" || csscrc.byteValue == "CRC16_MSB" || csscrc.byteValue == "CRC32_MSB">
  ${CSS_SVC_FNVAR_NAME_VALUE}_ERROR_CRC,
  </#if>
  <#if cssenddelimiter.byteValue == "END_DELIMITER" || cssenddelimiter.byteValue == "END_DELIMITER_MSB">
  ${CSS_SVC_FNVAR_NAME_VALUE}_ERROR_END_DELIMITER,
  </#if>
  ${CSS_SVC_FNVAR_NAME_VALUE}_INVALID_PACKET,
} ${CSS_SVC_FNVAR_NAME_VALUE}_ErrorType_T;

  <#if CSS_SVC_ESCCHAR_ENABLE_VALUE == true>
typedef struct __attribute__ ((packed))
{
uint8_t payload[256];
    <#if csslen.byteValue == "PAYLOAD_LEN">
uint8_t payloadLen;
    <#else>
uint16_t payloadLen;
    </#if>
}${CSS_SVC_FNVAR_NAME_VALUE}_ActData_T;
  </#if>

typedef struct __attribute__ ((packed))
{
  <#if csslen.byteValue == "UNUSED">
  uint16_t payloadLen;
  </#if>
  <#if cssseqnum.byteValue == "SEQNUM">
  uint8_t seqNum;
  <#elseif cssseqnum.byteValue == "SEQNUM_MSB">
  uint16_t seqNum;
  </#if>
  <#if cssopcode.byteValue == "OPCODE">
  uint8_t opcode;
  <#elseif cssopcode.byteValue == "OPCODE_MSB">
  uint16_t opcode;
  </#if>
  <#if csslen.byteValue == "PAYLOAD_LEN">
  uint8_t payloadLen;
  <#elseif csslen.byteValue == "PAYLOAD_LEN_MSB">
  uint16_t payloadLen;
  </#if>
  uint8_t* payload;
  <#if csschecksum.byteValue == "CHECKSUM8">
  uint8_t checksum8;
  <#elseif csschecksum.byteValue == "CHECKSUM16_MSB">
  uint16_t checksum16;
  <#elseif csschecksum.byteValue == "CHECKSUM32_MSB">
  uint32_t checksum32;
  </#if>
  <#if csscrc.byteValue == "CRC8">
  uint8_t crc8;
  <#elseif csscrc.byteValue == "CRC16_MSB">
  uint16_t crc16;
  <#elseif csscrc.byteValue == "CRC32_MSB">
  uint32_t crc32;
  </#if>
}${CSS_SVC_FNVAR_NAME_VALUE}_Packet_T;

  <#if cssopcode.byteValue == "UNUSED">
typedef void(*${CSS_SVC_FNVAR_NAME_VALUE}_ActionCb_T)(uint8_t* payload, uint16_t payloadlength);
  <#else>
typedef struct __attribute__ ((packed))
{
  uint16_t   CmdId;
  void  (*fnPtr) (uint8_t* p_payload, uint16_t payloadLen);
} ${CSS_SVC_FNVAR_NAME_VALUE}_ActionCbTable_T;
  </#if>
typedef void(*${CSS_SVC_FNVAR_NAME_VALUE}_ErrorCb_T)(${CSS_SVC_FNVAR_NAME_VALUE}_ErrorType_T errorType);
typedef void(*${CSS_SVC_FNVAR_NAME_VALUE}_BleDisconnectedCb_T)(void);
  <#if cssseqnum.byteValue == "SEQNUM">
typedef uint32_t(*${CSS_SVC_FNVAR_NAME_VALUE}_SeqCheckCb_T)(uint8_t receivedSeqNum);
  <#elseif cssseqnum.byteValue == "SEQNUM_MSB">
typedef uint32_t(*${CSS_SVC_FNVAR_NAME_VALUE}_SeqCheckCb_T)(uint16_t receivedSeqNum);
  </#if>
  <#if csschecksum.byteValue == "CHECKSUM8" || csscrc.byteValue == "CRC8">
typedef uint8_t(*${CSS_SVC_FNVAR_NAME_VALUE}_ErrorCheckCb_T)(uint8_t* data, uint16_t length);
  <#elseif csschecksum.byteValue == "CHECKSUM16_MSB" || csscrc.byteValue == "CRC16_MSB">
typedef uint16_t(*${CSS_SVC_FNVAR_NAME_VALUE}_ErrorCheckCb_T)(uint8_t* data, uint16_t length);
  <#elseif csschecksum.byteValue == "CHECKSUM32_MSB" || csscrc.byteValue == "CRC32_MSB">
typedef uint32_t(*${CSS_SVC_FNVAR_NAME_VALUE}_ErrorCheckCb_T)(uint8_t* data, uint16_t length);
  </#if>

typedef struct __attribute__ ((packed))
{
  <#if cssopcode.byteValue == "UNUSED">
  ${CSS_SVC_FNVAR_NAME_VALUE}_ActionCb_T bleCpsActionCb;
  <#else>
  ${CSS_SVC_FNVAR_NAME_VALUE}_ActionCbTable_T* bleCpsActionCbTable;
  </#if>
  <#if cssseqnum.byteValue != "UNUSED">
  ${CSS_SVC_FNVAR_NAME_VALUE}_SeqCheckCb_T bleCpsSeqCheckCb;
  </#if>
  <#if csschecksum.byteValue != "UNUSED" || csscrc.byteValue != "UNUSED">
  ${CSS_SVC_FNVAR_NAME_VALUE}_ErrorCheckCb_T bleCpsErrorCheckCb;
  </#if>
  ${CSS_SVC_FNVAR_NAME_VALUE}_ErrorCb_T bleCpsErrorCb;
  ${CSS_SVC_FNVAR_NAME_VALUE}_BleDisconnectedCb_T bleCpsDisconnectedCb;
}${CSS_SVC_FNVAR_NAME_VALUE}_Cb_T;
<#else>
typedef void(*${CSS_SVC_FNVAR_NAME_VALUE}_BleDisconnectedCb_T)(void);
typedef void(*${CSS_SVC_FNVAR_NAME_VALUE}_ActionCb_T)(uint8_t* payload, uint16_t payloadlength);
typedef struct __attribute__ ((packed))
{
  ${CSS_SVC_FNVAR_NAME_VALUE}_ActionCb_T bleCpsActionCb;
  ${CSS_SVC_FNVAR_NAME_VALUE}_BleDisconnectedCb_T bleCpsDisconnectedCb;
}${CSS_SVC_FNVAR_NAME_VALUE}_Cb_T;
</#if>

// *****************************************************************************
// *****************************************************************************
// Section: Function Prototypes
// *****************************************************************************
// *****************************************************************************
/**
 * @brief Handles BLE device disconnection events.
 *
 * This function is called from BLE_CPS_GapEventProcess() when a BLE device disconnection occurs.
 *
 * @param[in] None
 *
 * @retval None
 */
void ${CSS_SVC_FNVAR_NAME_VALUE}_DeviceDisconnected(void);

/**
 * @brief Decodes the packet and calls the action handler to execute the corresponding action.
 *
 * This function takes a packet buffer and its length, decodes the packet, and then calls the appropriate
 * action handler based on the decoded information.
 *
 * @param[in] packetLen Length of the packet.
 * @param[in] p_packet Pointer to the packet buffer (array of uint8_t).
 *
 * @retval None
 */
void ${CSS_SVC_FNVAR_NAME_VALUE}_CmdDecode(uint16_t packetLen,uint8_t* p_packet);

/**
 * @brief Registers the necessary callbacks for user actions.
 *
 * This function takes a structure containing callback functions and registers
 * them for handling user actions.
 *
 * @param[in] callback A structure containing the callback functions to register.
 *
 * @retval None
 */
void ${CSS_SVC_FNVAR_NAME_VALUE}_CallbackRegister(${CSS_SVC_FNVAR_NAME_VALUE}_Cb_T callback);

//DOM-IGNORE-BEGIN
#ifdef __cplusplus
}
#endif
//DOM-IGNORE-END

#endif /* ${CSS_SVC_FNVAR_NAME_VALUE}_H */