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
    app_ancs_callbacks.c

  Summary:
    This file contains API functions for the users to implement their business logic.

  Description:
    API functions for the user to implement his business logic.
*******************************************************************************/


#include "app_ancs_handler.h"
#include "app_ancs_callbacks.h"

<#if booleanappcode ==  true>
<#if PROFILE_ANCS?? && PROFILE_ANCS.ANCS_BOOL_CLIENT == true>
APP_NotificationInfo_T g_NtfyInfo;

static void APP_WLS_ANCS_RunAncsCmdbyState(void)
{
    BLE_ANCS_NtfyAttrsMask_T ntfyAttMask;
    BLE_ANCS_AppAttrsMask_T appAttrMask;

    switch (g_NtfyInfo.state)
    {
        case APP_ANCS_IND_NTFY_ADDED:
        {
            ntfyAttMask.appId=1;
            ntfyAttMask.title=1;
            ntfyAttMask.subtitle=1;
            ntfyAttMask.msg=1;
            ntfyAttMask.msgSize=1;
            ntfyAttMask.date=1;
            ntfyAttMask.positiveAction=1;
            ntfyAttMask.negativeAction=1;
            BLE_ANCS_GetNtfyAttr(g_pairedDevInfo.connHandle, g_NtfyInfo.ntfyId, ntfyAttMask);
        }
        break;

        case APP_ANCS_IND_NTFY_ATTR:
        {
            appAttrMask.displayName=1;
            BLE_ANCS_GetAppAttr(g_pairedDevInfo.connHandle, g_NtfyInfo.appId, appAttrMask);
        }
        break;

        case APP_ANCS_IND_APP_ATTR:
        {
            BLE_ANCS_PerformNtfyAction(g_pairedDevInfo.connHandle, g_NtfyInfo.ntfyId, BLE_ANCS_ACTION_ID_POSITIVE);
        }
        break;

        default:
        break;
    }
}
void APP_WLS_ANCS_KeyShortPress()
{
    GPIO_PinToggle(GPIO_PIN_RB7);

    if (g_pairedDevInfo.state == APP_DEVICE_STATE_CONN)
    {
        APP_WLS_ANCS_RunAncsCmdbyState();
    }   
}

void APP_WLS_ANCS_KeyDoublePress()
{
if (g_pairedDevInfo.state == APP_DEVICE_STATE_CONN)
    {
        if (g_NtfyInfo.state == APP_ANCS_IND_APP_ATTR)
        {
            BLE_ANCS_PerformNtfyAction(g_pairedDevInfo.connHandle, g_NtfyInfo.ntfyId, BLE_ANCS_ACTION_ID_NEGATIVE);
        }
    }
}

void APP_WLS_ANCS_KeyLongPress()
{
    switch (g_pairedDevInfo.state)
    {
        case APP_DEVICE_STATE_CONN:
        {
            g_bAllowNewPairing=true;
            BLE_GAP_Disconnect(g_pairedDevInfo.connHandle, GAP_DISC_REASON_REMOTE_TERMINATE);
        }
        break;

        case APP_DEVICE_STATE_ADV_DIR:
        {
            //Stop advertising
            if (BLE_GAP_SetAdvEnable(false, 0) == MBA_RES_SUCCESS)
            {
                //Start for new pairing
                //Clear paired device info
                APP_WLS_BLE_InitPairedDeviceInfo();
                //Set a new IRK
                APP_WLS_BLE_SetLocalIRK();
                //Set a new local address-Random Static Address
                APP_WLS_BLE_GenerateRandomStaticAddress(&g_extPairedDevInfo.localAddr);
                BLE_GAP_SetDeviceAddr(&g_extPairedDevInfo.localAddr);
                //Clear filter accept list
                APP_WLS_BLE_SetFilterAcceptList(false);
                //Clear resolving list
                APP_WLS_BLE_SetResolvingList(false);
                //Set the configuration of advertising
                APP_WLS_BLE_ConfigAdvDirect(false);
                //Start advertising
                APP_WLS_BLE_EnableAdvDirect(false);
            }
            else
            {   //For debug
                APP_LED_Stop(g_appLedHandler);
            }
        }
        break;

        default:
        break;
    }
}
</#if>
</#if>

/*******************************************************************************
  Function:
    void APP_WLS_ANCS_NotificationReceived(BLE_ANCS_EvtNtfyInd_T  *p_evtNtfyInd)
  Summary:
     Function for handling ANCS new notification received EVENT message.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/

void APP_WLS_ANCS_NotificationReceived(BLE_ANCS_EvtNtfyInd_T  *p_evtNtfyInd)
{

<#if booleanappcode ==  true>
<#if PROFILE_ANCS?? && PROFILE_ANCS.ANCS_BOOL_CLIENT == true>
 SYS_DEBUG_PRINT(SYS_ERROR_INFO,"BLE_ANCS_EVT_NTFY_ADDED_IND.\r\n"
                  "connHandle: 0x%.4X\r\n"
                  "NotificationUID: 0x%.8X\r\n"
                  "EventFlags:\r\n"
                  "  silent: %d\r\n"
                  "  important: %d\r\n"
                  "  preExisting: %d\r\n"
                  "  positiveAction: %d\r\n"
                  "  negativeAction: %d\r\n"
                  "CategoryID: 0x%.2X\r\n"
                  "CategoryCount: 0x%.2X\r\n"
                  "-> Press Button 1 to Get Notification Attributes:\r\n",
                  p_evtNtfyInd->connHandle,
                  (unsigned int)p_evtNtfyInd->ntfyId,
                  (p_evtNtfyInd->ntfyEvtFlagMask.silent ? 1: 0),
                  (p_evtNtfyInd->ntfyEvtFlagMask.important ? 1: 0),
                  (p_evtNtfyInd->ntfyEvtFlagMask.preExisting ? 1: 0),
                  (p_evtNtfyInd->ntfyEvtFlagMask.positiveAction ? 1: 0),
                  (p_evtNtfyInd->ntfyEvtFlagMask.negativeAction ? 1: 0),
                  p_evtNtfyInd->categoryId,
                  p_evtNtfyInd->categoryCount);

    g_NtfyInfo.bNtfyAdded=true;
    g_NtfyInfo.ntfyId = p_evtNtfyInd->ntfyId;
    g_NtfyInfo.ntfyEvtFlagMask = p_evtNtfyInd->ntfyEvtFlagMask;
    g_NtfyInfo.state = APP_ANCS_IND_NTFY_ADDED;
</#if>
</#if>
}


/*******************************************************************************
  Function:
    void APP_WLS_ANCS_NotificationModified(BLE_ANCS_EvtNtfyInd_T  *p_evtNtfyInd)
  Summary:
     Function for handling ANCS notification modified EVENT message.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_WLS_ANCS_NotificationModified(BLE_ANCS_EvtNtfyInd_T  *p_evtNtfyInd)
{

<#if booleanappcode ==  true>
<#if PROFILE_ANCS?? && PROFILE_ANCS.ANCS_BOOL_CLIENT == true>
     SYS_DEBUG_PRINT(SYS_ERROR_INFO,"BLE_ANCS_EVT_NTFY_MODIFIED_IND.\r\n"
          "connHandle: 0x%.4X\r\n"
          "NotificationUID: 0x%.8X\r\n"
          "EventFlags:\r\n"
          "  silent: %d\r\n"
          "  important: %d\r\n"
          "  preExisting: %d\r\n"
          "  positiveAction: %d\r\n"
          "  negativeAction: %d\r\n"
          "CategoryID: 0x%.2X\r\n"
          "CategoryCount: 0x%.2X\r\n",
          p_evtNtfyInd->connHandle,
          (unsigned int)p_evtNtfyInd->ntfyId,
          (p_evtNtfyInd->ntfyEvtFlagMask.silent ? 1: 0),
          (p_evtNtfyInd->ntfyEvtFlagMask.important ? 1: 0),
          (p_evtNtfyInd->ntfyEvtFlagMask.preExisting ? 1: 0),
          (p_evtNtfyInd->ntfyEvtFlagMask.positiveAction ? 1: 0),
          (p_evtNtfyInd->ntfyEvtFlagMask.negativeAction ? 1: 0),
          p_evtNtfyInd->categoryId,
          p_evtNtfyInd->categoryCount);
            
    g_NtfyInfo.ntfyId = p_evtNtfyInd->ntfyId;
    g_NtfyInfo.ntfyEvtFlagMask = p_evtNtfyInd->ntfyEvtFlagMask;

</#if>
</#if>
}


/*******************************************************************************
  Function:
    void APP_WLS_ANCS_NotificationRemoved(BLE_ANCS_EvtNtfyInd_T  *p_evtNtfyInd)
  Summary:
     Function for handling ANCS notification removed EVENT message.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_WLS_ANCS_NotificationRemoved(BLE_ANCS_EvtNtfyInd_T  *p_evtNtfyInd)
{

<#if booleanappcode ==  true>
<#if PROFILE_ANCS?? && PROFILE_ANCS.ANCS_BOOL_CLIENT == true>
     SYS_DEBUG_PRINT(SYS_ERROR_INFO,"BLE_ANCS_EVT_NTFY_REMOVED_IND.\r\n"
          "connHandle: 0x%.4X\r\n"
          "NotificationUID: 0x%.8X\r\n"
          "EventFlags:\r\n"
          "  silent: %d\r\n"
          "  important: %d\r\n"
          "  preExisting: %d\r\n"
          "  positiveAction: %d\r\n"
          "  negativeAction: %d\r\n"
          "CategoryID: 0x%.2X\r\n"
          "CategoryCount: 0x%.2X\r\n",
          p_evtNtfyInd->connHandle,
          (unsigned int)p_evtNtfyInd->ntfyId,
          (p_evtNtfyInd->ntfyEvtFlagMask.silent ? 1: 0),
          (p_evtNtfyInd->ntfyEvtFlagMask.important ? 1: 0),
          (p_evtNtfyInd->ntfyEvtFlagMask.preExisting ? 1: 0),
          (p_evtNtfyInd->ntfyEvtFlagMask.positiveAction ? 1: 0),
          (p_evtNtfyInd->ntfyEvtFlagMask.negativeAction ? 1: 0),
          p_evtNtfyInd->categoryId,
          p_evtNtfyInd->categoryCount);

    g_NtfyInfo.bNtfyAdded=false;
    g_NtfyInfo.ntfyId = p_evtNtfyInd->ntfyId;
    g_NtfyInfo.ntfyEvtFlagMask = p_evtNtfyInd->ntfyEvtFlagMask;
    g_NtfyInfo.state = APP_ANCS_IND_NTFY_REMOVED;


</#if>
</#if>
}

/*******************************************************************************
  Function:
    void APP_WLS_ANCS_NotificationDetailsReceived(BLE_ANCS_EvtNtfyAttrInd_T  *p_evtNtfyAttrInd)
  Summary:
     Function for handling ANCS notification detailed information received EVENT message.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_WLS_ANCS_NotificationDetailsReceived(BLE_ANCS_EvtNtfyAttrInd_T  *p_evtNtfyAttrInd)
{

<#if booleanappcode ==  true>
<#if PROFILE_ANCS?? && PROFILE_ANCS.ANCS_BOOL_CLIENT == true>
    BLE_ANCS_DecodeNtfyAttrs_T  *p_data;
     SYS_DEBUG_PRINT(SYS_ERROR_INFO,"BLE_ANCS_EVT_NTFY_ATTR_IND.\r\n"
          "connHandle: 0x%.4X\r\n"
          "NotificationUID: 0x%.8X\r\n"
          "bitmask:\r\n"
          "  appId: %s\r\n"
          "  title: %s\r\n"
          "  subtitle: %s\r\n"
          "  msg: %s\r\n"
          "  msgSize: %d\r\n"
          "  date: %s\r\n"
          "  positiveAction: %s\r\n"
          "  negativeAction: %s\r\n"
          "-> Press Button 1 to Get App Attributes:\r\n",
          p_evtNtfyAttrInd->connHandle,
          (unsigned int)p_evtNtfyAttrInd->p_data->ntfyId,
          (p_evtNtfyAttrInd->p_data->bitmask.appId ? (char *)p_evtNtfyAttrInd->p_data->appId: ""),
          (p_evtNtfyAttrInd->p_data->bitmask.title ? (char *)p_evtNtfyAttrInd->p_data->p_title: ""),
          (p_evtNtfyAttrInd->p_data->bitmask.subtitle ? (char *)p_evtNtfyAttrInd->p_data->p_subtitle: ""),
          (p_evtNtfyAttrInd->p_data->bitmask.msg ? (char *)p_evtNtfyAttrInd->p_data->p_msg: ""),
          (p_evtNtfyAttrInd->p_data->bitmask.msgSize ? p_evtNtfyAttrInd->p_data->msgSize: 0),
          (p_evtNtfyAttrInd->p_data->bitmask.date ? (char *)p_evtNtfyAttrInd->p_data->date: ""),
          (p_evtNtfyAttrInd->p_data->bitmask.positiveAction ? (char *)p_evtNtfyAttrInd->p_data->positiveAction: ""),
          (p_evtNtfyAttrInd->p_data->bitmask.negativeAction ? (char *)p_evtNtfyAttrInd->p_data->negativeAction: "")); 

    p_data=p_evtNtfyAttrInd->p_data;
    g_NtfyInfo.ntfyAttrBitMask=p_data->bitmask;
    g_NtfyInfo.state = APP_ANCS_IND_NTFY_ATTR;

    if (p_data->bitmask.appId)
    {
        memcpy(g_NtfyInfo.appId, p_data->appId, BLE_ANCS_MAX_APPID_LEN);
    }
    if (p_data->bitmask.positiveAction)
    {
        memcpy(g_NtfyInfo.positiveAction, p_data->positiveAction, BLE_ANCS_MAX_POS_ACTION_LABEL_LEN);
    }
    if (p_data->bitmask.negativeAction)
    {
        memcpy(g_NtfyInfo.negativeAction, p_data->negativeAction, BLE_ANCS_MAX_NEG_ACTION_LABEL_LEN);
    }


</#if>
</#if>
}

/*******************************************************************************
  Function:
    void APP_WLS_ANCS_AppDetailsReceived(BLE_ANCS_EvtAppAttrInd_T  *p_evtAppAttrInd)
  Summary:
     Function for handling ANCS application attributes of notification EVENT message.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_WLS_ANCS_AppDetailsReceived(BLE_ANCS_EvtAppAttrInd_T  *p_evtAppAttrInd)
{

<#if booleanappcode ==  true>
<#if PROFILE_ANCS?? && PROFILE_ANCS.ANCS_BOOL_CLIENT == true>
   SYS_DEBUG_PRINT(SYS_ERROR_INFO,"BLE_ANCS_EVT_APP_ATTR_IND.\r\n"
          "connHandle: 0x%.4X\r\n"
          "appId: %s\r\n"
          "displayName: %s\r\n"
          "->%s%s%s%s :\r\n",
          p_evtAppAttrInd->connHandle,
          p_evtAppAttrInd->p_data->appId,
          p_evtAppAttrInd->p_data->displayName,
          (g_NtfyInfo.ntfyEvtFlagMask.positiveAction ? " Press Button1: ": ""),
          (g_NtfyInfo.ntfyEvtFlagMask.positiveAction ? (char *)g_NtfyInfo.positiveAction: ""),
          (g_NtfyInfo.ntfyEvtFlagMask.negativeAction ? " Double-click Button 1: ": ""),
          (g_NtfyInfo.ntfyEvtFlagMask.negativeAction ? (char *)g_NtfyInfo.negativeAction: ""));

  g_NtfyInfo.state = APP_ANCS_IND_APP_ATTR;

</#if>
</#if>
}

/*******************************************************************************
  Function:
    void APP_WLS_ANCS_ErrorIndication(BLE_ANCS_EvtErrInd_T   *p_evtErrInd)
  Summary:
     Function for handling ANCS notofication error indication EVENT message.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_WLS_ANCS_ErrorIndication(BLE_ANCS_EvtErrInd_T   *p_evtErrInd)
{

<#if booleanappcode ==  true>
<#if PROFILE_ANCS?? && PROFILE_ANCS.ANCS_BOOL_CLIENT == true>
/* Require security permission to access characteristics. Inform application and pause the discovery. */
  if ((p_evtErrInd->errCode == ATT_ERR_INSUF_ENC) || (p_evtErrInd->errCode == ATT_ERR_INSUF_AUTHN))
  {
    BLE_DM_ProceedSecurity(p_evtErrInd->connHandle, 0);
  }

</#if>
</#if>
}
