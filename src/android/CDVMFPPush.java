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

import com.ibm.mobilefirstplatform.clientsdk.android.logger.api.Logger;
import com.ibm.mobilefirstplatform.clientsdk.android.push.api.MFPPush;
import com.ibm.mobilefirstplatform.clientsdk.android.push.api.MFPSimplePushNotification;
import com.ibm.mobilefirstplatform.clientsdk.android.push.api.MFPPushException;
import com.ibm.mobilefirstplatform.clientsdk.android.push.api.MFPPushNotificationListener;
import com.ibm.mobilefirstplatform.clientsdk.android.push.api.MFPPushResponseListener;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;

public class CDVMFPPush extends CordovaPlugin {

    private static final Logger pushLogger = Logger.getInstance("CDVMFPPush");

    private static CallbackContext notificationCallback;

    private static MFPPushNotificationListener notificationListener;

    private static boolean ignoreIncomingNotifications = false;

    @Override
    public boolean execute(String action, JSONArray args, final CallbackContext callbackContext) throws JSONException {
        pushLogger.debug("execute() : action = " + action);

        if ("registerDevice".equals(action)) {
            this.registerDevice(callbackContext);

            return true;
        } else if ("unregisterDevice".equals(action)) {
            this.unregisterDevice(callbackContext);

            return true;
        } else if ("retrieveSubscriptions".equals(action)) {
            this.retrieveSubscriptions(callbackContext);

            return true;
        } else if ("retrieveAvailableTags".equals(action)) {
            this.retrieveAvailableTags(callbackContext);

            return true;
        } else if ("subscribe".equals(action)) {
            String tag = args.getString(0);
            this.subscribe(tag, callbackContext);

            return true;
        } else if ("unsubscribe".equals(action)) {
            String tag = args.getString(0);
            this.unsubscribe(tag, callbackContext);

            return true;
        } else if ("registerNotificationsCallback".equals(action)) {
            this.registerNotificationsCallback(callbackContext);

            return true;
        }
        return false;
    }

    /**
     * Registers the device for Push notifications with the given alias and consumerId
     * @param callbackContext Javascript callback
     */
    private void registerDevice(final CallbackContext callbackContext) {
        MFPPush.getInstance().initialize(this.cordova.getActivity().getApplicationContext());

        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                MFPPush.getInstance().register(new MFPPushResponseListener<String>() {
                    @Override
                    public void onSuccess(String s) {
                        pushLogger.debug("registerDevice() Success : " + s);
                        callbackContext.success(s);
                    }
                    @Override
                    public void onFailure(MFPPushException ex) {
                        pushLogger.debug("registerDevice() Error : " + ex.toString());
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
        pushLogger.debug("In unregisterDevice");

        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                MFPPush.getInstance().unregister(new MFPPushResponseListener<String>() {
                    @Override
                    public void onSuccess(String s) {
                        pushLogger.debug("unregisterDevice() Success : " + s);
                        callbackContext.success(s);
                    }
                    @Override
                    public void onFailure(MFPPushException ex) {
                        pushLogger.debug("unregisterDevice() Error : " + ex.toString());
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
        pushLogger.debug("In retrieveAvailableTags");

        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                MFPPush.getInstance().getTags(new MFPPushResponseListener<List<String>>() {
                    @Override
                    public void onSuccess(List<String> tags) {
                        pushLogger.debug("retrieveAvailableTags() Success : " + tags);
                        callbackContext.success(new JSONArray(tags));
                    }

                    @Override
                    public void onFailure(MFPPushException ex) {
                        pushLogger.debug("retrieveAvailableTags() Error : " + ex.toString());
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
        pushLogger.debug("In unsubscribe");

        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                MFPPush.getInstance().getSubscriptions(new MFPPushResponseListener<List<String>>() {
                    @Override
                    public void onSuccess(List<String> tags) {
                        pushLogger.debug("retrieveSubscriptions() Success : " + tags);
                        callbackContext.success(new JSONArray(tags));
                    }

                    @Override
                    public void onFailure(MFPPushException ex) {
                        pushLogger.debug("retrieveSubscriptions() Error : " + ex.toString());
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
        pushLogger.debug("In subscribe");

        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                    MFPPush.getInstance().subscribe(tag, new MFPPushResponseListener<String>() {
                        @Override
                        public void onSuccess(String s) {
                            pushLogger.debug("subscribe() Success : " + s);
                            callbackContext.success(s);
                        }

                        @Override
                        public void onFailure(MFPPushException ex) {
                            pushLogger.debug("subscribe() Error : " + ex.toString());
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
        pushLogger.debug("In unsubscribe");

        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                    MFPPush.getInstance().unsubscribe(tag, new MFPPushResponseListener<String>() {
                        @Override
                        public void onSuccess(String s) {
                            pushLogger.debug("unsubscribe() Success : " + s);
                            callbackContext.success(s);
                        }

                        @Override
                        public void onFailure(MFPPushException ex) {
                            pushLogger.debug("unsubscribe() Error : " + ex.toString());
                            callbackContext.error(ex.toString());
                        }
                     });
            }
        });

    }

    private void registerNotificationsCallback(final CallbackContext callbackContext) {
        pushLogger.debug("In registerNotificationsCallback");

        notificationCallback = callbackContext;

        if(!ignoreIncomingNotifications) {

            cordova.getThreadPool().execute(new Runnable() {
                public void run() {
                    notificationListener = new MFPPushNotificationListener() {
                        @Override
                        public void onReceive(final MFPSimplePushNotification message) {
                            try {
                                pushLogger.debug("Push notification received: " + message.toString());

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
            pushLogger.warn("Notification handling is currently off. Turn it back on by calling setIgnoreIncomingNotifications(true)");
            callbackContext.error("Error: Called registerNotificationsCallback() after IgnoreIncomingNotifications was set");
        }
    }

    /**
     * Change the plugin's default behavior to ignore handling push notifications
     * @param ignore boolean parameter for the 'ignore notifications' behavior
     */
    public static void setIgnoreIncomingNotifications(boolean ignore) {
        pushLogger.debug("In setIgnoreIncomingNotifications : ignore = " + ignore);
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
        pushLogger.debug("In onResume");

        if (!ignoreIncomingNotifications && MFPPush.getInstance() != null) {
            MFPPush.getInstance().listen(notificationListener);
        }
    }

    @Override
    public void onPause(boolean multitasking) {
        super.onPause(multitasking);
        pushLogger.debug("In onPause");

        if (!ignoreIncomingNotifications && MFPPush.getInstance() != null) {
            MFPPush.getInstance().hold();
        }
    }

}