---
abbrlink: ''
categories:
- - oi算法
date: '2023-11-26T09:37:52+08:00'
mathjax: true
tags:
- 学术
- 数论
- OI
- 算法
title: 信竞初等数论导论
updated: '2024-02-18T10:23:16.969+08:00'
---
![](https://pic.imgdb.cn/item/658f77c9c458853aefbd431e.jpg)

### 引入

如果说数论是数学体系中专门用来研究数字性质的一个分支，那么初等数论则是对整数的性质进行系统性的探讨与研究。千万不要因为其中的“初等”二字小瞧这初等数论~~尽管名称和学习难度上都没有高等数论那么有逼格，就像初等数学之于高数~~，数论的所有内容均筑基于此。其中欧几里得证明的算数基本定理（一切合数都可被分解为有限个质数的乘积）在质数筛、GCD（以及LCA)计算、无理数证明等问题上均有用武之地。可以说高等数论奠基于初等数论。它同时也是初学者接触数论的必经之路。

### Part1.&nbsp;&nbsp;前置知识

#### Div1. 数论有关定理

**算术基本定理**：每一个合数都可以被分解为有限个质数的乘积。即对于任意合数$n$，都存在：

$n=p_{1}^{c_1}p_{2}^{c_2}p_{3}^{c_3}...p_{k}^{c_k}$，其中$p$为质数。

**推论一**：正整数$n$的正因数集合为：

$\{n=p_{1}^{b_1}p_{2}^{b_2}p_{3}^{b_3}...p_{i}^{b_i} \mid 1 \leq b_i \leq c_i, 1 \leq i \leq k\}$

**推论二**：正整数$n$的正因数个数为：$\tau (n)= (c_1+1) \cdot(c_2+1) \cdot (c_3+1)  ...  (c_k+1) =\prod_{i=1}^{k}\left( c_i+1\right) \\$

**推论三**：正整数$n$的所有正因数之和为

$\sigma(n)=(p_1+p_1^2+...+p_1^{c_1}+1)\times (p_2+p_2^2+...+p_2^{c_2}+1)\times...\times (p_k+p_k^2+...+p_k^{c_k}+1)=\prod_{i=1}^{k}\frac{p_k^{c_k+1}}{p_k-1}$

**质数分布定理**：区间$[1,N]$中，当$N\to \infty$时，质数个数$\pi (x)\approx \frac{n}{\ln n}$。

**费马小定理：** 若$p$是一个质数，则$a^p\equiv a\bmod p$（$\equiv$为同余符号）。

**欧拉定理（费马小定理扩展）：** 若$a\perp n$（$a$与$n$互质），则有$a^{\varphi{(n)}} \equiv 1 \bmod n$，其中$\varphi(n)$为欧拉函数。

#### Div2. 同余

**同余**，顾名思义，两个数分别除以一个正整数$m$后得到相同的余数。即$a\bmod m=b\bmod m$。但是它的定义给出了这样一句话：**“对于正整数$a$和$b$，若$(a-b)\mid m$（$a-b$能被$m$整除），则称$a$和$b$对模$m$同余，记作$a\equiv b\pmod m$”**。当然以上两种说法是等价的。

同余具有以下三种基本性质：

1. 反身性：对于任何正整数$a$，$a\equiv a\pmod m$
2. 对称性：即对于$a\equiv b\;(\bmod m)$，有$b\equiv a\pmod m$
3. 传递性：若$a\equiv b\pmod m$，且$b\equiv c\pmod m$，有$a\equiv c\pmod m$

当然，它可以延申到计算机的模运算（毕竟出现了$\bmod$）。模运算有三种基本运算：

1. 加运算：$(a+b)\% m=(a\% m+b\% m)\% m$
2. 减运算：$(a-b)\%m=(a\%m-b\%m)\%m$
3. 乘运算：$(a\cdot b)\%m=((a\%m)*(b\%m))\%m$

还有两个推论：

1. 幂运算：$a^b\%p=((a\%p)^b)\%p$
2. 求和运算：$(\sum\limits_{x=1}^{n}x)\%p=(\sum\limits_{x=1}^{n}x\%p)\%p$

同余消去原则：

> 若同余号两端的项相等，且都与模$n$互质，则可以同时消去

举例：$a\cdot c\equiv b\cdot c \bmod n$，如果$gcd(c,n)=1$，则$a\cdot c\equiv b\cdot c\Rightarrow a\equiv b \bmod n$。

### Part2.&nbsp;&nbsp;质数

质数的判断：除了它自身$P$以及$1$以外，不存在其他正整数$N$使得$N\mid P$。

#### Div1.&nbsp;&nbsp;质数判断

**试除法：** 这是三种方法中，**唯一一种能做到100%正确的质数判断方法**。对于给定数$n$，遍历所有$[2,\sqrt n]$间的正整数$m$，若出现$m\mid n$则证明它不是质数，因为质数**只能被1以及它本身整除**。

```cpp
bool isPrime(int n) {
	for (int i = 2; i * i <= n; i++) {
		if (n % i == 0) return false;
	}
	return true;
}
```

复杂度：$\mathcal O(\sqrt n)$

适用范围：普及、提高

~~试除法の大胜利！~~

**费马素性检验：** 是上述费马小定理的实际运用，它与常规算法思想有所不同：它主张在$[2,n-1]$中随机选取一个数$a$。若出现与费马小定理不符的情况，那么$n$一定为合数；若每次均符合定理，称为 _费马伪素数_ ，因为它**很大概率**是一个质数。

```cpp
bool isPrime(int n) {
	if (n <= 2) return false;
	int k = 10;
	while (k--) {
		srand(time(0));
		int a = rand() % (n - 2) + 2;
		if (__gcd(a, n) != 1) return false;
		if (qpow(a, n - 1, n) != 1) return false; 
	} 
	return true;
}
```

复杂度：$\mathcal O(k\log n)$，其中$k$为随机数检验次数，$\log n$是因为使用了快速幂算法。

适用范围：提高T2及以下（慎用）

为什么用该方法判断的质数 _大概率_ 是个质数呢？不妨测试一下`561`（3）、`1105`（5）、`1729`（7）（括号内为它的最小因子），你会发现函数的返回值均为`true`，即都为质数。可见这个算法不是100%正确的，这些“漏网之鱼”被称为“Carmichael数”。它们极其罕见，一亿范围内仅255个。也因如此，你可以通过打表特判的方式抠掉这些特例（你保证记得住就行）。2016年中国物流工人余建春给出了一个Carmichael数的判断准则，这个标准目前在国际上得到了广泛认同。

对于优化，你可以在函数起始点加入类似于`if (n % 2 == 0 || n % 3 == 0) return false;`的特判，进一步降低复杂度。

**Miller-Rabin算法：** **该算法同样无法保证结果100%准确，慎用！**

MB算法实质上是对费马素性检验算法的效率和准确度优化。算法流程如下：

1. 将$n-1$分解为$2^s+d$的形式，其中$d$为奇数
2. 从$[2,n-2]$中选取整数$a$，称为“基数”
3. 计算$a^d \bmod n$的值，若结果为$1$或$n-1$，则可能为质数，继续检验
4. 若结果不等于$1$或$n-1$，计算$a^{2d} \bmod n$、$a^{4d} \bmod n$、$a^{6d} \bmod n$……$a^{2^{s-1}d} \bmod n$的值，若结果等于$n-1$，则可能为质数，继续检验
5. 若都不等于$1$，则$n$一定是合数。称为**强费马证据**。

当然，它同样有特例，称为**强伪质数**，如`2047`（23）、`3277`（29）、`4033`（39）等（括号内为它的最小因子）。

#### Div2.&nbsp;&nbsp;质数筛

常见的质数筛法有：试除法、埃氏筛、线性筛。

**试除法**：从质数定义出发，即存在一个正整数$N$，对于任意$[2,\sqrt N]$间的正整数$M$，总有$N\bmod M \neq 0$成立。代码实现只需枚举$[2, \sqrt N]$间所有正整数，并让$N$对其取余。若取模运算出现$0$则代表它不为质数，没有出现$0$则为质数。

```cpp
bool isPrime(int n) {
	for (int i = 2; i * i <= n; i++) {
		if (n % i == 0) return false;
	}
	return true;
}
```

复杂度：$\mathcal O( \sqrt N )$

适用范围：普及T2及以下

这里所展示的试除法代码实际上经过一轮优化。若严格根据质数定义，第二行的循环上限应为$n-1$。考虑到如下性质：$\forall m\in [2,\sqrt N]$，若$m\mid N$，则一定有$\frac{N}{m}\mid N$。因此可以将循环上限压缩至$\sqrt N$。

**埃氏筛**：全称叫*埃拉托斯特尼筛法*，老哥生活在2200年前的古希腊，不借助望远镜就计算出了地球的周长（与真实值偏差仅0.96%）、同时他也是第一位根据经纬线绘制出世界地图的人、也是最先提出将地球根据南北回归线分为“五带”的大人物。他提出的筛法核心思想如下：

第一步：列出从2开始的一列连续数字；第二步：选出第一个质数（本例中为2），将该质数标记，将数列中它的的所有倍数划去；第三步：**若数列中的末项小于它前一项的平方，则质数已全部筛出；否则返回第二步**。

```cpp
void get(int n) {
	for (int i = 2; i <= n; i++) {
		if (!vis[i]) {
			prime[cnt++] = i;
		}
		for (int j = 2; i * j <= n; j ++) vis[i * j] = true;
	}
}
```

其中，`prime`数组存储质数，`vis`数组用于标记（即上文中“划去数字”），变量`cnt`则存储$[2,N]$中质数的个数。

复杂度：$\mathcal O(n\ln{n})$

适用范围：普及T2及以下

但是继续观察算法发现：**我们其实无需将所有$i$的倍数删去，只需删去前一步得出的质数的所有倍数即可。** 这与前文介绍的埃氏法核心相符。因此将$j$循环迁移至条件判断中即可：

```cpp
void get(int n) {
	for (int i = 2; i <= n; i++) {
		if (!vis[i]) {
			prime[cnt++] = i;
			for (int j = i + i; j <= n; j += i) vis[j] = true;
		}
	}
}
```

优化复杂度：$\mathcal O(n\log{\log n})$

适用范围：普及T3及以下

**线性筛/欧拉筛**：实质是埃氏筛的线性优化。因为在埃氏筛中，有些数字被重复筛了多次（例如30会被2、3、5筛到）。本着线性优化的原则，我们需要找到一个方法，使得每个合数仅被筛选一次。主要思想如下：

我们发现，线性筛和埃氏筛均使用了**质数的$n$倍为合数**的结论。我们只需要保证每一个数仅被它自身的最小质因数筛出即可。即对于数字$m$，$m\cdot p_i$是一个合数，且$m\cdot p_i$只会被$p_i$筛出。

```cpp
void get(int n) {
	for (int i = 2; i <= n; i++) {
		if (!vis[i]) prime[cnt++] = j;
		for (int j = 1; prime[j] <= n / i; j++) {
			vis[prime[j] * i] = true;
			if (i % prime[j] == 0) break;
		}
	}
}
```

复杂度：$\mathcal O(n)$

适用范围：普及、提高

---

**例题：**

1. [P5736 【深基7.例2】质数筛](https://www.luogu.com.cn/problem/P5736)
2. [P5723 【深基4.例13】质数口袋](https://www.luogu.com.cn/problem/P5723)

### Part3.&nbsp;&nbsp;因数

**因数定义：** 对于一个数$n$，若存在一个正整数$m$使得$m\mid n$，则称$m$是$n$的因数。

#### Div1.&nbsp;&nbsp;因数分解法

**试除法：**~~万能暴力解法~~。即遍历$[2,\sqrt n]$间的所有数$m$，若可以整除$n$，则$m$和$\frac{n}{m}$均为$n$的因数。特殊情况：$\sqrt n$为整数时，因数仅有$\sqrt n$本身，因此需特判。

```cpp
vector<int> get(int n) {
	vector<int> ret;
	for (int i = 2; i * i <= n; i++) {
		if (n % i == 0) {
			ret.push_back(i);
			ret.push_back(n / i);
		}
		if (n % (i * i) == 0) ret.pop_back();
	}
	sort(ret.begin(), ret.end());
	return ret;
}
```

复杂度：$\mathcal O(\sqrt n)$

适用范围：普及T1

#### Div2.最大公约数

**辗转相除法：** 又是我们大名鼎鼎的欧几里得老先生提出的一套公约数算法，整个算极其简洁：核心只有一行，即：

> 两个数的最大公约数等于其中较小的数字和二者之间余数的最大公约数

可以写出：

```cpp
int gcd(int a, int b) {
	return b ? gcd(a, a % b) : a; 
} 
```

但是为什么$gcd(a,b)=gcd(a,a\bmod b)$呢？我们可以通过以下方法证明：

假设如下关系：$A=B\cdot C + D$。其中被除数$A$，除数$B$，商$C$，余数$D$。则$A\bmod B=A\bmod C=D$。

首先证明充分性：令$A=a\cdot k$、$B=b\cdot k$，即二者有相同因子$k$。

代入初始除法算式得：$D=A-B\cdot C\rightarrow a\cdot k-b\cdot k\cdot C\rightarrow k(a-b\cdot C)$

接着由于加减乘法的封闭性，即一个整数进行加减乘运算得到的结果同样是一个整数。可以得出：$D=k\cdot N\mid N\in \mathbb{N_+}$。即$D$（$A\bmod B$）与$A$有共同因子。

接下来证必要性。令$B=b\cdot q$、$D=d\cdot q$

**Stein算法：** 上一个方法的明显缺点在于，它处理大质数的效率并不好（但总体来说是很好的），因为它使用了取余运算，这会减慢一些速度。可以理解，生在2000多年前——一个没有电脑和OI的古希腊社会，这个算法已经足够兼顾常规效率和手推难度了。但是步入21世纪，加快的生活节奏~~毒瘤数据~~使得人们对更快算法的需求空前高涨。Stein算法便应运而生。

算法流程如下：

1. 任意给定两个正整数，先判断它们是否都是偶数，若是，则用2约简，若不是，则执行第二步。
2. 若两数是一奇一偶，则偶数除以2，直至两数都成为奇数。再以较大的数减较小的数，接着取所得的差与较小的数，若两数一奇一偶，仍然偶数除以2，直至两数都成为奇数。再次以大数减小数。不断重复这个操作，直到所得的减数和差相等为止。
3. 两数相等时，第一步中约掉的若干个2与第二步中最终的等数的乘积就是所求的最大公约数。

```cpp
int gcd(int a, int b) {
	int p = 0, t;
	if (!(1 & a) && !(1 & b)) {
		a >>= 1;
		b >>= 1;
		p++;
	}
	while (!(1 & a)) a >>= 1;
	while (!(1 & b)) b >>= 1;
	if (a < b) {
		t = a;
		a = b;
		b = t;
	}
	while (a = ((a - b) >> 1)) {
		while (!(1 & a)) a >>= 1;
		if (a < b) {
			t = a;
			a = b;
			b = t;
		}
	}
	return b << p;
} 
```

这个算法的优点在于：它大大优化了大质数的运算。但可惜的是，它的代码量膨胀了8倍，因此不太建议赛时使用。~~毕竟C++都给你内置了`__gcd()`函数嘛，干嘛不偷个懒？~~

#### Div3. 最小公倍数

我们可以简单概括成一句话：

> 两个数的最小公倍数等于这两个数的乘积与这两个数最大公约数的商

即：$lca(a,b)=\frac{a\cdot b}{gcd(a,b)}$

~~凭啥呀？~~

我们假设两个数$A$和$B$有最大公约数$x$，则$A=a\cdot x$，且$B=b\cdot x$。并且$a$和$b$一定互质（若不互质，$A$和$B$的最大公约数就不会是$x$，而是一个比$x$大的值）。

由乘法交换律，可知：$A\cdot B = B\cdot A\rightarrow A\cdot b \cdot x=B\cdot a\cdot x$

消去$x$得：$A\cdot b=B\cdot a$。因为$a$、$b$互质，所以$A\cdot b$或者$B\cdot a$即为两个数的最小公倍数。得证。

---

**例题：**

1. [P1075 [NOIP2012 普及组] 质因数分解](https://www.luogu.com.cn/problem/P1075)
2. [P2424 约数和](https://www.luogu.com.cn/problem/P2424) （需要逆向思维）

### Part4. 欧拉函数相关

#### Div1. 欧拉函数推导

~~问：论牧师欧拉有多么的高产~~

~~答：平均每年800页数学论文你说高不高产嘛~~

**欧拉函数**，记作$\varphi(n)$。表示$[1,n)$中与$n$互质的数的个数，即$\forall m\in [1,n)$，满足$gcd(n,m)=1$的$m$的总个数即为$\varphi(n)$的值。举个例子，$\varphi(3)=2$，因为在$[1,3)$中，$1$和$2$均与$3$互质。特殊地，$\varphi(1)=1$。

欧拉函数有如下计算公式：若$n$可被表示为$n=\prod\limits_{i=1}^{k}p_i^{\alpha_i}$（算术基本定理分解式）的形式，则$\varphi(n)=n*(1-\frac{1}{p_1})(1-\frac{1}{p_2})\dots(1-\frac{1}{p_k})=n*\prod\limits_{i=1}^{k}(1-\frac{1}{p_i})$。

**推导思想即为用$n$减去所有$[1,n)$中所有与$n$不互质的数**。在计算机上实现，首先需要分解质因数。思路如下：首先抛出第一个质因数$p_1$，那么将$[1,n]$中所有的$p_1$的倍数删去，因而可以保证筛出的数一定是$n$的质因子，**否则他们将存在最大公约数$p_1$**。那么能被$p_1$整除的数的个数（也就是$n$以内$p_1$的倍数个数）为$[\frac{n}{p_1}]$——其中的中括号代表整除。

因此我们离解出欧拉函数就进了一步了，我们的过渡式子就是$TS_1(n)=n-[\frac{n}{p_1}]-[\frac{n}{p_2}]-\dots-[\frac{n}{p_{k-1}}]-[\frac{n}{p_k}]$。

~~好耶~~

别急着好耶，我们可以发现一个小小的推导谬误（可能并不是很容易发现）。当我们用$p_2$去筛数时，使用的算式仍然是$[\frac{n}{p_2}]$。对于形如$p_1^np_2^m$的数，会被重复筛去多次，导致多减，最终结果会小于$\varphi(n)$。有些抽象，我们来看这张图：

![容斥原理](data:image/png;base64,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)

易知$[1,30]$中可被$2$整除的数字共有$30\div 2=15$个，能被$5$整除的数字共有$30\div 5=6$个。但是如果说能被$2$和$5$整除的数字共有$15+6=21$个，显然不合常理，**因为$10$、$20$、$30$都既能被$2$整除，也能被$5$整除，如果不加排除，他们将会被减去2次**。因此需要补偿损失，正确的计算方法是（仅计算能被$2$和$5$整除的数的总个数）：

- 能被$2$整除的：$30\div 2=15$个
- 能被$5$整除的：$30\div 5=6$个
- 同时被$2$和$5$整除的：$30\div lca(2,5)=30 \div 10=3$个
- 总个数：$15+6-(2-1)\times 3=18$个（就是被绿圈和橙圈捆住的的数的个数）

那么对于$2$、$3$、$5$整除问题，中间的$30$被重复加了3次，需减去两次平衡收支。此即容斥原理的简单思想表示。

回到欧拉函数推导上来：过渡公式$TS_1$中的容斥问题可以解决一部分了。**对于可同时被两个不同质数整除的数（例如$6=2\times3$、$15=3\times5$），我们加上它的总个数。** 得到$TS_2=TS_1+[\frac{n}{p_1p_2}]+[\frac{n}{p_1p_3}]+\dots+[\frac{n}{p_1p_k}]+[\frac{n}{p_2p_3}]+[\frac{n}{p_2p_4}]+\dots+[\frac{n}{p_{k-1}p_k}]$。

当然这又有一个小问题~~没完没了了是不是？~~：**对于$p_1\;p_2\;p_3$的公倍数，会被先减去3次，然后被上一步的操作加上3次，总体不加不减**。还是回到上图：中间的$30$会被每个颜色的圈先减去一次、共3次，上一步的补偿操作，可以看作又被橙绿圈（橙圈和绿圈的交集）、蓝绿圈、蓝橙圈一共加上了3次。减3次加3次相当于没动，为了让它被算上，我们需要加上它，对于$\varphi(n)$则是全部减去（因为*括号外有减号需要变号*，不要忘记$\varphi(n)$是由一系列不合规的数字个数*相减*得来的）。得到我们的过渡态3：$TS_3=TS_2-[\frac{n}{p_1p_2p_3}]-[\frac{n}{p_1p_2p_4}]-[\frac{n}{p_1p_2p_5}]-\dots-[\frac{n}{p_{k-2}p_{k-1}p_{k}}]$

又是如上的容斥判断，这里我们省去讨论。将最终的产物合并得到：$\varphi(n)=n*(1-\frac{1}{p_1})(1-\frac{1}{p_2})\dots(1-\frac{1}{p_{k-1}})(1-\frac{1}{p_k})$！（我不会合并，但是你可以把$\varphi(n)$括号拆开看看是不是上述形式。总之，欧拉牛逼！）

$QED$，好耶！~~终于可以好耶了……~~

#### Div2. 欧拉函数代码实现

~~主要是如果压成一个Div会非常的长，因此这里新开一个Div2~~

我们明确了欧拉函数的推导，接下来就是整理思路写代码的时间了！我们也只需跟着原始思路走就可以了。再次回忆一下：首先我们需要筛出质因数，除去它的所有倍数，再用公式$\varphi(n)=n*(1-\frac{1}{p_1})(1-\frac{1}{p_2})\dots(1-\frac{1}{p_{k-1}})(1-\frac{1}{p_k})$代入$p_i$就可以了。

```cpp
long long eular(int n) {
	long long res = n;
	for (int i = 2; i * i <= n; i++) {
		if (n % i == 0) {
			res = res * (i - 1) / i;
			while (n % i == 0) n /= i;
		}
	}
	if (n > 1) res = res * (n - 1) / n;
	return res;
}
```

时间复杂度：$\mathcal O(\sqrt n)$

适用范围：All Clear

#### Div3. 欧拉函数推论

> 1. 若$p$为质数，则$\varphi(p)=p-1$

让我们回到欧拉函数的定义上去：$\varphi(i)$是$[1,i]$中与$i$互质的数的个数（特殊地，$\varphi(1)=1$）。那么对于$p$这个质数，有多少数与它互质呢？

很显然，答案是$p-1$个！因为$p$的质因子只有$p$本身，若不止$p$一个质因子，很显然它不是一个质数。因此$\varphi(p)=p(1-\frac{1}{p})=p-1$。

> 2. 假设$p_k$是一个质数，$p_k\mid i$（或$i\bmod p_k=0$），且$\varphi(i)$的值已知，那么$\varphi(p_k*i)=p_k\cdot\varphi(i)$

~~凭啥呀？~~

因为$p_k$已经是一个质数，换句话说：在这个条件下$p_k$是$p_k*i$的一个质因子。在计算$\varphi(i)$时，$p_k$就已经作为一个质因子以$(1-\frac{1}{p_k})$的形式乘进去了。此时$\varphi(i)$可以写作

$\varphi(i)=i(1-\frac{1}{p_1})(1-\frac{1}{p_2})\dots(1-\frac{1}{p_k})\dots (1-\frac{1}{p_n})\dots \dots(1)$

那么函数值多乘了一个$p_k$

$\varphi(p_k*i)=p_k\cdot i(1-\frac{1}{p_1})(1-\frac{1}{p_2})\dots(1-\frac{1}{p_k})\dots (1-\frac{1}{p_n})\dots\dots(2)$

我们发现：(2)式中包含了(1)式，只是头上乘以了$p_k$。因而得到$\varphi(p_k*i)=\varphi(i)\cdot p_k$

> 3. 假设$p_k$是一个质数，$p_k\nmid i$（或$i\bmod p_k\neq0$），且$\varphi(i)$的值已知，那么$\varphi(p_k*i)=p_k\cdot\varphi(i)\cdot(1-\frac{1}{p_k})= \varphi(i)\cdot(p_k-1)$

这东西长得和性质2很相似，唯一不同的是$p_k$不再是$i$的一个质因子了。但是$p_k$变成了$p_k*i$的质因子。因此我们计算$\varphi(p_k*i)$的值时，不仅需要在头部乘上$p_k$，而且还需要将$(1-\frac{1}{p_k})$乘进去：

$\varphi(p_k*i)=p_k\cdot i\cdot (1-\frac{1}{p_1})\dots(1-\frac{1}{p_n})(1-\frac{1}{p_k})$

因为$p_k\cdot (1-\frac{1}{p_k})=p_k-1$，所以得到性质3，即$\varphi(p_k*i)=p_k\cdot\varphi(i)\cdot(1-\frac{1}{p_k})= \varphi(i)\cdot(p_k-1)$。

这三个性质将作为重点性质出现在欧拉函数筛法中。

#### Div4. 欧拉函数线性筛

我们已经接触了简单的欧拉函数计算方法，那么又该如何解决形如：“给定一个正整数$i\in [x,y]$，求$\sum\limits_{i=x}^{y}\varphi(i)$的值”的问题呢？

考虑继续使用上面的朴素算法，时间复杂度将会是$n\sqrt n$。明显无法满足需求，更何况，每个数与每个数之间的$\varphi$值之间有一种推导关系，使得我们无需每次重新计算$\varphi$值，而是用已经求出的$\varphi(n)$来线性推出$\varphi(i)$的值。

欧拉函数涉及到质因子的拆分，我们又需要在线性时间内求各种质数。自然而然想到了先前所学的线性筛：

```cpp
int primes[N];
bool st[N];
int cnt = 0;

void sieve(int n) {
	for (int i = 2; i <= n; i++) {
		if (!st[i]) primes[++cnt] = i;
		for (int j = 1; primes[j] * i <= n; j++) {
			st[primes[j] * i] = true;
			if (i % primes[j] == 0) break;
		}
	}
}
```

我们运用这段代码可以得出$[1,n]$范围内所有的质数，用`st[N]`数组可以筛出所有的合数。也就是说对于筛出的合数，我们能够得知组成它的质因子是什么，比如`st[primes[j]*i]=true;`这一行代码。接着套用上述三种性质，我们可以得出$\varphi$值。

此时我们就需要新建一个`phi[N]`数组来存储每个数的$\varphi$值，并且在代码中三个地方加入对于三种性质的公式：

```cpp
typedef long long ll;

ll primes[N];
bool st[N];
int cnt = 0;
ll phi[N];

void phi_sieve(int n) {
	for (int i = 2; i <= n; i++) {
		if (!st[i]) {
			primes[++cnt] = i;
			phi[i] = i - 1; 
		}
		for (int j = 1; primes[j] * i <= n; j++) {
			st[primes[j] * i] = true;
			if (i % primes[j] == 0) {
				phi[primes[j] * i] = phi[i] * primes[j];
				break;
			}
			phi[primes[j] * i] = phi[i] * (primes[j] - 1);
		}
	}
}
```

~~没错我开了`long long`防止爆`int`~~

时间复杂度：$\mathcal O(n)$

适用范围：普及&提高

对于开头提出的求和问题，遍历`phi[1]`到`phi[n]`的所有值求和即可。

#### Div5. 欧拉定理

> 若正整数$a$与$n$互质，则有$a^{\varphi(n)}\equiv1\pmod n$

对于它的证明，[百度百科](https://baike.baidu.com/item/%E6%AC%A7%E6%8B%89%E5%AE%9A%E7%90%86/891345?fr=ge_ala#2_2)中如此写到：

> 取$m$的缩系$a_1,a_2,\dots,a_{\varphi(m)}$，故$aa_1,aa_2,\dots,aa_{\varphi(m)}$也为$m$的缩系。有$\prod\limits_{i=1}^{\varphi(m)}a_i\equiv\prod\limits_{i=1}^{\varphi(m)}aa_i\equiv a_{\varphi(m)}\prod\limits_{i=1}^{\varphi(m)}a_i\pmod m$

通俗来讲就是这样：

1. 在$[1,n]$中取所有与$n$互质的数$a_1,a_2\dots,a_{\varphi(n)}$，很容易知道这样的$a$共有$\varphi(n)$个（根据欧拉函数定义得来）。它们都与$n$互质。
2. 给这列数同时乘上$a$，得到$aa_1,aa_2,\dots,aa_{\varphi(n)}$。它们也都和$n$互质，并且各不相同。
3. 提出括号里乘了$\varphi(n)$次的$a$，得到以下关系式：$a^{\varphi(n)}[a_1a_2\dots a_{\varphi(n)}]\equiv a_1a_2\dots a_{\varphi(n)}\pmod n$
4. 那么根据同余号两端的消去原则（左右两端两个项相同且与模$n$互质），可以消去$a_1a_2\dots a_{\varphi(n)}$。得到$a^{\varphi(n)}\equiv1\pmod n$，欧拉定理得证。
5. 特殊地，如果$p$是一个质数，有$a^{\varphi(p)}\equiv1\pmod p\Rightarrow a^{p-1}\equiv1\pmod p$。这被称作费马小定理（先前的费马素性检验就是基于这个原理编写的）。

~~真不知道明明可以写得通俗点为什么非得省那点空间写看起来那么高深莫测的专业术语，真的是只写给自己看的。~~

#### Div6. 降幂算法

尤其对于绿题以上的题目，题面中可能出现“**答案可能很大，请对大质数$p$取余**”的字样。这意味着题目可能涉及到大规模的幂运算，需要我们用简便的方法计算幂。对于一般的题目，我们使用快速幂。

**快速幂**：快速幂思想如下：

$a^b= \begin{cases}a^{ \frac{b}{2}}\times a^{ \frac{b}{2}},& b\bmod 2=0\\a\times a^{ \frac{b-1}{2}}\times a^{ \frac{b-1}{2}},&b\bmod2=1 \end{cases}$

我们将指数$b$分解为若干$2^n$的和（二进制表示），例如：$a^{11}=a^{2^0}\cdot a^{2^1}\cdot a^{2^3}$，因为$(11)_{10}=(1011)_2$。因而不必将$a$连续乘11次，效率大幅提升。

```cpp
typedef long long ll;

int qpow(int a, int k, int p) {
	int res = 1;
	while (k) {
		if (k & 1) res = (ll) res * a % p;
		a = a * a % p; 
		k >>= 1;
	}
	return res;
}
```

时间复杂度：$\mathcal O(\log n)$

适用范围：基本All Clear

**欧拉降幂**：上面方法一个缺点在于无法处理过大的指数，在处理类似于$a^{2^n}$的计算时将会疯狂掉san。接下来介绍一种使用上面讲到的欧拉定理来解决大指数幂运算的方法。

欧拉降幂核心公式：$a^k\bmod p=a^{k\bmod\varphi(p)+\varphi(p)}\bmod p$（又称 _扩展欧拉定理_ ）

也就是说：我们只需要算出$q=k\bmod\varphi(p)+\varphi(p)$的值，再用快速幂算法，将$q$作为新指数带入计算即可。当然，这里的$k$可能会爆`long long`，因此可以选择使用字符串进行高精度计算。

```cpp
typedef long long ll;

ll primes[N];
bool st[N];
int cnt = 0;

int qpow(int a, int k, int p) {
	int res = 1;
	while (k) {
		if (k & 1) res = (ll) res * a % p;
		a = a * a % p; 
		k >>= 1;
	}
	return res;
}

ll eular(int n) {
	ll res = 0;
	for (int i = 2; i <= n; i++) {
		if (!st[i]) {
			primes[++cnt] = i;
			res = res * (i - 1) / i;
			while (n % i == 0) n /= i;
		}
		for (int j = 1; i * primes[j] <= n; j++) {
			st[i * primes[j]] = true;
			if (i % primes[j] == 0) break;
		} 
	}
	if (n > 1) res = res * (n - 1) / n;
	return res;
}

int edp(int a, string k, int p) {
	ll phi = eular(p);
	int drop = 0;
	for (int i = 0; i < k.length(); i++) {
		drop *= 10;
		drop += k[i] % phi;
	}
	drop += phi;
	return qpow(a, drop, p);
} 
```

其中`eular(int n)`函数用于计算欧拉函数的值、`edp(int a, string k, int p)`用于计算降幂后的指数、`qpow(int a, int k, int p)`是快速幂算法。

时间复杂度：$\mathcal O(\log n)$

适用范围：所有

扩展欧拉定理可谓是欧拉定理的一般形式，它的定义如下：对于任意正整数$a$、$k$、$p$，满足：

$a^k\equiv\begin{cases}a^k&(\bmod\;p ),gcd(a,p)\neq1,k<\varphi(p)\\a^{k\bmod\varphi(p)+\varphi(p)}&(\bmod\;p),gcd(a,p)\neq1,k\geq\varphi(p)\\a^{k\bmod\varphi(p)}&(\bmod\;p),gcd(a,p)=1\end{cases} $

其中第二个式子就是欧拉降幂的核心公式。

扩展欧拉定理的证明见[这里](https://zhuanlan.zhihu.com/p/452303582)。~~因为太复杂了我不会证~~

---

**例题：**

1. [P2158 [SDOI2008] 仪仗队](https://www.luogu.com.cn/problem/P2158) （欧拉函数板子）
2. [P1447 [NOI2010] 能量采集](https://www.luogu.com.cn/problem/P1447)（上一个问题的变式）
3. [P1226 [模板] 快速幂](https://www.luogu.com.cn/problem/P1226)
4. [P5091 [模板] 扩展欧拉定理](https://www.luogu.com.cn/problem/P5091) （欧拉降幂）
5. [P4139 上帝与集合的正确用法](https://www.luogu.com.cn/problem/P4139) （欧拉降幂+递归）

### Part5. 同余方程的解法

这里会涉及到一元线性同余方程，一元线性同余方程组和高次同余方程的算法解法。

#### Div.1 裴蜀定理

很多人会把他读成裴除（chú）（比如我的某位好友），**这个名词正确的读法是裴蜀（shǔ）**。或者可以直接改称作“贝祖定理”，它的提出者艾蒂安·裴蜀估计怎么也没想到后人居然连他的名字都读不对（想想如果这种事情发生到你身上会怎么样）。你也可以读他名字的法语发音$B\acute ezout$（显得你很优雅且有文化）。

切入正题，裴蜀定理表述为：**对于任意正整数$a$，$b$，总有整数$x$、$y$，使得$ax+by=(a,b)$**，其中$(a,b)$等价于$gcd(a,b)$，是数论中最大公约数的表述方式。

首先可以知道$at+bn=d\;\;\;(n,t\in\mathbb Z\;\;\;n,t\neq0)$且$(a,b)\mid d$，因为$a$和$b$都具有约数$(a,b)$，让他们分别乘上另两个数$t$和$n$并不会改变$(a,b)$这一约数。所以假设$d=k\cdot(a,b),k\in\mathbb Z$，有$a\frac{t}{k}+b\frac{n}{k}=(a,b)$。在这里，$x=\frac{t}{k}\;\;y=\frac{n}{k}$。

#### Div2. 扩展欧几里得（EXGCD）

~~加了“扩展”二字是不是感觉逼格上来了？~~

扩展欧几里得算法用于求出线性同余方程的解。线性同余方程，即形如$ax\equiv b\pmod p$的方程，我们需要求出$x$的值。

回忆一下欧几里得算法的核心思路：$(a,b)=\begin{cases}(a,a\bmod b)&a\bmod b\neq0\\a&a\bmod b=0\end{cases}$。

再看看刚刚讲到的裴蜀定理，发现$(a\bmod b)x+by=k\cdot(a,a\bmod b)=k\cdot(a,b)=d$。根据余数的定义，有：$(a-\lfloor\frac{a}{b}\rfloor\cdot b)x+by=d$。

那么我们的任务就是求出这里的$x$和$y$值，因此拆开括号，整理出$a$和$b$的系数：$ax+b(y-\lfloor\frac{a}{b}\rfloor x)=d$。观察裴蜀定理的形式：$ax+by=(a,b)$，我们得出的式子中，$y$变成了$y-\lfloor\frac{a}{b}\rfloor x$。因此每次递归时需要将$y$的值减去$\lfloor\frac{a}{b}\rfloor x$。

既然我们设计的是一个递归算法，我们就必须明确它的递归出口。根据欧几里得算法，当$a\bmod b=0$时，$(a,b)=a$。我们把$a$和$a\bmod b$代入发现：$ax+(a\bmod b)y=(a,b)=a$，得到$ax+0y=a$，此时$y$可取任意整数值，$x=1$。这里我所取的解是$\begin{cases}x=1\\y=0\end{cases}$。

最后，因为这本质上还是一个欧几里得算法，所以返回$(a,b)$是有必要的（事实上exgcd算法返回的$(a,b)$将作为推导式中的$d$参与运算）。我们可以写出如下函数。

```cpp
int exgcd(int a, int b, int &x, int &y) {
	if (!b) {
		x = 1;
		y = 0;
		return a;
	}
	int d = exgcd(b, a % b, y, x);
	y -= a / b * x;
	return d;
}
```

时间复杂度：$\mathcal O(\log n)$

但是，题目中一般不会给出裴蜀定理那样的形式，而是形如$ax\equiv b\pmod m$的形式，让你求出$x$的值，并且上述方法仅求出了一元线性同余方程的一组特解，如果题目中让你求出最小**正整数解**呢？接下来就是解决上述问题的方法：

**1. 同余—等式互转**（自己起的名字）：

在上面的介绍中，我们遇到了一个问题：如何将$ax\equiv b\pmod m$这样的同余式变为$ax+by=c$这样的二元一次不定方程的裴蜀定理形式呢？

考虑到同余方程的定义（或者你可以把以下关系死记住），得到$ax\bmod m=b$。接着由余数定义，得到$ax=by+m,y\in\mathbb Z$，移项得到：$ax-by=m$。提出负号，令$b^\prime=-b$，则$ax+b^\prime y=m$。它有解的充要条件是$m\mid(a, b)$。经过如上变换后就变成了裴蜀定理的形式，可以直接用`exgcd`求解$x$和$y$。

**2. 最值解问题**：

[二元一次不定方程通解的证明](https://www.luogu.com.cn/blog/justpureh2o/general-solution-proof-for-2dioequation)

#### Div3. 中国剩余定理（CRT）

又称孙子定理（但我认为还是中国剩余定理听起来更有实力一些），最早见于《孙子算经》中“物不知数”问题，首次提出了有关一元线性同余方程的问题与解法。

对于一元线性同余方程：$S\rightarrow\begin{cases}x\equiv a_1\pmod{p_1}\\x\equiv a_2\pmod{p_2}\\\vdots\\x\equiv a_k\pmod{p_k}\end{cases}$，可以构造以下方法求出通解。

首先，令$M=p_1\cdot p_2\cdot p_3\dots p_k=\prod\limits_{i=1}^{k}p_i$。

然后，令$M_i=\frac{M}{p_i}\;(1\leq i\leq k)$，即除了$p_i$外所有$p$的乘积。

接着，令$t_i$为$M_i$在模$p_i$意义下的逆元，即$t_i\cdot M_i\equiv1\pmod{p_i}$。

所以，$S$的通解为：$x=a_1t_1M_1+a_2t_2M_2+\dots+a_kt_kM_k+kM=kM+\sum\limits_{i=1}^{k}a_ip_iM_i$。

#### Div4. Baby Step Giant Step算法（BSGS）

这个算法用于解决一元高次同余方程问题，模意义下的对数也可以求。又称“北上广深算法”~~（想出这种名字的人真是人才）~~。

高次同余方程长成这个样子：

$a^x\equiv b\pmod m$

发现$x$跑到了指数上边~~真是变态呢~~。这种问题显然没公式解，于是苦恼的人们只得选择一条略显暴力的求解道路，即**搜索**。严格来说，BSGS所使用的是双搜索，其中的一个变量的搜索步长会长于另一个变量的搜索步长，因而得名“大步小步算法”。~~或者叫北上广深/拔山盖世算法！~~

**朴素BSGS**（$a$与$m$互质）：不妨令$x=At-B$，原式为$a^{At-B}\equiv b\pmod m$。根据消去原则，两边同乘$a^B$得$a^{At}\equiv ba^B\pmod m$。

接下来我们对同余号右侧的部分求值，再任命一个固定的$t$值，使得左侧模$m$的值等于右侧模$m$的值。为了快速比对左右侧的值，我们选择将右侧预先计算出来的值存入一个哈希表中，让$ba^B\bmod m\rightarrow B$（键为$ba^B$，对应值为$B$）。接着就是选择$t$值，计算$a^{At}\bmod m$并比对了。

关于哈希表冲突，我们希望找到$x,x=At-B$的最小值，因而$B$需要尽可能大。每次冲突即代表一个更大的$B$值被发现了。因此无需处理冲突问题。

对于$t$的选择。可以发现$B$有$\varphi(m)\bmod t$个可能的取值，$A$有$\lfloor\varphi(m)/t\rfloor$个。$t$取$\lceil\sqrt{\varphi(m)}\rceil$时最佳。因此代码就可以写出来了。

```cpp
ll bsgs(ll a, ll b, ll m) {
	unordered_map<ll, ll> hash;
	ll bs = 1;
	int t = sqrt(m) + 1;
	for (int B = 1; B <= t; B++) {
		bs *= a;
		bs %= m;
		hash[b * bs % m] = B;
	}
	ll gs = bs;
	for (int A = 1; A <= t; A++) {
		auto iter = hash.find(gs);
		if (iter != hash.end()) return A * t - it->second;
		gs *= bs;
		gs %= m;
	}
	return -1;
}
```

时间复杂度：$\mathcal O(\sqrt m)$

**扩展BSGS**（$a$和$m$不互质）：

---

**例题：**

1. [P1082 [NOIP2012 提高组] 同余方程](https://www.luogu.com.cn/problem/P1082) (exgcd)
2. [P5656 [模板] 二元一次不定方程 (exgcd)](https://www.luogu.com.cn/problem/P5656)
3. [P1495 [模板] 中国剩余定理（CRT）/ 曹冲养猪](https://www.luogu.com.cn/problem/P1495)
4. [P1516 青蛙的约会](https://www.luogu.com.cn/problem/P1516) （CRT+exgcd）
5. [P3846 [TJOI2007] 可爱的质数/ [模板] BSGS](https://www.luogu.com.cn/problem/P3846)
6. [P2485 [SDOI2011] 计算器](https://www.luogu.com.cn/problem/P2485) （欧拉降幂+乘法逆元+BSGS）
7. [P3306 [SDOI2013] 随机数生成器](https://www.luogu.com.cn/problem/P3306) （等比数列推导+BSGS）
8. [P4195 [模板] 扩展 BSGS/exBSGS](https://www.luogu.com.cn/problem/P4195)

### Part6. 乘法逆元

乘法逆元定义如下（注意和矩阵求逆不是一个东西）：

> 若$a\cdot x\equiv1(\bmod\;b)$，且$a$与$b$互质，则$x$是$a$在模$b$条件下的乘法逆元，记作$a^{-1}$

简单来说乘法逆元$x$就是模$b$意义下的$a$的倒数。

**费马小定理求逆元**：大部分题目会给出一个质数模数，因而互质是可以保证的。此时我们的乘法逆元就是使式子$a\cdot x\equiv1(\bmod\;p)$成立的$x$值，考虑到模数$p$为质数，可以带回开头所说的费马小定理中。

得到$a^{p-1}\equiv1(\bmod\;p)$，由于$a$与$p$互质，消去得：$a\cdot a^{p-2}\equiv1(\bmod\;p)$，所以乘法逆元为$a^{p-2}\bmod\;p$。

```cpp
int inv(int a, int p) {
	return qpow(a, p - 2, p);
}
```

**扩展欧几里得求逆元**：这是万能的方法，对任意模数均成立。它不像上面费马小定理那样限制模数必须是质数，因而只要时间充裕，都建议使用这种求逆元的方式。

因为$ax\equiv 1\pmod b$，运用同余-等式互转可以得到$ax-1=by\rightarrow ax+by^\prime=1\pmod b,y^\prime=-y$。符合`exgcd`的形式。

```cpp
int exgcd(int a, int b, int &x, int &y) {
	if (!b) {
		x = 1;
		y = 0;
		return a;
	}
	int d = exgcd(b, a % b, y, x);
	y -= a / b * x;
	return d;
}

int inv(int a, int m) {
	int x, y;
	exgcd(a, m, x, y);
	return (x + m) % m;
}
```

**递推求逆元**：

---

**例题：**

1. [P3811 [模板] 模意义下的乘法逆元](https://www.luogu.com.cn/problem/P3811) （递推求逆元）

~~来张弔图~~

![](https://pic.imgdb.cn/item/658ec89bc458853aefc1f3ca.jpg)

### Part7. 矩阵相关

矩阵，是一个按照长方排列的实数或复数集合。它最早用来表示方程组中的系数和常数，简单理解就是它将$n$元一次方程组中的系数，按照未知数的顺序依次挑出它们的系数组合为矩阵的某一行。$n$元一次方程的矩阵有$n$列，而行数则取决于方程组中方程的个数。

#### Div1. 初等行变换

考虑这个方程组：

$\begin{cases}2x+3y=-1&\dots1\\x-2z=6&\dots2\\x+2y-4z=-2&\dots3\end{cases}$

按照如上所述，将它转换为系数矩阵（只有$x,y,z$的系数）就是：

$\begin{pmatrix}2&3&0\\1&-2&0\\1&2&-4\end{pmatrix}$

你也可以写成增广矩阵（与系数矩阵相比多了一列常数，即等号右边的常数，这里用竖线隔开）的形式：

$\left(\begin{array}{ccc|c}2&3&0&-1\\1&-2&0&6\\1&2&-4&-2\end{array}\right)$

不难看出第一列代表了$x$的系数，第二列和第三列是$y$和$z$的系数。那么如果需要求解这个矩阵（得到方程组的解），我们应该通过初等行变换将它变成方便我们求解的模式。初等行变换内容如下（最好用方程组消元的思想简化理解）：

1. 交换某两行
2. 把矩阵的某一行同乘以一个非零的数
3. 把某行的若干倍加和到另一行

假设我们有一个$n$元线性方程组，如何设计算法使计算机能够快速求出它的解呢。我们需要引入**三角矩阵**的概念：

顾名思义，系数排列看起来像一个三角形的矩阵，叫做三角矩阵。分为上三角矩阵和下三角矩阵。前者的非零系数均分布在对角线的右上方、后者都在左下方，例如矩阵：$U\rightarrow\begin{pmatrix}5&2&2&1&7\\0&-2&4&9&-1\\0&0&7&6&4\\0&0&0&2&8\end{pmatrix}$就是一个上三角矩阵（这里是增广矩阵）。通常用字母$U$表示，求解线性方程组时经常化为这种形式方便求解：本例中当最后一个未知数（见最后一行）已知时，可以通过向上代入求解每一行中待求的未知数值。

那么如何将一个一般矩阵转换为上三角矩阵呢？答案是前面介绍过的初等行变换！步骤如下：

1. 枚举每一列$c$，选出无序组中第$c$列系数绝对值最大的一行$p$，并移到无序组的最上边。
2. $p$行通过自乘，将第$c$列的系数变成$1$，并标记$p$为有序。
3. 通过加减有序组中某一行的非零倍，将之后所有行的第$c$列系数化为$0$。

文字还是太抽象，我们来举个例子：

令矩阵$A\rightarrow\left(\begin{array}{ccc|c}2&-1&1&1\\4&1&-1&5\\1&1&1&0\end{array}\right)$（有序组用绿色表示）

枚举第一列，$c=1$。开始时，所有行均无序。选出绝对值最大的那一项，本例中为第二行，进行移动，原矩阵变为：

$\left(\begin{array}{ccc|c}4&1&-1&5\\2&-1&1&1\\1&1&1&0\end{array}\right)$

第二步，自乘并标记有序，因此第一行除以$4$，原矩阵就变成了：

$\left(\begin{array}{ccc|c}\textcolor{green}{1}&\textcolor{green}{0.25}&\textcolor{green}{-0.25}&\textcolor{green}{1.25}\\2&-1&1&1\\1&1&1&0\end{array}\right)$

第三步，将无序组的第$c$列消成$0$。本例中，我们让第二行减去二倍第一行；第三行直接减去第一行，得到：

$\left(\begin{array}{ccc|c}\textcolor{green}{1}&\textcolor{green}{0.25}&\textcolor{green}{-0.25}&\textcolor{green}{1.25}\\0&-1.5&1.5&-1.5\\0&0.75&1.25&-1.25\end{array}\right)$

枚举第二列，此时$c=2$。第一步，选出第二列系数绝对值最大的那一行，移到无序组最上端。本例中无需移动，自乘$-\frac{2}{3}$，标记有序，原矩阵为：

$\left(\begin{array}{ccc|c}\textcolor{green}{1}&\textcolor{green}{0.25}&\textcolor{green}{-0.25}&\textcolor{green}{1.25}\\\textcolor{green}{0}&\textcolor{green}{1}&\textcolor{green}{-1}&\textcolor{green}{1}\\0&0.75&1.25&-1.25\end{array}\right)$

最终的最终，第三行减$0.75$倍第二行，得到我们心心念念的上三角矩阵：

$U\rightarrow\left(\begin{array}{ccc|c}1&0.25&-0.25&1.25\\0&1&-1&1\\0&0&2&-2\end{array}\right)$

我们假设从左到右，分别为$x$、$y$、$z$的系数，竖线右侧为常数。矩阵可以改写成方程组的形式：

$\begin{cases}x+0.25y-0.25z=1.25\\y-z=1\\2z=-2\end{cases}$

根据最后一行，显然$z=-1$。将$z$代入2式，解得$y=0$，以此类推，由下向上代入解出的值即可，本例的唯一解是：$\begin{cases}x=1\\y=0\\z=-1\end{cases}$。

然而心细的你估计发现了疏漏之处：“求一元二次方程时都要先检验根是否存在（$\Delta$判别式法）再来作答，你这里怎么没有讨论根的分布情况呢？”

事实上，矩阵的解的分布确实不止一种情况，这里是矩阵有唯一解的情况。类比高中立体几何求平面法向量的情景，我们通常都要令某个坐标为$1$或者是其他方便于计算的值，这里就是矩阵有无数组解的经典例子。要想系统分析矩阵方程解的数量情况，我们需要引入**秩**的概念。

#### Div2. 秩

在上一节中我们通过初等行变换求出了矩阵的解，然而并不是所有矩阵都能轻而易举求出唯一解，因为它可能无解、也有可能无唯一解（默认最高次数为一）。类比一元二次方程中的$\Delta$判别式法，矩阵是否也有判断根存在性的方法？

答案是：有滴！在矩阵运算中，我们使用**秩**来描述矩阵的一些关于解的个数的关系。秩被定义为：将矩阵通过初等行变换后形成的梯形矩阵中非零行的个数。试看如下例子：

定义一个$3\times2$的矩阵：$\begin{pmatrix}2&3&1\\6&9&3\\0&7&2\end{pmatrix}$

经过初等行变换后出现了这样的情况：

$\begin{pmatrix}4&-1&0\\0&0&0\\0&7&2\end{pmatrix}$(第二行减去乘3的第一行，第一行乘2减去第三行)

第二行变成了纯$0$的一行，一、三行说什么都无法消成一个未知数的形式。如果写成方程组就是：

$\begin{cases}4x-y=a_1\\7y+2z=a_2\end{cases}$

它有无数组解，原因是：**矩阵的秩与矩阵增广矩阵的秩相等且小于了它的阶**。简单来说就是你用两个方程去求三个未知数的值（初一内容），当然是有无数多组解。

规定对于矩阵$A$，它的秩用$R(A)$表示（$r(A)$、$rk(A)$、$rank(A)$均可）。因此令方程组的$n$阶增广矩阵秩为$R(A)$，系数矩阵的秩为$R(B)$。矩阵有无数组解的条件就是$R(B)<n$（严格来说：有无数组解的充要条件是$R(A)=R(B)<n$）

看第二个例子：

定义增广矩阵：$A\rightarrow\left(\begin{array}{cc|c}2&8&3\\1&3&-2\\2&7&1\end{array}\right)$；它的系数矩阵：$B\rightarrow\begin{pmatrix}2&8\\1&3\\2&7\end{pmatrix}$。

增广矩阵变换后：$\left(\begin{array}{cc|c}0&1&2\\2&0&-25\\0&0&3\end{array}\right)$；系数矩阵：$\begin{pmatrix}0&1\\2&0\\0&0\end{pmatrix}$

根据定义，得到$R(A)=3$，$R(B)=2$，此时$R(A)>R(B)$。方程组无解。因而矩阵无解的充要条件是$R(A)>R(B)$。简单理解起来就是方程组中的两个方程起了冲突，矩阵$A$被省去的其中一步变换是：$\left(\begin{array}{cc|c}0&1&2\\2&0&-25\\0&1&5\end{array}\right)$，第一行和第三行相当于要你求解如下的方程组：$\begin{cases}y=2\\y=5\end{cases}$。显然矛盾，因此矩阵无解。

加上第一节里面的结论，我们总结出了矩阵解分布的三种情况（方程组的增广矩阵为$A$、系数矩阵为$B$，阶为$n$）：

1. 当$R(A)=R(B)=n$时，矩阵有唯一解
2. 当$R(A)=R(B)<n$时，矩阵有无数解
3. 当$R(A)>R(B)$时，矩阵无解

因此就有了一套组合算法：

```cpp
#include <bits/stdc++.h>
#define N 110

#define NO_SOLUTION -1
#define INFINITE 0
#define SOLVE_OK 1
using namespace std;

typedef long long ll;

double mat[N][N];
int n;
double eps = 1e-6;
 
int solve() {
	int rank = 0;
	for (int c = 0, r = 0; c < n; c++) {
		int t = r;
		for (int i = r; i < n; i++) {
			if (fabs(mat[i][c]) > fabs(mat[t][c])) t = i;
		}
		if (fabs(mat[t][c]) < eps) continue;
		for (int i = c; i <= n; i++) swap(mat[r][i], mat[t][i]);
		for (int i = n; i >= c; i--) mat[r][i] /= mat[r][c];
		for (int i = r + 1; i < n; i++) {
			if (fabs(mat[i][c]) > eps) {
				for (int j = n; j >= c; j--) {
					mat[i][j] -= (mat[r][j] * mat[i][c]);
				}
			}
		}
		r++;
		rank = r;
	}
	if (rank < n) {
		for (int i = rank; i < n; i++) {
			for (int j = 0; j < n + 1; j++) {
				if (fabs(mat[i][j]) > eps) return NO_SOLUTION;
			}
		}
		return INFINITE;
	}
	for (int i = n - 1; i >= 0; i--) {
		for (int j = i + 1; j < n; j++) {
			mat[i][n] -= mat[i][j] * mat[j][n];
		}
	}
	return SOLVE_OK;
} 

int main() {
	cin>>n;
	for (int i = 0; i < n; i++) {
		for (int j = 0; j < n + 1; j++) 
			cin>>mat[i][j];
	}
	int res = solve();
	if (res != SOLVE_OK) cout<<res<<endl;
	else for (int i = 0; i < n; i++) {
		if (fabs(mat[i][n]) < eps) mat[i][n] = fabs(mat[i][n]);
		printf("x%d=%.2lf\n", i + 1, mat[i][n]); 
	}
	return 0;
}
```

时间复杂度：$\mathcal O(n^3)$

~~以后上大学解高次线性方程就可以用这段程序秒了。~~

#### Div3. 矩阵基本运算

**1. 加法**：

$\begin{pmatrix}2&3&8\\1&4&2\end{pmatrix}+\begin{pmatrix}6&0&4\\3&3&5\end{pmatrix}=\begin{pmatrix}2+6&3+0&8+4\\1+3&4+3&2+5\end{pmatrix}=\begin{pmatrix}8&3&12\\4&7&7\end{pmatrix}$

注意类比$n$元一次方程组的加减消元，两个矩阵相加意味着同一位置的元素相加。需要注意：**只有同型的矩阵才有加法运算**（同型即行数列数相等）。

可以知道，四则运算的加法交换律和结合律仍然适用于矩阵加法。

**2. 减法**：

$\begin{pmatrix}2&3&8\\1&4&2\end{pmatrix}-\begin{pmatrix}6&0&4\\3&3&5\end{pmatrix}=\begin{pmatrix}2-6&3-0&8-4\\1-3&4-3&2-5\end{pmatrix}=\begin{pmatrix}-4&3&4\\-2&1&-3\end{pmatrix}$

加法的逆运算，让矩阵同一位置的元素相减即可。也是仅限于同型矩阵之间才可做减法。

**3. 数乘**：

$4\cdot\begin{pmatrix}1&4&2\\6&1&5\\3&6&0\end{pmatrix}=\begin{pmatrix}1\times4&4\times4&2\times4\\6\times4&1\times4&5\times4\\3\times4&6\times4&0\times4\end{pmatrix}=\begin{pmatrix}4&16&8\\24&4&20\\12&24&0\end{pmatrix}$

即矩阵中每个元素都跟数字相乘。符合乘法交换律和结合律

**矩阵的加法、减法和数乘合称为矩阵的线性运算**

**4. 转置**：

矩阵$A$的转置矩阵用$A^T$表示。

$\begin{pmatrix}1&4&2\\6&1&5\end{pmatrix}^T=\begin{pmatrix}1&6\\4&1\\2&5\end{pmatrix}$

直观来讲就是将原矩阵旋转一下（行和列互换）。满足如下性质：

$(A^T)^T=A$ (转置一次后再转置一次还是原来的矩阵)

$(\lambda A)^T=\lambda A^T$ （常数转置后就是它本身）

$(AB)^T=A^TB^T$ （上一条是它的特殊形式，类比两数乘积的幂）

**5. 共轭**：

矩阵$A$的共轭矩阵用$\overline A$表示。

$A=\begin{pmatrix}2+i&8\\5-4i&2i\end{pmatrix}$

$\overline A=\begin{pmatrix}2-i&8\\5+4i&-2i\end{pmatrix}$

类比共轭复数的定义：实部不变、虚部取相反数。矩阵共轭变换就是将矩阵中的所有复数变为其共轭形式。

**6. 共轭转置**：

矩阵$A$的共轭转置矩阵记作$A^*$、$\overline A^T$、$\overline{A^T}$或$A^H$。

$A=\begin{pmatrix}2+i&8\\5-4i&2i\\1+i&2-2i\end{pmatrix}$

$A^H=\begin{pmatrix}2-i&5+4i&1-i\\8&-2i&2+2i\end{pmatrix}$

字面意思，先取共轭，再转置。它具备转置矩阵的三条性质。

#### Div4. 矩阵乘法

**只有一个矩阵的行数和另一个矩阵的列数相等时才可进行乘法运算**。

例如一个$n\times p$矩阵$A\rightarrow\begin{pmatrix}1&4&2\\3&0&8\end{pmatrix}$和一个$p\times m$矩阵$B\rightarrow\begin{pmatrix}2&6\\4&1\\3&8\end{pmatrix}$。记它们的乘积$C=AB$。则$C$中的某个元素$c_{i,j}=a_{i,1}b_{1,j}+a_{i,2}b_{2,j}+\dots+a_{i,p}b_{p,j}=\sum\limits_{k=1}^{n}a_{i,k}b_{k,j}$。并且$C$是一个$n\times m$的矩阵。

因此$AB=\begin{pmatrix}1\times2+4\times4+2\times3&1\times6+4\times1+2\times8\\3\times2+0\times4+8\times3&3\times6+0\times1+8\times8\end{pmatrix}=\begin{pmatrix}24&26\\30&82\end{pmatrix}$

它满足结合律、分配律，但是大多数情况下不满足交换律。交换律不成立可以看到下面这个例子：

首先根据定义，$C$矩阵的行列数取决于做乘法的两个矩阵$A$和$B$的行列数，比如$8\times3$矩阵和$3\times4$矩阵相乘，得到一个$8\times4$矩阵，但是将它颠倒顺序，让一个$3\times4$矩阵与$8\times3$矩阵相乘，结果将是一个$4\times8$矩阵，和前者行列数相反。

对于结果是正方形矩阵的，可以自己随便设置两个矩阵进行计算。但是部分矩阵仍然可以进行交换律运算：矩阵乘一个单位矩阵/数量矩阵[$AE=EA$/$A(kE)=(kE)A$]、矩阵乘它的伴随矩阵（$AA^*=A^*A$）。

#### Div5. 其他常用类型的矩阵

**1. 零矩阵**：顾名思义，由$0$组成的矩阵称作零矩阵。零矩阵不可逆，且任何符合条件的矩阵与一个零矩阵的积均为零矩阵。

**2. 单位矩阵**：形如$\begin{pmatrix}1&0&0\\0&1&0\\0&0&1\end{pmatrix}$的矩阵被称作单位矩阵，通常用字母$E$或$I$表示。单位矩阵指仅对角线系数为$1$、且其他系数为$0$的矩阵。$n$阶矩阵与它的逆矩阵相乘得到的结果就是一个$n$阶单位矩阵，即$AA^{-1}=E$。

**3. 数量矩阵**：形如$\begin{pmatrix}k&0&0\\0&k&0\\0&0&k\end{pmatrix},k\in\mathbb R$的矩阵叫数量矩阵，可以看作实数$k$与单位矩阵$E$进行数乘运算后的结果，通常表示成$kE,k\in\mathbb R$。矩阵与一个数量矩阵的乘积满足乘法交换律。

**4. 逆矩阵**：如果存在一个矩阵$B$和单位矩阵$E$，使得$AB=E=BA$，则称矩阵$A$可逆，$B$是$A$的逆矩阵，也可记作$A^{-1}$。单位矩阵的逆矩阵是它本身；零矩阵不可逆。$n$阶矩阵可逆的充要条件是$R(A)=n$。

**5. 对称矩阵**：转置矩阵与自身相等的矩阵叫做对称矩阵，特征是所有元素关于对角线对称，例如：$\begin{pmatrix}0&3&5\\3&0&8\\5&8&0\end{pmatrix}$。对称矩阵必为方形矩阵，反之不一定成立，对于一个方形矩阵$A$，$A+A^T$必定是对称矩阵。

#### Div6. 矩阵的几何表示

平面直角坐标系上，一个向量$\vec a=(1,2)$可以被表示成$\begin{bmatrix}1\\2\end{bmatrix}$的形式，即$\begin{bmatrix}x\\y\end{bmatrix}$。

计算机中，用两个不共线向量$\vec i$和$\vec j$能够表示整个平面直角坐标系。运用一点高中数学的空间几何知识，这里的$\vec i$和$\vec j$被称作基底（当然，如果需要描述三维空间坐标系，则需要三个不共线的基底向量）。于是我们使用矩阵$\begin{bmatrix}\textcolor{red}{x_i}&\textcolor{green}{x_j}\\\textcolor{red}{y_i}&\textcolor{green}{y_j}\end{bmatrix}$来描述这个平面直角坐标系就是非常简洁明了且优雅的了。

假设我们常规想法中的平面直角坐标系是$\begin{bmatrix}\textcolor{red}{1}&\textcolor{green}{0}\\\textcolor{red}{0}&\textcolor{green}{1}\end{bmatrix}$，经过一轮线性变换后得到的新坐标系是：$\begin{bmatrix}\textcolor{red}{2}&\textcolor{green}{3}\\\textcolor{red}{1}&\textcolor{green}{-2}\end{bmatrix}$。用一张图看一下变换后的坐标系：

![](https://pic1.zhimg.com/80/v2-030b79fb2087c47de91dddb7de21ab68_720w.webp)

如果在最开始的坐标系中有一个向量$\vec a\rightarrow\begin{bmatrix}5\\7\end{bmatrix}$，我们如何在新的坐标系中表示它呢？再根据我们高中数学所学，只需要算出$5\vec i+7\vec j$的值即可。因为$\vec i$是$x$轴的基底，相当于$x$上的一个单位，我们求新向量时只需求出在新的参考系中的新$x$值和$y$值，因而直接用$x$方向的系数乘以一个单位即可，在这里就是$5\cdot\begin{bmatrix}\textcolor{red}{2}\\\textcolor{red}{1}\end{bmatrix}+7\cdot\begin{bmatrix}\textcolor{green}{3}\\\textcolor{green}{-2}\end{bmatrix}$，得到$\vec a\rightarrow\begin{bmatrix}31\\-9\end{bmatrix}$。

抽象之后变成：

$\begin{bmatrix}\textcolor{red}{a}&\textcolor{green}{b}\\\textcolor{red}{c}&\textcolor{green}{d}\end{bmatrix}\begin{bmatrix}x\\y\end{bmatrix}=x\begin{bmatrix}\textcolor{red}{a}\\\textcolor{red}{c}\end{bmatrix}+y\begin{bmatrix}\textcolor{green}{a}\\\textcolor{green}{d}\end{bmatrix}=\begin{bmatrix}\textcolor{red}{a}x+\textcolor{green}{b}y\\\textcolor{red}{c}x+\textcolor{green}{d}y\end{bmatrix}$

$TODO$

---

**例题：**

1. [P3389 [模板] 高斯消元法](https://www.luogu.com.cn/problem/P3389) （上三角矩阵的转换）
2. [P2455 [SDOI2006] 线性方程组](https://www.luogu.com.cn/problem/P2455) （前一道题的升级版）

### Part8. 组合计数

#### StarterDiv1. 阶乘概述

阶乘，数学中用$!$表示，$n!,n\in\mathbb N$表示$n\times(n-1)\times(n-2)\dots\times2\times1$的值，即$\prod\limits_{i=0}^{n-1}(n-i)$

特殊地，$0!=1$。

#### StarterDiv2. 常用排列总结

**1. 排列数**：数学中用$A_{n}^{m}$表示（$Arrangement$，老教材记作$P_{n}^{m}$，$Permulation$）。表示从$m$个数中选择$n$个进行排列，公式为：$A_{n}^{m}=n(n-1)(n-2)\dots(n-m+1)=\frac{n!}{(n-m)!}$

~~为啥呢？~~，有弔图为证↓

![](https://pic.imgdb.cn/item/658ecc3cc458853aefd6b413.jpg)

**2. 组合数**：假设有$m$个物品，从中任选出$n$个排成一组，叫做组合；所有可能的选法总数叫做组合数。用$C_{n}^{m}$表示，计算公式为：$C_{n}^{m}=\frac{A_{n}^{m}}{A_{m}^{m}}=\frac{n!}{m!(n-m)!}$。简记为：**乌鸦坐飞机**

弔图×2↓

![](https://cdn.luogu.com.cn/upload/image_hosting/peb0mouz.png)

~~GZ表示就凭这几张图他能速通整个组合数的内容~~

#### StarterDiv3. 二项式定理

学过初中的大家都知道：$(x+y)^2=x^2+2xy+y^2$，这是完全平方和公式。高中的一些牛逼娃还知道完全立方和公式，也就是：$(x+y)^3=(x+y)(x^2+xy+y^2)=x^3+3y^2x+3xy^2+y^3$。这些式子其实都是可以由二项式定理套出来的。

二项式定理定义式如下：

$(x+y)^n=\begin{pmatrix}n\\0\end{pmatrix}x^ny^0+\begin{pmatrix}n\\1\end{pmatrix}x^{n-1}y^1+\begin{pmatrix}n\\2\end{pmatrix}x^{n-2}y^2+\dots+\begin{pmatrix}n\\n-1\end{pmatrix}x^1y^{n-1}+\begin{pmatrix}n\\n\end{pmatrix}x^0y^n=\sum\limits_{k=0}^{n}\begin{pmatrix}n\\k\end{pmatrix}x^{n-k}y^k$

这里出现的$\begin{pmatrix}n\\k\end{pmatrix}=\frac{n!}{k!(n-k)!}$。是不是突然发现它和组合数公式的共同之处喽？~~但是这一章并不会用它，只是作补充知识的说……~~

有这三条就够了，接下来进入组合计数的内容。

#### Div1. 高考娃狂喜——组合数计算

**一个小栗子：**

宇宙榜一大学阿福大学的榜一博士后导师黑虎阿福给你出了一道难题：

> 给你两个正整数$a$和$b$（$a\geq b$），让你求出$C_{b}^{a}$的值。

**你**：_“这还不简单？”_

**阿福**： _“好的，我这里将$a$设为$20850904$，$b$设为$1772093$，请你求解。”_

**你**： _“WTF？”_

于是你决定用程序来代替人脑，阿福教授也做出了一定让步，让你求出$C_{b}^{a}\bmod p$的值。但是不幸的是，人类的计算机科学水平自从2024之后就被来自几光年外的八体星人文明发出的“侄子一号（NEPHEW 1）”探测僚机锁定了，因此你需要设计一个高效的计算方式，~~而不是妄想着用2077年的赛博机器运行暴力计算~~，来解决这个问题。

一旦你的运行时间超过一秒，阿福教授就会使用战技“乌鸦坐飞机”对你造成大量阶乘伤害。已经学习了阶乘的你想必已了解了它的威力，所以还是老老实实推导公式吧！

**递推版：**

组合数递推公式：$C_{a}^{b}=C_{a-1}^{b}+C_{a-1}^{b-1}$。

分析思路类似于动态规划问题：我们要从$a$个物品中挑选$b$个出来，求组合数。

![](https://cdn.luogu.com.cn/upload/image_hosting/muvk0xi1.png)

上图中，若包含这个红色物体，那么我们只需再从剩下的$a-1$个物体里挑选，因为红色物体自身占据了$b$个位置中的其中一个，因此留给其他物体的总名额就只有$b-1$个，因此该情况下组合数：$C_{a-1}^{b-1}$；同样地，若不包含红色物体，从剩下的$a-1$个物体中选出$b$个，因为在该情况下红色的物体不计入组合，因此剩余名额还是$b$个，组合数就是$C_{a-1}^{b}$。最后，因为从$a$个物体里选，只有包含红色和不包含红色两种情况（就好像你的双亲，不是你的母亲就是你的父亲），因此可以做到不重不漏。所以总组合数就是$C_{a-1}^{b-1}+C_{a-1}^{b}$。

```cpp
#include <bits/stdc++.h>
#define N 2010
using namespace std;

int c[N][N];

void Csieve(int p) {
	for (int i = 0; i < N; i++) {
		for (int j = 0; j <= i; j++) {
			if (!j) c[i][j] = 1;
			else c[i][j] = (c[i - 1][j - 1] + c[i - 1][j]) % p;
		} 
	}
}

int main() {
	int a, b, p;
	cin>>a>>b>>p;
	Csieve(p);
	cout<<c[a][b]<<endl;
	return 0;
}
```

时间复杂度：$\mathcal O(N^2)$

适用于$a,b\leq10^5$的大部分情况。

**预处理版：**

但是众所周知，递归有两大痛点：对于主观思维来说，是边界问题；对于客观条件来说，是内存。递归过程中CPU里储存了大量的未运行或者待返回的函数实例，当$a$和$b$的值增大时，尽管它能在时间方面表现出色，但是内存就不那么理想了，反而会显得臃肿至极。当题目中给出$a,b\geq10^5$时，建议用这种方法。

```cpp
#include <bits/stdc++.h>
#define N 100010
using namespace std;

typedef long long ll;

int fact[N], infact[N];

int qpow(int a, int b, int p) {
	int res = 1;
	while (b) {
		if (b & 1) res = (ll) res * a % p;
		a = (ll) a * a % p;
		b >>= 1;
	}
	return res;
}

int inv(int a, int p) {
	return qpow(a, p - 2, p);
}

int C(int a, int b, int p) {
	return ((fact[a] % p) * (infact[b] % p)) % p * infact[a - b] % p;
}

int main() {
	int a, b, p;
	cin>>a>>b>>p;
	fact[0] = infact[0] = 1;
	for (int i = 1; i <= N; i++) {
		fact[i] = (ll) fact[i - 1] * i % p;
		infact[i] = (ll) infact[i - 1] * inv(i, p) % p;
	}
	cout<<C(a, b, p)<<endl;
	return 0;
}
```

时间复杂度：$\mathcal O(N\log N)$

适用范围，$a,b\geq10^5$且$a,b$均在`int`范围内的大部分情况。

**Lucas定理优化版：**

$Lucas$定理如下：$C_{a}^{b}\equiv C_{a\bmod p}^{b\bmod p}\cdot C_{a\div p}^{b\div p}\pmod p$（$p$为质数）。[证明在此](https://zhuanlan.zhihu.com/p/452976974?utm_id=0)（建议直接背结论）。

```cpp
typedef long long ll;

int p;

int qpow(int a, int b) {
	int res = 1;
	while (b) {
		if (b & 1) res = (ll) res * a % p;
		a = (ll) a * a % p;
		b >>= 1;
	}
	return res;
}

int inv(int a) {
	return qpow(a, p - 2);
}

int C(int a, int b) {
	int res = 1;
	for (int i = 1, j = a; i <= b; i++, j--) {
		res = (ll) res * j % p;
		res = (ll) res * inv(i) % p;
	}
	return res;
}

ll lucas(int a, int b) {
	if (a < p && b < p) return C(a, b);
	return (ll) C(a % p, b % p) * lucas(a / p, b / p) % p;
}

int main() {
	ios::sync_with_stdio(false);
	cin.tie(0);
	cout.tie(0);

	int t;
	int n, m;
	cin>>t;
	while (t--) {
		cin>>n>>m>>p;
		cout<<lucas(n + m, n)<<endl;
	}
	return 0;
}
```

时间复杂度：$\mathcal O(N)$

其本质是套用$Lucas$定理计算$C_{a}^{b}$，因为是模$p$意义下的除法，因而我们使用逆元来操作除法。

适用范围，$a,b$在`long long`范围内的大部分情况。

**高精度版（选修）：**

什么？你厌倦了组合数后面挂着的模$p$？不妨试试高精度版的组合数计算吧！它适用于作业上的题目求解！（~~虽然前面几种也可以，毕竟手算的题数据很小取不取模都一样~~）是不是心动了呢？

常规思路来说，我们的组合数公式经过一轮分式化简可以得到：$C_{a}^{b}=\frac{a\times(a-1)\times(a-2)\times\dots\times(a-b+1)}{b\times(b-1)\times(b-2)\times\dots\times2\times1}$。因此我们可以实现高精度的乘除法来计算这个炒鸡长的算式，但是这样不仅效率低下，手写和调试的难度也会增加。我们急切地想知道如何简化成一种高精度算法。

我们看到了[Part1](https://www.luogu.com.cn/blog/justpureh2o/oint-pt1-prescholar-knowledge)里面讲的算术基本定理，将组合数转化为$p_{1}^{c_1}p_{2}^{c_2}p_{3}^{c_3}...p_{k}^{c_k}$的质数乘积分解式，最后我们只需要解决质数头顶的指数即可。我们使用以下这个公式：

$\alpha(n!)=\lfloor\frac{n}{p}\rfloor\cdot\lfloor\frac{n}{p^2}\rfloor\cdot\dots\cdot\lfloor\frac{n}{p^k}\rfloor,p^k\leq n, n,k\in\mathbb Z$。

用它可以计算出$n!$中$p_i$的个数。

```cpp
#include <bits/stdc++.h>
#define N 10010
using namespace std;

typedef long long ll;

vector<int> num;
ll primes[N], sum[N];
bool st[N];
int cnt = 0;

void prime_sieve(int n) {
	for (int i = 2; i <= n; i++) {
		if (!st[i]) primes[++cnt] = i;
		for (int j = 1; i * primes[j] <= n; j++) {
			st[i * primes[j]] = true;
			if (i % primes[j] == 0) break;
		}
	}
}

int get(int a, int p) {
	int res = 0;
	while (a) {
		res += a / p;
		a /= p;
	}
	return res;
}

vector<int> mul(vector<int> a, int b) {
	vector<int> res;
	int t = 0;
	for (int i = 0; i < a.size(); i++) {
		t += a[i] * b;
		res.push_back(t % 10);
		t /= 10;
	}
	while (t) {
		res.push_back(t % 10);
		t /= 10;
	}
	return res;
}

int main() {
	int a, b;
	cin>>a>>b;
	prime_sieve(a);

	for (int i = 1; i <= cnt; i++) sum[i] = get(a, primes[i]) - get(b, primes[i]) - get(a - b, primes[i]);
	vector<int> res;
	res.push_back(1);
	for (int i = 1; i <= cnt; i++) {
		for (int j = 1; j <= sum[i]; j++) {
			res = mul(res, primes[i]);
		}
	}
	for (int i = res.size() - 1; i >= 0; i--) cout<<res[i];
	cout<<endl;
	return 0;
}
```

时间复杂度：$\mathcal O(N\sqrt N)$

适用范围，$a,b$在`int`范围内。

有了这段代码，我们就可以完成开头阿福教授的原问题了（不模不限数据）！

#### Div2. 世界上最OI的IDE——Catalan数

当你翻开Catalan数的介绍文章，并大学特学了一番，感觉自己完全掌握了这神奇的数列，正当你兴致勃勃地打开题库搜索到一道Catalan数的题目正准备大展身手时，你会发现，面对这神奇的题干，不同于往常秒模板题的你，你甚至完全看不出来它和Catalan数有任何的关系，而且很有可能，你其实连Catalan数究竟是什么东西都不知道！

~~苏子愀然，正襟危坐而问客曰：“何为其然也？”~~ 其实还真不能让那些博客背上黑锅，这种现象与Catalan数本身的应用有很大的关系。

Catalan数，或者习惯叫卡特兰数、明安图数，是组合数学中常用的特殊数列。数列如下：“$1,1,2,5,14,42,132,429,1430,4862,\dots$”，它是一个无穷数列，数与数之间看起来似乎也没什么太大联系……其实它和斐波那契数列有类似之处，它们不具有特定的数学意义（只是斐波那契的递推方法简单得多罢了），只是一个十分普遍的数学规律。所以学习时应该挂靠于例子本身而不是一味依赖于定义所写，那我们就开始吧：

用最经典的例子写出来就是：

> 给你一个$u\times v$的网格，你将从原点$(0,0)$开始移动。对于每次移动，你只能向上/向右一格（$y$坐标/$x$坐标加一），但是需要保证你总向右走的次数不少于向上走的次数，问从原点到$A(n,n)$有多少种不同的合法路径？

假设你某时刻走到了点$M(s,t)$，根据题目要求，意味着需要保证$s\geq t$。我们拟合一条经过点$M$的正比例函数，不难看出它的斜率$k\leq1$。对于这个$u\times v$的网格，所有的点都在整数刻度上。我们接着画出直线$y=x+1$的图像，然后尽可能画几条不合法的路径出来比对一下，你会发现：**不合法的路径与直线$y=x+1$至少有一个交点，合法路径一定与$y=x+1$没有交点**。用一张图来直观体会一下：

![](https://cdn.luogu.com.cn/upload/image_hosting/1czxz8td.png)

终点$A(5,5)$，其中红线为不合法路径，蓝线为合法路径。不难发现，不合法的路径与绿线（$y=x+1$）都有至少一个交点，因为它们在某次移动后的端点与原点拟合而成的正比例函数的斜率$k>1$，因此不是合法路径。

那么如何来计算合法和不合法路径的条数呢？直接求出合法路径不好求，规律不好找，因此我们计算出总路径数量，减去不合法数量即是合法路径数量。

可以看到，无论选择什么样的路径，在不左移、不下移的前提下，到达$A(n,n)$，你都只能移动$2n$次（小学内容，把横线和竖线平移到一块数格子），其中右移$n$次、上移$n$次。转化一下，就是在$2n$次移动中选出$n$次进行右移操作，总数就是$C_{2n}^n$。

因为所有路径，包括合法的和不合法的路径都最终抵达了$A(5,5)$，难以将内鬼剔除出来。我们选择将不合法路径关于判定线$y=x+1$对称过去，它们的新终点将是$A^\prime(4,6)$，也就是$A^\prime(n-1,n+1)$。根据上面的推导方法，这里就是在$2n$轮移动中挑出$n-1$次右移操作，于是不合法路径的数量就是：$C_{2n}^{n-1}$，合法路径数量是：$f=C_{2n}^{n}-C_{2n}^{n-1}$。

（至于为什么用右移次数而不是上移次数，是因为上移受到限制，这意味着你可以一直右移到$x=5$而无需担心条件限制；但是你就不能先一直上移到$y=5$，因为这不符合题目要求）

**扩展**：如果题干中指明向右走的次数不少于向上走的次数$\pm t$，则只需将判定线上下平移为$y=x+1\pm t$即可。

~~那这些又和宇宙第一IDE有什么关系呢~~

**应用场景一：括号匹配**

将向右走转化为左括号“（”，向上走转化为右括号“）”。对于每一次输入，检查一下左括号输入次数是否永不小于右括号输入次数。若是，当输入最后一个右括号，使左右括号数量相同时，即为匹配成功；若不是，且左括号个数大于右括号个数，则表明括号等待补全；若不是，且左括号个数小于右括号个数，即立即宣布失配。

**应用场景二：合法进出栈序列计数问题**

假设一个初始为空的栈，有$2n$次操作，$n$次进栈，$n$次出栈，请问合法进出栈序列总数（空栈不出）是多少？

答案就是Catalan数，自行套公式计算。

**应用场景三：圆的不相交弦计数问题**

假设一个圆周上分布着偶数个点，对这些点两两连线，使相连的线不相交的所有方案数。其中一个合法解如下图：

![](https://cdn.luogu.com.cn/upload/image_hosting/t00q8hh5.png)

聪明如你，答案还是Catalan数！那么如何转化为已知问题求解呢？

我们将出发点标记为左括号“（”，从出发点引出去的线与其他线/点的所有交点标记为右括号“）”。当所有点两两连接完毕时，根据场景一的模型，一旦左右括号失配即代表不合法，否则合法。因此这个问题也就变成了：给定$2n$个左括号和右括号，求出使左右括号匹配的排列个数。在这里，如果问题无解，将会是这样：

![](https://cdn.luogu.com.cn/upload/image_hosting/soc999oq.png)

---

**例题：**

1. [P3807 [模板] 卢卡斯定理/Lucas 定理](https://www.luogu.com.cn/problem/P3807)
2. [P5014 水の三角(修改版)](https://www.luogu.com.cn/problem/P5014) （Catalan数公式变形推导）
