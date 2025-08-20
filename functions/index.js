const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendChatNotification = onDocumentCreated(
    "chats/{chatId}/messages/{messageId}",
    async (event) => {
      console.log("1. Function triggered.");
      try {
        const snap = event.data;
        if (!snap) {
          console.log("2. ERROR: No data found in Firestore event. Exiting.");
          return;
        }
        console.log("2. Event data found.");

        const message = snap.data();
        const chatId = event.params.chatId;
        console.log("3. Extracted message and chat ID.", {chatId});

        const recipientId = message.receiverId;
        if (!recipientId) {
          console.log("4. ERROR: No recipientId in message. Exiting.");
          return;
        }
        console.log("4. Found recipientId:", recipientId);

        const recipientDoc = await admin.firestore()
            .collection("users").doc(recipientId).get();
        if (!recipientDoc.exists) {
          console.log("5. ERROR: Recipient document does not exist. Exiting.");
          return;
        }
        console.log("5. Recipient document found.", recipientDoc.data);

        const fcmTokens = recipientDoc.data().fcmTokens || [];
        if (!fcmTokens.length) {
          console.log("6. No FCM tokens for recipient. Exiting.");
          return;
        }
        console.log("6. Found FCM tokens:", fcmTokens);

        const senderId = message.senderId;
        const senderDoc = await admin.firestore()
            .collection("users").doc(senderId).get();
        const senderName = senderDoc.exists ?
                (senderDoc.data().firstName || "New message") : "New message";
        console.log("7. Determined sender name:", senderName);

        const payload = {
          notification: {
            title: `New Message from ${senderName}`,
            body: message.chatTextBody || "You have a new message",
          },
          data: {
            chatId: chatId,
            type: "chat",
            senderId: senderId,
          },
        };
        console.log("8. Constructed notification payload.", {payload});

        const response = await admin.messaging().sendEachForMulticast({
          tokens: fcmTokens,
          notification: payload.notification,
          data: payload.data,
          android: {
            notification: {
              sound: "default",
            },
          },
          apns: {
            payload: {
              aps: {
                sound: "default",
              },
            },
          },
        });

        console.log(`9. Notification sent. Success: 
          ${response.successCount}, Failure: ${response.failureCount}`);
        if (response.failureCount > 0) {
          response.responses.forEach((resp, idx) => {
            if (!resp.success) {
              console.log(`Failed to send to token: 
                ${fcmTokens[idx]}, error: ${resp.error}`);
            }
          });
        }
      } catch (error) {
        console.error("An unexpected error occurred:", error);
      }
    },
);
