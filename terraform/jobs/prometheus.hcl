job "prometheus" {
  datacenters = ["dc1"]
  type        = "service"

  update {
    stagger      = "10s"
    max_parallel = 1
  }

  group "prometheus" {
    constraint {
      distinct_hosts = true
    }

    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    task "prometheus" {
      driver = "docker"

      config {
        image        = "docker.io/nicholasjackson/prometheus-consul:latest"
        network_mode = "host"

        port_map {
          http = 9090
        }
      }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB

        network {
          mbits = 10

          port "http" {
            static = "9090"
          }
        }
      }

      service {
        name = "prometheus"
        port = "http"

        tags = [
          "urlprefix-/",
        ]

        check {
          name     = "alive"
          type     = "http"
          interval = "10s"
          timeout  = "2s"
          path     = "/status"
        }
      }
    }
  }
}
