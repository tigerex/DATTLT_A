const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const authRoutes = require('./routes/auth');
const { MongoClient } = require('mongodb');

const app = express();
const url = "mongodb+srv://adminM:Raccoon-1@usertest.1opu14d.mongodb.net/"
const dbName = "User";

const client = new MongoClient(url, { useNewUrlParser: true, useUnifiedTopology: true });
const db = client.db(dbName);
const testCollection = db.collection('Test');

// Cấu hình middleware
app.use(bodyParser.json());

// Kết nối MongoDB
mongoose.connect(url, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('\n=========Kết nối MongoDB thành công========='))
  .catch(err => console.log('Lỗi kết nối MongoDB', err));

// Sử dụng các route
app.use('/api/auth', authRoutes);

app.get('/api/hello', (req, res) => {
  res.send('Hello World!');
});

app.get('/api/all', async(req, res) => {
  const allData = await testCollection.find().toArray();
  if (allData.length === 0) {
    return res.status(404).json({ message: 'Không có dữ liệu nào trong cơ sở dữ liệu.' });
  }
  res.json(allData);
});

// Chạy server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`\nServer đang chạy trên cổng ${PORT}`);
});
