// DOM-IGNORE-BEGIN
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
// DOM-IGNORE-END

/*******************************************************************************
  MPLAB Harmony Application Header File

  Company:
    Microchip Technology Inc.

  File Name:
    app_anps_callbacks.c

  Summary:
    This file contains API functions for the users to implement their business logic.

  Description:
    API functions for the user to implement his business logic.
*******************************************************************************/

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

#include "app_ble_callbacks.h"
#include "handlers/app_anps_handler.h"
#include "app_anps_callbacks.h"

// *****************************************************************************
// *****************************************************************************
// Section: Macros
// *****************************************************************************
// *****************************************************************************

// *****************************************************************************
// *****************************************************************************
// Section: Data Types
// *****************************************************************************
// *****************************************************************************

// *****************************************************************************
// *****************************************************************************
// Section: Global Variables
// *****************************************************************************
// *****************************************************************************

// *****************************************************************************
// *****************************************************************************
// Section: Local Variables
// *****************************************************************************
// *****************************************************************************
<#if booleanappcode ==  true>
static APP_ANPS_ConnList_T     s_appAnpsConnList[APP_DEVICE_MAX_CONN_NBR];
</#if>
// *****************************************************************************
// *****************************************************************************
// Section: Function Prototypes
// *****************************************************************************
// *****************************************************************************

// *****************************************************************************
// *****************************************************************************
// Section: Functions
// *****************************************************************************
// *****************************************************************************
void APP_WLS_ANPS_AncpWriteIndication(BLE_ANPS_Event_T *p_event)
{

}

<#if booleanappcode ==  true>
static void APP_WLS_ANPS_RunCmdbyState(uint16_t connHandle)
{
    APP_ANPS_ConnList_T *p_conn = NULL;
    p_conn = APP_WLS_ANPS_GetConnListByHandle(connHandle);
    if (p_conn == NULL)
    { 
        return;
    }
    switch (p_conn->ntfyInfo)
    {
        case APP_ANPS_NTFY_NEW_ALERT:
        {
            uint8_t catId = BLE_ANPS_CAT_ID_SIMPLE_ALERT;
            uint8_t num = 2;
            const uint8_t txtStr[12] = "Mark.Smith";
            uint16_t txtStrLen = sizeof(txtStr);

            BLE_ANPS_SendNewAlert(connHandle, catId, num, txtStrLen, txtStr);
            p_conn->ntfyInfo = APP_ANPS_NTFY_UNREAD_ALERT;
        }
        break;
        case APP_ANPS_NTFY_UNREAD_ALERT:
        {
            uint8_t catId = BLE_ANPS_CAT_ID_SIMPLE_ALERT;
            uint8_t unreadCnt = 3;

            BLE_ANPS_SendUnreadAlertStat(connHandle, catId, unreadCnt);
             p_conn->ntfyInfo = APP_ANPS_NTFY_NEW_ALERT;
        }
        break;
        default:
        {
        }
        break;
    }
}

void APP_WLS_ANPS_InitConnList(uint8_t connIndex)
{
    (void)memset((uint8_t *)&s_appAnpsConnList[connIndex], 0, sizeof(APP_ANPS_ConnList_T));
}

APP_ANPS_ConnList_T *APP_WLS_ANPS_GetConnListByHandle(uint16_t connHandle)
{
    uint8_t i;

    for(i=0U; i<APP_DEVICE_MAX_CONN_NBR; i++)
    {
        if ((s_appAnpsConnList[i].bConnStatus == true) && (s_appAnpsConnList[i].connHandle == connHandle))
        {
            return &s_appAnpsConnList[i];
        }
    }
    return NULL;
}

APP_ANPS_ConnList_T *APP_WLS_ANPS_GetFreeConnList(void)
{
    uint8_t i;

    for(i=0U; i<APP_DEVICE_MAX_CONN_NBR; i++)
    {
        if (s_appAnpsConnList[i].bConnStatus == false)
        {
            s_appAnpsConnList[i].bConnStatus = true;
            s_appAnpsConnList[i].connIndex = i;
            return &s_appAnpsConnList[i];
        }
    }
    return NULL;
}

void APP_WLS_ANPS_KeyShortPress(void)
{
    uint8_t i = 0U;
    GPIO_PinToggle(GPIO_PIN_RB7);

    if (g_ctrlInfo.state == APP_DEVICE_STATE_CONNECTED)
    {
        for(i=0U; i<APP_DEVICE_MAX_CONN_NBR; i++)
        {
            if (s_appAnpsConnList[i].bConnStatus == true)
            {
                APP_WLS_ANPS_RunCmdbyState(s_appAnpsConnList[i].connHandle);
            }
        }
    }
}

void APP_WLS_ANPS_KeyLongPress(void)
{
    switch (g_ctrlInfo.state)
    {
        case APP_DEVICE_STATE_CONNECTED:
        {
            g_ctrlInfo.bAllowNewPairing=true;
            for(uint8_t i=0U; i<APP_DEVICE_MAX_CONN_NBR; i++)
            {
                if (s_appAnpsConnList[i].bConnStatus == true)
                {
                    BLE_GAP_Disconnect(s_appAnpsConnList[i].connHandle, GAP_DISC_REASON_REMOTE_TERMINATE);
                }
            }
        }
        break;

        case APP_DEVICE_STATE_WITH_BOND_SCAN:
        {
            uint16_t ret;
            //Start for new pairing
            ret  = APP_WLS_BLE_ScanEnable(APP_DEVICE_STATE_IDLE);
            if (ret != MBA_RES_SUCCESS)
            {}
            //Clear filter accept list
            APP_WLS_BLE_SetFilterAcceptList(false);
            //Clear resolving list
            ret = APP_WLS_BLE_ScanEnable(APP_DEVICE_STATE_SCAN);
            if (ret != MBA_RES_SUCCESS)
            {}
        }
        break;

        default:
        break;
    }
}
</#if>




