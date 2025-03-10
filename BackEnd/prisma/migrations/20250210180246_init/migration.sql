/*
  Warnings:

  - You are about to drop the `User` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropTable
DROP TABLE "User";

-- CreateTable
CREATE TABLE "Compte" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "login" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "status" BOOLEAN NOT NULL,
    "azureId" INTEGER NOT NULL,
    "dateCreation" TIMESTAMP(3) NOT NULL,
    "role" TEXT NOT NULL,
    "equipeId" INTEGER,
    "poste" TEXT,
    "dateEmbauche" TIMESTAMP(3),

    CONSTRAINT "Compte_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Equipe" (
    "id" SERIAL NOT NULL,
    "nom" TEXT NOT NULL,
    "responsableId" INTEGER NOT NULL,

    CONSTRAINT "Equipe_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Pointage" (
    "id" SERIAL NOT NULL,
    "compteId" INTEGER NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "heureArrivee" TIMESTAMP(3) NOT NULL,
    "heureDepart" TIMESTAMP(3) NOT NULL,
    "heureSupplementaire" INTEGER NOT NULL,
    "heuresTravaillées" INTEGER NOT NULL,

    CONSTRAINT "Pointage_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Notification" (
    "id" SERIAL NOT NULL,
    "destinataireId" INTEGER NOT NULL,
    "msg" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "dateEnvoi" TIMESTAMP(3) NOT NULL,
    "statutLecture" BOOLEAN NOT NULL,

    CONSTRAINT "Notification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Rapport" (
    "id" SERIAL NOT NULL,
    "rhId" INTEGER NOT NULL,
    "titre" TEXT NOT NULL,
    "dateGeneration" TIMESTAMP(3) NOT NULL,
    "Contenu" TEXT NOT NULL,
    "type" TEXT NOT NULL,

    CONSTRAINT "Rapport_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Congés" (
    "id" SERIAL NOT NULL,
    "compteId" INTEGER NOT NULL,
    "type" TEXT NOT NULL,
    "dateDebut" TIMESTAMP(3) NOT NULL,
    "dateFin" TIMESTAMP(3) NOT NULL,
    "status" TEXT NOT NULL,
    "dateDemande" TIMESTAMP(3) NOT NULL,
    "raison" TEXT NOT NULL,

    CONSTRAINT "Congés_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Compte_login_key" ON "Compte"("login");

-- AddForeignKey
ALTER TABLE "Compte" ADD CONSTRAINT "Compte_equipeId_fkey" FOREIGN KEY ("equipeId") REFERENCES "Equipe"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Pointage" ADD CONSTRAINT "Pointage_compteId_fkey" FOREIGN KEY ("compteId") REFERENCES "Compte"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_destinataireId_fkey" FOREIGN KEY ("destinataireId") REFERENCES "Compte"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Rapport" ADD CONSTRAINT "Rapport_rhId_fkey" FOREIGN KEY ("rhId") REFERENCES "Compte"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Congés" ADD CONSTRAINT "Congés_compteId_fkey" FOREIGN KEY ("compteId") REFERENCES "Compte"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
