<#assign APP_THROUGHPUT = false>
<#if wlsbleconfig?? &&  wlsbleconfig.WLS_BLE_GAP_PERIPHERAL == true && 
    wlsbleconfig.WLS_BLE_GAP_ADVERTISING == true && 
    SS_TRSP_BOOL_SERVER == true && 
    wlsbleconfig.WLS_BLE_BOOL_GAP_EXT_ADV == false && 
    wlsbleconfig.WLS_BLE_GAP_DSADV_EN == false && 
    wlsbleconfig.WLS_BLE_BOOL_L2CAP_CREDIT_FLOWCTRL == true> 
<#assign APP_THROUGHPUT = true>
</#if>
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

/*******************************************************************************
  MPLAB Harmony Application Header File

  Company:
    Microchip Technology Inc.

  File Name:
    app_trsps_handler.h

  Summary:
    This header file provides prototypes and definitions for the application.

  Description:
    This header file provides function prototypes and data type definitions for
    the application.  Some of these are required by the system (such as the
    "APP_Initialize" and "APP_Tasks" prototypes) and some of them are only used
    internally by the application (such as the "APP_STATES" definition).  Both
    are defined here for convenience.
*******************************************************************************/

#ifndef APP_TRSPS_HANDLER_H
#define APP_TRSPS_HANDLER_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

#include <stdint.h>
#include <string.h>
#include "ble_trsps/ble_trsps.h"
<#if APP_THROUGHPUT == true>
#ifdef APP_PAIRING_ENABLE
#include "ble_trs/ble_trs.h"
#endif
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
    void APP_TrspsEvtHandler(BLE_TRSPS_Event_T *p_event)

  Summary:
     BLE application Transparent profile server event handler.

  Description:

  Precondition:

  Parameters:
    None.

  Returns:
    None.

*/
void APP_TrspsEvtHandler(BLE_TRSPS_Event_T *p_event);

//DOM-IGNORE-BEGIN
#ifdef __cplusplus
}
#endif
//DOM-IGNORE-END

#endif /* APP_TRSPS_HANDLER_H */


/*******************************************************************************
 End of File
 */

