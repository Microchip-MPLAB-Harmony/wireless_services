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
    app_ble_callbacks.h

  Summary:
    This file contains API functions for the user to implement his business logic.

  Description:
    API functions for the user to implement his business logic.
*******************************************************************************/

#ifndef APP_BLE_CALLBACKS_H
#define	APP_BLE_CALLBACKS_H

#ifdef	__cplusplus
extern "C" {
#endif

/*******************Header section common*****************/
#include "ble_gap.h"
#include "definitions.h"
#include "ble_dm/ble_dm.h" 
<#if wlsbleancsss?? && wlsbleancsss.SS_ANCS_BOOL_CLIENT == true>
#include "app_led.h"
#include "ble_ancs/ble_ancs.h"
</#if>
<#if wlsbleanpss?? &&  wlsbleanpss.ANPSS_BOOL_SERVER == true>
#include "app_anps_callbacks.h"
#include "app_led.h"
</#if>
<#if wlsbleanpss?? &&  wlsbleanpss.ANPSS_BOOL_CLIENT == true>
#include "ble_dm/ble_dm_dds.h"
#include "app_anpc_callbacks.h"
#include "app_led.h"
</#if>
<#if booleanappcode ==  true>
<#if wlsblepxpss?? &&  wlsblepxpss.SS_PXP_BOOL_SERVER == true>
#include "app_led.h"
#include "app_timer.h"
#include "app_key.h"
#include "ble/profile_ble/ble_pxpr/ble_pxpr.h"
#include "app_pxpr_callbacks.h"
</#if>
</#if>
<#if wlsblepxpss?? &&  wlsblepxpss.SS_PXP_BOOL_CLIENT == true>
#include "app_pxpm_callbacks.h"
</#if>
<#if booleanappcode ==  true>
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true && WLS_BLE_BOOL_GAP_EXT_ADV == false && WLS_BLE_GAP_DSADV_EN == false && WLS_BLE_BOOL_L2CAP_CREDIT_FLOWCTRL == true>    
#include "app_trp_common.h"
#include "ble_util/byte_stream.h"
#include "app_error_defs.h"
#include "app_led.h"
#include "app_trsps_callbacks.h"
</#if> 
</#if>
<#if booleanappcode ==  true>
<#if APP_THROUGHPUT == true>
#include <stdint.h>
</#if>
</#if>
/*****************************************************************************/   
    
/************************Macros defined here**************/

/**************************************************************************************/     
<#if booleanappcode ==  true>
<#if wlsblepxpss?? &&  wlsblepxpss.SS_PXP_BOOL_SERVER == true>    
#define TH_MID_ALERT                ((int8_t)0x4B) //  75db
#define TH_HIGH_ALERT               ((int8_t)0x55) //  85db   
</#if>  
</#if>
<#if booleanappcode ==  true>
<#if WLS_BLE_GAP_PERIPHERAL == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true && WLS_BLE_BOOL_GAP_EXT_ADV == true && WLS_BLE_GAP_PRI_ADV_PHY == "1" && WLS_BLE_GAP_SEC_ADV_PHY == "2">
${WLS_BLE_COMMENT}

#define APP_BLE_CODED_PHY_ENABLE

#ifdef APP_BLE_1M_PHY_ENABLE
  #undef APP_BLE_2M_PHY_ENABLE
  #undef APP_BLE_CODED_PHY_ENABLE
#elif defined(APP_BLE_2M_PHY_ENABLE)
  #undef APP_BLE_1M_PHY_ENABLE
  #undef APP_BLE_CODED_PHY_ENABLE
#elif defined(APP_BLE_CODED_PHY_ENABLE)
  #undef APP_BLE_1M_PHY_ENABLE
  #undef APP_BLE_2M_PHY_ENABLE
#else
  #define APP_BLE_CODED_PHY_ENABLE
#endif


#define APP_BLE_CODED_S8_ENABLE
#ifndef APP_BLE_CODED_S8_ENABLE
  #define APP_BLE_CODED_S2_ENABLE
#endif
</#if>
<#if WLS_BLE_GAP_CENTRAL == true  && WLS_BLE_GAP_SCAN == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_CLIENT == true  && WLS_BLE_BOOL_GAP_EXT_SCAN == true && WLS_BLE_GAP_EXT_SCAN_PHY == "2">
${WLS_BLE_COMMENT}
#define APP_BLE_CODED_PHY_ENABLE
//#define APP_BLE_CODED_S8_ENABLE
#ifndef APP_BLE_CODED_S8_ENABLE
#define APP_BLE_CODED_S2_ENABLE
#endif
</#if>
<#if WLS_BLE_BOOL_GAP_EXT_SCAN == true && WLS_BLE_GAP_CENTRAL == true && !wlsbletrspss??>
${WLS_BLE_COMMENT}
#define APP_BLE_GPIO_NUM  0x08
#define APP_BLE_ADV_DATA_LEN  19
#define APP_BLE_ADV_DATA 9
</#if>
<#if WLS_BLE_GAP_CENTRAL == true  && WLS_BLE_GAP_SCAN == true && WLS_BLE_GAP_SVC_PERI_PRE_CP == true> 
#define APP_BLE_CREATE_CONN_SCAN_INTERVAL           0x3C
#define APP_BLE_CREATE_CONN_SCAN_WINDOW             0x1E
#define APP_BLE_CREATE_CONN_INTERVAL_MIN            0x10   
#define APP_BLE_CREATE_CONN_INTERVAL_MAX            0x10    
#define APP_BLE_CREATE_CONN_LATENCY                 0
#define APP_BLE_CREATE_CONN_SUPERVISION_TIOMEOUT    0x48
</#if>
<#if WLS_BLE_GAP_CENTRAL == true  && WLS_BLE_GAP_SCAN == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_CLIENT == true && WLS_BLE_BOOL_GAP_EXT_SCAN == false>
${WLS_BLE_COMMENT}
#define APP_BLE_CREATE_CONN_SCAN_INTERVAL           0x3C
#define APP_BLE_CREATE_CONN_SCAN_WINDOW             0x1E
#define APP_BLE_CREATE_CONN_INTERVAL_MIN            0x10   
#define APP_BLE_CREATE_CONN_INTERVAL_MAX            0x10    
#define APP_BLE_CREATE_CONN_LATENCY                 0
#define APP_BLE_CREATE_CONN_SUPERVISION_TIOMEOUT    0x48
</#if>
<#if WLS_BLE_GAP_CENTRAL == true  && WLS_BLE_GAP_SCAN == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_CLIENT == true  && WLS_BLE_BOOL_GAP_EXT_SCAN == true && WLS_BLE_GAP_EXT_SCAN_PHY == "2">
#define APP_BLE_CREATE_CONN_SCAN_INTERVAL           0x3C
#define APP_BLE_CREATE_CONN_SCAN_WINDOW             0x1E
#define APP_BLE_CREATE_CONN_INTERVAL_MIN            0x10   
#define APP_BLE_CREATE_CONN_INTERVAL_MAX            0x10    
#define APP_BLE_CREATE_CONN_LATENCY                 0
#define APP_BLE_CREATE_CONN_SUPERVISION_TIOMEOUT    0x48
</#if>
</#if>
<#if APP_ANP_OR_PXP == true>
#define APP_DEVICE_MAX_CONN_NBR (0x01U)
</#if>
<#if APP_HOGP == true>
#define APP_MAX_CCCD_NUM             0x07U
</#if>
<#if APP_ANY_PROF = true>
#define APP_BLE_GAP_ADV_PARAM_INTERVAL_MIN			32
#define APP_BLE_GAP_ADV_PARAM_INTERVAL_MAX			32
</#if>
<#if booleanappcode ==  true>
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true && WLS_BLE_BOOL_GAP_EXT_ADV == false && WLS_BLE_GAP_DSADV_EN == false && WLS_BLE_BOOL_L2CAP_CREDIT_FLOWCTRL == true> 
#define APP_BLE_NUM_ADDR_IN_DEV_NAME    2    /**< The number of bytes of device address included in the device name. */


/**@brief Maximum device in peripheral role. */
#define APP_TRPS_MAX_LINK_NUMBER        BLE_TRSPS_MAX_CONN_NBR

/**@brief Maximum device in central role. */
#define APP_TRPC_MAX_LINK_NUMBER        BLE_TRSPC_MAX_CONN_NBR

/**@defgroup APP_BLE_MAX_LINK_NUMBER APP_BLE_MAX_LINK_NUMBER
 * @brief The definition of maximum BLE links that can exist
 * @{ */
#define APP_BLE_MAX_LINK_NUMBER         BLE_GAP_MAX_LINK_NBR
/** @} */

//#define APP_BLE_L2CAP_MAX_LINK_NUM      0x02   //BLE_TRCBPS_MAX_CONN_NBR

#define APP_BLE_UNKNOWN_ID              0xFF
</#if> 
</#if> 
<#if booleanappcode ==  true>
<#if APP_THROUGHPUT == true>
/**@defgroup APP_ADV_DEFAULT_INTERVAL APP_ADV_DEFAULT_INTERVAL
 * @brief The default value for the BLE Advertising interval. Unit: 0.625 ms. Default: 0x0200 (320 milliseconds)
 * @{ */
#define APP_ADV_DEFAULT_INTERVAL                                        0x0200
/** @} */

/**@defgroup APP_ADV_TYPE APP_ADV_TYPE
* @brief The definition of the advertising type
* @{ */
#define APP_ADV_TYPE_FLAGS                                              0x01       /**< Flags. */
#define APP_ADV_TYPE_INCOMPLETE_16BIT_SRV_UUID                          0x02       /**< Incomplete List of 16-bit Service Class UUIDs. */
#define APP_ADV_TYPE_COMPLETE_16BIT_SRV_UUID                            0x03       /**< Complete List of 16-bit Service Class UUIDs. */
#define APP_ADV_TYPE_SHORTENED_LOCAL_NAME                               0x08       /**< Shortened Local Name. */
#define APP_ADV_TYPE_COMPLETE_LOCAL_NAME                                0x09       /**< Complete Local Name. */
#define APP_ADV_TYPE_TX_POWER                                           0x0A       /**< Tx Power Level. */
#define APP_ADV_TYPE_SRV_DATA_16BIT_UUID                                0x16       /**< Service Data - 16-bit UUID. */
#define APP_ADV_TYPE_MANU_DATA                                          0xFF       /**< Manufacture Specific Data. */
/** @} */

/** @brief Advertising data size. */
#define APP_ADV_TYPE_LEN                                                0x01       /**< Length of advertising data type. */
#define APP_ADV_SRV_DATA_LEN                                            0x04       /**< Length of service data. */
#define APP_ADV_SRV_UUID_LEN                                            0x02       /**< Length of service UUID. */

/**@defgroup APP_ADV_FLAG APP_ADV_FLAG
* @brief The definition of the mask setting for the advertising type
* @{ */
#define APP_ADV_FLAG_LE_LIMITED_DISCOV                                              (1 << 0)       /**< LE Limited Discoverable Mpde. */
#define APP_ADV_FLAG_LE_GEN_DISCOV                                                  (1 << 1)       /**< LE General Discoverable Mpde. */
#define APP_ADV_FLAG_BREDR_NOT_SUPPORTED                                            (1 << 2)       /**< BR/EDR Not Supported. */
#define APP_ADV_FLAG_SIMULTANEOUS_LE_BREDR_TO_SAME_DEVICE_CAP_CONTROLLER            (1 << 3)       /**< Simultaneous LE and BR/EDR to Same Device Capable (Controller). */
#define APP_ADV_FLAG_SIMULTANEOUS_LE_BREDR_TO_SAME_DEVICE_CAP_HOST                  (1 << 4)       /**< Simultaneous LE and BR/EDR to Same Device Capable (Host). */
/** @} */

#define APP_ADV_COMPANY_ID_MCHP                                         0x00CD
#define APP_ADV_SERVICE_UUID_MCHP                                       0xFEDA
#define APP_ADV_ADD_DATA_CLASS_BYTE                                     0xFF

/**@defgroup APP_ADV_PROD_TYPE APP_ADV_PROD_TYPE
* @brief The definition of the product type in the advertising data
* @{ */
#define APP_ADV_PROD_TYPE_BLE_UART                                                  0x01           /**< Product Type: BLE UART */
/** @} */

/**@defgroup APP_ADV_FEATURE_SET APP_ADV_FEATURE_SET
* @brief The definition of the mask setting for the feature set in the advertising data
* @{ */
#define APP_ADV_FEATURE_SET_FEATURE1                                                (1 << 0)       /**< Feature 1. */
#define APP_ADV_FEATURE_SET_FEATURE2                                                (1 << 1)       /**< Feature 2. */
/** @} */


/**@brief The definition of the advertising set number. (Only for extended advertising)
* @{ */
#define APP_ADV_SET_NUM                                                  0x02                     /**< Number of advertising set. */
/** @} */

/**@brief The definition of the advertising handle. (Only for extended advertising)
* @{ */
#define APP_ADV_HANDLE1                                                  0x00                     /**< Advertising handle of advertising set 1. */
#define APP_ADV_HANDLE2                                                  0x01                     /**< Advertising handle of advertising set 2. */
/** @} */

/**@brief The definition of the value to be transmitted in the advertising SID subfield of the ADI field of the Extended Header. (Only for extended advertising)
* @{ */
#define APP_ADV_SID1                                                     0x00                     /**< SID of advertising set 1. */
#define APP_ADV_SID2                                                     0x01                     /**< SID of advertising set 2. */
/** @} */
</#if>
</#if>
// *****************************************************************************
// *****************************************************************************
// Section: Data Types
// *****************************************************************************
// *****************************************************************************
<#if booleanappcode ==  true>
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true && WLS_BLE_BOOL_GAP_EXT_ADV == false && !(wlsbletrspss.SS_TRSP_BOOL_CLIENT == true && wlsbletrspss.SS_TRSP_BOOL_SERVER == true)>
${WLS_BLE_COMMENT}
extern uint16_t conn_handle;
</#if>
<#if WLS_BLE_GAP_CENTRAL == true  && WLS_BLE_GAP_SCAN == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_CLIENT == true && WLS_BLE_BOOL_GAP_EXT_SCAN == false && !(wlsbletrspss.SS_TRSP_BOOL_CLIENT == true && wlsbletrspss.SS_TRSP_BOOL_SERVER == true) &&  numberoflinks <=1>
${WLS_BLE_COMMENT}
extern uint16_t conn_handle;
</#if>
<#-- For central multilink configuration -->
<#if wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_CLIENT == true &&  WLS_BLE_GAP_CENTRAL == true && WLS_BLE_GAP_SCAN == true && !(wlsbletrspss.SS_TRSP_BOOL_SERVER == true) && (numberoflinks == 2 || numberoflinks == 3)>
${WLS_BLE_COMMENT}
extern uint16_t conn_hdl[CONFIG_APP_BLE_MAXIMUM_NUMBER_OF_LINKS];
extern uint8_t no_of_links;
</#if>
<#if WLS_BLE_GAP_CENTRAL == true  && WLS_BLE_GAP_SCAN == true && WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true  && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true  && wlsbletrspss.SS_TRSP_BOOL_CLIENT == true>
${WLS_BLE_COMMENT}
extern uint16_t conn_hdl[CONFIG_APP_BLE_MAXIMUM_NUMBER_OF_LINKS];
extern uint8_t no_of_links;
</#if>
<#if WLS_BLE_GAP_PERIPHERAL == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true && WLS_BLE_BOOL_GAP_EXT_ADV == true && WLS_BLE_GAP_PRI_ADV_PHY == "1" && WLS_BLE_GAP_SEC_ADV_PHY == "2">
${WLS_BLE_COMMENT}
extern uint16_t conn_handle;
</#if>
<#if WLS_BLE_GAP_CENTRAL == true  && WLS_BLE_GAP_SCAN == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_CLIENT == true  && WLS_BLE_BOOL_GAP_EXT_SCAN == true && WLS_BLE_GAP_EXT_SCAN_PHY == "2">
${WLS_BLE_COMMENT}
extern uint16_t conn_handle;
</#if>
</#if>
<#if booleanappcode ==  true>
<#if wlsbleancsss?? && wlsbleancsss.SS_ANCS_BOOL_CLIENT == true 
        || wlsblehogp?? && wlsblehogp.HOGP_BOOL_SERVER == true 
        || wlsbleanpss?? && (wlsbleanpss.ANPSS_BOOL_SERVER == true || wlsbleanpss.ANPSS_BOOL_CLIENT == true) 
        || wlsblepxpss?? && (wlsblepxpss.SS_PXP_BOOL_CLIENT == true || wlsblepxpss.SS_PXP_BOOL_SERVER == true)>
typedef enum APP_DEVICE_States_T
{
	APP_DEVICE_STATE_INIT=0,
    APP_DEVICE_STATE_IDLE,
<#if BLE_STACK_LIB.GAP_ADVERTISING == true>
    APP_DEVICE_STATE_ADV,
    APP_DEVICE_STATE_ADV_DIR,
    APP_DEVICE_STATE_CONN,
</#if>
<#if BLE_STACK_LIB.GAP_SCAN == true>
    APP_DEVICE_STATE_CONNECTING,
    APP_DEVICE_STATE_CONNECTED,
    APP_DEVICE_STATE_WITH_BOND_SCAN,
    APP_DEVICE_STATE_SCAN,
</#if>
    APP_DEVICE_STATE_END
} APP_DEVICE_States_T;
</#if>
</#if>
<#if APP_ANY_PROF == true>
typedef struct APP_PairedDevInfo_T{
    bool bPaired;
    BLE_GAP_Addr_T addr;
    uint16_t connHandle;
    APP_DEVICE_States_T state;
    bool bAddrLoaded;
    uint8_t peerDevId;                  //Peer Device Id which is the pointer to the pairing data in DM(actually in flash)
    bool bPeerDevIdExist;               //If Peer Device Id exists in DM(actually in flash)
}APP_PairedDevInfo_T;

typedef struct APP_ExtPairedDevInfo_T{
    BLE_GAP_Addr_T localAddr;
    bool bConnectedByResolvedAddr;
}APP_ExtPairedDevInfo_T;
</#if>
<#if APP_ANP_OR_PXP == true>
typedef struct APP_CtrlInfo_T{
    APP_DEVICE_States_T state;
    uint8_t peerDevId;                  //Peer Device Id which is the pointer to the pairing data in DM(actually in flash)
    bool bAllowNewPairing;
}APP_CtrlInfo_T;
</#if>
<#if APP_HOGP == true>
typedef struct APP_PairedDevGattInfo_T{
    uint8_t             serviceChange;
    uint8_t             clientSupportFeature;
    uint8_t             numOfCccd;
    GATTS_CccdList_T    cccdList[APP_MAX_CCCD_NUM];
}APP_PairedDevGattInfo_T;
</#if>
<#if APP_ANCS == true>
typedef struct APP_GattClientInfo_T{
    bool bDiscoveryDone;
}APP_GattClientInfo_T;
</#if>
<#if APP_ANCS_OR_HOGP == true>
extern APP_PairedDevInfo_T g_pairedDevInfo;
extern APP_ExtPairedDevInfo_T g_extPairedDevInfo;
extern bool g_bAllowNewPairing;
</#if>
<#if APP_ANP_OR_PXP == true>
extern APP_CtrlInfo_T g_ctrlInfo;
</#if>
<#if APP_ANCS == true>
extern APP_GattClientInfo_T g_GattClientInfo;
</#if>
<#if APP_HOGP == true>
extern APP_PairedDevGattInfo_T g_PairedDevGattInfo;
extern bool g_bConnTimeout;
</#if>
<#if booleanappcode ==  true>
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true && WLS_BLE_BOOL_GAP_EXT_ADV == false && WLS_BLE_GAP_DSADV_EN == false && WLS_BLE_BOOL_L2CAP_CREDIT_FLOWCTRL == true>
typedef enum APP_DEVICE_States_T
{
	APP_DEVICE_STATE_INIT=0,
    APP_DEVICE_STATE_IDLE,
    APP_DEVICE_STATE_ADV,
    APP_DEVICE_STATE_ADV_DIR,
    APP_DEVICE_STATE_CONN,
    APP_DEVICE_STATE_END
} APP_DEVICE_States_T;



/**@brief Enumeration type of pair trigger method. */
typedef enum APP_BLE_PAIR_TRIGGER_ID
{
    APP_BLE_PAIR_TRIGGER_CENTRAL = 0x00,
    APP_BLE_PAIR_TRIGGER_PERIPHERAL,
    APP_BLE_PAIR_TRIGGER_End
} APP_BLE_PAIR_TRIGGER_ID;
/**@brief The structure contains the BLE Connection parameters. */
typedef struct APP_BLE_ConnData_T
{
    uint8_t                role;                                           /**< GAP role, see @ref BLE_GAP_ROLE. */
    uint16_t               handle;                                         /**< Connection handle associated with this connection. */
    BLE_GAP_Addr_T         remoteAddr;                                     /**< See @ref BLE_GAP_Addr_T. */
    uint16_t               connInterval;                                   /**< Connection interval used on this connection. Range should be @ref BLE_GAP_CP_RANGE. */
    uint16_t               connLatency;                                    /**< Slave latency for the connection in terms of number of connection events, see @ref BLE_GAP_CP_RANGE. */
    uint16_t               supervisionTimeout;                             /**< Supervision timeout for the LE Link, see @ref BLE_GAP_CP_RANGE. */
} APP_BLE_ConnData_T;

/**@brief This structure contains the BLE security related information. */
typedef struct APP_BLE_SecuData_T
{
    uint8_t                encryptionStatus;                               /**< BLE encryption status. 1: Enabled; 0: Disabled. */
    BLE_GAP_Addr_T         smpInitiator;                                   /**< Initiator BD_ADDR and address type. See @ref BLE_GAP_Addr_T */
} APP_BLE_SecuData_T;



/**@brief The structure contains the BLE link related information maintained by the application Layer */
typedef struct APP_BLE_ConnList_T
{
    APP_DEVICE_States_T         linkState;                                              /**< BLE link state. see @ref APP_DEVICE_States_T */
    APP_BLE_ConnData_T          connData;                                               /**< BLE connection information. See @ref APP_BLE_ConnData_T */
    APP_BLE_SecuData_T          secuData;                                               /**< BLE security information. See @ref APP_BLE_SecuData_T */
    //APP_BLE_TrcbpsConnData_T    trcbpsConnData[APP_BLE_L2CAP_MAX_LINK_NUM];             /**< BLE TRCBP connection parameters. See @ref APP_BLE_TrcbpsConnData_T */
} APP_BLE_ConnList_T;


typedef struct APP_Database_T
{
    uint8_t ioCapability;
    uint16_t gattcReadUuid;             /* Used for GATTC GATTC_ReadUsingUUID() API. */
} APP_Database_T;

typedef struct APP_ConnList
{
    uint8_t                         bdAddr[7];
    uint16_t                        connHandle;
    uint8_t                         state;
} APP_ConnList;

extern APP_Database_T         g_appDb;
extern APP_ConnList           g_appConnList[APP_BLE_MAX_LINK_NUMBER];


#ifdef APP_PAIRING_ENABLE
#include "ble_trs/ble_trs.h"
#endif
</#if> 
</#if>
<#if booleanappcode ==  true>
<#if APP_THROUGHPUT == true>
/**@brief The structure contains the BLE Advertising parameters to be set by the application. */
typedef struct APP_BLE_AdvParams_T
{
    uint16_t             intervalMin;                             /**< Minimum advertising interval, see @ref BLE_GAP_ADV_INTERVAL. Unit: 0.625ms */
    uint16_t             intervalMax;                             /**< Maximum advertising interval, see @ref BLE_GAP_ADV_INTERVAL. Unit: 0.625ms */
    uint8_t              advType;                                 /**< advertising type, see @ref BLE_GAP_ADV_TYPE. */
    uint8_t              filterPolicy;                            /**< Advertising filter policy. See @ref BLE_GAP_ADV_FILTER_POLICY */
} APP_BLE_AdvParams_T;
</#if>
</#if>
// *****************************************************************************
// *****************************************************************************
// Section: Functions
// *****************************************************************************
// ***************************************************************************** 
<#if booleanappcode ==  true>  
void APP_WLS_BLE_DeviceConnected(BLE_GAP_EvtConnect_T  *p_evtConnect);
void APP_WLS_BLE_DeviceDisconnected(BLE_GAP_EvtDisconnect_T *p_evtDisconnect);
void APP_WLS_BLE_AdvertisementReportReceived(BLE_GAP_EvtAdvReport_T *p_evtAdvReport);
void APP_WLS_BLE_ExtendedAdvertisementReportReceived(BLE_GAP_EvtExtAdvReport_T *p_evtExtAdvReport);
void APP_WLS_BLE_ScanTimedOut();
void APP_WLS_BLE_AdvertisementCompleted();
void APP_WLS_BLE_AdvertisementTimedOut();
void APP_WLS_BLE_PathLossThresholdReceived(BLE_GAP_EvtPathLossThreshold_T *p_evtPathLossThreshold);
void APP_WLS_BLE_PairedDeviceDisconnected(BLE_DM_Event_T *p_event);
void APP_WLS_BLE_PairedDeviceConnected(BLE_DM_Event_T *p_event);
<#if WLS_BLE_GAP_CENTRAL == true  && WLS_BLE_GAP_SCAN == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_CLIENT == true  && WLS_BLE_BOOL_GAP_EXT_SCAN == true && WLS_BLE_GAP_EXT_SCAN_PHY == "2">
void SYS_CONSOLE_PRINT_PHY(uint8_t phy);
</#if>
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true  && WLS_BLE_BOOL_GAP_EXT_ADV == true > 
 void SYS_CONSOLE_PRINT_PHY(uint8_t phy);
</#if>
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true && WLS_BLE_BOOL_GAP_EXT_ADV == false && WLS_BLE_GAP_DSADV_EN == false && WLS_BLE_BOOL_L2CAP_CREDIT_FLOWCTRL == true> 
void APP_WLS_ClearConnListByConnHandle(uint16_t connHandle);
APP_BLE_ConnList_T *APP_WLS_BLE_GetFreeConnList(void);
APP_BLE_ConnList_T *APP_WLS_BLE_GetConnInfoByConnHandle(uint16_t connHandle);
void APP_WLS_BLE_SwitchActiveDevice(void);
void APP_WLS_HexToAscii(uint8_t byteNum, uint8_t *p_hex, uint8_t *p_ascii);
void APP_WLS_BLE_UpdateLocalName(uint8_t devNameLen, uint8_t *p_devName);
APP_DEVICE_States_T APP_WLS_BLE_GetState(void);
void APP_WLS_BLE_SetState(APP_DEVICE_States_T state);
uint8_t APP_WLS_BLE_GetRole(void);
uint16_t APP_WLS_BLE_GetCurrentConnHandle(void);
void APP_WLS_BLE_InitConnList(void);
</#if> 
<#if APP_ANY_PROF == true>
bool APP_WLS_BLE_GetPairedDeviceId(uint8_t *pDevId);
void APP_WLS_BLE_SetResolvingList(bool bSet);
void APP_WLS_BLE_SetFilterAcceptList(bool bSet);
</#if>
<#if APP_ANCS_OR_HOGP == true>
void APP_WLS_BLE_EnableAdvDirect(bool bDirect);
void APP_WLS_BLE_ConfigAdvDirect(bool bDirect);
void APP_WLS_BLE_GenerateRandomStaticAddress(BLE_GAP_Addr_T *pAddr);
void APP_WLS_BLE_SetLocalIRK(void);
void APP_WLS_BLE_InitPairedDeviceInfo(void);
uint16_t APP_WLS_BLE_GetExtPairedDevInfoFromFlash(APP_ExtPairedDevInfo_T *pExtInfo);
uint16_t APP_WLS_BLE_SetExtPairedDevInfoInFlash(APP_ExtPairedDevInfo_T *pExtInfo);
void APP_WLS_RegisterPdsCb(void);
bool APP_WLS_BLE_GetPairedDeviceAddr(BLE_GAP_Addr_T *pAddr);
void APP_WLS_GenerateRandomData(uint8_t *pData, uint8_t dataLen);
</#if>
<#if APP_ANP_OR_PXP == true>
void APP_WLS_BLE_InitConfig(void);
</#if>
<#if APP_PXPM_OR_ANPS == true>
uint16_t APP_WLS_BLE_ScanEnable(APP_DEVICE_States_T scanType);
uint16_t APP_WLS_BLE_CreateConnection(BLE_GAP_Addr_T *peerAddr);
</#if>
<#if APP_PXPR_OR_ANPC == true>
void APP_WLS_BLE_EnableAdv(uint8_t advType);
void APP_WLS_BLE_ConfigAdv(uint8_t advType);
</#if>
<#if APP_HOGP == true>
uint16_t APP_WLS_BLE_GetPairedDevGattInfoFromFlash(APP_PairedDevGattInfo_T *pInfo);
uint16_t APP_WLS_BLE_SetPairedDevGattInfoInFlash(APP_PairedDevGattInfo_T *pInfo);
void APP_WLS_BLE_ConnTimeoutAction(void);
</#if>
<#if APP_THROUGHPUT == true>
void APP_ADV_Init(void);
void APP_WLS_BLE_Start(void);
void APP_WLS_BLE_Stop(void);
void APP_WLS_BLE_SetFilterPolicy(uint8_t filterPolicy);
uint8_t APP_WLS_BLE_GetFilterPolicy(void);
</#if>

#ifdef	__cplusplus
}
#endif
#endif	/* APP_API_EVENTS_H */
</#if>
