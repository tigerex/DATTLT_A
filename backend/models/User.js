const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const userSchema = new mongoose.Schema({
  userName: {
    type: String,
    required: true,
    unique: true
  },
  passWord: {
    type: String,
    required: true
  }
});

// Mã hóa mật khẩu trước khi lưu vào cơ sở dữ liệu
userSchema.pre('save', async function(next) {
  if (this.isModified('password')) {
    this.passWord = await bcrypt.hash(this.passWord, 10);
  }
  next();
});

// Kiểm tra mật khẩu
userSchema.methods.comparePassword = async function(passWord) {
  return bcrypt.compare(passWord, this.passWord);
};

module.exports = mongoose.model('User', userSchema);
