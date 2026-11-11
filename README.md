# NoblesDAO

This repository contains the NoblesDAO Solidity contracts, Firebase-backed API,
and React client. The Firebase credentials are intentionally not included.

## Requirements

- Node.js 18 or newer and npm
- A Firebase project with Email/Password Authentication and Realtime Database
  enabled, to use account creation and login
- A local Ethereum development chain only if you are compiling or deploying the
  Solidity contracts

## Run the API and client locally

1. Clone this repository and open a terminal in its root directory.
2. Obtain a Firebase service-account JSON file and keep it outside this
   repository. Find the Firebase Web API key in the Firebase project settings
   and the Realtime Database URL in the Database console.
3. In PowerShell, configure the API environment and start it:

   ```powershell
   $env:GOOGLE_APPLICATION_CREDENTIALS = "C:\secure\firebase-service-account.json"
   $env:FIREBASE_API_KEY = "your-firebase-web-api-key"
   $env:FIREBASE_DATABASE_URL = "https://your-project-default-rtdb.firebaseio.com/"
   $env:PORT = "3001"
   cd .\NoblesDAOAPI
   npm ci
   npm start
   ```

   Keep this terminal running. Do not commit the service-account JSON, API key,
   or any local `.env` files.

4. Open a second terminal at the repository root and start the client:

   ```powershell
   cd .\NoblesDAOClient
   npm ci
   npm start
   ```

   The client opens at <http://localhost:3000>. During local development its
   configured proxy sends API requests to <http://localhost:3001>. To use a
   separately hosted API instead, set `REACT_APP_API_BASE_URL` before starting
   the client.

The included API currently implements account creation (`POST /create_account`)
and login (`POST /login`). Poll-list, poll-creation, poll-detail, and voting
endpoints used by some client pages are not implemented in this repository yet;
those features therefore require additional API/contract integration.

## Solidity contracts

The contracts are in [`NoblesDAO/`](./NoblesDAO), with the parser dependency in
[`NoblesDAO/jsmnSol/`](./NoblesDAO/jsmnSol). They are included as source; this
repository does not yet have a verified contract compile/deploy workflow, and
the current API does not deploy or call them. `NoblesStorage` assigns the
deploying account as its initial admin. Use only a local/test chain until the
contracts and access-control behavior have been reviewed.

## Repository contents

- [`NoblesDAO/`](./NoblesDAO): Solidity contracts and parser dependency
- [`NoblesDAOAPI/`](./NoblesDAOAPI): Express API
- [`NoblesDAOClient/`](./NoblesDAOClient): React client
