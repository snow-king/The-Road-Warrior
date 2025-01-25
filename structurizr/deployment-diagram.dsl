workspace {

    model {
        user = person "User" {
            description "A user of the system"
        }

        webApp = softwareSystem "Web Application" {
            description "The web application for managing trips"
            webAppContainer = container "Web Application" "" "Delivers the static content and spa"
            api = container "DashbordService" "" "Golang"
            adminService = container "Admin API" "" "Golang"
            adminWebApp = container "Admin Web" "" "Vue"
            primaryDb = container "Primary Database" "" "PostgreSQL"
            replicaDb = container "Replica Database" "" "PostgreSQL"
            nginx = container "Api GateWay" "" "NGINX"
            spa = container "Single-Page Application" "" "Vue"
            pwa = container "Progressiv web application" "" "Vue"
            redis = container "Cash web application" "" "redis"
            queue = container "Broker" "" "Kafka"
            apiAdaptersOne = container "Integrations Container One"
            apiAdaptersTwo = container "Integrations Container Two"  
            apiAdaptersThree = container "Integrations Container Three"
            thirdpPartySystems = container " abstract thirdp Party Systems "
            socialMediaService = container "social Media  integration service  "
            authService = container "jwt auth service"
            
        }

        user -> webAppContainer "Uses"
        api -> primaryDb "Writes to" 
        replicaDb -> api  "Reads from" 
        
        adminWebApp -> nginx "Make api calls" "json/https"
        api -> adminService "Writes to" 
        replicaDb -> adminService  "Reads from" 
        nginx -> adminService "translate to api" "json/https"
        
        
        primaryDb -> replicaDb "Replicates data to"
        nginx -> NGINX "Forwards requests to"
        webAppContainer -> SPA "Delivers to the customers web browser"
        pwa -> nginx "Make api calls" "json/https"
        spa -> nginx "Make api calls" "json/https"
        nginx -> api "translate to api" "json/https"
        api -> redis "cash" "json"
        redis -> api "cash" "json"
        api -> queue "" "json"
        queue -> api "" "json"
        queue -> apiAdaptersOne "" "json"
        queue -> apiAdaptersTwo "" "json"
        queue -> apiAdaptersThree "" "json"
        socialMediaService -> api "" "json"
        api -> socialMediaService "" "json"
        apiAdaptersThree -> thirdpPartySystems "service data" "json/xml/grpc?"
        apiAdaptersTwo -> thirdpPartySystems "service data" "json/xml/grpc?"
        apiAdaptersOne -> thirdpPartySystems "service data" "json/xml/grpc?"
        authService -> nginx "auth data" "json"
        nginx -> authService "token" " json"
        
        
         
        production = deploymentEnvironment "Production" {
            deploymentNode "Internet"{
            containerInstance spa
            containerInstance pwa
            containerInstance thirdpPartySystems
            containerInstance adminWebApp
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
                        containerInstance authService
                        containerInstance queue
                        containerInstance adminService 
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
              deploymentNode  "VM" {
                 description "VM Backend node"
                containerInstance primaryDb
                containerInstance replicaDb
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
