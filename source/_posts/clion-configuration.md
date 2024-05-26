---
abbrlink: ''
categories: []
date: '2024-05-05T11:12:51.390678+08:00'
headimg: https://www.jetbrains.com.cn/clion/img/clion_ide_overview.png
keywords:
- clion
- jetbrains clion
- clion刷题
- oier clion
mathjax: false
seo_title: CLion刷题配置指南
tags:
- 教程
title: JetBrains CLion IDE 调教指南
updated: '2024-05-05T14:41:13.142+08:00'
---
### CLion

CLion 是一款在 IntelliJ 基础上开发的面向 C/C++ 的跨平台 IDE，它内置的许多智能模块和工具能够提升开发者 的开发效率、同时还使用智能编辑器提高代码质量、重构效率，其深度整合的 CMake 编译系统也能够帮助开发者高效的进行开发工作。

[官方 下载地址](https://www.jetbrains.com.cn/clion/download/download-thanks.html)

官方版有30天的试用期，如果用 edu 教育邮箱注册账号是可以获得免费下载的资格的。因为我基本都在学校里刷题，学校的机器又设置了自动还原，因此不需要担心30天试用期的问题。如果是普通用户，可以考虑下载 Eval Reset 插件实现试用期重置的功能，这里就不介绍了。

因为 CLion 是专门为项目开发设计的 IDE，与 VS Code、Dev C++ 相比，CLion最大的优势就在于对于长且复杂代码的快速分析、文件/函数/变量的依赖关系、实时查错/代码补全、以及友好的调试系统~~严厉批评 DEV 的垃圾调试系统~~。但这样也会带来一些不便，例如整个项目中只能出现一个主函数。接下来就介绍如何把 CLion 从项目开发工具调教成为广大 OIer 高效刷题的利器。

截至当前（2024.5.5），CLion 的最新版本为 `2024.1.1`，请注意文章时效性。

### 单文件编译

首先转到设置“Settings - Build, Execution, Deployment - CMake”，并勾选“Reload CMake project...”选项。这个设置允许 IDE 在 `CMakeList.txt` 修改后自动重新加载整个项目。

然后在新建的项目里找到 `CMakeLists.txt` 文件，把文件末尾的 `add_executable(...)` 全部删除，替换为如下的代码段：

```cmake
file (GLOB files *.cpp)
foreach (file ${files})
    string(REGEX REPLACE ".+/(.+)\\..*" "\\1" exe ${file})
    add_executable (${exe} ${file})
    message (\ \ \ \ --\ src/${exe}.cpp\ will\ be\ compiled\ to\ bin/${exe})
endforeach ()
```

这是官方提供的解决一个项目内只能同时存在一个主函数的方案，加入这段代码后，CMake 会遍历源工作目录（包括多级子目录）下的所有 C++ 源文件，并单独编译生成对应的可执行文件。

如果你没有勾选开头所说的选项，那么就需要在文件结构浏览器里右键项目文件夹，并选择“Reload CMake Project”，稍等片刻即可重新加载完毕。

新建文件时，在弹出的新建提示框中取消勾选“Add to targets”一项，此后新建的所有 C++ 源文件都不需要进行此操作。即可完全实现像 DEV 那样文件独立编译运行的功能。

### 键位设置

转到设置“Settings - Keymap”。在“MainMenu - Run - Run/Debug”下找到 `Run`，双击并选择“Add Keyboard Shorcut”，直接在弹出的提示框里按下你想要设置的按键，点击“OK”保存设置即可更改运行文件的快捷键。

调试键位：在 Keymap 的“MainMenu - Run - Run/Debug”下

---

> 注意：若当前源文件从未编译，则需要手动转到该文件的主函数，点击一旁的绿色箭头运行；在此之后如果想运行其他的文件，则需要在顶部的选项卡里选择对应的源文件名

### IDE 背景图

在设置“Settings - Appearance & Behavior - Appearance”里下滑找到“UI Options”里的“Background Image...”按钮，点击“Image”文本框旁边的浏览图片按钮就可以自选背景图了。支持调节背景图的透明度、以及一些其他的功能。

### 代码/文件模板

如果在敲代码时输入 `for`，你会发现有一个这样的选项：

![](https://pic.imgdb.cn/item/6637086a0ea9cb14032e3067.png)

点击回车，CLion 会自动置入一段标准的 `for` 循环代码：

![](https://pic.imgdb.cn/item/663708b80ea9cb14032ecf48.png)

可以发现编辑器在一些地方放上了可供更改的快捷区块，按 `tab` 可以快速切换这些块，并且可以在所有块更改完毕后跳进大括号内方便书写循环体内部的代码。

如要设置自定义内容（例如I/O重定向），可以转到设置“Settings - Editor - Live Templates”，点击加号添加一个模板：

![](https://pic.imgdb.cn/item/663725680ea9cb140377a7d8.png)

在“Abbreviation”里填入触发缩写；“Description”是描述；“Expand with”里的值是可编辑区域相互跳转的快捷键。在设置时需要点击下边的“Change”，在弹出的选项卡里选择 C++，此处是定义了一个语句模板，因此选择“Statement”选项；点击“Edit Variables”还可以对标为紫色的变量进行进一步设置。完成后点OK保存即可在代码里快捷使用了。

---

在 DEV C++ 的设置里可以编辑缺省源文件，在每次新建源文件时就会自动填入，省去了打头文件的不便。接下来介绍在 CLion 中设置缺省源的方式。

转到设置“Settings - Editor - File and Code Templates”，同样是点击加号新建模板，“Name”中填入源名称，“Extension”保持 `.cpp` 不变，然后在输入框里填入如下文本：

```plaintext
#[[#include]]# <bits/stdc++.h>
using namespace std;

int main() {
    // TODO
  
    return 0;
}
```

点击OK保持，在新建文件时，找到和你刚刚设置的“Name”相同的项，即可新建你的自定义代码模板：

![](https://pic.imgdb.cn/item/663728df0ea9cb14037f996c.png)

### 插件推荐

1. Rainbow Brackets：半付费，中国用户有打折优惠（若安装了 Eval Reset 则部分试用功能无法使用）；能够将代码里的不同层级的括号用不同颜色高亮
2. Chinese (Simplified) Language Pack/中文语言包：官方免费，将界面换成中文（但是有不少地方汉化没做好，而且中文字体显示也不是很好看，建议能看得懂就尽量用英文原版）
