## Purpose


This Node.js project automates the generation of Android APK files from a Flutter codebase. It allows for the customization of key details like the app's name, icon, and other hardcoded information. Built for a client, this project enables the easy distribution of the application to multiple end users, each with their own customized version of the app.




## Key Code Snippets

### 1. Generating Apk

```javascript
async function buildApk(outputDir, id) {
  console.log("on build apk");
  return new Promise((resolve, reject) => {
    console.log("executing");
    exec(
      `cd Recovery && flutter pub run flutter_launcher_icons && flutter pub run change_app_package_name:main com.starkin.recovery${id} && flutter build apk`,
      (error, stdout, stderr) => {
        if (error) {
          reject(error);
          return;
        }
        const apkOutputPath = path.join(
          process.cwd(),
          "Recovery",
          "build",
          "app",
          "outputs",
          "flutter-apk",
        );

        fs.readdir(apkOutputPath, (err, files) => {
          if (err) {
            reject(err);
            return;
          }
          if (stderr) {
            console.log(`stderr : ${stderr}`);
          }

          // Look for an APK file in the directory
          const apkFile = files.find((file) => file === "app-release.apk");
          if (!apkFile) {
            reject(new Error("APK file not found"));
            return;
          }

          // Move the APK file to the output directory
          const oldPath = path.join(apkOutputPath, apkFile);
          const newPath = path.join(outputDir, apkFile);
          fs.rename(oldPath, newPath, (err) => {
            if (err) {
              reject(err);
              return;
            }
            resolve(newPath);
          });
        });
      },
    );
  });
}
```

### 2. Storing customised data

```javascript
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
```

### 3. Executing command on different thread

```javascript
 const modulePath = path.resolve(process.cwd(), "./src/long_task.js");
    const child = fork(modulePath);
    var outputDir = ensureDirectoryExists(`apk/${agencyId}`);
    child.send({ command: "start", outputDir, agencyId });
    child.on("message", (result) => {
      if (result.apkPath) {
        console.log("apk generated sucess");
        current = current - 1;
        updateAndWriteCounts();
      } else {
        console.log(result);
        console.log("apk generated failed");
      }
    });
```

