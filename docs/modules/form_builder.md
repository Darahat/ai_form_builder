adb shell am start -a android.intent.action.VIEW -d "https://darahat.dev/form/a9158081-67e2-41f3-b6af-930ba8f89482" com.example.aiformbuilder

1.  Go to the App Signing page in your Google Play Console.
2.  Copy the SHA-256 certificate fingerprint for your production key.
3.  Add that new fingerprint to the sha256_cert_fingerprints list in your assetlinks.json file on your server.
