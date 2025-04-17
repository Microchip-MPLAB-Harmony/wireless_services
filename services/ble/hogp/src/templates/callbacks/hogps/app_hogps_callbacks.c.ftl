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
    app_hogps_callbacks.c

  Summary:
    This file contains API functions for the users to implement their business logic.

  Description:
    API functions for the user to implement his business logic.
*******************************************************************************/


#include "app_hogps_handler.h"
#include "app_hogps_callbacks.h"
<#if booleanappcode ==  true>
#include "app_led.h"
#include "app_conn.h"
</#if>

// *****************************************************************************
// *****************************************************************************
// Section: Macros
// *****************************************************************************
// *****************************************************************************
<#if booleanappcode ==  true>
#define APP_LOWEST_BATTERY_LEVEL    10
</#if>

// *****************************************************************************
// *****************************************************************************
// Section: Global Variables
// *****************************************************************************
// *****************************************************************************
<#if booleanappcode ==  true>
uint8_t g_userKeysCAPON[APP_USER_KEYS_NUM]={0x06, 0x04, 0x13, 0x12, 0x11};//"capon"
uint8_t g_userKeysCAPOF[APP_USER_KEYS_NUM]={0x06, 0x04, 0x13, 0x12, 0x09};//"capof"
</#if>

// *****************************************************************************
// *****************************************************************************
// Section: Local Variables
// *****************************************************************************
// *****************************************************************************
<#if booleanappcode == true>
static uint8_t s_keyPressed[HID_REPORT_LENGTH_KB_INPUT]={0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
static uint8_t s_userKeysABCDE[APP_USER_KEYS_NUM]={0x04, 0x05, 0x06, 0x07, 0x08};//"abcde"
</#if>

// *****************************************************************************
// *****************************************************************************
// Section: Function Prototypes
// *****************************************************************************
// *****************************************************************************
<#if booleanappcode ==  true>
static void APP_WLS_UpdateBatteryLevel(uint8_t batteryLevel);
</#if>


// *****************************************************************************
// *****************************************************************************
// Section: Functions
// *****************************************************************************
// *****************************************************************************

/*******************************************************************************
  Function:
    void APP_WLS_HOGPS_BootMode(BLE_HOGPS_EvtBootModeEnter_T  evtBootModeEnter)
  Summary:
     Function for handling HID device has switched from report mode to boot mode event.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/

void APP_WLS_HOGPS_BootMode(BLE_HOGPS_EvtBootModeEnter_T  *p_evtBootModeEnter)
{

}


/*******************************************************************************
  Function:
    void APP_WLS_HOGPS_SendReport(BLE_HOGPS_EvtReportModeEnter_T  *p_evtReportModeEnter)
  Summary:
    Function for handling HID device is ready to start sending input reports to the host.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_WLS_HOGPS_SendReport(BLE_HOGPS_EvtReportModeEnter_T  *p_evtReportModeEnter)
{

}


/*******************************************************************************
  Function:
    void APP_WLS_HOGPS_SuspendEnterState(BLE_HOGPS_EvtHostSuspendEnter_T  *p_evtHostSuspendEnter)
  Summary:
     Function for handling HOGPS entering suspend state.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_WLS_HOGPS_SuspendEnterState(BLE_HOGPS_EvtHostSuspendEnter_T  *p_evtHostSuspendEnter)
{

}

/*******************************************************************************
  Function:
    void APP_WLS_HOGPS_SuspendExitState(BLE_HOGPS_EvtHostSuspendExit_T  *p_evtHostSuspendExit)
  Summary:
     Function for handling HOGPS exiting suspend state.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_WLS_HOGPS_SuspendExitState(BLE_HOGPS_EvtHostSuspendExit_T  *p_evtHostSuspendExit)
{

}

/*******************************************************************************
  Function:
    void APP_WLS_HOGPS_WriteInputReport(BLE_HOGPS_EvtReportWrite_T  *p_evtInputReportWrite)
  Summary:
     Function for handling HOGPS input report write opertaion.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_WLS_HOGPS_WriteInputReport(BLE_HOGPS_EvtReportWrite_T  *p_evtInputReportWrite)
{

}

/*******************************************************************************
  Function:
    void APP_WLS_HOGPS_WriteOutputReport(BLE_HOGPS_EvtReportWrite_T  *p_evtOutputReportWrite)
  Summary:
     Function for handling HOGPS output report write opertaion.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_WLS_HOGPS_WriteOutputReport(BLE_HOGPS_EvtReportWrite_T  *p_evtOutputReportWrite)
{

  /* TODO: implement your application code.*/
<#if booleanappcode ==  true>
<#if PROFILE_HOGP?? && PROFILE_HOGP.HOGP_BOOL_SERVER == true>

  static bool bCapsOn=false;
  if (p_evtOutputReportWrite->length == 1)
  {
      if (p_evtOutputReportWrite->p_data[0] & 0x02)//Caps lock
      {
          APP_WLS_HOGPS_PressFewKeys(g_userKeysCAPON, APP_USER_KEYS_NUM);
          bCapsOn=true;
      }
      else
      {
          if (bCapsOn)
          {
              APP_WLS_HOGPS_PressFewKeys(g_userKeysCAPOF, APP_USER_KEYS_NUM);
              bCapsOn=false;
          }
      }
  }
</#if>
</#if>
}

/*******************************************************************************
  Function:
    void APP_WLS_HOGPS_WriteFeatureReport(BLE_HOGPS_EvtReportWrite_T  *p_evtFeatureReportWrite)
  Summary:
     Function for handling HOGPS feature report write opertaion.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_WLS_HOGPS_WriteFeatureReport(BLE_HOGPS_EvtReportWrite_T  *p_evtFeatureReportWrite)
{

}

<#if booleanappcode ==  true>
void APP_WLS_HOGPS_KeyShortPress(void)
{
    uint8_t ibatteryLevel;
    GPIO_PinToggle(GPIO_PIN_RB7);
    if (g_pairedDevInfo.state == APP_DEVICE_STATE_CONN)
    {
        APP_CONN_ResetTimeoutTimer();

        APP_WLS_HOGPS_PressFewKeys(s_userKeysABCDE, APP_USER_KEYS_NUM);
        BLE_BAS_GetBatteryLevel(&ibatteryLevel);
        if (ibatteryLevel > APP_LOWEST_BATTERY_LEVEL)
        {
            ibatteryLevel -= 1;
            APP_WLS_UpdateBatteryLevel(ibatteryLevel);
        }
    }
}

void APP_WLS_HOGPS_KeyLongPress(void)
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

void APP_WLS_HOGPS_PressFewKeys(uint8_t *pKeys, uint8_t key_num)
{
    uint16_t i;
    uint16_t ret;

    if ((key_num <= 0) || (!pKeys))
    {
        return;
    }

    for (i=0; i < key_num; i++)
    {
        s_keyPressed[2]=pKeys[i];   //Make
        ret=BLE_HOGPS_SendKeyboardInputReport(g_pairedDevInfo.connHandle, s_keyPressed);
        if (ret != MBA_RES_SUCCESS)
        {
            SYS_DEBUG_PRINT(SYS_ERROR_INFO,"Send input report error: %d\n", ret);
        }

        s_keyPressed[2]=0x00;       //Release: clear letter
        ret=BLE_HOGPS_SendKeyboardInputReport(g_pairedDevInfo.connHandle, s_keyPressed);
        if (ret != MBA_RES_SUCCESS)
        {
            SYS_DEBUG_PRINT(SYS_ERROR_INFO,"Send input report error: %d\n", ret);
        }
    }
}

static void APP_WLS_UpdateBatteryLevel(uint8_t batteryLevel)
{
    BLE_BAS_SetBatteryLevel(batteryLevel);
    BLE_HOGPS_SendBatteryLevel(g_pairedDevInfo.connHandle);
}
</#if>
