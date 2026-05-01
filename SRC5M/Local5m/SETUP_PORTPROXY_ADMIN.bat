@echo off
set MAC_SERVER_IP=192.168.2.23

echo Setting Windows portproxy to %MAC_SERVER_IP%...
netsh interface portproxy delete v4tov4 listenaddress=127.0.0.1 listenport=8888 >nul 2>&1
netsh interface portproxy delete v4tov4 listenaddress=127.0.0.1 listenport=14445 >nul 2>&1

netsh interface portproxy add v4tov4 listenaddress=127.0.0.1 listenport=8888 connectaddress=%MAC_SERVER_IP% connectport=8888
netsh interface portproxy add v4tov4 listenaddress=127.0.0.1 listenport=14445 connectaddress=%MAC_SERVER_IP% connectport=14445

echo.
echo Done. Now run RUN_GAME.bat or open ModLocal_Double.exe.
pause
