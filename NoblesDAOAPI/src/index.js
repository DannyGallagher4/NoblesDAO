const express = require('express');
const axios = require('axios');
const admin = require('./firebaseAdmin');

const app = express();
app.use(express.json());

const FIREBASE_API_KEY = process.env.FIREBASE_API_KEY;

if (!FIREBASE_API_KEY) {
  throw new Error('Set FIREBASE_API_KEY to your Firebase Web API key.');
}

app.post('/create_account', async (req, res) => {
  const { email, password } = req.body;
  try {
    const userRecord = await admin.auth().createUser({
      email: email,
      password: password
    });

    // Generate a random number between 1 and 1000
    const randomValue = Math.floor(Math.random() * 1000) + 1;

    // Get a reference to the Realtime Database
    const databaseRef = admin.database().ref();

    // Create a new entry in the 'users' child with the user's UID
    await databaseRef.child('users').child(userRecord.uid).set({
      random_value: randomValue
    });

    res.send({ userId: userRecord.uid });
  } catch (error) {
    res.status(500).send({ error: error.message });
  }
});

app.post('/login', async (req, res) => {
    const { email, password } = req.body;
    const params = new URLSearchParams();
    params.append('email', email);
    params.append('password', password);
    params.append('returnSecureToken', true);
  
    try {
      const response = await axios.post(`https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${FIREBASE_API_KEY}`, params);
      const { localId } = response.data; // `localId` is the user ID in Firebase
      res.send({ userId: localId });
    } catch (error) {
      if (error.response && error.response.data && error.response.data.error) {
        res.status(400).send({ error: error.response.data.error.message });
      } else {
        res.status(500).send({ error: 'Internal server error' });
      }
    }
  });

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
