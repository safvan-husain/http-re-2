const { fork } = require("child_process");
const express = require("express");
const fs = require("fs");
const path = require("path");
const { renameApp, setAgencyDetails } = require("./rename-app.js");
const app = express();
const port = 3001;
const multer = require("multer");
const DataModel = require("./data.js");
const longTaskModule = require("./long_task.js");
app.use(express.json());
const upload = multer({ dest: "uploads/" });
const {
  createThatXmlIfNotExist,
} = require("./check_existence_of_n_t_c_b_xml.js");
const {
  resetCount,
  readCountsFromFile,
  updateAndWriteCounts,
} = require("./read_count.js");
const mongoose = require("mongoose");

let { total, current } = readCountsFromFile();

//mongodb+srv://safvanstarkin:EmbFsFTmiSFpRNtM@cluster0.bj7sphw.mongodb.net/
app.get("/", async (req, res) => {
  console.log(process.cwd());
  res.sendFile(path.join(__dirname, "display.html"));
  // res.send("hello world from http-recovery");
});

app.post("/run", upload.single("logo"), async (req, res) => {
  const { name, agencyId, contact, address } = req.body;

  if (current < 1) {
    res.sendFile(path.join(__dirname, "error.html"));
    return;
  }

  if (name === undefined || name === null) {
    res.status(401).json({ message: "name: argument name is required" });
    return;
  } else if (agencyId === undefined || agencyId === null) {
    res
      .status(401)
      .json({ message: "agencyId: argument agencyId is required" });
    return;
  } else if (contact === undefined || contact === null) {
    res.status(401).json({ message: "contect: argument contact is required" });
    return;
  } else if (address === undefined || address === null) {
    res.status(401).json({ message: "address: argument address is required" });
    return;
  } else if (address === undefined || address === null) {
    res.status(401).json({ message: "address: argument address is required" });
    return;
  }
  const imageFile = req.file; // Access the uploaded file
  if (imageFile == null || imageFile == undefined) {
    res.status(401).json({ message: "logo image is missing" });
    return;
  }
  res.status(200).json({ message: "request recieved" });
  const targetImageDirectory = process.cwd() + "/Recovery/assets/icons"; //I will add it later.

  try {
    await createThatXmlIfNotExist();

    await renameApp(name, agencyId);
    await setAgencyDetails(name, agencyId, contact, address);
    //  Move the image file to the target directory with the name logo.png
    const destinationPath = path.join(targetImageDirectory, "logo.png");
    fs.rename(imageFile.path, destinationPath, (err) => {
      if (err) throw err;
      console.log("Image moved successfully!");
    });
    const modulePath = path.resolve(process.cwd(), "./src/long_task.js");
    const child = fork(modulePath);
    var outputDir = ensureDirectoryExists(`apk/${agencyId}`);
    child.send({ command: "start", outputDir, agencyId });
    child.on("message", (result) => {
      if (result.apkPath) {
        current = current - 1;
        updateAndWriteCounts();
      } else {
        console.log(result);
      }
    });
  } catch (error) {
    console.log(error);
  }
});

app.post("/reset", (req, res) => {
  const { password, count } = req.body;
  if (password === "65") {
    resetCount(count);
    current = count;
    res.status(200).json({ message: "count has updated successfully" });
  } else {
    res.status(401).json({ message: "wrong password" });
  }
});

app.get("/download", (req, res) => {
  // Extract the file name from the request query parameters
  const fileName = decodeURIComponent(req.query.file);

  // Check if the file exists
  if (fs.existsSync(fileName)) {
    // Set the appropriate headers for file download
    res.setHeader("Content-Disposition", `attachment; filename="${fileName}"`);
    res.setHeader("Content-Type", "application/octet-stream");

    // Stream the file content to the client
    const readStream = fs.createReadStream(fileName);
    readStream.pipe(res);
  } else {
    // Send a 404 Not Found status if the file does not exist
    res.status(404).send("File not found");
  }
});

app.get("/download-with-id", (req, res) => {
  // Extract the file name from the request query parameters
  const fileId = req.query.id; // Assuming the ID is passed as 'id' query parameter
  const fileName = `apk/${fileId}/app-release.apk`; // Adjust file path accordingly
  const filePath = path.resolve(process.cwd(), fileName);

  // Check if the file exists
  if (fs.existsSync(filePath)) {
    // Set the appropriate headers for file download
    res.setHeader("Content-Disposition", `attachment; filename="${fileName}"`);
    res.setHeader("Content-Type", "application/octet-stream");

    // Stream the file content to the client
    const readStream = fs.createReadStream(fileName);
    readStream.pipe(res);
  } else {
    // Send a 404 Not Found status if the file does not exist
    res
      .status(404)
      .send(
        `file not found for the agency id: ${fileId}, if you haven't requested to generate the apk, please request from the webpage, if requested, try using this link after 10 minitues, if still not found, please request again.`
      );
  }
});

function ensureDirectoryExists(folderPath) {
  const dir = path.join(process.cwd(), folderPath);

  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }

  return dir;
}

// async function checkAndCreateDataModel() {
//   try {
//     // Check if a document exists
//     let data = await DataModel.findOne({});

//     // If no document is found, create a new one with total_generated and current_remaining set to 0
//     if (!data) {
//       data = new DataModel({
//         total_generated: 0,
//         current_remaining: 0,
//       });
//       await data.save();
//       console.log("DataModel document created with initial values.");
//     } else {
//       console.log("DataModel document already exists.");
//     }
//   } catch (error) {
//     console.error("Error checking and creating DataModel document:", error);
//   }
// }

// mongoose
//   .connect(
//     "mongodb+srv://safvanstarkin:EmbFsFTmiSFpRNtM@cluster0.bj7sphw.mongodb.net/"
//   )
//   .then(() => {
//     console.log("Connected!");
//     checkAndCreateDataModel();
//   });

app.listen(port, "0.0.0.0", () => {
  console.log(`Server is running on http://localhost:${port}`);
});
