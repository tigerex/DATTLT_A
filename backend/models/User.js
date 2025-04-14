const mongoose = require('mongoose');
// const bcrypt = require('bcryptjs');
// const e = require('express');

const userSchema = new mongoose.Schema(
  {
    email: {type: String,required: true,unique: true},    // Địa chỉ email của người dùng
    passWord: {type: String,required: true,unique: true}, // Mật khẩu của người dùng
    phone: {type: String,required: true,unique: true},    // Số điện thoại của người dùng
    displayName: {type: String,required: true},           // Tên hiển thị của người dùng
    age: {type: Number,required: true},                   // Tuổi của người dùng
    role: {type: String,default: 'user'},                 // Vai trò của người dùng (mặc định là 'user')
    status: {type: String,default: 'active'},             // Trạng thái tài khoản (mặc định là 'active')
    createDate: {type: Date,default: Date.now},           // Ngày tạo tài khoản
    updatedDate: {type: Date,default: Date.now},          // Ngày cập nhật tài khoản
  },
  { 
    collection: 'User'  // Tên collection trong MongoDB
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

module.exports = mongoose.model('User', userSchema);
