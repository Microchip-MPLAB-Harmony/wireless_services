<#if booleanappcode == true>
${WLS_BLE_COMMENT}
<#if wlsbletrspss??>
<#-- For TRSP_CLIENT or TRSP_SERVER configuration (either CLIENT ,SERVER or both together) -->
<#if (wlsbletrspss.SS_TRSP_BOOL_CLIENT == true || wlsbletrspss.SS_TRSP_BOOL_SERVER == true) && WLS_BLE_BOOL_L2CAP_CREDIT_FLOWCTRL == false>
                else if(p_appMsg->msgId==APP_MSG_UART_CB)
                        {
                        // Transparent UART Client Data transfer Event
                            APP_UartCBHandler();
                        } 
</#if>
</#if>
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && WLS_BLE_BOOL_GAP_EXT_ADV == false && WLS_BLE_GAP_DSADV_EN == false && WLS_BLE_BOOL_L2CAP_CREDIT_FLOWCTRL == true>
            switch (p_appMsg->msgId) {
                case APP_MSG_BLE_STACK_EVT:
                    // Pass BLE Stack Event Message to User Application for handling
                    APP_BleStackEvtHandler((STACK_Event_T *) p_appMsg->msgData);
                    break;

                case APP_MSG_PROTOCOL_RSP:
                    {
                        p_connList = ((APP_TIMER_TmrElem_T *) p_appMsg->msgData)->p_tmrParam;

                        if ((p_connList != NULL) && (p_connList->trpRole == APP_TRP_SERVER_ROLE))
                            APP_WLS_TRP_SendCheckSumCommand(p_connList);
                    }
                        break;

                case APP_MSG_FETCH_TRP_RX_DATA:
                    {
                        p_connList = ((APP_TIMER_TmrElem_T *) p_appMsg->msgData)->p_tmrParam;
                        if ((p_connList != NULL) && (p_connList->trpRole == APP_TRP_SERVER_ROLE))
                        {
                            uint16_t dataLen;
                            uint8_t *p_data = NULL;
                            status = APP_WLS_TRPS_GetDataParam(p_connList,&dataLen,p_data);
                            if(status == MBA_RES_SUCCESS)
                                APP_WLS_TRPS_ProcessData(p_connList,dataLen,p_data);
                        }
                    }
                        break;

                case APP_MSG_LED_TIMEOUT:
                    {
                        APP_LED_Elem_T *p_ledElem;

                        instance = ((APP_TIMER_TmrElem_T *) p_appMsg->msgData)->instance;
                        p_ledElem = (APP_LED_Elem_T *) ((APP_TIMER_TmrElem_T *) p_appMsg->msgData)->p_tmrParam;
                        APP_LED_StateMachine(instance, p_ledElem);
                    }
                        break;
                }
</#if>
<#if wlsbleancsss?? && wlsbleancsss.SS_ANCS_BOOL_CLIENT == true 
    || wlsblehogp?? && wlsblehogp.HOGP_BOOL_SERVER == true
    || wlsbleanpss?? &&  wlsbleanpss.ANPSS_BOOL_CLIENT == true
    || wlsbleanpss?? &&  wlsbleanpss.ANPSS_BOOL_SERVER == true
    || wlsblepxpss?? && wlsblepxpss.SS_PXP_BOOL_SERVER == true>

                else if(p_appMsg->msgId==APP_MSG_LED_TIMEOUT)
                {
                    APP_LED_Elem_T *p_ledElem;
                    uint8_t     instance;

                    instance = ((APP_TIMER_TmrElem_T *)p_appMsg->msgData)->instance;
                    p_ledElem = (APP_LED_Elem_T *)((APP_TIMER_TmrElem_T *)p_appMsg->msgData)->p_tmrParam;
                    APP_LED_StateMachine(instance, p_ledElem);
                }
</#if>
<#if wlsblepxpss?? && wlsblepxpss.SS_PXP_BOOL_CLIENT == true>
                else if(p_appMsg->msgId == APP_MSG_RSSI_MONI_TIMEOUT)
                { 
                    APP_WLS_PXPM_RssiMonitorHandler((APP_TIMER_TmrElem_T *)(void*)p_appMsg->msgData);
                }
</#if>
<#if wlsbleancsss?? && wlsbleancsss.SS_ANCS_BOOL_CLIENT == true 
    || wlsblehogp?? && wlsblehogp.HOGP_BOOL_SERVER == true
    || wlsbleanpss?? &&  wlsbleanpss.ANPSS_BOOL_CLIENT == true
    || wlsbleanpss?? &&  wlsbleanpss.ANPSS_BOOL_SERVER == true
    || wlsblepxpss?? && wlsblepxpss.SS_PXP_BOOL_SERVER == true
    || wlsblepxpss?? && wlsblepxpss.SS_PXP_BOOL_CLIENT == true>
                else if(p_appMsg->msgId==APP_MSG_KEY_SCAN)
                {
                    APP_KEY_Scan();
                }	
</#if>
<#if wlsblepxpss?? &&wlsblepxpss.SS_PXP_BOOL_CLIENT == true>
#ifdef PIC32BZ3
                else if(p_appMsg->msgId==APP_MSG_LED_TIMEOUT)
                {
                    APP_LED_Elem_T *p_ledElem;
                    uint8_t     instance;

                    instance = ((APP_TIMER_TmrElem_T *)p_appMsg->msgData)->instance;
                    p_ledElem = (APP_LED_Elem_T *)((APP_TIMER_TmrElem_T *)p_appMsg->msgData)->p_tmrParam;
                    APP_LED_StateMachine(instance, p_ledElem);
                }
#endif                
</#if>
<#if wlsblehogp?? && wlsblehogp.HOGP_BOOL_SERVER == true>
                else if(p_appMsg->msgId==APP_MSG_CONN_TIMEOUT)
                {
                    APP_CONN_TimeoutAction();
                }
</#if>
<#if wlsblepxpss?? && wlsblepxpss.SS_PXP_BOOL_SERVER == true> 
                else if((APP_MsgId_T)p_appMsg->msgId==APP_MSG_ALERT_TOGGLE)
#ifdef PIC32BZ2
                {
                    BSP_USER_LED_Toggle();
                }
#elif defined(PIC32BZ3)
                {
                    BSP_RGB_LED_GREEN_Toggle();
                }
	            else if((APP_MsgId_T)p_appMsg->msgId==APP_MSG_LED_IND_SWITCH)
                {
                    APP_WLS_PXPR_connStateLedRestore();
                }
#endif
</#if>
<#if wlsbleanpss?? &&  wlsbleanpss.ANPSS_BOOL_CLIENT == true 
    || wlsbleanpss?? &&  wlsbleanpss.ANPSS_BOOL_SERVER == true
    || wlsblepxpss?? && wlsblepxpss.SS_PXP_BOOL_CLIENT == true
    || wlsblepxpss?? && wlsblepxpss.SS_PXP_BOOL_SERVER == true>
            else
                {
                }            
</#if>
</#if>