const express = require('express');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const User = require('../models/User');
const router = express.Router();
const { MongoClient } = require('mongodb');
const cookieParser = require('cookie-parser');
const mongoose = require('mongoose');

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

router.get('/UserStatus', (req, res) => {
  const token = req.cookies.jwt; // Lấy token từ cookie
  try {
  if (!token) {
    throw new Error ("NOFIND"); // Nếu không có token, trả về lỗi
  }
  const decoded = decodedToken(token); // Giải mã token để lấy thông tin người dùng
  if (!decoded) {
    throw new Error ("INCORRECTTOKEN") // Nếu token không hợp lệ, trả về lỗi
  } else {
    return res.status(200).json({ msg: 'Đã đăng nhập!!!', UserID: decoded.user }); // Nếu token hợp lệ, trả về thông tin người dùng
  }

  } catch (error) {
    let msg = 'ERROR!!!Lỗi server jj đó ở khúc lấy thông tin người dùng á!!!';
    let status = 400;

    if (error.message === "NOFIND") msg = 'ERROR!!!chưa đăng nhập!!!'; status = 401;
    if (error.message === "INCORRECTTOKEN") msg = 'ERROR!!!Token không hợp lệ!!!'; status = 401;

    return res.status(status).json({ msg, error: error.message });
  }
});

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
    res.cookie('jwt', token, { httpOnly: true, maxAge: maxAge * 1000 }); // Ghi cookie vào trình duyệt
    res.status(200).json({ msg: 'Đăng nhập thành công!!!',token,user}); // Trả về thông báo thành công

  } catch (error) {
    let msg = 'ERROR!!!Lỗi server jj đó ở khúc đăng nhập á!!!';
    let status = 400;

    if (error.message === "MISSINGDATA") msg = 'ERROR!!!Thiếu thông tin đăng nhập!!!'; status = 400;
    if (error.message === "NOFIND") msg = 'ERROR!!!Người dùng không tồn tại!!!'; status = 404;
    if (error.message === "WRONGPASS") msg = 'ERROR!!!Mật khẩu không đúng!!!'; status = 401; 

    return res.status(status).json({ msg, error: error.message });
  }
});

router.get('/logout', (req, res) => {
  // kiem tra xem người dùng đã đăng nhập chưa
  const token = req.cookies.jwt; // Lấy token từ cookie
  try {
    if (!token) {
      throw new Error("NOFIND"); // Kieerm tra xem người dùng có tồn tại không
    }
    res.clearCookie('jwt'); // Xóa cookie jwt
    res.status(200).json({ msg: 'Đăng xuất thành công!!!' }); // Trả về thông báo thành công

  } catch (error) {
    let msg = 'ERROR!!!Lỗi server jj đó ở khúc đăng xuất á!!!';
    let status = 400;

    if (error.message === "NOFIND") msg = 'ERROR!!!chưa đăng nhập!!!';
    
    return res.status(status).json({ msg, error: error.message });
  }
});

router.get('/user/token/:token', async (req, res) => {
  const { token } = req.params; // Lấy token từ URL
  try {
    const decoded = decodedToken(token); // Giải mã token để lấy thông tin người dùng
    // console.log("decoded:", decoded);
    const userID = decoded.user; // Lấy id người dùng từ token
    console.log("userID:", userID);
    if (!decoded) {
      return res.status(401).json({ msg: 'ERROR!!!Token không hợp lệ!!!' }); // Nếu token không hợp lệ, trả về lỗi
    } else {
      const user = await userCollection.findOne({ _id: new mongoose.Types.ObjectId(decoded.user) });// Tìm người dùng trong cơ sở dữ liệu
      // console.log("find work") 
      if (!user) {
        return res.status(404).json({ msg: 'ERROR!!!Người dùng không tồn tại!!!' }); // Nếu không tìm thấy người dùng, trả về lỗi
      }
      res.status(200).json(user); // Trả về thông tin người dùng
    }
  } catch (error) {
    res.status(500).json({ msg: 'ERROR!!!Lỗi server jj đó ở khúc lấy thông tin người dùng á!!!', error });
  }
});


function generateAccessToken(user) {
  // console.log("user:", user);
  // console.log("Key:", ACCESS_SECRET_TOKEN);
  // console.log("maxAge:", maxAge);
  return jwt.sign({user}, ACCESS_SECRET_TOKEN, { expiresIn: maxAge});
}

function decodedToken(token) {
  try {
    const decoded = jwt.verify(token, ACCESS_SECRET_TOKEN); // Giải mã token để lấy id người dùng
    return decoded;
  } catch (error) {
    return null; // Nếu token không hợp lệ, trả về null
  }
}

module.exports = router;