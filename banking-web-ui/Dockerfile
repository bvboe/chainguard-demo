FROM cgr.dev/chainguard/node:latest-dev AS builder

WORKDIR /app

COPY package*.json .npmrc ./
RUN --mount=type=secret,id=cg_npm_auth_b64,env=CG_NPM_AUTH_B64 npm ci

COPY . .

RUN npm run build

FROM cgr.dev/chainguard/node:latest AS runtime

WORKDIR /app

COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/node_modules/.package-lock.json /app/node_modules/.package-lock.json

EXPOSE 3000

CMD ["server.js"]
