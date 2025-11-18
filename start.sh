#!/bin/bash

# Thiết lập quyền thực thi cho script (Quan trọng)
chmod +x start.sh

echo "Running database migrations..."
npx medusa db:migrate

echo "Seeding database..."
# Chạy seeding, nếu thất bại thì vẫn tiếp tục
npm run seed || echo "Seeding failed or already done, continuing..."

echo "Starting Medusa production server..."
# Khởi động server ở chế độ production
npm start


# #!/bin/sh

# # Run migrations and start server
# echo "Running database migrations..."
# npx medusa db:migrate

# echo "Seeding database..."
# npm run seed || echo "Seeding failed, continuing..."

# echo "Starting Medusa development server..."
# npm run dev