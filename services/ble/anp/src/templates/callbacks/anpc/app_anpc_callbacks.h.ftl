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
  MPLAB Harmony Application Header File

  Company:
    Microchip Technology Inc.

  File Name:
    app_anpc_callbacks.h

  Summary:
    This header file provides prototypes and definitions for the application.

  Description:
    This header file provides function prototypes and data type definitions for
    the application.  Some of these are required by the system (such as the
    "APP_Initialize" and "APP_Tasks" prototypes) and some of them are only used
    internally by the application (such as the "APP_STATES" definition).  Both
    are defined here for convenience.
*******************************************************************************/

#ifndef APP_ANPC_CALLBACKS_H
#define APP_ANPC_CALLBACKS_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************
#include <stdio.h>
#include "ble_anpc/ble_anpc.h"
#include "app_anpc_callbacks.h"
#include "definitions.h"

// *****************************************************************************
// *****************************************************************************
// Section: Data Types
// *****************************************************************************
<#if booleanappcode ==  true>
typedef struct APP_ANPC_ConnList_T
{
    bool              bConnStatus;
    bool              bCccdEnable;
    bool              bDiscovered;
    bool              bNewAlertEnable;
    bool              bUnreadAlertEnable;
    bool              bEnableCccdRetry;
    uint8_t           connIndex;
    uint16_t          connHandle;
} APP_ANPC_ConnList_T;
</#if>


void APP_WLS_ANPC_DiscoverySuccessfull(BLE_ANPC_EvtDiscComplete_T *p_evtDiscComplete);
void APP_WLS_ANPC_SupportNewCategoryReceived(BLE_ANPC_EvtSuppNewAlertCatInd_T *p_evtSuppNewAlertCatInd);
void APP_WLS_ANPC_UnreadAlertCategoryStatusIndication(BLE_ANPC_EvtSuppUnreadAlertCatInd_T  *p_evtSuppUnreadAlertCatInd);
void APP_WLS_ANPC_NewAlertReceived(BLE_ANPC_EvtNewAlertInd_T  *p_evtNewAlertInd);
void APP_WLS_ANPC_UnreadAlertStatusReceived(BLE_ANPC_EvtUnreadAlertStatInd_T  *p_evtUnreadAlertStatInd);
<#if booleanappcode ==  true>
void APP_WLS_ANPC_InitConnList(uint8_t connIndex);
APP_ANPC_ConnList_T *APP_WLS_ANPC_GetConnListByHandle(uint16_t connHandle);
APP_ANPC_ConnList_T *APP_WLS_ANPC_GetFreeConnList(void);
APP_ANPC_ConnList_T *APP_WLS_ANPC_GetFreeConnList(void);
void APP_WLS_ANPC_EnableCccd(uint16_t connHandle, bool enable);
void APP_WLS_ANPC_KeyShortPress(void);
void APP_WLS_ANPC_KeyLongPress(void);
</#if>

/*******************************************************************************
 End of File
 */

#endif /* APP_ANPC_CALLBACKS_H */