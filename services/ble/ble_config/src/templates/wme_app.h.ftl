<#if booleanappcode ==  true>
${WLS_BLE_COMMENT}
<#if wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_CLIENT == true || wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true>	
		APP_MSG_UART_CB,	
</#if>
<#if wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_CLIENT == true && WLS_BLE_BOOL_GAP_EXT_ADV == true>
<#if WLS_BLE_GAP_PRI_ADV_PHY == "1" && WLS_BLE_GAP_SEC_ADV_PHY == "2">
APP_MSG_UART_CB,	
</#if>
</#if>
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && WLS_BLE_BOOL_GAP_EXT_ADV == false && WLS_BLE_GAP_DSADV_EN == false &&  WLS_BLE_BOOL_L2CAP_CREDIT_FLOWCTRL == true>
APP_MSG_PROTOCOL_RSP,
APP_MSG_FETCH_TRP_RX_DATA,
APP_MSG_LED_TIMEOUT,
</#if>
<#if wlsbleancsss?? && wlsbleancsss.SS_ANCS_BOOL_CLIENT == true
    || wlsblehogp?? && wlsblehogp.HOGP_BOOL_SERVER == true
    || wlsbleanpss?? && wlsbleanpss.ANPSS_BOOL_CLIENT == true
    || wlsbleanpss?? && wlsbleanpss.ANPSS_BOOL_SERVER == true
    || wlsblepxpss?? && wlsblepxpss.SS_PXP_BOOL_SERVER == true
    ||wlsblepxpss?? && wlsblepxpss.SS_PXP_BOOL_CLIENT == true>
    APP_MSG_LED_TIMEOUT,    		
</#if>
<#if wlsbleancsss?? && wlsbleancsss.SS_ANCS_BOOL_CLIENT == true
    || wlsblehogp?? && wlsblehogp.HOGP_BOOL_SERVER == true
    || wlsbleanpss?? && wlsbleanpss.ANPSS_BOOL_CLIENT == true
    || wlsbleanpss?? && wlsbleanpss.ANPSS_BOOL_SERVER == true
    || wlsblepxpss?? && wlsblepxpss.SS_PXP_BOOL_SERVER == true
    || wlsblepxpss?? && wlsblepxpss.SS_PXP_BOOL_CLIENT == true>
    APP_MSG_KEY_SCAN,		
</#if>
<#if wlsblehogp?? && wlsblehogp.HOGP_BOOL_SERVER == true>
    APP_MSG_CONN_TIMEOUT,		
</#if>
<#if wlsblepxpss?? && wlsblepxpss.SS_PXP_BOOL_CLIENT == true>
APP_MSG_RSSI_MONI_TIMEOUT,		
</#if>
<#if wlsblepxpss?? && wlsblepxpss.SS_PXP_BOOL_SERVER == true>
APP_MSG_ALERT_TOGGLE,
APP_MSG_LED_IND_SWITCH,		
</#if>
</#if>