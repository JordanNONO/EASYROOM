const fs = require("fs");
const path = require("path");
const sharp = require("sharp");
const toIco = require("to-ico");

const svg = `
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
  <rect width="100" height="100" fill="#FAF7F1"/>
  <path d="M50 8 L84 38 L82 38 L18 38 L16 38 Z" fill="#17233A"/>
  <rect x="30" y="34" width="40" height="8" fill="#17233A"/>
  <rect x="24" y="42" width="52" height="46" rx="3" fill="#17233A"/>
  <rect x="43" y="61" width="14" height="27" rx="2" fill="#A9722F"/>
</svg>
`;

const publicDir = path.join(__dirname, "..", "public");

async function main() {
	const sizes = [16, 32, 48, 64, 180, 192, 512];
	const buffers = {};
	for (const size of sizes) {
		buffers[size] = await sharp(Buffer.from(svg)).resize(size, size).png().toBuffer();
	}

	const icoBuffer = await toIco([buffers[16], buffers[32], buffers[48]]);
	fs.writeFileSync(path.join(publicDir, "favicon.ico"), icoBuffer);
	fs.writeFileSync(path.join(publicDir, "apple-touch-icon.png"), buffers[180]);
	fs.writeFileSync(path.join(publicDir, "icon-192.png"), buffers[192]);
	fs.writeFileSync(path.join(publicDir, "icon-512.png"), buffers[512]);

	console.log("Favicon assets generated.");
}

main();
