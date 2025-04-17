<#if booleanappcode ==  true>
<#if WLS_BLE_GAP_DSADV_EN == true>
    /*** generated sample application code  ***/
    DEVICE_DeepSleepWakeSrc_T wakeSrc;
    DEVICE_GetDeepSleepWakeUpSrc(&wakeSrc);
    if (wakeSrc == DEVICE_DEEP_SLEEP_WAKE_NONE) { // Initialize RTC if wake source is none (i.e., power on reset)
        RTC_Initialize();
    }
</#if>
</#if>


