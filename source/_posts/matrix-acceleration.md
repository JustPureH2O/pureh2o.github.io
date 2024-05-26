---
abbrlink: ''
categories:
- - oi算法
date: '2024-03-13T18:42:32.793513+08:00'
headimg: https://cdn.luogu.com.cn/upload/image_hosting/9bngyldq.png
tags:
- oi
- 线性代数
- 算法
title: OI算法——矩阵加速递推
updated: '2024-03-23T23:10:39.858+08:00'
---
![](https://cdn.luogu.com.cn/upload/image_hosting/9bngyldq.png)

在开始之前，确保你至少已经学会了[矩阵乘法](https://justpureh2o.cn/articles/9306/#%E7%AC%AC%E4%BA%8C%E7%AB%A0-%E7%9F%A9%E9%98%B5%E4%B9%98%E6%B3%95)的计算方法。

矩阵加速递推（后边简称矩阵递推）充分利用了初等矩阵的性质，可以将原本耗时间费空间的函数递归、优化但复杂度较高的记忆化搜索进一步加速为复杂度仅 $\mathcal O(m^3\log n)$ 的对数级别算法（$m$ 一般为 ${2}$ 或 ${3}$）。在数据范围很大时可以考虑使用。

### 矩阵乘法是如何起作用的

[初等矩阵——概念及用法](https://justpureh2o.cn/articles/9306/#%E7%AC%AC%E4%BA%8C%E8%8A%82-%E5%88%9D%E7%AD%89%E7%9F%A9%E9%98%B5%E4%B8%8E%E7%9F%A9%E9%98%B5%E9%80%92%E6%8E%A8)，花一点篇幅来复习一下：

初等行变换：

1. 交换矩阵某两行
2. 将某一行的元素全部乘以一个非零数
3. 将某一行的非零倍加到另一行上

非常简单，甚至我们化简多元方程式都会用到上边的变换。事实上，如果把一次方程组的系数和常数项按一定顺序排列起来，将会得到一个系数矩阵，系数矩阵经过一系列化简和反代也可以解出原方程组的解。

考虑一个单位矩阵 $I=\begin{bmatrix}1&0&0\\0&1&0\\0&0&1\end{bmatrix}$，它很特殊，和实数运算的 $1$ 类似：任何矩阵左乘和右乘单位矩阵所得的乘积矩阵都是这个矩阵本身。顺便说一句，矩阵乘法一般不符合乘法交换律，但单位矩阵乘法除外，也就是说当矩阵长和宽符合要求时，就有 $AI=IA=A$ 成立。

那么一个初等矩阵就是单位矩阵**只进行一次初等行变换**得到的矩阵。进行变换法则的第几条就是第几类初等矩阵。一般来说，矩阵递推里的转移矩阵不属于初等矩阵，因为它通常会经过不止一次的初等行变换。递推时，如果初始矩阵是一列数，那么一般选择左乘转移矩阵；如果是一行数字，就选择右乘。（具体情况具体分析）

---

接下来进入正题：

假如有下边这个递推关系

$$
f(x)=\begin{cases}
1&x=1
\\2&x=2
\\f(x-1)+f(x-2)&x>2
\end{cases}
$$

初始情况下，我们向矩阵中放入两个元素：$A=\begin{bmatrix}1&2\end{bmatrix}$。我们希望构造出一个转移矩阵使得转移后的结果就是前两个元素相加的和（根据递推方程），做一次乘法，矩阵变为 $\begin{bmatrix}2&3\end{bmatrix}$；再来一次，变成 $\begin{bmatrix}3&5\end{bmatrix}$。不难发现，当做了 $n$ 次乘法后，矩阵变为 $\begin{bmatrix}f(n+1)&f(n+2)\end{bmatrix}$。所以假设我们的转移矩阵是 $M$，$f(n)=s_{11}$，其中矩阵 $S=AM^{n-1}$。就基本搞清楚了矩阵递推的原理了。

### 矩阵结构体

函数`I()`的功能是构造单位矩阵，后面会涉及到定义它的原因。整体思路就是定义二维数组存放矩阵元素，声明时对内部元素自动置零，以及构造单位矩阵

```cpp
struct Matrix {
	ll mat[N + 1][N + 1];

	Matrix() {
	    memset(mat, 0, sizeof mat);
	}

	void I() {
            memset(mat, 0, sizeof mat);
	    for (int i = 1; i <= N; i++) mat[i][i] = 1;
	}
};
```

### 矩阵快速幂

和实数运算一样，矩阵自乘也可以用二进制快速幂的方式快速求解，复杂度是 $\mathcal O(\log n)$ 的。

下边是实数快速幂的代码（带取模）：

```cpp
int qpow(int a, int b) {
	int res = 1;
	while (b) {
		if (b & 1) res = (ll) res * a % MOD;
		a = a * a % MOD;
		b >>= 1;
	}
	return res;
}
```

原理不再赘述。如果想要把它改造成适用于矩阵的快速幂算法，我们就需要实现这两个运算：

1. 矩阵乘法
2. 矩阵置一

对于第一点，我们根据矩阵乘法的定义可以很轻松写出代码。一般来说，重载运算符是一个很方便的办法（注意如果重载在结构体内就需要在函数定义时加上`friend`友元访问权）：

```cpp
Matrix operator *(const Matrix &l, const Matrix &r) {
	Matrix res;
	for (int i = 1; i <= N; i++) {
		for (int j = 1; j <= N; j++) {
			for (int k = 1; k <= N; k++) {
				res.mat[i][j] += (l.mat[i][k] * r.mat[k][j]);
				res.mat[i][j] %= MOD;
			}
		}
	}
}
```

那么“置一”是什么呢？

相当于实数快速幂里的`int res = 1;`，试想一个全新定义的零矩阵（元素全为零）拿去计算乘法，最终的结果总会是零。因此我们就需要找到和 $1$ 作用相同的矩阵，赋上初值，计算出来的结果才是正确的。于是很自然想到了单位矩阵，结构体中的`I()`函数用于将矩阵变为一个主对角线元素全为 $1$、其他元素均为 $0$ 的矩阵。

类比实数快速幂，矩阵快速幂是这样的：

```cpp
Matrix qpow(Matrix a, int b) {
	Matrix res;
	res.I();
	while (b) {
	    if (b & 1) res = res * a;
	    a = a * a;
	    b >>= 1; 
	}
	return res;
}
```

此时就不能图省事用`*=`运算符了（除非你另外重载，但这样会更麻烦）

### 转移矩阵的构造

转移矩阵可谓是矩阵递推题目的灵魂所在，合理地构造转移矩阵可以达到事半功倍的效果。接下来通过几个例子来深入探究转移矩阵的构造方法：

#### 洛谷 P1962 斐波那契数列

题目传送门：[这里](https://www.luogu.com.cn/problem/P1962)

题目难度：<span data-v-71731098="" class="lfe-caption" style="color:#FFFFFF; background:#52C41A;">普及+/提高</span>

> 大家都知道，斐波那契数列是满足如下性质的一个数列：
>
> $$
> F_n = \left\{\begin{aligned} 1 \space (n \le 2) \\ F_{n-1}+F_{n-2} \space (n\ge 3) \end{aligned}\right.
> $$
>
> 请你求出 $F_n \bmod 10^9 + 7$ 的值。
>
> ---
>
> 输入一行一个正整数 $n$
>
> 输出一行一个整数表示答案。
>
> ---
>
> **数据范围：**
>
> 对于 $60\%$ 的数据，$1\le n \le 92$；
>
> 对于 $100\%$ 的数据，$1\le n < 2^{63}$。

正如这头图所示，我们的初始矩阵是 $A=\begin{bmatrix}1&1\end{bmatrix}$，转移矩阵是 $M=\begin{bmatrix}0&1\\1&1\end{bmatrix}$。$\operatorname{fib}_n$ 就是 $AM^{n-1}$ 的第一个元素。~~嘎嘎好用是不是~~

首先，要求出某一项，就必须明确它的前两项。因此我们让初始矩阵填上 $\operatorname{fib}_1=1$ 和 $\operatorname{fib}_2=1$。对于转移，我们有一个非常好的小技巧：整体左移——这就好比一个滑动窗口（但不是单调队列那个），斐波那契数列按顺序排列在一起：$\operatorname{fib}_1,\operatorname{fib}_2,\operatorname{fib}_3,\operatorname{fib}_4,\dots\operatorname{fib}_{n-1},\operatorname{fib}_n$。最开始这个矩阵框住了 $\operatorname{fib}_1$ 和 $\operatorname{fib}_2$，操作一次，它框住 $\operatorname{fib}_2$ 和 $\operatorname{fib}_3$，以此类推……每次挪一下，因此做了 $n-1$ 次乘法后就挪到了 $\operatorname{fib}_n$ 的位置。那我们怎么构造这种转移矩阵呢？

所谓左移，就是让 $a_{12}$ 换到 $a_{11}$ 的位置来，根据矩阵乘法系数配对的原理。对于转移矩阵第一列，就是下面这样：

$$
M=\begin{bmatrix}
0&
\\1&
\end{bmatrix}
$$

第二列也很简单，对原先的转移矩阵的两个元素都配上系数 $1$ 即可：

$$
M=\begin{bmatrix}0&1\\1&1\end{bmatrix}
$$

于是代码就出来了（~~不开`long long`见祖宗~~）：

```cpp
#include <bits/stdc++.h>

#define N 15
using namespace std;

typedef long long ll;

const int MOD = 1e9 + 7;

struct Matrix {
    ll mat[N][N];

    Matrix() {
        memset(mat, 0, sizeof mat);
    }

    void I() {
        memset(mat, 0, sizeof mat);
        for (int i = 1; i <= 2; i++) mat[i][i] = 1;
    }
};

Matrix operator *(const Matrix &l, const Matrix &r) {
    Matrix res;
    for (int i = 1; i <= 2; i++) {
        for (int j = 1; j <= 2; j++) {
            for (int k = 1; k <= 2; k++) {
                res.mat[i][j] += (l.mat[i][k] * r.mat[k][j]);
                res.mat[i][j] %= MOD;
            }
        }
    }
    return res;
}

Matrix qpow(Matrix a, ll b) {
    Matrix res;
    res.I();
    while (b) {
        if (b & 1) res = res * a;
        a = a * a;
        b >>= 1;
    }
    return res;
}

int main() {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.tie(nullptr);

    ll n;
    cin >> n;

    Matrix A, M;
    A.mat[1][1] = A.mat[1][2] = 1;
    M.mat[1][2] = M.mat[2][1] = M.mat[2][2] = 1;

    A = A * qpow(M, n - 1);

    cout << A.mat[1][1] % MOD << endl;

    return 0;
}
```

总用时：$42ms$ [记录](https://www.luogu.com.cn/record/143858453)

这种类型的题还有[洛谷 P1349 广义斐波那契数列](https://www.luogu.com.cn/problem/P1349)，同样是左移技巧，只不过转移矩阵要稍作变动。

#### 洛谷 P1397 矩阵游戏

题目传送门：[这里](https://www.luogu.com.cn/problem/P1397)

题目难度：<span data-v-71731098="" class="lfe-caption" style="color:#FFFFFF; background:#3498DB;">提高+/省选</span>

题目来源：<span data-v-71731098="" class="lfe-caption" style="color:#FFFFFF; background:#13C2C2;">NOI</span>&nbsp;&nbsp;&nbsp;&nbsp;<span data-v-71731098="" class="lfe-caption" style="color:#FFFFFF; background:#3498DB;">2013</span>

~~NOI 2012 和 2013连着两年都考了矩阵递推，真的强！~~

> 婷婷是个喜欢矩阵的小朋友，有一天她想用电脑生成一个巨大的 $n$ 行 $m$ 列的矩阵（你不用担心她如何存储）。她生成的这个矩阵满足一个神奇的性质：若用 $F[i,j]$ 来表示矩阵中第 $i$ 行第 $j$ 列的元素，则 $F[i,j]$ 满足下面的递推式:
>
> $$
> \begin{aligned}
> F[1, 1] &= 1 \\
> F[i, j] &=a\times F[i, j-1]+b, &j\neq 1 \\
> F[i, 1] &=c\times F[i-1, m]+d, &i\neq 1 \\
> \end{aligned}
> $$
>
> 递推式中 $a,b,c,d$ 都是给定的常数。
>
> 现在婷婷想知道 $F[n,m]$ 的值是多少，请你帮助她。由于最终结果可能很大，你只需要输出 $F[n,m]$ 除以 ${10^9+7}$ 的余数。
>
> ---
>
> 输入包含一行，有六个整数 $n,m,a,b,c,d$。意义如题所述。
>
> 输出包含一个整数，表示 $F[n,m]$ 除以 $10^9+7$ 的余数。
>
> ---
>
> **数据范围：**
>
> ${1\leq n,m\leq10^{1~000~000};~1\leq a,b,c,d\leq10^9}$

这道题需要我们推一个式子，因为递推公式出现了两种情况，我们就需要两个不同的转移矩阵。假设一个为 $M_{ab}$，一个为 $M_{cd}$，分别对应递推式里的系数，以及一个初始矩阵 $A$。

这里出现了常数项，通常选择在初始矩阵中放入一个常量 $1$，每次递推将它乘以这个常数、并且需要保证它不被转移矩阵改变，这样一来才能保证递推稳定运行。

那么在初始矩阵的第二列放上常量 $1$，以 $M_{ab}$ 为例，要满足递推关系，未知数和 $1$ 的系数分别是 $a$ 和 $b$，于是转移矩阵第一列就是 $\begin{bmatrix}a\\b\end{bmatrix}$，第二列就是 $\begin{bmatrix}0\\1\end{bmatrix}$。

同理有：$A=\begin{bmatrix}1&1\end{bmatrix}$、$M_{ab}=\begin{bmatrix}a&0\\b&1\end{bmatrix}$、$M_{cd}=\begin{bmatrix}c&0\\d&1\end{bmatrix}$。

接下来根据题目描述，要想一路推到右下角的 $(n,m)$，首先就得把 $(n-1,m)$ 弄出来，而这一行又从 $(n-1,1)$ 递推得来，以此类推……那么每一行最右边的元素和该行第一个元素的关系就是 $AM_{ab}^{m-1}$，又因为矩阵共 $n$ 行，每一行的开头还得乘上一个 $M_{cd}$，因此公式就是：$A(M_{ab}^{m-1}M_{cd})^{n-1}M_{ab}^{m-1}$。再看看数据范围，~~十的一百万次方？？？太抽象了~~，对于这么大的幂，普通的位运算快速幂已经满足不了时限了，于是我们引入一种高级方法——十进制快速幂：

快速幂基于数字的拆位，所以我们可以选择在十进制表示下拆位运算。因此就算是十的一百万次方，应用十进制快速幂就会让复杂度降落不少，因此我们试验这个方法：

十进制矩阵快速幂：

```cpp
Matrix dec_qpow(Matrix a, string b) {
	Matrix res;
	res.I();
	int len = b.length();
	while (len) {
		int p = b[len - 1] - '0';
		if (p) {
			for (int i = 1; i <= p; i++) {
				res = res * a;
			}
		}
		for (int i = 1; i <= 10; i++) a = a * a;
		len--;
	}
	return res;
}
```

当然可以用二进制快速幂取代中间的循环乘幂，代码会简洁一些：

```cpp
Matrix dec_qpow(Matrix a, string b) {
	Matrix res;
	res.I();
	int len = b.length();
	while (len) {
		int p = b[len - 1] - '0';
		res = res * bin_qpow(a, p);
		a = bin_qpow(a, 10);
		len--;
	}
	return res;
}
```

然后我们再来算上面推出的式子，考虑到变量 $n$ 和 $m$ 必须要用字符串读入，可以用高精度的思想对二者进行预处理，将它们的值分别减少 ${1}$ ，然后将处理后的字符串作为参数传入快速幂函数中计算即可。下边是代码：

```cpp
#include <bits/stdc++.h>
#define N 5
using namespace std;

const int MOD = 1e9 + 7;

typedef long long ll;

struct Matrix {
	ll a[N][N];

	Matrix() {
		memset(a, 0, sizeof a);
	}

	void I() {
		a[1][1] = a[2][2] = 1;
	}
} A, M, S;

Matrix operator *(const Matrix &l, const Matrix &r) {
	Matrix res;
	for (int i = 1; i <= 2; i++) {
		for (int j = 1; j <= 2; j++) {
			for (int k = 1; k <= 2; k++) {
				res.a[i][j] = (res.a[i][j] + l.a[i][k] % MOD * r.a[k][j] % MOD) % MOD;
			}
		}
	}
	return res;
}

Matrix bin_qpow(Matrix a, ll b) {
	Matrix res;
	res.I();
	while (b) {
		if (b & 1) res = res * a;
		a = a * a;
		b >>= 1;
	}
	return res;
}

Matrix dec_qpow(Matrix a, string b) {
	Matrix res;
	res.I();
	int len = b.length();
	while (len) {
		int p = b[len - 1] - '0';
		for (int i = 1; i <= p; i++) {
			res = res * a;
		}
		a = bin_qpow(a, 10);
		len--;
	}
	return res;
}

string init(string s) {
	for (int i = s.length() - 1; i >= 0; i--) {
		if (s[i] == '0') s[i] = '9';
		else {
			s[i]--;
			break;
		}
	}
	return s;
}

int main() {
	ios::sync_with_stdio(false);
	cin.tie(nullptr);
	cout.tie(nullptr);

	string n, m;
	ll a, b, c, d;

	cin >> n >> m >> a >> b >> c >> d;

	A.a[1][1] = 1, A.a[1][2] = 1;
	M.a[2][2] = 1, M.a[1][1] = a, M.a[2][1] = b;
	S.a[2][2] = 1, S.a[1][1] = c, S.a[2][1] = d;

	n = init(n), m = init(m);

	Matrix T = A * dec_qpow((dec_qpow(M, m) * S), n) * dec_qpow(M, m);

	cout << T.a[1][1] % MOD << endl;
	return 0;
}
```

这段代码只能得[80分](https://www.luogu.com.cn/record/150651826)，最后四个点TLE了。此时有两种解决办法，第一是卡常——将矩阵乘法的三层循环完全展开、内联函数、加法取模，可以将代码运行时间压到 ${1.37}s$ （最慢的点 ${341}ms$）[记录](https://www.luogu.com.cn/record/150660458)。

### 矩阵递推的变式

#### 广义矩阵乘法

相信你已经背下了矩阵乘法的模板了，为了避免遗忘，再在这里给出矩阵乘法的一般定义：假设一个 $n\times p$ 的矩阵 $A$ 和一个 $p\times m$ 矩阵 $B$ 相乘，就有：

$$
(AB)_{ij}=\sum\limits_{k=1}^{p}a_{ik}b_{kj}
$$

最终结果 $C=AB$，满足 $C$ 为一个 $n\times m$ 矩阵。

---

那么是不是非得要求和和相加呢？当然不是，对于一般的矩阵乘法，才会像上边一样对乘积求和。广义矩阵乘法不仅限于上边的“对积求和”的规则，它还可以做到“对位与求位或和”。接下来探讨广义矩阵乘法所要满足的条件：

定义运算符 $\bigoplus$ 为“异加”（变种加法）、$\bigotimes$ 为“异乘”（变种乘法）。假如还是上面的 $A,B$ 矩阵，那么广义矩阵乘法将是这种形式：

$$
(AB)_{ij}=\bigoplus\limits_{k=1}^{p}a_{ik}\otimes b_{kj}
$$

要想让这种运算关系能够支持递推算法，那就必须使算式 $A\times M\times M\times\dots\times M=AM^n$ 成立才行。而这个转化很明显是将连乘的 $M$ 结合为矩阵的幂，因此只要上边的新定义算式满足乘法结合律，就可以被归入广义矩阵乘法的范畴内。假设此时有 $A,B,C$ 三个能够相乘的矩阵，那么：

$$
\begin{aligned}
[(AB)C]_{ij}&=\bigoplus\limits_{k_1=1}^{n}(AB)_{ik_1}\otimes C_{k_1j}
\\&=\bigoplus\limits_{k_1=1}^{n}\left(\bigoplus\limits_{k_2=1}^{n}a_{ik_2}\otimes b_{k_2k_1}\right)\otimes c_{k_1j}
\\ [A(BC)]_{ij}&=\bigoplus_{k_1=1}^{n}A_{ik_1}\otimes(BC)_{k_1j}
\\&=\bigoplus\limits_{k_1=1}^{n}a_{ik_1}\otimes\left(\bigoplus\limits_{k_2=1}^{n}b_{k_1k_2}\otimes c_{k_2j}\right)
\end{aligned}
$$

换句话说：

$$
\bigoplus\limits_{k_1=1}^{n}\left(\bigoplus\limits_{k_2=1}^{n}a_{ik_2}\otimes b_{k_2k_1}\right)\otimes c_{k_1j}=\bigoplus\limits_{k_1=1}^{n}a_{ik_1}\otimes\left(\bigoplus\limits_{k_2=1}^{n}b_{k_1k_2}\otimes c_{k_2j}\right)
$$

类比一般加法和乘法。当 $\bigotimes$ 运算符合交换律、结合律；并且 $\left(\bigoplus a\right)\otimes b=\bigoplus\left(a\otimes b\right)$ 成立，则原式化简为：

$$
\left[A(BC)\right]_{ij}=\left[(AB)C\right]_{ij}=\bigoplus\limits_{k_1=1}^{n}\bigoplus\limits_{k_2=1}^{n}\left(a_{ik_2}\otimes b_{k_2k_1}\otimes c_{k_1j}\right)
$$
