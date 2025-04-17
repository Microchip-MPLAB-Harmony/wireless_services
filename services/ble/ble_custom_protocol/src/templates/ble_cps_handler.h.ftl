/*******************************************************************************
* Copyright (C) 2024 Microchip Technology Inc. and its subsidiaries.
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

/*******************************************************************************
  BLE Custom System Service Write Handler Header File

  Company:
    Microchip Technology Inc.

  File Name:
    ble_css_handler.h

  Summary:
    This file contains the functions to receive and send the BLE write data.
	
  Description:
    This file contains the functions to handle the BLE write data.
 *******************************************************************************/
#ifndef BLE_CPS_HANDLER_H
#define BLE_CPS_HANDLER_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

#include <stdint.h>
#include <string.h>
#include "gap_defs.h"
#include "ble_gap.h"
#include "ble_l2cap.h"
#include "ble_smp.h"
#include "gatt.h"
#include "ble_dtm.h"
#include "ble_dm/ble_dm.h"

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

extern "C" {

#endif
// DOM-IGNORE-END

// *****************************************************************************
// *****************************************************************************
// Section: Macros
// *****************************************************************************
// *****************************************************************************
#define BLE_CSS_GAP_ADV_DURATION        0

// *****************************************************************************
// *****************************************************************************
// Section: Data Types
// *****************************************************************************
// *****************************************************************************
typedef struct BLE_CSS_CurrConn_T
{
    uint16_t                   connHandle;              /**< Connection handle associated with current connection. */
    uint16_t                   attMtu;                  /**< Record the current connection MTU size. */
    uint16_t                   attrHandle;              /**< characteristic handle through which packet received*/
} BLE_CSS_CurrConn_T;

// *****************************************************************************
// *****************************************************************************
// Section: Function Prototypes
// *****************************************************************************
// *****************************************************************************
/**
 * @brief Processes GAP events received from the BLE stack for the custom protocol application.
 *
 * This function handles the GAP (Generic Access Profile) events that are received from the BLE (Bluetooth Low Energy) stack.
 * It is designed to be used within a custom protocol application to manage BLE connections, advertisements, and other GAP-related activities.
 *
 * @param[in] p_event Pointer to a structure of type BLE_GAP_Event_T that contains the details of the GAP event.
 *
 * @return None
 */
void BLE_CPS_GapEventProcess(BLE_GAP_Event_T *p_event);

/**
 * @brief Processes GATT events received from the BLE stack for the custom protocol application.
 *
 * This function handles the GATT (Generic Attribute Profile) events that are received from the BLE (Bluetooth Low Energy) stack.
 * It processes these events to ensure proper communication and functionality of the custom protocol application.
 *
 * @param[in] p_event Pointer to a structure of type GATT_Event_T that contains the details of the GATT event.
 *
 * @return None
 */
void BLE_CPS_GattEventProcess(GATT_Event_T *p_event);

/**
 * @brief Sends a response as a BLE notification using the respective attribute handle from which the packet is received.
 *
 * This API allows the user to send a response. The response will be sent as a BLE notification using the attribute handle
 * from which the packet is received.
 *
 * @param[in] payloadLength Length of the packet.
 * @param[in] p_payload Pointer to the payload buffer (array of uint8_t).
 *
 * @return Stack API return result.
 */
uint16_t BLE_CPS_SendResponse(uint16_t payloadLength, uint8_t *p_payload);

/**
 * @brief Sends a notification via the BLE stack.
 *
 * This API allows the user to send a notification by providing the attribute handle,
 * the payload length, and a pointer to the payload buffer.
 *
 * @param[in] attrHandle BLE attribute handle.
 * @param[in] payloadLength Length of the payload in bytes.
 * @param[in] p_payload Pointer to the payload buffer (array of uint8_t).
 *
 * @return Stack API return result.
 */
uint16_t BLE_CPS_NotifyData(uint16_t attrHandle, uint16_t payloadLength, uint8_t *p_payload);

/**
 * @brief Initializes the custom service by registering it with the GATT server.
 *
 * This function sets up the custom service and registers it with the GATT (Generic Attribute Profile) server,
 * making it available for use in the Bluetooth stack.
 *
 * @param[in] None
 *
 * @retval None
 */
void BLE_CPS_Init(void);

//DOM-IGNORE-BEGIN
#ifdef __cplusplus
}
#endif
//DOM-IGNORE-END

#endif /* BLE_CPS_HANDLER_H */