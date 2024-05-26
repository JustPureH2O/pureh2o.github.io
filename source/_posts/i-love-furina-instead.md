---
abbrlink: ''
categories:
- - 题解
date: '2024-02-19T17:44:37.366906+08:00'
tags:
- 题解
- oi
title: 洛谷  陌路寻诗礼 题解
updated: '2024-02-20T11:22:58.270+08:00'
---
题目传送门：[P10178](https://www.luogu.com.cn/problem/P10178)

~~受到了题面的启发，我才想起那个早已死去的算法——SPFA~~

题面总结成一句话就是：**最短路只能有一条**。

那么我们用最短路算法：如果有最短路，先选择最短路。如果在更新最短值时出现了冲突——即某两种方案路径长度相等时，让**后来者**考虑加上一个 $[1,k]$ 范围内的值，使它变长、不再是最短路（~~退出奖牌争夺~~）就好了。

对于加上的正整数值，不妨从 $1$ 开始加。$1$不够就加上 $2$ ，还不够就加上 $3$ ，以此类推……在经历若干次最短路淘汰后，如果边权加上 $k$ 仍然不能满足**最短路唯一**的硬性需求时，代表这组数值根本就是无解的，因此需输出`No`。反之将试加的值记录到`ans`数组中去，在每组数据结束后输出即可。

同时请注意**多测清空**！

代码，但是$80\;pts$

```cpp
#include <bits/stdc++.h>

#define N 300010
using namespace std;

int k;
int h[N], to[N], ne[N], ans[N], dis[N];
bool st[N];
int idx = 0;

void add(int u, int v) {
    idx++;
    to[idx] = v;
    ne[idx] = h[u];
    h[u] = idx;
}

bool spfa() {
    queue<int> q;
    q.push(1);
    dis[1] = 0;
    st[1] = true;
    while (!q.empty()) {
        int top = q.front();
        q.pop();
        for (int i = h[top]; ~i; i = ne[i]) {
            int j = to[i];
            if (top == j) {
                ans[i] = k;
                continue;
            }
            int trial = 1;
            if (dis[j] > dis[top] + trial) {
                dis[j] = dis[top] + trial;
                if (!st[j]) q.push(j), st[j] ^= 1;
            } else if (dis[j] == dis[top] + trial) trial++;
            if (trial > k) return false;
            ans[i] = trial;
        }
    }
    return true;
}

int main() {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.tie(nullptr);

    int t, n, m;
    cin >> t;
    while (t--) {
        memset(dis, 0x3f, sizeof dis);
        memset(h, -1, sizeof h);
        memset(st, 0, sizeof st);
        idx = 0;
    
        cin >> n >> m >> k;
        for (int i = 1; i <= m; i++) {
            int u, v;
            cin >> u >> v;
            add(u, v);
        }
        if (spfa()) {
            cout << "Yes\n";
            for (int i = 1; i <= m; i++) cout << ans[i] << ' ';
        } else cout << "No";
        cout << endl;
    }
    return 0;
}
```

这段代码居然一反常态的在第一组测试点处TLE了？？？于是重新看到数据范围——$n,m\leq 5$，发现竟然是清空的`memset`出了问题！当你定义了一个大小为 $3\times10^5$ 的数组时，调用`memset`的结果就是对这整个 $3\times10^5$ 的空间进行内存赋值，而且估计第一组测试点出了一个比较大的询问个数 $t$，导致TLE。

解决方案就是从 $1$ 循环到 $n$ 清空，避免不必要的性能浪费

代码 $100\;pts$

```cpp
#include <bits/stdc++.h>

#define N 300010
using namespace std;

int k;
int h[N], to[N], ne[N], ans[N], dis[N];
bool st[N];
int idx = 0;

void add(int u, int v) {
    idx++;
    to[idx] = v;
    ne[idx] = h[u];
    h[u] = idx;
}

bool spfa() {
    queue<int> q;
    q.push(1);
    dis[1] = 0;
    st[1] = true;
    while (!q.empty()) {
        int top = q.front();
        q.pop();
        for (int i = h[top]; ~i; i = ne[i]) {
            int j = to[i];
            if (top == j) {
                ans[i] = k;
                continue;
            }
            int trial = 1;
            if (dis[j] > dis[top] + trial) {
                dis[j] = dis[top] + trial;
                if (!st[j]) q.push(j), st[j] ^= 1;
            } else if (dis[j] == dis[top] + trial) trial++;
            if (trial > k) return false;
            ans[i] = trial;
        }
    }
    return true;
}

int main() {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.tie(nullptr);

    int t, n, m;
    cin >> t;
    while (t--) {
        cin >> n >> m >> k;
        for (int i = 1; i <= n; i++) {
            idx = 0;
            dis[i] = 0x3f3f3f3f;
            st[i] = false;
            h[i] = -1;
            ans[i] = 0;
        }
        for (int i = 1; i <= m; i++) {
            int u, v;
            cin >> u >> v;
            add(u, v);
        }
        if (spfa()) {
            cout << "Yes\n";
            for (int i = 1; i <= m; i++) cout << ans[i] << ' ';
        } else cout << "No";
        cout << endl;
    }
    return 0;
}
```

~~发现第一组数据跑得飞快，完全不见了方才TLE时的拖沓！~~

---

本蒟蒻第一篇题解，害怕~
