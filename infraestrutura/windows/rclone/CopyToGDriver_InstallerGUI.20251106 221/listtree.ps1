chcp 65001
tree /F > temp.txt
powershell -Command "Get-Content temp.txt -Raw | Out-File -FilePath tree.txt -Encoding utf8"
del temp.txt
