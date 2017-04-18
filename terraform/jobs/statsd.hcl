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
          stats = 8125
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
            static = "8125"
          }
        }
      }

      service {
        name = "statsd"
        tags = ["statsd"]
      }
    }
  }
}
