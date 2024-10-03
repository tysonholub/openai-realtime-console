FROM node:20

WORKDIR /app

COPY package.json .
COPY package-lock.json .
COPY tsconfig.json .
COPY .eslintrc.json .
COPY .prettierrc .

RUN npm install

COPY src/ src/
COPY relay-server/ relay-server/
COPY public/ public/

CMD ["echo use 'npm start' or 'npm run relay' to start the client or relay server"]