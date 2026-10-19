# --- Step 1: Base/Build Stage ---
FROM node:22-alpine AS builder
WORKDIR /usr/src/app

COPY package*.json ./
# Install ALL dependencies (including devDependencies if you use a build step later)
RUN npm ci

COPY . .

# --- Step 2: Production Stage ---
FROM node:22-alpine AS runner
WORKDIR /usr/src/app

# Set production environment variable
ENV NODE_ENV=production

COPY package*.json ./
# Install only production dependencies
RUN npm ci --only=production

# Copy source files from the host or build stage
COPY --from=builder /usr/src/app/server.js ./server.js

# Run as non-root user for security
USER node

EXPOSE 3000

CMD ["node", "server.js"]

