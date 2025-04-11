const express = require('express');
const jwt = require('jsonwebtoken');
const User = require('../models/User');
const router = express.Router();
const { MongoClient } = require('mongodb');

const url = "mongodb+srv://adminM:Raccoon-1@usertest.1opu14d.mongodb.net/"
const dbName = "User";

const client = new MongoClient(url, { useNewUrlParser: true, useUnifiedTopology: true });
const db = client.db(dbName);
const testCollection = db.collection('Test');


// Đăng ký người dùng mới 
router.post('/register', async (req, res) => {
  const { role, userName, passWord, email, phone, displayName, age } = req.body;
  
  try {
    // Kiểm tra xem người dùng đã tồn tại chưa
    const user = await testCollection.findOne({ userName: userName });
    if (user) {
      return res.status(400).json({msg: 'Người dùng đã tồn tại'});
    }

    else{
      const newUser = {
        role,
        userName,
        passWord,
        email,
        phone,
        displayName,
        age,
        createdAt: new Date()
      };

      // Thêm vào MongoDB
      const result = await testCollection.insertOne(newUser);

      res.status(201).json({ msg: 'Đăng ký thành công!!!', userId: result.insertedId });
    }

  } catch (error) {
    res.status(500).json({ msg: 'Lỗi server', error });
  }
});

// Đăng nhập người dùng
router.post('/login', async (req, res) => {
  const { userName, passWord } = req.body;
  try {
    // Tìm người dùng trong cơ sở dữ liệu
    const user = await testCollection.find({ userName: userName }).toArray();;
    if (!user) {
      return res.status(400).json({ msg: 'ERROR!!!Người dùng không tồn tại!!!' });
    }

    // Kiểm tra mật khẩu
    if (user[0].passWord !== passWord) {
      return res.status(400).json({ msg: 'ERROR!!!Mật khẩu không đúng!!!' });
    }

    res.send({ msg: 'Đăng nhập thành công!!!', user });
  } catch (error) {
    res.status(500).json({ msg: 'Lỗi server jj đó', error });
  }
});

module.exports = router;
