/*
  Warnings:

  - You are about to drop the column `idCompte` on the `Manager` table. All the data in the column will be lost.
  - You are about to drop the column `estLu` on the `Notification` table. All the data in the column will be lost.
  - You are about to drop the column `idCompte` on the `Notification` table. All the data in the column will be lost.
  - You are about to drop the column `idCompte` on the `RH` table. All the data in the column will be lost.
  - You are about to drop the `Compte` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Congé` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Employe` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Pointage` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[userId]` on the table `Manager` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[userId]` on the table `RH` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `userId` to the `Notification` table without a default value. This is not possible if the table is not empty.
  - Added the required column `userId` to the `RH` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "Congé" DROP CONSTRAINT "Congé_idCompte_fkey";

-- DropForeignKey
ALTER TABLE "Employe" DROP CONSTRAINT "Employe_idCompte_fkey";

-- DropForeignKey
ALTER TABLE "Manager" DROP CONSTRAINT "Manager_idCompte_fkey";

-- DropForeignKey
ALTER TABLE "Notification" DROP CONSTRAINT "Notification_idCompte_fkey";

-- DropForeignKey
ALTER TABLE "Pointage" DROP CONSTRAINT "Pointage_idCompte_fkey";

-- DropForeignKey
ALTER TABLE "RH" DROP CONSTRAINT "RH_idCompte_fkey";

-- DropIndex
DROP INDEX "Manager_idCompte_key";

-- DropIndex
DROP INDEX "RH_idCompte_key";

-- AlterTable
ALTER TABLE "Manager" DROP COLUMN "idCompte",
ADD COLUMN     "userId" INTEGER;

-- AlterTable
ALTER TABLE "Notification" DROP COLUMN "estLu",
DROP COLUMN "idCompte",
ADD COLUMN     "isRead" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "userId" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "RH" DROP COLUMN "idCompte",
ADD COLUMN     "userId" INTEGER NOT NULL;

-- DropTable
DROP TABLE "Compte";

-- DropTable
DROP TABLE "Congé";

-- DropTable
DROP TABLE "Employe";

-- DropTable
DROP TABLE "Pointage";

-- CreateTable
CREATE TABLE "User" (
    "id" SERIAL NOT NULL,
    "matricule" INTEGER NOT NULL,
    "supervisorId" INTEGER NOT NULL,
    "attendanceId" INTEGER NOT NULL,
    "cinNumber" INTEGER NOT NULL,
    "department" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "login" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "status" BOOLEAN NOT NULL,
    "leaveBalance" INTEGER NOT NULL DEFAULT 0,
    "role" TEXT NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Employee" (
    "id" TEXT NOT NULL,
    "poste" TEXT NOT NULL,
    "userId" INTEGER NOT NULL,

    CONSTRAINT "Employee_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Attendance" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "arrivalTime" TIMESTAMP(3) NOT NULL,
    "departureTime" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Attendance_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Leaves" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "startDate" TIMESTAMP(3) NOT NULL,
    "endDate" TIMESTAMP(3) NOT NULL,
    "status" TEXT NOT NULL,
    "isHalfDay" BOOLEAN NOT NULL DEFAULT false,
    "type" TEXT NOT NULL,
    "reason" TEXT NOT NULL,

    CONSTRAINT "Leaves_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_cinNumber_key" ON "User"("cinNumber");

-- CreateIndex
CREATE UNIQUE INDEX "User_login_key" ON "User"("login");

-- CreateIndex
CREATE UNIQUE INDEX "Employee_userId_key" ON "Employee"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Manager_userId_key" ON "Manager"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "RH_userId_key" ON "RH"("userId");

-- AddForeignKey
ALTER TABLE "Employee" ADD CONSTRAINT "Employee_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Manager" ADD CONSTRAINT "Manager_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RH" ADD CONSTRAINT "RH_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Attendance" ADD CONSTRAINT "Attendance_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Leaves" ADD CONSTRAINT "Leaves_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
