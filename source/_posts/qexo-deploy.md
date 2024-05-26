---
abbrlink: ''
categories:
- - 博客搭建
date: '2024-02-15T09:52:57.521119+08:00'
headimg: https://pic.imgdb.cn/item/65cd8ca29f345e8d034f412f.png
tags:
- 博客
- qexo
- 后端
title: Hexo云后台——Qexo搭建教程
updated: '2024-03-10T09:03:10.078+08:00'
---
在开始之前，首先你需要有一个自己的域名（`github.io`不算在内，你必须能够亲自更改DNS解析设置），并在博客仓库设置的Pages选项卡中绑定自己的域名。

### 部署Qexo环境

官方提供了四种方式来部署Qexo环境，其中一种允许你在本地进行部署，另外三种各自使用了不同网站提供的免费数据库服务。综合考虑操作便捷性和成功率，这里选用Vercel提供的免费PostgreSQL服务进行部署。

首先点击[这里](https://vercel.com/new/clone?repository-url=https://github.com/am-abudu/Qexo)进入Vercel的仓库克隆界面。建议新建一个私有仓库进行Qexo仓库的克隆工作，第一次操作时你需要授权Vercel登录你的Github账号，在新跳出的浏览器窗口里按顺序授权即可。

设置好仓库名称后，点击`Create`创建，下边会有一个`Deploy`界面。Vercel在创建和更改仓库时会自动进行一次部署，因此创建完毕后部署将会自动启动，并且这第一次部署是一定会失败的。因为Qexo所依赖的数据库还没有配置。因此点击网页左上角的三角形符号，或者点[这里](https://vercel.com/dashboard)快捷进入你的项目管理页面。不出意外的话，界面将是这个样子：

![](https://pic.imgdb.cn/item/65cd75059f345e8d0314b216.png)

（我这里是已经配置好了Qexo）

然后我们开始配置PostgreSQL数据库，在[Storage](https://vercel.com/justpureh2os-projects/~/stores)界面可以申请，点击右上角`Create Database`并选择`Postgres`，Vercel的免费Postgre数据库仅限创建一个，如果你先前没有配置过——点击`Continue`进入数据库连接配置，在`Connect`界面选择地区为`Washington DC`或者`USA (east)`。创建完毕后，在`Storage`选项卡里选择进入你创建的数据库配置界面。在左侧边栏点击`Project`，接着点击`Connect Project`：

![](https://pic.imgdb.cn/item/65cd78019f345e8d031b8c58.png)

选择自己想要部署Qexo的仓库即可，接着回到项目管理界面，点击部署用的仓库。在`Settings`里面选择`Domains`域名选项，添加自己购买的域名。**注意不要将域名指向到主页地址，如果你购买的主域名是abcd.xyz，此处建议绑定到它的子域名admin.abcd.xyz，而不能直接绑定到abcd.xyz！**。

当你添加了一个目标域名后，Vercel会自动对填入的域名进行DNS检查，若第一次配置，大概率会出现以下情况：

![](https://pic.imgdb.cn/item/65cd7e2f9f345e8d032acc60.png)

此时你需要打开自己域名的DNS解析设置，添加一个A解析：主机记录为`@`，记录值为`76.76.21.21`。补充一句，这个IP地址指向`vercel.app`的域名服务器，然而这个域名已经处于DNS污染的状态，无法访问。Vercel的临时备用方案是将IP改成`76.223.126.88`，事实证明到现在这个方案还是有效的。

配置完部署域名后，转到顶端选项卡`Deployment`中点击`Redeploy`开始二次部署。一般等待一分钟左右无报错信息即可完成部署。

如果你使用的是`MongoDB`，有可能在二次部署开始三到四分钟后接收到部署失败的信息。如果失败信息里出现了类似于`handshake failed`的握手失败信息时，建议放弃该方法（很可能是国内墙掉了MongoDB的连接接口导致部署时无法访问）并转而使用上边介绍的PostgreSQL法重新部署。

查看其他部署具体步骤，见[官方文档——部署](https://www.oplog.cn/qexo/start/build.html)；若部署时遇到报错，可以进入[官方文档——常见问题](https://www.oplog.cn/qexo/start/questions.html)排错。

### 初始化Qexo

#### Github配置

部署完毕后，切换到绑定的域名，本例中我们转到`admin.abcd.xyz`。如果没有出现Qexo的初始化配置界面，试着转到`admin.abcd.xyz/init/`。如果你使用Hexo，并在Github上托管，在Github的配置界面，你会看到这几项：

![](https://pic.imgdb.cn/item/65cd80789f345e8d0330a703.png)

（这是已经配置好的Qexo的设置界面，只是我将填写的内容删去了，但是项目是完全一致的）

Github密钥这一项，你需要在[Github设置](https://github.com/settings/tokens)中申请。右上角选择`Generate New Token`，有两个选项，选择`classic`。接着完成身份验证。改变如下几项：

![](https://pic.imgdb.cn/item/65cd81e59f345e8d033410e3.png)

`Note`必填，作为这个token的使用目的；`Expiration`是生效期限，安全起见建议设置一个较短的期限，然后定时重置，重新配置Qexo设置，这里我选择的是永久有效；在下边的生效条目里，保证`repo`下的复选框全部勾选，建议同时勾选`workflow`，但官方不建议给出所有权限。这么做的目的是保证Qexo有足够权限访问Github API从而在线修改Github博客源码的内容。

申请完毕后复制下来，出于安全，Github仅在token初次创建完毕后给出复制选项，所以尽快保存，并填入初始化界面的“Github 密钥”文本框中。

然后在Github里新建仓库，用于存放博客源码。接着在本地转到你的博客源码文件夹中（就是你执行`hexo clean & hexo g & hexo d`的文件夹），右键点击`git bash here`，依次键入以下的代码：

1. （“查看”里勾选“显示隐藏的文件”后，若源码目录下没有名为`.git`的文件夹，有则跳过该步骤）`git init`
2. 复制仓库的网页地址，例：`https://github.com/<username>/<repo>`
3. 输入`git remote add <name> https://github.com/<username>/<repo>.git`（这里的`<name>`任取，但保证先前未创建过，且不与已经存在的`<name>`重复，否则将可能不会上传当前的文件夹）
4. 输入`git pull <name> master`，`master`可更改，但保证和新建仓库的主branch同名
5. 输入`git add .`（注意有个点）
6. 输入`git commit -m "Commit内容"`（内容可更改，但需要用半角双引号包裹起来）
7. 输入`git push <name> master`（`master`保持前后一致即可）

如果是第一次上传，按顺序执行以下七步操作；如果已经上传过了，想要提交一些个人的更改，执行第四到第七步即可。“Github 仓库”这一项就填刚刚创建并上传的源码仓库，格式是`<username>/<repo>`（例：`mynameisabcd/BlogSourceCode`）。

“项目分支”填源代码仓库的主要分支，一般是`master`；“博客路径”留空即可。

若使用Gitlab，或者想要通过本地进行初始化，见[官方文档](https://www.oplog.cn/qexo/configs/provider.html)。

#### Vercel配置

“VERCEL_TOKEN”一项，需要在[这里](https://vercel.com/account/tokens)生成。

![](https://pic.imgdb.cn/item/65cd88989f345e8d0344c1cf.png)

同样是填写token名称、生效范围（这里选择`xxx's projetcs`）和生效期限（建议期限短些）。完毕后点击`Create`生成密钥，也是需要尽快复制下来，粘贴到“VERCEL_TOKEN”里。

“PROJECT_ID”则需要回到Vercel对应的项目的`Settings`里，在`General`选项卡中向下翻到`Project ID`并复制内容，粘贴到`PROJECT_ID`中就完成Vercel配置了。

接下来你还需要设置管理员账号密码，设置完毕后就可以从`admin.abcd.xyz`快捷进入管理界面了。

#### 自动部署

好吧这个自动部署才是耗时最久、踩坑最多的一步。

按照官方文档所述，Github Action的配置文件应该是下边这样：

```yaml
name: 自动部署 Hexo

on:
  push:
    branches:
      - master

jobs:
  build:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [10.x]

    steps:
      - name: 开始运行
        uses: actions/checkout@v1

      - name: 设置 Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v1
        with:
          node-version: ${{ matrix.node-version }}

      - name: 安装 Hexo CI
        run: 
          export TZ='Asia/Shanghai'
          npm install hexo-cli -g

      - name: 缓存
        uses: actions/cache@v1
        id: cache-dependencies
        with:
          path: node_modules
          key: ${{runner.OS}}-${{hashFiles('**/package-lock.json')}}

      - name: 安装插件
        if: steps.cache-dependencies.outputs.cache-hit != 'true'
        run: 
          npm install

      - name: 部署博客
        run: 
          hexo clean && hexo g && hexo douban && gulp
          cd ./public
          git init
          git config user.name "${{secrets.GIT_NAME}}"
          git config user.email "${{secrets.GIT_EMAIL}}"
          git add .
          git commit -m "Update"
          git push --force --quiet "https://${{secrets.GH_TOKEN}}@${{secrets.GH_REF}}" master:master
          git push --force --quiet "https://${{secrets.CD_TOKEN}}@${{secrets.CD_REF}}" master:master
```

或许是因为某些原因，如上的配置**并不正确**。相应地，这段错误的配置文件导致我在接下来的两天时间里出现了几十次部署错误。接下来针对这段代码进行修改：

首先，子任务里多行代码的写法是在签名的冒号后加上竖线，例如：

```yaml
- name: 部署博客
  run: |
    lineA
    lineB
    lineC
```

如果不加竖线，每个函数仅能执行第一行代码。顺便提一句，`yaml`对每行代码的缩进非常严格，正规做法是每次仅缩进**两个半角空格**，和平时习惯使用的四个半角空格有所差异。

接着是`Node.js`的问题，建议将版本编辑为`14`以上，否则新版`Hexo`的某些功能可能无法正常工作。修改成以下：

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [18.x]
```

如果你在博客上应用了类似于Pandoc这样需要本地程序依赖的插件，则需要另外加入一个配置代码：

```yaml
- name: 安装Pandoc
  uses: nikeee/setup-pandoc@v1
```

最后，如果你按照官方文档的教程走了一遍，设置了Github Secrets，并且在自动部署时接收到类似于这样的消息时：

```
fatal: could not read Username for 'https://github.com': No such device or address
```

先检查有没有给git设置用户名和密码，如果设置了还是报出这样的错误提示。那么请转到根目录下`_config.yml`，将`deploy`更改为以下形式：

```yaml
# Deployment
## Docs: https://hexo.io/docs/one-command-deployment
deploy:
  type: git
  repo: https://<Your Github Token>@github.com/<Your Username>/<Your Username>.github.io.git
  branch: master
```

若是担心Token的保密问题，可以将存放博客源代码的Github仓库设为私有。

本博客的自动部署脚本如下（有些地方因为怕出现其他问题所以可能没有删去理论上多余的代码）：

```yaml
name: 自动部署 Hexo

on:
  push:
    branches:
      - master

jobs:
  build:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [18.x]

    steps:
      - name: 开始运行
        uses: actions/checkout@v2
        with:
          submodules: true
  
      - name: 安装Pandoc
        uses: nikeee/setup-pandoc@v1
  
      - name: 设置 Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v1
        with:
          node-version: ${{ matrix.node-version }}

      - name: 安装 Hexo CI
        run: |
          export TS='Asia/Shanghai'
          npm install hexo-cli -g

      - name: 缓存
        uses: actions/cache@v1
        id: cache-dependencies
        with:
          path: node_modules
          key: ${{runner.OS}}-${{hashFiles('**/package-lock.json')}}
  
      - name: 安装依赖插件
        run: |
          # Install Plugins with 'npm install'
  
      - name: 安装插件
        if: steps.cache-dependencies.outputs.cache-hit != 'true'
        run: |
          npm install
  
      - name: 配置SSH私钥
        env:
          HEXO_DEPLOY_PRIVATE_KEY: ${{secrets.GIT_PRI}}
        run: |
          mkdir -p ~/.ssh/
          echo "$HEXO_DEPLOY_PRIVATE_KEY" > ~/.ssh/id_rsa 
          chmod 600 ~/.ssh/id_rsa
          ssh-keyscan github.com >> ~/.ssh/known_hosts  

      - name: 部署博客
        run: | 
          # 这下边对git的配置理论上都是多余的，但以防万一还是没删
          # hexo clean 以下的代码都是必需的，不可删去
          git config --global credential.helper store
          git config --global init.defaultBranch master
          git config --global user.name "${{secrets.GIT_NAME}}"
          git config --global user.email "${{secrets.GIT_EMAIL}}" 
          git config --global user.password "${{secrets.GIT_PSW}}"
          hexo clean
          hexo g -d
          cd ./public
          git init
          git add .
          git commit -m 'Update'
          git push --force --quiet 'https://${{secrets.GH_TOKEN}}@github.com/${{secrets.GH_REF}}' master

```

### 其他设置

#### 设置友链

在博客源码目录里打开命令行，输入`hexo new page links`创建友链页面，打开`source/links/index.md`，将`front-matter`修改成如下格式：

```ini
---
layout: friends # 必须
title: 我的朋友们 # 可选，这是友链页的标题
---
```

并且在`front-matter`后的正文部分直接粘贴：

```html
<div id="qexo-friends"></div>
<link rel="stylesheet" href="https://unpkg.com/qexo-friends/friends.css"/>
<script src="https://cdn.jsdelivr.net/npm/qexo-static@1.6.0/hexo/friends.js"></script>
<script>loadQexoFriends("qexo-friends", "Qexo部署的网址")</script>

```

需要更改“Qexo部署的网址”为你方才Vercel设置里填写的域名。

部分主题有专门的主题适配选项，详情见[这里](https://www.oplog.cn/qexo/exts/flinks.html#%E4%B8%BB%E9%A2%98%E9%80%82%E9%85%8D)。

#### 设置说说

在Hexo源代码根目录里新建页面`hexo new page talks`。

在`source/talks/index.md`中正文部分加入：

```html
<div id="qexot"></div>
<script src="https://cdn.jsdelivr.net/npm/qexo-static@1.6.0/hexo/talks.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/qexo-static@1.6.0/hexo/talks.css">
<script>showQexoTalks("qexot", "Qexo部署的网址", 5)</script>

```

同样是更改“Qexo部署的网址”，网址后的数字代表每页展示的说说个数，可根据需要自行调整。还可以[美化样式](plog.cn/qexo/exts/talks.html#可选-个性化)。
