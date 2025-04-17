<#if booleanappcode ==  true>
<#if wlsblehogp?? && wlsblehogp.HOGP_BOOL_SERVER == true>
/*******************************************************************************
* Copyright (C) 2023 Microchip Technology Inc. and its subsidiaries.
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
    app_module.h

  Summary:
    This header file provides functions for the application.

  Description:
    This header file provides functions for the application.
*******************************************************************************/

#ifndef APP_MODULE_H
#define APP_MODULE_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************
#include <stdint.h>
#include <string.h>
#include <stdbool.h>
#include "mba_error_defs.h"
#include "gap_defs.h"
#include "ble_gap.h"
#include "gatt.h"
#include "app_key.h"

// *****************************************************************************
// *****************************************************************************
// Section: Macros
// *****************************************************************************
// *****************************************************************************
#define APP_USER_KEYS_NUM   5

// *****************************************************************************
// *****************************************************************************
// Section: Data Types
// *****************************************************************************
typedef enum
{
    APP_HOGPS_STATE_INIT=0,
    APP_HOGPS_STATE_IDLE,
    APP_HOGPS_STATE_ADV,
    APP_HOGPS_STATE_ADV_DIR,
    APP_HOGPS_STATE_CONN,
} APP_HOGPS_STATES;

typedef struct APP_PairedDevInfo_T{
    bool bPaired;
    BLE_GAP_Addr_T addr;
    uint16_t connHandle;
    APP_HOGPS_STATES state;
    bool bAddrLoaded;
    uint8_t peerDevId;                  //Peer Device Id which is the pointer to the pairing data in DM(actually in flash)
    bool bPeerDevIdExist;               //If Peer Device Id exists in DM(actually in flash)
}APP_PairedDevInfo_T;

typedef struct APP_ExtPairedDevInfo_T{
    BLE_GAP_Addr_T localAddr;
    bool bConnectedByResolvedAddr;
}APP_ExtPairedDevInfo_T;

#define APP_MAX_CCCD_NUM                    0x07
typedef struct APP_PairedDevGattInfo_T{
    uint8_t             serviceChange;
    uint8_t             clientSupportFeature;
    uint8_t             numOfCccd;
    GATTS_CccdList_T    cccdList[APP_MAX_CCCD_NUM];
}APP_PairedDevGattInfo_T;

// *****************************************************************************
// *****************************************************************************
// Section: Global Variables
// *****************************************************************************
// *****************************************************************************
extern APP_PairedDevInfo_T g_pairedDevInfo;
extern APP_ExtPairedDevInfo_T g_extPairedDevInfo;
extern APP_PairedDevGattInfo_T g_PairedDevGattInfo;
extern bool g_bConnTimeout;
extern bool g_bAllowNewPairing;
extern uint8_t g_userKeysCAPON[APP_USER_KEYS_NUM];
extern uint8_t g_userKeysCAPOF[APP_USER_KEYS_NUM];

// *****************************************************************************
// *****************************************************************************
// Section: Function Prototypes
// *****************************************************************************
// *****************************************************************************
void APP_WLS_BLE_EnableAdvDirect(bool bDirect);
void APP_WLS_BLE_ConfigAdvDirect(bool bDirect);
void APP_WLS_BLE_SetResolvingList(bool bSet);
void APP_WLS_BLE_SetFilterAcceptList(bool bSet);
void APP_WLS_BLE_GenerateRandomStaticAddress(BLE_GAP_Addr_T *pAddr);
void APP_WLS_BLE_SetLocalIRK(void);
void APP_WLS_BLE_InitPairedDeviceInfo(void);
uint16_t APP_WLS_BLE_GetExtPairedDevInfoFromFlash(APP_ExtPairedDevInfo_T *pExtInfo);
uint16_t APP_WLS_BLE_SetExtPairedDevInfoInFlash(APP_ExtPairedDevInfo_T *pExtInfo);
uint16_t APP_WLS_BLE_GetPairedDevGattInfoFromFlash(APP_PairedDevGattInfo_T *pInfo);
uint16_t APP_WLS_BLE_SetPairedDevGattInfoInFlash(APP_PairedDevGattInfo_T *pInfo);
void APP_WLS_HOGPS_PressFewKeys(uint8_t *pKeys, uint8_t key_num);
void APP_KeyFunction(APP_KEY_MSG_T msg);
void APP_WLS_BLE_ConnTimeoutAction(void);
void APP_WLS_RegisterPdsCb(void);
bool APP_WLS_BLE_GetPairedDeviceId(uint8_t *pDevId);
bool APP_WLS_BLE_GetPairedDeviceAddr(BLE_GAP_Addr_T *pAddr);
void APP_WLS_GenerateRandomData(uint8_t *pData, uint8_t dataLen);
/*******************************************************************************
 End of File
 */

#endif /* APP_MODULE_H */

</#if>
<#if wlsbleancsss?? && wlsbleancsss.SS_ANCS_BOOL_CLIENT == true>
/*******************************************************************************
* Copyright (C) 2023 Microchip Technology Inc. and its subsidiaries.
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
    app_module.h

  Summary:
    This header file provides functions for the application.

  Description:
    This header file provides functions for the application.
*******************************************************************************/

#ifndef APP_MODULE_H
#define APP_MODULE_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>
#include "mba_error_defs.h"
#include "gap_defs.h"
#include "ble_gap.h"
#include "gatt.h"
#include "app_key.h"
#include "ble_ancs/ble_ancs.h"

// *****************************************************************************
// *****************************************************************************
// Section: Macros
// *****************************************************************************
// *****************************************************************************

// *****************************************************************************
// *****************************************************************************
// Section: Data Types
// *****************************************************************************
typedef enum
{
    APP_ANCS_STATE_INIT=0,
    APP_ANCS_STATE_IDLE,
    APP_ANCS_STATE_ADV,
    APP_ANCS_STATE_ADV_DIR,
    APP_ANCS_STATE_CONN,
} APP_ANCS_STATES;

typedef struct APP_PairedDevInfo_T{
    bool bPaired;
    BLE_GAP_Addr_T addr;
    uint16_t connHandle;
    APP_ANCS_STATES state;
    bool bAddrLoaded;
    uint8_t peerDevId;                  //Peer Device Id which is the pointer to the pairing data in DM(actually in flash)
    bool bPeerDevIdExist;               //If Peer Device Id exists in DM(actually in flash)
}APP_PairedDevInfo_T;

typedef struct APP_ExtPairedDevInfo_T{
    BLE_GAP_Addr_T localAddr;
    bool bConnectedByResolvedAddr;
}APP_ExtPairedDevInfo_T;

typedef enum
{
    APP_ANCS_IND_INIT=0,
    APP_ANCS_IND_NTFY_ADDED,
    APP_ANCS_IND_NTFY_ATTR,
    APP_ANCS_IND_APP_ATTR,
    APP_ANCS_IND_NTFY_REMOVED,
} APP_ANCS_IND_STATES;

typedef struct APP_NotificationInfo_T{
    bool                        bNtfyAdded; //if receive Notification Added or not
    uint32_t                    ntfyId;     //Notification UID
    APP_ANCS_IND_STATES         state;
    BLE_ANCS_NtfyEvtFlagMask_T  ntfyEvtFlagMask;        /**< Bitmask to signal whether a special condition applies to the notification. For example, "Silent" or "Important". */
    BLE_ANCS_NtfyAttrsMask_T    ntfyAttrBitMask;
    uint8_t                     positiveAction[BLE_ANCS_MAX_POS_ACTION_LABEL_LEN]; /**< Valid if Positive Action is enabled. */
    uint8_t                     negativeAction[BLE_ANCS_MAX_NEG_ACTION_LABEL_LEN]; /**< Valid if Negative Action is enabled. */
    uint8_t                     appId[BLE_ANCS_MAX_APPID_LEN];
}APP_NotificationInfo_T;

typedef struct APP_GattClientInfo_T{
    bool bDiscoveryDone;
}APP_GattClientInfo_T;

// *****************************************************************************
// *****************************************************************************
// Section: Global Variables
// *****************************************************************************
// *****************************************************************************
extern APP_PairedDevInfo_T g_pairedDevInfo;
extern APP_ExtPairedDevInfo_T g_extPairedDevInfo;
extern bool g_bAllowNewPairing;
extern APP_NotificationInfo_T g_NtfyInfo;
extern APP_GattClientInfo_T g_GattClientInfo;
// *****************************************************************************
// *****************************************************************************
// Section: Function Prototypes
// *****************************************************************************
// *****************************************************************************
void APP_WLS_BLE_EnableAdvDirect(bool bDirect);
void APP_WLS_BLE_ConfigAdvDirect(bool bDirect);
void APP_WLS_BLE_SetResolvingList(bool bSet);
void APP_WLS_BLE_SetFilterAcceptList(bool bSet);
void APP_WLS_BLE_GenerateRandomStaticAddress(BLE_GAP_Addr_T *pAddr);
void APP_WLS_BLE_SetLocalIRK(void);
void APP_WLS_BLE_InitPairedDeviceInfo(void);
uint16_t APP_WLS_BLE_GetExtPairedDevInfoFromFlash(APP_ExtPairedDevInfo_T *pExtInfo);
uint16_t APP_WLS_BLE_SetExtPairedDevInfoInFlash(APP_ExtPairedDevInfo_T *pExtInfo);
void APP_KeyFunction(APP_KEY_MSG_T msg);
void APP_WLS_BLE_ConnTimeoutAction(void);
void APP_WLS_RegisterPdsCb(void);
bool APP_WLS_BLE_GetPairedDeviceId(uint8_t *pDevId);
bool APP_WLS_BLE_GetPairedDeviceAddr(BLE_GAP_Addr_T *pAddr);
void APP_WLS_GenerateRandomData(uint8_t *pData, uint8_t dataLen);
/*******************************************************************************
 End of File
 */

#endif /* APP_MODULE_H */

</#if>
</#if>
