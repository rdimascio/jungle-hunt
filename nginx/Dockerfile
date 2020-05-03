FROM nginx:stable-alpine

# COPY --from=server /app/build /usr/share/nginx/html
# new
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]