# Projekt: Infrastrukturautomation med Ansible

## Översikt

Detta projekt ger dig möjlighet att tillämpa och fördjupa dina Ansible-kunskaper genom att automatisera serverinstallation och konfiguration, implementera filsynkronisering med Unison, samt säkra hög kodkvalitet med `ansible-lint`. Du kommer att praktiskt arbeta med grundläggande principer inom infrastructure as code för att bygga upp och hantera en flexibel och robust servermiljö.

## Mål

- Automatisera serverinstallation och konfiguration med Ansible.
- Implementera filsynkronisering mellan servrar med [Unison file synchronizer](https://github.com/bcpierce00/unison).
- Säkerställa att playbooks följer bästa praxis genom `ansible-lint`.

## Krav

### Allmänna riktlinjer

- Deltagare kan arbeta i grupper om 3–4 personer, där alla medlemmar ska bidra aktivt genom commits i repot med sina respektive konton. Detta är avgörande för att kunna utvärdera varje medlems bidrag.
- Se till att ert arbete är logiskt strukturerat och namngivet på ett tydligt sätt.
- Följ arbetsflödet från kursen "Projektmetodiker" för commits, brancher och pull requests. Ett rekommenderat arbetssätt är att ha ett dagligt stand-up- eller synkmöte varje arbetsdag.

### Grundläggande krav (Godkänt)

- Använd tre Ubuntu Server VMs.
- Den första SSH-nyckelinstallationen, nödvändig för att Ansible ska kunna ansluta till värdarna, ska göras manuellt.
- Skapa en ny lösenordsfri SSH-nyckel manuellt för server-till-server-kommunikation, dock utan att använda denna nyckel i Ansible.

#### Skapa en playbook som:

1. Uppgraderar alla installerade paket.
2. Modifierar OpenSSH-serverns konfiguration så att endast nyckelinloggning är tillåten (lösenord inaktiveras).
3. Startar om servern.
4. Skapar en ny användare kallad `boxydrop`.
5. Lagrar den privata SSH-nyckeln för serverkommunikation säkert med Ansible Vault.
6. Kopierar nyckeln till `.ssh`-katalogen för användaren `boxydrop` och lägger till den offentliga nyckeln i `authorized_keys`. För att testa, logga in via SSH, växla sedan användare med `sudo su boxydrop` på varje server. Användaren ska kunna SSH:a till de andra utan lösenord. Observera att du fortfarande måste acceptera värdfingeravtrycket manuellt – radera `.ssh/known_hosts` efter testet.
7. Dynamiskt genererar en `/home/boxydrop/known_hosts`-fil med rätt behörigheter så att SSH använder den på varje server.
   - Dynamiskt innebär här att:
     - Playbooken samlar in de offentliga värdnycklarna och använder dem.
     - Om du raderar de befintliga värdnycklarna och återskapar dem på en server med `rm /etc/ssh/ssh_host_* && ssh-keygen -A`, kommer `known_hosts`-filen automatiskt att uppdateras med de nya nycklarna.
     - Med andra ord, innehållet i `known_hosts`-filen ska inte vara hårdkodat.
8. Synkroniserar filer med Unison där en VM är passiv (central synkpunkt) och de två andra är aktiva. Synkningen sker tvåvägs, så alla maskiner uppdateras via den passiva servern som de aktiva ansluter till.
9. Synkroniserar katalogen `/boxydrop`.
10. Kör Unison som användaren `boxydrop`, och säkerställ att nödvändiga behörigheter för katalogen finns.
11. Schemalägg Unison att köras varje minut med "cron" eller en systemd timer. Endast de aktiva maskinerna ska ha cron-jobbet.
12. Definiera maskinroller (passiv/aktiv) med Ansible-grupper eller inventory-variabler – inga hårdkodade värdnamn.
13. Säkerställ att `ansible-lint` passerar utan fel. Felet för `state: latest` i paketuppdateringen kan ignoreras med en `noqa`-kommentar. Exempel:

```yaml
- name: Update cache and all packages
  ansible.builtin.apt:
  update_cache: true
  name: "*"
  state: latest # noqa: package-latest
```

### Avancerade krav (Väl Godkänt)

14. Strukturera playbooken i minst två plays men använd endast en playbook.
15. Installera och konfigurera Docker på en av värdarna via Ansible och använd en "docker" [role](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html).
16. Distribuera en Docker-container (valfritt program) som låter användare lägga till filer i `/boxydrop` via ett webbgränssnitt.
17. Kontrollera och bekräfta att behörigheterna för `/boxydrop` tillåter att Unison-synkningen fortsätter samtidigt som Docker-containern kan lägga till filer.

**Förslag på programvara för filuppladdning via webbgränssnitt:**

- [PhotoView](https://photoview.github.io/)
- [FileBrowser](https://filebrowser.org/)

## Verktyg och teknologier

- Ansible
- Unison
- `ansible-lint`
- Docker (för avancerade krav för Väl Godkänt)

## Inlämningsinstruktioner

1. **Deadline**: 2024-11-07, 23:59. Redovisning sker dagen därpå.
2. **Gruppinlämningar**: Säkerställ att varje medlem committar med sitt konto.
3. **Kontroller**:
   1. Alla relevanta filer ska inkluderas i repot, exempelvis playbooks, inventory och roles.
   2. Det ska vara möjligt att konfigurera en ren server (med enbart SSH-anslutning) genom att enbart köra er playbook.
   3. SSH:a in på alla noder, navigera till `/boxydrop` och kör:
   ```bash
      while true; do sleep 15; date; ls; done
   ```
   4. Ladda upp en fil till en aktiv maskin och ta en skärmdump som visar filspridningen.
   5. Visa en skärmdump av `ansible-lint yourplaybook.yml` utan fel.
   6. **Avancerade krav**: Ta en skärmdump av det Docker-distribuerade programmet med uppladdade filer synliga i en webbläsare.

## Resurser

- [Unison File Synchronizer Tutorials](https://www.youtube.com/results?search_query=unison+file+synchronizer)
- [Crontab i Ubuntu](https://www.youtube.com/results?search_query=crontab+ubuntu)
- [Ansible-Lint Documentation](https://ansible.readthedocs.io/projects/lint/)
- [Good Commit Messages Guide](https://cbea.ms/git-commit/)
- [Ansible Examples](https://github.com/nackc8/ansible-examples)
- [Projekt Tips](https://docs.google.com/document/d/1PkOvJ5XPpz4tw3OZfiMcASKluqlIBCxyz3yOWlVkIhE/edit?tab=t.0)
