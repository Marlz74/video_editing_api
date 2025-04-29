# Video Editing Platform Backend

A Node.js-based REST API for uploading, editing, rendering, and managing videos. The platform supports video uploads, trimming, subtitle addition, rendering with FFmpeg, and downloading rendered videos. It includes features like render job status tracking and paginated video retrieval, with robust error handling and Swagger documentation.

## Table of Contents
- [Features](#features)
- [Technologies](#technologies)
- [Prerequisites](#prerequisites)
- [Setup Instructions](#setup-instructions)
- [Environment Variables](#environment-variables)
- [API Endpoints](#api-endpoints)
- [Notes](#notes)
- [Running the Application](#running-the-application)
- [Testing](#testing)
- [License](#license)

## Features
- **Video Upload**: Upload videos (MP4, MKV, AVI, MOV, WEBM) with title and description, stored locally with metadata extraction via FFmpeg.
- **Video Editing**:
  - Trim videos by specifying start and end times.
  - Add subtitles with customizable text, timing, and position.
- **Video Rendering**: Queue and process render jobs using BullMQ and FFmpeg.
- **Video Download**: Download rendered videos with download count tracking.
- **Render Status**: Check the status of render jobs (queued, processing, completed, failed).
- **Paginated Video List**: Retrieve videos with pagination (page, limit).
- **Robust Error Handling**: Graceful handling of invalid inputs and errors.
- **Swagger Documentation**: Available at `/api-docs`.
- **Prisma ORM**: PostgreSQL database management.
- **Redis Queue**: BullMQ for job queue.
- **Swagger Documentation**: Available at `/api-docs`.
- **Swagger Documentation**: Interactive API docs available [here](http://localhost:3000/api-docs/#/) when running locally.



## Technologies
- **Node.js**
- **Express.js**
- **Prisma** (with PostgreSQL)
- **Redis**
- **FFmpeg**
- **BullMQ**
- **Swagger** (`swagger-jsdoc`, `swagger-ui-express`)
- **Multer**
- **Nodemon**

## Prerequisites
- Node.js 18.x or higher
- PostgreSQL 13.x or higher
- Redis 6.x or higher
- FFmpeg installed
- Git

## Setup Instructions

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/Marlz74/video_editing_api.git
   cd fallon_video_api


2. **Install Dependencies**:
   ```bash
   npm install
   ```

3. **Install FFmpeg**:

   - Ubuntu/Debian:
     ```bash
     sudo apt-get update
     sudo apt-get install ffmpeg
     ```

   - macOS (Homebrew):
     ```bash
     brew install ffmpeg
     ```

   - Verify:
     ```bash
     ffmpeg -version
     ```

4. **Set Up PostgreSQL**:

   - Create a database:
     ```bash
     psql -U postgres
     CREATE DATABASE video_editing_platform;
     \q
     ```

5. **Install Redis**:

   - Ubuntu/Debian:
     ```bash
     sudo apt-get install redis-server
     sudo systemctl enable redis
     sudo systemctl start redis
     ```

   - macOS (Homebrew):
     ```bash
     brew install redis
     brew services start redis
     ```

   - Verify:
     ```bash
     redis-cli ping
     # Output: PONG
     ```

6. **Configure Environment Variables**:

   - Copy example and edit:
     ```bash
     cp .env.example .env
     ```

   - Update values (see [Environment Variables](#environment-variables))

7. **Run Prisma Migrations**:
   ```bash
   npx prisma migrate dev
   npx prisma generate
   ```

8. **Start the Development Server**:
   ```bash
   npm run dev
   ```

   - API is available at: `http://localhost:3000`

9. **Start the Render Worker** (in a new terminal):
   ```bash
   node src/services/renderWorker.js
   ```

10. **Open Swagger Docs**:
    - Visit: `http://localhost:3000/api-docs`

## Environment Variables

`.env` file:

```env
# Database connection (PostgreSQL)
DATABASE_URL="postgresql://username:password@localhost:5432/video_editing_platform?schema=public"

# Server port
PORT=3000

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379
```

## API Endpoints

All endpoints are under `/api/v1`. Test interactively via `/api-docs`.

| Method | Endpoint                        | Description                        | Body / Params |
|--------|----------------------------------|------------------------------------|---------------|
| POST   | /videos/upload                  | Upload a video                     | Form-data: `video`, `title`, `description` |
| POST   | /videos/{id}/trim               | Add trim operation                 | JSON: `{ "start": number, "end": number }` |
| POST   | /videos/{id}/subtitles          | Add subtitle                       | JSON: `{ "text": string, "start_time": number, "end_time": number, "position": string }` |
| POST   | /videos/{id}/render             | Queue render job                   | None |
| GET    | /videos/{id}/download           | Download rendered video            | None |
| GET    | /videos/{id}/render/status      | Get render job status              | None |
| GET    | /videos                         | Paginated video list               | Query: `page`, `limit` |

## Example Requests

- **Upload Video**:
  ```bash
  curl -X POST http://localhost:3000/api/v1/videos/upload \
  -F "video=@/path/to/sample.mp4" \
  -F "title=Test Video" \
  -F "description=Sample description"
  ```

- **Trim Video**:
  ```bash
  curl -X POST http://localhost:3000/api/v1/videos/2/trim \
  -H "Content-Type: application/json" \
  -d '{"start": 0, "end": 20}'
  ```

- **Get Render Status**:
  ```bash
  curl http://localhost:3000/api/v1/videos/2/render/status
  ```

- **Get Paginated Videos**:
  ```bash
  curl http://localhost:3000/api/v1/videos?page=1&limit=5
  ```

## Notes

- **BigInt Serialization**: Prisma BigInt fields are converted to strings to prevent JSON serialization issues.
- **Error Handling**:
  - Handles missing `req.body`, bad inputs.
  - Converts string numbers (e.g. `"0"`) to actual numbers.

## Running the Application

- **Start server**: `npm run dev`
- **Start worker**: `node src/services/renderWorker.js`

## Testing

To be added (include unit tests and integration tests setup).

## License

MIT License
```

---

Would you like a visual version of this documentation (e.g., a hosted Swagger screenshot or a README preview)?