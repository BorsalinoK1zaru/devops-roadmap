FROM nginx:latest

LABEL project="devops-roadmap"
LABEL lesson="day-05-layers-cache"

RUN mkdir -p /usr/share/nginx/html/pages

COPY index.html /usr/share/nginx/html/index.html
COPY about.html /usr/share/nginx/html/pages/about.html
