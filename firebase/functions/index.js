/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

exports.helloWorld = onRequest((request, response) => {
  logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});

exports.generatePseudoRandomPermutation = functions.https.onRequest((req, res) => {
    const N = 100;  // Set N, change as needed
    const seed = parseInt(req.query.seed) || Date.now();  // Use provided seed or fallback to current time

    let permutation = Array.from({ length: N }, (_, i) => i);  // Generate array [0, 1, 2, ..., N-1]
    shuffle(permutation, seed);

    res.json({ permutation });
});

function shuffle(array, seed) {
    let randomSeed = seed;
    for (let i = array.length - 1; i > 0; i--) {
        let j = random(randomSeed, i + 1);
        [array[i], array[j]] = [array[j], array[i]];  // Swap elements
        randomSeed = hash(randomSeed + i);  // Update seed
    }
}

function random(seed, upperBound) {
    return Math.floor(hash(seed) % upperBound);
}

function hash(seed) {
    // Simple hash function using JavaScript built-in functions (you can replace it with something better)
    const x = Math.sin(seed) * 10000;
    return x - Math.floor(x);
}
