const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { createCanvas, loadImage } = require('canvas');

admin.initializeApp();

exports.stitchImages = functions.https.onRequest(async (req, res) => {
  try {
    // Get the image paths from query parameters (comma-separated list)
    const imagePathsQuery = req.query.imagePaths;
    
    if (!imagePathsQuery) {
      return res.status(400).send('No image paths provided.');
    }

    // Split the imagePaths by comma to get an array
    const imagePaths = imagePathsQuery.split(',');

    const bucket = admin.storage().bucket();
    
    // Load images from Firebase Storage
    const images = await Promise.all(imagePaths.map(async (path) => {
      const file = bucket.file(path);
      const [fileBuffer] = await file.download();
      return loadImage(fileBuffer);
    }));

    // Calculate total width and max height for the resulting image
    const totalWidth = images.reduce((sum, img) => sum + img.width, 0);
    const maxHeight = Math.max(...images.map(img => img.height));

    // Create a canvas to draw the images
    const canvas = createCanvas(totalWidth, maxHeight);
    const ctx = canvas.getContext('2d');

    // Draw each image side by side
    let currentX = 0;
    images.forEach(img => {
      ctx.drawImage(img, currentX, 0);
      currentX += img.width;
    });

    // Convert the canvas to a buffer and set response headers
    const finalImageBuffer = canvas.toBuffer('image/png');
    res.setHeader('Content-Type', 'image/png');
    res.status(200).send(finalImageBuffer);

  } catch (error) {
    console.error('Error stitching images:', error);
    res.status(500).send('Error processing images.');
  }
});
