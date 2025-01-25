workspace {

    model {
        user = person "Клиент" "Использует приложение Road Warrior."
        admin = person "Администратор" "Управляет приложением Road Warrior."

        RoadWarrior = softwareSystem "Road Warrior" "Сервис доставки." {
            webAppContainer = container "Web Application" "Интерфейс для клиентов." "Spring Boot"
            api = container "DashbordService" "Основная бизнес-логика приложения." "Golang"
            adminService = container "Admin API" "API для администраторов." "Golang"
            adminWebApp = container "Admin Web" "Интерфейс для администраторов." "Vue"
            primaryDb = container "Primary Database" "База данных для записи." "PostgreSQL"
            replicaDb = container "Replica Database" "База данных для чтения." "PostgreSQL"
            nginx = container "Api GateWay" "API шлюз." "NGINX"
            spa = container "Single-Page Application" "Одностраничное приложение." "Vue"
            pwa = container "Progressive Web Application" "Прогрессивное веб-приложение." "Vue"
            redis = container "Cache" "Кэш приложения." "Redis"
            queue = container "Broker" "Очередь для взаимодействия сервисов." "Kafka"
            apiAdaptersOne = container "Integrations Container One" "Интеграционный контейнер 1."
            apiAdaptersTwo = container "Integrations Container Two" "Интеграционный контейнер 2."
            apiAdaptersThree = container "Integrations Container Three" "Интеграционный контейнер 3."
            thirdPartySystems = container "Third-Party Systems" "Сторонние системы."
            socialMediaService = container "Social Media Integration Service" "Сервис интеграции с социальными сетями."
            authService = container "JWT Auth Service" "Сервис аутентификации JWT."
        }

        user -> webAppContainer "Использует"
        user -> spa "Использует"
        user -> pwa "Использует"
        admin -> adminWebApp "Использует"

        webAppContainer -> api "Использует"
        spa -> nginx "Делает API вызовы" "JSON/HTTPS"
        pwa -> nginx "Делает API вызовы" "JSON/HTTPS"
        adminWebApp -> nginx "Делает API вызовы" "JSON/HTTPS"
        nginx -> api "Перенаправляет запросы" "JSON/HTTPS"
        api -> primaryDb "Записывает в"
        api -> replicaDb "Читает из"
        primaryDb -> replicaDb "Реплицирует данные в"
        api -> redis "Кэширует" "JSON"
        redis -> api "Читает из кэша" "JSON"
        api -> queue "Отправляет сообщения" "JSON"
        queue -> api "Получает сообщения" "JSON"
        queue -> apiAdaptersOne "Отправляет сообщения" "JSON"
        queue -> apiAdaptersTwo "Отправляет сообщения" "JSON"
        queue -> apiAdaptersThree "Отправляет сообщения" "JSON"
        apiAdaptersOne -> thirdPartySystems "Интеграция данных" "JSON/XML/GRPC"
        apiAdaptersTwo -> thirdPartySystems "Интеграция данных" "JSON/XML/GRPC"
        apiAdaptersThree -> thirdPartySystems "Интеграция данных" "JSON/XML/GRPC"
        api -> socialMediaService "Интеграция с соцсетями" "JSON"
        socialMediaService -> api "Интеграция с соцсетями" "JSON"
        nginx -> authService "Аутентификация" "JSON"
        nginx -> adminService  Перенаправляет запросы" "JSON/HTTPS"
        authService -> nginx "Токен" "JSON"
        adminService -> primaryDb "Записывает в"
        adminService -> replicaDb "Читает из"
    }

    views {
        container RoadWarrior {
            include *
            autolayout lr
        }

        theme default
    }
}
