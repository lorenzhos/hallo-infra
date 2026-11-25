hallo-infra

Eine kleine Web-App, die vollautomatisch auf einem eigenen Server läuft – von der Infrastruktur über die Einrichtung bis zum Deployment. Ein Lernprojekt, mit dem ich Infrastructure as Code, Container und CI/CD in der Praxis lerne.

<!-- Live-Link einsetzen, falls die App öffentlich erreichbar ist, sonst diese Zeile löschen -->

Live: https://lorenzhosnerink.ch

Worum es geht

Ich wollte verstehen, wie eine Anwendung wirklich in Betrieb geht – nicht nur lokal, sondern auf einem echten Server im Internet. Statt alles von Hand einzurichten, ist jeder Schritt als Code beschrieben:

Terraform erstellt den Server bei AWS Lightsail.
Ansible richtet den Server ein und sichert ihn ab.
Podman / Docker Compose startet die App in Containern.
GitHub Actions führt das Deployment bei jedem Push automatisch aus.

So lässt sich der ganze Server jederzeit neu und gleich aufbauen.

Ablauf
Push auf main
GitHub Actions
TerraformServer bei AWS Lightsail
Ansible-PlaybookEinrichtung und Sicherheit
Podman / Docker ComposeApp in Containern
lorenzhosnerink.ch
Technologien
Bereich	Werkzeug
Infrastruktur	Terraform, AWS Lightsail
Server-Einrichtung	Ansible
Container	Podman, Docker Compose
CI/CD	GitHub Actions
Betriebssystem	Linux (Ubuntu)
Domain und HTTPS	eigene Domain, Let's Encrypt
Aufbau des Repos
<!-- Bitte an deine echte Ordnerstruktur anpassen -->
hallo-infra/
├── terraform/          # Server und Netzwerk bei AWS Lightsail
├── ansible/            # Playbooks für Einrichtung und Absicherung
├── app/                # die Web-App und ihr Container-Setup
└── .github/workflows/  # Deployment-Pipeline
Sicherheit
<!-- Nur behalten, was du wirklich umgesetzt hast; Fehlendes löschen oder ergänzen -->

Die Absicherung des Servers ist Teil des Ansible-Playbooks und läuft bei jedem Deployment mit:

Anmeldung per SSH nur mit Schlüssel, kein Passwort-Login
Firewall: nur die nötigen Ports sind offen (SSH, HTTP, HTTPS)
Automatische Sicherheits-Updates
HTTPS-Zertifikat über Let's Encrypt
Zugangsdaten liegen als GitHub Secrets, nie im Code
Selbst ausprobieren
<!-- Befehle an dein Projekt anpassen -->

Voraussetzungen: Terraform, Ansible, ein AWS-Konto und ein SSH-Schlüssel.

bash
# 1. Server erstellen
cd terraform
terraform init
terraform apply

# 2. Server einrichten und App starten
cd ../ansible
ansible-playbook -i inventory.ini site.yml

Im Alltag ist das nicht nötig: Ein Push auf main startet die Pipeline automatisch.

Was ich dabei gelernt habe
Angefangen habe ich lokal auf einer Ubuntu-VM in VirtualBox, um Podman und Docker Compose zu verstehen.
Danach habe ich den Schritt auf einen echten Server gemacht und gelernt, wie DNS, Domain und HTTPS zusammenspielen.
Mit Terraform und Ansible ist der Server reproduzierbar: Ich kann ihn löschen und in wenigen Minuten gleich wieder aufbauen.
Mit GitHub Actions läuft das Deployment ohne Handarbeit, und Fehler fallen früh auf.
Nächste Schritte
<!-- Anpassen oder löschen -->
Monitoring und Benachrichtigung, wenn die App nicht erreichbar ist
Automatische Backups

Lorenz Hosner · Wirtschaftsinformatik-Student an der ZHAW · GitHub
