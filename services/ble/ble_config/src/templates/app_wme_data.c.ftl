<#if booleanappcode == true>
<#-- Common variables across different conditions -->
<#if wlsbletrspss??>
<#-- For TRSP_CLIENT configuration ( for CLIENT configuration but not both together central_trp_uart and central_trp_codedPhy) -->
<#if wlsbletrspss.SS_TRSP_BOOL_CLIENT == true &&  WLS_BLE_GAP_CENTRAL == true && WLS_BLE_GAP_SCAN == true && !(wlsbletrspss.SS_TRSP_BOOL_CLIENT == true && wlsbletrspss.SS_TRSP_BOOL_SERVER == true) && numberoflinks <=1>
${WLS_BLE_COMMENT}
uint16_t conn_handle; // connection handle info captured @BLE_GAP_EVT_CONNECTED event
uint8_t uart_data;
</#if>
<#-- For central multilink configuration -->
<#if wlsbletrspss.SS_TRSP_BOOL_CLIENT == true &&  WLS_BLE_GAP_CENTRAL == true && WLS_BLE_GAP_SCAN == true && !( wlsbletrspss.SS_TRSP_BOOL_SERVER == true) && (numberoflinks == 2 || numberoflinks == 3)>
${WLS_BLE_COMMENT}
uint16_t conn_hdl[CONFIG_APP_BLE_MAXIMUM_NUMBER_OF_LINKS] = {0xFFFF, 0xFFFF, 0xFFFF};// connection handle info captured @BLE_GAP_EVT_CONNECTED event
uint8_t no_of_links;// No of connected peripheral devices
uint8_t i = 0;// link index
uint8_t uart_data;
</#if>
<#-- For SS_TRSP_BOOL_SERVER configuration ( for SS_TRSP_BOOL_SERVER configuration but not both together peripheral_trp_uart and peripheral_trp_codedPhy) -->
<#if wlsbletrspss.SS_TRSP_BOOL_SERVER == true && WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && !(wlsbletrspss.SS_TRSP_BOOL_CLIENT == true && wlsbletrspss.SS_TRSP_BOOL_SERVER == true) && WLS_BLE_BOOL_L2CAP_CREDIT_FLOWCTRL == false>
${WLS_BLE_COMMENT}
uint16_t conn_handle; // connection handle info captured @BLE_GAP_EVT_CONNECTED event
uint16_t ret;
uint8_t uart_data;
</#if>
<#-- For both TRSP_CLIENT and TRSP_SERVER configuration -->
<#if wlsbletrspss.SS_TRSP_BOOL_CLIENT == true && wlsbletrspss.SS_TRSP_BOOL_SERVER == true>
<#if WLS_BLE_GAP_CENTRAL == true && WLS_BLE_GAP_SCAN == true && WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true>
${WLS_BLE_COMMENT}
uint16_t conn_hdl[CONFIG_APP_BLE_MAXIMUM_NUMBER_OF_LINKS]; // connection handle info captured @BLE_GAP_EVT_CONNECTED event
uint8_t uart_data;
uint8_t no_of_links; // No of connected peripheral devices
uint8_t i = 0; // link index
</#if>
</#if>
</#if>
<#-- For BLE GAP Peripheral Advertising Configuration without TRSP -->
<#if WLS_BLE_GAP_ADVERTISING == true && WLS_BLE_BOOL_GAP_EXT_ADV == true && WLS_BLE_GAP_PERIPHERAL == true && !wlsbletrspss?? && WLS_BLE_GAP_EXT_ADV_ADV_SET_2 == false>
${WLS_BLE_COMMENT}
uint16_t ret;
</#if>
</#if>