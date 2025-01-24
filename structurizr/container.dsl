workspace {

    model {
        user = person "Клиент" "Использует приложение Road Warrior."
        admin = person "Администратор" "Управляет приложением Road Warrior."

        RoadWarrior = softwareSystem "Road Warrior" "Сервис доставки." {
            webApp = container "Web-приложение" "Интерфейс для клиентов." "Web Application"
            mobileAppiOS = container "Mobile App iOS" "iOS приложение для клиентов." "iOS"
            mobileAppAndroid = container "Mobile App Android" "Android приложение для клиентов." "Android"
            adminWebApp = container "Web App Admin" "Интерфейс для администраторов." "Web Application"
            webApi = container "Application Backend" "основная бизнес-логика приложения." "Application Backend"
            postgress = container "Postgress" "База данных приложения"
            apiLayers = container "Integration Layer" "обеспечивает взаимодействие с внешними API поставщиков"
            redis = container "Redis" "Кэш приложения"
            kafka = container "Kafka" "Очередь для взаимодействия сервисов"
        }

        integrationServ = softwareSystem "Сторонние системы" "(авиакомпании, отели, прокат авто)" 
        
        user -> webApp "Использует"
        user -> mobileAppiOS "Использует"
        user -> mobileAppAndroid "Использует"
        admin -> adminWebApp "Использует"
        
        webApp -> webApi "API"
        mobileAppiOS -> webApi "API"
        mobileAppAndroid -> webApi "API"
        adminWebApp -> webApi "API"
        
        webApi -> redis ""
        webApi -> postgress ""
        webApi -> kafka "очрердь"
        kafka -> webApi "очрердь"
        apiLayers -> kafka "очрердь"
        kafka -> apiLayers "очередь"
        integrationServ -> apiLayers "HTTPS/JSON"
        apiLayers -> integrationServ "HTTPS/JSON"
    }

    views {
        container RoadWarrior {
            include *
            autolayout lr
        }

        theme default
    }
}
