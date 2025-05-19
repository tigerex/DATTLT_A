const express = require('express');
const router = express.Router();
const { MongoClient } = require('mongodb');
const cookieParser = require('cookie-parser');
const mongoose = require('mongoose');

const Result = require('../models/testResult'); // Import model TestResult

const app = express();
const dbName = "User"; // Thay đổi tên cơ sở dữ liệu nếu cần
const collectionName = "Result"; // Tên collection trong MongoDB
const accessPassword = "Raccoon-1"; // Mật khẩu truy cập MongoDB
const url = "mongodb+srv://adminM:"+accessPassword+"@usertest.1opu14d.mongodb.net/User?retryWrites=true&w=majority&appName=UserTest";

const client = new MongoClient(url, { useNewUrlParser: true, useUnifiedTopology: true }); // Kết nối MongoDB
const db = client.db(dbName); // Kết nối đến cơ sở dữ liệu
const resultCollection = db.collection(collectionName); // Tạo collection để lưu trữ câu hỏi

// Cấu hình middleware
app.use(cookieParser()); // Sử dụng cookie-parser để xử lý cookie
app.use(express.json()); // Sử dụng express.json() để xử lý JSON trong request body

// Show tất cả kết quả bài kiểm tra trong MongoDB
router.get('/all', async (req, res) => {
    const allData = await resultCollection.find().toArray();
    if (allData.length === 0) {
        return res.status(404).json({ message: 'Không có kết quả bài kiểm tra nào trong cơ sở dữ liệu!!!' });
    }
    res.json(allData);
});

// Thêm kết quả bài kiểm tra mới vào MongoDB
router.post('/add', async (req, res) => {
    const { userId, level, timeTaken, score, questions } = req.body;

    try {
        // Kiểm tra dữ liệu hợp lệ
        if ( !userId || !questions || !Array.isArray(questions) || !level || typeof timeTaken !== 'number') { //question là một mảng nhé bro
            throw new Error("MISSINGDATA");
        }

        const newResult = new Result({
            resultId: new mongoose.Types.ObjectId().toString(), // Tạo ID mới cho kết quả bài kiểm tra
            userId: new mongoose.Types.ObjectId(userId).toString(), // ID người dùng
            level: level, // Độ khó bài kiểm tra
            timeTaken: timeTaken, // Thời gian làm bài (tính bằng giây)
            score: score, // Điểm số bài kiểm tra
            questions // Mảng các câu hỏi
        });

        await newResult.save(); // Thêm kết quả bài kiểm tra vào MongoDB
        res.status(201).json({ message: 'Kết quả bài kiểm tra đã được thêm thành công!' });

    } catch (error) {
        let msg = 'Lỗi server không rõ!';
        let status = 400;

        if (error.message === 'MISSINGDATA') {
            msg = 'Thiếu thông tin cần thiết!';
            status = 400;
        }

        return res.status(status).json({ msg, error: error.message });
    }
});

// Lấy danh sách kết quả bài kiểm tra theo UserID
router.get('/user/:userId', async (req, res) => {
    const { userId } = req.params; // Lấy ID người dùng từ tham số URL
    console.log('Requested userId:', userId);
    try {
        if (!userId) {
            throw new Error('MISSINGPARA'); // Kiểm tra xem có thiếu thông tin không
        }

        // Tìm kiếm kết quả bài kiểm tra theo ID người dùng
        const results = await Result.find({ userId: userId })
            .sort({ createdAt: -1 }) // Sắp xếp theo ngày tạo giảm dần
            .populate('userId', 'displayName')
            .lean();

        return res.status(200).json(results);
    } catch (err) {
        console.error(err);
        let msg = 'Lỗi server không rõ!';
        let status = 400;

        if (err.message === 'MISSINGPARA') msg = 'Thiếu thông tin cần thiết!';status = 400;

        return res.status(status).json({ msg, error: err.message });
    }
});

// ranking theo độ khó bài kiểm tra
router.get('/rankings/:level', async (req, res) => {
    const { level } = req.params;// Lấy độ khó từ tham số URL
    const validLevels = ['easy', 'medium', 'hard'];// Danh sách các độ khó hợp lệ
    console.log('Requested level:', level);
    try {
        if (!level) {
            throw new Error('MISSINGPARA'); // Kiểm tra xem có thiếu thông tin không
        }

        // Kiểm tra độ khó hợp lệ
        if (!validLevels.includes(level)) {
            throw new Error('INVALIDLEVEL'); // Độ khó không hợp lệ
        }
  
        // const results1 = await resultCollection.find({ level: level }).toArray();
        // console.log('Found results:', results1);

        // Tìm kiếm kết quả bài kiểm tra theo độ khó
        const results = await Result.find({ level: level })
            .sort({ score: -1, timeTaken: 1 }) // Sắp xếp theo điểm số giảm dần và thời gian làm bài tăng dần
            .populate('userId', 'displayName')
            .lean();
  
        // Phần này là để thêm rank cho mỗi kết quả. Nếu mọi thứ đúng thì mấy bạn chỉ cần truyền theo kiểu list qua phongEnd là được
        const rankedResults = results.map((r, index) => ({
            rank: index + 1, // Thêm rank cho mỗi kết quả
            userId: r.userId, // Thay thế ObjectId bằng thông tin người dùng
            score: r.score, // Điểm số bài kiểm tra
            timeTaken: r.timeTaken, // Thời gian làm bài (tính bằng giây)
            level: r.level, // Độ khó bài kiểm tra
            resultID: r._id, // ID kết quả bài kiểm tra
            createdAt: r.createdAt, // Ngày tạo kết quả bài kiểm tra
        }));
  
        return res.status(200).json(rankedResults);
    } catch (err) {
      console.error(err);
        let msg = 'Lỗi server không rõ!';
        let status = 400;

        if (err.message === 'MISSINGPARA') msg = 'Thiếu thông tin cần thiết!';status = 400;
        if (err.message === 'INVALIDLEVEL') msg = 'Độ khó không hợp lệ!';status = 400;

        return res.status(status).json({ msg, error: err.message });
    }
});

router.get('/top10', async (req, res) => {
  try {
    const level = req.query.level;

    const results = await Result.find(level ? { level } : {})
      .populate('userId', 'name') // lấy tên người dùng
      .sort({ score: -1, createdAt: -1 }) // ưu tiên điểm cao, mới hơn
      .limit(10);

    const formatted = results.map(r => ({
      username: r.userId.name,  // cần có trường `name` trong bảng User
      score: r.score,
      total: r.questions.length,
      date: r.createdAt,
    }));

    res.status(200).json(formatted);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Server error' });
  }
});

module.exports = router;