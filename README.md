# BLEPeripheral

用iOS设备采集加速度传感器、陀螺仪和磁力计的9d数据传入Mac端。

真机调试时若遇到错误提示，尝试终端中使用下面三条指令，然后重新跑

rm -rf "$(getconf DARWIN_USER_CACHE_DIR)/org.llvm.clang/ModuleCache"
rm -rf ~/Library/Developer/Xcode/DerivedData/*
rm -rf ~/Library/Caches/com.apple.dt.Xcode/*

若有其他问题，请邮件 15212010015@fudan.edu.cn
