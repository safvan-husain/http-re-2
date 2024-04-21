const fs = require('fs');
const path = require('path');

// Function to read counts from file
function readCountsFromFile() {
 const countsFilePath = path.join(process.cwd(), 'ifno.json');
 if (fs.existsSync(countsFilePath)) {
    const counts = JSON.parse(fs.readFileSync(countsFilePath, 'utf8'));
    return counts;
 } else {
    // If the file doesn't exist, return default counts
    return { total: 0, current: 15 };
 }
}
function resetCount(current_limit) {
    let { total, current} = readCountsFromFile();
 // Update the counts

 // Prepare the counts object
 const counts = { total, current: current_limit};

 // Define the path to the counts file
 const countsFilePath = path.join(process.cwd(), 'info.json');

 // Write the updated counts to the file
 fs.writeFileSync(countsFilePath, JSON.stringify(counts), 'utf8');
}

function updateAndWriteCounts() {
    let { total, current} = readCountsFromFile();
 // Update the counts
 total+= 1;
 current-= 1;

 // Prepare the counts object
 const counts = { total, current};

 // Define the path to the counts file
 const countsFilePath = path.join(process.cwd(), 'info.json');

 // Write the updated counts to the file
 fs.writeFileSync(countsFilePath, JSON.stringify(counts), 'utf8');
}

module.exports = { updateAndWriteCounts, readCountsFromFile, resetCount };