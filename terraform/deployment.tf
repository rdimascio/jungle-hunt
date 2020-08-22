resource "digitalocean_droplet" "junglehunt" {
    count = var.instance_count
    image = var.do_snapshot_id
    name = "${var.do_name}-test"
    region = var.do_region
    size = var.do_size
    backups = var.do_backups
    monitoring = var.do_monitoring
    private_networking = var.do_private_networking
    ssh_keys = [
        var.ssh_fingerprint
    ]
    user_data = <<EOF
    #cloud-config
        runcmd:
            - cd /var/www/jungle-hunt/app
            - npm i --silent
            - npm i react-scripts@3.4.1 -g --silent
            - npm run build
            - cd ./../api
            - npm i --silent
            - cd ./../pm2/ && pm2 start ecosystem.config.js
            - pm2 save
    EOF
}

data "digitalocean_domain" "junglehunt" {
    name = "junglehunt.io"
}

resource "digitalocean_record" "root" {
    domain = data.digitalocean_domain.junglehunt.id
    type = "A"
    name = var.do_domain
    value = digitalocean_droplet.junglehunt[0].ipv4_address
}
