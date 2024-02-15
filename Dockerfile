# production environment
FROM nginx:stable-alpine
WORKDIR /usr/share/nginx/html
COPY . .

#RUN chmod +x ./supercronic-linux-amd64 && mv ./supercronic-linux-amd64 /bin/supercronic-linux-amd64 && ln -s /bin/supercronic-linux-amd64 /bin/supercronic
RUN chmod +x ./supercronic-linux-arm64 && mv ./supercronic-linux-arm64 /bin/supercronic-linux-arm64 && ln -s /bin/supercronic-linux-arm64 /bin/supercronic

# Default port exporsure
EXPOSE 80

# Make our shell script executable
RUN chmod +x init.sh scripts.sh

# Start Nginx server
CMD ["/bin/sh", "-c", "/usr/share/nginx/html/init.sh && nginx -g \"daemon off;\""]