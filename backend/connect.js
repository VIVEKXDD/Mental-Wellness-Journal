const { MongoClient } = require("mongodb");
const uri =
  "mongodb+srv://vivekdhotre07:diZZLdrD0o2syyjz@wellness.litgo.mongodb.net/";
async function main() {
  const client = new MongoClient(uri, {});
  try {
    await client.connect();
    console.log("Connected to MongoDB!");
  } catch (e) {
    console.error(e);
  } finally {
    await client.close();
  }
}

main().catch(console.error);
