<#if booleanappcode ==  true>
<#assign APP_ANCS = false>
<#assign APP_ANPC = false>
<#assign APP_ANPS = false>
<#assign APP_HOGP = false>
<#assign APP_PXPR = false>
<#assign APP_PXPM = false>
<#assign APP_THROUGHPUT = false>
<#if wlsbleancsss?? && wlsbleancsss.SS_ANCS_BOOL_CLIENT == true> 
<#assign APP_ANCS = true>
</#if>
<#if wlsbleanpss?? && wlsbleanpss.ANPSS_BOOL_CLIENT == true> 
<#assign APP_ANPC = true>
</#if>
<#if wlsbleanpss?? && wlsbleanpss.ANPSS_BOOL_SERVER == true> 
<#assign APP_ANPS = true>
</#if>
<#if wlsblehogp?? && wlsblehogp.HOGP_BOOL_SERVER == true> 
<#assign APP_HOGP = true>
</#if>
<#if wlsblepxpss?? && wlsblepxpss.SS_PXP_BOOL_CLIENT == true> 
<#assign APP_PXPM = true>
</#if>
<#if wlsblepxpss?? && wlsblepxpss.SS_PXP_BOOL_SERVER == true> 
<#assign APP_PXPR = true>
</#if>
<#if WLS_BLE_GAP_PERIPHERAL == true && WLS_BLE_GAP_ADVERTISING == true && wlsbletrspss?? && wlsbletrspss.SS_TRSP_BOOL_SERVER == true && WLS_BLE_BOOL_GAP_EXT_ADV == false && WLS_BLE_GAP_DSADV_EN == false && WLS_BLE_BOOL_L2CAP_CREDIT_FLOWCTRL == true> 
<#assign APP_THROUGHPUT = true>
</#if>
/*******************************************************************************
  Application Timer Header File

  Company:
    Microchip Technology Inc.

  File Name:
    app_timer.h

  Summary:
    This file contains the Application Timer functions for this project.

  Description:
    This file contains the Application Timer functions for this project.
    Including the Set/Stop/Reset timer and timer expired handler.
 *******************************************************************************/

// DOM-IGNORE-BEGIN
/*******************************************************************************
* Copyright (C) 2025 Microchip Technology Inc. and its subsidiaries.
*
* Subject to your compliance with these terms, you may use Microchip software
* and any derivatives exclusively with Microchip products. It is your
* responsibility to comply with third party license terms applicable to your
* use of third party software (including open source software) that may
* accompany Microchip software.
*
* THIS SOFTWARE IS SUPPLIED BY MICROCHIP "AS IS". NO WARRANTIES, WHETHER
* EXPRESS, IMPLIED OR STATUTORY, APPLY TO THIS SOFTWARE, INCLUDING ANY IMPLIED
* WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS FOR A
* PARTICULAR PURPOSE.
*
* IN NO EVENT WILL MICROCHIP BE LIABLE FOR ANY INDIRECT, SPECIAL, PUNITIVE,
* INCIDENTAL OR CONSEQUENTIAL LOSS, DAMAGE, COST OR EXPENSE OF ANY KIND
* WHATSOEVER RELATED TO THE SOFTWARE, HOWEVER CAUSED, EVEN IF MICROCHIP HAS
* BEEN ADVISED OF THE POSSIBILITY OR THE DAMAGES ARE FORESEEABLE. TO THE
* FULLEST EXTENT ALLOWED BY LAW, MICROCHIP'S TOTAL LIABILITY ON ALL CLAIMS IN
* ANY WAY RELATED TO THIS SOFTWARE WILL NOT EXCEED THE AMOUNT OF FEES, IF ANY,
* THAT YOU HAVE PAID DIRECTLY TO MICROCHIP FOR THIS SOFTWARE.
*******************************************************************************/
// DOM-IGNORE-END


#ifndef APP_TIMER_H
#define APP_TIMER_H


// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************
#include <stdint.h>
#include "osal/osal_freertos_extend.h"
#include "timers.h"


// *****************************************************************************
// *****************************************************************************
// Section: Macros
// *****************************************************************************
// *****************************************************************************

/**@brief The definition of Timer ID. */
typedef enum APP_TIMER_TimerId_T
{
<#if APP_ANCS == true || APP_ANPC == true || APP_ANPS == true || APP_HOGP == true || APP_PXPM == true || APP_PXPR == true>
    APP_TIMER_LED_01,                       /**< The timer to measure LED interval and duration. */
    APP_TIMER_KEY_SCAN_02,                  /**< The timer for key scan. */
</#if>
<#if APP_HOGP == true>
    APP_TIMER_CONN_TIMEOUT_03,
</#if>
<#if APP_PXPM == true>
    APP_TIMER_RSSI_MONI_03,
</#if>
<#if APP_PXPR == true>
    APP_TIMER_LED_ALERT_03,
#ifdef PIC32BZ3
    APP_TIMER_LED_IND_SWITCH_04,
#endif
</#if>
<#if APP_THROUGHPUT == true>
    APP_TIMER_PROTOCOL_RSP_01,              /**< The timer to check protocol response delay. */
    APP_TIMER_FETCH_TRP_RX_DATA_02,         /**< The timer to fetch the TRP RX data. */
    APP_TIMER_LED_04,                       /**< The timer to measure LED interval and duration. */

    APP_TIMER_RESERVED_07,                  /**< Reserved. */
    APP_TIMER_RESERVED_08,                  /**< Reserved. */
    APP_TIMER_RESERVED_09,                  /**< Reserved. */
</#if>

    APP_TIMER_TOTAL
} APP_TIMER_TimerId_T;

/**@defgroup APP_TIMER_TIMEOUT APP_TIMER_TIMEOUT
 * @brief The definition of the timeout value.
 * @{ */
#define APP_TIMER_10MS                                 0x0A     /**< 10ms timer. */
#define APP_TIMER_12MS                                 0x0C     /**< 12ms timer. */
#define APP_TIMER_18MS                                 0x12     /**< 18ms timer. */
#define APP_TIMER_20MS                                 0x14     /**< 20ms timer. */
#define APP_TIMER_30MS                                 0x1E     /**< 30ms timer. */
#define APP_TIMER_50MS                                 0x32     /**< 50ms timer. */
#define APP_TIMER_100MS                                0x64     /**< 100ms timer. */
#define APP_TIMER_500MS                                0x1F4    /**< 500ms timer. */
#define APP_TIMER_1S                                   0x3E8    /**< 1s timer. */
#define APP_TIMER_2S                                   0x7D0    /**< 2s timer. */
#define APP_TIMER_3S                                   0xBB8    /**< 3s timer. */
#define APP_TIMER_5S                                   0x1388   /**< 5s timer. */
#define APP_TIMER_30S                                  0x7530   /**< 30s timer. */
#define APP_TIMER_3MIN                                 0x2BF20  /**< 3min timer. */
/** @} */

// *****************************************************************************
// *****************************************************************************
// Section: Data Types
// *****************************************************************************
// *****************************************************************************
/**@brief The structure contains the information about Timer element structure. */
typedef struct APP_TIMER_TmrElem_T
{
    uint8_t        tmrId;           /**< Dedicated timer Id */
    uint8_t        instance;        /**< Dedicated timer instance */ 
    TimerHandle_t   tmrHandle;      /**< Dedicated timer handler */ 
    void            *p_tmrParam;    /**< Dedicated timer parameter */
} APP_TIMER_TmrElem_T;


// *****************************************************************************
// *****************************************************************************
// Section: Function Prototypes
// *****************************************************************************
// *****************************************************************************

/**@brief The function is used to set timer element.
 *@param[in] timerId                          Timer ID. See @ref APP_TIMER_TimerId_T.
 *@param[in] instance                         Timer instance. Defined by users.
 *@param[in] p_tmrParam                       Timer parameters. Users want to pass the parameter.
 *@param[out] p_tmrElem                       Timer element. See @ref APP_TIMER_TmrElem_T.
 *
 * @retval none                               
 *
 */
void APP_TIMER_SetTimerElem(uint8_t timerId, uint8_t instance, void *p_tmrParam, 
    APP_TIMER_TmrElem_T *p_tmrElem);

/**@brief The function is used to set and start a timer.
 *@param[in] timerId                          Timer ID. See @ref APP_TIMER_TimerId_T.
 *@param[in] timeout                          Timeout value (unit: ms)
 *@param[in] isPeriodicTimer                  Set as true to let the timer expire repeatedly with a frequency set by the timeout parameter. \n
 *                                            Set as false to let the timer be a one-shot timer.
 *
 * @retval APP_RES_SUCCESS                    Set and start a timer successfully.
 * @retval APP_RES_FAIL                       Failed to start the timer.
 * @retval APP_RES_OOM                        No available memory.
 * @retval APP_RES_NO_RESOURCE                Failed to create a new timer.
 *
 */
uint16_t APP_TIMER_SetTimer(APP_TIMER_TmrElem_T *p_timerId, uint32_t timeout, bool isPeriodicTimer);

/**@brief The function is used to stop a timer.
 *@param[in] timerId                          Timer ID. See @ref APP_TIMER_TimerId_T.
 *
 * @retval APP_RES_SUCCESS                    Stop a timer successfully.
 * @retval APP_RES_FAIL                       Failed to stop the timer.
 * @retval APP_RES_INVALID_PARA               The timerId doesn't exist.
 *
 */
uint16_t APP_TIMER_StopTimer(TimerHandle_t *timerHandler);

/**@brief The function is used to re-start a timer. Not available if the timer is one-shot and it has been expired.
 *@param[in] timerId                          Timer ID. See @ref APP_TIMER_TimerId_T.
 *
 * @retval APP_RES_SUCCESS                    Reset a timer successfully.
 * @retval APP_RES_FAIL                       Failed to reset the timer.
 * @retval APP_RES_INVALID_PARA               The timerId doesn't exist.
 *
 */
uint16_t APP_TIMER_ResetTimer(TimerHandle_t timerHandler);

#endif
</#if>