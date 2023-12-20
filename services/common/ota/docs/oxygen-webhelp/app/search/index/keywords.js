define(function() {var keywords=[{w:"1.1.4.1.5",p:["p0"]},{w:"OTA_SERVICE_Transport_RspRecv",p:["p0"]},{w:"Quality",p:["p1"]},{w:"Management",p:["p1"]},{w:"System",p:["p1","p24"]},{w:"1.1.4.1.3",p:["p2"]},{w:"OTA_SERVICE_Transport_MsgRecv",p:["p2"]},{w:"Microchip",p:["p3","p18","p32"]},{w:"Information",p:["p3"]},{w:"1.1.5.1.1",p:["p4"]},{w:"OTA_SERVICE_FH_CtrlBlkRead",p:["p4"]},{w:"Legal",p:["p5"]},{w:"Notice",p:["p5"]},{w:"1.1.4.1.1",p:["p6"]},{w:"OTA_SERVICE_Transport_initialize",p:["p6"]},{w:"1.1.6",p:["p7"]},{w:"OTA",p:["p7","p10","p11","p12","p13","p17","p19","p21","p28","p33"]},{w:"service",p:["p7","p11","p12","p13","p17","p19","p21","p28","p29","p33","p34"]},{w:"Host",p:["p7"]},{w:"Script",p:["p7"]},{w:"Help",p:["p7","p39"]},{w:"Trademarks",p:["p8"]},{w:"1.1.4.1.7",p:["p9"]},{w:"OTA_SERVICE_Transport_CloseOta",p:["p9"]},{w:"1.1.4",p:["p10"]},{w:"Transport",p:["p10","p17"]},{w:"Task",p:["p10","p21"]},{w:"1.1.3",p:["p11"]},{w:"Library",p:["p11","p12","p13","p17"]},{w:"Interface",p:["p11","p13","p17"]},{w:"1.1.1",p:["p12"]},{w:"How",p:["p12"]},{w:"the",p:["p12","p18"]},{w:"works",p:["p12"]},{w:"1.1.5.1",p:["p13"]},{w:"File",p:["p13","p21"]},{w:"Handler",p:["p13","p21"]},{w:"1.1.3.5",p:["p14"]},{w:"OTA_SERVIC_Task_UpdateUser",p:["p14"]},{w:"1.1.5.1.5",p:["p15"]},{w:"OTA_SERVICE_FH_TriggerReset",p:["p15"]},{w:"1.1.5.1.4",p:["p16"]},{w:"OTA_SERVICE_FH_Tasks",p:["p16"]},{w:"1.1.4.1",p:["p17"]},{w:"Website",p:["p18"]},{w:"1.1",p:["p19"]},{w:"-",p:["p19"]},{w:"Bluetooth",p:["p19"]},{w:"Low",p:["p19"]},{w:"Energy",p:["p19"]},{w:"1.1.3.3",p:["p20"]},{w:"OTA_SERVICE_OTA_Initialize",p:["p20"]},{w:"1.1.5",p:["p21"]},{w:"1.1.5.1.3",p:["p22"]},{w:"OTA_SERVICE_FH_StateGet",p:["p22"]},{w:"1.1.3.7",p:["p23"]},{w:"OTA_SERVICE_OTA_Start",p:["p23"]},{w:"Product",p:["p24","p29"]},{w:"Identification",p:["p24"]},{w:"1.1.3.4",p:["p25"]},{w:"OTA_SERVICE_Transport_FHMsgReceive",p:["p25"]},{w:"1.1.4.1.6",p:["p26"]},{w:"OTA_SERVICE_Transport_ackResp",p:["p26"]},{w:"1.1.3.2",p:["p27"]},{w:"OTA_SERVICE_Transport_Tasks",p:["p27"]},{w:"1.1.2",p:["p28"]},{w:"Configurations",p:["p28"]},{w:"Change",p:["p29"]},{w:"Notification",p:["p29"]},{w:"1.1.4.1.4",p:["p30"]},{w:"OTA_SERVICE_Transport_MsgSend",p:["p30"]},{w:"1.1.5.1.2",p:["p31"]},{w:"OTA_SERVICE_FH_CtrlBlkWrite",p:["p31"]},{w:"Devices",p:["p32"]},{w:"Code",p:["p32"]},{w:"Protection",p:["p32"]},{w:"Feature",p:["p32"]},{w:"1",p:["p33"]},{w:"Worldwide",p:["p34"]},{w:"Sales",p:["p34"]},{w:"and",p:["p34"]},{w:"1.1.4.1.2",p:["p35"]},{w:"OTA_SERVICE_Transport_Complete",p:["p35"]},{w:"Customer",p:["p36"]},{w:"Support",p:["p36"]},{w:"1.1.3.1",p:["p37"]},{w:"OTA_SERVICE_Tasks",p:["p37"]},{w:"1.1.3.6",p:["p38"]},{w:"OTA_CallBackReg",p:["p38"]},{w:"Context",p:["p39"]},{w:"Sensitive",p:["p39"]}];
var ph={};
ph["p0"]=[0, 1];
ph["p1"]=[2, 3, 4];
ph["p2"]=[5, 6];
ph["p3"]=[7, 8];
ph["p4"]=[9, 10];
ph["p5"]=[11, 12];
ph["p6"]=[13, 14];
ph["p7"]=[15, 16, 17, 18, 19, 20];
ph["p8"]=[21];
ph["p9"]=[22, 23];
ph["p30"]=[69, 70];
ph["p10"]=[24, 16, 25, 26];
ph["p32"]=[7, 73, 74, 75, 76];
ph["p31"]=[71, 72];
ph["p12"]=[30, 31, 32, 16, 17, 28, 33];
ph["p34"]=[78, 79, 80, 17];
ph["p11"]=[27, 16, 17, 28, 29];
ph["p33"]=[77, 16, 17];
ph["p14"]=[37, 38];
ph["p36"]=[83, 84];
ph["p13"]=[34, 16, 17, 35, 36, 28, 29];
ph["p35"]=[81, 82];
ph["p16"]=[41, 42];
ph["p38"]=[87, 88];
ph["p15"]=[39, 40];
ph["p37"]=[85, 86];
ph["p18"]=[32, 7, 44];
ph["p17"]=[43, 16, 17, 25, 28, 29];
ph["p39"]=[89, 90, 20];
ph["p19"]=[45, 16, 17, 46, 47, 48, 49];
ph["p21"]=[52, 16, 17, 35, 36, 26];
ph["p20"]=[50, 51];
ph["p23"]=[55, 56];
ph["p22"]=[53, 54];
ph["p25"]=[59, 60];
ph["p24"]=[57, 58, 4];
ph["p27"]=[63, 64];
ph["p26"]=[61, 62];
ph["p29"]=[57, 67, 68, 17];
ph["p28"]=[65, 16, 17, 66];
     return {
         keywords: keywords,
         ph: ph
     }
});
