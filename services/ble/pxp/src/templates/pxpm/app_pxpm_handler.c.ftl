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
    app_pxpm_handler.c

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
#include "app_pxpm_handler.h"
#include "app_pxpm_callbacks.h"





void APP_PxpmEvtHandler(BLE_PXPM_Event_T *p_event)
{
    switch(p_event->eventId)
    {
        case BLE_PXPM_EVT_DISC_COMPLETE_IND:
        {           
            /* TODO: implement your application code.*/
            APP_WLS_PXPM_DiscoveryCompleted(&p_event->eventField.evtDiscComplete);
        }
        break;
        
        case BLE_PXPM_EVT_LLS_ALERT_LEVEL_WRITE_RSP_IND:
        {
            /* TODO: implement your application code.*/
            APP_WLS_PXPM_LLSAlertLevelWriteResponseIndication(&p_event->eventField.evtLlsAlertLvInd);
        }
        break;
   
        case BLE_PXPM_EVT_TPS_TX_POWER_LEVEL_IND:
        {
             /* TODO: implement your application code.*/
            APP_WLS_PXPM_TPSTransmitPowerLevelIndication(&p_event->eventField.evtTpsTxPwrLvInd);
        }
        break;

        case BLE_PXPM_EVT_ERR_UNSPECIFIED_IND:
        {
            /* TODO: implement your application code.*/
            APP_WLS_PXPM_ErrorUnspecifiedIndication(p_event);
        }
        break;
        default:
        {
        }
        break;
    }

}
