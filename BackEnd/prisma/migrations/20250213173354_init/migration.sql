/*
  Warnings:

  - You are about to drop the column `azureId` on the `Compte` table. All the data in the column will be lost.
  - You are about to drop the column `dateCreation` on the `Compte` table. All the data in the column will be lost.
  - You are about to drop the column `dateEmbauche` on the `Compte` table. All the data in the column will be lost.
  - You are about to drop the column `equipeId` on the `Compte` table. All the data in the column will be lost.
  - You are about to drop the column `login` on the `Compte` table. All the data in the column will be lost.
  - You are about to drop the column `name` on the `Compte` table. All the data in the column will be lost.
  - You are about to drop the column `password` on the `Compte` table. All the data in the column will be lost.
  - You are about to drop the column `poste` on the `Compte` table. All the data in the column will be lost.
  - You are about to drop the column `dateEnvoi` on the `Notification` table. All the data in the column will be lost.
  - You are about to drop the column `destinataireId` on the `Notification` table. All the data in the column will be lost.
  - You are about to drop the column `msg` on the `Notification` table. All the data in the column will be lost.
  - You are about to drop the column `statutLecture` on the `Notification` table. All the data in the column will be lost.
  - You are about to drop the column `type` on the `Notification` table. All the data in the column will be lost.
  - You are about to drop the column `compteId` on the `Pointage` table. All the data in the column will be lost.
  - You are about to drop the column `heureSupplementaire` on the `Pointage` table. All the data in the column will be lost.
  - You are about to drop the column `heuresTravaillées` on the `Pointage` table. All the data in the column will be lost.
  - You are about to drop the `Congés` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Equipe` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Rapport` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[numeroCIN]` on the table `Compte` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[email]` on the table `Compte` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `departement` to the `Compte` table without a default value. This is not possible if the table is not empty.
  - Added the required column `email` to the `Compte` table without a default value. This is not possible if the table is not empty.
  - Added the required column `idSociete` to the `Compte` table without a default value. This is not possible if the table is not empty.
  - Added the required column `idSuperviseur` to the `Compte` table without a default value. This is not possible if the table is not empty.
  - Added the required column `motDePasse` to the `Compte` table without a default value. This is not possible if the table is not empty.
  - Added the required column `nom` to the `Compte` table without a default value. This is not possible if the table is not empty.
  - Added the required column `numeroCIN` to the `Compte` table without a default value. This is not possible if the table is not empty.
  - Added the required column `idCompte` to the `Notification` table without a default value. This is not possible if the table is not empty.
  - Added the required column `message` to the `Notification` table without a default value. This is not possible if the table is not empty.
  - Added the required column `idCompte` to the `Pointage` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "Compte" DROP CONSTRAINT "Compte_equipeId_fkey";

-- DropForeignKey
ALTER TABLE "Congés" DROP CONSTRAINT "Congés_compteId_fkey";

-- DropForeignKey
ALTER TABLE "Notification" DROP CONSTRAINT "Notification_destinataireId_fkey";

-- DropForeignKey
ALTER TABLE "Pointage" DROP CONSTRAINT "Pointage_compteId_fkey";

-- DropForeignKey
ALTER TABLE "Rapport" DROP CONSTRAINT "Rapport_rhId_fkey";

-- DropIndex
DROP INDEX "Compte_login_key";

-- AlterTable
ALTER TABLE "Compte" DROP COLUMN "azureId",
DROP COLUMN "dateCreation",
DROP COLUMN "dateEmbauche",
DROP COLUMN "equipeId",
DROP COLUMN "login",
DROP COLUMN "name",
DROP COLUMN "password",
DROP COLUMN "poste",
ADD COLUMN     "departement" TEXT NOT NULL,
ADD COLUMN     "email" TEXT NOT NULL,
ADD COLUMN     "idSociete" INTEGER NOT NULL,
ADD COLUMN     "idSuperviseur" INTEGER NOT NULL,
ADD COLUMN     "motDePasse" TEXT NOT NULL,
ADD COLUMN     "nom" TEXT NOT NULL,
ADD COLUMN     "numeroCIN" INTEGER NOT NULL,
ADD COLUMN     "soldeConges" INTEGER NOT NULL DEFAULT 0;

-- AlterTable
ALTER TABLE "Notification" DROP COLUMN "dateEnvoi",
DROP COLUMN "destinataireId",
DROP COLUMN "msg",
DROP COLUMN "statutLecture",
DROP COLUMN "type",
ADD COLUMN     "estLu" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "idCompte" INTEGER NOT NULL,
ADD COLUMN     "message" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "Pointage" DROP COLUMN "compteId",
DROP COLUMN "heureSupplementaire",
DROP COLUMN "heuresTravaillées",
ADD COLUMN     "idCompte" INTEGER NOT NULL;

-- DropTable
DROP TABLE "Congés";

-- DropTable
DROP TABLE "Equipe";

-- DropTable
DROP TABLE "Rapport";

-- CreateTable
CREATE TABLE "Employe" (
    "matricule" TEXT NOT NULL,
    "poste" TEXT NOT NULL,
    "idCompte" INTEGER NOT NULL,

    CONSTRAINT "Employe_pkey" PRIMARY KEY ("matricule")
);

-- CreateTable
CREATE TABLE "Manager" (
    "id" TEXT NOT NULL,
    "idCompte" INTEGER NOT NULL,

    CONSTRAINT "Manager_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RH" (
    "id" TEXT NOT NULL,
    "idCompte" INTEGER NOT NULL,

    CONSTRAINT "RH_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Congé" (
    "id" SERIAL NOT NULL,
    "idCompte" INTEGER NOT NULL,
    "dateDebut" TIMESTAMP(3) NOT NULL,
    "dateFin" TIMESTAMP(3) NOT NULL,
    "statut" TEXT NOT NULL,
    "demiJournee" BOOLEAN NOT NULL DEFAULT false,
    "type" TEXT NOT NULL,
    "raison" TEXT NOT NULL,

    CONSTRAINT "Congé_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Employe_idCompte_key" ON "Employe"("idCompte");

-- CreateIndex
CREATE UNIQUE INDEX "Manager_idCompte_key" ON "Manager"("idCompte");

-- CreateIndex
CREATE UNIQUE INDEX "RH_idCompte_key" ON "RH"("idCompte");

-- CreateIndex
CREATE UNIQUE INDEX "Compte_numeroCIN_key" ON "Compte"("numeroCIN");

-- CreateIndex
CREATE UNIQUE INDEX "Compte_email_key" ON "Compte"("email");

-- AddForeignKey
ALTER TABLE "Employe" ADD CONSTRAINT "Employe_idCompte_fkey" FOREIGN KEY ("idCompte") REFERENCES "Compte"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Manager" ADD CONSTRAINT "Manager_idCompte_fkey" FOREIGN KEY ("idCompte") REFERENCES "Compte"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RH" ADD CONSTRAINT "RH_idCompte_fkey" FOREIGN KEY ("idCompte") REFERENCES "Compte"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Pointage" ADD CONSTRAINT "Pointage_idCompte_fkey" FOREIGN KEY ("idCompte") REFERENCES "Compte"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_idCompte_fkey" FOREIGN KEY ("idCompte") REFERENCES "Compte"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Congé" ADD CONSTRAINT "Congé_idCompte_fkey" FOREIGN KEY ("idCompte") REFERENCES "Compte"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
