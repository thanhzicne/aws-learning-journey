---
title: "Worklog Tuần 8"
date: 2026-05-14
weight: 8
chapter: false
pre: " <b> 1.8. </b> "
---

## Mục tiêu tuần 8

- Xây dựng React frontend (Vite) và kết nối API backend (Axios).
- Hiển thị danh sách sản phẩm với ảnh từ S3.
- Implement trang thêm/sửa/xóa sản phẩm.
- Deploy frontend lên S3 Static Hosting.

### Các công việc cần triển khai trong tuần này

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu |
| --- | --- | --- | --- | --- |
| 2 | Tạo React project với Vite, cấu hình cấu trúc thư mục, cài đặt Axios và React Router | 08/06/2026 | 08/06/2026 | [Frontend Development for Serverless APIs](https://000079.awsstudygroup.com) |
| 3 | Kết nối API backend (Axios), hiển thị danh sách sản phẩm với ảnh từ S3 | 09/06/2026 | 09/06/2026 | [Frontend Development for Serverless APIs](https://000079.awsstudygroup.com) |
| 4 | **Thực hành Frontend:** Implement trang thêm/sửa/xóa sản phẩm, xử lý upload ảnh | 10/06/2026 | 10/06/2026 | [Frontend Integration with API Gateway](https://000135.awsstudygroup.com) |
| 5 | Cấu hình CORS trên backend, xử lý lỗi và kiểm thử toàn bộ luồng | 11/06/2026 | 11/06/2026 | [Frontend Development for Serverless APIs – Config CORS](https://000079.awsstudygroup.com/4-config-api-gw/4-2-setting-and-cors/) |
| 6 | Build & Deploy frontend lên S3 Static Hosting. Ôn tập, viết báo cáo worklog. Viết lại những gì học được sau khi tham dự event FCAJ Community Day, tìm hiểu các bài blog trên AWS. Lên kế hoạch tuần 9 | 12/06/2026 | 12/06/2026 | [Static Website Hosting with Amazon S3](https://000057.awsstudygroup.com) |

### Kết quả đạt được tuần 8

Nắm vững các khái niệm nền tảng của Frontend Integration trên AWS:

- **React:** Thư viện JavaScript để xây dựng giao diện người dùng dạng component. Mỗi component quản lý state riêng và render lại khi state thay đổi.
- **Vite:** Build tool thế hệ mới, nhanh hơn Create React App nhờ dùng ES Modules native thay vì bundle toàn bộ khi dev.
- **Axios:** HTTP client dựa trên Promise, dùng để gọi REST API từ React đến backend. Hỗ trợ interceptors, timeout và xử lý lỗi tập trung.
- **React Router:** Thư viện điều hướng (routing) phía client cho React SPA, cho phép chuyển trang mà không reload trình duyệt.
- **CORS (Cross-Origin Resource Sharing):** Cơ chế bảo mật của trình duyệt, chặn request từ domain A gọi sang domain B trừ khi server B cho phép tường minh qua HTTP header.
- **S3 Static Hosting:** Tính năng của S3 cho phép phục vụ file HTML/CSS/JS như một website tĩnh mà không cần server. Phù hợp để deploy React app sau khi `npm run build`.

```text
Luồng dữ liệu:
  User (Browser)
    ↓  Request
  React App (S3 Static Hosting)
    ↓  Axios HTTP call (REST API)
  Backend (EC2 / Spring Boot)
    ↓  Query / Upload
  Database (RDS) + Storage (S3)
```

#### Bài tập 1: Tạo React Project với Vite

**Vite vs Create React App:**

- **CRA (Create React App):** Bundle toàn bộ code trước khi chạy dev server → khởi động chậm khi project lớn.
- **Vite:** Dùng ES Modules native của trình duyệt, chỉ transform file khi được request → khởi động gần như tức thì.

Khởi tạo project React sử dụng Vite, cài đặt các thư viện cần thiết:

```bash
npm create vite@latest ecommerce-frontend -- --template react
cd ecommerce-frontend
npm install axios
npm install react-router-dom
```

Cấu trúc thư mục project:

```text
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

> **Screenshot:** ![React project created](/images/evidence/week-08/01-react-project-created.png)

#### Bài tập 2: Kết nối API Backend (Axios)

**Axios và các HTTP method:**

| Method | Mục đích | Ví dụ |
| :--- | :--- | :--- |
| `GET` | Lấy dữ liệu | Lấy danh sách sản phẩm |
| `POST` | Tạo mới | Thêm sản phẩm, upload ảnh |
| `PUT` | Cập nhật toàn bộ | Sửa thông tin sản phẩm |
| `DELETE` | Xóa | Xóa sản phẩm |

**Service Layer Pattern:** Tách biệt logic gọi API ra khỏi component UI. Component chỉ gọi hàm từ service, không biết chi tiết HTTP bên trong → dễ bảo trì và tái sử dụng.

Tạo service layer để gọi API backend từ EC2:

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

> **Screenshot:** ![Product list from API](/images/evidence/week-08/02-product-list.png)

#### Bài tập 3: Cấu hình CORS và kiểm thử

**CORS (Cross-Origin Resource Sharing)** là cơ chế bảo mật của trình duyệt, chặn request từ một origin (domain + port) gọi sang origin khác trừ khi server phản hồi với header cho phép tường minh.

Trong project này, React (S3) và backend (EC2) chạy trên 2 domain khác nhau nên trình duyệt sẽ block request nếu không cấu hình CORS:

```text
CORS Flow:
  Browser (React on S3)  →  Preflight OPTIONS request  →  EC2 Backend
                         ←  Access-Control-Allow-Origin: *  ←
                         →  Actual GET/POST/PUT/DELETE request  →
```

Vì React chạy trên S3 domain còn backend chạy trên EC2 domain, cần cấu hình CORS trên backend:

```java
@CrossOrigin(origins = "*")
@RestController
public class ProductController { ... }
```

Kiểm thử toàn bộ luồng: thêm, sửa, xóa sản phẩm và upload ảnh lên S3.

> **Admin Page:**
> **Screenshot:** ![CORS configured](/images/evidence/week-08/03-admin-page.png)
> **Add Product:**
> **Screenshot:** ![CORS configured](/images/evidence/week-08/03-add-product.png)
> **Edit Product:**
> **Screenshot:** ![CORS configured](/images/evidence/week-08/03-edit-product.png)
> **Delete Product:**
> **Screenshot:** ![CORS configured](/images/evidence/week-08/03-delete-product.png)

#### Bài tập 4: Build & Deploy lên S3 Static Hosting

**S3 Static Hosting hoạt động như thế nào:**

- `npm run build` compile toàn bộ React app thành các file HTML/CSS/JS tĩnh trong thư mục `dist/`.
- S3 phục vụ các file này trực tiếp đến trình duyệt, không cần web server (Nginx, Apache…).
- Cần bật **Static Website Hosting** trong tab Properties của bucket và thiết lập **Index Document** là `index.html`.
- Với React Router, cần đặt **Error Document** cũng là `index.html` để các route như `/admin` không trả về 403.

Build React app và đồng bộ lên S3 bucket:

```bash
npm run build
# Tạo thư mục dist/

aws s3 sync dist/ s3://simple-ecommerce-fe-yourname/ --delete
```

> **Screenshot:** ![Frontend live on S3](/images/evidence/week-08/04-frontend-live.png)
>
> **Screenshot:** ![Frontend live on S3](/images/evidence/week-08/04-frontend-admin.png)

#### Khó khăn gặp phải

| Vấn đề | Cách giải quyết |
| :--- | :--- |
| `curl: (7) Failed to connect to port 8080` — không kết nối được backend | Mở port 8080 trên Security Group của EC2 (Inbound rules → Add rule Custom TCP 8080 source 0.0.0.0/0) |
| SSH timeout — không SSH vào được EC2 | IP máy tính thay đổi khiến rule SSH bị chặn, sửa Source của rule SSH port 22 thành IP hiện tại hoặc 0.0.0.0/0 |
| Backend không khởi động được — `Access denied for user 'admin'` | Mật khẩu RDS lưu dưới dạng biến môi trường `${DB_PASSWORD}` chưa được set, truyền thẳng qua tham số `--spring.datasource.password=...` khi chạy jar |
| Lệnh `jar` không tìm thấy trên EC2 | Dùng `unzip -p file.jar path/to/file` thay thế, cài bằng `sudo apt install unzip -y` |
| Frontend báo `Network Error` dù backend đã chạy | CORS chưa được cấu hình trên backend, thêm `CorsConfig.java` với `addCorsMappings` cho phép `allowedOriginPatterns("*")` rồi build và deploy lại jar |
| Trình duyệt báo `ERR_BLOCKED_BY_CLIENT` | Extension AdBlock/ABP chặn request đến IP EC2, mở trình duyệt ẩn danh (`Ctrl+Shift+N`) hoặc tắt extension để bypass |
| Lệnh `scp` báo `No such file or directory` | Lệnh `scp` phải chạy trên CMD Windows không phải trong SSH, dùng đường dẫn đầy đủ có dấu ngoặc kép |
| Warning `Calling setState synchronously within an effect` | Tách logic fetch ra khỏi `useEffect`, dùng biến `cancelled` để tránh update state sau khi component unmount |

## Kế hoạch tuần 9

- Tìm hiểu Docker cơ bản: image, container, Dockerfile, layer caching.
- Viết Dockerfile cho Spring Boot backend và React frontend (Nginx).
- Cấu hình `docker-compose.yml` để chạy toàn bộ stack trên local.
- Push Docker images lên Docker Hub và chạy containers trên EC2.
