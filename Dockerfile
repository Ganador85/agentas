FROM debian:bookworm-slim
ENV DEBIAN_FRONTEND=noninteractive DISPLAY=:99 LANG=lt_LT.UTF-8 LC_ALL=lt_LT.UTF-8

RUN apt-get update && apt-get install -y \
  curl wget gnupg ca-certificates supervisor xvfb x11vnc fluxbox websockify novnc \
  locales fonts-liberation nginx \
 && sed -i 's/# lt_LT.UTF-8 UTF-8/lt_LT.UTF-8 UTF-8/' /etc/locale.gen && locale-gen \
 && curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google.gpg \
 && echo "deb [signed-by=/usr/share/keyrings/google.gpg] http://dl.google.com/linux/chrome/deb/ stable main" >/etc/apt/sources.list.d/google.list \
 && apt-get update && apt-get install -y google-chrome-stable \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 7900 9222
CMD ["supervisord","-n"]
