# os_30day
30天自制操作系统

## 在Deepin下的实践

源代码使用作者自带的`nask`汇编编译器编译，有些指令与`NASM`不兼容，在保留`.nas`代码的同时增加了`.asm`代码用于在Linux下的编译。

清理
```
make clean
```

运行
```
make run
```

## 在Ubuntu20.04下的实践
中间由于Deepin出现键盘中断的问题，尝试切换到Ubuntu编译，竟然成功了，所以增加了`os-ubuntu`分支
