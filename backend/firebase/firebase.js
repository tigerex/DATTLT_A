const admin = require('firebase-admin');

// TUYỆT ĐỐI KHÔNG PUSH CÁI NÀY LÊN GITHUB
const serviceAccount = require('./my-first-project-ecf2b-firebase-adminsdk-zk4xt-7c74378944.json'); // Đường dẫn đến tệp JSON chứa thông tin xác thực Firebase Admin SDK

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  storageBucket: 'gs://my-first-project-ecf2b.firebasestorage.app', // Use the actual Firebase storage bucket URL
});

const bucket = admin.storage().bucket();  // Lấy bucket từ Firebase Storage

module.exports = bucket;

//gsutil cors set cors.json gs://my-first-project-ecf2b.appspot.com