provider "google" {
  credentials = var.GOOGLE_CREDENTIALS
  project     = var.project
  region      = var.region
}

resource "google_compute_firewall" "firewall" {
  name    = "new-firewall-externalssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22","443","80","9090","9100","8000","8001","9093"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"] # Limiting the source range
  target_tags   = ["externalssh","http-server"]
}

resource "google_compute_network" "vpc_network" {
  name                    = "my-custom-mode-network"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "default" {
  name          = "my-custom-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-west1"
  network       = google_compute_network.vpc_network.id
}



# We create a public IP address for our google compute instance to utilize
resource "google_compute_address" "static" {
  name       = "vm-public-address"
  project    = var.project
  region     = var.region
  depends_on = [google_compute_firewall.firewall]
}

resource "google_compute_instance" "default" {
  name         = "md-vm"
  machine_type = "e2-medium"
  zone         = "us-west1-a"
  tags         = ["externalssh", "http-server"]

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.default.name

    access_config {
      nat_ip = google_compute_address.static.address
    }
  }

  metadata = {
    ssh-keys = "${var.user}:${var.public_key}"
  }

  provisioner "remote-exec" {
    inline = [
      "export MYSQL_USER='${var.MYSQL_USER}'",
      "export MYSQL_PASSWORD='${var.MYSQL_PASSWORD}'",
      "curl -o /tmp/mediawiki.sh https://raw.githubusercontent.com/rujhaan123/Th-Assignment/main/mediawiki.sh", # Download the script from GitHub
      "chmod +x /tmp/mediawiki.sh", # Make the script executable
      "sudo /tmp/mediawiki.sh" # Run the script as root
    ]
    connection {
      type        = "ssh"
      user        = var.user
      private_key = var.private_key
      host        = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
    }
  }

  depends_on = [google_compute_firewall.firewall]
}
