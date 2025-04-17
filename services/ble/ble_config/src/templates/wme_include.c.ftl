<#if booleanappcode == true>
<#assign APP_THROUGHPUT = false>
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true && WLS_BLE_BOOL_GAP_EXT_ADV == false && WLS_BLE_GAP_DSADV_EN == false && WLS_BLE_BOOL_L2CAP_CREDIT_FLOWCTRL == true> 
<#assign APP_THROUGHPUT = true>
</#if>
${WLS_BLE_COMMENT}
<#if wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_CLIENT == true && WLS_BLE_BOOL_GAP_EXT_SCAN == true>
<#if WLS_BLE_GAP_EXT_SCAN_PHY == "1" || WLS_BLE_GAP_EXT_SCAN_PHY == "2">
#include "peripheral/sercom/usart/plib_sercom0_usart.h"
#include "ble_trspc/ble_trspc.h"
#include "system/console/sys_console.h"
</#if>
</#if>
<#if wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_CLIENT == true && WLS_BLE_BOOL_GAP_EXT_SCAN == false>
<#if WLS_BLE_GAP_EXT_SCAN_PHY == "0">
#include "peripheral/sercom/usart/plib_sercom0_usart.h"
#include "ble_trspc/ble_trspc.h"
</#if>
</#if>
<#if WLS_BLE_GAP_PERIPHERAL == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true && WLS_BLE_BOOL_GAP_EXT_ADV == true && WLS_BLE_GAP_PRI_ADV_PHY == "1" && WLS_BLE_GAP_SEC_ADV_PHY == "2">
<#if WLS_BLE_GAP_PRI_ADV_PHY == "1" && WLS_BLE_GAP_SEC_ADV_PHY == "2">
#include "ble_trsps/ble_trsps.h"
#include "system/console/sys_console.h"
</#if>
</#if>
<#if WLS_BLE_GAP_PERIPHERAL == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true && WLS_BLE_BOOL_GAP_EXT_ADV == false && WLS_BLE_BOOL_L2CAP_CREDIT_FLOWCTRL == false>
#include "ble_trsps/ble_trsps.h" 
</#if>
<#if wlsbleancsss?? && wlsbleancsss.SS_ANCS_BOOL_CLIENT == true
	|| wlsbleanpss?? &&  wlsbleanpss.ANPSS_BOOL_CLIENT == true
	|| wlsbleanpss?? && wlsbleanpss.ANPSS_BOOL_SERVER == true
	|| wlsblehogp?? && wlsblehogp.HOGP_BOOL_SERVER == true>
#include "app_timer.h"
#include "app_led.h"
#include "app_key.h"
#include "app_ble_callbacks.h"
</#if>
<#if wlsbleancsss?? && wlsbleancsss.SS_ANCS_BOOL_CLIENT == true>
#include "app_ancs_callbacks.h"
</#if>
<#if wlsbleanpss?? &&  wlsbleanpss.ANPSS_BOOL_CLIENT == true>
#include "app_anpc_callbacks.h"
</#if>
<#if wlsblehogp?? && wlsblehogp.HOGP_BOOL_SERVER == true>
#include "app_conn.h"
#include "app_hogps_callbacks.h"
#include "ble_dis/ble_dis.h"
</#if>
<#if wlsbleanpss?? && wlsbleanpss.ANPSS_BOOL_SERVER == true>
#include "app_anps_callbacks.h"
</#if> 
<#if wlsblepxpss?? && wlsblepxpss.SS_PXP_BOOL_CLIENT == true>
#include "FreeRTOS.h"
#include "app_ble_callbacks.h"		
</#if>
<#if wlsblepxpss?? && wlsblepxpss.SS_PXP_BOOL_SERVER == true>
#include "app_ble_callbacks.h"	
</#if>
<#if APP_THROUGHPUT == true>
#include "app_trsps_callbacks.h"
#include "app_ble_callbacks.h"
</#if>
<#if WLS_BLE_GAP_CENTRAL == true  && WLS_BLE_GAP_SCAN == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_CLIENT == true && WLS_BLE_BOOL_GAP_EXT_SCAN == false  && !(wlsbletrspss.SS_TRSP_BOOL_CLIENT == true && wlsbletrspss.SS_TRSP_BOOL_SERVER == true)>
// from1
#define APP_BLE_SCAN_DURATION		1000
</#if>
<#if  WLS_BLE_GAP_CENTRAL == true && WLS_BLE_GAP_SCAN == true && WLS_BLE_GAP_SVC_PERI_PRE_CP == false && !wlsbletrspss?? && WLS_BLE_BOOL_GAP_EXT_SCAN == false && !wlsbleanpss?? && !wlsblepxpss??>
#define APP_BLE_SCAN_DURATION		100
</#if>
<#if  WLS_BLE_GAP_CENTRAL == true && WLS_BLE_GAP_SCAN == true && WLS_BLE_GAP_SVC_PERI_PRE_CP == true && !wlsbletrspss?? && WLS_BLE_BOOL_GAP_EXT_SCAN == false && !wlsbleanpss?? && !wlsblepxpss??>
#define APP_BLE_SCAN_DURATION		1000
</#if>
<#if WLS_BLE_GAP_CENTRAL == true  && WLS_BLE_GAP_SCAN == true && WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true  && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true  && wlsbletrspss.SS_TRSP_BOOL_CLIENT == true>
<#-- For TRSP_CLIENT configuration ( for multilink and multirole ) -->
#define APP_BLE_SCAN_DURATION		1000
</#if>


<#if WLS_BLE_GAP_SCAN == true && WLS_BLE_BOOL_GAP_EXT_SCAN == true>
    <#if wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_CLIENT == true >
        <#if WLS_BLE_GAP_EXT_SCAN_PHY == "1" || WLS_BLE_GAP_EXT_SCAN_PHY == "2">
${WLS_BLE_COMMENT}
#define APP_BLE_EXTSCAN_DURATION		0x2710
#define APP_BLE_EXTSCAN_PERIOD			0x0000
</#if>
<#else>
<#-- For TRSP_CLIENT configuration ( for central_ext_scan) -->
#define APP_BLE_EXTSCAN_DURATION		0x0000
#define APP_BLE_EXTSCAN_PERIOD			0x0000 
</#if>
</#if>
<#if WLS_BLE_GAP_PERIPHERAL == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true && WLS_BLE_BOOL_GAP_EXT_ADV == true && WLS_BLE_GAP_PRI_ADV_PHY == "1" && WLS_BLE_GAP_SEC_ADV_PHY == "2">
<#-- For TRSP_CLIENT configuration ( for peripheral_trp_codedPhy ) -->
#define APP_BLE_EXTADVENBALEPARAM_ADV_HANDLE 		0x00
#define APP_BLE_EXTADVENBALEPARAM_DURATION 			0x00
#define APP_BLE_EXTADVENBALEPARAM_MAX_EXT_ADV_EVTS 	0
</#if>
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && WLS_BLE_GAP_DSADV_EN == false && WLS_BLE_BOOL_GAP_EXT_ADV == true && !wlsbletrspss?? && WLS_BLE_GAP_EXT_ADV_ADV_SET_2 == false>
#define APP_BLE_EXTADVENBALEPARAM_ADV_HANDLE 		0x01
#define APP_BLE_EXTADVENBALEPARAM_DURATION 			0x00
#define APP_BLE_EXTADVENBALEPARAM_MAX_EXT_ADV_EVTS 	0
</#if> 
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && WLS_BLE_GAP_DSADV_EN == false && WLS_BLE_BOOL_GAP_EXT_ADV == true && !wlsbletrspss?? && WLS_BLE_GAP_EXT_ADV_ADV_SET_2 == true>
<#--( for two set adv set ) -->  
#define APP_BLE_EXTADVENBALEPARAM_ADV_HANDLE_1 		0x01
#define APP_BLE_EXTADVENBALEPARAM_ADV_HANDLE_2 		0x02
#define APP_BLE_EXTADVENBALEPARAM_DURATION 			0x00
#define APP_BLE_EXTADVENBALEPARAM_MAX_EXT_ADV_EVTS 	0
</#if>
<#if wlsbleancsss?? && wlsbleancsss.SS_ANCS_BOOL_CLIENT == true  || wlsblehogp?? && wlsblehogp.HOGP_BOOL_SERVER == true >
<#--#define APP_BLE_GAP_ADV_PARAM_INTERVAL_MIN			32 -->
<#--#define APP_BLE_GAP_ADV_PARAM_INTERVAL_MAX			32 -->
</#if>  
</#if>