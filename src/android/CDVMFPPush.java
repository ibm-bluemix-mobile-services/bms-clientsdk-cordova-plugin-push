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
    private static final MFPPush pushInstance = MFPPush.getInstance();

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        MFPPush.getInstance().initialize(this.cordova.getActivity().getApplicationContext());
        pushLogger.debug("In execute");

        if ("register".equals(action)) {
            pushLogger.debug("Registering device");
            MFPPush.getInstance().initialize(this.cordova.getActivity().getApplicationContext());
            this.register(callbackContext);

            return true;
        } else if ("unregister".equals(action)) {
            pushLogger.debug("Unregistering device");
            this.unregister(callbackContext);

            return true;
        } else if ("getSubscriptionStatus".equals(action)) {
            pushLogger.debug("getSubscriptionStatus");
            this.getSubscriptionStatus(callbackContext);

            return true;
        } else if ("retrieveAvailableTags".equals(action)) {
            pushLogger.debug("retrieveAvailableTags");
            this.retrieveAvailableTags(callbackContext);

            return true;
        } else if ("subscribe".equals(action)) {
            pushLogger.debug("subscribe");
            final List<String> tagsList = convertJSONArrayToList(args.getJSONArray(0));
            this.subscribe(tagsList, callbackContext);

            return true;
        } else if ("unsubscribe".equals(action)) {
            pushLogger.debug("unsubscribe");
            final List<String> tagsList = convertJSONArrayToList(args.getJSONArray(0));
            this.unsubscribe(tagsList, callbackContext);

            return true;
        } else if ("registerIncomingNotificationListener".equals(action)) {

            return true;
        }
        return false;
    }

    private void register(final CallbackContext callbackContext) {
        pushInstance.register(new MFPPushResponseListener<String>() {
            @Override
            public void onSuccess(String s) {
                pushLogger.debug("register() Successfully registered");
            }
            @Override
            public void onFailure(MFPPushException e) {
                pushLogger.debug("register() ERROR registering device");
            }
        });
    }

    private void unregister(final CallbackContext callbackContext) {
        pushInstance.unregisterDevice(new MFPPushResponseListener<String>() {
            @Override
            public void onSuccess(String s) {
                pushLogger.debug("unregister() Successfully unregistered");
            }
            @Override
            public void onFailure(MFPPushException e) {
                pushLogger.debug("unregister() ERROR unregistering device");
            }
        });
    }

    private void retrieveAvailableTags(final CallbackContext callbackContext) {
        pushInstance.getTags(new MFPPushResponseListener<List<String>>() {
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

    private void getSubscriptionStatus(final CallbackContext callbackContext) {
        pushInstance.getSubscriptions(new MFPPushResponseListener<List<String>>() {
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

    private void subscribe(final List<String> tagsList, final CallbackContext callbackContext) {
        for(final String individualTag : tagsList) {
            pushInstance.subscribe(individualTag, new MFPPushResponseListener<String>() {
                @Override
                public void onSuccess(String s) {
                    pushLogger.debug("subscribe() Success: Subscribed to " + individualTag);
                }

                @Override
                public void onFailure(MFPPushException ex) {
                    pushLogger.debug("subscribe() Error: Unable to subscribe to " + individualTag);
                    callbackContext.error(ex.toString());
                }
             });
        }
    }

    private void unsubscribe(final List<String> tagsList, final CallbackContext callbackContext) {
        for(final String individualTag : tagsList) {
            pushInstance.unsubscribe(individualTag, new MFPPushResponseListener<String>() {
                @Override
                public void onSuccess(String s) {
                    pushLogger.debug("subscribe() Success: Subscribed to " + individualTag);
                }

                @Override
                public void onFailure(MFPPushException ex) {
                    pushLogger.debug("subscribe() Error: Unable to subscribe to " + individualTag);
                    callbackContext.error(ex.toString());
                }
             });
        }
    }

    /**
     * Convert a JSONArray to a List
     * @param args JSONArray that contains the backendRoute and backendGUID
     * @param callbackContext
     */
    private static List<String> convertJSONArrayToList(JSONArray tagsList) throws JSONException {
        List<String> convertedList = new ArrayList<String>();
        for(int i=0; i < tagsList.length(); i++) {
            convertedList.add(tagsList.getString(i));
        }
        return convertedList;
    }

}
