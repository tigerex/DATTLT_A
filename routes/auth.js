const express = require('express');
const jwt = require('jsonwebtoken');
const User = require('../models/User');
const router = express.Router();

// Đăng ký người dùng mới
router.post('/register', async (req, res) => {
  const { username, password } = req.body;
  
  try {
    // Kiểm tra xem người dùng đã tồn tại chưa
    let user = await User.findOne({ userName });
    if (user) {
      return res.status(400).json({ msg: 'Người dùng đã tồn tại' });
    }

    // Tạo người dùng mới
    user = new User({ userName, password });
    await user.save();

    res.status(201).json({ msg: 'Đăng ký thành công' });
  } catch (error) {
    res.status(500).json({ msg: 'Lỗi server', error });
  }
});

// Đăng nhập người dùng
router.post('/login', async (req, res) => {
  const { userName, passWord } = req.body;
  
  try {
    // Tìm người dùng trong cơ sở dữ liệu
    const user = await User.findOne({ userName });
    if (!user) {
      return res.status(400).json({ msg: 'Người dùng không tồn tại' });
    }

    // Kiểm tra mật khẩu
    const isMatch = await user.comparePassword(passWord);
    if (!isMatch) {
      return res.status(400).json({ msg: 'Mật khẩu không đúng' });
    }

    // Tạo token JWT
    const payload = { userId: user._id };
    const token = jwt.sign(payload, 'secretkey', { expiresIn: '1h' });

    res.json({ token });
  } catch (error) {
    res.status(500).json({ msg: 'Lỗi server', error });
  }
});

module.exports = router;
