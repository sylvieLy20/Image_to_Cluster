packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "nginx_source" {
  image  = "nginx:alpine"
  commit = true
}

build {
  sources = ["source.docker.nginx_source"]

  provisioner "file" {
    source      = "index.html"
    destination = "/usr/share/nginx/html/index.html"
  }

  post-processor "docker-tag" {
    repository = "mon-nginx-custom"
    tag        = ["v1"]
  }
}
