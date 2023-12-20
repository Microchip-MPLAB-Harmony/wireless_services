( function() {  var mapping = [{"appname":"", "appid":"OTA_SERVICE_Tasks", "path":"GUID-F504A2BE-0F28-49E9-8F4A-40C61A8DADA1.html"},{"appname":"", "appid":"OTA_SERVICE_Transport_Tasks", "path":"GUID-C561467B-299A-43C2-9D71-32B1BA2BCD44.html"},{"appname":"", "appid":"OTA_SERVICE_OTA_Initialize", "path":"GUID-7D50DABA-10E8-4576-BB61-458197CF5A65.html"},{"appname":"", "appid":"OTA_SERVICE_Transport_FHMsgReceive", "path":"GUID-ADDBE456-881C-4DC7-BC6B-4777C154D400.html"},{"appname":"", "appid":"OTA_SERVIC_Task_UpdateUser", "path":"GUID-5C0E4708-4FDE-47BB-B065-5373D409E2EA.html"},{"appname":"", "appid":"OTA_CallBackReg", "path":"GUID-FBE157F6-70A7-4241-8026-7E59103E3C22.html"},{"appname":"", "appid":"OTA_SERVICE_OTA_Start", "path":"GUID-AB5C2131-20B9-4F80-A29E-E4CB43F8C831.html"},{"appname":"", "appid":"OTA_SERVICE_Transport_initialize", "path":"GUID-15795D88-C6D4-438A-882F-74D946AB8E53.html"},{"appname":"", "appid":"OTA_SERVICE_Transport_Complete", "path":"GUID-EFE06E46-BAC7-48D0-8419-9BB38944A4DF.html"},{"appname":"", "appid":"OTA_SERVICE_Transport_MsgRecv", "path":"GUID-0B03E4E3-52DA-4D47-A3C4-66735228B561.html"},{"appname":"", "appid":"OTA_SERVICE_Transport_MsgSend", "path":"GUID-DA0320D3-0E0C-41BF-9EA1-8E593EA30287.html"},{"appname":"", "appid":"OTA_SERVICE_Transport_RspRecv", "path":"GUID-0435D032-19C1-4D4C-BD25-376A65AF68E6.html"},{"appname":"", "appid":"OTA_SERVICE_Transport_ackResp", "path":"GUID-B86B3087-E346-4ABD-83B5-565AF5C76BF4.html"},{"appname":"", "appid":"OTA_SERVICE_Transport_CloseOta", "path":"GUID-2A8C4FC6-AB3F-4F56-AFAD-EAEC95AA8770.html"},{"appname":"", "appid":"OTA_SERVICE_FH_CtrlBlkRead", "path":"GUID-12590574-8460-4790-9A58-0324493CC59B.html"},{"appname":"", "appid":"OTA_SERVICE_FH_CtrlBlkWrite", "path":"GUID-E1165A17-B4A2-4711-897E-B09ECEF50B26.html"},{"appname":"", "appid":"OTA_SERVICE_FH_StateGet", "path":"GUID-99762913-2246-4419-A689-47DB04E495E4.html"},{"appname":"", "appid":"OTA_SERVICE_FH_Tasks", "path":"GUID-6DE8F3D2-193B-470B-8D2C-E47E82885C60.html"},{"appname":"", "appid":"OTA_SERVICE_FH_TriggerReset", "path":"GUID-67C8BEB1-6370-4DF2-B347-11F5FE626EF5.html"}];
            var mchp = (function (mchp) {
                var mchp = mchp || {};
                var mapping = [];
        
                mchp.utils = {};
        
                mchp.utils.getQueryParam = function (name, url = window.location.href) {
                  name = name.replace(/[\[\]]/g, "\\$&");
                  var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
                    results = regex.exec(url);
                  if (!results) return null;
                  if (!results[2]) return "";
                  return decodeURIComponent(results[2].replace(/\+/g, " "));
                };

                mchp.utils.isFirefox = typeof InstallTrigger !== 'undefined';
        
                mchp.init = function (options) {
                  mchp.mapping = options.mapping || [];
                  mchp.bindEvents();
                };
        
                mchp.bindEvents = function () {
                    if (mchp.utils.isFirefox) {
                      window.onload = mchp.checkRedirect;
                    } else {
                      document.onreadystatechange = mchp.checkRedirect;
                    }
                };

                mchp.checkRedirect = function() {
                  var contextId = mchp.utils.getQueryParam("contextId") || "";
                  if (contextId && contextId != undefined) {
                    var record = mchp.mapping.find(function(x){
                      return x.appid && x.appid.toLowerCase() == contextId.toLowerCase();
                    });
                    if (record && record.path) {
                      window.stop();
                      window.location = record.path;
                    }
                  }
                };
        
                return {
                  init: mchp.init,
                };
              })();
        
              mchp.init({
                mapping: mapping
              });

        })();