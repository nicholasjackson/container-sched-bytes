job "statsd" {
  datacenters = ["dc1"]
  type        = "system"

  update {
    stagger      = "10s"
    max_parallel = 1
  }

  group "statsd" {
    constraint {
      distinct_hosts = true
    }

    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    task "statsd" {
      driver = "docker"

      config {
        image = "docker.io/prom/statsd-exporter:latest"

        port_map {
          http  = 9102
          stats = 9125
        }
      }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB

        network {
          mbits = 10

          port "http" {
            static = "9102"
          }

          port "stats" {
            static = "9125"
          }
        }
      }

      service {
        name = "statsd"
        port = "http"

        tags = ["statsd:9102"]

        check {
          name     = "alive"
          type     = "http"
          interval = "10s"
          timeout  = "2s"
          path     = "/"
        }
      }
    }
  }
}
