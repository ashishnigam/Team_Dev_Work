/**
 * This file was auto-generated by the Titanium Module SDK helper for Android
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2010 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 *
 */
package com.ashish.cardioandroid;

import io.card.payment.CardIOActivity;
import io.card.payment.CreditCard;

import java.util.HashMap;

import org.appcelerator.kroll.KrollDict;
import org.appcelerator.kroll.KrollFunction;
import org.appcelerator.kroll.KrollProxy;
import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.kroll.common.Log;
import org.appcelerator.kroll.common.TiConfig;
import org.appcelerator.titanium.TiApplication;
import org.appcelerator.titanium.util.TiActivityResultHandler;
import org.appcelerator.titanium.util.TiActivitySupport;
import org.appcelerator.titanium.util.TiConvert;
import org.appcelerator.titanium.util.TiIntentWrapper;

import android.app.Activity;
import android.content.Intent;

// This proxy can be created by calling CodestrongAndroid.createExample({message: "hello world"})
@Kroll.proxy(creatableInModule = CardioandroidModule.class)
public class CardioProxy extends KrollProxy implements TiActivityResultHandler {
	// Standard Debugging variables
	final String LCAT = getClass().getName();;
	private int MY_SCAN_REQUEST_CODE = 100; // arbitrary int

	protected KrollFunction successCallback = null;
	protected KrollFunction cancelCallback = null;
	protected KrollFunction cancelCallbackOnCancel = null;
	protected int thisRequestCode;

	// Constructor
	public CardioProxy() {
		super();
	}

	private void onCreate() {
		// TODO Auto-generated method stub
		Log.i(LCAT, "inside CardIOProxy onCreate");
	}

	public CardioProxy create(KrollDict options) {
		Log.i(LCAT, "inside_CardIOProxy_create" + options);
		return this;
	}

	// Handle creation options
	@Override
	public void handleCreationDict(KrollDict options) {
		Log.i(LCAT, "inside_handleCreationDict_create" + options);
		super.handleCreationDict(options);
	}

	// Methods
	private KrollFunction getCallback(final KrollDict options, final String name)
			throws Exception {
		Object callback = options.get(name);
		if ((callback != null) && (callback instanceof KrollFunction)) {
			return (KrollFunction) callback;
		} else {
			Log.i(LCAT, "Callback not found: " + name);
			throw new Exception("Callback not found: " + name);
		}
	}

	/**
	 * main method for the module to return the users lat lng information from
	 * the skyhook api service
	 * 
	 * @param args
	 * @throws Exception
	 */
	@SuppressWarnings("deprecation")
	@Kroll.method(runOnUiThread = true)
	public void doScan(HashMap args) throws Exception {
		// Log.i(LCAT, "inside CardIOProxy doScan");
		// Log.i(LCAT, "ashish test doscan");
		final KrollProxy that = this;
		// set up the callbacks for when the scan is completed
		KrollDict options = new KrollDict(args);
		successCallback = getCallback(options, "success");
		cancelCallback = getCallback(options, "error");
		cancelCallbackOnCancel = getCallback(options, "error");

		// Log.i(LCAT, "ashish callback" + successCallback.toString());
		// Log.i(LCAT, "ashish callback" + cancelCallback.toString());

		Activity activity = TiApplication.getInstance().getCurrentActivity();// this.getActivity();
		final TiActivitySupport activitySupport = (TiActivitySupport) activity;

		Intent scanIntent = new Intent(activity, CardIOActivity.class);
		// customize these values to suit your needs.
		scanIntent.putExtra(CardIOActivity.EXTRA_REQUIRE_EXPIRY,
				TiConvert.toBoolean(getProperty("REQUIRE_EXPIRY")));
		// default:true
		scanIntent.putExtra(CardIOActivity.EXTRA_REQUIRE_CVV,
				TiConvert.toBoolean(getProperty("REQUIRE_CVV")));
		// default: false
		scanIntent.putExtra(CardIOActivity.EXTRA_REQUIRE_POSTAL_CODE,
				TiConvert.toBoolean(getProperty("REQUIRE_ZIP")));// default:

		scanIntent.putExtra(CardIOActivity.EXTRA_SUPPRESS_MANUAL_ENTRY,
				TiConvert.toBoolean(getProperty("SUPPRESS_MANUAL_ENTRY")));
		
		scanIntent.putExtra(CardIOActivity.EXTRA_KEEP_APPLICATION_THEME,
				TiConvert.toBoolean(getProperty("KEEP_APPLICATION_THEME")));

		// Log.i(LCAT, "ashish activitySupport" + activitySupport.toString());
		thisRequestCode = activitySupport.getUniqueResultCode();
		activitySupport.launchActivityForResult(scanIntent, thisRequestCode,
				this);
	}

	@Override
	public void onError(Activity activity, int requestCode, Exception e) {
		String msg = "Problem with scanner; " + e.getMessage();
		Log.i(LCAT, "inside CardIOResultHandler onError " + msg);
		HashMap<String, String> callbackDict = new HashMap<String, String>();
		callbackDict.put("error", "true");
		callbackDict.put("message", msg);
		if (cancelCallback != null) {
			cancelCallback.callAsync(getKrollObject(), callbackDict);
		}
	}

	@Override
	public void onResult(Activity activity, int requestCode, int resultCode,
			Intent data) {
		Log.i(LCAT, "ashish_onResult requC = " + requestCode + " resultc = "
				+ resultCode);
		if (requestCode != thisRequestCode) {
			return;

		}
		// fireEvent("propertyChange", requestCode);
		String resultStr;
		HashMap<String, String> callbackDict = new HashMap<String, String>();
		Log.i(LCAT, "ashish onResult" + requestCode);
		// process the results
		if (data != null && data.hasExtra(CardIOActivity.EXTRA_SCAN_RESULT)) {
			CreditCard scanResult = data
					.getParcelableExtra(CardIOActivity.EXTRA_SCAN_RESULT);

			// Never log a raw card number. Avoid displaying it, but if
			// necessary use getFormattedCardNumber()
			resultStr = "Card Number: " + scanResult.getRedactedCardNumber()
					+ "\n";

			// Do something with the raw number, e.g.:
			// myService.setCardNumber( scanResult.cardNumber );

			if (scanResult.isExpiryValid()) {
				resultStr += "Expiration Date: " + scanResult.expiryMonth + "/"
						+ scanResult.expiryYear + "\n";
			}

			if (scanResult.cvv != null) {
				// Never log or display a CVV
				resultStr += "CVV has " + scanResult.cvv + "\n";
			}

			if (scanResult.postalCode != null) {
				resultStr += "Zip: " + scanResult.postalCode + "\n";
			}

			// get all of the data in a hash for returning
			callbackDict.put("success", "true");
			callbackDict
					.put("cvv", (scanResult.cvv != null ? "true" : "false"));
			callbackDict.put("expiryMonth",
					(scanResult.expiryMonth != 0 ? scanResult.expiryMonth + ""
							: null));
			callbackDict.put("zip",
					(scanResult.postalCode != null ? scanResult.postalCode
							: null));
			callbackDict.put("expiryYear",
					(scanResult.expiryYear != 0 ? scanResult.expiryYear + ""
							: null));
			callbackDict.put(
					"redactedCard",
					(scanResult.getRedactedCardNumber() != null ? scanResult
							.getRedactedCardNumber() : null));
			callbackDict.put(
					"formattedCard",
					(scanResult.getFormattedCardNumber() != null ? scanResult
							.getFormattedCardNumber() : null));
			// callback if necessary and just log the error
			if (successCallback != null) {
				successCallback.callAsync(getKrollObject(), callbackDict);
			}

		} else {
			resultStr = "Scan was canceled.";

			callbackDict.put("success", "false");
			callbackDict.put("cancelled", resultStr);

			// callback if necessary and just log the error
			if (cancelCallback != null) {
				cancelCallback.callAsync(getKrollObject(), callbackDict);
			}

		}
		Log.i(LCAT, "Scan results: " + resultStr);
	}
}