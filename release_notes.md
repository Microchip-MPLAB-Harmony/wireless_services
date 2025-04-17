![Microchip logo](https://raw.githubusercontent.com/wiki/Microchip-MPLAB-Harmony/Microchip-MPLAB-Harmony.github.io/images/microchip_logo.png)
![Harmony logo small](https://raw.githubusercontent.com/wiki/Microchip-MPLAB-Harmony/Microchip-MPLAB-Harmony.github.io/images/microchip_mplab_harmony_logo_small.png)

# Microchip MPLAB® Harmony 3 Release Notes

### Wireless services Release v2.0.0
### New Features

- This release includes support for 
    - **BLE Config App Service**  This service component will automatically generate application-specific code based on the BLE stack settings. All other application components have dependency with this service component.
    - **Apple Notification App Service**  This profile service component replicates the configuration of the Apple Notification Center Service (ANCS) Profile component. It will automatically activate the necessary components for the ANCS Profile and configure the ANCS component and stack for application development.
    - **Alert Notification App Service**  This profile service component replicates the configuration of the Alert Notification Profile component. It will automatically activate the necessary components for the Alert Notification Profile and configure the Alert Notification Service component and stack for application development.
    - **HIG Over GATT App Service**  This profile service component replicates the configuration of the HIG Over GATT Profile (HOGP) component within the service configuration interface. It will automatically activate the necessary components for the HOGP and configure the HIG Over GATT Service component and stack for application development.
    - **Proximity App Service**  This profile service component replicates the configuration of the Proximity Profile component within the service configuration interface. It will automatically activate the necessary components for the Proximity Profile and configure the Proximity Service component and stack for application development.
    - **Transparent App Service**  This profile service component replicates the configuration of the Transparent Profile component within the service configuration interface. It will automatically activate the necessary components for the Transparent Profile and configure the Transparent Profile component and stack for application development.
    - **Custom Protocol App Service**  This service component assists users in quickly designing custom protocols over BLE custom services to meet their specific requirements.
### Known Issues
### Dependent repo details

| Repo     | Version                                               |
| ---        | ---                                                       |
| wireless_ble       | v1.4.0   |
| wireless_pic32cxbz_wbz    | v1.5.0   |

### Development Tools

* [MPLAB® X IDE v6.25](https://www.microchip.com/mplab/mplab-x-ide)
* [MPLAB® XC32 C/C++ Compiler 4.60](https://www.microchip.com/mplab/compilers)
* MPLAB® X IDE plug-ins:
    * MPLAB® Code Configurator (MCC) v5.5.2

### Wireless services Release v1.0.0
### New Features

- This release includes support for 
    - **OTA Service** for BLE RNBDxxx device.
### Known Issues
### Development Tools

* [MPLAB® X IDE v6.15](https://www.microchip.com/mplab/mplab-x-ide)
* [MPLAB® XC32 C/C++ Compiler v4.35](https://www.microchip.com/mplab/compilers)
* MPLAB® X IDE plug-ins:
    * MPLAB® Code Configurator (MCC) v5.4.1
