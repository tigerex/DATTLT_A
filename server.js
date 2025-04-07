const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const authRoutes = require('./routes/auth');

const app = express();

// Cấu hình middleware
app.use(bodyParser.json());

// Kết nối MongoDB
mongoose.connect('mongodb+srv://adminM:Raccoon-1@usertest.1opu14d.mongodb.net/', { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('Kết nối MongoDB thành công'))
  .catch(err => console.log('Lỗi kết nối MongoDB', err));

// Sử dụng các route
app.use('/api/auth', authRoutes);

// Chạy server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server đang chạy trên cổng ${PORT}`);
});
