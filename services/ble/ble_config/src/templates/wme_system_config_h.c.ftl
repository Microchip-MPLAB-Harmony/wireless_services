<#if booleanappcode ==  true>   
<#if wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_CLIENT == true &&  WLS_BLE_GAP_CENTRAL == true && WLS_BLE_GAP_SCAN == true && !( wlsbletrspss.SS_TRSP_BOOL_SERVER == true) && (numberoflinks == 2 || numberoflinks == 3)>    
#define CONFIG_APP_BLE_MAXIMUM_NUMBER_OF_LINKS               ${numberoflinks}
</#if>
<#if WLS_BLE_GAP_CENTRAL == true  && WLS_BLE_GAP_SCAN == true && WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true  && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true  && wlsbletrspss.SS_TRSP_BOOL_CLIENT == true>
#define CONFIG_APP_BLE_MAXIMUM_NUMBER_OF_LINKS               ${numberoflinks}
</#if>
</#if>