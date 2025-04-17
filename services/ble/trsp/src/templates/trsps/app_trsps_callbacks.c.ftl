<#assign APP_THROUGHPUT = false>
<#if wlsbleconfig?? &&  wlsbleconfig.WLS_BLE_GAP_PERIPHERAL == true && 
    wlsbleconfig.WLS_BLE_GAP_ADVERTISING == true && 
    SS_TRSP_BOOL_SERVER == true && 
    wlsbleconfig.WLS_BLE_BOOL_GAP_EXT_ADV == false && 
    wlsbleconfig.WLS_BLE_GAP_DSADV_EN == false && 
    wlsbleconfig.WLS_BLE_BOOL_L2CAP_CREDIT_FLOWCTRL == true> 
<#assign APP_THROUGHPUT = true>
</#if>
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
    app_trsps_callbacks.c

  Summary:
    This file contains API functions for the user to implement his business logic.

  Description:
    API functions for the user to implement his business logic.
*******************************************************************************/

#include "definitions.h" 
#include "app_trsps_callbacks.h"
<#if APP_THROUGHPUT == true>
#include "app_trsps_handler.h"
#include "app_trp_common.h"

// *****************************************************************************
// *****************************************************************************
// Section: Macros
// *****************************************************************************
// *****************************************************************************


// *****************************************************************************
// *****************************************************************************
// Section: Data Types
// *****************************************************************************
// *****************************************************************************


// *****************************************************************************
// *****************************************************************************
// Section: Global Variables
// *****************************************************************************
// *****************************************************************************


// *****************************************************************************
// *****************************************************************************
// Section: Local Variables
// *****************************************************************************
// *****************************************************************************

// *****************************************************************************
// *****************************************************************************
// Section: Function Prototypes
// *****************************************************************************
// *****************************************************************************


uint32_t APP_WLS_TRPS_CalculateCheckSum(uint32_t checkSum, uint32_t *totalDataLeng, APP_TRP_ConnList_T *p_connList_t, uint16_t dataLen,uint8_t *p_rxData) 
{
    uint16_t tmpLeng, status;
    uint32_t i;
    uint8_t *p_data = NULL;
    tmpLeng = dataLen;
    p_data = p_rxData;

    if (((*totalDataLeng) == 0) || (p_connList_t == NULL))
        return checkSum;

    while (tmpLeng > 0) {
        if (p_data != NULL) 
        {
            for (i = 0; i < tmpLeng; i++)
                checkSum += p_data[i];
            if ((*totalDataLeng) > tmpLeng)
                *totalDataLeng -= tmpLeng;
            else
                *totalDataLeng = 0;
            OSAL_Free(p_data);
            p_data = NULL;
            if ((*totalDataLeng) == 0)
                break;
            status = APP_WLS_TRP_GetTrpDataLength(p_connList_t, &tmpLeng);
            if (status != APP_RES_SUCCESS)
            {
                return checkSum;
            }
            else
            {
                if (tmpLeng > 0)
                {
                    status = APP_WLS_TRP_GetTrpData(p_connList_t, p_data);
                    if (status != APP_RES_SUCCESS) 
                    {
                        break;
                    }
                }
            }
        } 
        else
        {
            return checkSum;
        }
    }

    //Start a timer then reset the timer every time the device receives the data
    //If timeout occurs, send out current checksum directly.
    if (*totalDataLeng != 0) 
    {
        APP_WLS_TRP_SetTimer(APP_TRP_TMR_ID_INST_MERGE(APP_TIMER_PROTOCOL_RSP_01, 0),
                (void *) p_connList_t, APP_TIMER_3S, false, &(p_connList_t->protocolRspTmr));
    }

    return checkSum;
}

uint16_t APP_WLS_TRPS_SendLeDataCircQueue(APP_TRP_ConnList_T *p_connList_t,uint16_t leDataLen,uint8_t *p_rxData) {
    APP_TRP_LeCircQueue_T *p_leCircQueue_t = &(p_connList_t->leCircQueue_t);
    APP_UTILITY_QueueElem_T *p_queueElem_t = NULL;
   
    uint16_t status = APP_RES_SUCCESS, dataLeng;
    uint8_t validNum = APP_TRP_MAX_TRANSMIT_NUM, *p_data = NULL;
    
    dataLeng = leDataLen;
    p_data = p_rxData;

    if (p_connList_t == NULL)
        return APP_RES_INVALID_PARA;

    while (validNum > 0) 
    {
        p_queueElem_t = APP_WLS_TRP_GetElemLeCircQueue(p_leCircQueue_t);

        if (p_queueElem_t != NULL) 
        {
            if ((p_queueElem_t->dataLeng != 0) && (p_queueElem_t->p_data != NULL)) 
            {
                status = APP_WLS_TRP_SendLeData(p_connList_t, p_queueElem_t->dataLeng, p_queueElem_t->p_data);
                if (status == APP_RES_SUCCESS) 
                {
                    APP_WLS_TRP_FreeElemLeCircQueue(p_leCircQueue_t);
                    validNum--;
                } 
                else 
                {
                    // drop the data!
                    SYS_CONSOLE_PRINT("LE Tx error: status=0x%x\r\n", status);
                    APP_WLS_TRP_FreeElemLeCircQueue(p_leCircQueue_t);
                }
            } 
            else 
            {
                APP_WLS_TRP_FreeElemLeCircQueue(p_leCircQueue_t);
                validNum--;
            }
        } 
        else 
        {
            if (p_data != NULL) 
            {
                if (p_data[0] < 0)
                {
                    OSAL_Free(p_data);
//                    p_data != NULL;
                    validNum--; 
                }
                else
                {
                    status = APP_WLS_TRP_SendLeData(p_connList_t, dataLeng, p_data);

                    if (status == APP_RES_SUCCESS) 
                    {
                        OSAL_Free(p_data);
                        p_data = NULL;
                        validNum--;
                    } 
                    else 
                    {
                        if ((status == APP_RES_NO_RESOURCE) || (status == APP_RES_OOM)) 
                        {
                            if (APP_WLS_TRP_GetValidLeCircQueueNum(p_leCircQueue_t) > 0) 
                            {
                                APP_WLS_TRP_InsertDataToLeCircQueue(dataLeng, p_data, p_leCircQueue_t);
                            } 
                            else 
                            {
                                OSAL_Free(p_data);
                                p_data = NULL;
                            }
                        } 
                        else 
                        {
                            OSAL_Free(p_data);
                            p_data = NULL;
                        }
                        return status;
                    }
                }
            
                status = APP_WLS_TRP_GetTrpDataLength(p_connList_t, &dataLeng);
                if(dataLeng > 0)
                {
                    p_data = OSAL_Malloc(dataLeng);
                    status = APP_WLS_TRP_GetTrpData(p_connList_t, p_data);
                }
                else
                {
                    return status;
                }
            }
            else
            {
               return status; 
            }
        }
    }
    status = APP_WLS_TRP_GetTrpDataLength(p_connList_t, &dataLeng);
    if ((APP_WLS_TRP_GetValidLeCircQueueNum(p_leCircQueue_t) > 0) || ((status == APP_RES_SUCCESS)
            && (dataLeng > 0))) {
        // Set a timer to send residue data.
        APP_WLS_TRP_SetTimer(APP_TRP_TMR_ID_INST_MERGE(APP_TIMER_FETCH_TRP_RX_DATA_02, 0),
                (void *) p_connList_t, APP_TIMER_18MS, false, &(p_connList_t->leTxTmr));
    }
    
    return status;
}

uint16_t APP_WLS_TRPS_GetDataParam(APP_TRP_ConnList_T *p_connList_t,uint16_t *dataLen,uint8_t *p_data)
{

    // Retrieve received data length
    BLE_TRSPS_GetDataLength(p_connList_t->connHandle, dataLen);
    if(dataLen>0)
    {
        // Allocate memory according to data length
        p_data = OSAL_Malloc(*dataLen);
        if(p_data == NULL)
            return APP_RES_FAIL;
        // Retrieve received data
        BLE_TRSPS_GetData(p_connList_t->connHandle, p_data);
        // Free memory     
    }
    return MBA_RES_SUCCESS;
}

void APP_WLS_TRPS_ProcessData(APP_TRP_ConnList_T *p_connList_t,uint16_t dataLen,uint8_t *p_data) 
{
    uint16_t status = APP_RES_FAIL;
    uint8_t grpId[] = {TRP_GRPID_NULL, TRP_GRPID_CHECK_SUM, TRP_GRPID_LOOPBACK, TRP_GRPID_FIX_PATTERN,
        TRP_GRPID_UART, TRP_GRPID_REV_LOOPBACK};

    if (p_connList_t->workModeEn == false) 
    {
        if ((grpId[p_connList_t->workMode] > TRP_GRPID_NULL) && (grpId[p_connList_t->workMode] < TRP_GRPID_UART)) 
        {
            APP_WLS_TRP_SendErrorRsp(p_connList_t, grpId[p_connList_t->workMode]);
        }
    }

    switch (p_connList_t->workMode) 
    {
        case TRP_WMODE_CHECK_SUM:
        {
            p_connList_t->checkSum = APP_WLS_TRPS_CalculateCheckSum(p_connList_t->checkSum,
                    &(p_connList_t->txTotalLeng), p_connList_t, dataLen, p_data);
            if (p_connList_t->txTotalLeng == 0) 
            {
                status = APP_TIMER_StopTimer(&(p_connList_t->protocolRspTmr.tmrHandle));
                if (status != APP_RES_SUCCESS)
                    SYS_CONSOLE_PRINT("APP_TIMER_PROTOCOL_RSP_01 stop error ! result=%d\r\n", status);
                APP_WLS_TRP_SendCheckSumCommand(p_connList_t);
            }
        }
            break;

        case TRP_WMODE_LOOPBACK:
        {
            p_connList_t->srcType = APP_TRP_SRC_TYPE_LE;
            status = APP_WLS_TRPS_SendLeDataCircQueue(p_connList_t, dataLen, p_data);
            if ((status == APP_RES_NO_RESOURCE) || (status == APP_RES_OOM))
            {
                SYS_CONSOLE_PRINT("LB Tx error: status=%d\r\n", status);
            }
        }
            break;

        default:
            break;
    }
}


void APP_WLS_TRPS_VendorCmdProc(APP_TRP_ConnList_T *p_connList_t, uint8_t *p_cmd) {
    uint16_t lastNumber, idx;
    uint8_t groupId, commandId;

    idx = 1;
    groupId = p_cmd[idx++];
    commandId = p_cmd[idx++];
    SYS_CONSOLE_PRINT("Group ID = %d, Command ID = %d \r\n", groupId, commandId);

    switch (groupId) {
        case TRP_GRPID_CHECK_SUM:
        {
            if (commandId == APP_TRP_WMODE_CHECK_SUM_DISABLE) {
                APP_WLS_TRP_SendCheckSumCommand(p_connList_t);
                p_connList_t->workMode = TRP_WMODE_NULL;
            } else if (commandId == APP_TRP_WMODE_CHECK_SUM_ENABLE) {
                p_connList_t->workMode = TRP_WMODE_CHECK_SUM;
                p_connList_t->workModeEn = false;
                p_connList_t->checkSum = 0;
                p_connList_t->txCtrRspFg = 0;

            } else if (commandId == APP_TRP_WMODE_CHECK_SUM) {
                if (p_cmd[idx] == (p_connList_t->checkSum & 0xFF)) {
                    SYS_CONSOLE_PRINT("Check sum = %x. Check sum is correct. \r\n", p_cmd[idx]);
                } else {
                    SYS_CONSOLE_PRINT("Check sum = %x. Check sum is wrong. \r\n", p_cmd[idx]);
                }
            }
        }
            break;

        case TRP_GRPID_LOOPBACK:
        {
            if (commandId == APP_TRP_WMODE_LOOPBACK_DISABLE) {
                p_connList_t->workMode = TRP_WMODE_NULL;
            } else if (commandId == APP_TRP_WMODE_LOOPBACK_ENABLE) {
                p_connList_t->workMode = TRP_WMODE_LOOPBACK;
                p_connList_t->workModeEn = false;
                p_connList_t->txCtrRspFg = 0;
            }
        }
            break;

        case TRP_GRPID_FIX_PATTERN:
        {
            if (commandId == APP_TRP_WMODE_FIX_PATTERN_DISABLE) {
                // Send the last number
                p_connList_t->workMode = TRP_WMODE_NULL;
            } else if (commandId == APP_TRP_WMODE_FIX_PATTERN_ENABLE) {
                p_connList_t->workMode = TRP_WMODE_FIX_PATTERN;
                p_connList_t->workModeEn = false;
                p_connList_t->lastNumber = 0;
                p_connList_t->txCtrRspFg = 0;

            } else if (commandId == APP_TRP_WMODE_TX_LAST_NUMBER) {
                BUF_BE_TO_U16(&(lastNumber), &(p_cmd[idx]));
                if (lastNumber == (p_connList_t->lastNumber - 1)) {
                    SYS_CONSOLE_PRINT("The last number = %x. The last number check is successful !\r\n", lastNumber);
                } else {
                    SYS_CONSOLE_PRINT("The last number = %x. The last number check is fail !\r\n", lastNumber);
                }
                p_connList_t->workMode = TRP_WMODE_NULL;
            } else if (commandId == APP_TRP_WMODE_ERROR_RSP) {
                SYS_CONSOLE_PRINT("Fixed pattern error response! \r\n");
            }
        }
            break;

        case TRP_GRPID_UART:
        {
            //not supported
            if (commandId == APP_TRP_WMODE_UART_ENABLE){
                APP_WLS_TRP_SendErrorRsp(p_connList_t, TRP_GRPID_UART);
                SYS_CONSOLE_PRINT("TRP_GRPID_UART is not supported! \r\n");
            }
        }
            break;

        case TRP_GRPID_TRANSMIT:
        {
            if (commandId == APP_TRP_WMODE_TX_DATA_END) {
                if (p_connList_t->workMode == TRP_WMODE_FIX_PATTERN) {
                    APP_WLS_TRP_SendLastNumber(p_connList_t);
                }
                p_connList_t->workMode = TRP_WMODE_NULL;
                p_connList_t->workModeEn = false;
                APP_WLS_TRP_DelAllLeCircData(&(p_connList_t->leCircQueue_t));
            } else if (commandId == APP_TRP_WMODE_TX_DATA_START) {
                p_connList_t->workModeEn = true;

                if (p_connList_t->workMode == TRP_WMODE_FIX_PATTERN) {
                    // Send the first packet
                    APP_WLS_TRP_InitFixPatternParam(p_connList_t);
                    APP_WLS_TRP_SendFixPatternFirstPkt(p_connList_t);
                }
                break;
            } else if (commandId == APP_TRP_WMODE_TX_DATA_LENGTH) {
                APP_UTILITY_BUF_BE_TO_U32(&(p_connList_t->txTotalLeng), &(p_cmd[idx]));
                SYS_CONSOLE_PRINT("Tx total length = %ld \r\n", p_connList_t->txTotalLeng);
            } else if (commandId == APP_TRP_WMODE_TX_TYPE) {
                p_connList_t->type = p_cmd[idx];

                if (p_connList_t->type == APP_TRP_TYPE_LEGACY)
                    p_connList_t->lePktLeng = p_connList_t->txMTU;
                else if (p_connList_t->channelEn & APP_TRCBP_DATA_CHAN_ENABLE)
                    p_connList_t->lePktLeng = p_connList_t->fixPattTrcbpMtu;
            }
        }
            break;

        case TRP_GRPID_UPDATE_CONN_PARA:
        {
            if (commandId == APP_TRP_WMODE_UPDATE_CONN_PARA) {
#ifndef APP_MIDDLEWARE_ENABLE

                BLE_GAP_ConnParams_T params;

                BUF_BE_TO_U16(&params.intervalMin, &p_cmd[3]);
                BUF_BE_TO_U16(&params.intervalMax, &p_cmd[5]);
                BUF_BE_TO_U16(&params.latency, &p_cmd[7]);
                BUF_BE_TO_U16(&params.supervisionTimeout, &p_cmd[9]);

                /* Validate connection parameters */
                if ((params.intervalMin >= BLE_GAP_CP_MIN_CONN_INTVAL_MIN) && (params.intervalMin <= BLE_GAP_CP_MIN_CONN_INTVAL_MAX) &&
                        (params.intervalMax >= BLE_GAP_CP_MAX_CONN_INTVAL_MIN) && (params.intervalMax <= BLE_GAP_CP_MAX_CONN_INTVAL_MAX) &&
                        (params.latency >= BLE_GAP_CP_LATENCY_MIN) && (params.latency <= BLE_GAP_CP_LATENCY_MAX) &&
                        (params.supervisionTimeout >= BLE_GAP_CP_CONN_SUPV_TIMEOUT_MIN) && (params.supervisionTimeout <= BLE_GAP_CP_CONN_SUPV_TIMEOUT_MAX)) {
                    //Update connection parameters
                    BLE_GAP_UpdateConnParam(p_connList_t->connHandle, &params);
                }
#else
                BLE_DM_ConnParamUpdate_T params;

                BUF_BE_TO_U16(&params.intervalMin, &p_cmd[3]);
                BUF_BE_TO_U16(&params.intervalMax, &p_cmd[5]);
                BUF_BE_TO_U16(&params.latency, &p_cmd[7]);
                BUF_BE_TO_U16(&params.timeout, &p_cmd[9]);

                /* Validate connection parameters */
                if ((params.intervalMin >= BLE_GAP_CP_MIN_CONN_INTVAL_MIN) && (params.intervalMin <= BLE_GAP_CP_MIN_CONN_INTVAL_MAX) &&
                        (params.intervalMax >= BLE_GAP_CP_MAX_CONN_INTVAL_MIN) && (params.intervalMax <= BLE_GAP_CP_MAX_CONN_INTVAL_MAX) &&
                        (params.latency >= BLE_GAP_CP_LATENCY_MIN) && (params.latency <= BLE_GAP_CP_LATENCY_MAX) &&
                        (params.timeout >= BLE_GAP_CP_CONN_SUPV_TIMEOUT_MIN) && (params.timeout <= BLE_GAP_CP_CONN_SUPV_TIMEOUT_MAX)) {
                    BLE_DM_ConnectionParameterUpdate(p_connList_t->connHandle, &params);
                }
#endif

            }
        }
            break;

        case TRP_GRPID_WMODE_SELECTION:
        {
            if ((commandId >= TRP_GRPID_NULL) && (commandId < TRP_GRPID_TRANSMIT)) {
                p_connList_t->workMode = commandId;
            }
        }
            break;

        case TRP_GRPID_REV_LOOPBACK:
        {
            if ((commandId == APP_TRP_WMODE_REV_LOOPBACK_DISABLE) || (commandId == APP_TRP_WMODE_ERROR_RSP)) {
                p_connList_t->workMode = TRP_WMODE_NULL;
            }
        }
            break;

        default:
            break;
    }
}

void APP_WLS_TRPS_Init(void) {

    memset((uint8_t *) & s_trpsConnList_t, 0, sizeof (APP_TRP_ConnList_T));

}

void APP_WLS_TRPS_ConnEvtProc(BLE_GAP_EvtConnect_T  *p_evtConnect) {

    s_trpsConnList_t.connHandle = p_evtConnect->connHandle;
}

void APP_WLS_TRPS_DiscEvtProc(uint16_t connHandle) {
    if (s_trpsConnList_t.connHandle == connHandle) {
        APP_WLS_TRP_DelAllLeCircData(&(s_trpsConnList_t.leCircQueue_t));
        memset((uint8_t *) & s_trpsConnList_t, 0, sizeof (APP_TRP_ConnList_T));
    }
}

void APP_WLS_TRPS_SendUpConnParaStatusToClient(uint16_t connHandle, uint8_t upConnParaStatus) {
    if (s_trpsConnList_t.connHandle == connHandle) {
        uint8_t grpId = TRP_GRPID_UPDATE_CONN_PARA;
        uint8_t commandId = APP_TRP_WMODE_SNED_UP_CONN_STATUS;

        s_trpsConnList_t.upConnParaStatus = upConnParaStatus;
        APP_WLS_TRP_SendUpConnParaStatus(&s_trpsConnList_t, grpId, commandId, upConnParaStatus);
    }
}

void APP_WLS_TRPS_TxBufValidEvtProc(void) {
    uint16_t status = APP_RES_SUCCESS;
    uint8_t grpId[] = {TRP_GRPID_NULL, TRP_GRPID_CHECK_SUM, TRP_GRPID_LOOPBACK,
		TRP_GRPID_FIX_PATTERN};

    if ((s_trpsConnList_t.workMode == TRP_WMODE_LOOPBACK) && (s_trpsConnList_t.leCircQueue_t.usedNum > 0)) {
        s_trpsConnList_t.srcType = APP_TRP_SRC_TYPE_LE;
        status = APP_WLS_TRP_SendLeDataCircQueue(&s_trpsConnList_t);
    } else if ((s_trpsConnList_t.workMode == TRP_WMODE_FIX_PATTERN) && (s_trpsConnList_t.workModeEn == true)) {
        status = APP_WLS_TRP_SendFixPattern(&s_trpsConnList_t);
        if (status & APP_RES_COMPLETE) {
            APP_WLS_TRP_SendModeCommand(&s_trpsConnList_t, TRP_GRPID_TRANSMIT, APP_TRP_WMODE_TX_DATA_END);
            APP_WLS_TRP_SendLastNumber(&s_trpsConnList_t);
            s_trpsConnList_t.workModeEn = false;
        }
    } else if (s_trpsConnList_t.workMode == TRP_WMODE_FIX_PATTERN) {
        if (s_trpsConnList_t.txCtrRspFg & APP_TRP_SEND_GID_TX_FAIL) {
            APP_WLS_TRP_SendModeCommand(&s_trpsConnList_t, TRP_GRPID_TRANSMIT, APP_TRP_WMODE_TX_DATA_END);
        }
        if (s_trpsConnList_t.txCtrRspFg & APP_TRP_SEND_LAST_NUMBER_FAIL) {
            APP_WLS_TRP_SendLastNumber(&s_trpsConnList_t);
        }
    } else if ((s_trpsConnList_t.workMode == TRP_WMODE_CHECK_SUM)
            && (s_trpsConnList_t.txCtrRspFg & APP_TRP_SEND_CHECK_SUM_FAIL)) {
        APP_WLS_TRP_SendCheckSumCommand(&s_trpsConnList_t);
    } else if (s_trpsConnList_t.txCtrRspFg & APP_TRP_SEND_ERROR_RSP_FAIL) {
        if ((grpId[s_trpsConnList_t.workMode] > TRP_GRPID_NULL)
                && (grpId[s_trpsConnList_t.workMode] < TRP_GRPID_UART)) {
            APP_WLS_TRP_SendErrorRsp(&s_trpsConnList_t, grpId[s_trpsConnList_t.workMode]);
        }
    } else if (s_trpsConnList_t.txCtrRspFg & APP_TRP_SEND_STATUS_FLAG) {
        APP_WLS_TRP_SendUpConnParaStatus(&s_trpsConnList_t, TRP_GRPID_UPDATE_CONN_PARA, APP_TRP_WMODE_SNED_UP_CONN_STATUS, s_trpsConnList_t.upConnParaStatus);
    }

}

void APP_WLS_TRPS_UpdateMtuEvtProc(uint16_t connHandle, uint16_t exchangedMTU) {
    if (s_trpsConnList_t.connHandle == connHandle) {
        s_trpsConnList_t.exchangedMTU = exchangedMTU;
        s_trpsConnList_t.txMTU = s_trpsConnList_t.exchangedMTU - ATT_HANDLE_VALUE_HEADER_SIZE;
    }
}

</#if>
<#if wlsbleconfig.WLS_BLE_GAP_CENTRAL == true  && wlsbleconfig.WLS_BLE_GAP_SCAN == true && wlsbleconfig.WLS_BLE_GAP_PERIPHERAL == true && wlsbleconfig.WLS_BLE_GAP_ADVERTISING == true  && PROFILE_TRSP?? && PROFILE_TRSP.TRSP_BOOL_SERVER == true  && PROFILE_TRSP.TRSP_BOOL_CLIENT == true && (wlsbleconfig.numberoflinks == 2 || wlsbleconfig.numberoflinks == 3)>
#include "ble_trspc/ble_trspc.h"

uint16_t conn_hdl[CONFIG_APP_BLE_MAXIMUM_NUMBER_OF_LINKS];
uint8_t no_of_links;
</#if>
/*******************************************************************************
  Function:
    void APP_WLS_TRPS_DataReceived(uint16_t connHandle, uint16_t dataLen, uint8_t *p_data)

  Summary:
     Function for handling trsps received data EVENT message.

  Description:
      Function for handling trsps received data EVENT message. 
      Once the data is processed, data buffer will be released after this callback.

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_WLS_TRPS_DataReceived(uint16_t connHandle, uint16_t dataLen, uint8_t *p_data)
{

<#if booleanappcode == true>
<#if APP_THROUGHPUT == true>
  if (s_trpsConnList_t.connHandle == connHandle) 
  {
      if (s_trpsConnList_t.trpRole == APP_TRP_SERVER_ROLE) 
      {
          if (s_trpsConnList_t.type == APP_TRP_TYPE_LEGACY) 
          {
              if (s_trpsConnList_t.workMode == TRP_WMODE_NULL) 
              { 
                  return;
              }
          
              APP_WLS_TRPS_ProcessData(&s_trpsConnList_t,dataLen,p_data);
          }
      }

  }

<#elseif wlsbleconfig.WLS_BLE_GAP_CENTRAL == true  && wlsbleconfig.WLS_BLE_GAP_SCAN == true && wlsbleconfig.WLS_BLE_GAP_PERIPHERAL == true && wlsbleconfig.WLS_BLE_GAP_ADVERTISING == true  && PROFILE_TRSP?? && PROFILE_TRSP.TRSP_BOOL_SERVER == true  && PROFILE_TRSP.TRSP_BOOL_CLIENT == true> 
SERCOM0_USART_Write((uint8_t *)"\r\nServer Data :", 15);
            SERCOM0_USART_Write(p_data, dataLen);
            // Send the data from UART to connected device through Transparent service
            for (int i=0;i<no_of_links;i++)
            {
                BLE_TRSPC_SendData(conn_hdl[i], dataLen, p_data);
            }

<#elseif wlsbleconfig.WLS_BLE_GAP_PERIPHERAL == true && wlsbleconfig.WLS_BLE_GAP_ADVERTISING == true && PROFILE_TRSP?? && PROFILE_TRSP.TRSP_BOOL_SERVER == true  && wlsbleconfig.WLS_BLE_BOOL_GAP_EXT_ADV == false > 
 SERCOM0_USART_Write(p_data, dataLen);
<#elseif wlsbleconfig.WLS_BLE_GAP_PERIPHERAL == true && wlsbleconfig.WLS_BLE_GAP_ADVERTISING == true && PROFILE_TRSP?? && PROFILE_TRSP.TRSP_BOOL_SERVER == true  && wlsbleconfig.WLS_BLE_BOOL_GAP_EXT_ADV == true > 
SERCOM0_USART_Write(p_data, dataLen);
</#if> 
</#if>
}


