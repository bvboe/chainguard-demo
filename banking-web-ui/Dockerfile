FROM node:26 AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

RUN npm run build

FROM node:26 AS runtime

WORKDIR /app

COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/node_modules/.package-lock.json /app/node_modules/.package-lock.json

EXPOSE 3000

CMD ["node", "server.js"]
