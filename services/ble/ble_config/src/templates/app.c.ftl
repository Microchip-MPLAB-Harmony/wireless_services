<#assign APP_THROUGHPUT = false>
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true && WLS_BLE_BOOL_GAP_EXT_ADV == false && WLS_BLE_GAP_DSADV_EN == false && WLS_BLE_BOOL_L2CAP_CREDIT_FLOWCTRL == true> 
<#assign APP_THROUGHPUT = true>
</#if>
// DOM-IGNORE-BEGIN
/*******************************************************************************
* Copyright (C) 2022 Microchip Technology Inc. and its subsidiaries.
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
  MPLAB Harmony Application Source File

  Company:
    Microchip Technology Inc.

  File Name:
    app.c

  Summary:
    This file contains the source code for the MPLAB Harmony application.

  Description:
    This file contains the source code for the MPLAB Harmony application.  It
    implements the logic of the application's state machine and it may call
    API routines of other MPLAB Harmony modules in the system, such as drivers,
    system services, and middleware.  However, it does not call any of the
    system interfaces (such as the "Initialize" and "Tasks" functions) of any of
    the modules in the system or make any assumptions about when those functions
    are called.  That is the responsibility of the configuration-specific system
    files.
 *******************************************************************************/

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************
#include <string.h>
#include "app.h"
#include "definitions.h"
<#if BLE_STACK_LIB.BLE_SYS_CTRL_ONLY_EN == false>
#include "app_ble.h"
<#else>
#include "app_ble_hci.h"
</#if>
<#if BLE_STACK_LIB.GAP_ADVERTISING && (!BLE_STACK_LIB.BOOL_GAP_EXT_ADV) && BLE_STACK_LIB.GAP_DSADV_EN>
#include "app_ble_dsadv.h"
</#if>
${WLS_BLE_LIST_DEV_SUPP_INCLUDE_C}
// *****************************************************************************
// *****************************************************************************
// Section: Global Data Definitions
// *****************************************************************************
// *****************************************************************************
${WLS_BLE_LIST_DEV_SUPP_DATA_C}

// *****************************************************************************
/* Application Data

  Summary:
    Holds application data

  Description:
    This structure holds the application's data.

  Remarks:
    This structure should be initialized by the APP_Initialize function.

    Application strings and buffers are be defined outside this structure.
*/

APP_DATA appData;

// *****************************************************************************
// *****************************************************************************
// Section: Application Callback Functions
// *****************************************************************************
// *****************************************************************************

/* TODO:  Add any necessary callback functions.
*/
${WLS_BLE_LIST_DEV_SUPP_CB_FUNC_C}
<#if wlsbleancsss?? && wlsbleancsss.SS_ANCS_BOOL_CLIENT == true || wlsblehogp?? && wlsblehogp.HOGP_BOOL_SERVER == true || wlsbleanpss?? && (wlsbleanpss.ANPSS_BOOL_SERVER == true || wlsbleanpss.ANPSS_BOOL_CLIENT == true) || wlsblepxpss?? && (wlsblepxpss.SS_PXP_BOOL_CLIENT == true || wlsblepxpss.SS_PXP_BOOL_SERVER == true)>
static void APP_KeyFunction(APP_KEY_MSG_T msg)
{
  switch (msg)
  {
    case APP_KEY_MSG_SHORT_PRESS:
    {
  <#lt>${WLS_BLE_APP_KEY_MSG_SHORT_PRESS}
    }
    break;
    case APP_KEY_MSG_LONG_PRESS:
    {
  <#lt>${WLS_BLE_APP_KEY_MSG_LONG_PRESS}
    }
    break; 
    case APP_KEY_MSG_DOUBLE_CLICK:
    {
  <#lt>${WLS_BLE_APP_KEY_MSG_DOUBLE_CLICK}
    }
    break; 
    default:
    break;
  }
}
</#if>
// *****************************************************************************
// *****************************************************************************
// Section: Application Local Functions
// *****************************************************************************
// *****************************************************************************


/* TODO:  Add any necessary local functions.
*/



// *****************************************************************************
// *****************************************************************************
// Section: Application Initialization and State Machine Functions
// *****************************************************************************
// *****************************************************************************

/*******************************************************************************
  Function:
    void APP_Initialize ( void )

  Remarks:
    See prototype in app.h.
 */

void APP_Initialize ( void )
{
    /* Place the App state machine in its initial state. */
    appData.state = APP_STATE_INIT;


    appData.appQueue = xQueueCreate( 64, sizeof(APP_Msg_T) );
    /* TODO: Initialize your application's state machine and other
     * parameters.
     */

}


/******************************************************************************
  Function:
    void APP_Tasks ( void )

  Remarks:
    See prototype in app.h.
 */

void APP_Tasks ( void )
{
    APP_Msg_T    appMsg[1];
    APP_Msg_T   *p_appMsg;
    p_appMsg=appMsg;
<#lt>${WLS_BLE_LIST_DEV_SUPP_APP_ENTRY_C}
/* Check the application's current state. */
    switch ( appData.state )
    {
        /* Application's initial state. */
        case APP_STATE_INIT:
        {
            bool appInitialized = true;
            //appData.appQueue = xQueueCreate( 10, sizeof(APP_Msg_T) );
            APP_BleStackInit();
<#lt>${WLS_BLE_LIST_DEV_SUPP_INIT_C}
<#if pic32cx_bz2_devsupport?? && ((pic32cx_bz2_devsupport.SLEEP_SUPPORTED || ((pic32cx_bz2_devsupport.ZB_DEEP_SLEEP_SUPPORTED == true) || ((pic32cx_bz2_devsupport.OT_DEEP_SLEEP_SUPPORTED == true) || (pic32cx_bz2_devsupport.MAC_DEEP_SLEEP_SUPPORTED == true)))) && (pic32cx_bz2_devsupport.BLESTACK_LOADED == false))>
            if (!(RTC_REGS->MODE0.RTC_CTRLA & RTC_MODE0_CTRLA_ENABLE_Msk))
            {
                RTC_Timer32Start();
            }
</#if>
            if (appInitialized)
            {

                appData.state = APP_STATE_SERVICE_TASKS;
            }
            break;
        }

        case APP_STATE_SERVICE_TASKS:
        {
            if (OSAL_QUEUE_Receive(&appData.appQueue, &appMsg, OSAL_WAIT_FOREVER))
            {
<#if APP_THROUGHPUT == false>
<#if BLE_STACK_LIB.BLE_SYS_CTRL_ONLY_EN == false>
                if(p_appMsg->msgId==APP_MSG_BLE_STACK_EVT)
                {
                    // Pass BLE Stack Event Message to User Application for handling
                    APP_BleStackEvtHandler((STACK_Event_T *)p_appMsg->msgData);
                }
    <#if BLE_STACK_LIB.BLE_VIRTUAL_SNIFFER_EN == true>
                else if(p_appMsg->msgId==APP_MSG_BLE_STACK_LOG)
                {
                    // Pass BLE LOG Event Message to User Application for handling
                    APP_BleStackLogHandler((BT_SYS_LogEvent_T *)p_appMsg->msgData);
                }
</#if>
<#else>
                if(p_appMsg->msgId==APP_MSG_BLE_STACK_EVT)
                {
                    // Pass BLE Stack Event Message to User Application for handling
                    APP_BleStackEvtHandler((STACK_HCI_Cb_T *)p_appMsg->msgData);
                }
</#if>
<#else>
</#if>
<#lt>${WLS_BLE_LIST_DEV_SUPP_TASK_ENTRY_C}

            }
            break;
        }
        
        /* TODO: implement your application state machine.*/
     

        /* The default state should never be executed. */
        default:
        {
            /* TODO: Handle error in application's state machine. */
            break;
        }
    }
}


/*******************************************************************************
 End of File
 */
