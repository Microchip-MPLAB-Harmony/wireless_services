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
    app_pxpm_callbacks.c

  Summary:
    This file contains API functions for the user to implement their business logic.

  Description:
    API functions for the user to implement his business logic.
*******************************************************************************/

#include "app_pxpm_callbacks.h"


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
<#if booleanappcode ==  true>
static APP_PXPM_ConnList_T s_appPxpmConnList[APP_PXPM_MAX_CONN_NBR];
// *****************************************************************************
// *****************************************************************************
// Section: Functions
// *****************************************************************************
// *****************************************************************************

APP_PXPM_ConnList_T *APP_WLS_PXPM_GetConnListByHandle(uint16_t connHandle)
{
    uint8_t i;
    for(i=0; i<APP_PXPM_MAX_CONN_NBR; i++)
    {
       if ((s_appPxpmConnList[i].connstatus == true) && (s_appPxpmConnList[i].connHandle == connHandle))
       { 
           return &s_appPxpmConnList[i];
       } 
    }
    return NULL;
}

APP_PXPM_ConnList_T *APP_WLS_PXPM_GetFreeConnList(void)
{
    uint8_t i;
    for(i=0; i<APP_PXPM_MAX_CONN_NBR; i++)
    {
    if (s_appPxpmConnList[i].connstatus == false)
       {
           s_appPxpmConnList[i].connIndex = i;
           s_appPxpmConnList[i].connstatus = true;
           return &s_appPxpmConnList[i];
       }
    }
    return NULL;
}

void APP_WLS_PXPM_RssiMonitorHandler(APP_TIMER_TmrElem_T *timerElem){  

    int8_t rssi =0 , link_budget = 0; 
    APP_PXPM_TxPower_T *monitor_handle = ((APP_PXPM_TxPower_T *)timerElem->p_tmrParam);
    if(MBA_RES_SUCCESS == BLE_GAP_GetRssi(monitor_handle->connhandle, &rssi))
    {
        link_budget = monitor_handle->tx_power - rssi ;
        APP_WLS_PXPM_RssiCheck(monitor_handle->connhandle,link_budget);
    }
}

void APP_WLS_PXPM_InitConnCharList(uint8_t connIndex)
{
    if(NULL ==memset((uint8_t *)&s_appPxpmConnList[connIndex], 0, sizeof(APP_PXPM_ConnList_T)))
    {
        return;
    }
 }

uint16_t APP_WLS_PXPM_SetPathLossReportingParams(BLE_GAP_PathLossReportingParams_T *params)
{

    uint16_t ret ;
    if(MBA_RES_SUCCESS == (ret = BLE_GAP_SetPathLossReportingParams(params)))
    {
        if(MBA_RES_SUCCESS == (ret = BLE_GAP_SetPathLossReportingEnable(params->connHandle,true)))
        {
        }
    }

    return ret;
}

void APP_WLS_PXPM_KeyLongPress()
{
    uint8_t i;
    switch (g_ctrlInfo.state)
            {
                case APP_DEVICE_STATE_CONNECTED:
                {
                    g_ctrlInfo.bAllowNewPairing=true;
                    for(i=0U; i<APP_PXPM_MAX_CONN_NBR; i++)
                    {
                        if (s_appPxpmConnList[i].connstatus == true)
                        {
                            BLE_GAP_Disconnect(s_appPxpmConnList[i].connHandle, GAP_DISC_REASON_REMOTE_TERMINATE);
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
                {
                }
                break;
            }
}
void APP_WLS_PXPM_BackupService(reissue func,uint16_t connHandle,BLE_PXPM_AlertLevel_T level)
{

    if(connHandle) {
        s_pxpmReissue.reissue = func;
        s_pxpmReissue.alert_level = level;
        s_pxpmReissue.connHandle = connHandle;
    }

}
void APP_WLS_PXPM_ReissueService(void)
{
    if(s_pxpmReissue.connHandle && NULL != s_pxpmReissue.reissue)
    {
        s_pxpmReissue.reissue(s_pxpmReissue.connHandle,s_pxpmReissue.alert_level);
        s_pxpmReissue.reissue = NULL;
        s_pxpmReissue.connHandle = 0x0;
    }
}

void APP_WLS_PXPM_Recovery(void)
{
#ifdef PIC32BZ2   
    APP_WLS_RGB_RED_Off();
    APP_WLS_RGB_GREEN_Off();
#endif
    APP_TIMER_StopTimer(&s_pxpmPathLossTmr.tmrHandle);
} 



void APP_WLS_PXPM_RssiCheck(uint16_t connHandle,uint8_t link_budget)
{
    APP_PXPM_ConnList_T *connlist = APP_WLS_PXPM_GetConnListByHandle(connHandle);

    switch(connlist->connIasLevel)
    {
        case BLE_PXPM_ALERT_LEVEL_MILD:
#ifdef PIC32BZ3
        {
           if(link_budget <= TH_MID_ALERT)
            {
                connlist->connIasLevel = BLE_PXPM_ALERT_LEVEL_NO;
                BLE_PXPM_WriteIasAlertLevel(connHandle,connlist->connIasLevel);
            }
            else if(link_budget > TH_HIGH_ALERT)
            {
                connlist->connIasLevel = BLE_PXPM_ALERT_LEVEL_HIGH;
                BLE_PXPM_WriteIasAlertLevel(connHandle,connlist->connIasLevel);
            } 
          
        }
        break;
 #endif        
        case BLE_PXPM_ALERT_LEVEL_HIGH:
        {
#ifdef PIC32BZ2
            if(link_budget <= TH_MID_ALERT - LOW_HYSTERESIS)
            {
                connlist->connIasLevel = BLE_PXPM_ALERT_LEVEL_NO;
                BLE_PXPM_WriteIasAlertLevel(connHandle,connlist->connIasLevel);
                APP_WLS_RGB_RED_Off();
                APP_WLS_RGB_GREEN_On();
            }
#elif defined(PIC32BZ3)
            if(link_budget <= TH_HIGH_ALERT)
            {
                connlist->connIasLevel = BLE_PXPM_ALERT_LEVEL_MILD;
                BLE_PXPM_WriteIasAlertLevel(connHandle,connlist->connIasLevel);
            }
#endif
        }
        break;
        case BLE_PXPM_ALERT_LEVEL_NO:
        {
#ifdef PIC32BZ2
            if(link_budget > TH_MID_ALERT + LOW_HYSTERESIS)
            {
                connlist->connIasLevel = (link_budget >= TH_HIGH_ALERT + HIGH_HYSTERESIS) ?
                                                                    BLE_PXPM_ALERT_LEVEL_HIGH : BLE_PXPM_ALERT_LEVEL_MILD;
                BLE_PXPM_WriteIasAlertLevel(connHandle,connlist->connIasLevel);
                APP_WLS_RGB_RED_On();
                APP_WLS_RGB_GREEN_Off();
            }
#elif defined(PIC32BZ3)
            if(link_budget > TH_MID_ALERT)
            {
                connlist->connIasLevel = BLE_PXPM_ALERT_LEVEL_MILD;
                BLE_PXPM_WriteIasAlertLevel(connHandle,connlist->connIasLevel);
            }
#endif           
        }
        break;
        default:
        {
            connlist->connIasLevel = BLE_PXPM_ALERT_LEVEL_NO;
        }
        break;
    }
}


static uint16_t APP_WLS_PXPM_SetTimer(uint16_t idInstance, void *p_tmrParam, uint32_t timeout, bool isPeriodicTimer,
APP_TIMER_TmrElem_T *p_tmrElem)
{
    uint8_t tmrId;
    uint16_t result;

    tmrId = (uint8_t)(idInstance >> 8);
    APP_TIMER_SetTimerElem(tmrId, (uint8_t)idInstance, (void *)p_tmrParam, p_tmrElem);
    result = APP_TIMER_SetTimer(p_tmrElem, timeout, isPeriodicTimer);
    return result;

}

</#if>
/*******************************************************************************
  Function:
    void APP_WLS_PXPM_DiscoveryCompleted(BLE_PXPM_EvtDiscComplete_T *evtDiscComplete)
  Summary:
     Function for handling PXPM Dicovery completed indication .

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/

void APP_WLS_PXPM_DiscoveryCompleted(BLE_PXPM_EvtDiscComplete_T *p_evtDiscComplete)
{
<#if booleanappcode ==  true>
<#if PROFILE_PXP?? &&  PROFILE_PXP.PXP_BOOL_CLIENT == true>
  
    uint16_t connHdl = p_evtDiscComplete->connHandle;
    APP_PXPM_ConnList_T *connlist = APP_WLS_PXPM_GetConnListByHandle(connHdl);
    connlist->connTxPwr = 0U;

    if(NULL == memset(&s_monitorHandle , 0U, sizeof(APP_PXPM_TxPower_T)))
    {
        return ;
    }
    if(NULL == memset(&s_pxpmPathLossTmr , 0U, sizeof(APP_TIMER_TmrElem_T)))
    {
        return ;
    }
#ifdef PIC32BZ2
    APP_WLS_RGB_RED_Off();
    APP_WLS_RGB_GREEN_Off();
#endif
    APP_WLS_PXPM_BackupService(BLE_PXPM_WriteLlsAlertLevel,connHdl,BLE_PXPM_ALERT_LEVEL_HIGH);
    BLE_PXPM_WriteLlsAlertLevel(connHdl,BLE_PXPM_ALERT_LEVEL_HIGH);

</#if>
</#if>
}

/*******************************************************************************
  Function:
    void APP_WLS_PXPM_LLSAlertLevelWriteResponseIndication(BLE_PXPM_EvtLlsAlertLvInd_T *p_evtLlsAlertLvInd)
  Summary:
     Function for handling PXPM Link Loss Service Write response indication.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_WLS_PXPM_LLSAlertLevelWriteResponseIndication(BLE_PXPM_EvtLlsAlertLvInd_T *p_evtLlsAlertLvInd)
{
<#if booleanappcode ==  true>
#ifdef PIC32BZ2 
    APP_WLS_RGB_RED_Off();
    APP_WLS_RGB_GREEN_Off();
#endif
#ifdef APP_PWR_CTRL_ENABLE
    uint16_t connHdl = evtLlsAlertLvInd->connHandle;
    APP_PXPM_ConnList_T *connlist = APP_WLS_PXPM_GetConnListByHandle(connHdl);
    BLE_GAP_PathLossReportingParams_T params;
    params.connHandle =  p_event->eventField.evtLlsAlertLvInd.connHandle/* Set the connection handle */;
    params.highThreshold = PWR_CTRL_TH_HIGH /* Set the high threshold */;
    params.highHysteresis = HIGH_HYSTERESIS/* Set the high hysteresis */;
    params.lowThreshold = PWR_CTRL_TH_MILD/* Set the low threshold */;
    params.lowHysteresis = LOW_HYSTERESIS/* Set the low hysteresis */;
    params.minTimeSpent = 1/* Set the minimum time spent */; 
    if (MBA_RES_SUCCESS != APP_WLS_PXPM_SetPathLossReportingParams(&params) && !connlist->connTxPwr)
#endif
    {
        BLE_PXPM_ReadTpsTxPowerLevel(p_evtLlsAlertLvInd->connHandle);
    }
</#if>
}

/*******************************************************************************
  Function:
    void APP_WLS_PXPM_TPSTransmitPowerLevelIndication(BLE_PXPM_EvtTpsTxPwrLvInd_T   *p_evtTpsTxPwrLvInd)
  Summary:
     Function for handling PXPM Transmit Power Service Power level Indcation event from peer device

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_WLS_PXPM_TPSTransmitPowerLevelIndication(BLE_PXPM_EvtTpsTxPwrLvInd_T   *p_evtTpsTxPwrLvInd)
{
<#if booleanappcode ==  true>
#ifdef PIC32BZ2
    APP_WLS_RGB_RED_Off();
    APP_WLS_RGB_GREEN_On();
#endif
    uint16_t connHdl = p_evtTpsTxPwrLvInd->connHandle;
    APP_PXPM_ConnList_T *connlist = APP_WLS_PXPM_GetConnListByHandle(connHdl);
    connlist->connTxPwr = p_evtTpsTxPwrLvInd->txPowerLevel;

    if(connlist->connTxPwr == 0U)
    {
#ifdef PIC32BZ2
        APP_WLS_RGB_GREEN_Off();
#endif
        return ;
    }

    s_monitorHandle = (APP_PXPM_TxPower_T){.connhandle = connHdl,
                                        .tx_power = p_evtTpsTxPwrLvInd->txPowerLevel};

    if(APP_RES_SUCCESS != APP_WLS_PXPM_SetTimer(APP_PXPM_TMR_ID_INST_MERGE(APP_TIMER_RSSI_MONI_03, 0U), &s_monitorHandle, APP_TIMER_1S, true, &s_pxpmPathLossTmr))
    {
        return ; 
    }
</#if>
}

/*******************************************************************************
  Function:
    void APP_WLS_PXPM_ErrorUnspecifiedIndication(BLE_PXPM_Event_T *p_event)
  Summary:
     Function for handling PXPM unspecified error

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_WLS_PXPM_ErrorUnspecifiedIndication(BLE_PXPM_Event_T *p_event)
{
<#if booleanappcode ==  true>   
#ifdef PIC32BZ2
    APP_WLS_RGB_RED_Off();
    APP_WLS_RGB_GREEN_Off();
#endif
    uint16_t connHdl = p_event->eventField.evtTpsTxPwrLvInd.connHandle;
    APP_PXPM_ConnList_T *connlist = APP_WLS_PXPM_GetConnListByHandle(connHdl);
    if(connlist->connTxPwr != 0U)
    {
     APP_TIMER_StopTimer(&s_pxpmPathLossTmr.tmrHandle);
    }
</#if>
}



