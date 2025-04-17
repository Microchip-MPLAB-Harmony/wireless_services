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
    app_pxpm_callbacks.h

  Summary:
    This file contains API functions for the user to implement their business logic.

  Description:
    API functions for the user to implement his business logic.
*******************************************************************************/
#ifndef APP_PXPM_CALLBACKS_H
#define	APP_PXPM_CALLBACKS_H

#include "bsp/bsp.h"
#include "ble_pxpm/ble_pxpm.h"
<#if booleanappcode ==  true>
#include "app_timer.h"
#include "app_error_defs.h"
#include "app_key.h"
#include "app_led.h"
#include "app_ble_callbacks.h"

#define APP_PXPM_MAX_CONN_NBR    BLE_GAP_MAX_LINK_NBR    /**< Maximum allowing Conncetion Numbers for MBADK. */
/* For PXPR, calculating the link budget value as a standard for path loss assessment, especially in cases where power control is not supported. */
typedef struct APP_PXPM_TxPower_T{
    int8_t tx_power;     /**< The pxpr tx power status, which is read from PXPR via the TPS service. */
    uint16_t connhandle; /**< The PXPR connect handle, which is used to monitor the Received Signal Strength Indicator (RSSI) of PXPR for link budget calculation.*/
} APP_PXPM_TxPower_T;

typedef struct APP_PXPM_ConnList_T
{
    uint16_t                          connHandle;
    uint8_t                           connIndex;
    bool                              connstatus;
    uint8_t                           connTxPwr;
    BLE_PXPM_AlertLevel_T             connIasLevel;
    bool                              bSecurityStatus;
} APP_PXPM_ConnList_T;

#ifdef PIC32BZ2
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
#endif
//#define APP_PWR_CTRL_ENABLE 
#define APP_PXPM_ENABLE
#define BLE_PXPM_EVT_NUM  (0x5U)
#define APP_PXPM_TMR_ID_INST_MERGE(id, instance) ((((uint16_t)(id)) << 8) | (uint16_t)(instance))
#define TH_MID_ALERT                    ((uint8_t)0x48) //  75db
#define TH_HIGH_ALERT                   ((uint8_t)0x5F) //  95db
#define PWR_CTRL_TH_HIGH                ((uint8_t)0x50) //  80db
#define PWR_CTRL_TH_MILD                ((uint8_t)0x3C) //  60db

#ifdef __HPA__
#define HIGH_HYSTERESIS                 ((uint8_t)0x3)
#define LOW_HYSTERESIS                  ((uint8_t)0x3)
#else
#define HIGH_HYSTERESIS                 ((uint8_t)0x4)
#define LOW_HYSTERESIS                  ((uint8_t)0x4)
#endif

static APP_PXPM_TxPower_T s_monitorHandle ;
static APP_TIMER_TmrElem_T s_pxpmPathLossTmr;        /**< Key scan timer of 50 ms unit. */

typedef uint16_t (*reissue)(uint16_t , BLE_PXPM_AlertLevel_T);

typedef struct APP_PXPM_Reissue_T
{
    reissue                 reissue; 
    uint16_t                connHandle;
    BLE_PXPM_AlertLevel_T   alert_level;
}APP_PXPM_Reissue_T ;

static APP_PXPM_Reissue_T s_pxpmReissue = {
    .reissue = NULL , 
};

APP_PXPM_ConnList_T *APP_WLS_PXPM_GetConnListByHandle(uint16_t connHandle);
APP_PXPM_ConnList_T *APP_WLS_PXPM_GetFreeConnList(void);
void APP_WLS_PXPM_RssiMonitorHandler(APP_TIMER_TmrElem_T *timerElem);
void APP_WLS_PXPM_InitConnCharList(uint8_t connIndex);
uint16_t APP_WLS_PXPM_SetPathLossReportingParams(BLE_GAP_PathLossReportingParams_T *params);
void APP_WLS_PXPM_KeyLongPress();
void APP_WLS_PXPM_Recovery(void);
void APP_WLS_PXPM_RssiCheck(uint16_t connHandle,uint8_t link_budget);
void APP_WLS_PXPM_BackupService(reissue func,uint16_t connHandle,BLE_PXPM_AlertLevel_T level);
void APP_WLS_PXPM_ReissueService(void);
void APP_WLS_BLE_SetResolvingList(bool isSet);
</#if>
void APP_WLS_PXPM_DiscoveryCompleted(BLE_PXPM_EvtDiscComplete_T *p_evtDiscComplete);
void APP_WLS_PXPM_LLSAlertLevelWriteResponseIndication(BLE_PXPM_EvtLlsAlertLvInd_T *p_evtLlsAlertLvInd);
void APP_WLS_PXPM_TPSTransmitPowerLevelIndication(BLE_PXPM_EvtTpsTxPwrLvInd_T   *p_evtTpsTxPwrLvInd);
void APP_WLS_PXPM_ErrorUnspecifiedIndication(BLE_PXPM_Event_T *p_event);

#endif