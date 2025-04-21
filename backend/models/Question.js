const mongoose = require('mongoose');
// const bcrypt = require('bcryptjs');
// const e = require('express');

const questionSchema = new mongoose.Schema(
    {
        questionId: { type: String, required: true, unique: true },    // ID câu hỏi (định danh duy nhất)
        level: { type: String, required: true },                       // Cấp độ câu hỏi (easy, medium, hard)
        questionImg: { type: String, required: false, default: null }, // câu hỏi hình ảnh
        questionText: { type: String, required: true },                // Nội dung câu hỏi
        option_a: { type: String, required: true },                    // Đáp án A
        option_b: { type: String, required: true },                    // Đáp án B
        option_c: { type: String, required: true },                    // Đáp án C
        option_d: { type: String, required: true },                    // Đáp án D
        isCorrectAnswer: { type: String, required: true },             // Đáp án đúng (A, B, C, D)
        maxTimePerQuestion: { type: Number, required: true },          // Thời gian tối đa cho mỗi câu hỏi (giây)
        createDate: { type: Date, default: Date.now },                 // Ngày tạo tài khoản
        updatedDate: { type: Date, default: Date.now },                // Ngày cập nhật tài khoản
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