---
abbrlink: ''
categories: []
date: '2023-11-12T09:23:35+08:00'
tags:
- latex
title: Latex常用符号大全
updated: '2024-05-12T13:13:53.394+08:00'
---
## 导言区

### 页边距&行距

“窄”：`\geometry{left=1.27cm, right=1.27cm, top=1.27cm, bottom=1.27cm}`

“宽”：`\geometry{left=3.18cm, right=3.18cm, top=2.54cm, bottom=2.54cm}`

很合适的行距：`\linespread{1.5}`

### 标题&作者&时间

`\title{-IamTitle-\vspace{-2em}}` 

注：`\vspace{-2em}` 是用来缩小标题与正文之间的行距

不想显示作者和时间的话可以留空：

```plaintext
\author{}

\date{}
```

其中时间可以用 `\today` 来表示今天，会在编译时自动填充

注意：请一定要在**正文区**使用 `\maketitle`

### 文章样式

用 `\pagestyle{plain}` 就好

### 特殊转义

空格：`~`（波浪号）

宽分隔符：`\qquad`

## 段落层次

### 大标题&小标题

大标题：`\section{TITLE}` 居中、微软雅黑

小标题：`\subsection{TITLE}` 左对齐、微软雅黑

注：若想去除编号，可以在环境名称后面加 `*`，如：`\subsection*{<人物事迹>}`

### 定理环境 etc.

目前还没用到，所以先空着

## 加粗&下划线&斜体(*Italic*)

### 加粗

在文本环境中使用：`\textbf{}` $\textbf{This~is~a~bold~text.}$

在公式环境中使用：`\bm{}`（见 [后文](#usepackagebm) 介绍`\usepackage{bm}`宏包）

### 斜体

在文本环境中使用：`\textil{}` $\textil{This~is~Italic}$

公式环境本来就是斜体……

### 下划线

在文本环境中使用：`\underline{}` $\underline{This~sentence~contains~underline}$

# 常用命令总结

## 自带基础命令

乘号（叉乘）:  `\times` $\times$

乘号（数量积/点乘）： `\cdot`  $\times$

除号： `\div` $\div$

开方/N次方根： `\sqrt[N]{ABC}` $\sqrt[N]{ABC}$

乘方/N次幂： `A^N` $A^N$

下标： `A_N` $A_N$

约等号： `\approx` $\approx$

加粗约等于：`\thickapprox` $\thickapprox$

不等号： `\neq` $\neq$

恒等号/定义为： `\equiv` $\equiv$

大于号： `\gt` $\gt$

小于号： `\lt` $\lt$

大于等于： `\geq` $\geq$

小于等于： `\leq` $\leq$

远大于： `\gg` $\gg$

远小于： `\ll` $\ll$

正负： `\pm` $\pm$

负正： `\mp` $\mp$

垂直： `\perp` $\perp$

平行： `\parallel` $\parallel$

角/无标记角： `\angle` $\angle$

角/标记角： `\measuredangle` $\measuredangle$

一般全等： `\cong` $\cong$

相似： `\sim` $\sim$

加粗相似：  `\thicksim` $\thicksim$

三角形： `\triangle` $\triangle$

正方形： `\square` $\square$

圆： `\odot` $\odot$

向量：`\overrightarrow{AB}` $\overrightarrow{AB}$

属于： `\in` $\in$

不属于： `\notin` $\notin$

子集： `\subseteqq` $\subseteqq$

真子集：   `\subsetneqq` $\subsetneqq$

真子集/直线在平面上： `\subset` $\subset$

并集： `\cup` $\cup$

交集： `\cap` $\cap$

补集： `\complement{_U^A}` $\complement{_U^A}$

因为： `\because` $\because$

所以： `\therefore` $\therefore$

存在： `\exists` $\exists$

不存在： `\nexists` $\nexists$

任意/对于所有： `\forall` $\forall$

空集： `\varnothing` $\varnothing$

逻辑或： `\cup` $\cup$ 或  `\lor` $\lor$

逻辑与： `\cap` $\cap$ 或  `\land` $\land$

逻辑非： `\lnot` $\lnot$

充分条件/右双箭头： `\Rightarrow` $\Rightarrow$ 大小写敏感

必要条件/左双箭头： `\Leftarrow` $\Leftarrow$ 大小写敏感

充要条件/双向双箭头： `\Leftrightarrow`$\Leftrightarrow$ 大小写敏感

成正比： `\propto` $\propto$

定积分： `\int_{a}^{b}` $\int_{a}^{b}$

多重积分： `\iint_{a}^{b}` $\iint_{a}^{b}$ 及  `\iiint_{a}^{b}` $\iiint_{a}^{b}$

导函数/上撇号： `\prime` $\prime$

求和： `\sum_{i=1}^{n}` $\sum_{i=1}^{n}$

求积： `\prod_{i=1}^{n}` $\prod_{i=1}^{n}$

字母数位/平均数： `\overline{ABCD}` $\overline{ABCD}$

整除符号： `\mid` $\mid$

新定义运算符： `\oplus`  $\oplus$ 及  `\otimes`  $\otimes$ 及  `\ominus` $\ominus$

扰动值： `\tilde{K}` $\tilde{K}$

上箭头：`\uparrow` $\uparrow$

下箭头：`\downarrow` $\downarrow$

无穷大/无限： `\infty` $\infty$

圆周率： `\pi` $\pi$

普朗克常数： `\hbar` $\hbar$

phi：`\phi` $\phi$ 或 `\varphi` $\varphi$

## 分数、矩阵、行列式

分数：`\frac{1}{2}=0.5` $\frac{1}{2}=0.5$

小型分数：`\tfrac{1}{2} = 0.5` $\tfrac{1}{2} = 0.5$

大型分数：`\dfrac{k}{k-1} = 0.5` $\dfrac{k}{k-1} = 0.5$

大小型分数嵌套：

`\dfrac{ \tfrac{1}{2}[1-(\tfrac{1}{2})^n] }{ 1-\tfrac{1}{2} } = s_n`

$$
\dfrac{ \tfrac{1}{2}[1-(\tfrac{1}{2})^n] }{ 1-\tfrac{1}{2} } = s_n
$$

连续分数：

`\cfrac{2}{ c + \cfrac{2}{ d + \cfrac{1}{2} } } = a`

`\qquad`

`\dfrac{2}{ c + \dfrac{2}{ d + \dfrac{1}{2} } } = a`

$$
\cfrac{2}{ c + \cfrac{2}{ d + \cfrac{1}{2} } } = a
\qquad
\dfrac{2}{ c + \dfrac{2}{ d + \dfrac{1}{2} } } = a
$$

二项式分数：`\binom{n}{k}` $\binom{n}{k}$

小型二项式系数：`\tbinom{n}{k}` $\tbinom{n}{k}$

大型二项式系数：`\dbinom{n}{k}` $\dbinom{n}{k}$

矩阵（matrix、vmatrix、Vmatrix、bmatrix、Bmatrix、smallmatrix、pmatrix 环境）:

```plaintext
\begin{matrix}
x & y \\
z & v
\end{matrix}
\qquad  
\begin{vmatrix}
x & y \\
z & v
\end{vmatrix}
\qquad
\begin{Vmatrix}
x & y \\
z & v
\end{Vmatrix}
\qquad
\begin{bmatrix}
0 & \cdots & 0 \\
\vdots & \ddots & \vdots \\ 0 & \cdots & 0
\end{bmatrix}
\begin{Bmatrix}
x & y \\
z & v
\end{Bmatrix}
\qquad
\begin{pmatrix}
x & y \\
z & v
\end{pmatrix}
\qquad
\bigl( \begin{smallmatrix}
a&b\\
c&d
\end{smallmatrix} \bigr)
```

$$
\begin{matrix}
x & y \\
z & v
\end{matrix}
\qquad  
\begin{vmatrix}
x & y \\
z & v
\end{vmatrix}
\qquad
\begin{Vmatrix}
x & y \\
z & v
\end{Vmatrix}
\qquad
\begin{bmatrix}
0 & \cdots & 0 \\
\vdots & \ddots & \vdots \\ 0 & \cdots & 0
\end{bmatrix}

$$

$$
\begin{Bmatrix}
x & y \\
z & v
\end{Bmatrix}
\qquad
\begin{pmatrix}
x & y \\
z & v
\end{pmatrix}
\qquad
\bigl( \begin{smallmatrix}
a&b\\
c&d
\end{smallmatrix} \bigr)
$$

数组（Array 环境）:

```plaintext
\begin{array}{|c||c|||c||||}
a & b & S \\
\hline
0&0&1\\
0&1&1\\
1&0&1\\
1&1&0
\end{array}
```

$$
\begin{array}{|c||c|||c||||}
a & b & S \\
\hline
0&0&1\\
0&1&1\\
1&0&1\\
1&1&0
\end{array}
$$

方程组（Cases 环境）:

```plaintext
\begin{cases}
3x + 5y + z &= 1 \\
7x - 2y + 4z &= 2 \\
-6x + 3y + 2z &= 3
\end{cases}
```

$$
\begin{cases}
3x + 5y + z &= 1 \\
7x - 2y + 4z &= 2 \\
-6x + 3y + 2z &= 3
\end{cases}
$$

多行公式（Align 环境）:

```plaintext
\begin{align}
f(x) & = (a+b)^2 \\
& = a^2+2ab+b^2
\end{align}
```

$$
\begin{align}
f(x) & = (a+b)^2 \\
& = a^2+2ab+b^2
\end{align}
$$

从指定编号开始方程组（Alignat 环境）

```plaintext
\begin{alignat}{2}
f(x) & = (a-b)^2 \\
& = a^2-2ab+b^2
\end{alignat}
```

$$
\begin{alignat}{2}
f(x) & = (a-b)^2 \\
& = a^2-2ab+b^2
\end{alignat}
$$

注：若想去掉公式编号，使用 `align*` 环境

多行公式（左对齐）:

```plaintext
\begin{array}{lcl}
z & = & a \\
f(x,y,z) & = & x + y + z
\end{array}
```

$$
\begin{array}{lcl}
z & = & a \\
f(x,y,z) & = & x + y + z
\end{array}
$$

多行公式（右对齐）:

```plaintext
\begin{array}{lcr}
z & = & a \\
f(x,y,z) & = & x + y + z
\end{array}
```

$$
\begin{array}{lcr}
z & = & a \\
f(x,y,z) & = & x + y + z
\end{array}
$$

## extarrows 宏包

等号上有条件：`\xlongequal{xyz}` :  $\xlongequal{xyz}$

## cancel 宏包

大大的叉：`\xcancel{\frac{abc}{def}}`  : $\xcancel{\dfrac{abc}{def}}$

注：此命令只能在数学模式中使用（即用\$\$包裹时）

## xcolor 宏包

变色：`\textcolor{green}{abcdef}` :  $\textcolor{green}{OK}$

半色调：`\textcolor{<颜色>!<百分数>}`

混合色：`\textcolor{<颜色>!<百分数>!<颜色>}`

## bm 宏包

公式中加粗：`\bm{abc}` $\bm{abc}$
