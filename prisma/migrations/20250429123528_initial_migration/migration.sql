-- CreateEnum
CREATE TYPE "EditingSessionStatus" AS ENUM ('draft', 'rendering', 'completed', 'failed');

-- CreateEnum
CREATE TYPE "RenderJobStatus" AS ENUM ('queued', 'processing', 'completed', 'failed');

-- CreateEnum
CREATE TYPE "EditOperationType" AS ENUM ('trim', 'subtitle', 'audio', 'text', 'image');

-- CreateEnum
CREATE TYPE "EditOperationStatus" AS ENUM ('pending', 'applied', 'failed');

-- CreateTable
CREATE TABLE "User" (
    "id" SERIAL NOT NULL,
    "username" TEXT,
    "email" TEXT,
    "password_hash" TEXT,
    "avatar_url" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Video" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER,
    "title" TEXT,
    "description" TEXT,
    "original_filename" TEXT,
    "storage_path" TEXT,
    "thumbnail_path" TEXT,
    "duration" DOUBLE PRECISION,
    "size" BIGINT,
    "mime_type" TEXT,
    "status" TEXT DEFAULT 'uploaded',
    "visibility" TEXT DEFAULT 'public',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Video_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EditingSession" (
    "id" SERIAL NOT NULL,
    "video_id" INTEGER,
    "name" TEXT,
    "status" "EditingSessionStatus" NOT NULL DEFAULT 'draft',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "EditingSession_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RenderJob" (
    "id" SERIAL NOT NULL,
    "session_id" INTEGER,
    "status" "RenderJobStatus" NOT NULL DEFAULT 'queued',
    "progress" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "error_message" TEXT,
    "job_id" TEXT,
    "priority" INTEGER NOT NULL DEFAULT 0,
    "started_at" TIMESTAMP(3),
    "completed_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "RenderJob_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EditOperation" (
    "id" SERIAL NOT NULL,
    "session_id" INTEGER,
    "operation_type" "EditOperationType" NOT NULL,
    "sequence_order" INTEGER NOT NULL,
    "params" JSONB,
    "status" "EditOperationStatus" NOT NULL DEFAULT 'pending',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "EditOperation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TextOverlay" (
    "id" SERIAL NOT NULL,
    "video_id" INTEGER,
    "session_id" INTEGER,
    "text" TEXT,
    "start_time" DOUBLE PRECISION,
    "end_time" DOUBLE PRECISION,
    "position_x" DOUBLE PRECISION,
    "position_y" DOUBLE PRECISION,
    "style" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "TextOverlay_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Subtitle" (
    "id" SERIAL NOT NULL,
    "video_id" INTEGER,
    "session_id" INTEGER,
    "text" TEXT,
    "start_time" DOUBLE PRECISION,
    "end_time" DOUBLE PRECISION,
    "position" TEXT DEFAULT 'bottom',
    "style" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Subtitle_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SharedVideo" (
    "id" SERIAL NOT NULL,
    "video_id" INTEGER,
    "user_id" INTEGER,
    "share_token" TEXT,
    "expires_at" TIMESTAMP(3),
    "access_count" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "SharedVideo_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RenderedVideo" (
    "id" SERIAL NOT NULL,
    "session_id" INTEGER,
    "video_id" INTEGER,
    "storage_path" TEXT,
    "size" BIGINT,
    "duration" DOUBLE PRECISION,
    "resolution" TEXT,
    "status" TEXT DEFAULT 'rendering',
    "render_started_at" TIMESTAMP(3),
    "render_completed_at" TIMESTAMP(3),
    "download_count" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "RenderedVideo_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ImageOverlay" (
    "id" SERIAL NOT NULL,
    "video_id" INTEGER,
    "session_id" INTEGER,
    "storage_path" TEXT,
    "start_time" DOUBLE PRECISION,
    "end_time" DOUBLE PRECISION,
    "position_x" DOUBLE PRECISION,
    "position_y" DOUBLE PRECISION,
    "width" DOUBLE PRECISION,
    "height" DOUBLE PRECISION,
    "opacity" DOUBLE PRECISION NOT NULL DEFAULT 1.0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ImageOverlay_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AudioTrack" (
    "id" SERIAL NOT NULL,
    "video_id" INTEGER,
    "session_id" INTEGER,
    "name" TEXT,
    "storage_path" TEXT,
    "duration" DOUBLE PRECISION,
    "volume" DOUBLE PRECISION NOT NULL DEFAULT 1.0,
    "start_time" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "is_original" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AudioTrack_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_username_key" ON "User"("username");

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "SharedVideo_share_token_key" ON "SharedVideo"("share_token");

-- AddForeignKey
ALTER TABLE "Video" ADD CONSTRAINT "Video_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EditingSession" ADD CONSTRAINT "EditingSession_video_id_fkey" FOREIGN KEY ("video_id") REFERENCES "Video"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RenderJob" ADD CONSTRAINT "RenderJob_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "EditingSession"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EditOperation" ADD CONSTRAINT "EditOperation_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "EditingSession"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TextOverlay" ADD CONSTRAINT "TextOverlay_video_id_fkey" FOREIGN KEY ("video_id") REFERENCES "Video"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TextOverlay" ADD CONSTRAINT "TextOverlay_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "EditingSession"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Subtitle" ADD CONSTRAINT "Subtitle_video_id_fkey" FOREIGN KEY ("video_id") REFERENCES "Video"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Subtitle" ADD CONSTRAINT "Subtitle_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "EditingSession"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SharedVideo" ADD CONSTRAINT "SharedVideo_video_id_fkey" FOREIGN KEY ("video_id") REFERENCES "Video"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SharedVideo" ADD CONSTRAINT "SharedVideo_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RenderedVideo" ADD CONSTRAINT "RenderedVideo_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "EditingSession"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RenderedVideo" ADD CONSTRAINT "RenderedVideo_video_id_fkey" FOREIGN KEY ("video_id") REFERENCES "Video"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ImageOverlay" ADD CONSTRAINT "ImageOverlay_video_id_fkey" FOREIGN KEY ("video_id") REFERENCES "Video"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ImageOverlay" ADD CONSTRAINT "ImageOverlay_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "EditingSession"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AudioTrack" ADD CONSTRAINT "AudioTrack_video_id_fkey" FOREIGN KEY ("video_id") REFERENCES "Video"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AudioTrack" ADD CONSTRAINT "AudioTrack_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "EditingSession"("id") ON DELETE CASCADE ON UPDATE CASCADE;
