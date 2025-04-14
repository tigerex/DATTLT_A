const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const authRoutes = require('./routes/auth');
const registerRoutes = require('./routes/register');
const { MongoClient } = require('mongodb');
const User = require('./models/User');
const cookieParser = require('cookie-parser');

const cors = require('cors');

const PORT = process.env.PORT || 5000; // Port cho server

const app = express();
const dbName = "User"; // Thay đổi tên cơ sở dữ liệu nếu cần
const collectionName = "User"; // Tên collection trong MongoDB
const accessPassword = "Raccoon-1"; // Mật khẩu truy cập MongoDB
const url = "mongodb+srv://adminM:"+accessPassword+"@usertest.1opu14d.mongodb.net/?retryWrites=true&w=majority&appName=UserTest";

const client = new MongoClient(url, { useNewUrlParser: true, useUnifiedTopology: true }); // Kết nối MongoDB
const db = client.db(dbName); // Kết nối đến cơ sở dữ liệu
const userCollection = db.collection(collectionName); // Tạo collection để lưu trữ người dùng

// Cấu hình middleware
app.use(cors({
  credentials: true
}));
app.use(bodyParser.json());
app.use(cookieParser());

// Kết nối MongoDB
mongoose.connect(url, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('\n=========Kết nối MongoDB thành công========='))
  .catch(err => console.log('Lỗi kết nối MongoDB', err));



// Sử dụng các route
app.use('/api/auth', authRoutes);
app.use('/api/register', registerRoutes);

app.get('/api/hello', (req, res) => {
  res.send('Hello World!');
});

app.get('/api/all', async(req, res) => {
  const allData = await userCollection.find().toArray();
  if (allData.length === 0) {
    return res.status(404).json({ message: 'Không có dữ liệu nào trong cơ sở dữ liệu.' });
  }
  res.json(allData);
});

// Tìm kiếm người dùng theo id trong MongoDB (for demo)
app.get('/api/user/id/:id', async(req, res) => {
  const { id } = req.params;
  const user = await userCollection.findOne({ _id: new mongoose.Types.ObjectId(id) });
  if (!user) {
    return res.status(404).json({ message: 'Người dùng không tồn tại.' });
  }
  res.json(user);
});

// Tim kiếm người dùng theo tên hiển thị
app.get('/api/user/name/:name', async(req, res) => {
  const { name } = req.params;
  const user = await userCollection.findOne({ displayName: name });
  if (!user) {
    return res.status(404).json({ message: 'Người dùng không tồn tại.' });
  }
  res.json(user);
});

// Tim hieu token trong cookie
const cookieName = 'jwt'; // Tên cookie

app.get('/api/getCookie', (req, res) => {
  const token = req.cookies.jwt; // Lấy token từ cookie
  if (!token) {
    return res.status(401).json({ message: 'Không có token trong cookie.' });
  }
  res.json({ token });
});
app.get('/api/setCookie', (req, res)=> {
  res.cookie(cookieName, 'thong dip bi an', { httpOnly: true, maxAge: 1000 * 60 * 60 * 24 }); // Ghi cookie vào trình duyệt
  res.json({ok: 1})
})

// Chạy server
app.listen(PORT, () => {
  console.log(`\nServer đang chạy trên cổng ${PORT}`);
});
