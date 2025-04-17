<#if booleanappcode ==  true>
<#assign APP_ANCS = false>
<#assign APP_ANPC = false>
<#assign APP_ANPS = false>
<#assign APP_HOGP = false>
<#assign APP_PXPR = false>
<#assign APP_PXPM = false>
<#assign APP_THROUGHPUT = false>
<#if wlsbleancsss?? && wlsbleancsss.SS_ANCS_BOOL_CLIENT == true> 
<#assign APP_ANCS = true>
</#if>
<#if wlsbleanpss?? && wlsbleanpss.ANPSS_BOOL_CLIENT == true> 
<#assign APP_ANPC = true>
</#if>
<#if wlsbleanpss?? && wlsbleanpss.ANPSS_BOOL_SERVER == true> 
<#assign APP_ANPS = true>
</#if>
<#if wlsblehogp?? && wlsblehogp.HOGP_BOOL_SERVER == true> 
<#assign APP_HOGP = true>
</#if>
<#if wlsblepxpss?? && wlsblepxpss.SS_PXP_BOOL_CLIENT == true> 
<#assign APP_PXPM = true>
</#if>
<#if wlsblepxpss?? && wlsblepxpss.SS_PXP_BOOL_SERVER == true> 
<#assign APP_PXPR = true>
</#if>
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true && WLS_BLE_BOOL_GAP_EXT_ADV == false && WLS_BLE_GAP_DSADV_EN == false && WLS_BLE_BOOL_L2CAP_CREDIT_FLOWCTRL == true> 
<#assign APP_THROUGHPUT = true>
</#if>
/*******************************************************************************
  Application Timer Source File

  Company:
    Microchip Technology Inc.

  File Name:
    app_timer.c

  Summary:
    This file contains the Application Timer functions for this project.

  Description:
    This file contains the Application Timer functions for this project.
    Including the Set/Stop/Reset timer and timer expired handler.
 *******************************************************************************/

// DOM-IGNORE-BEGIN
/*******************************************************************************
* Copyright (C) 2025 Microchip Technology Inc. and its subsidiaries.
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
// DOM-IGNORE-END


// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************
#include <string.h>
#include "ble_util/byte_stream.h"
#include "app.h"
#include "app_ble.h"
#include "app_timer.h"
#include "app_error_defs.h"


// *****************************************************************************
// *****************************************************************************
// Section: Macros
// *****************************************************************************
// *****************************************************************************
#define STR_APP_TIMER "APP_Timer"


// *****************************************************************************
// *****************************************************************************
// Section: Data Types
// *****************************************************************************
// *****************************************************************************



// *****************************************************************************
// *****************************************************************************
// Section: Local Variables
// *****************************************************************************
// *****************************************************************************


// *****************************************************************************
// *****************************************************************************
// Section: Functions
// *****************************************************************************
// *****************************************************************************
static void app_timer_OneShotTimerExpiredHandle(TimerHandle_t xTimer)
{
    APP_TIMER_TmrElem_T *p_tmrId;
    APP_Msg_T appMsg;

    if (xTimer == NULL)
    {
        return;
    }
    p_tmrId = (APP_TIMER_TmrElem_T *)pvTimerGetTimerID(xTimer);

    if (p_tmrId != NULL)
    {
        switch (p_tmrId->tmrId)
        {
<#if APP_ANCS == true || APP_ANPC == true || APP_ANPS == true || APP_HOGP == true || APP_PXPR == true>
            case APP_TIMER_LED_01:
            {
                appMsg.msgId = APP_MSG_LED_TIMEOUT;
            }
            break;
</#if>
<#if APP_PXPR == true>
#ifdef PIC32BZ3
            case APP_TIMER_LED_IND_SWITCH_04:
            {
                appMsg.msgId = APP_MSG_LED_IND_SWITCH;
            }
             break;
#endif
</#if>
<#if APP_HOGP == true>
            case APP_TIMER_CONN_TIMEOUT_03:
            {
                appMsg.msgId = APP_MSG_CONN_TIMEOUT;
            }
            break;
</#if>

<#if APP_PXPM == true>
#ifdef PIC32BZ2
            case APP_TIMER_RSSI_MONI_03 :
            {
                appMsg.msgId = APP_MSG_RSSI_MONI_TIMEOUT;
            }
            break;
#elif defined(PIC32BZ3)
            case APP_TIMER_LED_01:
            {
                appMsg.msgId = APP_MSG_LED_TIMEOUT;
            }
            break;
#endif
</#if>

<#if APP_THROUGHPUT == true>
            case APP_TIMER_PROTOCOL_RSP_01:
            {
                appMsg.msgId = APP_MSG_PROTOCOL_RSP;
            }
            break;

            case APP_TIMER_FETCH_TRP_RX_DATA_02:
            {
                appMsg.msgId = APP_MSG_FETCH_TRP_RX_DATA;
            }
            break;

            case APP_TIMER_LED_04:
            {
                appMsg.msgId = APP_MSG_LED_TIMEOUT;
            }
            break;
</#if>

            default:
            break;
        }
        ((APP_TIMER_TmrElem_T *)appMsg.msgData)->tmrId = p_tmrId->tmrId;
        ((APP_TIMER_TmrElem_T *)appMsg.msgData)->instance = p_tmrId->instance;
        ((APP_TIMER_TmrElem_T *)appMsg.msgData)->tmrHandle = p_tmrId->tmrHandle;
        ((APP_TIMER_TmrElem_T *)appMsg.msgData)->p_tmrParam = p_tmrId->p_tmrParam;
        
        OSAL_QUEUE_Send(&appData.appQueue, &appMsg, 0);
    }
}

static void app_timer_PeriodicTimerExpiredHandle(TimerHandle_t xTimer)
{
    APP_TIMER_TmrElem_T *p_tmrId;
    APP_Msg_T appMsg;

    if (xTimer == NULL)
    {
        return;
    }
    p_tmrId = (APP_TIMER_TmrElem_T *)pvTimerGetTimerID(xTimer);

    if (p_tmrId != NULL)
    {
        switch (p_tmrId->tmrId)
        {
<#if APP_ANCS == true || APP_ANPC == true || APP_ANPS == true || APP_HOGP == true || APP_PXPM == true || APP_PXPR == true>
            case APP_TIMER_KEY_SCAN_02:
            {
                appMsg.msgId = APP_MSG_KEY_SCAN;
            }
            break;
</#if>

<#if APP_PXPM == true>
            case APP_TIMER_RSSI_MONI_03 :
            {
                appMsg.msgId = APP_MSG_RSSI_MONI_TIMEOUT;
            }
            break;
</#if>

<#if APP_PXPR == true>
            case APP_TIMER_LED_ALERT_03 :
            {
                appMsg.msgId = APP_MSG_ALERT_TOGGLE;
            }
            break;
</#if>

            default:
            break;
        }
        ((APP_TIMER_TmrElem_T *)appMsg.msgData)->tmrId = p_tmrId->tmrId;
        ((APP_TIMER_TmrElem_T *)appMsg.msgData)->instance = p_tmrId->instance;
        ((APP_TIMER_TmrElem_T *)appMsg.msgData)->tmrHandle = p_tmrId->tmrHandle;
        ((APP_TIMER_TmrElem_T *)appMsg.msgData)->p_tmrParam = p_tmrId->p_tmrParam;

         OSAL_QUEUE_Send(&appData.appQueue, &appMsg, 0);
    }
    //No need to free timer ID due to it's periodic timer
}

void APP_TIMER_SetTimerElem(uint8_t timerId, uint8_t instance, void *p_tmrParam, APP_TIMER_TmrElem_T *p_tmrElem)
{
    p_tmrElem->tmrId = timerId;
    p_tmrElem->instance= instance;
    p_tmrElem->p_tmrParam= p_tmrParam;
}

uint16_t APP_TIMER_SetTimer(APP_TIMER_TmrElem_T *p_timerId, uint32_t timeout, bool isPeriodicTimer)
{
    char timerName[12];
    uint8_t nameLen;

    if ((p_timerId == NULL) || (timeout == 0U))
    {
        return APP_RES_INVALID_PARA;
    }

    if (p_timerId->tmrHandle != NULL)
    {
        if (xTimerStop(p_timerId->tmrHandle, 0) != pdPASS)
        {
            return APP_RES_FAIL;
        }
        if (xTimerDelete(p_timerId->tmrHandle, 0) != pdPASS)
        {
            return APP_RES_FAIL;
        }
        p_timerId->tmrHandle = NULL;
    }

    nameLen = strlen(STR_APP_TIMER);
    if (sizeof(timerName) > nameLen)
    {
        //create the string of timer name: "APP_Timer3" when p_timerId->tmrId is 3
        (void)memcpy(timerName, STR_APP_TIMER, strlen(STR_APP_TIMER));
        timerName[nameLen] = (char)((uint8_t)'0' + p_timerId->tmrId);
        timerName[nameLen + 1U] = '\0';
    }
    else
    {
        return APP_RES_FAIL;
    }

    if (isPeriodicTimer)
    {
        p_timerId->tmrHandle = xTimerCreate(timerName, (timeout / portTICK_PERIOD_MS), pdTRUE, (void *)p_timerId, app_timer_PeriodicTimerExpiredHandle);
    }
    else
    {
        p_timerId->tmrHandle = xTimerCreate(timerName, (timeout / portTICK_PERIOD_MS), pdFALSE, (void *)p_timerId, app_timer_OneShotTimerExpiredHandle);
    }

    if (p_timerId->tmrHandle != NULL)
    {
        if (pdFAIL == xTimerStart(p_timerId->tmrHandle, 0))
        {
            return APP_RES_FAIL;
        }
        
        return APP_RES_SUCCESS;
    }

    return APP_RES_NO_RESOURCE;
}

uint16_t APP_TIMER_StopTimer(TimerHandle_t *timerHandler)
{
    if (*timerHandler == NULL)
    {
        return APP_RES_INVALID_PARA;
    }

    if (xTimerStop(*timerHandler, 0) != pdPASS)
    {
        return APP_RES_FAIL;
    }

    if (xTimerDelete(*timerHandler, 0) != pdPASS)
    {
        return APP_RES_FAIL;
    }
    *timerHandler = NULL;

    return APP_RES_SUCCESS;
}

uint16_t APP_TIMER_ResetTimer(TimerHandle_t timerHandler)
{
    if (timerHandler == NULL)
    {
        return APP_RES_INVALID_PARA;
    }

    if (xTimerReset(timerHandler, 0) != pdPASS)
    {
        return APP_RES_FAIL;
    }

    return APP_RES_SUCCESS;
}
</#if>
