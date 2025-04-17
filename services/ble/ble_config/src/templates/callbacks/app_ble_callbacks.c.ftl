<#assign APP_ANY_PROF = false>
<#assign APP_ANP_OR_PXP = false>
<#assign APP_ANCS_OR_HOGP = false>
<#assign APP_PXPM_OR_ANPS = false>
<#assign APP_PXPR_OR_ANPC = false>
<#assign APP_ANCS = false>
<#assign APP_ANPC = false>
<#assign APP_ANPS = false>
<#assign APP_HOGP = false>
<#assign APP_PXPR = false>
<#assign APP_PXPM = false>
<#assign APP_THROUGHPUT = false>
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true && WLS_BLE_BOOL_GAP_EXT_ADV == false && WLS_BLE_GAP_DSADV_EN == false && WLS_BLE_BOOL_L2CAP_CREDIT_FLOWCTRL == true> 
<#assign APP_THROUGHPUT = true>
</#if>
<#if wlsbleancsss?? && wlsbleancsss.SS_ANCS_BOOL_CLIENT == true>
<#if booleanappcode ==  true>
<#assign APP_ANCS = true>
</#if>
</#if>
<#if wlsbleanpss?? && wlsbleanpss.ANPSS_BOOL_CLIENT == true>
<#if booleanappcode ==  true>
<#assign APP_ANPC = true>
</#if>
</#if>
<#if wlsbleanpss?? && wlsbleanpss.ANPSS_BOOL_SERVER == true>
<#if booleanappcode ==  true>
<#assign APP_ANPS = true>
</#if>
</#if>
<#if wlsblehogp?? && wlsblehogp.HOGP_BOOL_SERVER == true>
<#if booleanappcode ==  true>
<#assign APP_HOGP = true>
</#if>
</#if>
<#if wlsblepxpss?? && wlsblepxpss.SS_PXP_BOOL_CLIENT == true>
<#if booleanappcode ==  true>
<#assign APP_PXPM = true>
</#if>
</#if>
<#if wlsblepxpss?? && wlsblepxpss.SS_PXP_BOOL_SERVER == true>
<#if booleanappcode ==  true> 
<#assign APP_PXPR = true>
</#if>
</#if>
<#if APP_ANCS == true || APP_ANPC ==  true || APP_ANPS == true || APP_HOGP == true || APP_PXPR == true || APP_PXPM == true>
<#assign APP_ANY_PROF = true>
</#if>
<#if APP_ANPC ==  true || APP_ANPS == true || APP_PXPR == true || APP_PXPM == true>
<#assign APP_ANP_OR_PXP = true>
</#if>
<#if APP_ANCS == true || APP_HOGP == true>
<#assign APP_ANCS_OR_HOGP = true>
</#if>
<#if APP_PXPM == true || APP_ANPS == true>
<#assign APP_PXPM_OR_ANPS = true>
</#if>
<#if APP_PXPR== true || APP_ANPC == true>
<#assign APP_PXPR_OR_ANPC = true>
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
    app_ble_callbacks.c

  Summary:
    This file contains API functions for the user to implement his business logic.

  Description:
    API functions for the user to implement his business logic.
*******************************************************************************/
// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************
#include <stdio.h>
#include <stdint.h>
#include "app_ble_callbacks.h"
#include "definitions.h" 
#include "app_ble_handler.h"
<#if booleanappcode ==  true>
<#if wlsbleancsss?? && wlsbleancsss.SS_ANCS_BOOL_CLIENT == true>
#include "app_ancs_callbacks.h"
</#if>
</#if>
<#if APP_ANCS_OR_HOGP = true>
#ifdef PIC32BZ3
#include "driver/security/sxsymcrypt/trng_api.h"
#include "driver/security/sxsymcrypt/statuscodes.h"
#endif
</#if>
<#if booleanappcode ==  true>
<#if wlsbleanpss?? &&  wlsbleanpss.ANPSS_BOOL_CLIENT == true>
${WLS_BLE_COMMENT}
#include "app_led.h"
</#if>
</#if>
<#if booleanappcode ==  true>
<#if wlsblepxpss?? && wlsblepxpss.SS_PXP_BOOL_SERVER == true>
#include "app_pxpr_callbacks.h"   
</#if>
</#if>
<#if booleanappcode ==  true>
<#if APP_THROUGHPUT == true>
#include <string.h>
#include "app.h"
#include "app_ble/handlers/app_ble_handler.h"
#include "app_error_defs.h"
#include "app_led.h"
#include "app_ble_callbacks.h"  
</#if>
</#if>
// *****************************************************************************
// *****************************************************************************
// Section: Macros
// *****************************************************************************
// *****************************************************************************
<#if booleanappcode ==  true>
<#if wlsbleanpss?? && wlsbleanpss.ANPSS_BOOL_SERVER == true>
${WLS_BLE_COMMENT}
#define BLE_ANS_UUID                   (0x1811U)
#define COMPLETE_LIST_OF_16_BIT_UUIDS  (0x03U)
</#if>
</#if>
<#if booleanappcode ==  true>
<#if wlsblepxpss?? && wlsblepxpss.SS_PXP_BOOL_CLIENT == true>
${WLS_BLE_COMMENT}
#define BLE_PXPM_UUID                  (0x1803U)
#define COMPLETE_LIST_OF_16_BIT_UUIDS  (0x03U)
</#if>
</#if>
<#if APP_ANY_PROF == true>
<#if BLE_STACK_LIB.GAP_ADVERTISING == true>
#define APP_ADV_DURATION_60S    (60*100)    //Unit: 10ms
#define APP_ADV_DURATION_30S    (30*100)    //Unit: 10ms
</#if>
<#if BLE_STACK_LIB.GAP_SCAN == true>
#define APP_SCAN_DURATION_60S    (60*10)    //Unit: 100ms
#define APP_SCAN_DURATION_30S    (30*10)    //Unit: 100ms
</#if>
<#if APP_ANCS_OR_HOGP == true>
#define APP_RANDOM_BYTE_LEN                        32
#define APP_BLE_GAP_RANDOM_SUB_TYPE_MASK           (0xC0U)     /**< Random Address Mask: Bit 7, Bit6. Bit 7 is the Most significant bit */
#define APP_BLE_GAP_RESOLVABLE_ADDR                (0x40U)     /**< (bit7:bit6) of BLE address is 01 then it is resolvable private address */
#define APP_BLE_GAP_NON_RESOLVABLE_ADDR            (0x00U)     /**< (bit7:bit6) of BLE address is 00 then it is non-resolvable private address */
#define APP_BLE_GAP_STATIC_ADDR                    (0xC0U)     /**< (bit7:bit6) of BLE address is 11 then it is static private address */
<#if APP_ANCS_OR_HOGP = true>
#ifdef PIC32BZ3
#define APP_TRNG_MAX_CHUNK_SZ 32    //The max chunk size is defined by the sample code of TRNG
#endif
</#if>
</#if>
</#if>
// *****************************************************************************
// *****************************************************************************
// Section: Data Types
// *****************************************************************************
// *****************************************************************************
<#if APP_ANCS_OR_HOGP == true>
typedef enum APP_PdsAppItem_T{
    PDS_APP_ITEM_ID_1 = (PDS_MODULE_APP_OFFSET),
    PDS_APP_ITEM_ID_2

}APP_PdsAppItem_T;
</#if>
<#if booleanappcode ==  true>
<#if APP_THROUGHPUT == true>
static APP_BLE_AdvParams_T s_bleAdvParam;
</#if>
</#if>
// *****************************************************************************
// *****************************************************************************
// Section: Global Variables
// *****************************************************************************
// *****************************************************************************
<#if APP_ANCS_OR_HOGP == true>
APP_PairedDevInfo_T g_pairedDevInfo;
APP_ExtPairedDevInfo_T g_extPairedDevInfo;
bool g_bAllowNewPairing;
</#if>
<#if APP_ANP_OR_PXP == true>
APP_CtrlInfo_T g_ctrlInfo;
</#if>
<#if APP_ANCS == true>
APP_GattClientInfo_T g_GattClientInfo;
</#if>
<#if APP_HOGP == true>
APP_PairedDevGattInfo_T g_PairedDevGattInfo;
bool g_bConnTimeout;
</#if>
<#if APP_ANCS_OR_HOGP == true>
static APP_ExtPairedDevInfo_T s_extPairedDevInfoBuf;
PDS_DECLARE_FILE(PDS_APP_ITEM_ID_1, sizeof(APP_ExtPairedDevInfo_T), &s_extPairedDevInfoBuf,FILE_INTEGRITY_CONTROL_MARK);
</#if>
<#if APP_HOGP == true>
static APP_PairedDevGattInfo_T s_PairedDevGattInfoBuf;
PDS_DECLARE_FILE(PDS_APP_ITEM_ID_2, sizeof(APP_PairedDevGattInfo_T), &s_PairedDevGattInfoBuf,FILE_INTEGRITY_CONTROL_MARK);
</#if>
<#if booleanappcode ==  true>
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true && WLS_BLE_BOOL_GAP_EXT_ADV == false && WLS_BLE_GAP_DSADV_EN == false && WLS_BLE_BOOL_L2CAP_CREDIT_FLOWCTRL == true> 
static APP_BLE_ConnList_T s_bleConnList[APP_BLE_MAX_LINK_NUMBER];
static APP_BLE_ConnList_T *sp_currentBleLink = NULL;
static uint8_t s_currBleConnIdx;
</#if>
</#if>
// *****************************************************************************
// *****************************************************************************
// Section: Function Prototypes
// *****************************************************************************
// *****************************************************************************
<#if booleanappcode ==  true>
<#if WLS_BLE_GAP_PERIPHERAL == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true && WLS_BLE_BOOL_GAP_EXT_ADV == true && WLS_BLE_GAP_PRI_ADV_PHY == "1" && WLS_BLE_GAP_SEC_ADV_PHY == "2">
	${WLS_BLE_COMMENT}

static  int8_t phyOptions = BLE_GAP_PHY_PREF_NO;

void SYS_CONSOLE_PRINT_PHY(uint8_t phy){
    switch (phy) {
        case BLE_GAP_PHY_TYPE_LE_1M:
             SYS_DEBUG_PRINT(SYS_ERROR_INFO,"LE_1M \r\n");
            break;
        case BLE_GAP_PHY_TYPE_LE_2M:
             SYS_DEBUG_PRINT(SYS_ERROR_INFO,"LE_2M \r\n");
            break;
        case BLE_GAP_PHY_TYPE_LE_CODED:
             SYS_DEBUG_PRINT(SYS_ERROR_INFO,"LE_CODED");
            if(phyOptions == BLE_GAP_PHY_PREF_S2)
                 SYS_DEBUG_PRINT(SYS_ERROR_INFO," |S2\r\n");
            else if(phyOptions == BLE_GAP_PHY_PREF_S8)
                 SYS_DEBUG_PRINT(SYS_ERROR_INFO," |S8\r\n");
            else
                 SYS_DEBUG_PRINT(SYS_ERROR_INFO,"\r\n");
            break;
        default:
             SYS_DEBUG_PRINT(SYS_ERROR_INFO,"UNKOWN PHY \r\n");
            break;
    }
};
</#if>
<#if WLS_BLE_GAP_CENTRAL == true  && WLS_BLE_GAP_SCAN == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_CLIENT == true  &&  WLS_BLE_BOOL_GAP_EXT_SCAN == true && WLS_BLE_GAP_EXT_SCAN_PHY == "2">
 ${WLS_BLE_COMMENT}
static  int8_t phyOptions = BLE_GAP_PHY_PREF_NO;

void SYS_CONSOLE_PRINT_PHY(uint8_t phy) {
    switch (phy) {
        case BLE_GAP_PHY_TYPE_LE_1M:
             SYS_DEBUG_PRINT(SYS_ERROR_INFO,"LE_1M \r\n");
            break;
        case BLE_GAP_PHY_TYPE_LE_2M:
             SYS_DEBUG_PRINT(SYS_ERROR_INFO,"LE_2M \r\n");
            break;
        case BLE_GAP_PHY_TYPE_LE_CODED:
             SYS_DEBUG_PRINT(SYS_ERROR_INFO,"LE_CODED");
            if(phyOptions == BLE_GAP_PHY_PREF_S2)
                 SYS_DEBUG_PRINT(SYS_ERROR_INFO," |S2\r\n");
            else if(phyOptions == BLE_GAP_PHY_PREF_S8)
                 SYS_DEBUG_PRINT(SYS_ERROR_INFO," |S8\r\n");
            else
                 SYS_DEBUG_PRINT(SYS_ERROR_INFO,"\r\n");
            break;
        default:
             SYS_DEBUG_PRINT(SYS_ERROR_INFO,"UNKOWN PHY \r\n");
            break;
    }
};

void SYS_CONSOLE_PRINT_extEVENT(uint8_t extEvent) {
    if (extEvent & BLE_GAP_EXT_ADV_RPT_TYPE_CONNECTABLE)
         SYS_DEBUG_PRINT(SYS_ERROR_INFO,"| CONNECTABLE");
    if (extEvent & BLE_GAP_EXT_ADV_RPT_TYPE_SCANNABLE)
         SYS_DEBUG_PRINT(SYS_ERROR_INFO,"| SCANNABLE");
    if (extEvent & BLE_GAP_EXT_ADV_RPT_TYPE_DIRECTED)
         SYS_DEBUG_PRINT(SYS_ERROR_INFO,"| DIRECTED");
    if (extEvent & BLE_GAP_EXT_ADV_RPT_TYPE_SCAN_RSP)
         SYS_DEBUG_PRINT(SYS_ERROR_INFO,"| SCAN_RSP");
    if (extEvent & BLE_GAP_EXT_ADV_RPT_TYPE_LEGACY)
         SYS_DEBUG_PRINT(SYS_ERROR_INFO,"| LEGACY");

     SYS_DEBUG_PRINT(SYS_ERROR_INFO,"\r\n");
};
</#if>
<#if WLS_BLE_GAP_CENTRAL == true  && WLS_BLE_GAP_SCAN == true>
${WLS_BLE_COMMENT}
static void APP_WLS_HexToAscii(uint8_t byteNum, uint8_t *p_hex, uint8_t *p_ascii)
{
    uint8_t i, j, c;
    uint8_t digitNum = byteNum * 2;

    if (p_hex == NULL || p_ascii == NULL)
        return;

    for (i = 0; i < digitNum; i++)
    {
        j = i / 2;
        c = p_hex[j] & 0x0F;

        if (c >= 0x00 && c <= 0x09)
        {
            p_ascii[digitNum - i - 1] = c + 0x30;
        }
        else if (c >= 0x0A && c <= 0x0F)
        {
            p_ascii[digitNum - i - 1] = c - 0x0A + 'A';
        }

        p_hex[j] /= 16;
    }
}
</#if>
</#if>

<#if booleanappcode ==  true>
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true && WLS_BLE_BOOL_GAP_EXT_ADV == false && WLS_BLE_GAP_DSADV_EN == false && WLS_BLE_BOOL_L2CAP_CREDIT_FLOWCTRL == true> 
void APP_WLS_ClearConnListByConnHandle(uint16_t connHandle) {
    uint8_t i;

    for (i = 0; i < APP_BLE_MAX_LINK_NUMBER; i++) {
        if (s_bleConnList[i].connData.handle == connHandle) {
            memset((uint8_t *) (&s_bleConnList[i]), 0, sizeof (APP_BLE_ConnList_T));
            s_bleConnList[i].linkState = APP_DEVICE_STATE_IDLE;
        }
    }
}

APP_BLE_ConnList_T *APP_WLS_BLE_GetFreeConnList(void) {
    uint8_t i;

    for (i = 0; i < APP_BLE_MAX_LINK_NUMBER; i++) {
        if (s_bleConnList[i].connData.handle == 0) {
            s_currBleConnIdx = i;
            return (&s_bleConnList[i]);
        }
    }
    return NULL;
}

APP_BLE_ConnList_T *APP_WLS_BLE_GetConnInfoByConnHandle(uint16_t connHandle) {
    uint8_t i;

    for (i = 0; i < APP_BLE_MAX_LINK_NUMBER; i++) {
        if (s_bleConnList[i].connData.handle == connHandle) {
            return (&s_bleConnList[i]);
        }
    }
    return NULL;
}

void APP_WLS_BLE_SwitchActiveDevice(void) {
    uint8_t i;
    uint8_t probeIndex;

    for (i = 1; i < APP_BLE_MAX_LINK_NUMBER; i++) {
        probeIndex = ((s_currBleConnIdx + i) % APP_BLE_MAX_LINK_NUMBER);

        if (s_bleConnList[probeIndex].linkState == APP_DEVICE_STATE_CONN) {
            sp_currentBleLink = &s_bleConnList[probeIndex];
            s_currBleConnIdx = probeIndex;

            return;
        }
    }

    s_currBleConnIdx = APP_BLE_UNKNOWN_ID;
}

void APP_WLS_HexToAscii(uint8_t byteNum, uint8_t *p_hex, uint8_t *p_ascii) 
{
    uint8_t i, j, c;
    uint8_t digitNum = byteNum * 2;

    if (p_hex == NULL || p_ascii == NULL)
        return;

    for (i = 0; i < digitNum; i++) 
    {
        j = i / 2;
        c = p_hex[j] & 0x0F;

        if (c >= 0x00 && c <= 0x09)
        {
            p_ascii[digitNum - i - 1] = c + 0x30;
        } 
        else if (c >= 0x0A && c <= 0x0F) 
        {
            p_ascii[digitNum - i - 1] = c - 0x0A + 'A';
        }

        p_hex[j] /= 16;
    }
}

void APP_WLS_BLE_UpdateLocalName(uint8_t devNameLen, uint8_t *p_devName) 
{
    uint8_t localName[GAP_MAX_DEVICE_NAME_LEN] = {0};
    uint8_t localNameLen = 0;

    if (p_devName == NULL || devNameLen == 0) 
    {
        BLE_GAP_Addr_T addrPara;
        uint8_t addrAscii[APP_BLE_NUM_ADDR_IN_DEV_NAME * 2];
        uint8_t digitNum = APP_BLE_NUM_ADDR_IN_DEV_NAME * 2;

        localName[localNameLen++] = 'B';
        localName[localNameLen++] = 'L';
        localName[localNameLen++] = 'E';
        localName[localNameLen++] = '_';
        localName[localNameLen++] = 'U';
        localName[localNameLen++] = 'A';
        localName[localNameLen++] = 'R';
        localName[localNameLen++] = 'T';
        localName[localNameLen++] = '_';

        BLE_GAP_GetDeviceAddr(&addrPara);

        APP_WLS_HexToAscii(APP_BLE_NUM_ADDR_IN_DEV_NAME, addrPara.addr, addrAscii);

        memcpy(&localName[localNameLen], &addrAscii[0], digitNum);

        localNameLen += digitNum;

        BLE_GAP_SetDeviceName(localNameLen, localName);
    } 
    else 
    {
        BLE_GAP_SetDeviceName(devNameLen, p_devName);
    }
}

APP_DEVICE_States_T APP_WLS_BLE_GetState(void) 
{
    return (sp_currentBleLink->linkState);
}

void APP_WLS_BLE_SetState(APP_DEVICE_States_T state) 
{
    sp_currentBleLink->linkState = state;
}

uint8_t APP_WLS_BLE_GetRole(void) 
{
    return (sp_currentBleLink->connData.role);
}

uint16_t APP_WLS_BLE_GetCurrentConnHandle(void) 
{
    if (sp_currentBleLink->linkState == APP_DEVICE_STATE_CONN) {
        return sp_currentBleLink->connData.handle;
    } else {
        return 0;
    }
}

void APP_WLS_BLE_InitConnList(void) 
{
    uint8_t i;

    sp_currentBleLink = &s_bleConnList[0];
    s_currBleConnIdx = APP_BLE_UNKNOWN_ID;

    for (i = 0; i < APP_BLE_MAX_LINK_NUMBER; i++) {
        memset((uint8_t *) (&s_bleConnList[i]), 0, sizeof (APP_BLE_ConnList_T));
        s_bleConnList[i].linkState = APP_DEVICE_STATE_IDLE;
    }
}
</#if>
</#if>
/*******************************************************************************
  Function:
    void APP_WLS_BLE_DeviceConnected(BLE_GAP_EvtConnect_T  *p_evtConnect)

  Summary:
     Function for handling GAP connected indication EVENT message.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_WLS_BLE_DeviceConnected(BLE_GAP_EvtConnect_T  *p_evtConnect)
{
/* TODO: implement your application code.*/
<#if booleanappcode ==  true>
${WLS_BLE_COMMENT}
    SYS_DEBUG_PRINT(SYS_ERROR_INFO,"Connected\r\n"); 
<#if WLS_BLE_GAP_CENTRAL == true  && WLS_BLE_GAP_SCAN == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_CLIENT == true  && WLS_BLE_BOOL_GAP_EXT_SCAN == true && WLS_BLE_GAP_EXT_SCAN_PHY == "2">
<#-- For  central_trp_uartcodedPhy -->
   ${WLS_BLE_COMMENT}
    conn_handle = p_evtConnect->connHandle;
</#if>
<#if WLS_BLE_GAP_CENTRAL == true  && WLS_BLE_GAP_SCAN == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_CLIENT == true && WLS_BLE_BOOL_GAP_EXT_SCAN == false && !(wlsbletrspss.SS_TRSP_BOOL_CLIENT == true && wlsbletrspss.SS_TRSP_BOOL_SERVER == true) &&  numberoflinks <=1>
<#-- For  central_trp_uart -->
    ${WLS_BLE_COMMENT}
	conn_handle = p_evtConnect->connHandle;	
</#if>
<#if WLS_BLE_GAP_CENTRAL == true  && WLS_BLE_GAP_SCAN == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_CLIENT == true && WLS_BLE_BOOL_GAP_EXT_SCAN == false && !(wlsbletrspss.SS_TRSP_BOOL_CLIENT == true && wlsbletrspss.SS_TRSP_BOOL_SERVER == true) && (numberoflinks == 2 || numberoflinks == 3)>
<#-- For  central_multilink -->
    ${WLS_BLE_COMMENT}
    conn_hdl[no_of_links] = p_evtConnect->connHandle;
    no_of_links++;
</#if>	
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true  && WLS_BLE_BOOL_GAP_EXT_ADV == false && !(wlsbletrspss.SS_TRSP_BOOL_CLIENT == true && wlsbletrspss.SS_TRSP_BOOL_SERVER == true) && WLS_BLE_BOOL_L2CAP_CREDIT_FLOWCTRL == false>
<#-- For  peripheral_trp_uart -->
// from here code added
    ${WLS_BLE_COMMENT}
	conn_handle = p_evtConnect->connHandle;
</#if>
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true  && WLS_BLE_BOOL_GAP_EXT_ADV == true >
<#-- For  peripheral_trp_uartcodedPhy -->
    ${WLS_BLE_COMMENT}
    conn_handle = p_evtConnect->connHandle;
</#if>	
<#if WLS_BLE_GAP_PERIPHERAL == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true && WLS_BLE_BOOL_GAP_EXT_ADV == true && WLS_BLE_GAP_PRI_ADV_PHY == "1" && WLS_BLE_GAP_SEC_ADV_PHY == "2">
    ${WLS_BLE_COMMENT}
    uint8_t txPhys = 0, rxPhys = 0;
            
#ifdef APP_BLE_CODED_PHY_ENABLE
    txPhys = BLE_GAP_PHY_OPTION_CODED;
    rxPhys = BLE_GAP_PHY_OPTION_CODED;
#ifdef APP_BLE_CODED_S2_ENABLE
    phyOptions = BLE_GAP_PHY_PREF_S2;
#else
    phyOptions = BLE_GAP_PHY_PREF_S8;
#endif
            
#elif defined(APP_BLE_2M_PHY_ENABLE)
    txPhys = BLE_GAP_PHY_OPTION_2M;
    rxPhys = BLE_GAP_PHY_OPTION_2M;
    phyOptions = BLE_GAP_PHY_OPTION_NO_PREF;
#else
    txPhys = BLE_GAP_PHY_OPTION_1M;
    rxPhys = BLE_GAP_PHY_OPTION_1M;
    phyOptions = BLE_GAP_PHY_OPTION_NO_PREF;
#endif
    BLE_GAP_SetPhy(p_evtConnect->connHandle, txPhys, rxPhys, phyOptions);
</#if>
<#if WLS_BLE_GAP_CENTRAL == true  && WLS_BLE_GAP_SCAN == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_CLIENT == true  && WLS_BLE_BOOL_GAP_EXT_SCAN == true && WLS_BLE_GAP_EXT_SCAN_PHY == "2">
    ${WLS_BLE_COMMENT}
    uint8_t tx_phy, rx_phy;

    BLE_GAP_ReadPhy(conn_handle, &tx_phy, &rx_phy);
     SYS_DEBUG_PRINT(SYS_ERROR_INFO,"tx_phy: ");
    SYS_CONSOLE_PRINT_PHY(tx_phy);

     SYS_DEBUG_PRINT(SYS_ERROR_INFO,"rx_phy: ");
    SYS_CONSOLE_PRINT_PHY(rx_phy);
    
#ifdef APP_BLE_CODED_PHY_ENABLE
    //if Le1M_CODED, set s8 or s2
    if (tx_phy == BLE_GAP_PHY_TYPE_LE_CODED) 
    {
#ifdef APP_BLE_CODED_S2_ENABLE
      phyOptions = BLE_GAP_PHY_PREF_S2;
#else
      phyOptions = BLE_GAP_PHY_PREF_S8;
#endif
      BLE_GAP_SetPhy(conn_handle, BLE_GAP_PHY_OPTION_CODED, BLE_GAP_PHY_OPTION_CODED, phyOptions);
    }
#endif
</#if>
<#if WLS_BLE_GAP_CENTRAL == true  && WLS_BLE_GAP_SCAN == true && WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true  && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true  && wlsbletrspss.SS_TRSP_BOOL_CLIENT == true>
<#-- For multirole multilink -->
    ${WLS_BLE_COMMENT}
    /* TODO: implement your application code.*/
    conn_hdl[no_of_links] = p_evtConnect->connHandle;
    no_of_links++;
</#if>
<#if wlsbleancsss?? && wlsbleancsss.SS_ANCS_BOOL_CLIENT == true>
    ${WLS_BLE_COMMENT}
    if (!g_pairedDevInfo.bPaired)
        {
            if (p_evtConnect->remoteAddr.addrType == BLE_GAP_ADDR_TYPE_RANDOM_RESOLVABLE)
            {
                g_extPairedDevInfo.bConnectedByResolvedAddr = true;
            }
            else
            {
                g_extPairedDevInfo.bConnectedByResolvedAddr = false;
            }
        }
        else
        {
        }

</#if>
<#if wlsblehogp?? && wlsblehogp.HOGP_BOOL_SERVER == true>
    GATTS_BondingParams_T gattsParams;

    if (!g_pairedDevInfo.bPaired)
    {
        if (p_evtConnect->remoteAddr.addrType == BLE_GAP_ADDR_TYPE_RANDOM_RESOLVABLE)
        {
            g_extPairedDevInfo.bConnectedByResolvedAddr = true;
        }
        else
        {
            g_extPairedDevInfo.bConnectedByResolvedAddr = false;
        }
    }
    else
    {
        APP_WLS_BLE_GetPairedDevGattInfoFromFlash(&g_PairedDevGattInfo);
        gattsParams.serviceChange= g_PairedDevGattInfo.serviceChange;
        gattsParams.clientSupportFeature= g_PairedDevGattInfo.clientSupportFeature;
        GATTS_UpdateBondingInfo(p_evtConnect->connHandle, &gattsParams, g_PairedDevGattInfo.numOfCccd, g_PairedDevGattInfo.cccdList);
    }

</#if>	
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true && WLS_BLE_BOOL_GAP_EXT_ADV == false && WLS_BLE_GAP_DSADV_EN == false && WLS_BLE_BOOL_L2CAP_CREDIT_FLOWCTRL == true>
    APP_BLE_ConnList_T *p_bleConn = NULL;
    APP_WLS_TRPS_ConnEvtProc(p_evtConnect);
    APP_LED_AlwaysOn(APP_LED_TYPE_GREEN, APP_LED_TYPE_NULL);

    p_bleConn = APP_WLS_BLE_GetFreeConnList();
    if (p_bleConn) {
        GATTS_UpdateBondingInfo(p_evtConnect->connHandle, NULL, 0, NULL); //TODO: Have to handle bonded case

        /* Update the connection parameter */
        p_bleConn->linkState = APP_DEVICE_STATE_CONN;
        p_bleConn->connData.role = p_evtConnect->role; // 0x00: Central, 0x01:Peripheral
        p_bleConn->connData.handle = p_evtConnect->connHandle;
        p_bleConn->connData.connInterval = p_evtConnect->interval;
        p_bleConn->connData.connLatency = p_evtConnect->latency;
        p_bleConn->connData.supervisionTimeout = p_evtConnect->supervisionTimeout;

        /* Save Remote Device Address */
        p_bleConn->connData.remoteAddr.addrType = p_evtConnect->remoteAddr.addrType;
        memcpy((uint8_t *) p_bleConn->connData.remoteAddr.addr, (uint8_t *) p_evtConnect->remoteAddr.addr, GAP_MAX_BD_ADDRESS_LEN);

        p_bleConn->secuData.smpInitiator.addrType = p_evtConnect->remoteAddr.addrType;
        memcpy((uint8_t *) p_bleConn->secuData.smpInitiator.addr, (uint8_t *) p_evtConnect->remoteAddr.addr, GAP_MAX_BD_ADDRESS_LEN);

        sp_currentBleLink = p_bleConn;

    }
</#if>
</#if>
}
/*******************************************************************************
  Function:
    void APP_WLS_BLE_DeviceDisconnected(BLE_GAP_EvtDisconnect_T *p_evtDisconnect)

  Summary:
     Function for handling GAP disconnected indication EVENT message.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_WLS_BLE_DeviceDisconnected(BLE_GAP_EvtDisconnect_T *p_evtDisconnect)
{
/* TODO: implement your application code.*/
<#if booleanappcode ==  true>
    ${WLS_BLE_COMMENT}
    SYS_DEBUG_PRINT(SYS_ERROR_INFO,"Disconnected\r\n");
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true && WLS_BLE_BOOL_GAP_EXT_ADV == false && WLS_BLE_GAP_DSADV_EN == false && WLS_BLE_BOOL_L2CAP_CREDIT_FLOWCTRL == true> 
    APP_WLS_ClearConnListByConnHandle(p_evtDisconnect->connHandle);
    APP_LED_AlwaysOn(APP_LED_TYPE_NULL, APP_LED_TYPE_NULL);

    APP_WLS_TRPS_DiscEvtProc(p_evtDisconnect->connHandle);

    /* Restart advertising */
    APP_WLS_BLE_Start();
    APP_WLS_BLE_SwitchActiveDevice(); 
</#if>
</#if>
}
/*******************************************************************************
  Function:
    void APP_WLS_BLE_AdvertisementReportReceived(BLE_GAP_EvtAdvReport_T *p_evtAdvReport)

  Summary:
     Function for handling GAP advertisement report received indication EVENT message.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_WLS_BLE_AdvertisementReportReceived(BLE_GAP_EvtAdvReport_T *p_evtAdvReport)
{
/* TODO: implement your application code.*/
<#if booleanappcode ==  true>
<#if WLS_BLE_GAP_CENTRAL == true  && WLS_BLE_GAP_SCAN == true && WLS_BLE_GAP_SVC_PERI_PRE_CP == true> 
    ${WLS_BLE_COMMENT}
    if (p_evtAdvReport->addr.addr[0] == 0xA1 && p_evtAdvReport->addr.addr[1] == 0xA2)
    {
         SYS_DEBUG_PRINT(SYS_ERROR_INFO,"Found Peer Node\r\n");
        BLE_GAP_CreateConnParams_T createConnParam_t;
        createConnParam_t.scanInterval = APP_BLE_CREATE_CONN_SCAN_INTERVAL; // 37.5 ms 
        createConnParam_t.scanWindow = APP_BLE_CREATE_CONN_SCAN_WINDOW; // 18.75 ms
        createConnParam_t.filterPolicy = BLE_GAP_SCAN_FP_ACCEPT_ALL;
        createConnParam_t.peerAddr.addrType = p_evtAdvReport->addr.addrType;
        memcpy(createConnParam_t.peerAddr.addr, p_evtAdvReport->addr.addr, GAP_MAX_BD_ADDRESS_LEN);
        createConnParam_t.connParams.intervalMin = APP_BLE_CREATE_CONN_INTERVAL_MIN; // 20ms
        createConnParam_t.connParams.intervalMax = APP_BLE_CREATE_CONN_INTERVAL_MAX; // 20ms
        createConnParam_t.connParams.latency = APP_BLE_CREATE_CONN_LATENCY;
        createConnParam_t.connParams.supervisionTimeout = APP_BLE_CREATE_CONN_SUPERVISION_TIOMEOUT; // 720ms
         SYS_DEBUG_PRINT(SYS_ERROR_INFO,"Initiating Connection\r\n");
        BLE_GAP_CreateConnection(&createConnParam_t);
    }
</#if>
<#if WLS_BLE_GAP_CENTRAL == true  && WLS_BLE_GAP_SCAN == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_CLIENT == true && WLS_BLE_BOOL_GAP_EXT_SCAN == false>
<#-- For  central_trp_uart amd multilink-->  
    ${WLS_BLE_COMMENT}
    if ((p_evtAdvReport->addr.addr[0] == 0xA1 && p_evtAdvReport->addr.addr[1] == 0xA2) ||
        (p_evtAdvReport->addr.addr[0] == 0xB1 && p_evtAdvReport->addr.addr[1] == 0xB2) ||
        (p_evtAdvReport->addr.addr[0] == 0xC1 && p_evtAdvReport->addr.addr[1] == 0xC2))
        {
             SYS_DEBUG_PRINT(SYS_ERROR_INFO,"Found Peer Node\r\n");
            BLE_GAP_CreateConnParams_T createConnParam_t;
            createConnParam_t.scanInterval = APP_BLE_CREATE_CONN_SCAN_INTERVAL; // 37.5 ms 
            createConnParam_t.scanWindow = APP_BLE_CREATE_CONN_SCAN_WINDOW; // 18.75 ms
            createConnParam_t.filterPolicy = BLE_GAP_SCAN_FP_ACCEPT_ALL;
            createConnParam_t.peerAddr.addrType = p_evtAdvReport->addr.addrType;
            memcpy(createConnParam_t.peerAddr.addr, p_evtAdvReport->addr.addr, GAP_MAX_BD_ADDRESS_LEN);
            createConnParam_t.connParams.intervalMin = APP_BLE_CREATE_CONN_INTERVAL_MIN; 
            createConnParam_t.connParams.intervalMax = APP_BLE_CREATE_CONN_INTERVAL_MAX; 
            createConnParam_t.connParams.latency = APP_BLE_CREATE_CONN_LATENCY;
            createConnParam_t.connParams.supervisionTimeout = APP_BLE_CREATE_CONN_SUPERVISION_TIOMEOUT; 
             SYS_DEBUG_PRINT(SYS_ERROR_INFO,"Initiating Connection\r\n");
            BLE_GAP_CreateConnection(&createConnParam_t);
        }
</#if>
<#if WLS_BLE_GAP_CENTRAL == true  && WLS_BLE_GAP_SCAN == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_CLIENT == true  && WLS_BLE_BOOL_GAP_EXT_SCAN == true && WLS_BLE_GAP_EXT_SCAN_PHY == "2">
<#-- For  central_trp_uartcodedPhy -->  
    ${WLS_BLE_COMMENT}
     SYS_DEBUG_PRINT(SYS_ERROR_INFO,"EVT_ADV:%d", p_evtAdvReport->eventType);

    // Filter Devices based of Address, for this example address checking only 2 bytes
    if ((p_evtAdvReport->addr.addr[0] == 0xA1 && p_evtAdvReport->addr.addr[1] == 0xA2) ||
        (p_evtAdvReport->addr.addr[0] == 0xB1 && p_evtAdvReport->addr.addr[1] == 0xB2) ||
        (p_evtAdvReport->addr.addr[0] == 0xC1 && p_evtAdvReport->addr.addr[1] == 0xC2)) 
        {
             SYS_DEBUG_PRINT(SYS_ERROR_INFO,"Found Peer Node\r\n");

            // found so disable legacy scanning
            BLE_GAP_SetScanningEnable(false, BLE_GAP_SCAN_FD_ENABLE, BLE_GAP_SCAN_MODE_OBSERVER, 1000);

            BLE_GAP_CreateConnParams_T createConnParam_t;
            createConnParam_t.scanInterval = APP_BLE_CREATE_CONN_SCAN_INTERVAL; // 37.5 ms 
            createConnParam_t.scanWindow = APP_BLE_CREATE_CONN_SCAN_WINDOW; // 18.75 ms
            createConnParam_t.filterPolicy = BLE_GAP_SCAN_FP_ACCEPT_ALL;
            createConnParam_t.peerAddr.addrType = p_evtAdvReport->addr.addrType;
            memcpy(createConnParam_t.peerAddr.addr, p_evtAdvReport->addr.addr, GAP_MAX_BD_ADDRESS_LEN);
            createConnParam_t.connParams.intervalMin = APP_BLE_CREATE_CONN_INTERVAL_MIN; 
            createConnParam_t.connParams.intervalMax = APP_BLE_CREATE_CONN_INTERVAL_MAX; 
            createConnParam_t.connParams.latency = APP_BLE_CREATE_CONN_LATENCY;
            createConnParam_t.connParams.supervisionTimeout = APP_BLE_CREATE_CONN_SUPERVISION_TIOMEOUT;
             SYS_DEBUG_PRINT(SYS_ERROR_INFO,"Initiating Connection\r\n");
            BLE_GAP_CreateConnection(&createConnParam_t);
          }
</#if>
<#if WLS_BLE_GAP_CENTRAL == true  && WLS_BLE_GAP_SCAN == true && !wlsbleanpss?? && WLS_BLE_GAP_SVC_PERI_PRE_CP ==  false && !wlsbletrspss?? && !wlsblepxpss??>
    ${WLS_BLE_COMMENT}
    uint8_t scanAddr[12]; 
    BLE_GAP_EvtAdvReport_T scanResults;
    scanResults.addr = p_evtAdvReport->addr;
    APP_WLS_HexToAscii(6, scanResults.addr.addr, scanAddr);
     SYS_DEBUG_PRINT(SYS_ERROR_INFO,"Address:0x%.12s\r\n",scanAddr);
</#if>
<#if wlsbleanpss?? &&  wlsbleanpss.ANPSS_BOOL_SERVER == true>
    ${WLS_BLE_COMMENT}
    const uint8_t  *p_data = p_evtAdvReport->advData;
    uint8_t  adTypeLen = 0U;
    uint16_t uuid16, i, ret;
    uint16_t strLen = p_evtAdvReport->length;

    if (g_ctrlInfo.state == APP_DEVICE_STATE_CONNECTING)
    {
        return;
    }
    for (i=0U; i<strLen; i=i+adTypeLen+1U)
    {
        uint8_t adType;
        adTypeLen = *(p_data+i);
        adType    = *(p_data+i+1U);
        if (adType == COMPLETE_LIST_OF_16_BIT_UUIDS)
        {
            uuid16  = (*(p_data+i+2U)) + (*(p_data+i+3U)<<8);
            if (uuid16 == BLE_ANS_UUID)
            {
                BLE_GAP_Addr_T remoteAddr;
                uint8_t devCnt;
                if (g_ctrlInfo.state == APP_DEVICE_STATE_WITH_BOND_SCAN)
                {
                    BLE_DM_GetFilterAcceptList(&devCnt, &remoteAddr);
                    if (memcmp(&remoteAddr, &p_evtAdvReport->addr, sizeof(BLE_GAP_Addr_T)) != 0)
                    {
                        break;
                    }
                }
                ret = APP_WLS_BLE_CreateConnection(&p_evtAdvReport->addr);
                if (ret == MBA_RES_SUCCESS)
                {
                    g_ctrlInfo.state = APP_DEVICE_STATE_CONNECTING;
                    APP_WLS_BLE_ScanEnable(APP_DEVICE_STATE_CONNECTING);
                }
                break;
            }
        }
    }  
</#if>
<#if wlsblepxpss?? &&  wlsblepxpss.SS_PXP_BOOL_CLIENT == true>
    const uint8_t  *p_data = p_evtAdvReport->advData;
    uint8_t  adTypeLen = 0U;
    uint16_t uuid16, i, ret;
    uint16_t strLen = p_evtAdvReport->length;
    if (g_ctrlInfo.state == APP_DEVICE_STATE_CONNECTING)
    {
        return;
    }
    for (i=0; i<strLen; i+=adTypeLen+1U)
    {
        uint8_t adType;
        adTypeLen = *(p_data+i);
        adType    = *(p_data+i+1U);
        if (adType == COMPLETE_LIST_OF_16_BIT_UUIDS)
        {
            uuid16  = (*(p_data+i+2U)) + (*(p_data+i+3U)<<8);
            if (uuid16 == BLE_PXPM_UUID)
            {
                BLE_GAP_Addr_T remoteAddr;
                uint8_t devCnt;
                if (g_ctrlInfo.state == APP_DEVICE_STATE_WITH_BOND_SCAN)
                {
                    BLE_DM_GetFilterAcceptList(&devCnt, &remoteAddr);
                    if (memcmp(&remoteAddr, &p_evtAdvReport->addr, sizeof(BLE_GAP_Addr_T)) != 0)
                    {
                        break;
                    }
                }
                ret = APP_WLS_BLE_CreateConnection(&p_evtAdvReport->addr);
                if (ret == MBA_RES_SUCCESS)
                {
                    g_ctrlInfo.state = APP_DEVICE_STATE_CONNECTING;
                    APP_WLS_BLE_ScanEnable(APP_DEVICE_STATE_CONNECTING);

                }
                break;
            }
        }
        }
</#if>
</#if>
}
/*******************************************************************************
  Function:
    void APP_WLS_BLE_ExtendedAdvertisementReportReceived(BLE_GAP_EvtExtAdvReport_T *p_evtExtAdvReport)

  Summary:
     Function for handling GAP advertisement report received indication EVENT message.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_WLS_BLE_ExtendedAdvertisementReportReceived(BLE_GAP_EvtExtAdvReport_T *p_evtExtAdvReport)
{
/* TODO: implement your application code.*/
<#if booleanappcode ==  true>
<#if WLS_BLE_BOOL_GAP_EXT_SCAN == true && WLS_BLE_GAP_CENTRAL == true && !wlsbletrspss??>
    ${WLS_BLE_COMMENT}
    // GPIO will toggle if it can scan any EXT ADV PDU near based on BLE_GAP_SCAN_PHY chosen
    GPIOB_REGS->GPIO_PORTINV = APP_BLE_GPIO_NUM; 
    // length value of 19 is chosen as a filter as ext_adv example sends 19 bytes of data
    // user can modify filter mechanism based on their requirements
    if (p_evtExtAdvReport->length == APP_BLE_ADV_DATA_LEN)
    {
         SYS_DEBUG_PRINT(SYS_ERROR_INFO,"\r\n%.9s",&p_evtExtAdvReport->advData[5]);
    }
</#if>
<#if WLS_BLE_GAP_CENTRAL == true  && WLS_BLE_GAP_SCAN == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_CLIENT == true  && WLS_BLE_BOOL_GAP_EXT_SCAN == true && WLS_BLE_GAP_EXT_SCAN_PHY == "2">
    ${WLS_BLE_COMMENT}
    if ((p_evtExtAdvReport->addr.addr[0] == 0xA1 && p_evtExtAdvReport->addr.addr[1] == 0xA2) ||
        (p_evtExtAdvReport->addr.addr[0] == 0xB1 && p_evtExtAdvReport->addr.addr[1] == 0xB2) ||
        (p_evtExtAdvReport->addr.addr[0] == 0xC1 && p_evtExtAdvReport->addr.addr[1] == 0xC2)) 
        {
             SYS_DEBUG_PRINT(SYS_ERROR_INFO,"\r\next Found Peer Node\r\n");

             SYS_DEBUG_PRINT(SYS_ERROR_INFO,"\r\nEXT_ADV primPhy:");
            SYS_CONSOLE_PRINT_PHY(p_evtExtAdvReport->priPhy);
             SYS_DEBUG_PRINT(SYS_ERROR_INFO,"EXT_ADV secPhy: ");
            SYS_CONSOLE_PRINT_PHY(p_evtExtAdvReport->secPhy);

             SYS_DEBUG_PRINT(SYS_ERROR_INFO,"\r\next Initiating Connection...\r\n");

            BLE_GAP_ExtCreateConnPhy_T extCreateConnParam;
            extCreateConnParam.le1mPhy.enable = true;
            extCreateConnParam.le1mPhy.scanInterval = APP_BLE_CREATE_CONN_SCAN_INTERVAL;
            extCreateConnParam.le1mPhy.scanWindow = APP_BLE_CREATE_CONN_SCAN_WINDOW;
            extCreateConnParam.le1mPhy.connParams.intervalMin = APP_BLE_CREATE_CONN_INTERVAL_MIN;
            extCreateConnParam.le1mPhy.connParams.intervalMax = APP_BLE_CREATE_CONN_INTERVAL_MAX;
            extCreateConnParam.le1mPhy.connParams.latency = APP_BLE_CREATE_CONN_LATENCY;
            extCreateConnParam.le1mPhy.connParams.supervisionTimeout = APP_BLE_CREATE_CONN_SUPERVISION_TIOMEOUT;

            extCreateConnParam.le2mPhy.enable = true;
            extCreateConnParam.le2mPhy.scanInterval = APP_BLE_CREATE_CONN_SCAN_INTERVAL;
            extCreateConnParam.le2mPhy.scanWindow = APP_BLE_CREATE_CONN_SCAN_WINDOW;
            extCreateConnParam.le2mPhy.connParams.intervalMin = APP_BLE_CREATE_CONN_INTERVAL_MIN;
            extCreateConnParam.le2mPhy.connParams.intervalMax = APP_BLE_CREATE_CONN_INTERVAL_MAX;
            extCreateConnParam.le2mPhy.connParams.latency = APP_BLE_CREATE_CONN_LATENCY;
            extCreateConnParam.le2mPhy.connParams.supervisionTimeout = APP_BLE_CREATE_CONN_SUPERVISION_TIOMEOUT;

            extCreateConnParam.leCodedPhy.enable = true;
            extCreateConnParam.leCodedPhy.scanInterval = APP_BLE_CREATE_CONN_SCAN_INTERVAL;
            extCreateConnParam.leCodedPhy.scanWindow = APP_BLE_CREATE_CONN_SCAN_WINDOW;
            extCreateConnParam.leCodedPhy.connParams.intervalMin = APP_BLE_CREATE_CONN_INTERVAL_MIN;
            extCreateConnParam.leCodedPhy.connParams.intervalMax = APP_BLE_CREATE_CONN_INTERVAL_MAX;
            extCreateConnParam.leCodedPhy.connParams.latency = APP_BLE_CREATE_CONN_LATENCY;
            extCreateConnParam.leCodedPhy.connParams.supervisionTimeout = APP_BLE_CREATE_CONN_SUPERVISION_TIOMEOUT;

            BLE_GAP_ExtCreateConnection(BLE_GAP_INIT_FP_FAL_NOT_USED,
                    &(p_evtExtAdvReport->addr),
                    &extCreateConnParam);
        }
</#if>
</#if>
}
/*******************************************************************************
  Function:
    void APP_WLS_BLE_ScanTimedOut()

  Summary:
     Function for handling GAP scan timeout indication EVENT message.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_WLS_BLE_ScanTimedOut()
{
/* TODO: implement your application code.*/
<#if booleanappcode ==  true>
<#if WLS_BLE_GAP_CENTRAL == true  && WLS_BLE_GAP_SCAN == true && WLS_BLE_BOOL_GAP_EXT_SCAN == false && !wlsbleanpss?? && !wlsbletrspss?? && !wlsblepxpss?? && WLS_BLE_GAP_SVC_PERI_PRE_CP == false> 
<#-- For legacy_scan-->  
    ${WLS_BLE_COMMENT}
     SYS_DEBUG_PRINT(SYS_ERROR_INFO,"Scan Completed\r\n");
</#if>
<#if WLS_BLE_GAP_CENTRAL == true  && WLS_BLE_GAP_SCAN == true && WLS_BLE_GAP_SVC_PERI_PRE_CP == true> 
${WLS_BLE_COMMENT}
     SYS_DEBUG_PRINT(SYS_ERROR_INFO,"Scan Completed\r\n");
</#if>
<#if WLS_BLE_GAP_CENTRAL == true  && WLS_BLE_GAP_SCAN == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_CLIENT == true && WLS_BLE_BOOL_GAP_EXT_SCAN == false && !(wlsbletrspss.SS_TRSP_BOOL_CLIENT == true && wlsbletrspss.SS_TRSP_BOOL_SERVER == true)>
<#-- For central_trp_uart -->  
    ${WLS_BLE_COMMENT}
     SYS_DEBUG_PRINT(SYS_ERROR_INFO,"Scan Completed\r\n");
</#if>
<#if WLS_BLE_GAP_CENTRAL == true  && WLS_BLE_GAP_SCAN == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_CLIENT == true && WLS_BLE_BOOL_GAP_EXT_SCAN == true && WLS_BLE_GAP_EXT_SCAN_PHY == "2">
${WLS_BLE_COMMENT}
     SYS_DEBUG_PRINT(SYS_ERROR_INFO,"Scan Completed\r\n");
</#if>
<#if wlsbleanpss?? &&  wlsbleanpss.ANPSS_BOOL_SERVER == true>
/* TODO: implement your application code.*/
    ${WLS_BLE_COMMENT}
    g_ctrlInfo.state = APP_DEVICE_STATE_IDLE;
    APP_LED_Stop(g_appLedHandler);
</#if>
<#if WLS_BLE_GAP_CENTRAL == true  && WLS_BLE_GAP_SCAN == true && WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true  && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true  && wlsbletrspss.SS_TRSP_BOOL_CLIENT == true>
     SYS_DEBUG_PRINT(SYS_ERROR_INFO,"Scan Completed \r\n");
    // Start Advertisement
    BLE_GAP_SetAdvEnable(0x01, 0x00);
     SYS_DEBUG_PRINT(SYS_ERROR_INFO,"Advertising\r\n");
</#if>
<#if wlsblepxpss?? &&  wlsblepxpss.SS_PXP_BOOL_CLIENT == true>
    g_ctrlInfo.state = APP_DEVICE_STATE_IDLE;
    APP_LED_Stop(g_appLedHandler);
</#if>
</#if>
}
/*******************************************************************************
  Function:
    void APP_WLS_BLE_AdvertisementCompleted()

  Summary:
     Function for handling GAP advertisement complete indication EVENT message.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_WLS_BLE_AdvertisementCompleted()
{
<#if booleanappcode ==  true>
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && !wlsbletrspss?? && WLS_BLE_BOOL_GAP_EXT_ADV == true && WLS_BLE_GAP_DSADV_EN == false && WLS_BLE_GAP_EXT_ADV_ADV_SET_2 == true>
    ${WLS_BLE_COMMENT}
     SYS_DEBUG_PRINT(SYS_ERROR_INFO,"BLE_GAP_EVT_ADV_SET_TERMINATED!\r\n");
</#if>
</#if>
}
/*******************************************************************************
  Function:
    void APP_WLS_BLE_AdvertisementTimedOut()

  Summary:
     Function for handling GAP advertisement timeout indication EVENT message.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_WLS_BLE_AdvertisementTimedOut()
{
/* TODO: implement your application code.*/ 
<#if booleanappcode ==  true>
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && !wlsbletrspss?? && WLS_BLE_BOOL_GAP_EXT_ADV == true && WLS_BLE_GAP_DSADV_EN == false && WLS_BLE_GAP_EXT_ADV_ADV_SET_2 == true>
    ${WLS_BLE_COMMENT}
     SYS_DEBUG_PRINT(SYS_ERROR_INFO,"BLE_GAP_EVT_ADV_TIMEOUT!\r\n");
</#if>
</#if>
<#if booleanappcode ==  true>
<#if wlsbleancsss?? && wlsbleancsss.SS_ANCS_BOOL_CLIENT == true>
    ${WLS_BLE_COMMENT}
    g_pairedDevInfo.state=APP_DEVICE_STATE_IDLE;
    APP_LED_Stop(g_appLedHandler);   
</#if>
</#if>
<#if booleanappcode ==  true>
<#if wlsbleanpss?? &&  wlsbleanpss.ANPSS_BOOL_CLIENT == true>
    ${WLS_BLE_COMMENT}
    g_ctrlInfo.state = APP_DEVICE_STATE_IDLE;
    APP_LED_Stop(g_appLedHandler);   
</#if>
<#if wlsblehogp?? && wlsblehogp.HOGP_BOOL_SERVER == true>
${WLS_BLE_COMMENT}
    g_pairedDevInfo.state=APP_DEVICE_STATE_IDLE;
    APP_LED_Stop(g_appLedHandler);
    DEVICE_EnterExtremeDeepSleep(true);   
</#if>
</#if>
<#if booleanappcode ==  true>
<#if wlsblepxpss?? &&  wlsblepxpss.SS_PXP_BOOL_SERVER == true>
    ${WLS_BLE_COMMENT}
    g_ctrlInfo.state=APP_DEVICE_STATE_IDLE;
    APP_LED_Stop(g_appLedHandler);
</#if>
</#if>
}
/*******************************************************************************
  Function:
    void APP_WLS_BLE_PathLossThresholdReceived(BLE_GAP_EvtPathLossThreshold_T *p_evtPathLossThreshold)

  Summary:
     Function for handling pathLoss threshold received indication EVENT message.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_WLS_BLE_PathLossThresholdReceived(BLE_GAP_EvtPathLossThreshold_T *p_evtPathLossThreshold)
{
<#if booleanappcode ==  true>
<#if wlsblepxpss?? &&  wlsblepxpss.SS_PXP_BOOL_CLIENT == true>
    uint16_t connHdl = p_evtPathLossThreshold->connHandle;
    APP_PXPM_ConnList_T *connlist = APP_WLS_PXPM_GetConnListByHandle(connHdl);
    connlist->connIasLevel = p_evtPathLossThreshold->zoneEntered;
#ifdef PIC32BZ2
    if(connlist->connIasLevel == BLE_PXPM_ALERT_LEVEL_NO)
    {
        APP_WLS_RGB_RED_Off();
        APP_WLS_RGB_GREEN_On();
    }
    else
    {
        APP_WLS_RGB_RED_On();
        APP_WLS_RGB_GREEN_Off();
    }
#endif
    BLE_PXPM_WriteIasAlertLevel(p_evtPathLossThreshold->connHandle,connlist->connIasLevel);
</#if>
</#if>
}
/*******************************************************************************
  Function:
    void APP_WLS_BLE_PairedDeviceDisconnected()

  Summary:
     Function for handling paired device link terminated EVENT message.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_WLS_BLE_PairedDeviceDisconnected(BLE_DM_Event_T *p_event)
{
<#if booleanappcode ==  true>
<#if wlsbleancsss?? && wlsbleancsss.SS_ANCS_BOOL_CLIENT == true>
    ${WLS_BLE_COMMENT}
    if (g_bAllowNewPairing)
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
    {
        //Start to reconnect
        APP_WLS_BLE_ConfigAdvDirect(true);
        APP_WLS_BLE_SetFilterAcceptList(true);
        APP_WLS_BLE_SetResolvingList(g_extPairedDevInfo.bConnectedByResolvedAddr);
        APP_WLS_BLE_EnableAdvDirect(true);
    }
</#if>
</#if>
<#if booleanappcode ==  true>
<#if wlsbleanpss?? &&  wlsbleanpss.ANPSS_BOOL_CLIENT == true>
    ${WLS_BLE_COMMENT}

    APP_ANPC_ConnList_T *p_conn = NULL;
    bool bPaired;
    uint8_t devId;
    p_conn = APP_WLS_ANPC_GetConnListByHandle(p_event->connHandle);
    if (p_conn == NULL)
    {
        return;
    }
    APP_WLS_ANPC_InitConnList(p_conn->connIndex);
    bPaired=APP_WLS_BLE_GetPairedDeviceId(&devId);
    if (bPaired == true)
    {
    APP_WLS_BLE_SetResolvingList(true);
    }
    if ((g_ctrlInfo.bAllowNewPairing) || (bPaired == false))
    {   //Start for new pairing
    //Clear filter accept list
    APP_WLS_BLE_SetFilterAcceptList(false);
    //Set the configuration of advertising
    APP_WLS_BLE_ConfigAdv(APP_DEVICE_STATE_ADV);
    //Start advertising
    APP_WLS_BLE_EnableAdv(APP_DEVICE_STATE_ADV);
    }
    else
    {   //Start to reconnect
    APP_WLS_BLE_ConfigAdv(APP_DEVICE_STATE_ADV_DIR);
    APP_WLS_BLE_SetFilterAcceptList(true);
    APP_WLS_BLE_EnableAdv(APP_DEVICE_STATE_ADV_DIR);;
    }
</#if>
</#if>
<#if booleanappcode ==  true>
<#if wlsbleanpss?? &&  wlsbleanpss.ANPSS_BOOL_SERVER == true>
    ${WLS_BLE_COMMENT}

    APP_ANPS_ConnList_T *p_conn = NULL;
    bool bPaired;
    uint8_t devId;
    p_conn = APP_WLS_ANPS_GetConnListByHandle(p_event->connHandle);
    if (p_conn == NULL)
    {
        return;
    }
    APP_WLS_ANPS_InitConnList(p_conn->connIndex);
    g_ctrlInfo.state=APP_DEVICE_STATE_IDLE;
    bPaired=APP_WLS_BLE_GetPairedDeviceId(&devId);
    if (bPaired == true)
    {
        APP_WLS_BLE_SetResolvingList(true);
    }
    if (g_ctrlInfo.bAllowNewPairing || (bPaired == false))
    {
        //Clear filter accept list
        APP_WLS_BLE_SetFilterAcceptList(false);
        //Clear resolving list
        APP_WLS_BLE_ScanEnable(APP_DEVICE_STATE_SCAN);
    }
    else
    {
        //Clear filter accept list
        APP_WLS_BLE_SetFilterAcceptList(true);
        //Clear resolving list
        APP_WLS_BLE_ScanEnable(APP_DEVICE_STATE_WITH_BOND_SCAN);
    }
</#if>
<#if wlsblehogp?? && wlsblehogp.HOGP_BOOL_SERVER == true>
    ${WLS_BLE_COMMENT}

    if (g_bConnTimeout)
    {
        DEVICE_EnterExtremeDeepSleep(true);
    }
    else
    {
        APP_CONN_StopTimeoutTimer();

        if (g_bAllowNewPairing)
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
        {
            //Start to reconnect
            APP_WLS_BLE_ConfigAdvDirect(true);
            APP_WLS_BLE_SetFilterAcceptList(true);
            APP_WLS_BLE_SetResolvingList(g_extPairedDevInfo.bConnectedByResolvedAddr);
            APP_WLS_BLE_EnableAdvDirect(true);
        }
    }
</#if>
<#if wlsblepxpss?? &&  wlsblepxpss.SS_PXP_BOOL_CLIENT == true>
APP_PXPM_ConnList_T *p_conn = NULL;
    bool bPaired;
    uint8_t devId;
    p_conn = APP_WLS_PXPM_GetConnListByHandle(p_event->connHandle);
    if (p_conn == NULL)
    {
        return;
    }
    APP_WLS_PXPM_InitConnCharList(p_conn->connIndex);
    g_ctrlInfo.state=APP_DEVICE_STATE_IDLE;
    bPaired=APP_WLS_BLE_GetPairedDeviceId(&devId);
    if (bPaired == true)
    {
        APP_WLS_BLE_SetResolvingList(true);
    }
    if (g_ctrlInfo.bAllowNewPairing || (bPaired == false))
    {
        //Clear filter accept list
        APP_WLS_BLE_SetFilterAcceptList(false);
        //Clear resolving list
        APP_WLS_BLE_ScanEnable(APP_DEVICE_STATE_SCAN);
    }
    else
    {
        //Clear filter accept list
        APP_WLS_BLE_SetFilterAcceptList(true);
        //Clear resolving list
        APP_WLS_BLE_ScanEnable(APP_DEVICE_STATE_WITH_BOND_SCAN);               
    }
    APP_WLS_PXPM_Recovery();
</#if>
</#if>
<#if booleanappcode ==  true>
<#if wlsblepxpss?? && wlsblepxpss.SS_PXP_BOOL_SERVER == true>
    APP_PXPR_ConnList_T *p_conn = NULL;
    bool bPaired;
    uint8_t devId;
    bPaired=APP_WLS_BLE_GetPairedDeviceId(&devId);
    if (bPaired == true)
    {
        APP_WLS_BLE_SetResolvingList(true);
    }
    if ((g_ctrlInfo.bAllowNewPairing) || (bPaired == false))
    {   //Start for new pairing
        //Clear filter accept list
        APP_WLS_BLE_SetFilterAcceptList(false);
        //Set the configuration of advertising
        APP_WLS_BLE_ConfigAdv(APP_DEVICE_STATE_ADV);
        //Start advertising
        APP_WLS_BLE_EnableAdv(APP_DEVICE_STATE_ADV);
    }
    else
    {   //Start to reconnect
        APP_WLS_BLE_ConfigAdv(APP_DEVICE_STATE_ADV_DIR);
        APP_WLS_BLE_SetFilterAcceptList(true);
        APP_WLS_BLE_EnableAdv(APP_DEVICE_STATE_ADV_DIR);;
    }
    APP_WLS_PXPR_Linkloss(p_event->connHandle);
    p_conn = APP_WLS_PXPR_GetConnListByHandle(p_event->connHandle);
    if (p_conn == NULL)
    {
        return;
    }
    APP_WLS_PXPR_InitConnCharList(p_conn->connIndex);
    BLE_PXPR_SetTxPowerLevel(0);
</#if>
</#if>
}
/*******************************************************************************
  Function:
    void APP_WLS_BLE_PairedDeviceConnected(BLE_DM_Event_T *p_event)

  Summary:
     Function for handling paired device link connected EVENT message.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_WLS_BLE_PairedDeviceConnected(BLE_DM_Event_T *p_event)
{
<#if booleanappcode ==  true>
<#if wlsbleancsss?? && wlsbleancsss.SS_ANCS_BOOL_CLIENT == true>
    ${WLS_BLE_COMMENT}
    g_bAllowNewPairing=false;
    g_pairedDevInfo.connHandle=p_event->connHandle;
    g_pairedDevInfo.state=APP_DEVICE_STATE_CONN;
    g_appLedHandler=APP_LED_StartByMode(APP_LED_MODE_CONN);
</#if>
<#if wlsblepxpss?? &&  wlsblepxpss.SS_PXP_BOOL_CLIENT == true>
    APP_PXPM_ConnList_T *p_conn = NULL;
    p_conn = APP_WLS_PXPM_GetFreeConnList();
    if (p_conn == NULL)
    { 
    return;
    }
    p_conn->connHandle=p_event->connHandle;
    g_ctrlInfo.bAllowNewPairing=false;
    g_ctrlInfo.state=APP_DEVICE_STATE_CONNECTED;
#ifdef PIC32BZ3
    g_appLedHandler=APP_LED_StartByMode(APP_LED_MODE_CONN);
#endif
</#if>
</#if>
<#if booleanappcode ==  true>
<#if wlsbleanpss?? &&  wlsbleanpss.ANPSS_BOOL_CLIENT == true>
    ${WLS_BLE_COMMENT}
    APP_ANPC_ConnList_T *p_conn = NULL;
    p_conn = APP_WLS_ANPC_GetFreeConnList();
    if (p_conn == NULL)
    { 
        return;
    }
    p_conn->connHandle=p_event->connHandle;
    g_ctrlInfo.bAllowNewPairing = false;
    g_ctrlInfo.state = APP_DEVICE_STATE_CONN;
    g_appLedHandler      = APP_LED_StartByMode(APP_LED_MODE_CONN);
</#if>
</#if>
<#if booleanappcode ==  true>
<#if wlsbleanpss?? &&  wlsbleanpss.ANPSS_BOOL_SERVER == true>
    ${WLS_BLE_COMMENT}
        APP_ANPS_ConnList_T *p_conn = NULL;
    bool bPaired;
    uint8_t devId;
    p_conn = APP_WLS_ANPS_GetFreeConnList();
    if (p_conn == NULL)
    { 
        return;
    }
    p_conn->connHandle=p_event->connHandle;
    g_ctrlInfo.bAllowNewPairing=false;
    g_ctrlInfo.state=APP_DEVICE_STATE_CONNECTED;
    g_appLedHandler=APP_LED_StartByMode(APP_LED_MODE_CONN);
    bPaired=APP_WLS_BLE_GetPairedDeviceId(&devId);
    if ((bPaired == true) && (p_conn->bSecurityStatus == false))
    {
        BLE_DM_ProceedSecurity(p_conn->connHandle, 0);
    }
</#if>
</#if>
<#if booleanappcode ==  true>
<#if wlsblehogp?? && wlsblehogp.HOGP_BOOL_SERVER == true>
${WLS_BLE_COMMENT}

    g_bAllowNewPairing=false;

    g_pairedDevInfo.connHandle=p_event->connHandle;
    g_pairedDevInfo.state=APP_DEVICE_STATE_CONN;
    g_appLedHandler=APP_LED_StartByMode(APP_LED_MODE_CONN);

    APP_CONN_StartTimeoutTimer();
</#if>
</#if>
<#if booleanappcode ==  true>
<#if wlsblepxpss?? && wlsblepxpss.SS_PXP_BOOL_SERVER == true>
    APP_PXPR_ConnList_T *p_conn = NULL;
    p_conn = APP_WLS_PXPR_GetFreeConnList();
    if (p_conn == NULL)
    { 
        return;
    }
    p_conn->connHandle=p_event->connHandle;
    p_conn->connTxp = 0xF;
    g_ctrlInfo.bAllowNewPairing=false;
    g_ctrlInfo.state=APP_DEVICE_STATE_CONN;
    BLE_PXPR_SetTxPowerLevel(p_conn->connTxp);
    g_appLedHandler=APP_LED_StartByMode(APP_LED_MODE_CONN);                
    APP_WLS_PXPR_Connected();
</#if>
</#if>
}
<#if APP_ANY_PROF == true>
bool APP_WLS_BLE_GetPairedDeviceId(uint8_t *pDevId)
{
    bool ret=false;
    uint8_t devIdList[BLE_DM_MAX_PAIRED_DEVICE_NUM];
    uint8_t devCnt=0;

    BLE_DM_GetPairedDeviceList(devIdList, &devCnt);
    if (devCnt > 0)
    {
        *pDevId =devIdList[0];//should be only 1 dev id
        ret=true;
    }

    return ret;
}
void APP_WLS_BLE_SetResolvingList(bool bSet)
{

    if (bSet)
    {
		uint8_t devId;
		bool    bPaired=APP_WLS_BLE_GetPairedDeviceId(&devId);
		if (bPaired == true)
		{
			uint8_t privacyModeList[1];
			uint8_t devIdList[1];
			devIdList[0] = devId;
			privacyModeList[0] = BLE_GAP_PRIVACY_MODE_DEVICE;
			//Set Resolving List
			BLE_DM_SetResolvingList(1, devIdList, privacyModeList);
		}
    }
    else
    {
        //Clear Resolving List
        BLE_DM_SetResolvingList(0, NULL, NULL);
    }
}

void APP_WLS_BLE_SetFilterAcceptList(bool bSet)
{
    if (bSet)
    {
        uint8_t devId;
        bool    bPaired=APP_WLS_BLE_GetPairedDeviceId(&devId);
        if (bPaired == true)
        {
            uint8_t devIdList[1];
            devIdList[0] = devId;
            //Set Filter Accept List
            BLE_DM_SetFilterAcceptList(1, devIdList);
        }
    }
    else
    {
        //Clear Filter Accept List
        BLE_DM_SetFilterAcceptList(0, NULL);
    }
}
</#if>
<#if APP_ANP_OR_PXP == true>
void APP_WLS_BLE_InitConfig(void)
{
<#if BLE_STACK_LIB.GAP_ADVERTISING == true>
    BLE_GAP_AdvParams_T advParam;
</#if>
    bool                bPaired;
    uint8_t             i;
    //Check if paired device exists, load the info of paired device from pds.
    bPaired=APP_WLS_BLE_GetPairedDeviceId(&g_ctrlInfo.peerDevId);
<#if BLE_STACK_LIB.GAP_ADVERTISING == true>
    //Advertise Parameter
    (void)memset(&advParam, 0, sizeof(BLE_GAP_AdvParams_T));
    advParam.intervalMin = APP_BLE_GAP_ADV_PARAM_INTERVAL_MIN;
    advParam.intervalMax = APP_BLE_GAP_ADV_PARAM_INTERVAL_MAX;
    //Windows/ Android/ iOS support the reconnection using ADV_IND. So using ADV_IND for pairing and reconnection.
    advParam.type = BLE_GAP_ADV_TYPE_ADV_IND;

    advParam.advChannelMap = BLE_GAP_ADV_CHANNEL_ALL;
    if (bPaired)
    {
        advParam.filterPolicy = BLE_GAP_ADV_FILTER_SCAN_CONNECT;
    }
    else
    {
        advParam.filterPolicy = BLE_GAP_ADV_FILTER_DEFAULT;
    }
    BLE_GAP_SetAdvParams(&advParam);
</#if>

    //If paired device exists, set resolving list
    if (bPaired)//Paired already
    {
        APP_WLS_BLE_SetFilterAcceptList(true);
        APP_WLS_BLE_SetResolvingList(true);
    }
    for(i = 0; i < APP_DEVICE_MAX_CONN_NBR; i++)
    {
<#if APP_ANPC ==  true>
    APP_WLS_ANPC_InitConnList(i);
</#if>
<#if APP_PXPR == true>
    APP_WLS_PXPR_InitConnCharList(i);
</#if>
<#if APP_ANPS == true>
    APP_WLS_ANPS_InitConnList(i);
</#if>
<#if APP_PXPM == true>
    APP_WLS_PXPM_InitConnCharList(i);
</#if>
    }
}
</#if>
<#if APP_ANCS_OR_HOGP == true>
void APP_WLS_GenerateRandomData(uint8_t *pData, uint8_t dataLen)
{    
#ifdef PIC32BZ2
    uint8_t       out[APP_RANDOM_BYTE_LEN];
    uint32_t random_part;
    for(uint8_t i = 0; i < sizeof(out); i +=sizeof(random_part)){
        random_part = TRNG_ReadData();
        memcpy(&out[i], &random_part, (sizeof(out) - i)>=sizeof(random_part)?sizeof(random_part):(sizeof(out) - i) );
    }
    if (dataLen <= APP_RANDOM_BYTE_LEN)
    {
        memcpy(pData, out, dataLen);
    }
    else
    {
        memcpy(pData, out, APP_RANDOM_BYTE_LEN);
    }
#elif defined(PIC32BZ3)
    int len = dataLen;
    int ret;
    char rndBytes[64];
    struct sx_trng ctx;
    int chunkSz;
    int i;

    SX_CLK_ENABLE();

    ret = SX_TRNG_INIT(&ctx, NULL);
    if (ret != SX_OK)
    {
        return;
    }

    ret = 1;
    i = 0;
    while (i < len)
    {
        chunkSz = len > APP_TRNG_MAX_CHUNK_SZ ? APP_TRNG_MAX_CHUNK_SZ : len;
        ret = SX_TRNG_GET(&ctx, rndBytes, chunkSz);
        if (ret == SX_ERR_HW_PROCESSING)
        {
            continue;
        }
        if (ret)
        {
            return;
        }

        memcpy(pData, rndBytes, chunkSz);
        pData += chunkSz;
        i += chunkSz;
    }

    SX_CLK_DISABLE();
#endif
}

void APP_WLS_BLE_GenerateRandomStaticAddress(BLE_GAP_Addr_T *pAddr)
{
    //Get a random address and Configure it to Random Static Address
    APP_WLS_GenerateRandomData(pAddr->addr, GAP_MAX_BD_ADDRESS_LEN);
    pAddr->addr[GAP_MAX_BD_ADDRESS_LEN-1] &= ~APP_BLE_GAP_RANDOM_SUB_TYPE_MASK;
    pAddr->addr[GAP_MAX_BD_ADDRESS_LEN-1] |= APP_BLE_GAP_STATIC_ADDR;
    pAddr->addrType = BLE_GAP_ADDR_TYPE_RANDOM_STATIC;
}

void APP_WLS_BLE_SetLocalIRK(void)
{
    BLE_GAP_LocalPrivacyParams_T localPrivacyParams;

    //Set a new IRK
    memset(&localPrivacyParams, 0x00, sizeof(BLE_GAP_LocalPrivacyParams_T));
    localPrivacyParams.addrTimeout = BLE_GAP_RPA_TIMEOUT_MAX;
    APP_WLS_GenerateRandomData(localPrivacyParams.localIrk, 16);
    BLE_GAP_SetLocalPrivacy(false, &localPrivacyParams);
}

void APP_WLS_BLE_ConfigAdvDirect(bool bDirect)
{
    BLE_GAP_AdvParams_T             advParam;

    memset(&advParam, 0, sizeof(BLE_GAP_AdvParams_T));
    advParam.intervalMin = APP_BLE_GAP_ADV_PARAM_INTERVAL_MIN;     /* Advertising Interval Min */
    advParam.intervalMax = APP_BLE_GAP_ADV_PARAM_INTERVAL_MAX;     /* Advertising Interval Max */
    //Windows/ Android/ iOS support the reconnection using ADV_IND. So using ADV_IND for pairing and reconnection.
    advParam.type = BLE_GAP_ADV_TYPE_ADV_IND;        /* Advertising Type */
    advParam.advChannelMap = BLE_GAP_ADV_CHANNEL_ALL;        /* Advertising Channel Map */
    if (bDirect)//Paired already
    {
        advParam.filterPolicy = BLE_GAP_ADV_FILTER_SCAN_CONNECT;     /* Advertising Filter Policy */
    }
    else
    {
        advParam.filterPolicy = BLE_GAP_ADV_FILTER_DEFAULT;     /* Advertising Filter Policy */
    }
    BLE_GAP_SetAdvParams(&advParam);
}

void APP_WLS_BLE_EnableAdvDirect(bool bDirect)
{
<#if APP_HOGP == true>
    g_bConnTimeout=false;
    APP_CONN_StopTimeoutTimer();
</#if>
    if (bDirect)
    {
        g_pairedDevInfo.state=APP_DEVICE_STATE_ADV_DIR;
        g_appLedHandler=APP_LED_StartByMode(APP_LED_MODE_ADV_DIR);
        BLE_GAP_SetAdvEnable(true, APP_ADV_DURATION_30S);
    }
    else
    {
        g_pairedDevInfo.state=APP_DEVICE_STATE_ADV;
        g_appLedHandler=APP_LED_StartByMode(APP_LED_MODE_ADV);
        BLE_GAP_SetAdvEnable(true, APP_ADV_DURATION_60S);
    }
}
uint16_t APP_WLS_BLE_GetExtPairedDevInfoFromFlash(APP_ExtPairedDevInfo_T *pExtInfo)
{
    if (PDS_IsAbleToRestore(PDS_APP_ITEM_ID_1) == false)
        return MBA_RES_INVALID_PARA;

    if (PDS_Restore(PDS_APP_ITEM_ID_1))
    {
        memcpy(pExtInfo, &s_extPairedDevInfoBuf, sizeof(APP_ExtPairedDevInfo_T));
        return MBA_RES_SUCCESS;
    }
    else
    {
        return MBA_RES_FAIL;
    }
}

uint16_t APP_WLS_BLE_SetExtPairedDevInfoInFlash(APP_ExtPairedDevInfo_T *pExtInfo)
{
    memcpy(&s_extPairedDevInfoBuf, pExtInfo, sizeof(APP_ExtPairedDevInfo_T));

    if (PDS_Store(PDS_APP_ITEM_ID_1))
    {
        return MBA_RES_SUCCESS;
    }
    else
    {
        return MBA_RES_FAIL;
    }
}

void APP_WLS_BLE_InitPairedDeviceInfo(void)
{
    g_pairedDevInfo.bPaired=false;
    g_pairedDevInfo.bAddrLoaded=false;
<#if APP_ANCS == true>
    memset(&g_NtfyInfo, 0x00, sizeof(APP_NotificationInfo_T));
    memset(&g_GattClientInfo, 0x00, sizeof(APP_GattClientInfo_T));
</#if>
}

static void APP_WLS_PdsWriteCompleteCb(PDS_MemId_t memoryId)
{
    switch (memoryId)
    {
        case PDS_APP_ITEM_ID_1://PDS_MODULE_APP_OFFSET
        {
            //finish writing
        }
        break;

        case PDS_APP_ITEM_ID_2:
        {
            //finish writing
        }
        break;

        default:
        break;
    }
}

bool APP_WLS_BLE_GetPairedDeviceAddr(BLE_GAP_Addr_T *pAddr)
{
    bool ret=false;
    BLE_DM_PairedDevInfo_T  *p_devInfo;

    p_devInfo = OSAL_Malloc(sizeof(BLE_DM_PairedDevInfo_T));
    if (p_devInfo)
    {
        if (BLE_DM_GetPairedDevice(g_pairedDevInfo.peerDevId, p_devInfo) ==MBA_RES_SUCCESS)
        {
            memcpy(pAddr, &p_devInfo->remoteAddr, sizeof(BLE_GAP_Addr_T));
            ret=true;
        }
        OSAL_Free(p_devInfo);
    }

    return ret;
}

void APP_WLS_RegisterPdsCb(void)
{
    PDS_RegisterWriteCompleteCallback(APP_WLS_PdsWriteCompleteCb
);
}
</#if>
<#if APP_PXPM_OR_ANPS == true>
uint16_t APP_WLS_BLE_ScanEnable(APP_DEVICE_States_T scanType)
{
    uint16_t ret;
    switch (scanType)
    {
        case APP_DEVICE_STATE_WITH_BOND_SCAN:
        {
            g_ctrlInfo.state = scanType;
<#if APP_ANPS == true>
            g_appLedHandler  = APP_LED_StartByMode(APP_LED_MODE_WITH_BOND);
</#if>
<#if APP_PXPM == true>
#ifdef PIC32BZ3
            g_appLedHandler  = APP_LED_StartByMode(APP_LED_MODE_WITH_BOND);
#endif
</#if>
            ret = BLE_GAP_SetScanningEnable(true, BLE_GAP_SCAN_FD_DISABLE, BLE_GAP_SCAN_MODE_GENERAL_DISCOVERY, APP_SCAN_DURATION_30S);
        }
        break;
        case APP_DEVICE_STATE_SCAN:
        {
            g_ctrlInfo.state = scanType;
<#if APP_ANPS == true>
            g_appLedHandler  = APP_LED_StartByMode(APP_LED_MODE_WITHOUT_BOND);
</#if>
<#if APP_PXPM == true>
#ifdef PIC32BZ3
            g_appLedHandler  = APP_LED_StartByMode(APP_LED_MODE_WITHOUT_BOND);
#endif
</#if>
            ret = BLE_GAP_SetScanningEnable(true, BLE_GAP_SCAN_FD_DISABLE, BLE_GAP_SCAN_MODE_GENERAL_DISCOVERY, APP_SCAN_DURATION_60S);
        }
        break;
        default:
        {
            ret = BLE_GAP_SetScanningEnable(false, BLE_GAP_SCAN_FD_DISABLE, BLE_GAP_SCAN_MODE_GENERAL_DISCOVERY, 0);
        }
        break;
    }
    return ret; 
}
uint16_t APP_WLS_BLE_CreateConnection(BLE_GAP_Addr_T *peerAddr)
{
   BLE_GAP_CreateConnParams_T createConnParam;
   createConnParam.scanInterval = 0x0020;
   createConnParam.scanWindow = 0x0020;
   createConnParam.filterPolicy = BLE_GAP_INIT_FP_FAL_NOT_USED;
   if(NULL == memcpy(&createConnParam.peerAddr, peerAddr, sizeof(BLE_GAP_Addr_T)))
   {
       return MBA_RES_NO_RESOURCE;
   }
   createConnParam.connParams.intervalMin = 0x000C;
   createConnParam.connParams.intervalMax = 0x000C;
   createConnParam.connParams.latency = 0x0000;
   createConnParam.connParams.supervisionTimeout = 0x100;
   return BLE_GAP_CreateConnection(&createConnParam);
}
</#if>
<#if APP_PXPR_OR_ANPC == true>
void APP_WLS_BLE_ConfigAdv(uint8_t advType)
{
    BLE_GAP_AdvParams_T             advParam;

    (void)memset(&advParam, 0, sizeof(BLE_GAP_AdvParams_T));
    advParam.intervalMin = APP_BLE_GAP_ADV_PARAM_INTERVAL_MIN;     /* Advertising Interval Min */
    advParam.intervalMax = APP_BLE_GAP_ADV_PARAM_INTERVAL_MAX;     /* Advertising Interval Max */
    //Windows/ Android/ iOS support the reconnection using ADV_IND. So using ADV_IND for pairing and reconnection.
    advParam.type = BLE_GAP_ADV_TYPE_ADV_IND;        /* Advertising Type */
    advParam.advChannelMap = BLE_GAP_ADV_CHANNEL_ALL;        /* Advertising Channel Map */
    if (advType == APP_DEVICE_STATE_ADV_DIR)//Paired already
    {
        advParam.filterPolicy = BLE_GAP_ADV_FILTER_SCAN_CONNECT;     /* Advertising Filter Policy */
    }
    else
    {
        advParam.filterPolicy = BLE_GAP_ADV_FILTER_DEFAULT;     /* Advertising Filter Policy */
    }
    BLE_GAP_SetAdvParams(&advParam);
}

void APP_WLS_BLE_EnableAdv(uint8_t advType)
{
    if (advType == APP_DEVICE_STATE_ADV_DIR)
    {
        g_ctrlInfo.state=APP_DEVICE_STATE_ADV_DIR;
        g_appLedHandler=APP_LED_StartByMode(APP_LED_MODE_ADV_DIR);
        BLE_GAP_SetAdvEnable(true, APP_ADV_DURATION_30S);
    }
    else
    {
        g_ctrlInfo.state=APP_DEVICE_STATE_ADV;
        g_appLedHandler=APP_LED_StartByMode(APP_LED_MODE_ADV);
        BLE_GAP_SetAdvEnable(true, APP_ADV_DURATION_60S);
    }
}
</#if>
<#if APP_HOGP == true>
uint16_t APP_WLS_BLE_GetPairedDevGattInfoFromFlash(APP_PairedDevGattInfo_T *pInfo)
{
    if (PDS_IsAbleToRestore(PDS_APP_ITEM_ID_2) == false)
        return MBA_RES_INVALID_PARA;

    if (PDS_Restore(PDS_APP_ITEM_ID_2))
    {
        memcpy(pInfo, &s_PairedDevGattInfoBuf, sizeof(APP_PairedDevGattInfo_T));
        return MBA_RES_SUCCESS;
    }
    else
    {
        return MBA_RES_FAIL;
    }
}

uint16_t APP_WLS_BLE_SetPairedDevGattInfoInFlash(APP_PairedDevGattInfo_T *pInfo)
{
    memcpy(&s_PairedDevGattInfoBuf, pInfo, sizeof(APP_PairedDevGattInfo_T));

    if (PDS_Store(PDS_APP_ITEM_ID_2))
    {
        return MBA_RES_SUCCESS;
    }
    else
    {
        return MBA_RES_FAIL;
    }
}

void APP_WLS_BLE_ConnTimeoutAction(void)
{
    if (g_pairedDevInfo.state == APP_DEVICE_STATE_CONN)
    {
        g_bConnTimeout=true;
        BLE_GAP_Disconnect(g_pairedDevInfo.connHandle, GAP_DISC_REASON_REMOTE_TERMINATE);
    }
}
</#if>
<#if booleanappcode ==  true>
<#if APP_THROUGHPUT == true>
/*******************************************************************************
  Function:
    void APP_WLS_BLE_InitAdvParams(void)

  Summary:
     Function for Initiating adverising parameters.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
static void APP_WLS_BLE_InitAdvParams(void) {
    s_bleAdvParam.intervalMin = APP_ADV_DEFAULT_INTERVAL;
    s_bleAdvParam.intervalMax = APP_ADV_DEFAULT_INTERVAL;
    s_bleAdvParam.advType = BLE_GAP_ADV_TYPE_ADV_IND;
    s_bleAdvParam.filterPolicy = BLE_GAP_ADV_FILTER_DEFAULT;
}
/*******************************************************************************
  Function:
    static uint8_t APP_WLS_BLE_CalculateDataLength(uint8_t *advData)

  Summary:
     Function for calculating data length.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
static uint8_t APP_WLS_BLE_CalculateDataLength(uint8_t *advData) {
    /* Caculate Total Length of Adv Data /Scan Response Data Elements  */
    uint8_t len = 0, i = 0;

    while (1) {
        if (advData[i] != 0x00) // Check the length is Zero or not
        {
            len++; // Add Length field size
            len += advData[i]; // Add this Element Data Size

            if (len >= BLE_GAP_ADV_MAX_LENGTH) {
                len = BLE_GAP_ADV_MAX_LENGTH;
                break;
            } else {
                i = len;
            }
        } else {
            break;
        }
    }
    return len;
}
/*******************************************************************************
  Function:
    uint8_t APP_WLS_BLE_GetAdvertisingType(void)

  Summary:
    Function to get advertisement type.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
uint8_t APP_WLS_BLE_GetAdvertisingType(void) {
    return s_bleAdvParam.advType;
}
/*******************************************************************************
  Function:
    uint16_t APP_WLS_BLE_SetAdvertisingType(uint8_t advType)

  Summary:
    Function to set advertisement type.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
uint16_t APP_WLS_BLE_SetAdvertisingType(uint8_t advType) {
    if (advType > BLE_GAP_ADV_TYPE_ADV_DIRECT_LOW_IND) {
        return APP_RES_INVALID_PARA;
    }

    s_bleAdvParam.advType = advType;

    return APP_RES_SUCCESS;
}
/*******************************************************************************
  Function:
    uint16_t APP_WLS_BLE_SetAdvertisingParams(void)

  Summary:
    Function to set advertisement parameters.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
uint16_t APP_WLS_BLE_SetAdvertisingParams(void) {
    BLE_GAP_AdvParams_T advParams;

    memset((uint8_t *) & advParams, 0, sizeof (BLE_GAP_AdvParams_T));

    advParams.intervalMin = s_bleAdvParam.intervalMin;
    advParams.intervalMax = s_bleAdvParam.intervalMax;
    advParams.type = s_bleAdvParam.advType;
    advParams.peerAddr.addrType = BLE_GAP_ADDR_TYPE_PUBLIC;

    //advParams.peerAddr.addr = ;   //Peer address (For directed adverising used)

    advParams.advChannelMap = BLE_GAP_ADV_CHANNEL_ALL;
    advParams.filterPolicy = s_bleAdvParam.filterPolicy;

    return BLE_GAP_SetAdvParams(&advParams);
}
/*******************************************************************************
  Function:
    void APP_WLS_BLE_UpdateScanRspData(void)

  Summary:
    Function to update scan response data.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_WLS_BLE_UpdateScanRspData(void) {
    uint8_t localName[GAP_MAX_DEVICE_NAME_LEN + 2] = {0};
    uint8_t localNameLen = 0;
  

    memset(localName, 0x00, GAP_MAX_DEVICE_NAME_LEN + 2);
    
    BLE_GAP_GetDeviceName(&localNameLen, &localName[2]);

    localName[0] = localNameLen + APP_ADV_TYPE_LEN;
    localName[1] = APP_ADV_TYPE_COMPLETE_LOCAL_NAME;    
    localNameLen = APP_WLS_BLE_CalculateDataLength(localName);

    APP_UTILITY_UpdateBleScanRspUserData(localName, localNameLen + 2);
}
/*******************************************************************************
  Function:
    void APP_WLS_BLE_SetFilterPolicy(uint8_t filterPolicy)

  Summary:
    Function to set filter policy.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_WLS_BLE_SetFilterPolicy(uint8_t filterPolicy) {
    s_bleAdvParam.filterPolicy = filterPolicy;
}
/*******************************************************************************
  Function:
    uint8_t APP_WLS_BLE_GetFilterPolicy(void)

  Summary:
    Function to get filter policy.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
uint8_t APP_WLS_BLE_GetFilterPolicy(void) {
    return s_bleAdvParam.filterPolicy;
}
/*******************************************************************************
  Function:
    uint16_t APP_WLS_BLE_Ctrl(uint8_t enable)

  Summary:
    Function to control advertisemnt.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
uint16_t APP_WLS_BLE_Ctrl(uint8_t enable) {
    uint16_t result = APP_RES_BAD_STATE;

    if (enable) {
        if (APP_WLS_BLE_GetState() == APP_DEVICE_STATE_IDLE) {
            result = BLE_GAP_SetAdvEnable(true, 0);

            if (result == APP_RES_SUCCESS) {
                APP_WLS_BLE_SetState(APP_DEVICE_STATE_ADV);
                g_appLedGreenHandler = APP_LED_StartByMode(APP_LED_MODE_ADV);
            }
        }
    }
    else {
        if (APP_WLS_BLE_GetState() == APP_DEVICE_STATE_ADV) {
            result = BLE_GAP_SetAdvEnable(false, 0);

            if (result == APP_RES_SUCCESS) {
                APP_WLS_BLE_SetState(APP_DEVICE_STATE_IDLE);
            }
        }
    }

    return result;
}
/*******************************************************************************
  Function:
    void APP_WLS_BLE_Start(void)

  Summary:
    Function to start advertisement.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_WLS_BLE_Start(void) {
    
    APP_WLS_BLE_SetAdvertisingParams();
    APP_WLS_BLE_UpdateScanRspData();
    APP_WLS_BLE_Ctrl(true);
}
/*******************************************************************************
  Function:
    void APP_WLS_BLE_Stop(void)

  Summary:
    Function to stop advertisement.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_WLS_BLE_Stop(void) {
    APP_WLS_BLE_Ctrl(false);
}
/*******************************************************************************
  Function:
    void APP_ADV_Init(void)

  Summary:
    Function to initialise advertisement.

  Description:

  Precondition:

  Parameters:                
              

  Returns:
    None.
*/
void APP_ADV_Init(void) {
    APP_WLS_BLE_InitAdvParams();
    APP_WLS_BLE_Start();
}
</#if>
</#if>