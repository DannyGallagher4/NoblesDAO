const admin = require('firebase-admin');
const path = require('path');

const serviceAccountPath = process.env.GOOGLE_APPLICATION_CREDENTIALS;
const databaseURL = process.env.FIREBASE_DATABASE_URL;

if (!serviceAccountPath) {
  throw new Error('Set GOOGLE_APPLICATION_CREDENTIALS to your Firebase service-account JSON file.');
}

if (!databaseURL) {
  throw new Error('Set FIREBASE_DATABASE_URL to your Firebase Realtime Database URL.');
}

const serviceAccount = require(path.resolve(serviceAccountPath));

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL,
});

module.exports = admin;
