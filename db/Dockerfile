FROM mongo:latest

COPY seed ./seed

ADD ./seed/user.js /docker-entrypoint-initdb.d/
ADD ./seed/import.sh /docker-entrypoint-initdb.d/
ADD ./seed/importUsers.js /docker-entrypoint-initdb.d/