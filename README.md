### Inception

(TR)
## Proje Hakkında
Bu proje, 42 eğitim programı kapsamında Docker ve Docker Compose kullanarak bütün bir sistem altyapısını kodla ayağa kaldırmayı amaçlar. Tüm servisler (Nginx, MariaDB, WordPress) Alpine Linux tabanlı özel Dockerfile'lar ile oluşturulmuştur.

## Altyapı Mimarisi
- **Nginx**: Reverse proxy olarak TLSv1.2/1.3 protokolü ile yapılandırılmış, TLS/SSL sertifikaları ile güvenli bağlantı sağlayan giriş noktası.
- **WordPress + PHP-FPM**: NGINX ile iletişim kuran, içerik yönetim sistemi ve PHP işleme birimi.
- **MariaDB**: WordPress için optimize edilmiş veritabanı sunucusu.
- **Docker Compose**: Tüm servisleri tek bir komutla başlatan yapılandırma.
- **Docker Volumes**: Veritabanı ve web dosyaları için kalıcı depolama.
- **Docker Network**: Servisler arası güvenli ve kapalı ağ iletişimi.

## Özellikler
- Hazır Docker Hub imajları kullanılmamış, tüm imajlar Dockerfile üzerinden inşa edilmiştir.
- SSL sertifikaları ile güvenli (HTTPS) bağlantı sağlanmıştır.
- `Makefile` üzerinden tek komutla tüm sistem ayağa kaldırılabilir.

## Kurulum ve Kullanım

1. **Repoyu klonlayın**
   ```bash
   git clone https://github.com/KubraNurGulfidan/42-inception.git
   cd 42-inception```
2. **Yapılandırma**
   .env dosyasında istenen gerekli veritabanı/kullanıcı bilgilerini girin.
   secrets klasörü içerisindeki dosyalarda istenenleri (şifre belirleme) yapın.
3. **Çalıştırma**
   ```bash
   make
4. **Container ve log kontrolü**
   ```bash
   make ps
   make log```
5. **Erişim**
   https://login.42.fr (Not: /etc/hosts dosyanıza 127.0.0.1 login.42.fr satırını eklemeyi unutmayın.)

(EN)
## About the Project
This project aims to deploy a complete system infrastructure using Docker and Docker Compose as part of the 42 curriculum. All services (Nginx, MariaDB, WordPress) are built with custom Dockerfiles based on Alpine Linux.

## Infrastructure Architecture
- **Nginx**: Entry point configured as a reverse proxy with TLSv1.2/1.3, providing secure connections via SSL certificates.
- **WordPress + PHP-FPM**: Content management system and PHP processing unit communicating with NGINX.
- **MariaDB**: Database server optimized for WordPress.
- **Docker Compose**: Configuration that starts all services with a single command.
- **Volumes & Network**: Persistent storage for data and secure internal communication between containers.

## Key Features
- No ready-made Docker Hub images were used; all images were built via custom Dockerfiles.
- Secure (HTTPS) connection provided via self-signed SSL certificates.
- The entire system can be deployed with a single command via `Makefile`.

## Installation & Usage

1. **Clone the repo:**
   ```bash
   git clone https://github.com/KubraNurGulfidan/42-inception.git
   cd 42-inception```
2. **Configuration**
   Fill in the required database/user credentials in the .env file and set passwords in the secrets folder.
3. **Run**
   ```bash
   make```
4. **Container & log**
   ```bash
   make ps
   make log```
5. **Access**
   https://login.42.fr (Note: Don't forget to add 127.0.0.1 login.42.fr to your /etc/hosts file.)
