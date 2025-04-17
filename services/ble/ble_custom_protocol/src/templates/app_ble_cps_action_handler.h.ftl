<#assign CSS_SVC_COMMAND_COUNT_ID = "CSS_INT_SVC_" + CSS_SVC + "_CP_" + CSS_CP + "_COMMAND_COUNT">
<#assign CSS_SVC_COMMAND_COUNT_VALUE = CSS_SVC_COMMAND_COUNT_ID?eval>
<#assign CSS_SVC_NAME_ID = "CSS_STR_SVC_NAME_" + CSS_SVC>
<#assign CSS_SVC_NAME_VALUE = CSS_SVC_NAME_ID?eval>
<#assign CSS_SVC_HEADER_LEN_ID = "CSS_INT_SVC_" + CSS_SVC + "_CP_" + CSS_CP + "_HEADER_LEN">
<#assign CSS_SVC_HEADER_LEN_VALUE = CSS_SVC_HEADER_LEN_ID?eval>
<#assign CSS_SVC_FOOTER_LEN_ID = "CSS_INT_SVC_" + CSS_SVC + "_CP_" + CSS_CP + "_FOOTER_LEN">
<#assign CSS_SVC_FOOTER_LEN_VALUE = CSS_SVC_FOOTER_LEN_ID?eval>
<#assign CSS_SVC_FNVAR_NAME_PREFIX = "APP_WLS_CPS_" + CSS_SVC_NAME_VALUE?upper_case + CSS_CP>
<#assign CSS_SVC_LFNVAR_NAME_PREFIX = "app_wls_cps_" + CSS_SVC_NAME_VALUE?lower_case + CSS_CP>
<#assign CSS_SVC_MACRO_PREFIX = "APP_WLS_CPS_" + CSS_SVC_NAME_VALUE?upper_case + CSS_CP>
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
    <#elseif CSS_SVC_BYTE_VALUE == "DELIMITER_MSB">
      <#assign cssdelimiter = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
    <#elseif CSS_SVC_BYTE_VALUE == "SEQNUM">
      <#assign cssseqnum = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
    <#elseif CSS_SVC_BYTE_VALUE == "SEQNUM_MSB">
      <#assign cssseqnum = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
    <#elseif CSS_SVC_BYTE_VALUE == "OPCODE">
      <#assign cssopcode = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
    <#elseif CSS_SVC_BYTE_VALUE == "OPCODE_MSB">
      <#assign cssopcode = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
    <#elseif CSS_SVC_BYTE_VALUE == "PAYLOAD_LEN">
      <#assign csslen = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
    <#elseif CSS_SVC_BYTE_VALUE == "PAYLOAD_LEN_MSB">
      <#assign csslen = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
    </#if>
  </#list>
</#if>
<#if (CSS_SVC_FOOTER_LEN_VALUE > 0)>
  <#list 0..(CSS_SVC_FOOTER_LEN_VALUE - 1) as i>
    <#assign CSS_SVC_BYTE_ID = "CSS_INT_SVC_" + CSS_SVC + "_CP_" + CSS_CP + "FOOTER_BYTE_" + i>
    <#assign CSS_SVC_BYTE_VALUE = CSS_SVC_BYTE_ID?eval>
    <#if CSS_SVC_BYTE_VALUE == "CHECKSUM8">
      <#assign csschecksum = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
    <#elseif CSS_SVC_BYTE_VALUE == "CHECKSUM16_MSB">
      <#assign csschecksum = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
    <#elseif CSS_SVC_BYTE_VALUE == "CHECKSUM32_MSB">
      <#assign csschecksum = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
    <#elseif CSS_SVC_BYTE_VALUE == "CRC8">
      <#assign csscrc = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
    <#elseif CSS_SVC_BYTE_VALUE == "CRC16_MSB">
      <#assign csscrc = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
    <#elseif CSS_SVC_BYTE_VALUE == "CRC32_MSB">
      <#assign csscrc = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
    <#elseif CSS_SVC_BYTE_VALUE == "END_DELIMITER">
      <#assign cssenddelimiter = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
    <#elseif CSS_SVC_BYTE_VALUE == "END_DELIMITER_MSB">
      <#assign cssenddelimiter = {"index": i,"byteValue": CSS_SVC_BYTE_VALUE}>
    </#if>
  </#list>
</#if>
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
  Application BLE Custom System Service Header File

  Company:
    Microchip Technology Inc.

  File Name:
    ${CSS_SVC_LFNVAR_NAME_PREFIX}_action_handler.h

  Summary:
    This file contains functions for processing decoded packets.
	
  Description:
    This file contains functions for processing decoded packets.
    The implementation of demo mode is included in this file.
 *******************************************************************************/

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************
#include <stdint.h>
#include <string.h>

// *****************************************************************************
// *****************************************************************************
// Section: Macros
// *****************************************************************************
// *****************************************************************************
<#if cssdelimiter.byteValue != "UNUSED" || csslen.byteValue != "UNUSED" || cssenddelimiter.byteValue != "UNUSED">
  <#if cssopcode.byteValue == "OPCODE" || cssopcode.byteValue == "OPCODE_MSB">
#define ${CSS_SVC_MACRO_PREFIX}_COMMAND_COUNT ${CSS_SVC_COMMAND_COUNT_VALUE}

    <#list 0..(CSS_SVC_COMMAND_COUNT_VALUE - 1) as i>
        <#assign CSS_SVC_COMMAND_NAME_ID = "CSS_STR_SVC_" + CSS_SVC + "_CP_" + CSS_CP + "COMMAND_NAME" + i>
        <#assign CSS_SVC_COMMAND_NAME_VALUE = CSS_SVC_COMMAND_NAME_ID?eval>
        <#assign CSS_SVC_COMMAND_ID = "CSS_HEX_SVC_" + CSS_SVC + "_CP_" + CSS_CP + "COMMAND_ID" + i>
        <#assign CSS_SVC_COMMAND_VALUE = CSS_SVC_COMMAND_ID?eval>
#define ${CSS_SVC_MACRO_PREFIX}_${CSS_SVC_COMMAND_NAME_VALUE?upper_case} 0x${CSS_SVC_COMMAND_VALUE?upper_case}
    </#list>

  </#if>
</#if>
// *****************************************************************************
// *****************************************************************************
// Section: Data Types
// *****************************************************************************
// *****************************************************************************

// *****************************************************************************
// *****************************************************************************
// Section: Function Prototypes
// *****************************************************************************
// *****************************************************************************
/**
 * @brief Registers the callbacks.
 *
 * This function will register the necessary callbacks for the application.
 *
 * @param[in] None
 *
 * @retval None
 */
void ${CSS_SVC_FNVAR_NAME_PREFIX}_CallbackRegisterInit(void);