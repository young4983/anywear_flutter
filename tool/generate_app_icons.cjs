// Regenerate launcher icons from assets/branding. Requires Node.js and sharp.
const fs = require('node:fs');
const path = require('node:path');
const sharp = require('sharp');

const root = path.resolve(__dirname, '..');
const background = fs.readFileSync(path.join(root, 'assets/branding/app_icon_background.svg'));
const foreground = fs.readFileSync(path.join(root, 'assets/branding/app_icon_foreground.svg'));
const iosDir = path.join(root, 'ios/Runner/Assets.xcassets/AppIcon.appiconset');
const androidRes = path.join(root, 'android/app/src/main/res');

async function render(source, size, file, opaque = false) {
  let image = sharp(source).resize(size, size);
  if (opaque) image = image.removeAlpha();
  await image.png().toFile(file);
}

async function main() {
  const fullIcon = await sharp(background)
    .composite([{ input: foreground }])
    .png()
    .toBuffer();
  const catalog = JSON.parse(fs.readFileSync(path.join(iosDir, 'Contents.json'), 'utf8'));
  const outputs = new Map();
  for (const item of catalog.images) {
    if (!item.filename) continue;
    const size = Number(item.size.split('x')[0]) * Number(item.scale.replace('x', ''));
    outputs.set(item.filename, size);
  }
  for (const [filename, size] of outputs) {
    await render(fullIcon, size, path.join(iosDir, filename), true);
  }
  for (const [density, factor] of [['mdpi', 1], ['hdpi', 1.5], ['xhdpi', 2], ['xxhdpi', 3], ['xxxhdpi', 4]]) {
    const dir = path.join(androidRes, `mipmap-${density}`);
    fs.mkdirSync(dir, { recursive: true });
    await render(fullIcon, 48 * factor, path.join(dir, 'ic_launcher.png'), true);
    await render(background, 108 * factor, path.join(dir, 'ic_launcher_background.png'), true);
    await render(foreground, 108 * factor, path.join(dir, 'ic_launcher_foreground.png'));
  }
  console.log(`Generated ${outputs.size} iOS images and Android icons for five densities.`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
