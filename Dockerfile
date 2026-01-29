FROM node:18-slim AS builder

WORKDIR /app

# Ferramentas de sistema necessárias
RUN apt-get update && apt-get install -y python3 make g++

COPY package*.json ./
COPY tsconfig*.json ./

RUN npm install

COPY . .

RUN npm run build

# --- Estágio Final ---
FROM node:18-slim

WORKDIR /app

ENV NODE_ENV=production

# Certificados para a API do Google funcionar
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules

CMD ["node", "dist/index.js"]