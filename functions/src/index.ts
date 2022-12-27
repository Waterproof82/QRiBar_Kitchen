/* //import * as functions from "firebase-functions";
import admin = require("firebase-admin");
import functions = require("firebase-functions");

admin.initializeApp();

const messaging = admin.messaging();

exports.notifySubscribers = functions.https.onCall(async (data, _) => {
    try {
        await messaging.sendToDevice(data.targetDevices, {
            notification: {
                title: data.messageTitle,
                body: data.messageBody
            }
        });

        return true;
    } catch (ex) {
        return false;
    }
}); */
// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
