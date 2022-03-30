require("dotenv").config()

module.exports = {
  REDIS_HOST: process.env.REDIS_HOST,
  REDIS_PORT: process.env.REDIS_PORT,
  MONGO_URI: process.env.MONGO_URI,
  TOKEN_BASE_URL: process.env.TOKEN_BASE_URL,
  X_AUTH_TOKEN: process.env.X_AUTH_TOKEN,
}