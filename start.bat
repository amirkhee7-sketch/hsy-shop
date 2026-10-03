@echo off
title HSY SHOP - نظام إدارة الاشتراكات
color 0b
echo ===================================================
echo               🛍️ HSY SHOP DASHBOARD 🛍️
echo     نظام إدارة اشتراكات الزبائن وحساب الأرباح الذكي
echo ===================================================
echo.
echo جاري تشغيل خادم الموقع المحلي...
echo.

start "" "http://localhost:3000"
node server.js

pause
