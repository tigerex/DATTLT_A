const mongoose = require('mongoose');
// const bcrypt = require('bcryptjs');
// const e = require('express');

const questionSchema = new mongoose.Schema(
    {
        questionId: { type: String},
        level: { type: String, required: true }, // "easy", "medium", "hard"
        questionImg: { type: String, default: null },
        questionText: { type: String, required: true },
        options: [
            {
                label: { type: String, enum: ['A', 'B', 'C', 'D'], required: true },
                text: { type: String, required: true }
            }
        ],
        correctAnswer: { type: String, enum: ['A', 'B', 'C', 'D'], required: true },
        maxTime: { type: Number, required: true },
        createDate: { type: Date, default: Date.now },
        updatedDate: { type: Date, default: Date.now }
    },
    {
        collection: 'Question'  // Tên collection trong MongoDB
    }
);
// // Mã hóa mật khẩu trước khi lưu vào cơ sở dữ liệu
// userSchema.pre('save', async function(next) {
//   if (this.isModified('password')) {
//     this.passWord = await bcrypt.hash(this.passWord, 10);
//   }
//   next();
// });

// // Kiểm tra mật khẩu
// userSchema.methods.comparePassword = async function(passWord) {
//   return bcrypt.compare(passWord, this.passWord);
// };

module.exports = mongoose.model('Question', questionSchema);