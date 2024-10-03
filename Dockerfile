# Étape 1 : Construction de l'image
FROM node:18 AS builder

# Définit le répertoire de travail
WORKDIR /app

# Copie les fichiers de package
COPY package.json package-lock.json ./

# Installe les dépendances
RUN npm install

# Copie le reste des fichiers de l'application
COPY . .

# Construire l'application
RUN npm run build

# Étape 2 : Création de l'image finale
FROM node:18 AS runner

# Définit le répertoire de travail
WORKDIR /app

# Copie uniquement les fichiers nécessaires
COPY --from=builder /app/package.json ./
COPY --from=builder /app/package-lock.json ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules

# Expose le port sur lequel l'application va écouter
EXPOSE 3000

# Commande pour démarrer l'application
CMD ["npm", "start"]
