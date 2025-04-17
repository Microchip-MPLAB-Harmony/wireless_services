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
    app_ancs_handler.c

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
#include "app_ancs_handler.h"
#include "ble_dm/ble_dm.h"
#include "app_ancs_callbacks.h"
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
void APP_AncsEvtHandler(BLE_ANCS_Event_T *p_event)
{
    switch(p_event->eventId)
    {
        case BLE_ANCS_EVT_DISC_COMPLETE_IND:
        {
            /* TODO: implement your application code.*/
            g_GattClientInfo.bDiscoveryDone= true;
        }
        break;

        case BLE_ANCS_EVT_ERR_ATTR_BUF_IND:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case BLE_ANCS_EVT_ERR_RECOMPOSE_BUF_IND:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case BLE_ANCS_EVT_NTFY_ADDED_IND:
        {
            /* TODO: implement your application code.*/
            APP_WLS_ANCS_NotificationReceived(&(p_event->eventField.evtNtfyInd));

        } 
        break;

        case BLE_ANCS_EVT_NTFY_MODIFIED_IND:  
        {
            /* TODO: implement your application code.*/
             APP_WLS_ANCS_NotificationModified(&(p_event->eventField.evtNtfyInd));
        }
        break;

        case BLE_ANCS_EVT_NTFY_REMOVED_IND:  
        {
            /* TODO: implement your application code.*/
            APP_WLS_ANCS_NotificationRemoved(&(p_event->eventField.evtNtfyInd));
        }
        break;

        case BLE_ANCS_EVT_NTFY_ATTR_IND:
        {
            /* TODO: implement your application code.*/
            APP_WLS_ANCS_NotificationDetailsReceived(&(p_event->eventField.evtNtfyAttrInd));
        }
        break;

        case BLE_ANCS_EVT_APP_ATTR_IND:
        {
            /* TODO: implement your application code.*/
            APP_WLS_ANCS_AppDetailsReceived(&(p_event->eventField.evtAppAttrInd));
        }
        break;

        case BLE_ANCS_EVT_ERR_UNSPECIFIED_IND:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case BLE_ANCS_EVT_ERR_NO_MEM_IND:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case BLE_ANCS_EVT_ERR_IND:
        {
            /* TODO: implement your application code.*/
            APP_WLS_ANCS_ErrorIndication(&(p_event->eventField.evtErrInd));
        }
        break;

        default:
        break;
    }
}


