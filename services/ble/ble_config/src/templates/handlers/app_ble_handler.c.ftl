/*******************************************************************************
  Application BLE Source File

  Company:
    Microchip Technology Inc.

  File Name:
    app_ble_handler.c

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
#include <stdint.h>
#include "osal/osal_freertos_extend.h"
#include "app_ble_handler.h"
#include "app_ble_callbacks.h"
<#if booleanappcode ==  true>
<#if wlsbleanpss?? &&  wlsbleanpss.ANPSS_BOOL_CLIENT == true>
#include "app_anpc_callbacks.h"
</#if>
</#if>
<#if booleanappcode ==  true>
<#if wlsblehogp?? && wlsblehogp.HOGP_BOOL_SERVER == true>
#include "ble_hids/ble_hids.h"
#include "app_hogps_callbacks.h"
#include "device_deep_sleep.h"
#include "app_conn.h"
</#if>
<#-- For central multilink configuration --> 
<#if wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_CLIENT == true &&  WLS_BLE_GAP_CENTRAL == true && WLS_BLE_GAP_SCAN == true && !( wlsbletrspss.SS_TRSP_BOOL_SERVER == true) && (numberoflinks == 2 || numberoflinks == 3)> 
#include "ble_trspc/ble_trspc.h"
</#if>
<#-- For central_trp_uart --> 
<#if WLS_BLE_GAP_CENTRAL == true  && WLS_BLE_GAP_SCAN == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_CLIENT == true && WLS_BLE_BOOL_GAP_EXT_SCAN == false>  
#include "ble_trspc/ble_trspc.h"
</#if>
<#-- For central_trp_codedPhy --> 
<#if WLS_BLE_GAP_CENTRAL == true  && WLS_BLE_GAP_SCAN == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_CLIENT == true  && WLS_BLE_BOOL_GAP_EXT_SCAN == true && WLS_BLE_GAP_EXT_SCAN_PHY == "2">  
#include "ble_trspc/ble_trspc.h"
</#if>
</#if>
<#lt>${LIST_BLE_HANDLER_APP_INCLUDE}


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
void APP_BleGapEvtHandler(BLE_GAP_Event_T *p_event)
{
<#if booleanappcode ==  true>
<#if wlsbleanpss?? &&  wlsbleanpss.ANPSS_BOOL_CLIENT == true>
    APP_ANPC_ConnList_T *p_conn = NULL;  
</#if>
</#if>

    switch(p_event->eventId)
    {
        case BLE_GAP_EVT_CONNECTED:
        {
            /* TODO: implement your application code.*/
            APP_WLS_BLE_DeviceConnected(&(p_event->eventField.evtConnect));

        }
        break;
        case BLE_GAP_EVT_DISCONNECTED:
        {
            /* TODO: implement your application code.*/

            APP_WLS_BLE_DeviceDisconnected(&(p_event->eventField.evtDisconnect));

        }
        break;

        case BLE_GAP_EVT_CONN_PARAM_UPDATE:
        {
<#if booleanappcode ==  true>
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true && WLS_BLE_BOOL_GAP_EXT_ADV == false && WLS_BLE_GAP_DSADV_EN == false && WLS_BLE_BOOL_L2CAP_CREDIT_FLOWCTRL == true> 
            APP_BLE_ConnList_T *p_bleConn = NULL;
            /* TODO: implement your application code.*/
            uint8_t updateStatus = APP_RES_SUCCESS;
            /* Update the connection parameter */
            if (p_event->eventField.evtConnParamUpdate.status == 0) 
            {
            // APP_BLE_ConnList_T *p_bleConn = NULL;

                p_bleConn = APP_WLS_BLE_GetConnInfoByConnHandle(p_event->eventField.evtConnParamUpdate.connHandle);

                if (p_bleConn) 
                {
                    p_bleConn->connData.handle = p_event->eventField.evtConnParamUpdate.connHandle;
                    p_bleConn->connData.connInterval = p_event->eventField.evtConnParamUpdate.connParam.intervalMin;
                    p_bleConn->connData.connLatency = p_event->eventField.evtConnParamUpdate.connParam.latency;
                    p_bleConn->connData.supervisionTimeout = p_event->eventField.evtConnParamUpdate.connParam.supervisionTimeout;
                }
            } 
            else 
            {
                updateStatus = APP_RES_FAIL;
            }

            APP_WLS_TRPS_SendUpConnParaStatusToClient(p_event->eventField.evtConnParamUpdate.connHandle, updateStatus);   
</#if>
</#if>   
        }
        break;

        case BLE_GAP_EVT_ENCRYPT_STATUS:
        {
            
            /* TODO: implement your application code.*/

<#if booleanappcode ==  true>
<#if wlsbleanpss?? &&  wlsbleanpss.ANPSS_BOOL_CLIENT == true>
            APP_ANPC_ConnList_T *p_conn = NULL;
            if (p_event->eventField.evtEncryptStatus.status == GAP_STATUS_SUCCESS)
            {
                p_conn = APP_WLS_ANPC_GetConnListByHandle(p_event->eventField.evtEncryptStatus.connHandle);
                if (p_conn == NULL)
                { 
                    return;
                }
                if (p_conn->bDiscovered == true)
                {
                    APP_WLS_ANPC_EnableCccd(p_event->eventField.evtEncryptStatus.connHandle, true);
                }
            }
</#if>
</#if>
<#if booleanappcode ==  true>
<#if wlsbleanpss?? &&  wlsbleanpss.ANPSS_BOOL_SERVER == true>
            APP_ANPS_ConnList_T *p_conn = NULL;
            if (p_event->eventField.evtEncryptStatus.status == GAP_STATUS_PIN_KEY_MISSING)
            {
                BLE_DM_ProceedSecurity(p_event->eventField.evtEncryptStatus.connHandle, 1);
                p_conn = APP_WLS_ANPS_GetConnListByHandle(p_event->eventField.evtEncryptStatus.connHandle);
                if (p_conn == NULL)
                { 
                return;
                }
                p_conn->bSecurityStatus = true;
            }    

</#if>
</#if>
<#if booleanappcode ==  true>
<#if wlsblepxpss?? &&  wlsblepxpss.SS_PXP_BOOL_CLIENT == true>
            APP_PXPM_ConnList_T *p_conn = NULL;
                if (p_event->eventField.evtEncryptStatus.status == GAP_STATUS_PIN_KEY_MISSING)
                {
                    BLE_DM_ProceedSecurity(p_event->eventField.evtEncryptStatus.connHandle, 1);
                    p_conn = APP_WLS_PXPM_GetConnListByHandle(p_event->eventField.evtEncryptStatus.connHandle);
                    if (p_conn == NULL)
                    { 
                        return;
                    }
                    p_conn ->bSecurityStatus = true;
                }   
</#if>
</#if>

<#if booleanappcode ==  true>
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true && WLS_BLE_BOOL_GAP_EXT_ADV == false && WLS_BLE_GAP_DSADV_EN == false && WLS_BLE_BOOL_L2CAP_CREDIT_FLOWCTRL == true> 
 APP_BLE_ConnList_T *p_bleConn = NULL;
        p_bleConn = APP_WLS_BLE_GetConnInfoByConnHandle(p_event->eventField.evtEncryptStatus.connHandle);

        if (p_event->eventField.evtEncryptStatus.status != GAP_STATUS_SUCCESS) {
            BLE_GAP_Disconnect(p_event->eventField.evtEncryptStatus.connHandle, GAP_DISC_REASON_REMOTE_TERMINATE);
        }

        if (p_bleConn) 
        {
            /* Set Encryption */
            if (p_event->eventField.evtEncryptStatus.status == GAP_STATUS_SUCCESS) 
            {
                p_bleConn->secuData.encryptionStatus = 1; //enable
            } 
            else 
            {
                p_bleConn->secuData.encryptionStatus = 0; //disable
            }
        }
</#if>
</#if>
        }
        break;

        case BLE_GAP_EVT_ADV_REPORT:
        {
            /* TODO: implement your application code.*/
            APP_WLS_BLE_AdvertisementReportReceived(&(p_event->eventField.evtAdvReport));
        }
        break;

        case BLE_GAP_EVT_ENC_INFO_REQUEST:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case BLE_GAP_EVT_REMOTE_CONN_PARAM_REQUEST:
        {
            /* TODO: implement your application code.*/
           
        }
        break;

        case BLE_GAP_EVT_EXT_ADV_REPORT:
        {
            /* TODO: implement your application code.*/
            APP_WLS_BLE_ExtendedAdvertisementReportReceived(&(p_event->eventField.evtExtAdvReport));

        }
        break;

        case BLE_GAP_EVT_ADV_TIMEOUT:
        {
            /* TODO: implement your application code.*/
            APP_WLS_BLE_AdvertisementTimedOut();
        }
        break;

        case BLE_GAP_EVT_TX_BUF_AVAILABLE:
        {
        /* TODO: implement your application code.*/

<#if booleanappcode ==  true>
<#if wlsbleanpss?? &&  wlsbleanpss.ANPSS_BOOL_CLIENT == true>
            p_conn = APP_WLS_ANPC_GetConnListByHandle(p_event->eventField.evtTxBufAvailable.connHandle);
            if (p_conn == NULL)
            { 
                return;
            }
            if (p_conn->bEnableCccdRetry == true)
            {
                APP_WLS_ANPC_EnableCccd(p_event->eventField.evtTxBufAvailable.connHandle, p_conn->bCccdEnable);
            }
</#if>
</#if>
<#if booleanappcode ==  true>
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true && WLS_BLE_BOOL_GAP_EXT_ADV == false && WLS_BLE_GAP_DSADV_EN == false && WLS_BLE_BOOL_L2CAP_CREDIT_FLOWCTRL == true> 

            APP_WLS_TRPS_TxBufValidEvtProc();
</#if>
</#if>   
        }
        break;

        case BLE_GAP_EVT_DEVICE_NAME_CHANGED:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case BLE_GAP_EVT_AUTH_PAYLOAD_TIMEOUT:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case BLE_GAP_EVT_PHY_UPDATE:
        {
            /* TODO: implement your application code.*/
<#if booleanappcode ==  true>
<#if WLS_BLE_GAP_PERIPHERAL == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true && WLS_BLE_BOOL_GAP_EXT_ADV == true && WLS_BLE_GAP_PRI_ADV_PHY == "1" && WLS_BLE_GAP_SEC_ADV_PHY == "2">
		     SYS_DEBUG_PRINT(SYS_ERROR_INFO,"\r\nBLE_GAP_EVT_PHY_UPDATE:\r\n");
            
             SYS_DEBUG_PRINT(SYS_ERROR_INFO,"tx_phy: ");
            SYS_CONSOLE_PRINT_PHY(p_event->eventField.evtPhyUpdate.txPhy);

             SYS_DEBUG_PRINT(SYS_ERROR_INFO,"rx_phy: ");
            SYS_CONSOLE_PRINT_PHY(p_event->eventField.evtPhyUpdate.rxPhy);
</#if>
<#if WLS_BLE_GAP_CENTRAL == true  && WLS_BLE_GAP_SCAN == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_CLIENT == true  && WLS_BLE_BOOL_GAP_EXT_SCAN == true && WLS_BLE_GAP_EXT_SCAN_PHY == "2">
             SYS_DEBUG_PRINT(SYS_ERROR_INFO,"\r\nBLE_GAP_EVT_PHY_UPDATE:\r\n");
            
             SYS_DEBUG_PRINT(SYS_ERROR_INFO,"tx_phy: ");
            SYS_CONSOLE_PRINT_PHY(p_event->eventField.evtPhyUpdate.txPhy);

             SYS_DEBUG_PRINT(SYS_ERROR_INFO,"rx_phy: ");
            SYS_CONSOLE_PRINT_PHY(p_event->eventField.evtPhyUpdate.rxPhy);
</#if>
</#if>
        }
        break;

        case BLE_GAP_EVT_SCAN_REQ_RECEIVED:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case BLE_GAP_EVT_DIRECT_ADV_REPORT:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case BLE_GAP_EVT_PERI_ADV_SYNC_EST:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case BLE_GAP_EVT_PERI_ADV_REPORT:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case BLE_GAP_EVT_PERI_ADV_SYNC_LOST:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case BLE_GAP_EVT_ADV_SET_TERMINATED:
        {
            /* TODO: implement your application code.*/

<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && !wlsbletrspss?? && WLS_BLE_BOOL_GAP_EXT_ADV == true && WLS_BLE_GAP_DSADV_EN == false && WLS_BLE_GAP_EXT_ADV_ADV_SET_2 == true>
            ${WLS_BLE_COMMENT}
             SYS_DEBUG_PRINT(SYS_ERROR_INFO,"BLE_GAP_EVT_ADV_SET_TERMINATED!\r\n");
</#if>
        }
        break;

        case BLE_GAP_EVT_SCAN_TIMEOUT:
        {
            /* TODO: implement your application code.*/
            APP_WLS_BLE_ScanTimedOut();
        }
        break;

        case BLE_GAP_EVT_TRANSMIT_POWER_REPORTING:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case BLE_GAP_EVT_ADV_COMPL:
        {
            /* TODO: implement your application code.*/
            APP_WLS_BLE_AdvertisementCompleted();

        }
        break;

        case BLE_GAP_EVT_PATH_LOSS_THRESHOLD:
        {
            /* TODO: implement your application code.*/

            APP_WLS_BLE_PathLossThresholdReceived(&(p_event->eventField.evtPathLossThreshold));
        }
        break;

        default:
        break;
    }
<#lt>${LIST_GAP_EVT_HANDLER_APP_HANDLER}
}
<#if BLE_STACK_LIB.GAP_CENTRAL == true || BLE_STACK_LIB.GAP_PERIPHERAL == true>
void APP_BleL2capEvtHandler(BLE_L2CAP_Event_T *p_event)
{
    switch(p_event->eventId)
    {
        case BLE_L2CAP_EVT_CONN_PARA_UPD_REQ:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case BLE_L2CAP_EVT_CONN_PARA_UPD_RSP:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case BLE_L2CAP_EVT_CB_CONN_IND:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case BLE_L2CAP_EVT_CB_CONN_FAIL_IND:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case BLE_L2CAP_EVT_CB_SDU_IND:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case BLE_L2CAP_EVT_CB_ADD_CREDITS_IND:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case BLE_L2CAP_EVT_CB_DISC_IND:
        {
            /* TODO: implement your application code.*/
        }
        break;        

        default:
        break;
    }
}

void APP_GattEvtHandler(GATT_Event_T *p_event)
{   
    switch(p_event->eventId)
    {
        case GATTC_EVT_ERROR_RESP:
        {
        /* TODO: implement your application code.*/

<#if booleanappcode ==  true>
<#if wlsbleanpss?? && wlsbleanpss.ANPSS_BOOL_CLIENT == true>
           if ((p_event->eventField.onError.errCode == ATT_ERR_INSUF_ENC) || (p_event->eventField.onError.errCode == ATT_ERR_INSUF_AUTHN))
            {
				BLE_DM_ProceedSecurity(p_event->eventField.onError.connHandle, 0);
            }
</#if>
</#if>

<#if booleanappcode ==  true>
<#if wlsblepxpss?? && wlsblepxpss.SS_PXP_BOOL_CLIENT == true>
    switch(p_event->eventField.onError.errCode)
            {
            case ATT_ERR_INSUF_AUTHN:
            case ATT_ERR_INSUF_ENC:
            {
                BLE_DM_ProceedSecurity(p_event->eventField.onError.connHandle, false);
            }
            break;
            default:
            {
            }
            break;
            } 
</#if>
</#if>
        }
        break;

        case GATTC_EVT_DISC_PRIM_SERV_RESP:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case GATTC_EVT_DISC_PRIM_SERV_BY_UUID_RESP:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case GATTC_EVT_DISC_CHAR_RESP:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case GATTC_EVT_DISC_DESC_RESP:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case GATTC_EVT_READ_USING_UUID_RESP:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case GATTC_EVT_READ_RESP:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case GATTC_EVT_WRITE_RESP:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case GATTC_EVT_HV_NOTIFY:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case GATTC_EVT_HV_INDICATE:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case GATTS_EVT_READ:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case GATTS_EVT_WRITE:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case GATTS_EVT_HV_CONFIRM:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case ATT_EVT_TIMEOUT:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case ATT_EVT_UPDATE_MTU:
        {
            /* TODO: implement your application code.*/
<#if booleanappcode ==  true>
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true && WLS_BLE_BOOL_GAP_EXT_ADV == false && WLS_BLE_GAP_DSADV_EN == false && WLS_BLE_BOOL_L2CAP_CREDIT_FLOWCTRL == true> 
            APP_WLS_TRPS_UpdateMtuEvtProc(p_event->eventField.onUpdateMTU.connHandle,p_event->eventField.onUpdateMTU.exchangedMTU);
</#if>
</#if>
        }
        break;

        case GATTC_EVT_DISC_CHAR_BY_UUID_RESP:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case GATTS_EVT_SERVICE_CHANGE:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case GATTS_EVT_CLIENT_FEATURE_CHANGE:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case GATTS_EVT_CLIENT_CCCDLIST_CHANGE:
        {
            /* TODO: implement your application code.*/
<#if booleanappcode ==  true>
<#if wlsblehogp?? && wlsblehogp.HOGP_BOOL_SERVER == true>
            g_PairedDevGattInfo.serviceChange=GATT_DB_CHANGE_AWARE; //Currently no Characteristic: Service Changed in GATT Service
            g_PairedDevGattInfo.clientSupportFeature=APP_BLE_CLIENT_SUPPORT_FEATURE_NULL;          //Currently no Characteristic: Client Supported Features in GATT Service
            g_PairedDevGattInfo.numOfCccd=p_event->eventField.onClientCccdListChange.numOfCccd;
            memcpy((uint8_t *)g_PairedDevGattInfo.cccdList, (uint8_t *)p_event->eventField.onClientCccdListChange.p_cccdList, (g_PairedDevGattInfo.numOfCccd*sizeof(GATTS_CccdList_T)));
            APP_WLS_BLE_SetPairedDevGattInfoInFlash(&g_PairedDevGattInfo);
</#if> 
</#if> 
            OSAL_Free(p_event->eventField.onClientCccdListChange.p_cccdList);
        }
        break;

        case GATTC_EVT_PROTOCOL_AVAILABLE:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case GATTS_EVT_PROTOCOL_AVAILABLE:
        {
            /* TODO: implement your application code.*/
        }
        break;

        default:
        break;        
    }

<#lt>${LIST_GATT_EVT_HANDLER_APP_HANDLER}
}

 
void APP_BleSmpEvtHandler(BLE_SMP_Event_T *p_event)
{
  
    switch(p_event->eventId)
    {
        case BLE_SMP_EVT_PAIRING_COMPLETE:
        {
            /* TODO: implement your application code.*/
<#if booleanappcode ==  true>
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true && WLS_BLE_BOOL_GAP_EXT_ADV == false && WLS_BLE_GAP_DSADV_EN == false && WLS_BLE_BOOL_L2CAP_CREDIT_FLOWCTRL == true> 
            if (p_event->eventField.evtPairingComplete.status != BLE_SMP_PAIRING_SUCCESS) 
            {
                BLE_GAP_Disconnect(p_event->eventField.evtPairingComplete.connHandle, GAP_DISC_REASON_REMOTE_TERMINATE);
            }
</#if>
</#if>
        }
        break;

        case BLE_SMP_EVT_SECURITY_REQUEST:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case BLE_SMP_EVT_NUMERIC_COMPARISON_CONFIRM_REQUEST:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case BLE_SMP_EVT_INPUT_PASSKEY_REQUEST:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case BLE_SMP_EVT_DISPLAY_PASSKEY_REQUEST:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case BLE_SMP_EVT_NOTIFY_KEYS:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case BLE_SMP_EVT_PAIRING_REQUEST:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case BLE_SMP_EVT_INPUT_OOB_DATA_REQUEST:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case BLE_SMP_EVT_INPUT_SC_OOB_DATA_REQUEST:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case BLE_SMP_EVT_KEYPRESS:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case BLE_SMP_EVT_GEN_SC_OOB_DATA_DONE:
        {
            /* TODO: implement your application code.*/
        }
        break;

        default:
        break;        
    }
}
 
void APP_DmEvtHandler(BLE_DM_Event_T *p_event)
{
    switch(p_event->eventId)
    {
        case BLE_DM_EVT_DISCONNECTED:
        {
            /* TODO: implement your application code.*/
            APP_WLS_BLE_PairedDeviceDisconnected(p_event);
        }
        break;

        case BLE_DM_EVT_CONNECTED:
        {
            /* TODO: implement your application code.*/
            APP_WLS_BLE_PairedDeviceConnected(p_event);
        }
        break;

        case BLE_DM_EVT_SECURITY_START:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case BLE_DM_EVT_SECURITY_SUCCESS:
        {
            /* TODO: implement your application code.*/
<#if booleanappcode ==  true>
<#if wlsblepxpss?? && wlsblepxpss.SS_PXP_BOOL_CLIENT == true>
            if(p_event->eventField.evtSecuritySuccess.procedure == DM_SECURITY_PROC_ENCRYPTION)
                {
                    APP_WLS_PXPM_ReissueService();
                }
</#if>
</#if>
        }
        break;

        case BLE_DM_EVT_SECURITY_FAIL:
        {
            /* TODO: implement your application code.*/
<#if booleanappcode ==  true>
<#if wlsblehogp?? && wlsblehogp.HOGP_BOOL_SERVER == true>
            APP_LED_BLUE_OFF
            APP_LED_RED_ON
</#if>
</#if>
        }
        break;

        case BLE_DM_EVT_PAIRED_DEVICE_FULL:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case BLE_DM_EVT_PAIRED_DEVICE_UPDATED:
        {
            /* TODO: implement your application code.*/
<#if booleanappcode ==  true>
<#if (wlsbleancsss?? && wlsbleancsss.SS_ANCS_BOOL_CLIENT == true) || (wlsblehogp?? && wlsblehogp.HOGP_BOOL_SERVER == true)>
            BLE_DM_PairedDevInfo_T  *p_devInfo;

            g_pairedDevInfo.bPaired=true;
            p_devInfo = OSAL_Malloc(sizeof(BLE_DM_PairedDevInfo_T));
            if (p_devInfo)
            {
                if (BLE_DM_GetPairedDevice(p_event->peerDevId, p_devInfo) == MBA_RES_SUCCESS)
                {
                    g_pairedDevInfo.bAddrLoaded=true;
                    memcpy(&g_pairedDevInfo.addr, &p_devInfo->remoteAddr, sizeof(BLE_GAP_Addr_T));

                    //Remove previous pairing data, store new pairing data(actually APP only stores peerDevId, pairing data has been stored by DM already)
                    if (g_pairedDevInfo.bPeerDevIdExist)
                    {
                        if (g_pairedDevInfo.peerDevId != p_event->peerDevId)
                        {
                            BLE_DM_DeletePairedDevice(g_pairedDevInfo.peerDevId);
                        }
                    }
                    else
                    {
                        g_pairedDevInfo.bPeerDevIdExist=true;
                    }
                    g_pairedDevInfo.peerDevId =p_event->peerDevId;

                    //Write extended Paired Device info once Paired Device info finished the writing in flash.
                    APP_WLS_BLE_SetExtPairedDevInfoInFlash(&g_extPairedDevInfo);
                }
                else
                {
                    //Should not happen
                    g_pairedDevInfo.bAddrLoaded=false;
                }
                OSAL_Free(p_devInfo);
            }
</#if>
<#if wlsbleanpss?? && wlsbleanpss.ANPSS_BOOL_CLIENT == true>
            BLE_DM_PairedDevInfo_T  *p_devInfo;

            p_devInfo = OSAL_Malloc(sizeof(BLE_DM_PairedDevInfo_T));
            if (p_devInfo != NULL)
            {
                if (BLE_DM_GetPairedDevice(p_event->peerDevId, p_devInfo) == MBA_RES_SUCCESS)
                {
                    //There is previous pairing data
                    if (g_ctrlInfo.peerDevId < BLE_DM_MAX_PAIRED_DEVICE_NUM)
                    {
                        //Paired with different device from previous paired device, delete previous pairing data
                        if (g_ctrlInfo.peerDevId != p_event->peerDevId)
                        {
                            BLE_DM_DeletePairedDevice(g_ctrlInfo.peerDevId);
                        }
                    }
                    g_ctrlInfo.peerDevId =p_event->peerDevId;
                }
                else
                {
                    /* TODO: implement your application code.*/
                }
                OSAL_Free(p_devInfo);
            }
</#if>
<#if wlsbleanpss?? &&  wlsbleanpss.ANPSS_BOOL_SERVER == true>
            BLE_DM_PairedDevInfo_T  *p_devInfo;

            p_devInfo = OSAL_Malloc(sizeof(BLE_DM_PairedDevInfo_T));
            if (p_devInfo != NULL)
            {
                if (BLE_DM_GetPairedDevice(p_event->peerDevId, p_devInfo) == MBA_RES_SUCCESS)
                {
                    //There is previous pairing data
                    if (g_ctrlInfo.peerDevId < BLE_DM_MAX_PAIRED_DEVICE_NUM)
                    {
                        //Paired with different device from previous paired device, delete previous pairing data
                        if (g_ctrlInfo.peerDevId != p_event->peerDevId)
                        {
                            BLE_DM_DeletePairedDevice(g_ctrlInfo.peerDevId);
                        }
                    }
                    g_ctrlInfo.peerDevId =p_event->peerDevId;
                }
                else
                {
                    /* TODO: implement your application code.*/
                }
                OSAL_Free(p_devInfo);
            }
</#if>
<#if wlsblepxpss?? && wlsblepxpss.SS_PXP_BOOL_CLIENT == true>
            BLE_DM_PairedDevInfo_T  *p_devInfo;
            p_devInfo = OSAL_Malloc(sizeof(BLE_DM_PairedDevInfo_T));
            if (p_devInfo != NULL)
            {
                if (BLE_DM_GetPairedDevice(p_event->peerDevId, p_devInfo) == MBA_RES_SUCCESS)
                {
                    //There is previous pairing data
                    if (g_ctrlInfo.peerDevId < BLE_DM_MAX_PAIRED_DEVICE_NUM)
                    {
                        //Paired with different device from previous paired device, delete previous pairing data
                        if (g_ctrlInfo.peerDevId != p_event->peerDevId)
                        {
                            BLE_DM_DeletePairedDevice(g_ctrlInfo.peerDevId);
                        }
                    }
                    g_ctrlInfo.peerDevId =p_event->peerDevId;
                }
                else
                {
                    /* TODO: implement your application code.*/
                }
                OSAL_Free(p_devInfo);
            }
</#if>
<#if wlsblepxpss?? && wlsblepxpss.SS_PXP_BOOL_SERVER == true>
            BLE_DM_PairedDevInfo_T  *p_devInfo;

            p_devInfo = OSAL_Malloc(sizeof(BLE_DM_PairedDevInfo_T));
            if (p_devInfo != NULL)
            {
                if (BLE_DM_GetPairedDevice(p_event->peerDevId, p_devInfo) == MBA_RES_SUCCESS)
                {
                   
                    if (g_ctrlInfo.peerDevId < BLE_DM_MAX_PAIRED_DEVICE_NUM)
                    {
                        //Paired with different device from previous paired device, delete previous pairing data
                        if (g_ctrlInfo.peerDevId != p_event->peerDevId)
                        {
                            BLE_DM_DeletePairedDevice(g_ctrlInfo.peerDevId);
                        }
                    }
                    g_ctrlInfo.peerDevId =p_event->peerDevId;
                }
                else
                {
                   
                }
                OSAL_Free(p_devInfo);
            }
</#if>
</#if>
        }
        break;

        case BLE_DM_EVT_CONN_UPDATE_SUCCESS:
        {
            /* TODO: implement your application code.*/
        }
        break;

        case BLE_DM_EVT_CONN_UPDATE_FAIL:
        {
            /* TODO: implement your application code.*/
        }
        break;

        default:
        break;
    }
}
<#if BLE_STACK_LIB.BLE_BOOL_GATT_CLIENT == true>
void APP_DdEvtHandler(BLE_DD_Event_T *p_event)
{
<#if BLE_STACK_LIB.BOOL_GCM_SCM == true>
    BLE_SCM_BleDdEventHandler(p_event);
</#if>
<#if BLE_STACK_LIB.APP_TRSP_CLIENT == true>
    BLE_TRSPC_BleDdEventHandler(p_event);
</#if>
<#if BLE_STACK_LIB.APP_OTAP_CLIENT == true>
    BLE_OTAPC_BleDdEventHandler(p_event);
</#if>
<#if BLE_STACK_LIB.APP_PXP_CLIENT == true>
    BLE_PXPM_BleDdEventHandler(p_event);
</#if>
<#if BLE_STACK_LIB.APP_ANP_CLIENT == true>
    BLE_ANPC_BleDdEventHandler(p_event);
</#if>
<#if BLE_STACK_LIB.APP_ANCS_CLIENT == true>
    BLE_ANCS_BleDdEventHandler(p_event);
</#if>
}

<#if BLE_STACK_LIB.BOOL_GCM_SCM == true>
void APP_ScmEvtHandler(BLE_SCM_Event_T *p_event)
{
    if (p_event->eventId == BLE_SCM_EVT_SVC_CHANGE)
    {
        BLE_DD_RestartServicesDiscovery(p_event->eventField.evtServiceChange.connHandle);
    }

    /* TODO: implement your application state machine.*/
}
</#if>
</#if>
</#if>
    
