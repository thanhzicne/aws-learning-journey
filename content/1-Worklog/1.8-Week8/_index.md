---
title: "Week 8 Worklog"
date: 2026-05-14
weight: 8
chapter: false
pre: " <b> 1.8. </b> "
---

## Week 8 Objectives

- Build a React frontend (Vite) and connect it to the backend API (Axios).
- Display a product list with images served from S3.
- Implement add/edit/delete product pages.
- Deploy the frontend to S3 Static Hosting.

### Tasks for This Week

| Day | Task | Start Date | End Date | Reference |
| --- | --- | --- | --- | --- |
| Mon | Create React project with Vite, configure project structure, install Axios and React Router | 08/06/2026 | 08/06/2026 | [Frontend Development for Serverless APIs](https://000079.awsstudygroup.com) |
| Tue | Connect backend API (Axios), display product list with S3 images | 09/06/2026 | 09/06/2026 | [Frontend Development for Serverless APIs](https://000079.awsstudygroup.com) |
| Wed | **Practice Frontend:** Implement add/edit/delete product pages, handle image upload | 10/06/2026 | 10/06/2026 | [Frontend Integration with API Gateway](https://000135.awsstudygroup.com) |
| Thu | Configure CORS on backend, handle errors and test the full flow | 11/06/2026 | 11/06/2026 | [Frontend Development for Serverless APIs – Config CORS](https://000079.awsstudygroup.com/4-config-api-gw/4-2-setting-and-cors/) |
| Fri | Build & deploy frontend to S3 Static Hosting. Review, write worklog report, plan Week 9 | 12/06/2026 | 12/06/2026 | [Static Website Hosting with Amazon S3](https://000057.awsstudygroup.com) |

### Week 8 Results

Key concepts learned in Frontend Integration on AWS:

- **React:** A JavaScript library for building component-based user interfaces. Each component manages its own state and re-renders when state changes.
- **Vite:** A next-generation build tool that is much faster than Create React App by leveraging native ES Modules instead of bundling everything at dev time.
- **Axios:** A Promise-based HTTP client used to call REST APIs from React to the backend. Supports interceptors, timeouts, and centralized error handling.
- **React Router:** A client-side routing library for React SPAs, enabling page navigation without full browser reloads.
- **CORS (Cross-Origin Resource Sharing):** A browser security mechanism that blocks requests from one origin (domain + port) to another unless the server explicitly allows it via HTTP headers.
- **S3 Static Hosting:** An S3 feature that serves HTML/CSS/JS files as a static website without requiring a server. Ideal for deploying a React app after `npm run build`.

```text
Data Flow:
  User (Browser)
    ↓  Request
  React App (S3 Static Hosting)
    ↓  Axios HTTP call (REST API)
  Backend (EC2 / Spring Boot)
    ↓  Query / Upload
  Database (RDS) + Storage (S3)
```

#### Exercise 1: Create React Project with Vite

**Vite vs Create React App:**

- **CRA (Create React App):** Bundles all code before starting the dev server → slow startup on large projects.
- **Vite:** Uses the browser's native ES Modules and only transforms files on request → near-instant startup.

Initialized a React project using Vite and installed the required libraries:

```bash
npm create vite@latest ecommerce-frontend -- --template react
cd ecommerce-frontend
npm install axios
npm install react-router-dom
```

Project folder structure:

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

#### Exercise 2: Connect Backend API (Axios)

**Axios and HTTP Methods:**

| Method | Purpose | Example |
| :--- | :--- | :--- |
| `GET` | Fetch data | Get product list |
| `POST` | Create new resource | Add product, upload image |
| `PUT` | Full update | Edit product details |
| `DELETE` | Remove resource | Delete a product |

**Service Layer Pattern:** Separates API-call logic from UI components. Components only call functions from the service layer without knowing the HTTP details inside — making code easier to maintain and reuse.

Created a service layer to call the backend API running on EC2:

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

#### Exercise 3: Configure CORS and Test

**CORS (Cross-Origin Resource Sharing)** is a browser security mechanism that blocks requests from one origin (domain + port) to another unless the server responds with explicit allow headers.

In this project, React (on S3) and the backend (on EC2) run on two different domains, so the browser will block requests unless CORS is configured:

```text
CORS Flow:
  Browser (React on S3)  →  Preflight OPTIONS request  →  EC2 Backend
                         ←  Access-Control-Allow-Origin: *  ←
                         →  Actual GET/POST/PUT/DELETE request  →
```

Since React runs on the S3 domain and the backend runs on an EC2 domain, CORS must be configured on the backend:

```java
@CrossOrigin(origins = "*")
@RestController
public class ProductController { ... }
```

Tested the complete flow: adding, editing, and deleting products as well as uploading images to S3.

> **Screenshot:** ![CORS configured](/images/evidence/week-08/03-cors-configured.png)

#### Exercise 4: Build & Deploy to S3 Static Hosting

**How S3 Static Hosting works:**

- `npm run build` compiles the entire React app into static HTML/CSS/JS files inside the `dist/` folder.
- S3 serves these files directly to the browser — no web server (Nginx, Apache…) required.
- **Static Website Hosting** must be enabled under the bucket's Properties tab, with **Index Document** set to `index.html`.
- For React Router, set the **Error Document** to `index.html` as well, so routes like `/admin` don't return a 403 error.

Built the React app and synced it to the S3 bucket:

```bash
npm run build
# Generates the dist/ folder

aws s3 sync dist/ s3://simple-ecommerce-fe-yourname/ --delete
```

> **Screenshot:** ![Frontend live on S3](/images/evidence/week-08/04-frontend-live.png)

#### Challenges Encountered

| Problem | Solution |
| :--- | :--- |
| CORS error when React called the EC2 API | Added `@CrossOrigin(origins = "*")` to the backend controller |
| S3 images not displaying on the frontend | Checked the Bucket Policy and Public Access settings on the S3 bucket |
| React Router not working after S3 deployment | Set the Error Document to `index.html` in S3 Static Hosting settings |

## Week 9 Plan

- Learn about Amazon CloudFront and how to distribute static content.
- Attach a CloudFront distribution to the S3 frontend bucket.
- Configure a Custom Domain and SSL certificate using ACM.
- Optimize performance with caching policies.
