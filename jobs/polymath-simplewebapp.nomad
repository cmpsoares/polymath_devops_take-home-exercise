job "simplewebapp" {
  datacenters = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  type = "service"

  group "db" {
    count = 1

    network {
      mode = "bridge"
    }

    service {
      name = "simplewebappdb"
      tags = ["postgres db for simplewebapp"]
      port = "5432"

      connect {
        sidecar_service {}
      }
    }

    task "postgres" {
      driver = "docker"
      config {
        image = "postgres"

      }
      env {
          POSTGRES_USER="postgres"
          POSTGRES_PASSWORD="postgres"
      }

      logs {
        max_files     = 5
        max_file_size = 15
      }

      resources {
        cpu = 50
        memory = 512
      }
    }
    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

  }

  group "frontend" {
    count = 1

    network {
      mode = "bridge"
      port "ingress" {
        static       = 8080
        to           = 8080
      }
    }

    service {
      name = "simplewebapp"
      tags = ["simple web app for polymath THA"]
      port = "8080"

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "simplewebappdb"
              local_bind_port  = 5432
            }
          }
        }
      }
    }

    task "simplewebapp" {
      driver = "docker"
      config {
        image = "marcinpolymath/simplewebapp:latest"
      }
      env {
          PORT="8080"
          DB_USER="postgres"
          DB_PASS="postgres"
          DB_HOST="localhost"
          DB_PORT="5432"
          DB_NAME="visitscounter"
          DB_PARAMS="sslmode=disable"
      }

      logs {
        max_files     = 5
        max_file_size = 15
      }

      resources {
        cpu = 50
        memory = 256
      }
    }

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

  }

  update {
    max_parallel = 10
    min_healthy_time = "5s"
    healthy_deadline = "3m"
    auto_revert = false
    canary = 0
  }
}