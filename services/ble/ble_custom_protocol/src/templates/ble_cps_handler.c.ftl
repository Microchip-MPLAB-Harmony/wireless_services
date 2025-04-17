<#assign SVC_MAX_COUNT = CSS_SVC_MAX_COUNT?number>
<#assign CP_MAX_COUNT = CSS_CP_MAX_COUNT?number>
<#assign cssList = [] />
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
  BLE Custom System Service Write Handler Source File

  Company:
    Microchip Technology Inc.

  File Name:
    ble_css_handler.c

  Summary:
    This file contains the functions to handle the BLE write data.
	
  Description:
    This file contains the functions to handle the BLE write data.
    The implementation is included in this file.
 *******************************************************************************/


// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************
#include "ble_cps_handler.h"
<#assign srv_found = false>
<#list 0..(SVC_MAX_COUNT - 1) as i>
  <#assign CSS_SVC_NAME_ID = "CSS_STR_SVC_NAME_" + i>
  <#assign CSS_SVC_NAME_VALUE = CSS_SVC_NAME_ID?eval>
  <#list 0..(CP_MAX_COUNT - 1) as j>
    <#assign CSS_CP_COMMAND_ID = "CSS_BOOL_SVC_" + i + "_CP_" + j + "_COMMAND">
    <#if CSS_CP_COMMAND_ID?eval == true>
      <#assign srv_found = true>
      <#assign cssList = cssList + [{"svcName": CSS_SVC_NAME_VALUE, "charNumber":j}]>
#include "ble_cps_${CSS_SVC_NAME_VALUE?lower_case}${j}_decode.h"
    </#if>
  </#list>
  <#if srv_found == true>
    <#assign srv_found = false>
#include "ble/service_ble/ble_cms/ble_${CSS_SVC_NAME_VALUE?lower_case}_svc.h"
  </#if>
</#list>
#include "osal/osal_freertos.h"

// *****************************************************************************
// *****************************************************************************
// Section: Local Variables
// *****************************************************************************
// *****************************************************************************
static BLE_CSS_CurrConn_T     s_CurrConn;

// *****************************************************************************
// *****************************************************************************
// Section: Functions
// *****************************************************************************
// *****************************************************************************
<#assign serviceName = "servicename">
<#if (cssList?size > 0)>
<#list cssList as entry>
<#if serviceName != entry.svcName>
static void ble_cps_${entry.svcName?lower_case}_AttributeHandle(BLE_${entry.svcName?upper_case}_AttributeHandle_T attrHandle,uint16_t writeLength,uint8_t* writeData)
{
    <#assign serviceName = entry.svcName>
    switch(attrHandle)
    {
  <#list cssList as entry>
    <#if serviceName == entry.svcName>
      case ${entry.svcName?upper_case}_HDL_CHARVAL_${entry.charNumber}:
          BLE_CPS_${entry.svcName?upper_case}${entry.charNumber}_DECODE_CmdDecode(writeLength,writeData);
          break;
    </#if>
  </#list>
      default:
          /*Handle unexpected cases*/
          break;  
    }
}
</#if>
</#list>
</#if>
static void ble_cps_GattsWriteProcess(GATT_EvtWrite_T writeEvent)
{
<#if (cssList?size > 0)>
  <#assign serviceName = "servicename"> 
    uint16_t status;
    s_CurrConn.connHandle = writeEvent.connHandle;
    s_CurrConn.attrHandle = writeEvent.attrHandle;

  <#list cssList as entry>
    <#if serviceName != entry.svcName>
    ble_cps_${entry.svcName?lower_case}_AttributeHandle((BLE_${entry.svcName?upper_case}_AttributeHandle_T) writeEvent.attrHandle,writeEvent.writeDataLength,writeEvent.writeValue);
    </#if>
  <#assign serviceName = entry.svcName>
  </#list>

    if ((writeEvent.writeType == ATT_WRITE_REQ)
    || (writeEvent.writeType == ATT_PREPARE_WRITE_REQ))
    {
        GATTS_SendWriteRespParams_T *p_trsRespParams = (GATTS_SendWriteRespParams_T *)OSAL_Malloc(sizeof(GATTS_SendWriteRespParams_T));
        if (p_trsRespParams == NULL)
        {
            return;
        }
        p_trsRespParams->responseType = ATT_WRITE_RSP;
        status = GATTS_SendWriteResponse(writeEvent.connHandle, p_trsRespParams);
        if (status == MBA_RES_SUCCESS)
        {
            OSAL_Free(p_trsRespParams);
            p_trsRespParams = NULL;
        }
    }
</#if>
}

void BLE_CPS_GapEventProcess(BLE_GAP_Event_T *p_event)
{
    switch(p_event->eventId)
    {
        case BLE_GAP_EVT_CONNECTED:
        {
            s_CurrConn.connHandle = p_event->eventField.evtConnect.connHandle;
        }
        break;
        case BLE_GAP_EVT_DISCONNECTED:
        {   <#if (cssList?size > 0)>
                <#list cssList as entry>
            BLE_CPS_${entry.svcName?upper_case}${entry.charNumber}_DECODE_DeviceDisconnected();
                </#list>
            </#if>
            s_CurrConn.connHandle = 0;
            (void)BLE_GAP_SetAdvEnable(true, BLE_CSS_GAP_ADV_DURATION);
        }
        break;
        default:
        {
            //Do nothing
        }
        break;
    }
}

void BLE_CPS_GattEventProcess(GATT_Event_T *p_event)
{
    switch (p_event->eventId)
    {
        case ATT_EVT_UPDATE_MTU:
        {
            s_CurrConn.attMtu = p_event->eventField.onUpdateMTU.exchangedMTU;
        }
        break;

        case GATTS_EVT_WRITE:
        {
            ble_cps_GattsWriteProcess((GATT_EvtWrite_T)p_event->eventField.onWrite);
        }
        break;

        default:
        {
            //Do nothing
        }
        break;
    }
}

uint16_t BLE_CPS_SendResponse(uint16_t payloadLength, uint8_t *p_payload)
{
    uint16_t result;
    GATTS_HandleValueParams_T *p_hvParams;

    if (s_CurrConn.connHandle == 0U)
    {
        return MBA_RES_FAIL;
    }

    if ((payloadLength > (s_CurrConn.attMtu-ATT_NOTI_INDI_HEADER_SIZE)) || (payloadLength == 0U) || (p_payload == NULL))
    {
        return MBA_RES_INVALID_PARA;
    }

    p_hvParams = (GATTS_HandleValueParams_T*)OSAL_Malloc(sizeof(GATTS_HandleValueParams_T));
    if (p_hvParams != NULL)
    {
        p_hvParams->charHandle = s_CurrConn.attrHandle;
        p_hvParams->charLength = payloadLength;
        (void)memcpy(p_hvParams->charValue, p_payload, payloadLength);
        p_hvParams->sendType = ATT_HANDLE_VALUE_NTF;
        result = GATTS_SendHandleValue(s_CurrConn.connHandle, p_hvParams);
        OSAL_Free(p_hvParams);
        
        return result;
    }
    else
    {
        return MBA_RES_OOM;
    }
}

uint16_t BLE_CPS_NotifyData(uint16_t attrHandle, uint16_t payloadLength, uint8_t *p_payload)
{
    uint16_t result;
    GATTS_HandleValueParams_T *p_hvParams;

    if (s_CurrConn.connHandle == 0U)
    {
        return MBA_RES_FAIL;
    }

    if ((payloadLength > (s_CurrConn.attMtu-ATT_NOTI_INDI_HEADER_SIZE)) || (payloadLength == 0U) || (p_payload == NULL))
    {
        return MBA_RES_INVALID_PARA;
    }

    p_hvParams = (GATTS_HandleValueParams_T*)OSAL_Malloc(sizeof(GATTS_HandleValueParams_T));
    if (p_hvParams != NULL)
    {
        p_hvParams->charHandle = attrHandle;
        p_hvParams->charLength = payloadLength;
        (void)memcpy(p_hvParams->charValue, p_payload, payloadLength);
        p_hvParams->sendType = ATT_HANDLE_VALUE_NTF;
        result = GATTS_SendHandleValue(s_CurrConn.connHandle, p_hvParams);
        OSAL_Free(p_hvParams);
        
        return result;
    }
    else
    {
        return MBA_RES_OOM;
    }
}

void BLE_CPS_Init(void)
{
<#list 0..(SVC_MAX_COUNT - 1) as i>
  <#assign CSS_SVC_NAME_ID = "CSS_STR_SVC_NAME_" + i>
  <#assign CSS_SVC_NAME_VALUE = CSS_SVC_NAME_ID?eval>
  <#list 0..(CP_MAX_COUNT - 1) as j>
    <#assign CSS_CP_COMMAND_ID = "CSS_BOOL_SVC_" + i + "_CP_" + j + "_COMMAND">
    <#if CSS_CP_COMMAND_ID?eval == true>
      <#assign srv_found = true>
    </#if>
  </#list>
  <#if srv_found == true>
    <#assign srv_found = false>
    (void)BLE_${CSS_SVC_NAME_VALUE?upper_case}_Add();
  </#if>
</#list>
}