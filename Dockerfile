# === GIAI ĐOẠN 1: BUILDER (Cài đặt & Build) ===
FROM node:20 AS builder

# Thiết lập thư mục làm việc
WORKDIR /app

# Tận dụng cache: Chỉ COPY các tệp package.json
COPY package.json package-lock.json ./

# Cài đặt tất cả dependencies
RUN npm install

# Sao chép toàn bộ mã nguồn còn lại
COPY . .

# Chạy lệnh build 
RUN npm run build

# Cấp quyền thực thi cho start.sh 
RUN chmod +x ./start.sh


# === GIAI ĐOẠN 2: PRODUCTION (Môi trường Runtime nhỏ gọn) ===
FROM node:20-alpine AS production

# Thiết lập biến môi trường
ENV NODE_ENV production
WORKDIR /app

# 1. Sao chép CÁC TỆP CẦN THIẾT cho việc cài đặt dependencies lại
COPY --from=builder /app/package.json /app/package-lock.json ./

# 2. Cài đặt LẠI dependencies, CHỈ CÁC GÓI PRODUCTION
RUN npm install --only=production

# 3. Sao chép toàn bộ mã nguồn đã được build/biên dịch từ stage builder
COPY --from=builder /app .

# Cấu hình cổng
EXPOSE 9000

# Lệnh khởi chạy: Chạy script để xử lý migration trước khi start server
CMD ["./start.sh"]



# # Stage 1: build
# FROM node:20 AS builder
# WORKDIR /app
# COPY package*.json ./
# RUN npm install
# COPY . .
# RUN npm run build

# # Stage 2: production
# FROM node:20-alpine
# WORKDIR /app
# COPY --from=builder /app ./
# EXPOSE 9000
# CMD ["npm", "start"]
