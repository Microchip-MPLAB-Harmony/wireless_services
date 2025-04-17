<#if booleanappcode ==true>
<#assign APP_THROUGHPUT = false>
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true && WLS_BLE_BOOL_GAP_EXT_ADV == false && WLS_BLE_GAP_DSADV_EN == false && WLS_BLE_BOOL_L2CAP_CREDIT_FLOWCTRL == true> 
<#assign APP_THROUGHPUT = true>
</#if>
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && !wlsbletrspss?? && WLS_BLE_BOOL_GAP_EXT_ADV == true && WLS_BLE_GAP_DSADV_EN == false && WLS_BLE_GAP_EXT_ADV_ADV_SET_2 == true>
    ${WLS_BLE_COMMENT}
	uint16_t ret;
</#if>
<#if APP_THROUGHPUT == true>
    uint8_t instance;
    APP_TRP_ConnList_T *p_connList;
    uint16_t status = APP_RES_FAIL;
</#if>
</#if>