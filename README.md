#  iRetro

## ToDos

- Finish implementing GB-GBC
- Refine frontend
- Add a second core (GBA)
- Try to implement auto game scanning with libretro-db https://github.com/libretro/RetroArch/blob/master/libretro-db/README.md https://github.com/libretro/libretro-database


- Per Sync:
    - Se l'utente attiva la sincronizzazione sul cloud, usare quello come master e triggerare la copia solo al momento dello switch a On
    - Periodicamente triggerare la sincronizzazione --> la sincronizzazione non fa altro che scaricare i file dal cloud aggiornando il locale se la data di modifica è maggiore
        - Ogni modifica dei file in locale deve essere mirrorata sul cloud:
            - carico un gioco --> lo carico anche sul cloud
            - salvo un gioco --> aggiorno il salvataggio sul cloud
            - cancello un gioco --> cancello tutto anche dal cloud
