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
    app_ble_handler.h

  Summary:
    This header file provides prototypes and definitions for the application.

  Description:
    This header file provides function prototypes and data type definitions for
    the application.  Some of these are required by the system (such as the
    "APP_Initialize" and "APP_Tasks" prototypes) and some of them are only used
    internally by the application (such as the "APP_STATES" definition).  Both
    are defined here for convenience.
*******************************************************************************/

#ifndef APP_BLE_HANDLER_H
#define APP_BLE_HANDLER_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

#include <stdint.h>
#include <string.h>
#include "gap_defs.h"
#include "ble_gap.h"
<#if BLE_STACK_LIB.GAP_CENTRAL == true || BLE_STACK_LIB.GAP_PERIPHERAL == true>
#include "ble_l2cap.h"
#include "ble_smp.h"
#include "gatt.h"
#include "ble_dtm.h"
#include "ble_dm/ble_dm.h"
    <#if BLE_STACK_LIB.BLE_BOOL_GATT_CLIENT == true>
#include "ble_gcm/ble_dd.h"
        <#if BLE_STACK_LIB.BOOL_GCM_SCM == true>
#include "ble_gcm/ble_scm.h"
        </#if>
    </#if>
</#if>

<#if booleanappcode ==  true>
<#if wlsbleancsss?? && wlsbleancsss.SS_ANCS_BOOL_CLIENT == true>
</#if>

<#if wlsbleanpss?? &&  wlsbleanpss.ANPSS_BOOL_SERVER == true>
#include "../app_ble_callbacks.h"
</#if>

<#if wlsblehogp?? && wlsblehogp.HOGP_BOOL_SERVER == true>
#include "app_hogps_callbacks.h"
#include "device_deep_sleep.h"
#include "app_led.h"
#include "app_conn.h"

#define APP_BLE_CLIENT_SUPPORT_FEATURE_NULL 0x00
</#if>

</#if>

<#if booleanappcode ==  true>
<#if wlsblepxpss?? &&  wlsblepxpss.SS_PXP_BOOL_CLIENT == true>
#include "app_pxpm_handler.h"
#include "ble/middleware_ble/ble_dm/ble_dm_info.h"
#include "bsp/bsp.h"
</#if>
</#if>

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

extern "C" {

#endif
// DOM-IGNORE-END

// *****************************************************************************
// *****************************************************************************
// Section: Type Definitions
// *****************************************************************************
// *****************************************************************************

/*******************************************************************************
  Function:
    void APP_BleGapEvtHandler( BLE_GAP_Event_T *p_event )

  Summary:
     BLE Stack application GAP event handler.

  Description:

  Precondition:

  Parameters:
    None.

  Returns:
    None.

*/
void APP_BleGapEvtHandler(BLE_GAP_Event_T *p_event);
<#if BLE_STACK_LIB.GAP_CENTRAL == true || BLE_STACK_LIB.GAP_PERIPHERAL == true>
/*******************************************************************************
  Function:
    void APP_BleL2capEvtHandler( BLE_L2CAP_Event_T *p_event )

  Summary:
     BLE application L2cap event handler.

  Description:

  Precondition:

  Parameters:
    None.

  Returns:
    None.

*/
void APP_BleL2capEvtHandler(BLE_L2CAP_Event_T *p_event);

/*******************************************************************************
  Function:
    void APP_GattEvtHandler( GATT_Event_T * p_event )

  Summary:
     BLE application GATT event handler.

  Description:

  Precondition:

  Parameters:
    None.

  Returns:
    None.

*/
void APP_GattEvtHandler(GATT_Event_T * p_event);

/*******************************************************************************
  Function:
    void APP_BleSmpEvtHandler( BLE_SMP_Event_T *p_event )

  Summary:
     BLE application SMP event handler.

  Description:

  Precondition:

  Parameters:
    None.

  Returns:
    None.

*/
void APP_BleSmpEvtHandler(BLE_SMP_Event_T *p_event);

/*******************************************************************************
  Function:
    void APP_DmEvtHandler( BLE_DM_Event_T *p_event )

  Summary:
     BLE application DM event handler.

  Description:

  Precondition:

  Parameters:
    None.

  Returns:
    None.

*/
void APP_DmEvtHandler(BLE_DM_Event_T *p_event);

   <#if BLE_STACK_LIB.BLE_BOOL_GATT_CLIENT == true>
/*******************************************************************************
  Function:
    void APP_DdEvtHandler( BLE_DD_Event_T *p_event )

  Summary:
     BLE application DD event handler.

  Description:

  Precondition:

  Parameters:
    None.

  Returns:
    None.

*/
void APP_DdEvtHandler(BLE_DD_Event_T *p_event);
        <#if BLE_STACK_LIB.BOOL_GCM_SCM == true>
/*******************************************************************************
  Function:
    void APP_ScmEvtHandler( BLE_SCM_Event_T *p_event )

  Summary:
     BLE application SCM event handler.

  Description:

  Precondition:

  Parameters:
    None.

  Returns:
    None.

*/
void APP_ScmEvtHandler(BLE_SCM_Event_T *p_event);
        </#if>
    </#if>
</#if>

//DOM-IGNORE-BEGIN
#ifdef __cplusplus
}
#endif
//DOM-IGNORE-END

#endif /* APP_BLE_HANDLER_H */


/*******************************************************************************
 End of File
 */

