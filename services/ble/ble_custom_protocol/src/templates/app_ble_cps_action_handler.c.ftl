<#assign CSS_SVC_NAME_ID = "CSS_STR_SVC_NAME_" + CSS_SVC>
<#assign CSS_SVC_NAME_VALUE = CSS_SVC_NAME_ID?eval>
<#assign CSS_SVC_HEADER_LEN_ID = "CSS_INT_SVC_" + CSS_SVC + "_CP_" + CSS_CP + "_HEADER_LEN">
<#assign CSS_SVC_HEADER_LEN_VALUE = CSS_SVC_HEADER_LEN_ID?eval>
<#assign CSS_SVC_FOOTER_LEN_ID = "CSS_INT_SVC_" + CSS_SVC + "_CP_" + CSS_CP + "_FOOTER_LEN">
<#assign CSS_SVC_FOOTER_LEN_VALUE = CSS_SVC_FOOTER_LEN_ID?eval>
<#assign CSS_SVC_COMMAND_COUNT_ID = "CSS_INT_SVC_" + CSS_SVC + "_CP_" + CSS_CP + "_COMMAND_COUNT">
<#assign CSS_SVC_COMMAND_COUNT_VALUE = CSS_SVC_COMMAND_COUNT_ID?eval>
<#assign CSS_SVC_FNVAR_NAME_PREFIX = "APP_WLS_CPS_" + CSS_SVC_NAME_VALUE?upper_case + CSS_CP>
<#assign CSS_SVC_LFNVAR_NAME_PREFIX = "app_wls_cps_" + CSS_SVC_NAME_VALUE?lower_case + CSS_CP>
<#assign CSS_SVC_MACRO_PREFIX = "APP_WLS_CPS_" + CSS_SVC_NAME_VALUE?upper_case + CSS_CP>
<#assign CSS_SVC_DECODE_FNVAR_PREFIX = "BLE_CPS_" + CSS_SVC_NAME_VALUE?upper_case + CSS_CP + "_DECODE">
<#assign CSS_SVC_DECODE_LOWER_PREFIX = "ble_cps_" + CSS_SVC_NAME_VALUE?lower_case + CSS_CP + "_decode">
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
<#assign CSS_BOOL_APP_LED_CODE = false>
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
  Application BLE Custom System Service Source File

  Company:
    Microchip Technology Inc.

  File Name:
    ${CSS_SVC_LFNVAR_NAME_PREFIX}_action_handler.c

  Summary:
    This file contains functions for processing decoded packets and executing 
    corresponding actions.
	
  Description:
    This file contains functions for executing corresponding actions.
    The implementation of demo mode is included in this file.
 *******************************************************************************/

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************
#include "${CSS_SVC_LFNVAR_NAME_PREFIX}_action_handler.h"
#include "wireless/services/ble/cps/${CSS_SVC_DECODE_LOWER_PREFIX}.h"
#include "wireless/services/ble/cps/ble_cps_handler.h"
#include "definitions.h"

// *****************************************************************************
// *****************************************************************************
// Section: Local Variables and Macros
// *****************************************************************************
// *****************************************************************************
<#if (cssdelimiter.byteValue != "UNUSED" || csslen.byteValue != "UNUSED" || cssenddelimiter.byteValue != "UNUSED") && (cssopcode.byteValue != "UNUSED")>
  <#if (mainBoard_WBZ451_CURIOSITY?? || mainBoard_WBZ351_CURIOSITY??) && CSS_BOOL_APP_CODE_ENABLE == true>
      <#if SERVICE_CMS?? && SERVICE_CMS.CMS_INT_SERVICE_COUNT == 1>
        <#if SERVICE_CMS.CMS_INT_SVC_CHAR_COUNT_0 == 1>
          <#if SERVICE_CMS.CMS_STR_SVC_NAME_0 == "ledctrl" || SERVICE_CMS.CMS_STR_SVC_NAME_0 == "LEDCTRL">
            <#if SERVICE_CMS.CMS_STR_SVC_UUID_0 == "144d508b1543489787489227dfcb15b0">
              <#if SERVICE_CMS.CMS_STR_SVC_0_CHAR_0_UUID == "da6dc1884bf646928734214fdf2ca1e4">
                <#if cssopcode.byteValue != "UNUSED">
                  <#if CSS_INT_SVC_0_CP_0_COMMAND_COUNT == 2>
                    <#assign CSS_BOOL_APP_LED_CODE = true>
                  </#if>
                </#if>
              </#if>
            </#if>
          </#if>
        </#if>
      </#if>
  </#if>
  <#list 0..(CSS_SVC_COMMAND_COUNT_VALUE - 1) as i>
      <#assign CSS_SVC_COMMAND_NAME_ID = "CSS_STR_SVC_" + CSS_SVC + "_CP_" + CSS_CP + "COMMAND_NAME" + i>
      <#assign CSS_SVC_COMMAND_NAME_VALUE = CSS_SVC_COMMAND_NAME_ID?eval>
      <#assign firstChar = CSS_SVC_COMMAND_NAME_VALUE?substring(0, 1)?upper_case>
      <#assign restChars = CSS_SVC_COMMAND_NAME_VALUE?substring(1)?lower_case>
      <#assign CSS_SVC_FNNAME_SUFFIX = firstChar + restChars>
static void ${CSS_SVC_LFNVAR_NAME_PREFIX}_Action${CSS_SVC_FNNAME_SUFFIX}(uint8_t* p_payload, uint16_t payloadLength);
  </#list>

static ${CSS_SVC_DECODE_FNVAR_PREFIX}_ActionCbTable_T s_cmdTable[${CSS_SVC_MACRO_PREFIX}_COMMAND_COUNT] = 
{
  <#list 0..(CSS_SVC_COMMAND_COUNT_VALUE - 1) as i>
      <#assign CSS_SVC_COMMAND_NAME_ID = "CSS_STR_SVC_" + CSS_SVC + "_CP_" + CSS_CP + "COMMAND_NAME" + i>
      <#assign CSS_SVC_COMMAND_NAME_VALUE = CSS_SVC_COMMAND_NAME_ID?eval>
      <#assign firstChar = CSS_SVC_COMMAND_NAME_VALUE?substring(0, 1)?upper_case>
      <#assign restChars = CSS_SVC_COMMAND_NAME_VALUE?substring(1)?lower_case>
      <#assign CSS_SVC_FNNAME_SUFFIX = firstChar + restChars>
  {${CSS_SVC_MACRO_PREFIX}_${CSS_SVC_COMMAND_NAME_VALUE?upper_case},${CSS_SVC_LFNVAR_NAME_PREFIX}_Action${CSS_SVC_FNNAME_SUFFIX}},
  </#list>
};
  <#if CSS_BOOL_APP_LED_CODE == true>

#define APP_WLS_RGB_RED_On()    GPIO_PinSet(GPIO_PIN_RB0)
#define APP_WLS_RGB_RED_Off()   GPIO_PinClear(GPIO_PIN_RB0)
#define APP_WLS_RGB_GREEN_On()  GPIO_PinSet(GPIO_PIN_RB3)
#define APP_WLS_RGB_GREEN_Off() GPIO_PinClear(GPIO_PIN_RB3)
#define APP_WLS_RGB_BLUE_On()   GPIO_PinSet(GPIO_PIN_RB5)
#define APP_WLS_RGB_BLUE_Off()  GPIO_PinClear(GPIO_PIN_RB5)
#define APP_WLS_USER_LED_On()   GPIO_PinClear(GPIO_PIN_RB7)
#define APP_WLS_LED_Start()     APP_WLS_RGB_RED_Off();\
                                APP_WLS_RGB_GREEN_Off();\
                                APP_WLS_RGB_BLUE_Off();\
                                APP_WLS_USER_LED_On()
#ifdef PIC32BZ2
#define APP_WLS_LED_Init()      APP_WLS_LED_Start()
#elif defined(PIC32BZ3)
#define APP_WLS_LED_Init()      APP_WLS_LED_Start();\
                                SYS_DEBUG_MESSAGE(SYS_ERROR_INFO,"[BLE CPS APP] RGB RED/BLUE LED: Only GPIO PB0/PB5 state change supported!\r\n")
#endif

typedef struct __attribute__ ((packed))
{
    uint8_t    Red;
    uint8_t    Green;
    uint8_t    Blue;
}${CSS_SVC_DECODE_FNVAR_PREFIX}_LedState;

static ${CSS_SVC_DECODE_FNVAR_PREFIX}_LedState s_ledState = {0,0,0};
  </#if>
</#if>

// *****************************************************************************
// *****************************************************************************
// Section: Functions
// *****************************************************************************
// *****************************************************************************
<#if cssdelimiter.byteValue != "UNUSED" || csslen.byteValue != "UNUSED" || cssenddelimiter.byteValue != "UNUSED">
  <#if cssopcode.byteValue != "UNUSED">
      <#list 0..(CSS_SVC_COMMAND_COUNT_VALUE - 1) as i>
        <#assign CSS_SVC_COMMAND_NAME_ID = "CSS_STR_SVC_" + CSS_SVC + "_CP_" + CSS_CP + "COMMAND_NAME" + i>
        <#assign CSS_SVC_COMMAND_NAME_VALUE = CSS_SVC_COMMAND_NAME_ID?eval>
        <#assign firstChar = CSS_SVC_COMMAND_NAME_VALUE?substring(0, 1)?upper_case>
        <#assign restChars = CSS_SVC_COMMAND_NAME_VALUE?substring(1)?lower_case>
        <#assign CSS_SVC_FNNAME_SUFFIX = firstChar + restChars>
static void ${CSS_SVC_LFNVAR_NAME_PREFIX}_Action${CSS_SVC_FNNAME_SUFFIX}(uint8_t* p_payload, uint16_t payloadLength)
{
        <#if CSS_BOOL_APP_CODE_ENABLE == true>
  if(payloadLength > 0)
  {
    SYS_DEBUG_MESSAGE(SYS_ERROR_INFO,"[BLE CPS APP] Payload Received: ");
    for (uint16_t i = 0; i < payloadLength; i++) 
    {
       SYS_DEBUG_PRINT(SYS_ERROR_INFO,"%02X ", p_payload[i]);
    }
    SYS_DEBUG_MESSAGE(SYS_ERROR_INFO,"\r\n");
  }
  else
  {
    SYS_DEBUG_MESSAGE(SYS_ERROR_INFO,"[BLE CPS APP] No Payload\r\n");
  }
        </#if>
        <#if CSS_BOOL_APP_LED_CODE == true>
          <#if i == 0>
  if(payloadLength == 3U && p_payload != NULL)
  {
    if(p_payload[0] == 1U)
    {
        s_ledState.Red = 1U;
        APP_WLS_RGB_RED_On();
    }
    else if(p_payload[0] == 0U)
    {
        s_ledState.Red = 0U;
        APP_WLS_RGB_RED_Off();
    }
    if(p_payload[1] == 1U)
    {
        s_ledState.Green = 1U;
        APP_WLS_RGB_GREEN_On();
    }
    else if(p_payload[1] == 0U)
    {
        s_ledState.Green = 0U;
        APP_WLS_RGB_GREEN_Off();  
    }
    if(p_payload[2] == 1U)
    {
        s_ledState.Blue = 1U;
        APP_WLS_RGB_BLUE_On();
    }
    else if(p_payload[2] == 0U)
    {
        s_ledState.Blue = 0U;
        APP_WLS_RGB_BLUE_Off();
    }
  }
          <#elseif i == 1>
  if(payloadLength == 0U)
  {
    uint8_t resp[3] = {s_ledState.Red,s_ledState.Green,s_ledState.Blue};
    (void)(p_payload);
    (void)(payloadLength);
    BLE_CPS_SendResponse(3,resp);
  }
          </#if>
        <#else>
  /*Add User Code here for action handling*/
        </#if>
}
      </#list>
  <#else>
static void ${CSS_SVC_LFNVAR_NAME_PREFIX}_ActionHandler(uint8_t* p_payload, uint16_t payloadLength)
{
    <#if CSS_BOOL_APP_CODE_ENABLE == true>
  if(payloadLength > 0)
  {
    SYS_DEBUG_MESSAGE(SYS_ERROR_INFO,"[BLE CPS APP] Payload Received: ");
    for (uint16_t i = 0; i < payloadLength; i++) 
    {
      SYS_DEBUG_PRINT(SYS_ERROR_INFO,"%02X ", p_payload[i]);
    }
    SYS_DEBUG_MESSAGE(SYS_ERROR_INFO,"\r\n");
  }
  else
  {
    SYS_DEBUG_MESSAGE(SYS_ERROR_INFO,"[BLE CPS APP] No Payload\r\n");
  }
    </#if>
  /*Add User Code here for action handling*/
}
  </#if>
static void ${CSS_SVC_LFNVAR_NAME_PREFIX}_ErrorHandler(${CSS_SVC_DECODE_FNVAR_PREFIX}_ErrorType_T errortype)
{
      <#if CSS_BOOL_APP_CODE_ENABLE == true>
  SYS_DEBUG_PRINT(SYS_ERROR_INFO,"[BLE CPS APP] Failed with error type = %d\r\n",errortype);
      </#if>
  /*Add User Code here for error handling*/
}
<#else>
static void ${CSS_SVC_LFNVAR_NAME_PREFIX}_ActionHandler(uint8_t* p_payload,uint16_t payloadLength)
{
  <#if CSS_BOOL_APP_CODE_ENABLE == true>
  if(payloadLength > 0)
  {
    SYS_DEBUG_MESSAGE(SYS_ERROR_INFO,"[BLE CPS APP] Payload Received: ");
    for (uint16_t i = 0; i < payloadLength; i++) 
    {
      SYS_DEBUG_PRINT(SYS_ERROR_INFO,"%02X ", p_payload[i]);
    }
    SYS_DEBUG_MESSAGE(SYS_ERROR_INFO,"\r\n");
  }
  else
  {
    SYS_DEBUG_MESSAGE(SYS_ERROR_INFO,"[BLE CPS APP] No Payload\r\n");
  }
  </#if>
  /*Add User Code here for action handling*/
}
</#if>

static void ${CSS_SVC_LFNVAR_NAME_PREFIX}_DeviceDisconnected(void)
{
  /*Add User Code here for BLE connection close*/
}

void ${CSS_SVC_FNVAR_NAME_PREFIX}_CallbackRegisterInit(void)
{
<#if cssdelimiter.byteValue != "UNUSED" || csslen.byteValue != "UNUSED" || cssenddelimiter.byteValue != "UNUSED">
  ${CSS_SVC_DECODE_FNVAR_PREFIX}_Cb_T appCallback =
  {
    <#if cssopcode.byteValue == "UNUSED"> 
    ${CSS_SVC_LFNVAR_NAME_PREFIX}_ActionHandler,
    <#else>
    s_cmdTable,
    </#if>
    <#if cssseqnum.byteValue != "UNUSED">
    NULL, /*If required, replace NULL with a user-defined callback function to validate sequence numbers*/
    </#if>
    <#if csschecksum.byteValue != "UNUSED" || csscrc.byteValue != "UNUSED">
    NULL, /*If required, replace NULL with a user-defined callback function for CRC/Checksum calculation*/
    </#if>
    ${CSS_SVC_LFNVAR_NAME_PREFIX}_ErrorHandler,
    ${CSS_SVC_LFNVAR_NAME_PREFIX}_DeviceDisconnected
  };
  ${CSS_SVC_DECODE_FNVAR_PREFIX}_CallbackRegister(appCallback);
<#else>
  ${CSS_SVC_DECODE_FNVAR_PREFIX}_Cb_T appCallback =
  {
    ${CSS_SVC_LFNVAR_NAME_PREFIX}_ActionHandler,
    ${CSS_SVC_LFNVAR_NAME_PREFIX}_DeviceDisconnected
  };
  ${CSS_SVC_DECODE_FNVAR_PREFIX}_CallbackRegister(appCallback);
</#if>
<#if CSS_BOOL_APP_LED_CODE == true>

  APP_WLS_LED_Init();
</#if>
}
