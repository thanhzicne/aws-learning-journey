# 📅 Báo cáo Tuần 8 — Frontend Integration (React)

> **Trạng thái:** ⏳ Chưa bắt đầu  
> **Thời gian học:** — (15/06/2026 – 21/06/2026)

---

## 🎯 Mục tiêu tuần này

- [ ] Xây dựng React frontend (create-react-app / Vite)
- [ ] Kết nối API backend (Axios)
- [ ] Hiển thị danh sách sản phẩm với ảnh từ S3
- [ ] Implement trang thêm/sửa/xóa sản phẩm
- [ ] Deploy frontend lên S3 static hosting

---

## 🔧 Bài tập thực hành

### Bước 1: Tạo React Project

```bash
npm create vite@latest ecommerce-frontend -- --template react
cd ecommerce-frontend
npm install axios
npm install react-router-dom
```

### Bước 2: Cấu trúc project

```
src/
├── components/
│   ├── ProductCard.jsx
│   ├── ProductForm.jsx
│   └── Navbar.jsx
├── pages/
│   ├── HomePage.jsx
│   └── AdminPage.jsx
├── services/
│   └── productService.js    ← Axios calls to backend
└── App.jsx
```

### Bước 3: Kết nối API

```javascript
// services/productService.js
import axios from 'axios';
const API_URL = 'http://<EC2-IP>:8080/api';

export const getProducts = () => axios.get(`${API_URL}/products`);
export const createProduct = (data) => axios.post(`${API_URL}/products`, data);
export const uploadImage = (id, file) => {
  const formData = new FormData();
  formData.append('file', file);
  return axios.post(`${API_URL}/products/${id}/image`, formData);
};
```

### Bước 4: Build & Deploy lên S3

```bash
npm run build
# Tạo thư mục dist/

aws s3 sync dist/ s3://simple-ecommerce-fe-yourname/ --delete
```

> 📸 Screenshot: `01-frontend-live.png`

---

## 💡 Kiến thức quan trọng đã học

### CORS Configuration
Backend cần cấu hình CORS để React (S3 domain) gọi được API (EC2 domain):

```java
@CrossOrigin(origins = "*")
@RestController
public class ProductController { ... }
```

> ✏️ *Điền thêm khi học xong*

---

## ⏱️ Worklog giờ học

| Ngày | Thời gian | Hoạt động |
|---|---|---|
| **Tổng** | **... giờ** | |

---

*Cập nhật: [Ngày] | [Tên học viên]*
