<#if HarmonyCore??>
<#if (HarmonyCore.SELECT_RTOS)?? && HarmonyCore.SELECT_RTOS == "FreeRTOS">
    <#lt>void _OTA_SERVICE_Tasks(  void *pvParameters  )
    <#lt>{
    <#lt>    while(1)
    <#lt>    {
    <#lt>        OTA_SERVICE_Tasks();
             <#if OTA_SERVICE_RTOS_USE_DELAY >
    <#lt>        vTaskDelay(${OTA_SERVICE_RTOS_DELAY} / portTICK_PERIOD_MS);
             </#if>
    <#lt>    }
    <#lt>}
<#elseif (HarmonyCore.SELECT_RTOS)?? && HarmonyCore.SELECT_RTOS == "ThreadX">
    <#lt>TX_THREAD      _ota_service_Task_TCB;
    <#lt>uint8_t*       _ota_service_Task_Stk_Ptr;

    <#lt>static void _OTA_SERVICE_Tasks( ULONG thread_input )
    <#lt>{
    <#lt>    while(1)
    <#lt>    {
    <#lt>        OTA_SERVICE_Tasks();
    <#if OTA_SERVICE_RTOS_USE_DELAY == true>
        <#lt>        tx_thread_sleep((ULONG)(${OTA_SERVICE_RTOS_DELAY} / (TX_TICK_PERIOD_MS)));
    </#if>
    <#lt>    }
    <#lt>}
<#elseif (HarmonyCore.SELECT_RTOS)?? && HarmonyCore.SELECT_RTOS == "MicriumOSIII">
    <#lt>OS_TCB  _ota_service_Tasks_TCB;
    <#lt>CPU_STK _ota_service_TasksStk[${OTA_SERVICE_RTOS_STACK_SIZE}];

    <#lt>void _OTA_SERVICE_Tasks(  void *pvParameters  )
    <#lt>{
    <#if OTA_SERVICE_RTOS_USE_DELAY == true>
        <#lt>    OS_ERR os_err;
    </#if>
    <#lt>    while(1)
    <#lt>    {
    <#lt>        OTA_SERVICE_Tasks();
    <#if OTA_SERVICE_RTOS_USE_DELAY == true>
        <#lt>        OSTimeDly(${OTA_SERVICE_RTOS_DELAY} , OS_OPT_TIME_DLY, &os_err);
    </#if>
    <#lt>    }
    <#lt>}
<#elseif (HarmonyCore.SELECT_RTOS)?? && HarmonyCore.SELECT_RTOS == "MbedOS">
    <#lt>void _OTA_SERVICE_Tasks( void *pvParameters )
    <#lt>{
    <#lt>    while(1)
    <#lt>    {
    <#lt>        OTA_SERVICE_Tasks();
    <#if OTA_SERVICE_RTOS_USE_DELAY == true>
        <#lt>    thread_sleep_for((uint32_t)(${OTA_SERVICE_RTOS_DELAY} / MBED_OS_TICK_PERIOD_MS));
    </#if>
    <#lt>    }
    <#lt>}
</#if>
</#if>