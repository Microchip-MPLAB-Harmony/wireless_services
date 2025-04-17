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
    app_ancs_callbacks.h

  Summary:
    This header file provides prototypes and definitions for the application.

  Description:
    This header file provides function prototypes and data type definitions for
    the application.  Some of these are required by the system (such as the
    "APP_Initialize" and "APP_Tasks" prototypes) and some of them are only used
    internally by the application (such as the "APP_STATES" definition).  Both
    are defined here for convenience.
*******************************************************************************/
#include <stdio.h>
#include "ble_ancs/ble_ancs.h"
#include "definitions.h"
#include "ble_dm/ble_dm.h"
#include "app_ble_callbacks.h"
<#if booleanappcode ==  true>
<#if PROFILE_ANCS?? && PROFILE_ANCS.ANCS_BOOL_CLIENT == true>

typedef enum
{
    APP_ANCS_IND_INIT=0,
    APP_ANCS_IND_NTFY_ADDED,
    APP_ANCS_IND_NTFY_ATTR,
    APP_ANCS_IND_APP_ATTR,
    APP_ANCS_IND_NTFY_REMOVED,
} APP_ANCS_IND_STATES;

typedef struct APP_NotificationInfo_T{
    bool                        bNtfyAdded; //if receive Notification Added or not
    uint32_t                    ntfyId;     //Notification UID
    APP_ANCS_IND_STATES         state;
    BLE_ANCS_NtfyEvtFlagMask_T  ntfyEvtFlagMask;        /**< Bitmask to signal whether a special condition applies to the notification. For example, "Silent" or "Important". */
    BLE_ANCS_NtfyAttrsMask_T    ntfyAttrBitMask;
    uint8_t                     positiveAction[BLE_ANCS_MAX_POS_ACTION_LABEL_LEN]; /**< Valid if Positive Action is enabled. */
    uint8_t                     negativeAction[BLE_ANCS_MAX_NEG_ACTION_LABEL_LEN]; /**< Valid if Negative Action is enabled. */
    uint8_t                     appId[BLE_ANCS_MAX_APPID_LEN];
}APP_NotificationInfo_T;

extern APP_NotificationInfo_T g_NtfyInfo;

//static void APP_WLS_ANCS_RunAncsCmdbyState(void);
void APP_WLS_ANCS_KeyShortPress();
void APP_WLS_ANCS_KeyDoublePress();
void APP_WLS_ANCS_KeyLongPress();
</#if>
</#if>

void APP_WLS_ANCS_NotificationReceived(BLE_ANCS_EvtNtfyInd_T  *p_evtNtfyInd);
void APP_WLS_ANCS_NotificationModified(BLE_ANCS_EvtNtfyInd_T  *p_evtNtfyInd);
void APP_WLS_ANCS_NotificationRemoved(BLE_ANCS_EvtNtfyInd_T  *p_evtNtfyInd);
void APP_WLS_ANCS_NotificationDetailsReceived(BLE_ANCS_EvtNtfyAttrInd_T  *p_evtNtfyAttrInd);
void APP_WLS_ANCS_AppDetailsReceived(BLE_ANCS_EvtAppAttrInd_T  *p_evtAppAttrInd);
void APP_WLS_ANCS_ErrorIndication(BLE_ANCS_EvtErrInd_T   *p_evtErrInd);
