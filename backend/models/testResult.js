const mongoose = require('mongoose');

const testResultSchema = new mongoose.Schema(
    {
      userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
      level: { type: String, required: true },
      timeTaken: { type: Number, required: true },
      score: { type: Number, default: 0 },
      questions: [
        {
          question_Id: { type: mongoose.Schema.Types.ObjectId, ref: 'Question', required: true },
          userAnswer: { type: String, default: null },
        }
      ],
      createdAt: { type: Date, default: Date.now },
      updatedAt: { type: Date, default: Date.now }
    },
    {
      collection: 'Result'
    }
  );
  
  module.exports = mongoose.model('Result', testResultSchema);

