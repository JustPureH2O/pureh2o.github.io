@echo off
chcp 65001

echo 初次运行需在弹出窗口中点击 Agree 同意第三方软件用户许可证
echo 三秒后执行挂起，请注意切换窗口！
TIMEOUT /T 2
goto a

:a
TIMEOUT /T 1
pssuspend StudentMain.exe
pssuspend jfglzs.exe
echo 挂起成功！按任意键解挂...
pause
TIMEOUT /T 1
pssuspend -r StudentMain.exe
echo 解挂成功！按任意键挂起...
pause
goto a