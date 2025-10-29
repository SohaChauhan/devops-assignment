const fs = require("fs");
const path = require("path");

// Environment file configurations
const envFiles = [
  {
    path: "backend/user-service/.env",
    content: `PORT=3001
MONGODB_URI=mongodb://localhost:27017/user-service
JWT_SECRET=your-secret-key-change-this-in-production-${Math.random()
      .toString(36)
      .substring(7)}
JWT_EXPIRE=7d`,
  },
  {
    path: "backend/product-service/.env",
    content: `PORT=3002
MONGODB_URI=mongodb://localhost:27017/product-service`,
  },
  {
    path: "backend/order-service/.env",
    content: `PORT=3003
MONGODB_URI=mongodb://localhost:27017/order-service
PRODUCT_SERVICE_URL=http://localhost:3002`,
  },
];

console.log("🚀 Creating environment files...\n");

envFiles.forEach((file) => {
  const filePath = path.join(__dirname, file.path);
  const dir = path.dirname(filePath);

  // Create directory if it doesn't exist
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }

  // Check if file already exists
  if (fs.existsSync(filePath)) {
    console.log(`⚠️  ${file.path} already exists. Skipping...`);
  } else {
    fs.writeFileSync(filePath, file.content);
    console.log(`✅ Created ${file.path}`);
  }
});

console.log("\n✨ Environment files setup complete!");
console.log("\n📝 Next steps:");
console.log("1. Review the .env files and update values if needed");
console.log("2. Make sure MongoDB is running");
console.log('3. Run "npm run install-all" to install dependencies');
console.log('4. Run "npm run dev" to start all services\n');
