const express = require('express');
const router = express.Router();
const { MongoClient } = require('mongodb');
const cookieParser = require('cookie-parser');
const mongoose = require('mongoose');
const User = require('../models/Question'); // Import model Question

const app = express();
const dbName = "User"; // Thay đổi tên cơ sở dữ liệu nếu cần
const collectionName = "User"; // Tên collection trong MongoDB
const accessPassword = "Raccoon-1"; // Mật khẩu truy cập MongoDB
const url = "mongodb+srv://adminM:"+accessPassword+"@usertest.1opu14d.mongodb.net/?retryWrites=true&w=majority&appName=UserTest";

const client = new MongoClient(url, { useNewUrlParser: true, useUnifiedTopology: true }); // Kết nối MongoDB
const db = client.db(dbName); // Kết nối đến cơ sở dữ liệu
const userCollection = db.collection(collectionName); // Tạo collection để lưu trữ câu hỏi

// Cấu hình middleware
app.use(cookieParser()); // Sử dụng cookie-parser để xử lý cookie
app.use(express.json()); // Sử dụng express.json() để xử lý JSON trong request body


// Show tất cả người dùng trong MongoDB
router.get('/all', async(req, res) => {
    const allData = await userCollection.find().toArray();
    if (allData.length === 0) {
      return res.status(404).json({ message: 'Không có dữ liệu nào trong cơ sở dữ liệu.' });
    }
    res.json(allData);
});

// Tìm kiếm người dùng theo id trong MongoDB (for demo)
router.get('/id/:id', async(req, res) => {
    const { id } = req.params;
    const user = await userCollection.findOne({ _id: new mongoose.Types.ObjectId(id) });
    if (!user) {
      return res.status(404).json({ message: 'Người dùng không tồn tại.' });
    }
    res.json(user);
});
  
// Tim kiếm người dùng theo tên hiển thị
router.get('/name/:name', async(req, res) => {
    const { name } = req.params;
    const user = await userCollection.findOne({ displayName: name });
    if (!user) {
        return res.status(404).json({ message: 'Người dùng không tồn tại.' });
    }
    res.json(user);
});

module.exports = router;