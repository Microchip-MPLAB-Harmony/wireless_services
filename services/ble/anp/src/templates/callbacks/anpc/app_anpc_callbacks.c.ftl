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
    app_anpc_callbacks.c

  Summary:
    This file contains API functions for the users to implement their business logic.

  Description:
    API functions for the user to implement his business logic.
*******************************************************************************/
#include "app_ble_callbacks.h"
#include "app_anpc_handler.h"
#include "app_anpc_callbacks.h"
#include "definitions.h" 

// *****************************************************************************
// *****************************************************************************
// Section: Local Variables
// *****************************************************************************
// *****************************************************************************
<#if booleanappcode ==  true>
static APP_ANPC_ConnList_T s_appAnpcConnList[APP_DEVICE_MAX_CONN_NBR];
</#if>


/*******************************************************************************
  Function:
    void APP_WLS_ANPC_DiscoverySuccessfull(BLE_ANPC_EvtDiscComplete_T *p_evtDiscComplete)
  Summary:
     Function for handling ANPC successfully discovered all the necessary characteristics and descriptors of the Alert Notification Service on the server.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/

void APP_WLS_ANPC_DiscoverySuccessfull(BLE_ANPC_EvtDiscComplete_T *p_evtDiscComplete)
{
<#if booleanappcode ==  true>
<#if PROFILE_ANP?? &&  PROFILE_ANP.ANP_BOOL_CLIENT == true>
  APP_ANPC_ConnList_T *p_conn = NULL;
  p_conn = APP_WLS_ANPC_GetConnListByHandle(p_evtDiscComplete->connHandle);
  if (p_conn == NULL)
  { 
      return;
  }
  p_conn->bDiscovered = true;
  APP_WLS_ANPC_EnableCccd(p_evtDiscComplete->connHandle, true);
</#if>
</#if>
}


/*******************************************************************************
  Function:
    void APP_WLS_ANPC_SupportNewCategoryReceived(BLE_ANPC_EvtSuppNewAlertCatInd_T *p_evtSuppNewAlertCatInd)
  Summary:
     Function for handling ANPC succesfully received category of new alerts notification EVENT message.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_WLS_ANPC_SupportNewCategoryReceived(BLE_ANPC_EvtSuppNewAlertCatInd_T *p_evtSuppNewAlertCatInd)
{
<#if booleanappcode ==  true>
<#if PROFILE_ANP?? &&  PROFILE_ANP.ANP_BOOL_CLIENT == true>
  int retNum;
  char s_strBuf[256];
  retNum = sprintf(s_strBuf,
    "BLE_ANPC_EVT_SUPP_NEW_ALERT_CAT_IND\n"
    "  connHandle: %04x\n"
    "  category: %04x\n",
    p_evtSuppNewAlertCatInd->connHandle,
    p_evtSuppNewAlertCatInd->category);
  if (retNum > 0)
  {
       SYS_DEBUG_PRINT(SYS_ERROR_INFO,s_strBuf);
  }
</#if>
</#if>
}


/*******************************************************************************
  Function:
    void APP_WLS_ANPC_UnreadAlertCategoryStatusIndication(BLE_ANPC_EvtSuppUnreadAlertCatInd_T  *p_evtSuppUnreadAlertCatInd)
  Summary:
     Function for handling ANPC unread alert status EVENT message.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_WLS_ANPC_UnreadAlertCategoryStatusIndication(BLE_ANPC_EvtSuppUnreadAlertCatInd_T  *p_evtSuppUnreadAlertCatInd)
{
<#if booleanappcode ==  true>
<#if PROFILE_ANP?? &&  PROFILE_ANP.ANP_BOOL_CLIENT == true>
  int retNum;
  char s_strBuf[256];
  retNum = sprintf(s_strBuf,
      "BLE_ANPC_EVT_SUPP_UNREAD_ALERT_STAT_CAT_IND\n"
      "  connHandle: %04x\n"
      "  category: %04x\n",
      p_evtSuppUnreadAlertCatInd->connHandle,
      p_evtSuppUnreadAlertCatInd->category);
  if (retNum > 0)
  {
       SYS_DEBUG_PRINT(SYS_ERROR_INFO,s_strBuf);
  }
</#if>
</#if>
}

/*******************************************************************************
  Function:
    void APP_WLS_ANPC_NewAlertReceived(BLE_ANPC_EvtNewAlertInd_T  *p_evtNewAlertInd)
  Summary:
     Function for handling ANPC new alert received EVENT message.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_WLS_ANPC_NewAlertReceived(BLE_ANPC_EvtNewAlertInd_T  *p_evtNewAlertInd)
{
<#if booleanappcode ==  true>
<#if PROFILE_ANP?? &&  PROFILE_ANP.ANP_BOOL_CLIENT == true>
  char s_strBuf[256];
  int retNum;
  uint16_t strLen = p_evtNewAlertInd->receivedLength;
  char *p_txtStr = OSAL_Malloc(strLen+1U);

  if (p_txtStr == NULL)
  {
      return;
  }
  (void)memcpy(p_txtStr,p_evtNewAlertInd->p_receivedValue, strLen);
  p_txtStr[strLen] = '\0';
  retNum = sprintf(s_strBuf,
      "BLE_ANPC_EVT_NEW_ALERT_IND\n"
      "  connHandle: %04x\n"
      "  categoryId: %02x\n"
      "  numOfNewAlert: %02x\n"
      "  receivedLength: %04x\n"
      "  txtStr: %s\n",
      p_evtNewAlertInd->connHandle,
      p_evtNewAlertInd->categoryId,
      p_evtNewAlertInd->numOfNewAlert,
      p_evtNewAlertInd->receivedLength,
      p_txtStr);
  if (retNum > 0)
  {
       SYS_DEBUG_PRINT(SYS_ERROR_INFO,"%s\r\n",s_strBuf);
  }
  OSAL_Free(p_txtStr);
</#if>
</#if>
}

/*******************************************************************************
  Function:
    void APP_WLS_ANPC_UnreadAlertStatusReceived(BLE_ANPC_EvtUnreadAlertStatInd_T  *p_evtUnreadAlertStatInd)
  Summary:
     Function for handling ANPC received an unread alert status notification from the server.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_WLS_ANPC_UnreadAlertStatusReceived(BLE_ANPC_EvtUnreadAlertStatInd_T  *p_evtUnreadAlertStatInd)
{
<#if booleanappcode ==  true>
<#if PROFILE_ANP?? &&  PROFILE_ANP.ANP_BOOL_CLIENT == true>
  char s_strBuf[256];
  int retNum;
  retNum = sprintf(s_strBuf,
    "BLE_ANPC_EVT_UNREAD_ALERT_STAT_IND\n"
    "  connHandle: %04x\n"
    "  category: %02x\n"
    "  unreadCnt: %02x\n",
    p_evtUnreadAlertStatInd->connHandle,
    p_evtUnreadAlertStatInd->categoryId,
    p_evtUnreadAlertStatInd->unreadCnt);
  if (retNum > 0)
  {
       SYS_DEBUG_PRINT(SYS_ERROR_INFO,"%s\r\n", s_strBuf);
  }
</#if>
</#if>
}

<#if booleanappcode ==  true>
static void APP_WLS_ANPC_RunCmdbyState(uint16_t connHandle)
{
    APP_ANPC_ConnList_T *p_conn = NULL;
    p_conn = APP_WLS_ANPC_GetConnListByHandle(connHandle);
    if (p_conn == NULL)
    { 
        return;
    }
    if (p_conn->bCccdEnable == false)
    {
        APP_WLS_ANPC_EnableCccd(connHandle, true);
    }
    else
    {
        APP_WLS_ANPC_EnableCccd(connHandle, false);
    }
}

void APP_WLS_ANPC_InitConnList(uint8_t connIndex)
{
    (void)memset((uint8_t *)&s_appAnpcConnList[connIndex], 0, sizeof(APP_ANPC_ConnList_T));
}

APP_ANPC_ConnList_T *APP_WLS_ANPC_GetConnListByHandle(uint16_t connHandle)
{
    uint8_t i;

    for(i=0; i<APP_DEVICE_MAX_CONN_NBR; i++)
    {
        if ((s_appAnpcConnList[i].bConnStatus == true) && (s_appAnpcConnList[i].connHandle == connHandle))
        {
            return &s_appAnpcConnList[i];
        }
    }
    return NULL;
}

APP_ANPC_ConnList_T *APP_WLS_ANPC_GetFreeConnList(void)
{
    uint8_t i;

    for(i=0; i<APP_DEVICE_MAX_CONN_NBR; i++)
    {
        if (s_appAnpcConnList[i].bConnStatus == false)
        {
            s_appAnpcConnList[i].bConnStatus = true;
            s_appAnpcConnList[i].connIndex = i;
            return &s_appAnpcConnList[i];
        }
    }
    return NULL;
}

void APP_WLS_ANPC_EnableCccd(uint16_t connHandle, bool enable)
{
    APP_ANPC_ConnList_T *p_conn = NULL;
    uint16_t ret = MBA_RES_SUCCESS;
    p_conn = APP_WLS_ANPC_GetConnListByHandle(connHandle);
    if (p_conn == NULL)
    {
        return;
    }
    if (p_conn->bDiscovered == false)
	{
		return;
	}
    p_conn->bCccdEnable = enable;

    if (p_conn->bNewAlertEnable !=  enable)
    {
        ret = BLE_ANPC_EnableNewAlertNtfy(connHandle, enable);
    }
    else if (p_conn->bUnreadAlertEnable !=  enable)
    {
        ret = BLE_ANPC_EnableUnreadAlertNtfy(connHandle, enable);
    }
    else
    {
    }
    if (ret == MBA_RES_SUCCESS)
    {
        p_conn->bEnableCccdRetry = false;
    }
    else
    {
        p_conn->bEnableCccdRetry = true;
    }
}

void APP_WLS_ANPC_KeyShortPress(void)
{
    uint8_t i = 0U;
    GPIO_PinToggle(GPIO_PIN_RB7);

    if (g_ctrlInfo.state == APP_DEVICE_STATE_CONN)
    {
        for(i=0; i<APP_DEVICE_MAX_CONN_NBR; i++)
        {
            if (s_appAnpcConnList[i].bConnStatus == true)
            {
                APP_WLS_ANPC_RunCmdbyState(s_appAnpcConnList[i].connHandle);
            }
        }
    }
}

void APP_WLS_ANPC_KeyLongPress(void)
{
  uint8_t i = 0U;
  switch (g_ctrlInfo.state)
  {
      case APP_DEVICE_STATE_CONN:
      {
          g_ctrlInfo.bAllowNewPairing = true;
          for(i=0; i<APP_DEVICE_MAX_CONN_NBR; i++)
          {
              if (s_appAnpcConnList[i].bConnStatus == true)
              {
                  BLE_GAP_Disconnect(s_appAnpcConnList[i].connHandle, GAP_DISC_REASON_REMOTE_TERMINATE);
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
              ret  = APP_LED_Stop(g_appLedHandler);
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
</#if>