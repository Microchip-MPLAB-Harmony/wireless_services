<#assign APP_THROUGHPUT = false>
<#if wlsbleconfig?? &&  wlsbleconfig.WLS_BLE_GAP_PERIPHERAL == true && 
    wlsbleconfig.WLS_BLE_GAP_ADVERTISING == true && 
    SS_TRSP_BOOL_SERVER == true && 
    wlsbleconfig.WLS_BLE_BOOL_GAP_EXT_ADV == false && 
    wlsbleconfig.WLS_BLE_GAP_DSADV_EN == false && 
    wlsbleconfig.WLS_BLE_BOOL_L2CAP_CREDIT_FLOWCTRL == true> 
<#assign APP_THROUGHPUT = true>
</#if>
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
    app_trsps_callbacks.h

  Summary:
    This file contains API functions for the user to implement his business logic.

  Description:
    API functions for the user to implement his business logic.
*******************************************************************************/
#ifndef APP_TRSPS_CALLBACKS_H
#define	APP_TRSPS_CALLBACKS_H

#ifdef	__cplusplus
extern "C" {
#endif
#include <string.h>
#include "definitions.h" 
<#if APP_THROUGHPUT == true>
#include "app.h"
#include "ble_util/byte_stream.h"
#include "stack_mgr.h"

#include "app_trp_common.h"
#include "app_timer.h"
#include "app_ble.h"

#include "app_led.h"

#include "app_error_defs.h"
#include "system/console/sys_console.h"
#include "ble_dm/ble_dm.h"

extern APP_TRP_ConnList_T s_trpsConnList_t;

void APP_WLS_TRPS_Init(void);
void APP_WLS_TRPS_ConnEvtProc(BLE_GAP_EvtConnect_T  *p_evtConnect);
void APP_WLS_TRPS_DiscEvtProc(uint16_t connHandle);
uint16_t APP_WLS_TRPS_GetDataParam(APP_TRP_ConnList_T *p_connList_t,uint16_t *dataLen,uint8_t *p_data);
void APP_WLS_TRPS_ProcessData(APP_TRP_ConnList_T *p_connList_t,uint16_t dataLen,uint8_t *pdata);
uint16_t APP_WLS_TRPS_SendLeDataCircQueue(APP_TRP_ConnList_T *p_connList_t,uint16_t dataLen,uint8_t *p_rxData);
uint32_t APP_WLS_TRPS_CalculateCheckSum(uint32_t checkSum, uint32_t *totalDataLeng, APP_TRP_ConnList_T *p_connList_t, uint16_t dataLen,uint8_t *p_rxData);
void APP_WLS_TRPS_UpdateMtuEvtProc(uint16_t connHandle, uint16_t exchangedMTU);
uint32_t APP_WLS_TRPS_CalculateCheckSum(uint32_t checkSum, uint32_t *totalDataLeng, APP_TRP_ConnList_T *p_connList_t, uint16_t dataLen,uint8_t *p_rxData);
void APP_WLS_TRPS_VendorCmdProc(APP_TRP_ConnList_T *p_connList_t, uint8_t *p_cmd);
void APP_WLS_TRPS_SendUpConnParaStatusToClient(uint16_t connHandle, uint8_t upConnParaStatus);
void APP_WLS_TRPS_TxBufValidEvtProc(void);
</#if>

void APP_WLS_TRPS_DataReceived(uint16_t connHandle, uint16_t dataLen, uint8_t *p_data);

#ifdef	__cplusplus
}
#endif

#endif