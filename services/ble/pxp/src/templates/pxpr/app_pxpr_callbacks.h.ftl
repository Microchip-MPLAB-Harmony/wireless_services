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
    app_pxpr_callbacks.h

  Summary:
    This file contains API functions for the user to implement their business logic.

  Description:
    API functions for the user to implement his business logic.
*******************************************************************************/
#ifndef APP_PXPR_CALLBACKS_H
#define APP_PXPR_CALLBACKS_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

<#if booleanappcode ==  true>
<#if PROFILE_PXP?? &&  PROFILE_PXP.PXP_BOOL_SERVER == true>    
#include "bsp/bsp.h"
#include "app_timer.h"
#include "app_error_defs.h"


#define APP_PXPR_TMR_ID_INST_MERGE(id, instance) ((((uint16_t)(id)) << 8) | (uint16_t)(instance))
#define APP_PXPR_MAX_CONN_NBR       (0x01U)    /**< Maximum allowing Conncetion Numbers for MBADK. */

typedef struct APP_PXPR_ConnList_T
{
    uint16_t                connHandle;
    uint8_t                 connIndex;
    bool                    connStatus;
    int               connTxp;
    BLE_PXPR_AlertLevel_T currAlert;
    BLE_PXPR_AlertLevel_T llsAlert;
} APP_PXPR_ConnList_T;

void APP_WLS_PXPR_KeyLongPress();
void APP_WLS_PXPR_Init(void);
APP_PXPR_ConnList_T *APP_WLS_PXPR_GetConnListByHandle(uint16_t connHandle);
APP_PXPR_ConnList_T *APP_WLS_PXPR_GetFreeConnList(void);
void APP_WLS_PXPR_InitConnCharList(uint8_t connIndex);
void APP_WLS_PXPR_Connected(void);
void APP_WLS_PXPR_Linkloss(uint16_t connHandle);
void APP_WLS_PXPR_connStateLedRestore(void);
</#if>
</#if>  

void APP_WLS_PXPR_LLSAlertLevelWriteResponseIndication(BLE_PXPR_EvtAlertLevelWriteInd_T    *p_evtLlsAlertLevelWriteInd);
void APP_WLS_PXPR_IASLevelIndication(BLE_PXPR_EvtAlertLevelWriteInd_T    *p_evtLlsAlertLevelWriteInd);
void APP_WLS_PXPR_ErrorUnspecifiedIndication(BLE_PXPR_Event_T *p_event);
#endif