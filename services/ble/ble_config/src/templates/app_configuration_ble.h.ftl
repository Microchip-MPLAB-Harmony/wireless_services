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


<#assign APP_UTILITY_ADVERTISING = false>
<#if BLE_STACK_LIB?? && (BLE_STACK_LIB.GAP_ADVERTISING == true && BLE_STACK_LIB.BOOL_GAP_EXT_ADV == false)>
  <#assign APP_UTILITY_ADVERTISING = true>
  <#assign APP_UTILITY_ADV_DATA = BLE_STACK_LIB.GAP_ADV_DATA>
  <#assign APP_UTILITY_SCANRSP_DATA = BLE_STACK_LIB.GAP_SCAN_RSP_DATA>
</#if>
<#assign APP_UTILITY_ADV_DATA_LEN = 0>
<#assign APP_UTILITY_SVC_ADV_DATA_LEN_INDEX = 0>
<#assign APP_UTILITY_SVC_ADV_DATA_APPEND_INDEX = 0>
<#assign bleAdvData = []>
<#assign APP_UTILITY_SCANRSP_DATA_LEN = 0>
<#assign APP_UTILITY_SVC_SCANRSP_DATA_LEN_INDEX = 0>
<#assign APP_UTILITY_SVC_SCANRSP_DATA_APPEND_INDEX = 0>
<#assign bleScanRspData = []>
<#if APP_UTILITY_ADVERTISING == true>
  <#if APP_UTILITY_ADV_DATA?length != 0>
    <#assign APP_UTILITY_ADV_DATA_HEX_LIST = APP_UTILITY_ADV_DATA?split(", ")>
    <#list APP_UTILITY_ADV_DATA_HEX_LIST as hexString>
      <#assign hexDigits = "0123456789ABCDEF">
      <#assign hexStringVal = hexString?replace("0x", "")>
      <#assign integerValue = 0>
      <#list 0..(hexStringVal?length - 1) as i>
          <#assign digit = hexStringVal[i]?upper_case>
          <#assign digitValue = hexDigits?index_of(digit)>
          <#assign integerValue = integerValue * 16 + digitValue>
      </#list>
      <#assign bleAdvData = bleAdvData + [integerValue]>
    </#list>
    <#assign APP_UTILITY_ADV_DATA_LEN = bleAdvData?size>
  </#if>
  <#if APP_UTILITY_SCANRSP_DATA?length != 0>
    <#assign APP_UTILITY_SCANRSP_DATA_HEX_LIST = APP_UTILITY_SCANRSP_DATA?split(", ")>
    <#list APP_UTILITY_SCANRSP_DATA_HEX_LIST as hexString>
      <#assign hexDigits = "0123456789ABCDEF">
      <#assign hexStringVal = hexString?replace("0x", "")>
      <#assign integerValue = 0>
      <#list 0..(hexStringVal?length - 1) as i>
          <#assign digit = hexStringVal[i]?upper_case>
          <#assign digitValue = hexDigits?index_of(digit)>
          <#assign integerValue = integerValue * 16 + digitValue>
      </#list>
      <#assign bleScanRspData = bleScanRspData + [integerValue]>
    </#list>
    <#assign APP_UTILITY_SCANRSP_DATA_LEN = bleScanRspData?size>
  </#if>
</#if>
<#if (APP_UTILITY_ADV_DATA_LEN > 0)>
<#assign offset = 0>
  <#list 0..APP_UTILITY_ADV_DATA_LEN-1 as i>
    <#if (offset >= APP_UTILITY_ADV_DATA_LEN)>
      <#break>
    </#if>
    <#assign length = bleAdvData[offset]>
    <#if (length < (APP_UTILITY_ADV_DATA_LEN - offset))>
      <#if (bleAdvData[offset+1] == 1)>
          <#assign offset = offset + length>
      <#elseif (bleAdvData[offset+1] == 9)>
          <#assign offset = offset + length>
      <#elseif (bleAdvData[offset+1] == 22 || bleAdvData[offset+1] == 32 || bleAdvData[offset+1] == 33)>
          <#assign APP_UTILITY_SVC_ADV_DATA_LEN_INDEX = offset>
          <#assign offset = offset + length>
          <#assign APP_UTILITY_SVC_ADV_DATA_APPEND_INDEX = offset+1>
      <#elseif (bleAdvData[offset+1] == 255)>
          <#assign offset = offset + length>
      <#else>
          <#assign offset = offset + length>
      </#if>
    </#if>
    <#assign offset = offset + 1>
  </#list>
</#if>
<#if (APP_UTILITY_SCANRSP_DATA_LEN > 0)>
<#assign offset = 0>
  <#list 0..APP_UTILITY_SCANRSP_DATA_LEN-1 as i>
    <#if (offset >= APP_UTILITY_SCANRSP_DATA_LEN)>
      <#break>
    </#if>
    <#assign length = bleScanRspData[offset]>
    <#if (length < (APP_UTILITY_SCANRSP_DATA_LEN - offset))>
      <#if (bleScanRspData[offset+1] == 1)>
          <#assign offset = offset + length>
      <#elseif (bleScanRspData[offset+1] == 9)>
          <#assign offset = offset + length>
      <#elseif (bleScanRspData[offset+1] == 22 || bleScanRspData[offset+1] == 32 || bleScanRspData[offset+1] == 33)>
          <#assign APP_UTILITY_SVC_SCANRSP_DATA_LEN_INDEX = offset>
          <#assign offset = offset + length>
          <#assign APP_UTILITY_SVC_SCANRSP_DATA_APPEND_INDEX = offset+1>
      <#elseif (bleScanRspData[offset+1] == 255)>
          <#assign offset = offset + length>
      <#else>
          <#assign offset = offset + length>
      </#if>
    </#if>
    <#assign offset = offset + 1>
  </#list>
</#if>
<#if (APP_UTILITY_ADVERTISING == false) || (APP_UTILITY_ADV_DATA_LEN == 0)>
#define CONFIG_BLE_GAP_ADV_DATA                {0U}
#define CONFIG_BLE_GAP_ADV_DATA_ORIG_LEN       0U
</#if>
<#if (APP_UTILITY_ADVERTISING == false) || (APP_UTILITY_SCANRSP_DATA_LEN == 0)>
#define CONFIG_BLE_GAP_SCAN_RSP_DATA           {0U}
#define CONFIG_BLE_GAP_SCAN_RSP_DATA_ORIG_LEN  0U
</#if>
#define CONFIG_APP_BLE_USERDATA_APPEND_INDEX      ${APP_UTILITY_ADV_DATA_LEN}U
#define CONFIG_APP_BLE_SVCDATA_LENGTH_INDEX       ${APP_UTILITY_SVC_ADV_DATA_LEN_INDEX}U
#define CONFIG_APP_BLE_SVCDATA_APPEND_INDEX       ${APP_UTILITY_SVC_ADV_DATA_APPEND_INDEX}U
#define CONFIG_APP_BLE_RSP_USERDATA_APPEND_INDEX  ${APP_UTILITY_SCANRSP_DATA_LEN}U
#define CONFIG_APP_BLE_RSP_SVCDATA_LENGTH_INDEX   ${APP_UTILITY_SVC_SCANRSP_DATA_LEN_INDEX}U
#define CONFIG_APP_BLE_RSP_SVCDATA_APPEND_INDEX   ${APP_UTILITY_SVC_SCANRSP_DATA_APPEND_INDEX}U

<#if DEVICE_SELECT == "pic32cx_bz2_family">
#define PIC32BZ2
<#if APP_ANY_PROF == true>
#define CONFIG_APP_BLE_READ_SW  GPIO_PinRead(GPIO_PIN_RB4)
</#if>
<#elseif DEVICE_SELECT == "pic32cx_bz3_family">
#define PIC32BZ3
<#if APP_ANY_PROF == true>
#define CONFIG_APP_BLE_READ_SW  GPIO_PinRead(GPIO_PIN_RB9)
</#if>
</#if>
