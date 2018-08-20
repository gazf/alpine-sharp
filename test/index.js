const sharp = require('sharp');

sharp({
  create: {
    width: 300,
    height: 200,
    channels: 4,
    background: { r: 255, g: 0, b: 0, alpha: 128 }
  }
}).png();
