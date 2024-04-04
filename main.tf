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
    ports    = ["22","443"]
  }

  source_ranges = ["0.0.0.0/0"] # Not So Secure. Limit the Source Range
  target_tags   = ["externalssh"]
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
  tags         = ["externalssh", "webserver"]

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

  depends_on = [google_compute_firewall.firewall]

  /*service_account {
    email  = var.email
    scopes = ["compute-ro"]
  }*/
  
  metadata = {
    ssh-keys = "${var.user}:${var.public_key}"
  }
}
