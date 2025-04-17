/*******************************************************************************
* Copyright (C) 2022 Microchip Technology Inc. and its subsidiaries.
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
  Application BLE Profile Source File

  Company:
    Microchip Technology Inc.

  File Name:
    app_anpc_handler.c

  Summary:
    This file contains the Application BLE functions for this project.

  Description:
    This file contains the Application BLE functions for this project.
 *******************************************************************************/


// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************
#include <stdio.h>
#include "app_anpc_handler.h"
#include "definitions.h"
#include "../app_anpc_callbacks.h"

// *****************************************************************************
// *****************************************************************************
// Section: Global Variables
// *****************************************************************************
// *****************************************************************************

// *****************************************************************************
// *****************************************************************************
// Section: Functions
// *****************************************************************************
// *****************************************************************************

void APP_AnpcEvtHandler(BLE_ANPC_Event_T *p_event)
{

    switch(p_event->eventId)
    {
        case BLE_ANPC_EVT_DISC_COMPLETE_IND:
        {
            /* TODO: implement your application code.*/
            APP_WLS_ANPC_DiscoverySuccessfull(&(p_event->eventField.evtDiscComplete));
        }
        break;

        case BLE_ANPC_EVT_SUPP_NEW_ALERT_CAT_IND:
        {
            /* TODO: implement your application code.*/
            APP_WLS_ANPC_SupportNewCategoryReceived(&(p_event->eventField.evtSuppNewAlertCatInd));
        }
        break;

        case BLE_ANPC_EVT_SUPP_UNREAD_ALERT_STAT_CAT_IND:
        {
            /* TODO: implement your application code.*/
            APP_WLS_ANPC_UnreadAlertCategoryStatusIndication(&(p_event->eventField.evtSuppUnreadAlertCatInd));
        }
        break;

        case BLE_ANPC_EVT_WRITE_NEW_ALERT_NTFY_RSP_IND:
        {
            /* TODO: implement your application code.*/
            <#if booleanappcode ==  true>
            APP_ANPC_ConnList_T *p_conn = NULL;
            int retNum;
            char s_strBuf[256];
            if (p_event->eventField.evtWriteNewAlertRspInd.errCode == 0)
            {
                uint16_t connHandle = p_event->eventField.evtWriteNewAlertRspInd.connHandle;
                p_conn = APP_WLS_ANPC_GetConnListByHandle(connHandle);
                if (p_conn == NULL)
                { 
                    return;
                }
                if (p_conn->bCccdEnable == true)
                {
                    retNum = sprintf(s_strBuf,
                        "BLE_ANPC_EVT_WRITE_NEW_ALERT_NTFY_RSP_IND_ENABLE\n");
                    if (retNum > 0)
                    {
                          SYS_DEBUG_PRINT(SYS_ERROR_INFO,"%s\r\n",s_strBuf);;
                    }
                    p_conn->bNewAlertEnable = true;
                    APP_WLS_ANPC_EnableCccd(connHandle, true);
                }
                else
                {
                    retNum = sprintf(s_strBuf,
                        "BLE_ANPC_EVT_WRITE_NEW_ALERT_NTFY_RSP_IND_DISABLE\n");
                    if (retNum > 0)
                    {
                          SYS_DEBUG_PRINT(SYS_ERROR_INFO,"%s\r\n",s_strBuf);;
                    }
                    p_conn->bNewAlertEnable = false;
                    APP_WLS_ANPC_EnableCccd(connHandle, false);
                }
            }
            </#if>
        }
        break;

        case BLE_ANPC_EVT_WRITE_UNREAD_ALERT_NTFY_RSP_IND:
        {
            /* TODO: implement your application code.*/
            <#if booleanappcode ==  true>
            APP_ANPC_ConnList_T *p_conn = NULL;
            int retNum;
            char s_strBuf[256];
            p_conn = APP_WLS_ANPC_GetConnListByHandle(p_event->eventField.evtWriteUnreadAlertRspInd.connHandle);
            if (p_conn == NULL)
            { 
                return;
            }
            if (p_event->eventField.evtWriteUnreadAlertRspInd.errCode == 0)
            {
                if (p_conn->bCccdEnable == true)
                {
                    retNum = sprintf(s_strBuf,
                        "BLE_ANPC_EVT_WRITE_UNREAD_ALERT_NTFY_RSP_IND_ENABLE\n");
                    if (retNum > 0)
                    {
                         SYS_DEBUG_PRINT(SYS_ERROR_INFO,"%s\r\n",s_strBuf);
                    }
                    p_conn->bUnreadAlertEnable = true;
                }
                else
                {
                    retNum = sprintf(s_strBuf,
                        "BLE_ANPC_EVT_WRITE_UNREAD_ALERT_NTFY_RSP_IND_DISABLE\n");
                    if (retNum > 0)
                    {
                         SYS_DEBUG_PRINT(SYS_ERROR_INFO,"%s\r\n",s_strBuf);
                    }
                    p_conn->bUnreadAlertEnable = false;
                }
            }
            </#if>
        }
        break;

        case BLE_ANPC_EVT_WRITE_CP_RSP_IND:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case BLE_ANPC_EVT_NEW_ALERT_IND:
        {
            /* TODO: implement your application code.*/
            APP_WLS_ANPC_NewAlertReceived(&(p_event->eventField.evtNewAlertInd));
        }
        break;

        case BLE_ANPC_EVT_UNREAD_ALERT_STAT_IND:
        {
            /* TODO: implement your application code.*/
            APP_WLS_ANPC_UnreadAlertStatusReceived(&(p_event->eventField.evtUnreadAlertStatInd));
        }
        break;

        case BLE_ANPC_EVT_ERR_UNSPECIFIED_IND:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case BLE_ANPC_EVT_ERR_NO_MEM_IND:
        {
            /* TODO: implement your application code.*/
        }
        break;

        default:
        break;
    }
}

