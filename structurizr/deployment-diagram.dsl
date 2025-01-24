workspace {

    model {
        user = person "User" {
            description "A user of the system"
        }

        webApp = softwareSystem "Web Application" {
            description "The web application for managing trips"
            webAppContainer = container "Web Application" "" "Delivers the static content and spa"
            api = container "API" "" "Laravel"
            primaryDb = container "Primary Database" "" "PostgreSQL"
            replicaDb = container "Replica Database" "" "PostgreSQL"
            nginx = container "NGINX" "" "NGINX"
            spa = container "Single-Page Application" "" "Vue"
            pwa = container "Progressiv web application" "" "Vue"
            redis = container "Cash web application" "" "redis"
            queue = container "Event Queqy" "" "Kafka"
            apiAdaptersOne = container "Integrations Container One"
            apiAdaptersTwo = container "Integrations Container Two"
            apiAdaptersThree = container "Integrations Container Three"
            thirdpPartySystems = container " abstract thirdp Party Systems "
            socialMediaService = container "social Media  integration service Service"
        }

        user -> webAppContainer "Uses"
        api -> primaryDb "Writes to"
        api -> replicaDb "Reads from"
        primaryDb -> replicaDb "Replicates data to"
        nginx -> NGINX "Forwards requests to"
        webAppContainer -> SPA "Delivers to the customers web browser"
        pwa -> nginx "Make api calls" "json/https"
        spa -> nginx "Make api calls" "json/https"
        nginx -> api "translate to api" "json/https"
        api -> redis "cash" "json"
        redis -> api "cash" "json"
        api -> queue '' 'json'
        queue -> api '' 'json'
        queue -> apiAdaptersOne '' 'json'
        queue -> apiAdaptersTwo '' 'json'
        queue -> apiAdaptersThree '' 'json'
        socialMediaService -> api '' 'json'
        api -> socialMediaService '' 'json'
        apiAdaptersThree -> thirdpPartySystems 'service data' 'json/xml/grpc?'
        apiAdaptersTwo -> thirdpPartySystems 'service data' 'json/xml/grpc?'
        apiAdaptersOne -> thirdpPartySystems 'service data' 'json/xml/grpc?'
        
        production = deploymentEnvironment "Production" {
            deploymentNode "Internet"{
            containerInstance spa
            containerInstance pwa
            containerInstance thirdpPartySystems
            deploymentNode "Kubernetes Cluster" {
                description "Kubernetes cluster for deploying containers"
                technology "Kubernetes"

                deploymentNode "Master Node" {
                    description "Kubernetes master node"
                    technology "Kubernetes Master"
                }

                deploymentNode "Worker Node" {
                    description "Kubernetes worker node"
                    technology "Kubernetes Worker"
                    deploymentNode "Backend Pods" {
                        description "Kubernetes Backend node"
                        technology "Kubernetes Worker"
                        containerInstance redis
                        containerInstance nginx
                        containerInstance webAppContainer
                        containerInstance api
                        containerInstance api
                        containerInstance primaryDb
                        containerInstance replicaDb
                        containerInstance queue
                    }
                   deploymentNode "Integration Pods" {
                        description "Kubernetes Integration node"
                        technology "Kubernetes Worker"
                        containerInstance apiAdaptersOne
                        containerInstance apiAdaptersTwo
                        containerInstance apiAdaptersThree
                   }
                     deploymentNode "socialMedia Pods" {
                        description "Kubernetes social Media node"
                        technology "Kubernetes Worker"
                        containerInstance socialMediaService
                   }  
                }
            }
            }
        }
    }

    views {

        deployment * production {
            include *
            autoLayout lr
            title "Production Deployment Diagram"
        }
         theme default
    }

 
}
