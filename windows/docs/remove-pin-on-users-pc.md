1. Зайти на ПК під адміністратором
2. Відкрити командний рядок від імені адміністратора
3. Ввести команди (після цього буде можливість встановити новий PIN, щоб працював відбитик або face id, їх потрібно видалити, та додати заново):
```bash
takeown /f C:\Windows\ServiceProfiles\LocalService\AppData\Local\Microsoft\Ngc /r /d y
icacls C:\Windows\ServiceProfiles\LocalService\AppData\Local\Microsoft\Ngc /grant administrators:F /t
rd /s /q C:\Windows\ServiceProfiles\LocalService\AppData\Local\Microsoft\Ngc
```
