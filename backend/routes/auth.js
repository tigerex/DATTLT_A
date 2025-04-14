const express = require('express');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const User = require('../models/User');
const router = express.Router();
const { MongoClient } = require('mongodb');
const cookieParser = require('cookie-parser');

const app = express();
const dbName = "User"; // Thay đổi tên cơ sở dữ liệu nếu cần
const collectionName = "User"; // Tên collection trong MongoDB
const accessPassword = "Raccoon-1"; // Mật khẩu truy cập MongoDB
const url = "mongodb+srv://adminM:"+accessPassword+"@usertest.1opu14d.mongodb.net/?retryWrites=true&w=majority&appName=UserTest";

const client = new MongoClient(url, { useNewUrlParser: true, useUnifiedTopology: true }); // Kết nối MongoDB
const db = client.db(dbName); // Kết nối đến cơ sở dữ liệu
const userCollection = db.collection(collectionName); // Tạo collection để lưu trữ người dùng

const maxAge = 3 * 24 * 60 * 60; // Thời gian hết hạn token (3 ngày)
const ACCESS_SECRET_TOKEN = "Lola"; // Mã bí mật để mã hóa token (nên thay đổi trong thực tế)

// middleware để xử lý JSON và cookie
app.use(express.json()); // Sử dụng express.json() để xử lý JSON trong request body
app.use(cookieParser()); // Sử dụng cookie-parser để xử lý cookie

// Đăng nhập người dùng
router.post('/login', async (req, res) => {
  const { email, passWord } = req.body;

  try {
    if(!email || !passWord) {
      throw new Error("MISSINGDATA"); // Kiểm tra xem có thiếu thông tin không
    }
    // Tìm người dùng trong cơ sở dữ liệu
    const user = await userCollection.find({ email: email }).toArray();

    if (user.length === 0) {
      throw new Error("NOFIND"); // Kieerm tra xem người dùng có tồn tại không
    }

    // Kiểm tra mật khẩu
    if (!await bcrypt.compare(passWord, user[0].passWord)) {
      throw new Error("WRONGPASS"); // Kiểm tra mật khẩu có đúng không
    }
    const token = generateAccessToken(user[0]._id); // Tạo token cho người dùng
    console.log(token);
    res.cookie('jwt', token, { httpOnly: true, maxAge: maxAge * 1000 }); // Ghi cookie vào trình duyệt
    res.status(200).json({ msg: 'Đăng nhập thành công!!!', user });

  } catch (error) {
    if (error.message === "MISSINGDATA") {
      return res.status(400).json({ msg: 'ERROR!!!Sai thông tin đăng nhập!!!' });
    } 
    if (error.message === "NOFIND") {
      return res.status(400).json({ msg: 'ERROR!!!Người dùng không tồn tại!!!' });
    } 
    if (error.message === "WRONGPASS") {
      return res.status(400).json({ msg: 'ERROR!!!Mật khẩu không đúng!!!' });
    } 
    else {
      return res.status(500).json({ msg: 'ERROR!!!Lỗi server jj đó ở khúc đăng nhập á!!!', error });
    }
    
  }
});

function generateAccessToken(user) {
  console.log("user:", user);
  console.log("Key:", ACCESS_SECRET_TOKEN);
  console.log("maxAge:", maxAge);
  return jwt.sign({user}, ACCESS_SECRET_TOKEN, { expiresIn: maxAge});
}

module.exports = router;