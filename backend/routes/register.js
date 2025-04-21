const express = require('express');
const mongoose = require('mongoose');
// const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const router = express.Router();
const { MongoClient } = require('mongodb');
const User = require('../models/User');
const jwt = require('jsonwebtoken');
const cookieParser = require('cookie-parser');

const dbName = "User"; // Thay đổi tên cơ sở dữ liệu nếu cần
const collectionName = "User"; // Tên collection trong MongoDB
const accessPassword = "Raccoon-1"; // Mật khẩu truy cập MongoDB
const url = "mongodb+srv://adminM:"+accessPassword+"@usertest.1opu14d.mongodb.net/?retryWrites=true&w=majority&appName=UserTest";

const client = new MongoClient(url, { useNewUrlParser: true, useUnifiedTopology: true }); // Kết nối MongoDB
const db = client.db(dbName); // Kết nối đến cơ sở dữ liệu
const userCollection = db.collection(collectionName); // Tạo collection để lưu trữ người dùng

const maxAge = 3 * 24 * 60 * 60; // Thời gian hết hạn token (3 ngày)
const ACCESS_SECRET_TOKEN = "Lola"; // Mã bí mật để mã hóa token (nên thay đổi trong thực tế)

async function hashPassword(password) {
  const salt = await bcrypt.genSalt(); // Tạo muối để mã hóa mật khẩu
  return await bcrypt.hash(password, salt); // Mã hóa mật khẩu trước khi lưu vào cơ sở dữ liệu
}

// Đăng ký người dùng mới 
router.post('/newUser', async (req, res) => {
  const { email, passWord, phone, displayName, age, role, status} = req.body;
  
  try {
    if(!email || !passWord || !phone || !displayName || !age) {
      throw new Error("MISSINGDATA"); // Kiểm tra xem có thiếu thông tin không
    }
    // Kiểm tra xem người dùng đã tồn tại chưa
    // const existingUser = await userCollection.find({ email: email }).toArray();
    // if (existingUser.length > 0) {
    //   return res.status(400).json({ msg: 'ERROR!!!Người dùng đã tồn tại!!!' });
    // }else{
    //   const newUser = {
    //     email,
    //     passWord: await bcrypt.hash(passWord, 10), // Mã hóa mật khẩu trước khi lưu vào cơ sở dữ liệu
    //     phone,
    //     displayName,
    //     age,
    //     role: role || 'user', // Nếu không có vai trò, mặc định là 'user'
    //     status: status || 'active', // Nếu không có trạng thái, mặc định là 'active'
    //   };

      // Thêm vào MongoDB
      // const result = await userCollection.insertOne(newUser);

      /*============================================================================================================================
      Cách này đơn giản hơn rất nhiều, cách này lúc tạo người dùng mới, backend sẽ post lên trước rồi mới check
      trong MongoDB có người dùng đó hay không, nếu có thì sẽ báo lỗi, còn không thì sẽ tạo người dùng mới
      Cách tụi trên là check trước rồi mới tạo người dùng mới, ai biết cách nào hay hơn, nhưng mà cái dưới ít bước hơn :DD
      ============================================================================================================================*/

      const newUser = new User({
        email,
        passWord: await hashPassword(passWord), // Mã hóa mật khẩu trước khi lưu vào cơ sở dữ liệu
        phone,
        displayName,
        age,
        role: role || 'user', // Nếu không có vai trò, mặc định là 'user'
        status: status || 'active', // Nếu không có trạng thái, mặc định là 'active'
      });
      const result = await userCollection.insertOne(newUser); // Lưu người dùng mới vào MongoDB
      console.log("result:", result);
      const token = generateAccessToken(result[0]._id); // Tạo token cho người dùng
      res.cookie('jwt', token, { httpOnly: true, maxAge: maxAge * 1000 }); // Ghi cookie vào trình duyệt
      res.status(201).json({ msg: 'Đăng ký thành công!!!', user: result});
    // }

  } catch (error) {
    let msg = 'ERROR!!!Lỗi server jj đó ở khúc đăng kí áá!!!';
    if (error.code === 11000) msg = 'ERROR!!!Người dùng đã tồn tại!!!'; // Lỗi trùng lặp email
    if (error.message === "MISSINGDATA") msg = 'ERROR!!!Thiếu thông tin đăng ký!!!'; // Thiếu thông tin đăng ký
    
    return res.status(400).json({ msg, error: error.message });
  }
});

function generateAccessToken(user) {
  // console.log("user:", user);
  // console.log("Key:", ACCESS_SECRET_TOKEN);
  // console.log("maxAge:", maxAge);
  return jwt.sign({user}, ACCESS_SECRET_TOKEN, { expiresIn: maxAge});
}

module.exports = router;