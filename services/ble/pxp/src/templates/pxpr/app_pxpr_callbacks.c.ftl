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
    app_pxpr_callbacks.c

  Summary:
    This file contains API functions for the user to implement their business logic.

  Description:
    API functions for the user to implement his business logic.
*******************************************************************************/
#include "app_ble.h"
#include "app_ble_callbacks.h"
#include "app_pxpr_callbacks.h"


// *****************************************************************************
// *****************************************************************************
// Section: Global Variables
// *****************************************************************************
// *****************************************************************************
<#if booleanappcode ==  true>
<#if PROFILE_PXP?? &&  PROFILE_PXP.PXP_BOOL_SERVER == true>
#ifdef PIC32BZ3
#define BLE_PXPR_ALERT_DURATION_TYPE  0x3U
static APP_TIMER_TmrElem_T  s_alertDurationTmr;
#endif
static APP_TIMER_TmrElem_T  s_pathLedAlertTmr;
static struct APP_PXPR_ConnList_T  s_appPxprConnList[APP_PXPR_MAX_CONN_NBR];

// *****************************************************************************
// *****************************************************************************
// Section: Functions
// *****************************************************************************
// *****************************************************************************

void APP_WLS_PXPR_InitConnCharList(uint8_t connIndex)
{
    (void)memset(&s_appPxprConnList[connIndex], 0, sizeof(APP_PXPR_ConnList_T));
}

APP_PXPR_ConnList_T *APP_WLS_PXPR_GetConnListByHandle(uint16_t connHandle)
{
    uint8_t i;

    for(i=0; i<APP_PXPR_MAX_CONN_NBR; i++) 
    {
        if ((s_appPxprConnList[i].connStatus == true) && (s_appPxprConnList[i].connHandle == connHandle))
        {
            return &s_appPxprConnList[i]; 
        }
    }
    return NULL;
}


APP_PXPR_ConnList_T *APP_WLS_PXPR_GetFreeConnList(void)
{
    uint8_t i;

    for(i=0; i<APP_PXPR_MAX_CONN_NBR; i++)
    {
        if (s_appPxprConnList[i].connStatus == false)
        {
            s_appPxprConnList[i].connIndex = i;
            s_appPxprConnList[i].connStatus = true;
            return &s_appPxprConnList[i];
        }
    }
    return NULL; 
}


void APP_WLS_PXPR_KeyLongPress()
{
    uint8_t i;
    switch(g_ctrlInfo.state)
    {
      case APP_DEVICE_STATE_CONN:
      {
          g_ctrlInfo.bAllowNewPairing = true;
          for(i=0; i<APP_PXPR_MAX_CONN_NBR; i++)
          {
                if (s_appPxprConnList[i].connStatus == true)
                {
                    BLE_GAP_Disconnect(s_appPxprConnList[i].connHandle, GAP_DISC_REASON_REMOTE_TERMINATE);
                }
          }
      }
      break;
      case APP_DEVICE_STATE_ADV_DIR:
      {   //Stop advertising
          if (BLE_GAP_SetAdvEnable(false, 0) == MBA_RES_SUCCESS)
          {   //Start for new pairing
              //Clear filter accept list
              APP_WLS_BLE_SetFilterAcceptList(false);
              //Set the configuration of advertising
              APP_WLS_BLE_ConfigAdv(APP_DEVICE_STATE_ADV);
              //Start advertising
              APP_WLS_BLE_EnableAdv(APP_DEVICE_STATE_ADV);
          }
          else
          {   //For debug
              uint16_t ret;
              if (ret != APP_RES_SUCCESS)
              {
                  //if error occurs
              }
          }
      }
      break;
      default:
      {}
      break;
    }
}
void APP_WLS_PXPR_Connected(void)
{
    APP_TIMER_StopTimer(&s_pathLedAlertTmr.tmrHandle);
#ifdef PIC32BZ2 
    BSP_USER_LED_On();
#endif
}


static uint16_t APP_WLS_PXPR_SetTimer(uint16_t idInstance, void *p_tmrParam, bool isPeriodicTimer,APP_TIMER_TmrElem_T *p_tmrElem)
{
  uint8_t tmrId;
  uint16_t result;
  uint32_t timeout = 0x0;
  BLE_PXPR_AlertLevel_T alert_level = *((BLE_PXPR_AlertLevel_T*)p_tmrParam);

  tmrId = (uint8_t)(idInstance >> 8);
  APP_TIMER_SetTimerElem(tmrId, (uint8_t)idInstance, (void *)p_tmrParam, p_tmrElem);
  switch (alert_level)
  {
    case BLE_PXPR_ALERT_LEVEL_MILD:
    {
        timeout = APP_TIMER_500MS;
    }
    break;
    case BLE_PXPR_ALERT_LEVEL_HIGH:
    {
        timeout = APP_TIMER_100MS;
    }
    break;
#ifdef PIC32BZ3
    case BLE_PXPR_ALERT_LEVEL_NO:
    {
        timeout = APP_TIMER_5S;
    }
    break;
    case BLE_PXPR_ALERT_DURATION_TYPE:
    {
        timeout = APP_TIMER_5S;
    }
    break;
#endif
    default:
    break;
  }

  result = APP_TIMER_SetTimer(p_tmrElem, timeout, isPeriodicTimer);
  return result;
}


static void APP_WLS_PXPR_SetAlertTimer(APP_PXPR_ConnList_T *p_conn){
#ifdef PIC32BZ2 
  if(p_conn->currAlert > BLE_PXPR_ALERT_LEVEL_NO)
  {
    if(APP_RES_SUCCESS != APP_WLS_PXPR_SetTimer(APP_PXPR_TMR_ID_INST_MERGE(APP_TIMER_LED_ALERT_03,0U), &p_conn->currAlert, true, &s_pathLedAlertTmr))
    {
        return ; 
    }
  }
  else
  {
      APP_TIMER_StopTimer(&s_pathLedAlertTmr.tmrHandle);
      BSP_USER_LED_On();
  }
#elif defined(PIC32BZ3)
    uint8_t expiredChk = BLE_PXPR_ALERT_DURATION_TYPE;
    APP_LED_Stop(g_appLedHandler);
    if(APP_RES_SUCCESS != APP_WLS_PXPR_SetTimer(APP_PXPR_TMR_ID_INST_MERGE(APP_TIMER_LED_ALERT_03,0U), &p_conn->currAlert, true, &s_pathLedAlertTmr))
    {
        return ; 
    }

    if(APP_RES_SUCCESS != APP_WLS_PXPR_SetTimer(APP_PXPR_TMR_ID_INST_MERGE(APP_TIMER_LED_IND_SWITCH_04,0U),&expiredChk, false, &s_alertDurationTmr))
    {
        return;
    }
    BSP_RGB_LED_GREEN_On();
#endif  
}
void APP_WLS_PXPR_Linkloss(uint16_t connHandle)
{
  APP_PXPR_ConnList_T *p_conn = APP_WLS_PXPR_GetConnListByHandle(connHandle);
#ifdef PIC32BZ2 
  APP_TIMER_StopTimer(&s_pathLedAlertTmr.tmrHandle);
  if(APP_RES_SUCCESS != APP_WLS_PXPR_SetTimer(APP_PXPR_TMR_ID_INST_MERGE(APP_TIMER_LED_ALERT_03, 0U), &p_conn->llsAlert, true, &s_pathLedAlertTmr))
  {
    return ;
  }
#elif defined(PIC32BZ3)
  uint8_t expiredChk = BLE_PXPR_ALERT_DURATION_TYPE;
  APP_LED_Stop(g_appLedHandler);
  if(APP_RES_SUCCESS != APP_WLS_PXPR_SetTimer(APP_PXPR_TMR_ID_INST_MERGE(APP_TIMER_LED_ALERT_03,0U), &p_conn->llsAlert, true, &s_pathLedAlertTmr))
  {
      return ; 
  }
  if(APP_RES_SUCCESS != APP_WLS_PXPR_SetTimer(APP_PXPR_TMR_ID_INST_MERGE(APP_TIMER_LED_IND_SWITCH_04,0U),&expiredChk, false, &s_alertDurationTmr))
  {
      return;
  }
  BSP_RGB_LED_GREEN_On();
#endif
}

void APP_WLS_PXPR_connStateLedRestore(void)
{
    APP_TIMER_StopTimer(&s_pathLedAlertTmr.tmrHandle);

    switch(g_ctrlInfo.state)
    {
        case APP_DEVICE_STATE_ADV:
        {
            APP_LED_StartByMode(APP_LED_MODE_ADV);
        }
        break;
        case APP_DEVICE_STATE_ADV_DIR:
        {
            APP_LED_StartByMode(APP_LED_MODE_ADV_DIR);
        }
        break;
        case APP_DEVICE_STATE_CONN:
        {
            APP_LED_StartByMode(APP_LED_MODE_CONN);
        }
        break;
        default:
        {
        }
        break;
    }
}
</#if>
</#if>

/*******************************************************************************
  Function:
    void APP_WLS_PXPR_LLSAlertLevelWriteResponseIndication(BLE_PXPR_EvtAlertLevelWriteInd_T *evtLlsAlertLvInd)
  Summary:
     Function for handling PXPR Link Loss Service Write response indication.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_WLS_PXPR_LLSAlertLevelWriteResponseIndication(BLE_PXPR_EvtAlertLevelWriteInd_T    *p_evtLlsAlertLevelWriteInd)
{
/* TODO: implement your application code.*/
<#if booleanappcode ==  true>
<#if PROFILE_PXP?? &&  PROFILE_PXP.PXP_BOOL_SERVER == true>

    APP_PXPR_ConnList_T *p_conn = APP_WLS_PXPR_GetConnListByHandle(p_evtLlsAlertLevelWriteInd->connHandle);
    p_conn ->llsAlert =p_evtLlsAlertLevelWriteInd->alertLevel;
    BLE_PXPR_SetLlsAlertLevel(p_evtLlsAlertLevelWriteInd->alertLevel);
</#if>
</#if>
}

/*******************************************************************************
  Function:
    void APP_WLS_PXPR_IASLevelIndication(BLE_PXPR_EvtAlertLevelWriteInd_T   *p_evtTpsTxPwrLvInd)
  Summary:
     Function for handling PXPR Immediate Alert Service indication event from peer device

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_WLS_PXPR_IASLevelIndication(BLE_PXPR_EvtAlertLevelWriteInd_T   *p_evtIasAlertLevelWriteInd)
{
<#if booleanappcode ==  true>
<#if PROFILE_PXP?? &&  PROFILE_PXP.PXP_BOOL_SERVER == true>  
    APP_PXPR_ConnList_T *p_conn = APP_WLS_PXPR_GetConnListByHandle(p_evtIasAlertLevelWriteInd->connHandle);
    if(p_conn->currAlert != p_evtIasAlertLevelWriteInd->alertLevel)
    {
        p_conn->currAlert = p_evtIasAlertLevelWriteInd->alertLevel;
        APP_WLS_PXPR_SetAlertTimer(p_conn);
    }   
</#if>
</#if>
}

/*******************************************************************************
  Function:
    void APP_WLS_PXPR_ErrorUnspecifiedIndication(BLE_PXPR_Event_T *p_event)
  Summary:
     Function for handling PXPR unspecified error

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_WLS_PXPR_ErrorUnspecifiedIndication(BLE_PXPR_Event_T *p_event)
{
/* TODO: implement your application code.*/
<#if booleanappcode ==  true>
<#if PROFILE_PXP?? &&  PROFILE_PXP.PXP_BOOL_SERVER == true>
  
    APP_TIMER_StopTimer(&s_pathLedAlertTmr.tmrHandle);
</#if>
</#if>
}



