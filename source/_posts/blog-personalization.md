---
abbrlink: ''
categories:
- - 开发记录
- - 博客搭建
date: '2024-02-22T15:18:20.738525+08:00'
tags:
- 博客
- 前端
- 后端
- 开发记录
title: Volantis魔改记录
updated: '2024-05-01T22:01:36.403+08:00'
---
**在此记录我个人对博客的一些个性化改造**

本博客使用Volantis（v6 alpha 1）主题。

---

### 前端类

#### 刷新式Banner

对视差滚动插件$\operatorname{Parallax}$进行改造，将原先的定时更换变为了刷新更换，以减少窗口重获焦点后重复加载图片的问题。

`themes/volantis/layout/_plugins/parallax/script.ejs`

```js
// In function 'parallax()'
// ...
	next_parallax();
        Parallax.init();
	index++;
/*     - if (imgs.length>1) {
       - IntervalParallax = setInterval(function () {
       - next_parallax();
       - }, '<%- theme.plugins.parallax.duration %>');
    - } */

// In function 'next_parallax()'
// ...
    if (imgs.length>=1) {
          // + Parallax.options.src = imgs[new Date().getTime() % imgs.length];
	  Parallax.options.src = imgs[new Date().getTime() % imgs.length];
          // - Parallax.options.src = imgs[index % imgs.length];
      Parallax.start();
      index++;
      if (Parallax.cache) {
        fetch(imgs[index % imgs.length] +"?t=" + new Date().getTime());
        if (index == imgs.length) {
          Parallax.cache = 0;
        }
      }
    }
```

在[这里](https://justpureh2o.cn/picinfo/banners/)查看本网站的Banner信息

[预览新Banner效果](https://justpureh2o.cn)（多次刷新效果更佳）

#### OJ网站题目标签

$\begin{array}{c}Update~2024.3.22&\end{array}$简化了洛谷样式的HTML标签

添加了常用OJ网站（洛谷、AcWing）的题目难度标签CSS，现在可以直接通过`span`标签显示：

**洛谷风格**

1. <span data-luogu data-grey>printf("China\n");</span>
2. <span data-luogu data-red>用脚切的题</span>
3. <span data-luogu data-orange>只用一只手切的题</span>
4. <span data-luogu data-yellow>大规模出现DP、字符串、模拟等恶心题</span>
5. <span data-luogu data-green>恭喜你进阶提高组</span>
6. <span data-luogu data-blue>只要线代学得好，蓝题狂刷少不了</span>
7. <span data-luogu data-purple>同学，网络流好学吗</span>
8. <span data-luogu data-black>构造秒了</span>
9. 题目来源：<span data-luogu data-source>收钱协会举办的比赛之提高组</span>&nbsp;&nbsp;&nbsp;&nbsp;<span data-luogu data-source>收钱协会举办的比赛之普及组</span>&nbsp;&nbsp;&nbsp;&nbsp;<span data-luogu data-source>多 人 信 息 学 比 赛</span>&nbsp;&nbsp;&nbsp;&nbsp;<span data-luogu data-source>残 害 奶 牛 组 织 举 办 的 比 赛</span>
10. 相关比赛年份：<span data-luogu data-date>2024</span>&nbsp;&nbsp;&nbsp;&nbsp;<span data-luogu data-date>2023</span>&nbsp;&nbsp;&nbsp;&nbsp;<span data-luogu data-date>2077</span>&nbsp;&nbsp;&nbsp;&nbsp;<span data-luogu data-date>2233</span>
11. 算法标签：<span data-luogu data-algorithm>大模拟</span>&nbsp;&nbsp;&nbsp;&nbsp;<span data-luogu data-algorithm>退火邪教</span>&nbsp;&nbsp;&nbsp;&nbsp;<span data-luogu data-algorithm>毒瘤数据结构</span>&nbsp;&nbsp;&nbsp;&nbsp;<span data-luogu data-algorithm>卡常</span>
12. 特殊题目标签：<span data-luogu data-special>氧气优化,O2</span>&nbsp;&nbsp;&nbsp;&nbsp;<span data-luogu data-special>臭氧优化,O3</span>&nbsp;&nbsp;&nbsp;&nbsp;<span data-luogu data-special>四聚氧优化,O4</span>&nbsp;&nbsp;&nbsp;&nbsp;<span data-luogu data-special>红氧优化,O8</span>
13. 题目来源区域：<span data-luogu data-region>蒙德城</span>&nbsp;&nbsp;&nbsp;&nbsp;<span data-luogu data-region>璃月</span>&nbsp;&nbsp;&nbsp;&nbsp;<span data-luogu data-region>稻妻城</span>&nbsp;&nbsp;&nbsp;&nbsp;<span data-luogu data-region>须弥城</span>&nbsp;&nbsp;&nbsp;&nbsp;<span data-luogu data-region>枫丹廷</span>

~~以上均为整活~~

本站使用的`span`标签：

```html
<!-- 题目难度 -->
<span data-luogu data-grey>暂无评定</span>

<span data-luogu data-red>入门</span>

<span data-luogu data-orange>普及-</span>

<span data-luogu data-yellow>普及/提高-</span>

<span data-luogu data-green>普及+/提高</span>

<span data-luogu data-blue>提高+/省选</span>

<span data-luogu data-purple>省选/NOI-</span>

<span data-luogu data-black>NOI/NOI+/CTSC</span>
<!-- 题目来源 -->
<span data-luogu data-source>NOIp 提高组</span>
<!-- 相关比赛年份 -->
<span data-luogu data-date>2023</span>
<!-- 算法标签 -->
<span data-luogu data-algorithm>动态规划,dp</span>
<!-- 特殊题目标签 -->
<span data-luogu data-special>O2优化</span>
<!-- 题目来源区域 -->
<span data-luogu data-region>四川</span>
```

原生CSS标签：

```css
.lfe-caption {
    font-size: 0.875em;
}

span[data-v-71731098] {
    display: inline-block;
    padding: 0 8px;
    box-sizing: border-box;
    font-weight: 400;
    line-height: 1.5;
    border-radius: 2px;
}
```

**AcWing风格**

1. <span class="label label-success round">简单</span>
2. <span class="label label-warning round">中等</span>
3. <span class="label label-danger round">困难</span>

本站使用的`span`标签：

```html
<span class="label label-success round">简单</span>

<span class="label label-warning round">中等</span>

<span class="label label-danger round">困难</span>
```

原生CSS标签：

```css
.round {
    border-radius: 1020px;
}

.label {
    display: inline;
    padding: .2em .6em .3em;
    font-size: 75%;
    font-weight: 700;
    line-height: 1;
    color: #fff;
    text-align: center;
    white-space: nowrap;
    vertical-align: baseline;
    border-radius: .25em;
}

.label-success {
    background-color: #5cb85c;
}

.label-warning {
    background-color: #f0ad4e;
}

.label-danger {
    background-color: #d9534f;
}
```

#### 段落缩进（未启用）

注入以下的CSS代码：

```css
.md{
    text-align: left
    text-indent: 2em
}
```
