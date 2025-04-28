const express = require('express');
const router = express.Router();
const { MongoClient } = require('mongodb');
const cookieParser = require('cookie-parser');
const mongoose = require('mongoose');
const Question = require('../models/Question'); // Import model Question

const app = express();
const dbName = "User"; // Thay đổi tên cơ sở dữ liệu nếu cần
const collectionName = "Question"; // Tên collection trong MongoDB
const accessPassword = "Raccoon-1"; // Mật khẩu truy cập MongoDB
const url = "mongodb+srv://adminM:"+accessPassword+"@usertest.1opu14d.mongodb.net/?retryWrites=true&w=majority&appName=UserTest";

const client = new MongoClient(url, { useNewUrlParser: true, useUnifiedTopology: true }); // Kết nối MongoDB
const db = client.db(dbName); // Kết nối đến cơ sở dữ liệu
const questionCollection = db.collection(collectionName); // Tạo collection để lưu trữ câu hỏi

// Cấu hình middleware
app.use(cookieParser()); // Sử dụng cookie-parser để xử lý cookie
app.use(express.json()); // Sử dụng express.json() để xử lý JSON trong request body

// show tất cả câu hỏi trong MongoDB
router.get ('/all', async(req, res) => {
    const allData = await questionCollection.find().toArray();
    if (allData.length === 0) {
        return res.status(404).json({ message: 'Không có dữ liệu nào trong cơ sở dữ liệu.' });
    }
    res.json(allData);
    }
);

// Tìm kiếm câu hỏi theo id trong MongoDB (for demo)
router.get('/id/:id', async(req, res) => {
    const { id } = req.params;
    const question = await questionCollection.findOne({ questionId: id });
    if (!question) {
        return res.status(404).json({ message: 'Câu hỏi không tồn tại.' });
    }
    res.json(question);
});

// Tìm kiếm câu hỏi theo độ khó
router.get('/level/:level', async(req, res) => {
    const { level } = req.params;
    const question = await questionCollection.find({ level: level }).toArray();
    if (!question) {
        return res.status(404).json({ message: 'Câu hỏi không tồn tại.' });
    }
    res.json(question);
});

// Them câu hỏi mới vào MongoDB
router.post('/add', async (req, res) => {
    const { questionId, level, questionImg, questionText, options, correctAnswer, maxTime } = req.body;
    try {
        // Kiểm tra xem có thiếu thông tin không
        if (!questionId || !level || !questionText || !options || !correctAnswer || !maxTime) {
            throw new Error("MISSINGDATA");
        }

        // Kiểm tra đủ 4 lựa chọn
        if (!Array.isArray(options) || options.length !== 4) {
            throw new Error("INVALIDOPTIONS");
        }

        // Kiểm tra định dạng của các lựa chọn
        for (let opt of options) {
            if (!opt.label || !opt.text) {
                throw new Error("INVALIDOPTIONSFORMAT");
            }
        }

        // Kiểm tra xem đáp án đúng có khớp với bất kỳ label nào trong các lựa chọn không
        const validLabels = options.map(opt => opt.label);
        if (!validLabels.includes(correctAnswer)) {
            throw new Error("INVALIDCORRECTANSWER");
        }

        const newQuestion = {
            questionId,
            level,
            questionImg: questionImg || null,
            questionText,
            options,
            correctAnswer,
            maxTime,
            createDate: new Date(),
            updatedDate: new Date()
        };

        await questionCollection.insertOne(newQuestion);
        res.status(201).json({ message: 'Câu hỏi đã được thêm thành công.' });

    } catch (error) {
        let msg = 'Lỗi server không rõ!';
        if (error.message === "MISSINGDATA") msg = 'Thiếu thông tin câu hỏi!';
        if (error.message === "INVALIDOPTIONS") msg = 'Danh sách đáp án phải có đúng 4 lựa chọn!';
        if (error.message === "INVALIDOPTIONSFORMAT") msg = 'Mỗi lựa chọn phải có label và text!';
        if (error.message === "INVALIDCORRECTANSWER") msg = 'Đáp án đúng không khớp với bất kỳ label nào trong các lựa chọn!';
        
        return res.status(400).json({ msg, error: error.message });
    }
});

// Lấy câu hỏi có hình
router.get('/random/imgonly', async (req, res) => {
    try {
        const questions = await questionCollection.aggregate([
            { $match: { questionImg: { $ne: null } } }, // Lọc câu hỏi có hình ảnh
            { $sample: { size: 10 } } // Lấy ngẫu nhiên 5 câu hỏi
        ]).toArray();

        if (questions.length === 0) {
            throw new Error("NOQUESTIONFOUND");
        }
        res.json(questions);

    } catch (error) {
        let msg = 'Lỗi server không rõ!';
        let status = 400;

        if (error.message === "NOQUESTIONFOUND") msg = '!!!Không tìm thấy câu hỏi nào có hình ảnh!!!'; status = 404;

        return res.status(status).json({ msg, error: error.message });
    }
});


// Lấy random 5 câu hỏi cùng level
router.get('/random/:level', async (req, res) => {
    const { level } = req.params;
    try {
        const questions = await questionCollection.aggregate([
            { $match: { level: level } },
            { $sample: { size: 10 } } // Lấy ngẫu nhiên 5 câu hỏi
        ]).toArray();

        if (questions.length === 0) {
            throw new Error("NOQUESTIONFOUND");
        }
        res.json(questions);

    } catch (error) {
        let msg = 'Lỗi server không rõ!';
        let status = 400;

        if (error.message === "NOQUESTIONFOUND") msg = '!!!Không tìm thấy câu hỏi nào với độ khó này!!!'; status = 404;

        return res.status(status).json({ msg, error: error.message });
    }
});


module.exports = router;