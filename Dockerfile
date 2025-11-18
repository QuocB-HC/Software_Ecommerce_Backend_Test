# Stage 1: build
FROM node:20 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: production
FROM node:20-alpine
WORKDIR /app
COPY --from=builder /app ./
EXPOSE 9000
CMD ["npm", "start"]
