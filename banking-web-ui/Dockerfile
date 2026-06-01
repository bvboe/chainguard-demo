FROM cgr.dev/chainguard/node:latest-dev AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

RUN npm run build

FROM cgr.dev/chainguard/node:latest AS runtime

WORKDIR /app

COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static

EXPOSE 3000

CMD ["server.js"]
