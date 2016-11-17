/*
    Copyright 2015 IBM Corp.
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
        http://www.apache.org/licenses/LICENSE-2.0
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/
package com.ibm.mobilefirstplatform.clientsdk.cordovaplugins.push;

import com.ibm.mobilefirstplatform.clientsdk.android.push.api.MFPPush;
import com.ibm.mobilefirstplatform.clientsdk.android.push.api.MFPSimplePushNotification;
import com.ibm.mobilefirstplatform.clientsdk.android.push.api.MFPPushException;
import com.ibm.mobilefirstplatform.clientsdk.android.push.api.MFPPushNotificationListener;
import com.ibm.mobilefirstplatform.clientsdk.android.push.api.MFPPushResponseListener;

import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;
import java.lang.*;

public class CDVBMSPush extends CordovaPlugin {

    private static CallbackContext notificationCallback;

    private static MFPPushNotificationListener notificationListener;

    private static boolean ignoreIncomingNotifications = false;

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
    }

    @Override
    public boolean execute(String action, JSONArray args, final CallbackContext callbackContext) throws JSONException {

        if("initialize".equals(action)) {
             String appGUID = args.getString(0);
             String clientSecret = args.getString(1);
            this.initializePush(appGUID,clientSecret);
            return true;
        }else if("registerDevice".equals(action)) {
            JSONObject settings = args.getJSONObject(0);
            if(!settings.has("userId")){
                this.registerDevice(callbackContext);
            }else{
                String userId = settings.getString("userId");
                this.registerDeviceWithUserId(userId,callbackContext);
            }
            return true;
        } else if("unregisterDevice".equals(action)) {
            this.unregisterDevice(callbackContext);

            return true;
        } else if("retrieveSubscriptions".equals(action)) {
            this.retrieveSubscriptions(callbackContext);

            return true;
        } else if("retrieveAvailableTags".equals(action)) {
            this.retrieveAvailableTags(callbackContext);

            return true;
        } else if ("subscribe".equals(action)) {
            String tag = args.getString(0);
            this.subscribe(tag, callbackContext);

            return true;
        } else if("unsubscribe".equals(action)) {
            String tag = args.getString(0);
            this.unsubscribe(tag, callbackContext);

            return true;
        } else if("registerNotificationsCallback".equals(action)) {
            this.registerNotificationsCallback(callbackContext);
            return true;
        }
        return false;

    }
    /**
     * Initialize the SDK with appGUID and ClientSecret
     * @param appGUID - push service app GUID
     * @param clientSecret - push service clientSecret
     */
    private void initializePush(final String appGUID, final String clientSecret) {
        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                MFPPush.getInstance().initialize(cordova.getActivity().getApplicationContext(),appGUID,clientSecret);
            }
        });
    }

    /**
     * Registers the device for Push notifications with the given alias and consumerId
     * @param callbackContext Javascript callback
     */
    private void registerDevice(final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                MFPPush.getInstance().registerDevice(new MFPPushResponseListener<String>() {
                    @Override
                    public void onSuccess(String s) {

                        String message = s;
                        try {
                            JSONObject responseJson = new JSONObject(s.substring(s.indexOf('{')));
                            JSONObject messageJson = new JSONObject();
                            messageJson.put("token", responseJson.optString("token"));
                            messageJson.put("userId", responseJson.optString("userId"));
                            messageJson.put("deviceId", responseJson.optString("deviceId"));
                            message = messageJson.toString();
                        } catch (JSONException e) {
                            throw new RuntimeException(e);
                        }

                        callbackContext.success(message);
                    }
                    @Override
                    public void onFailure(MFPPushException ex) {
                        callbackContext.error(ex.toString());
                    }
                });
            }
        });

    }
    
    /**
     * Registers the device for Push notifications with the given alias and consumerId
     * @param callbackContext Javascript callback
     */
    private void registerDeviceWithUserId(final String userId, final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                MFPPush.getInstance().registerDeviceWithUserId(userId,new MFPPushResponseListener<String>() {
                    @Override
                    public void onSuccess(String s) {
                        
                        String message = s;
                        try {
                            JSONObject responseJson = new JSONObject(s.substring(s.indexOf('{')));
                            JSONObject messageJson = new JSONObject();
                            messageJson.put("token", responseJson.optString("token"));
                            messageJson.put("userId", responseJson.optString("userId"));
                            messageJson.put("deviceId", responseJson.optString("deviceId"));
                            message = messageJson.toString();
                        } catch (JSONException e) {
                            throw new RuntimeException(e);
                        }
                        callbackContext.success(message);
                    }
                    @Override
                    public void onFailure(MFPPushException ex) {
                        callbackContext.error(ex.toString());
                    }
                });
            }
        });
        
    }

    /**
     * Unregister the device from Push Server
     * @param callbackContext Javascript callback
     */
    private void unregisterDevice(final CallbackContext callbackContext) {

        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                MFPPush.getInstance().unregister(new MFPPushResponseListener<String>() {
                    @Override
                    public void onSuccess(String s) {
                        callbackContext.success(s);
                    }
                    @Override
                    public void onFailure(MFPPushException ex) {
                        callbackContext.error(ex.toString());
                    }
                });
            }
        });

    }

    /**
     * Get the list of available tags that the device can subscribe to
     * @param callbackContext Javascript callback
     */
    private void retrieveAvailableTags(final CallbackContext callbackContext) {

        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                MFPPush.getInstance().getTags(new MFPPushResponseListener<List<String>>() {
                    @Override
                    public void onSuccess(List<String> tags) {
                        callbackContext.success(new JSONArray(tags));
                    }

                    @Override
                    public void onFailure(MFPPushException ex) {
                        callbackContext.error(ex.toString());
                    }
                });
            }
        });

    }

    /**
     * Get the list of tags subscribed to
     * @param callbackContext Javascript callback
     */
    private void retrieveSubscriptions(final CallbackContext callbackContext) {

        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                MFPPush.getInstance().getSubscriptions(new MFPPushResponseListener<List<String>>() {
                    @Override
                    public void onSuccess(List<String> tags) {
                        callbackContext.success(new JSONArray(tags));
                    }

                    @Override
                    public void onFailure(MFPPushException ex) {
                        callbackContext.error(ex.toString());
                    }
                });
            }
        });

    }

    /**
     * Subscribes to the given tag(s)
     * @param tag
     * @param callbackContext Javascript callback
     */
    private void subscribe(final String tag, final CallbackContext callbackContext) {

        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                    MFPPush.getInstance().subscribe(tag, new MFPPushResponseListener<String>() {
                        @Override
                        public void onSuccess(String s) {
                            callbackContext.success(s);
                        }

                        @Override
                        public void onFailure(MFPPushException ex) {
                            callbackContext.error(ex.toString());
                        }
                     });
            }
        });

    }

    /**
     * Unsubscribes to the given tag(s)
     * @param tag
     * @param callbackContext Javascript callback
     */
    private void unsubscribe(final String tag, final CallbackContext callbackContext) {

        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                    MFPPush.getInstance().unsubscribe(tag, new MFPPushResponseListener<String>() {
                        @Override
                        public void onSuccess(String s) {
                            callbackContext.success(s);
                        }

                        @Override
                        public void onFailure(MFPPushException ex) {
                            callbackContext.error(ex.toString());
                        }
                     });
            }
        });

    }

    private void registerNotificationsCallback(final CallbackContext callbackContext) {

        notificationCallback = callbackContext;

        if(!ignoreIncomingNotifications) {

            cordova.getThreadPool().execute(new Runnable() {
                public void run() {
                    notificationListener = new MFPPushNotificationListener() {
                        @Override
                        public void onReceive(final MFPSimplePushNotification message) {
                            try {

                                JSONObject notification = new JSONObject();

                                notification.put("message", message.getAlert());
                                notification.put("payload", message.getPayload());

                                PluginResult result = new PluginResult(PluginResult.Status.OK, notification);
                                result.setKeepCallback(true);
                                notificationCallback.sendPluginResult(result);
                            } catch(JSONException e) {
                                PluginResult result = new PluginResult(PluginResult.Status.ERROR, e.toString());
                                result.setKeepCallback(true);
                                notificationCallback.sendPluginResult(result);
                            }
                        }
                    };

                    MFPPush.getInstance().listen(notificationListener);
                }
            });

        } else {
            callbackContext.error("Error: Called registerNotificationsCallback() after IgnoreIncomingNotifications was set");
        }
    }

    /**
     * Change the plugin's default behavior to ignore handling push notifications
     * @param ignore boolean parameter for the 'ignore notifications' behavior
     */
    public static void setIgnoreIncomingNotifications(boolean ignore) {
        ignoreIncomingNotifications = ignore;

        if(notificationListener != null) {
            if(ignore) {
                MFPPush.getInstance().hold();
            } else {
                MFPPush.getInstance().listen(notificationListener);
            }
        }

    }

    @Override
    public void onResume(boolean multitasking) {
        super.onResume(multitasking);

        if (!ignoreIncomingNotifications && MFPPush.getInstance() != null) {
            MFPPush.getInstance().listen(notificationListener);
        }
    }

    @Override
    public void onPause(boolean multitasking) {
        super.onPause(multitasking);

        if (!ignoreIncomingNotifications && MFPPush.getInstance() != null) {
            MFPPush.getInstance().hold();
        }
    }
}
