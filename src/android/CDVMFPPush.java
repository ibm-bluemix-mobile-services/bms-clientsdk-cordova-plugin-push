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
import com.ibm.mobilefirstplatform.clientsdk.android.push.api.MFPPushException;
import com.ibm.mobilefirstplatform.clientsdk.android.push.api.MFPPushNotificationListener;
import com.ibm.mobilefirstplatform.clientsdk.android.push.api.MFPPushResponseListener;
import com.ibm.mobilefirstplatform.clientsdk.android.push.api.MFPSimplePushNotification;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;
import java.util.ArrayList;

public class CDVMFPPush extends CordovaPlugin {

    private static String TAG = "CDVMFPPush";
    private static final Logger pushLogger = Logger.getInstance("CDVMFPPush");

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        pushLogger.debug("execute() : action() " + action);

        if ("register".equals(action)) {
            MFPPush.getInstance().initialize(this.cordova.getActivity().getApplicationContext());
            this.register(callbackContext);

            return true;
        } else if ("unregister".equals(action)) {
            this.unregister(callbackContext);

            return true;
        } else if ("retrieveSubscriptionStatus".equals(action)) {
            this.retrieveSubscriptionStatus(callbackContext);

            return true;
        } else if ("retrieveAvailableTags".equals(action)) {
            this.retrieveAvailableTags(callbackContext);

            return true;
        } else if ("subscribeToTag".equals(action)) {
            String tag = args.getString(0);
            this.subscribeToTag(tag, callbackContext);

            return true;
        } else if ("unsubscribeFromTag".equals(action)) {
            String tag = args.getString(0);
            this.unsubscribeFromTag(tag, callbackContext);

            return true;
        } else if ("registerIncomingNotificationListener".equals(action)) {
            this.registerIncomingNotificationListener(callbackContext);

            return true;
        }
        return false;
    }

    private void registerIncomingNotificationListener(final CallbackContext callbackContext) {
        pushLogger.debug("registerIncomingNotificationListener");
        /*
        MFPPush.getInstance().listen(new MFPPushNotificationListener() {
            @Override
            public void onReceive(MFPSimplePushNotification mfpSimplePushNotification) {
                pushLogger.debug("mfpSimplePushNotification.toString()" + mfpSimplePushNotification.toString());
                callbackContext.success("listener Received a message");
            }
        });
        */
    }

    /**
     * Registers the device for Push notifications with the given alias and consumerId
     * @param callbackContext Javascript callback
     */
    private void register(final CallbackContext callbackContext) {

        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                MFPPush.getInstance().register(new MFPPushResponseListener<String>() {
                    @Override
                    public void onSuccess(String s) {
                        pushLogger.debug("register() Success : " + s);
                        callbackContext.success();
                    }
                    @Override
                    public void onFailure(MFPPushException ex) {
                        pushLogger.debug("register() Error : " + ex.toString());
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
    private void unregister(final CallbackContext callbackContext) {

        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                MFPPush.getInstance().unregister(new MFPPushResponseListener<String>() {
                    @Override
                    public void onSuccess(String s) {
                        pushLogger.debug("unregister() Success : " + s);
                        callbackContext.success(s);
                    }
                    @Override
                    public void onFailure(MFPPushException ex) {
                        pushLogger.debug("unregister() Error : " + ex.toString());
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
    private void retrieveSubscriptionStatus(final CallbackContext callbackContext) {

        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                MFPPush.getInstance().getSubscriptions(new MFPPushResponseListener<List<String>>() {
                    @Override
                    public void onSuccess(List<String> tags) {
                        pushLogger.debug("getSubscriptionStatus() Success : " + tags);
                        callbackContext.success(new JSONArray(tags));
                    }

                    @Override
                    public void onFailure(MFPPushException ex) {
                        pushLogger.debug("getSubscriptionStatus() Error : " + ex.toString());
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
    private void subscribeToTag(final String tag, final CallbackContext callbackContext) {

        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                    MFPPush.getInstance().subscribe(tag, new MFPPushResponseListener<String>() {
                        @Override
                        public void onSuccess(String s) {
                            pushLogger.debug("subscribeToTag() Success : " + s);
                            callbackContext.success(s);
                        }

                        @Override
                        public void onFailure(MFPPushException ex) {
                            pushLogger.debug("subscribeToTag() Error : " + ex.toString());
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
    private void unsubscribeFromTag(final String tag, final CallbackContext callbackContext) {

        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                    MFPPush.getInstance().unsubscribe(tag, new MFPPushResponseListener<String>() {
                        @Override
                        public void onSuccess(String s) {
                            pushLogger.debug("unsubscribeFromTags() Success : " + s);
                            callbackContext.success(s);
                        }

                        @Override
                        public void onFailure(MFPPushException ex) {
                            pushLogger.debug("unsubscribeFromTags() Error : " + ex.toString());
                            callbackContext.error(ex.toString());
                        }
                     });
            }
        });

    }

    private static List<String> convertJSONArrayToList(JSONArray tagsList) throws JSONException {
        List<String> convertedList = new ArrayList<String>();
        for(int i=0; i < tagsList.length(); i++) {
            convertedList.add(tagsList.getString(i));
        }
        return convertedList;
    }

}
