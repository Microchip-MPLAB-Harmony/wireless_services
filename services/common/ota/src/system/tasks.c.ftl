<#if HarmonyCore??>
  <#if (HarmonyCore.SELECT_RTOS)?? && HarmonyCore.SELECT_RTOS == "FreeRTOS">
    <#assign OTA_SERVICE_STACK_SIZE = (OTA_SERVICE_RTOS_STACK_SIZE / 4) >
    <#lt>    xTaskCreate( _OTA_SERVICE_Tasks,
    <#lt>        "OTA_SERVICE_Tasks",
    <#lt>        ${OTA_SERVICE_STACK_SIZE},
    <#lt>        (void*)NULL,
    <#lt>        ${OTA_SERVICE_RTOS_TASK_PRIORITY},
    <#lt>        (TaskHandle_t*)NULL
    <#lt>    );
  <#elseif (HarmonyCore.SELECT_RTOS)?? && HarmonyCore.SELECT_RTOS == "ThreadX">
    <#lt>    tx_byte_allocate(&byte_pool_0,
    <#lt>       (VOID **) &_ota_service_Task_Stk_Ptr,
    <#lt>        ${OTA_SERVICE_RTOS_STACK_SIZE},
    <#lt>        TX_NO_WAIT);

    <#lt>    tx_thread_create(&_ota_service_Task_TCB,
    <#lt>        "OTA_SERVICE_Tasks",
    <#lt>        _OTA_SERVICE_Tasks,
    <#lt>        0,
    <#lt>        _ota_service_Task_Stk_Ptr,
    <#lt>        ${OTA_SERVICE_RTOS_STACK_SIZE},
    <#lt>        ${OTA_SERVICE_RTOS_TASK_PRIORITY},
    <#lt>        ${OTA_SERVICE_RTOS_TASK_PRIORITY},
    <#lt>        TX_NO_TIME_SLICE,
    <#lt>        TX_AUTO_START
    <#lt>        );
  <#elseif (HarmonyCore.SELECT_RTOS)?? && HarmonyCore.SELECT_RTOS == "MicriumOSIII">
    <#assign OTA_SERVICE_RTOS_TASK_OPTIONS = "OS_OPT_TASK_NONE" + OTA_SERVICE_RTOS_TASK_OPT_STK_CHK?then(' | OS_OPT_TASK_STK_CHK', '') + OTA_SERVICE_RTOS_TASK_OPT_STK_CLR?then(' | OS_OPT_TASK_STK_CLR', '') + OTA_SERVICE_RTOS_TASK_OPT_SAVE_FP?then(' | OS_OPT_TASK_SAVE_FP', '') + OTA_SERVICE_RTOS_TASK_OPT_NO_TLS?then(' | OS_OPT_TASK_NO_TLS', '')>
    <#lt>    OSTaskCreate((OS_TCB      *)&_ota_service_Tasks_TCB,
    <#lt>                 (CPU_CHAR    *)"OTA_SERVICE_Tasks",
    <#lt>                 (OS_TASK_PTR  )_OTA_SERVICE_Tasks,
    <#lt>                 (void        *)0,
    <#lt>                 (OS_PRIO      )${OTA_SERVICE_RTOS_TASK_PRIORITY},
    <#lt>                 (CPU_STK     *)&_ota_service_TasksStk[0],
    <#lt>                 (CPU_STK_SIZE )0u,
    <#lt>                 (CPU_STK_SIZE )${OTA_SERVICE_RTOS_STACK_SIZE},
    <#if MicriumOSIII.UCOSIII_CFG_TASK_Q_EN == true>
    <#lt>                 (OS_MSG_QTY   )${OTA_SERVICE_RTOS_TASK_MSG_QTY},
    <#else>
    <#lt>                 (OS_MSG_QTY   )0u,
    </#if>
    <#if MicriumOSIII.UCOSIII_CFG_SCHED_ROUND_ROBIN_EN == true>
    <#lt>                 (OS_TICK      )${OTA_SERVICE_RTOS_TASK_TIME_QUANTA},
    <#else>
    <#lt>                 (OS_TICK      )0u,
    </#if>
    <#lt>                 (void        *)0,
    <#lt>                 (OS_OPT       )(${OTA_SERVICE_RTOS_TASK_OPTIONS}),
    <#lt>                 (OS_ERR      *)&os_err);
  <#elseif (HarmonyCore.SELECT_RTOS)?? && HarmonyCore.SELECT_RTOS == "MbedOS">
    <#lt>    Thread ota_service_thread((osPriority)(osPriorityNormal + (${OTA_SERVICE_RTOS_TASK_PRIORITY} - 1)), ${OTA_SERVICE_RTOS_STACK_SIZE}, NULL, "OTA_SERVICE_Tasks");
    <#lt>    ota_service_thread.start(callback(_OTA_SERVICE_Tasks, (void *)NULL));
  <#else>
    <#lt>    OTA_SERVICE_Tasks();
  </#if>
<#else>
    <#lt>    OTA_SERVICE_Tasks();
</#if>
