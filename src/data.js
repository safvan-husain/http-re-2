const mongoose = require('mongoose');

// Define the schema
const dataSchema = new mongoose.Schema({
 total_generated: Number,
 current_remaining: Number
});

// Create the model
const DataModel = mongoose.model('Data', dataSchema);

module.exports = DataModel;

