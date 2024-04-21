const fs = require("fs");
const path = require("path");
const xml2js = require("xml2js");

// async function modifyMainActivity(newPackageName) {const mainActivityPath = path.join("Recovery", "android", "app", "src", "main", "kotlin", "com", "starkin", "recovery_app", "recovery_app", "MainActivity.kt");try {let mainActivityData = await fs.promises.readFile(mainActivityPath, "utf8");const packageRegex = /package\s+com\.starkin\.recovery_app\.recovery_app/;const newPackageLine = `package ${newPackageName}`;mainActivityData = mainActivityData.replace(packageRegex, newPackageLine);await fs.promises.writeFile(mainActivityPath, mainActivityData);console.log("MainActivity.kt updated successfully.");} catch (err) {console.error("Error modifying MainActivity.kt:", err);}}
//
// async function modifyApplicationId(newApplicationId) {
//   const buildGradlePath = path.join("Recovery", "android", "app", "build.gradle");
//
//   try {
//      // Read the build.gradle file
//      let buildGradleData = await fs.promises.readFile(buildGradlePath, "utf8");
//
//      // Use a regular expression to find the applicationId line and replace it
//      const applicationIdRegex = /applicationId\s+"[^"]*"/;
//      const newApplicationIdLine = `applicationId "${newApplicationId}"`;
//      buildGradleData = buildGradleData.replace(applicationIdRegex, newApplicationIdLine);
//
//      // Write the updated build.gradle back to the file
//      await fs.promises.writeFile(buildGradlePath, buildGradleData);
//      console.log("Application ID updated successfully.");
//   } catch (err) {
//      console.error("Error modifying applicationId:", err);
//   }
//  }

async function renameApp(name, id) {
  const manifestPath = "Recovery/android/app/src/main/AndroidManifest.xml";

  // Parse the XML data
  try {
    let manifestData = await fs.promises.readFile(manifestPath, "utf8");
    const result = await xml2js.parseStringPromise(manifestData);
    // Find the application node
    const applicationNode = result["manifest"]["application"][0];
    applicationNode["$"]["android:label"] = name;
    // const manifestNode = result["manifest"];
    // manifestNode["$"]["package"] = `com.starkin.recovery${id}`;
    // await modifyApplicationId(`com.starkin.recovery${id}`)
    // await modifyMainActivity(`com.starkin.recovery${id}`)

    // Change the label attribute value
    // applicationNode['$'].label = name;

    // Convert back to XML string
    const builder = new xml2js.Builder();
    const xml = builder.buildObject(result);

    // Write the updated XML back to the file
    await fs.promises.writeFile(manifestPath, xml);
  } catch (err) {
    console.error("Error parsing XML:", err);
  }
}
//this function will write new details into the json
async function setAgencyDetails(agencyName, id, contact, address) {
  const agencyDetailsJsonPath = "Recovery/assets/agency.json";
  let agencyDetails = {};

  // Read the existing JSON file
  try {
    const rawData = await fs.promises.readFile(agencyDetailsJsonPath, "utf8");
    agencyDetails = JSON.parse(rawData);
  } catch (err) {
    console.error("Error reading JSON file:", err);
    return;
  }

  // Update the values
  agencyDetails.id = id;
  agencyDetails.agency_name = agencyName;
  agencyDetails.contact = contact;
  agencyDetails.address = address;

  // Convert the updated object back to JSON string
  const updatedJson = JSON.stringify(agencyDetails, null, 2);

  // Write the updated JSON back to the file
  try {
    await fs.promises.writeFile(agencyDetailsJsonPath, updatedJson);
    console.log("Agency details updated successfully.");
  } catch (err) {
    console.error("Error writing JSON file:", err);
  }
}

renameApp("the app", "28");

module.exports = { renameApp, setAgencyDetails };
