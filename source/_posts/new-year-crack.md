---
abbrlink: '64010'
categories: []
date: '2023-12-31T20:22:54+08:00'
headimg: https://pic.imgdb.cn/item/658f966dc458853aef21ec93.png
keywords:
- 极域电子教室
- 极域破解
- 极域
- 如何破解极域
- 极域爆破
- 极域破解代码
- 极域破解脚本
seo_title: 极域电子教室破解
tags:
- 整活
- 破解
- 学术
title: 领域展开，坐杀极域
updated: '2024-04-24T15:58:55.754+08:00'
---
![](https://pic.imgdb.cn/item/658f966dc458853aef21ec93.png)

省流：[代码](https://www.luogu.com.cn/paste/nd8jfeoe)

$$
\begin{array}{c}
Update~2024.2.16&\text{更新Suspend条目的链接}
\\Update~2024.3.6&\text{更新条目1.5和3.1.2节内容}
\\Update~2024.3.20&\text{更新条目1.4.3和3.1.2节内容，修改了部分代码}
\\Update~2024.3.27&\text{更新条目3.2.1内容，上传部分代码}
\end{array}
$$

### 极域——世界上最弱小最单纯的机房软件

**注意，极域由C/C++语言开发。对于极域的反编译工作可以基本认定为徒劳且耗费大量时间的。**

开始的开始，我的脱控方式还仅限于最原始的`taskkill`和`ntsd`。这种做法不仅有时会失效，而且一旦老师发现你的机子的监控屏幕是纯黑一片、且无法控制，他就会气急败坏地冲向你对你进行一顿输出，结果自然是被班主任教训一顿、这学期的信息课停上。

令人欣慰的是：这种低级脱控方式已经在学子之间渐渐隐没不见，取而代之的是层出不穷的脱控软件，例如`JYTrainer`、还有本人开发的[ClassX](https://www.luogu.com.cn/paste/nd8jfeoe)（doge）等等……

因为本人不会那些所谓的网络IP、频道更改之类的高科技东西，另一方面实现如上的功能多半需要辅助程序（容易被反脱软件检测到进程名）。本着精简实现、不易查封的原则，我从非`exe`层面出发，编写了一套脱控程序供大家伙们免费使用，毕竟人生苦短，及时行乐嘛（doge）。

#### 板块一 TD到底是啥的缩写？

~~你知道明明U盘里装着几个G的学习资料却无法在计算机课上给周边的同学炫耀是怎么样一种感觉吗？你知道明明想要打开小破站观看最爱的coser投稿的新擦边视频却被提示“该网站已被禁止”是什么样的感觉吗？~~

出于以上两种痛苦的经历，我立志要写出能够禁止极域牛马功能的脚本。就先从U盘解禁和网络解禁两个方面入手！

**Windows服务概述**：打开任务管理器，选项卡里不仅有经典的“进程”选项、也有装机大佬们引以为傲的“性能”选项，可是我们今天的主角：“服务”选项却几乎无人问津。

类似于`cmd`的打开方式，服务管理器则需要在`Win+R`后输入`services.msc`来使用；你也可以通过任务管理器“服务”选项卡进入。那么什么是服务呢？

Windows服务是指系统自动完成的，不需要和用户交互的过程，可长时间运行的可执行应用程序。这些服务可以在计算机启动时自动启动，可以暂停和重新启动而且不显示任何用户界面。一个词概括就是：“幕后黑手”。开头立的flag就需要通过这种方式巧妙解决。

定位到极域安装目录：会发现下面有好多`TD`打头的文件，而当你在服务里面搜索时，你会发现一个惊人的巧合：`TDNetFilter`和`TDFileFilter`早已在你的机器上悄然运行了很久。看到它的名字，容易知道前者禁掉了你的网络、后者ban掉了你的U盘。如何终止服务呢？这也非常的简单：

在Windows系统中，与服务有关的命令是`sc`。要想停止某个服务，只需安装如下模式输入指令：`sc stop [NAME]`（`NAME`是服务名称）。于是我在`ClassX`的开头加入了如下的指令：

```
sc stop tdnetfilter
sc stop tdfilefilter
```

这样就结束了吗？然而并没有……

#### 板块二 可疑的程序

上一节里遗留了一个小问题：停止了服务后他就真的解禁了吗？事实并非如此：没过几秒，你的网络又会恢复到先前的状态、U盘再次被封杀。一切的一切都是因为两个不起眼的可疑程序……

`ProcHelper64.exe`和`MasterHelper.exe`——《我们俩》

有人问我当时是怎么发现的。首先需要知道，每个版本的Windows系统几乎都有一套特别的图标主题（图标存放在`Shell32.dll`中），现如今大部分机房电脑使用的是Win10系统，然而上述两个进程使用的是WinXP风格的图标，直接一眼丁真掏出`taskkill`秒了。~~真是实力坑队友~~。

因此`ClassX`里面还有这一段代码：

```ini
:a
taskkill /f /t /im ProcHelper64.exe
taskkill /f /t /im MasterHelper.exe

goto a
```

`:a`定义了一个函数`a`，中间是函数体，最后一行的`goto a`则是调用这个函数，注意`goto a`写在了`a`函数内部，起到了`while (true) {...}`的死循环作用。你也可以在空行出添加一段`TIMEOUT /T 1`，即延时一秒，因为这两个程序的复活时间大概在1秒左右（终止后一秒就会重启）。

#### 板块三 拒绝访问什么鬼？

##### 第一种情况：钩子程序

如果你是Win7及以下的系统，且直接使用任务管理器结束进程，那么很有可能会出现像标题这样的提示。这是因为极域启动了一个**系统钩子**（四川人莫笑，`Hook`翻译过来的确是钩子的意思）。

**Windows钩子概述**：类似于游戏（~~以及Scratch~~）的消息机制，Windows中存在一种事件系统，`Win+R`弹出运行、输入`eventvwr.exe`/`eventvwr.msc`打开事件管理器，你会看到本机所有事件的发生时间及概况。把Windows系统的事件系统比作一条河流，最上游是系统，负责抛出事件，事件信息顺流而下；把应用程序比作渔夫，它们在河岸两侧用网捞特定类型的事件，大多数情况下自行处理后再放回到河中。

对于极域来说，它在一个名叫`NtTerminateProcess`的系统函数上下钩，检测这个函数的传入信息，即终止对象的进程名，是否是`StudentMain.exe`（极域主程序），若是，就返回`false`，也就是失败。因而导致开头所说拒绝访问的情况，而把钩子钩在此处的，就是我们的`TD`圈大佬`LibTDProcHook.dll`。因为本人使用Win10系统，这个钩子对于Win7以后的系统都会失效，因此Win8/10/11用户可以直接用任务管理器。对于Win7系统用户，在这里使用WinAPI终止这个TD模块。

```cpp
#include <bits/stdc++.h>
#include <windows.h>
#include <tlhelp32.h>
#include <processthreadsapi.h>

using namespace std;

DWORD GetPID(const char* proc) {
	PROCESSENTRY32 entry;
	entry.dwSize = sizeof(PROCESSENTRY32);
	HANDLE snapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, NULL);

	if (Process32First(snapshot, &entry) == TRUE) {
		while (Process32Next(snapshot, &entry) == TRUE) {
			if (stricmp(entry.szExeFile, proc) == 0) {
				HANDLE hProc = OpenProcess(PROCESS_ALL_ACCESS, FALSE, entry.th32ProcessID);
				DWORD pid = GetProcessId(hProc);
				CloseHandle(hProc);
				return pid;
			}
		}
	}
}

int main() {
	HMODULE hook = GetModuleHandle("LibTDProcHook64.dll");
	FreeModule(hook);
	HANDLE handle = OpenProcess(PROCESS_TERMINATE, FALSE, GetPID("StudentMain.exe"));
	TerminateProcess(handle, 0);
	return 0;
}
```

##### 第二种情况：时代变了

自从学校机房的极域从2014版更新到了2020版，上述朴素解决方案已经不见效了。我也不知道从哪一年的版本开始，它给自己的服务加了一层防护，普通地运行`bat`脚本还木有用。但是它解决起来也简单，右键文件“以管理员模式运行”即可。

除此之外，你还可以在脚本开头加入：

```powershell
>nul 2>&1 "%SYSTEMROOT%\System32\cacls.exe" "%SYSTEMROOT%\System32\config\system"
 
 
if %errorlevel% == 0 (
    echo Admin Switched!
) else (
    echo Level Ascending... Restart
 
    powershell -command "Start-Process '%0' -Verb RunAs"
    exit
)
```

来实现UAC自动提权管理员！

#### 板块四 挂起进程

~~有一天我的同学给我推荐了这个方法，说是用一个命令行程序`Suspend`来命令层面挂起极域进程实现随意脱控，亲测有效。如果使用性能监视器也可以达到相同效果。~~

##### 挂起为何物？

大家可能有过这样的经历：当你用WPS做PPT或者正在用WPS演示PPT时，有时它会莫名其妙地卡掉，尤其是你画了太多墨迹注释时，看着永不停歇转动的“繁忙”鼠标图标，你也许会耐不住性子直接任务管理器结束进程，~~并发誓要下载一个破解版的微软Office全家桶来用~~。像这样，程序的卡死就是挂起的一个形式，当然，当CPU面临有限的内存分配问题时，它会优先分配运存给那些需要内存的重要程序而把不那么重要的进程挂起，表现为对用户操作无响应等。

那么你可能已经猜到了这一方法的逻辑了：我们挂起极域主进程。这样当教师端发送指令（黑屏安静、全屏广播等）时，你这边的极域接收端（学生端）就无法对指令作出响应，自然也就不会被控制。桌面监控同理，也会被影响，不同的是，教师端的监控小窗只会定格在你挂起极域前传输过来的最后一帧画面，总之瞒天过海是基本上没问题的了……

根据上述原理，我们有两种方式来挂起一个进程（其实本来还有Win32API这种方法，留给读者自行研究）：

##### 第一种 性能监视器

你可以打开任务管理器，在“性能”一栏的左下角可以看到“性能监视器”选项（Win10），对于Win11用户，则需点击“性能”栏右上角三个点，然后选中“性能监视器”；也可以`Win+R`输入`perfmon.exe /res`直接打开（万能）。还有几种方法见[百度百科](https://jingyan.baidu.com/article/ae97a646b689aafafc461d60.html)。

在性能监视器中，我们在最上面“进程”列表中找到`StudentMain.exe`（一般来说有两个同样的进程），接着挨个右键点击“暂停进程（S）”即可。

![](https://pic.imgdb.cn/item/65991be5871b83018acf5b30.png)

但是这样的话，你在教师端那边的小窗口上就会显示出一个性能监视器的窗口，感觉不太完美，怎么能优化一下呢？

##### 第二种 Suspend命令行

[PS Suspend - Microsoft Learn](https://learn.microsoft.com/zh-cn/sysinternals/downloads/pssuspend)

[PS Suspend微软官方下载地址](https://download.sysinternals.com/files/PSTools.zip)

下载下来的压缩包里有很多的工具，不过我们只需要其中的一个——“pssuspend.exe”（64位系统按需选用）

然后我们设计一个挂起脚本，由于挂起后，教师端的监控界面会停在挂起前的最后一帧。所以人性化的加入一个延时代码，让学生有充足的时间切换到学习屏幕上，使用`TIMEOUT`命令实现。

紧接着，因为每次手动打开脚本太慢了，我们将挂起和解挂贴在同一段函数里循环调用。当然，如果不小心手残关掉了窗口，我提供两个文件，一个脚本打开即挂起、另一个打开即解挂，完美符合需求。

代码在最下边↓

#### 板块五——东南互保，服务互救

极域在设计`Master Helper.exe`时还留了一手，专门开了一个服务`STUDSRV`来为它救急。全称 $\operatorname{Student~Service}$，这个服务有时会和它的姊妹服务`GATESRV`同框，而后者作用至今未知……

根据前文，我们只要杀掉这个服务就可以实现一次到位的`Master Helper.exe`进程终止。因此加入如下段落：

```powershell
sc stop STUDSRV
sc delete STUDSRV
```

同时你还可以把循环体`a`里的`taskkill /f /t /im MasterHelper.exe`提到循环体外边去，为本就渣成渣的CPU减点负担……

### 红蜘蛛软件——可曾听闻我绿蜘蛛脚本的厉害？

在本人印象中，红蜘蛛似乎就仅仅只是一个吉祥物，只有在开机后那么几秒，它拖着上世纪复古风的“高清”启动界面在我的眼前一闪而过，然后静静地躲在任务栏的小图标里，践行它大隐隐于市的人生信条……

说实话要不是同学提醒我还真忘了机房里还有这位叫红蜘蛛的朋友，于是我着手开始破解它。~~红蜘蛛：我吃柠檬~~

#### 1. 这玩意怎么跟2345一个德行？

知道2345全家桶的同学们肯定对它恨之入骨，尤其是那些下载了2345的同学们。2345号称天朝第一大流氓软件，在无数人的电脑中如同鬼魂一般挥之不去。捆绑安装、弹窗广告、强制修改系统文件、浏览器劫持……无奇不有，关键是它的公司甚至推出极其出生的“推广包”机制来诱惑不良商户分发2345毒瘤软件。[这篇文章](https://zhuanlan.zhihu.com/p/256170072)介绍了清除2345的一种方案。

回到本节主题上来，为什么会取这样一种怨气十足的标题呢？是因为它和2345伪装成系统文件类似，红蜘蛛属于是反向利用了系统文件来给自己加上一层保护网。

打开任务管理器，除了霸占后台程序第一行的红蜘蛛本体，下面还有两个附属程序，名叫“3000soft通用组件”，如果直接终止进程，它很快会再次冒出来。将它们展开后发现叫做`checkrs.exe`和`rscheck.exe`的程序。那么运用上边经常用到的服务搜查法，我们发现了两个命名规则极其相似的服务：`appcheck2`和`checkapp2`。

![](https://pic.imgdb.cn/item/659143adc458853aefe98c57.png)

~~然而我事后才发现[红蜘蛛官网](http://www.3000soft.net/products/redspider-firewall.htm)早已自报家门了……血亏！~~

常规思想：我们使用`sc`命令结束这两个服务，然而……

![](https://pic.imgdb.cn/item/65e852059f345e8d03d29e0c.png)

显示无法停止，那怎么办呢？

考虑到这两个进程是红蜘蛛死掉后无限重启的命根，并且这两个进程也跟红蜘蛛主程序一样杀了就会重启……很明显，根本原因就是那两个服务，但是`sc`命令不管用了，咋办呢？（抠头）

这时我们就需要绕道而行，既然命令不行，我们转战注册表！打开注册表管理器，定位到`HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services`文件夹，它有很多个子文件夹，在下面定位到`appcheck2`和`checkapp2`，它的文件结构类似于这样（这里用别的服务替代一下）：

![](https://pic.imgdb.cn/item/65914643c458853aeff1f9f7.png)

（注意，这个并不是红蜘蛛的服务，是我临时找别的替代的，它们的注册表项名称相同，只是数据不同而已）

容易发现：`ImagePath`项指向了服务的根文件地址，也就是俗称的万恶之源，既然每次终止组件后它会自动重启服务，那我们为何不破坏这个`ImagePath`，让它指向一个不存在的地址，这样它就启动不了任何东西了。在我的绿蜘蛛`inf`文件里如此写到：

```ini
[Version]
Signature="$CHICAGO$"
Provider=justpureh2o@outlook.com, 2023

[DefaultInstall]
DelReg=Delete
AddReg=RedSpiderService.ValueModify

[RedSpiderService.ValueModify]
HKLM,"SYSTEM\CurrentControlSet\Services\appcheck2","ImagePath",0,"C:\Windows\SysWOW64\rschck.exe"
HKLM,"SYSTEM\CurrentControlSet\Services\checkapp2","ImagePath",0,"C:\Windows\SysWOW64\chekrs.exe"
```

然后你就可以用任务管理器终止两个通用组件，紧接着就可以终止红蜘蛛了！

由于本人目前对红蜘蛛知之甚少，可以看[这篇文章](https://blog.csdn.net/u013731154/article/details/116714463)了解更多！

### 学生机房管理助手——闻着臭吃着香

#### 1. 不用逆向，能得到什么结论？

其实一开始我以为它和极域一样是基于C++/C开发的因此无法反编译，直到回家之后我自己下载了一个。杀毒软件报毒删除了`set.exe`，打开`main.exe`主入口程序时它突然弹出了一条C#式的通知框提示`set.exe`未找到。于是果断打开dnSpy开启后面的破解，反编译破解的内容将在后面涉及到。

首先看到他的文件目录↓

![](https://pic.imgdb.cn/item/658fd722c458853aef07a8f4.png)

其中`zy`文件夹中存放的是各种浏览器的`exe`可执行文件，猜测是覆盖现有的高版本浏览器，以便它操作注册表禁止各种功能。

有一定经验的同学想必会一眼看到可疑的`yl.reg`注册表文件，但是先别急着合并注册表。首先，你的机器可能已经被禁用了注册表和任务管理器；第二，这个文件里也不是你心心念念的破解注册表（虽然后面我们会利用它破解机房管理助手）。对于未知的事物，最好还是保持谨慎勿近的态度为好……

除此之外，一个名叫`jfglzs.exe`的程序吸引了我，根据我多年混迹于首拼梗圈的我一秒钟就反应过来，知道它就是“机房管理助手”的首拼。我们之后的破解也围绕着这个东西进行。

##### 第一问 任务管理器、注册表、组策略咋解

![](https://pic.imgdb.cn/item/65914280c458853aefe5bbbb.png)

~~本人Win11系统，正常情况下任务栏设置上端会有一个任务管理器选项。~~

如果你稍微懂一点高级知识，你也许会使用`Win+R`，并输入`taskmgr`试图使用任务管理器。然而这不可能奏效，因为你会接到一则提示：

![](https://pic.imgdb.cn/item/659142d0c458853aefe6c12f.png)

输入`regedit`（注册表）和`gpedit.msc`（组策略管理器）也是一样的道理。很少很少的高材生会使用`mmc`试图加载组策略，但是这样也不可能奏效。搜索资料发现，修改注册表的某些键值可以实现禁用组策略、注册表、任务管理器的功能。深度分析`yl.reg`时就会发现这些东西：

![](https://pic.imgdb.cn/item/659142eec458853aefe71e3e.png)

第一行翻译过来就是：“禁用任务管理器”，它的值被设置成了`1`，也就是`true`。这一块还有禁止更改密码、禁止切换用户的设置等等。对于组策略，它的两个值则是存放在注册表：`HKEY_CURRENT_USER\Software\Policies\Microsoft\MMC`中的`RestrictToPermittedSnapins`；和它的子目录`HKEY_CURRENT_USER\Software\Policies\Microsoft\MMC\{8FC0B734-A0E1-11D1-A7D30000F87571E3}`中的`Restrict_Run`。如果不出意外，它们的值都是非零的，意味着组策略被禁用了。**要想破解，我们就需要用一个不直接调用注册表的方式来添加/更改注册表值**，这也就是下面将要提出的`inf`安装文件法。

**INF安装文件的机制**

提起绿色版软件，大家应该不会陌生，它省去了冗杂的`dll`等库文件，仅仅一个`exe`文件驱动整个程序。在绿色版软件安装时，有时就是用的`inf`文件安装法。一个可运行的`inf`文件包含几个项：

```ini
[Version]
Signature="$CHICAGO$"
Provider=somebody
```

`Version`段包含`inf`文件的基本信息，其中`Signature`指定了文件的适用系统，常见的值有`MS`、`WindowsNT`等，这里我们使用`CHICAGO`获得最广泛的支持（注意美元符号和引号的书写）。

```ini
[DefaultInstall]
DelReg=Delete
AddReg=Add
```

这一段声明了安装时所需的函数，`DelReg`负责删除注册表，`AddReg`负责创建/修改注册表。基本语法如下：

`DelReg`：`[ROOT] [PATH] [NAME]`，`ROOT`就是注册表中`HKEY`开头的那些，你可以写全称，也可以写缩写形式（`HK`+后两个单词的首字母，`HKEY_LOCAL_MACHINE=HKLM`）；`PATH`是包含指定键值的文件夹路径；`NAME`就是键值的名字。

`AddReg`：`[ROOT] [PATH] [NAME] [TYPE] [VALUE]`，`TYPE`指定了注册表值的类型（`0`相当于缺省，默认字符串；`1`为`DWORD`值，设置十六进制值时只需两个数字一组，中间逗号分隔开，一定保证输入的十六进制为8位，一定记得写前导0！）；`VALUE`即为键值，值为字符串时需要在前后打上半角双引号。

等号右侧的值相当于C++中的`typedef`，用来重命名函数，因此，在后续的安装代码中，我们的字段标识符都要与等号右侧的值相符才可，在我们的`inf`中，它表现为这样（`inf`文件的注释用分号表示）：

```ini
[Delete]
HKCU,"Software\Policies\Microsoft\MMC","RestrictToPermittedSnapins"
HKCU,"Software\Policies\Microsoft\MMC\{8FC0B734-A0E1-11D1-A7D30000F87571E3}","Restrict_Run"

[Delete]
HKCU,"Software\Microsoft\Windows\CurrentVersion\Policies\System","DisableRegistryTools"
HKCU,"Software\Microsoft\Windows\CurrentVersion\Policies\System","DisableTaskMgr"
HKCU,"Software\Microsoft\Windows\CurrentVersion\Policies\System","DisableChangePassword"
HKCU,"Software\Microsoft\Windows\CurrentVersion\Policies\System","DisableCMD"

[Delete]
HKCU,"Software\Microsoft\Windows\CurrentVersion\Policies\System","DisableSwitchUserOption"
HKCU,"Software\Microsoft\Windows\CurrentVersion\Policies\System","HideFastUserSwitching"
```

在记事本里编辑即可，记得保存为`.inf`文件，而后右键“安装”，或者在`cmd`里运行：`InfDefaultInstall + inf文件地址`（前提是你的`cmd`没被禁止）。

除此之外，我们发现了一些好玩的东西：`yl.reg`的最后几十行，将常用浏览器的起始界面通过注册表的方式修改成了它的官网，学有余力的娃们可以通过刚才介绍的`AddReg`函数把它的值改成你想要的值，在这里我换成了我精心制作的嘲讽页面：

```ini
[Add]
HKLM,"SOFTWARE\Policies\Microsoft\Internet Explorer\Main","Start Page",0,"https://justpureh2o.github.io/2023/12/24/cracked-23-12-23"
HKLM,"SOFTWARE\Microsoft\Internet Explorer\MAIN","Start Page",0,"https://justpureh2o.github.io/2023/12/24/cracked-23-12-23"
HKLM,"SOFTWARE\Microsoft\Internet Explorer\MAIN","First Home Page",0,"https://justpureh2o.github.io/2023/12/24/cracked-23-12-23"
HKLM,"SOFTWARE\Wow6432Node\Baidu\BaiduProtect\LockIEStartPage","Start Page",0,"https://justpureh2o.github.io/2023/12/24/cracked-23-12-23"
HKLM,"SOFTWARE\Wow6432Node\Software\Microsoft\Internet Explorer\Main","Start Page",0,"https://justpureh2o.github.io/2023/12/24/cracked-23-12-23"
HKLM,"SOFTWARE\Wow6432Node\Software\Microsoft\Internet Explorer\Main","Default_Page_URL",0,"https://justpureh2o.github.io/2023/12/24/cracked-23-12-23"
HKEY_USERS,".DEFAULT\Software\Microsoft\Internet Explorer\Main","Start Page",0,"https://justpureh2o.github.io/2023/12/24/cracked-23-12-23"
HKEY_USERS,".DEFAULT\Software\Microsoft\Internet Explorer\Main","First Home Page",0,"https://justpureh2o.github.io/2023/12/24/cracked-23-12-23"
HKEY_USERS,"S-1-5-18\Software\Microsoft\Internet Explorer\Main","Start Page",0,"https://justpureh2o.github.io/2023/12/24/cracked-23-12-23"
HKEY_USERS,"S-1-5-18\Software\Microsoft\Internet Explorer\Main","First Home Page",0,"https://justpureh2o.github.io/2023/12/24/cracked-23-12-23"
```

~~`yl.reg`——队友坑害全队的典型例子。~~

当一切完成之后，你就可以自由使用任务管理器了，被锁定了`cmd`的同学们也可以尽情使用`taskkill`了！诶等等，事情好像有点不对劲……

##### 第二问 我的taskkill去哪了

~~可是我的taskkill还好好地躺在`System32`文件夹里啊~~

为找出机房管理助手禁用`taskkill`的内部机理，我从网上下载了一个`taskkill.exe`和ClassX放在同级目录下，两者的运行结果如下图：

![](https://pic.imgdb.cn/item/65e854de9f345e8d03de29ab.png)

上边是网上下载的`taskkill`、下边是系统自带的`taskkill`。容易发现机房管理助手使用了某种针对文件名的程序禁用策略。那好办，把下载下来的`taskkill`改个名字就好了，我改成了`tskill`，相应地，ClassX里的对应代码也要改变：

```powershell
:a
tskill /f /t /im MasterHelper.exe
tskill /f /t /im ProcHelper64.exe
TIMEOUT /T 1
goto a
```

![](https://pic.imgdb.cn/item/65e856f79f345e8d03e67134.png)

好耶！

逆向思维，我们可以不用下载`taskkill`，直接在`C:\Windows\System32\`下改名字。如果出现以下情况：

![](https://pic.imgdb.cn/item/65e857f29f345e8d03eab416.png)

提示你需要`Trusted Installer`提供的权限，就按照如下步骤操作：

打开`cmd`，输入`takeown /f [PATH] /a /d /r y && icacls [PATH] /grant [USERNAME]:F"`，其中`[PATH]`为文件路径、`[USERNAME]`为电脑用户名，通常启动`cmd`时显示的`C:\Users\`后就是用户名。输入完毕回车，就可以对文件进行重命名了。

当然也可以将下边代码存成一个`.reg`文件，双击，选择确定添加，对指定文件右键，选择“获取Trusted Installer权限即可”。

```ini
Windows Registry Editor Version 5.00

[HKEY_CLASSES_ROOT*shellunas]@="获得Trustedinstaler权限"

[HKEY_CLASSES_ROOT*shellunascommand]@="cmd.exe /c takeown /f "%1" && icacls "%1" /grant administrators:F""IsolatedCommand"="cmd.exe /c takeown /f "%1" && icacls "%1" /grant administrators:F"

[HKEY_CLASSES_ROOTDirectoryshellunas]@="获得Trustedinstaler权限""NoWorkingDirectory"=""

[HKEY_CLASSES_ROOTDirectoryshellunascommand]@="cmd.exe /c takeown /f "%1" /r /d y && icacls "%1" /grant administrators:F /t""IsolatedCommand"="cmd.exe /c takeown /f "%1" /r /d y && icacls "%1" /grant administrators:F /t"
```

一通操作下来，这是成果：

![](https://pic.imgdb.cn/item/65e85cad9f345e8d03feb639.png)

所以这到底是成功了还是没成功？它甚至连输出都没有了……事后查看任务管理器可以发现，这个方法是行之有效的！

---

事实上，机房管理助手使用了一个比较粗显的办法来禁用包括`taskkill`在内的诸多“可能造成威胁”的程序，根据上文探究，我们发现这种禁用策略基于文件名（改个名字就可以绕过），在我遇到这种情况时，我的脑子里第一反应就是——重定向。接下来介绍一种在Windows里操作注册表实现按文件名重定向的方法：

**映像劫持**

简称IEFO，原本是Windows提供给一些程序，用以进行调试的注册表项。只不过在更多时候，它被拿去给某些无良人士做软件禁用了……

定位到注册表路径`HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\`下，不出意外的话，目录下会有很多以文件名命名的子文件夹：

![](https://cdn.luogu.com.cn/upload/image_hosting/81lj59cc.png)

（看来来对地方了）

这里不仅有老朋友`taskkill`，还有我们的好朋友`ntsd`，它们都被拿捏了。~~不要怕，马上救你们于水火之中！~~

> **注意**：慎重修改除ntsd和taskkill以外的项，修改这些项可能导致系统某些功能无法正常运作！

在`taskkill`项里，有一个字符串值，值为`null`，也就是一个空值。在这里，可以直接删除`taskkill`项，或者删除`debugger`字符串值，你也可以把`debugger`的值直接修改为`taskkill.exe`。对于`ntsd`项同理。

![](https://cdn.luogu.com.cn/upload/image_hosting/5a6vbv0l.png)

（我选择删除`debugger`值，现在可以正常使用`taskkill`了）

解除映像劫持的代码也写进解锁脚本里了。

##### 第三问 yl.reg到底写了啥

其实最扎眼的就是它里面写的~~宣（补）战（贴）名单~~各种脱控工具箱，说实话那些工具箱软件我基本上一个都没见过……

这些注册表项有一个很普遍的特征，它们无一例外指向了注册表`HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\safer\codeidentifiers\0\Hashes`下很多以`GUID`形式命名的文件夹，那么这些文件夹具体起什么作用呢？

这其实是组策略管理器的黑名单，具体[见此](https://learn.microsoft.com/zh-cn/windows-server/identity/software-restriction-policies/determine-allow-deny-list-and-application-inventory-for-software-restriction-policies)，没错，组策略可以限制指定软件的运行。但是很遗憾，这些配置全部存放在上述的注册表里面。你可以把注册表看做系统的配置文件，操作系统几乎所有配置信息、甚至包括大部分软件程序的配置都存放在注册表中。~~这么看来除了BIOS没别的安全地方了~~

如果想要禁用这些项，并不需要挨个将每个文件删去，而是看到他的其中一个父文件夹`codeidentifiers`。它里面有一个二进制值`authenticodeenabled`，它指定组策略黑名单的ID标识符，也就是`codeidentifier`文件夹下以数字命名的文件夹，只有当子文件夹的名称与ID标识符相同时才会启用该文件夹下的配置。因此我们釜底抽薪，直接更改`authenticodeenabled`的值：

```ini
[Add]
HKLM,"SOFTWARE\Policies\Microsoft\Windows\safer\codeidentifiers","authenticodeenabled",1,00,11,45,14
```

#### 假如我掏出逆向工具，阁下又该如何应对？

正如开头所说，学生机房管理助手由C#开发，因此可以用`dnSpy`反编译它的可执行文件，得到源码。那么我们就开始吧！

##### 第一框 密码是啥

正如大多数软件那样，机房管理助手对它的源代码进行了一轮套壳，也就是代码混淆。为了让代码变成我们都容易看的形式。我们使用C#脱壳软件NET Reactor Slayer进行反混淆（代码混淆工具为NET Reactor）。然后再用dnSpy对机房管理助手的设置模块`set.exe`进行反编译，就可原模原样扒出下边这段C#代码（以上两个工具均可在GitHub下载到最新版）

```csharp
using System;
using System.Security.Cryptography;
using System.Text;
using System.IO;

public class Program
{
	public static void Main()
	{
                string string_3;

                Console.Write("Input Passcode Here: ");
                string stmp = Console.ReadLine();
                if (stmp != null) string_3 = stmp;
                else {
                Console.WriteLine("Interrupted by Ctrl+Z! Restart to retry...");
                return;
                }
		//string string_3 = "12345678";
		// Class6.smethod_0()
		string value = "C:\\WINDOWS";
		string s = value.Substring(0, 8);
		string s2 = value.Substring(1, 8);
		DESCryptoServiceProvider descryptoServiceProvider = new DESCryptoServiceProvider();
		descryptoServiceProvider.Key = Encoding.UTF8.GetBytes(s);
		descryptoServiceProvider.IV = Encoding.UTF8.GetBytes(s2);
		MemoryStream memoryStream = new MemoryStream();
		CryptoStream cryptoStream = new CryptoStream(memoryStream, descryptoServiceProvider.CreateEncryptor(), CryptoStreamMode.Write);
		StreamWriter streamWriter = new StreamWriter(cryptoStream);
		streamWriter.Write(string_3);
		streamWriter.Flush();
		cryptoStream.FlushFinalBlock();
		memoryStream.Flush();
		string string_4 = Convert.ToBase64String(memoryStream.GetBuffer(), 0, checked((int)memoryStream.Length));
		// Class6.smethod_3()
		StringBuilder stringBuilder = new StringBuilder();
		for(int i = 0; i < string_4.Length; i++)
			stringBuilder.Append((char)(string_4[i] - 10));
		string_3 = stringBuilder.ToString();
		// Class6.smethod_2()
		MD5CryptoServiceProvider md5CryptoServiceProvider = new MD5CryptoServiceProvider();
		byte[] array2 = md5CryptoServiceProvider.ComputeHash(Encoding.Default.GetBytes(string_3));
		stringBuilder.Clear();
		for (int i = 0; i < array2.Length; i++)
			stringBuilder.Append(array2[i].ToString("x2"));
		string str = stringBuilder.ToString().Substring(10);

		Console.WriteLine(str);
	}
}

```

在脱离控制之前，需将机房管理助手的互保程序至少挂起一个！使用 `pssuspend jfglzs.exe` 以达到该效果！**千万不要没挂起就改注册表，会寄，相信我**！

[在这里](https://try.dot.net)可以在线运行上边的代码并获得输出。

同时，机房管理助手的密码MD5文件存放在注册表`HKEY_CURRENT_USER\Software`下的字符串值`n`里面。更改即生效！注意若要完全退出，则需要重新解除挂起，输入密码才行；如果怕被发现需要重启，定位到机房管理助手安装目录，打开目录下的`jfglzs.exe`和`przs.exe`即可（别听他瞎扯，不需要重启电脑就可以重新复活机房管理助手）。

### 代码环节

#### ClassX

**如果安装了学生机房管理助手则先运行下边的“学生机房管理助手通用破解”，再运行这个脚本**

**使用方法**：另存为`.bat`文件直接运行

```powershell
@echo off
 
>nul 2>&1 "%SYSTEMROOT%\System32\cacls.exe" "%SYSTEMROOT%\System32\config\system"
 
 
if %errorlevel% == 0 (
    echo Admin Switched!
) else (
    echo Level Ascending... Restart
 
    powershell -command "Start-Process '%0' -Verb RunAs"
    exit
)

sc stop tdnetfilter
sc delete tdnetfilter
sc stop tdfilefilter
sc delete tdfilefilter
sc stop GATESRV
sc delete GATESRV
sc stop STUDSRV
sc delete STUDSRV

taskkill /f /t /im MasterHelper.exe
taskkill /f /t /im ProcHelper64.exe

pause
```

#### 绿蜘蛛

**使用方法**：另存为`.inf`文件→右键安装；任务管理器先结束进程3000soft通用组件，再结束红蜘蛛软件

```ini
[Version]
Signature="$CHICAGO$"
Provider=justpureh2o@outlook.com, 2023

[DefaultInstall]
DelReg=Delete
AddReg=RedSpiderService.ValueModify

[RedSpiderService.ValueModify]
HKLM,"SYSTEM\CurrentControlSet\Services\appcheck2","ImagePath",0,"C:\Windows\SysWOW64\rschck.exe"
HKLM,"SYSTEM\CurrentControlSet\Services\checkapp2","ImagePath",0,"C:\Windows\SysWOW64\chekrs.exe"
```

#### 机房管理杀手

**使用方法**：另存为`.inf`文件→右键安装

```ini
[Version]
Signature="$CHICAGO$"
Provider=justpureh2o@outlook.com, 2023

[DefaultInstall]
DelReg=Delete
AddReg=Add

[Delete] ; 你以为只有你会劫持？
HKLM,"SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\taskkill.exe","debugger"
HKLM,"SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\ntsd.exe","debugger"

[Delete] ; 大坏蛋，放开那个组策略管理器！
HKCU,"Software\Policies\Microsoft\MMC","RestrictToPermittedSnapins"
HKCU,"Software\Policies\Microsoft\MMC\{8FC0B734-A0E1-11D1-A7D30000F87571E3}","Restrict_Run"

[Delete] ; 注册表和任务管理器我来接手，你可以卷铺盖走人了！
HKCU,"Software\Microsoft\Windows\CurrentVersion\Policies\System","DisableRegistryTools"
HKCU,"Software\Microsoft\Windows\CurrentVersion\Policies\System","DisableTaskMgr"
HKCU,"Software\Microsoft\Windows\CurrentVersion\Policies\System","DisableChangePassword" 
HKCU,"Software\Microsoft\Windows\CurrentVersion\Policies\System","DisableCMD"

[Delete] ; 我就要切换用户！
HKCU,"Software\Microsoft\Windows\CurrentVersion\Policies\System","DisableSwitchUserOption"
HKCU,"Software\Microsoft\Windows\CurrentVersion\Policies\System","HideFastUserSwitching"

[Delete] ; 如果把我桌面搞乱了张伟会清理掉我的文件滴
HKCU,"Software\Microsoft\Windows\CurrentVersion\Explorer","DesktopProcess"

[Add] ; 加点料才香~
HKLM,"SOFTWARE\Policies\Microsoft\Windows\safer\codeidentifiers","authenticodeenabled",1,00,11,45,14
HKLM,"Software\Microsoft\Windows\CurrentVersion\Policies\System","NoConfigPage",1,00,00,00,01
HKLM,"Software\Microsoft\Windows\CurrentVersion\Policies\System","NoDevMgrPage",1,00,00,00,01

[Add] ; 嘲讽一波这sb管理助手，关键你就算换成自己的网页学校的破网也加载不出来（笑）
HKLM,"SOFTWARE\Policies\Microsoft\Internet Explorer\Main","Start Page",0,"https://justpureh2o.github.io/misc/"
HKLM,"SOFTWARE\Microsoft\Internet Explorer\MAIN","Start Page",0,"https://justpureh2o.github.io/misc/"
HKLM,"SOFTWARE\Microsoft\Internet Explorer\MAIN","First Home Page",0,"https://justpureh2o.github.io/misc/"
HKLM,"SOFTWARE\Wow6432Node\Baidu\BaiduProtect\LockIEStartPage","Start Page",0,"https://justpureh2o.github.io/misc/"
HKLM,"SOFTWARE\Wow6432Node\Software\Microsoft\Internet Explorer\Main","Start Page",0,"https://justpureh2o.github.io/misc/"
HKLM,"SOFTWARE\Wow6432Node\Software\Microsoft\Internet Explorer\Main","Default_Page_URL",0,"https://justpureh2o.github.io/misc/"
HKEY_USERS,".DEFAULT\Software\Microsoft\Internet Explorer\Main","Start Page",0,"https://justpureh2o.github.io/misc/"
HKEY_USERS,".DEFAULT\Software\Microsoft\Internet Explorer\Main","First Home Page",0,"https://justpureh2o.github.io/misc/"
HKEY_USERS,"S-1-5-18\Software\Microsoft\Internet Explorer\Main","Start Page",0,"https://justpureh2o.github.io/misc/"
HKEY_USERS,"S-1-5-18\Software\Microsoft\Internet Explorer\Main","First Home Page",0,"https://justpureh2o.github.io/misc/"
; TODO 再给你多附赠几个浏览器hh
HKCU,"Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedgedevtoolsclient_8wekyb3d8bbwe\MicrosoftEdgeMain","Start Page",0,"https://justpureh2o.github.io/2023/12/24/cracked-23-12-23" ; Edge 浏览器主页
```

#### 通用挂起&解挂

**使用方法**：另存为两个`.bat`文件

**开局即挂起**

```bash
@echo off
chcp 65001

echo 初次运行需在弹出窗口中点击 Agree 同意第三方软件用户许可证
echo 三秒后执行挂起，请注意切换窗口！
TIMEOUT /T 3
goto a

:a
pssuspend StudentMain.exe
echo 挂起成功！按任意键解挂...
pause
pssuspend -r StudentMain.exe
echo 解挂成功！按任意键挂起...
pause
goto a
```

**开局即解挂**

```bash
@echo off
chcp 65001

echo 初次运行需在弹出窗口中点击 Agree 同意第三方软件用户许可证
echo 三秒后执行解挂，请注意切换窗口！
TIMEOUT /T 3
goto a

:a
pssuspend -r StudentMain.exe
echo 解挂成功！按任意键挂起...
pause
pssuspend StudentMain.exe
echo 挂起成功！按任意键解挂...
pause
goto a
```
