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
  Application BLE Profile Source File

  Company:
    Microchip Technology Inc.

  File Name:
    app_trsps_handler.c
  Summary:
    This file contains the Application BLE functions for this project.

  Description:
    This file contains the Application BLE functions for this project.
 *******************************************************************************/

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

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************
#include <string.h>
#include "stdint.h"
#include "ble_trsps/ble_trsps.h"
#include "app_trsps_handler.h"
#include "app_trsps_callbacks.h"

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
<#if APP_THROUGHPUT == true>
APP_TRP_ConnList_T s_trpsConnList_t;
</#if>

void APP_TrspsEvtHandler(BLE_TRSPS_Event_T *p_event)
{
    switch(p_event->eventId)
    {
        case BLE_TRSPS_EVT_CTRL_STATUS:
        {
            /* TODO: implement your application code.*/
<#if APP_THROUGHPUT == true>
            if (s_trpsConnList_t.connHandle == p_event->eventField.onCtrlStatus.connHandle) 
            {
                if (p_event->eventField.onCtrlStatus.status == BLE_TRSPS_STATUS_CTRL_OPENED) 
                {
                    s_trpsConnList_t.trpRole = APP_TRP_SERVER_ROLE;
                    s_trpsConnList_t.channelEn |= APP_TRP_CTRL_CHAN_ENABLE;
                } 
                else 
                {
                    s_trpsConnList_t.trpRole = 0;
                    s_trpsConnList_t.channelEn &= APP_TRP_CTRL_CHAN_DISABLE;
                }
            }
</#if>
        }
        break;
        
        case BLE_TRSPS_EVT_TX_STATUS:
        {
            /* TODO: implement your application code.*/
<#if APP_THROUGHPUT == true>
            if (s_trpsConnList_t.connHandle == p_event->eventField.onTxStatus.connHandle) 
            {
                if (p_event->eventField.onTxStatus.status == BLE_TRSPS_STATUS_TX_OPENED) 
                {
                    if (!(s_trpsConnList_t.channelEn & APP_TRP_DATA_CHAN_ENABLE)) 
                    {
                        uint8_t txPhys = 0, rxPhys = 0, phyOptions = 0;

                        //Update Phy
                        txPhys = BLE_GAP_PHY_OPTION_2M;
                        rxPhys = BLE_GAP_PHY_OPTION_2M;
                        // phyOptions = 0;

                        BLE_GAP_SetPhy(p_event->eventField.onTxStatus.connHandle, txPhys, rxPhys, phyOptions);

                        BLE_DM_ConnParamUpdate_T params;

                        params.intervalMax = 0x10; //20ms
                        params.intervalMin = 0x10; //20ms
                        params.latency = 0;
                        params.timeout = 0x48; //720ms

                        BLE_DM_ConnectionParameterUpdate(p_event->eventField.onTxStatus.connHandle, &params);
                    }

                    s_trpsConnList_t.channelEn |= APP_TRP_DATA_CHAN_ENABLE;
                    s_trpsConnList_t.type = APP_TRP_TYPE_LEGACY;

                } 
                else 
                {
                    s_trpsConnList_t.channelEn &= APP_TRP_DATA_CHAN_DISABLE;

                    if (s_trpsConnList_t.channelEn & APP_TRCBP_DATA_CHAN_ENABLE) {
                        s_trpsConnList_t.type = APP_TRP_TYPE_TRCBP;
                    } 
                    else 
                    {
                        s_trpsConnList_t.type = APP_TRP_TYPE_UNKNOWN;
                    }
                }
            }
</#if>
        }
        break;

        case BLE_TRSPS_EVT_CBFC_ENABLED:
        {
            /* TODO: implement your application code.*/
        }
        break;
        
        case BLE_TRSPS_EVT_CBFC_CREDIT:
        {
            /* TODO: implement your application code.*/
        }
        break;
        
        case BLE_TRSPS_EVT_RECEIVE_DATA:
        {
            /* TODO: implement your application code.*/
            <#if booleanappcode ==  true> 

            uint16_t dataLen;
            uint8_t *p_data;
            // Retrieve received data length
            BLE_TRSPS_GetDataLength(p_event->eventField.onReceiveData.connHandle, &dataLen);
            if(dataLen>0)
            {
                // Allocate memory according to data length
                p_data = OSAL_Malloc(dataLen);
                if(p_data == NULL)
                    break;
                // Retrieve received data
                BLE_TRSPS_GetData(p_event->eventField.onReceiveData.connHandle, p_data);
                // Output received data to UART
                APP_WLS_TRPS_DataReceived(p_event->eventField.onReceiveData.connHandle, dataLen, p_data);
                // Free memory
                OSAL_Free(p_data);
            }

            </#if>    
                  
        }
        break;
        
        case BLE_TRSPS_EVT_VENDOR_CMD:
        {
            /* TODO: implement your application code.*/
<#if APP_THROUGHPUT == true>
            if ((s_trpsConnList_t.connHandle == p_event->eventField.onVendorCmd.connHandle)
                    && (p_event->eventField.onVendorCmd.p_payLoad[0] == APP_TRP_VENDOR_OPCODE_BLE_UART))
                APP_WLS_TRPS_VendorCmdProc(&s_trpsConnList_t, p_event->eventField.onVendorCmd.p_payLoad);
</#if>
        }
        break;

        case BLE_TRSPS_EVT_ERR_UNSPECIFIED:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case BLE_TRSPS_EVT_ERR_NO_MEM:
        {
            /* TODO: implement your application code.*/
        }
        break;

       default:
        break;
    }
}
