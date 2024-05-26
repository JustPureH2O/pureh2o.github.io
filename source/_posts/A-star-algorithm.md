---
abbrlink: ''
categories:
- - oi算法
date: '2024-04-26T15:42:58.472762+08:00'
tags:
- oi算法
- 搜索算法
- oi
title: A-star 算法——启发式搜索算法
updated: '2024-05-04T09:31:27.317+08:00'
---
*种子相声大师 JustPureH₂O 在他的新作里如此写道：*

*（上台）*

今个咱们不说dijkstra，咱来聊一聊 A星 算法。

诶，这个我知道。A星就是矩阵 A 的伴随矩阵，它有可多性质啦！考研娃们万别错过，咱们说这个伴随……

哎打住打住，A星算法怎么能是矩阵呢？再说了，你一个高中生不好好搞圆锥曲线和导数，反而来学线性代数干什么？

挨个列举矩阵 A 的代数余子式并把它放到一个新矩阵……

停停停！咱们这个 A星算法是用来求最优路径哒，你手机里的高德都用的就是 A星算法啦。A星是启发式搜索算法的其中一种，它还有一个迭代加深的版本 IDA……

这有啥的，我一通暴力 BFS 也能求最短路。

跟你那个不一样，人家 A星都是在 $10^8$ 数量级往上跑的，你一个 BFS 早超时啦——欸，所以你在认真听没有？我来考考你，A星是什么算法？

是矩阵 A 的伴随矩阵。

去你的吧

*（鞠躬退场）*

---

### A-star 算法介绍

如果你认真听了课，你就会知道 A星算法是~~伴随矩阵~~**启发式搜索算法的一类**，至于为什么是字母 A 加上一个星号——那得去问起这个名字的人，我也不清楚。

A星算法很像资本家的思维模式。对于有着庞大节点数量的图，要从起点开始搜寻到一条到终点的路径。此时的 BFS 就像一个不会做加法的完美主义者（BFS 跑最短路的要求是边权只出现一个或两个非负数），非得把所有通路都遍历一遍、才找出一条严格的最短路径；而 Dijkstra 算法又像只会做加法的完美主义者（只要边权非负即可，若要跑负权边请移步至[已死的算法](https://oi-wiki.org/graph/shortest-path/#%E9%98%9F%E5%88%97%E4%BC%98%E5%8C%96spfa)），和 BFS 相似，也要遍历大量的节点才找出一条路径。可是 A星思路却格外清奇——它设计了一个对当前节点进行估价的函数 $h(x)$ ，根据价值大小选择是否经过该节点，因此 A星算法得到的路径一定是耗材最少的路径，并且由于省去了大量无用遍历，它的执行效率也会快很多。

要实现 A星算法，我们首先就要对堆优化的 Dijkstra 进行一个小变动：

> 将 Dijkstra 所使用的记录距离的优先队列改为估价函数的优先队列。

其余的和 Dijkstra 也比较相似，我们需要遍历与该节点伸展出去的边，并入队这些边。当终点第一次出队时，跳出计算并返回最短值。

那么如何给点估价？我们首先要计算当前点 $x$ 到起点的真实距离并记作 $f(x)$ ；再将当前点到终点的估计距离（注意是估计出来的距离）记作 $g(x)$，那么估价函数 $h(x)=f(x)+g(x)$。注意到 Dijkstra 算法并不关心当前点到终点的估计距离，因此它是 $g(x)=0$ 恒成立的特殊情况。

### A-star 注意事项

1. 点的入队：在入队新点时，优先队列的排序关键字应该设为 $h(x)$，也就是 `dist[now] + f(now)` 的形式；特殊地，入队起点时应该将排序关键字设为 `f(now)`（此时显然 `dist[now]` 的值为 $0$）。
2. 估价函数的写法：估价函数不存在一个固定的模板。在[P1379 八数码难题](https://www.luogu.com.cn/problem/P1379)中，它是当前状态到目标状态的曼哈顿距离之和；在[P2901 Cow Jogging G](https://www.luogu.com.cn/problem/P2578)中，它又是当前点到终点的最短距离。因而对于不同的题目，估价函数都需要重新设定。
3. STL 使用的细节：优先队列 `priority_queue` 中若存储的是二元组 `pair`，那么将自动按照 `pair` 的第一关键字排序，且优先队列默认为大根堆（队头永远是最大的），而在实际算法中，我们更常使用小根堆，此时将优先队列定义为 `priority_queue<PAIR, vector<PAIR>, greater<PAIR>>` 即可。

### A-star 典例

#### 洛谷 P1379 八数码难题

题目传送门：[这里](https://www.luogu.com.cn/problem/P1379)

题目难度：<span data-luogu data-green>普及+/提高</span>

题目来源：<span data-luogu data-source>福建省历届夏令营</span>

> 在 $3\times 3$ 的棋盘上，摆有八个棋子，每个棋子上标有 $1$ 至 $8$ 的某一数字。棋盘中留有一个空格，空格用 $0$ 来表示。空格周围的棋子可以移到空格中。要求解的问题是：给出一种初始布局（初始状态）和目标布局（为了使题目简单,设目标状态为 $123804765$），找到一种最少步骤的移动方法，实现从初始布局到目标布局的转变。
>
> ---
>
> **输入**
>
> 输入初始状态，一行九个数字，空格用 $0$ 表示。
>
> **输出**
>
> 只有一行，该行只有一个数字，表示从初始状态到目标状态需要的最少移动次数。保证测试数据中无特殊无法到达目标状态数据。
>
> ---
>
> **样例输入 #1**
>
> ```
> 283104765
> ```
>
> **样例输出 #1**
>
> ```
> 4
> ```
>
> **样例 #1 解释**
>
> ![](https://cdn.luogu.com.cn/upload/image_hosting/7rhxbnup.png)
>
> 图中标有 $0$ 的是空格。绿色格子是空格所在位置，橙色格子是下一步可以移动到空格的位置。如图所示，用四步可以达到目标状态。
>
> 并且可以证明，不存在更优的策略。

先用朴素 BFS 的思路思考一遍，我们肯定是要枚举可能到达的状态，若当前状态和目标状态相同，则返回步数。由于 BFS 的最短路性质，在目标状态第一次弹出时即可返回步数。

考虑使用 A* 算法，我们就需要思考如何对状态估价，即计算当前状态与目标状态的差异度。不妨计算同一元素在当前状态和目标状态的曼哈顿距离（横坐标距离加上纵坐标距离），并对除开空格外的八个元素均使用此操作，并累加结果，就能得到描述两个状态的差异度的量了。

代码：

```cpp
#include <bits/stdc++.h>

using namespace std;

typedef pair<int, string> STATE;
unordered_map<string, int> dist;
priority_queue<STATE, vector<STATE>, greater<>> q;
string st, ed = "123804765";

int f(const string &now) {
    int res = 0;
    for (int i = 0; i < 9; i++) {
        if (now[i] == '0') continue;
        switch (now[i] - '0') {
            case 1:
            case 2:
            case 3:
                res += abs(i / 3) + abs(i % 3 - (now[i] - '1') % 3);
                break;
            case 4:
                res += abs(i / 3 - 1) + abs(i % 3 - 2);
                break;
            case 5:
                res += abs(i / 3 - 2) + abs(i % 3 - 2);
                break;
            case 6:
                res += abs(i / 3 - 2) + abs(i % 3 - 1);
                break;
            case 7:
                res += abs(i / 3 - 2) + abs(i % 3);
                break;
            case 8:
                res += abs(i / 3 - 1) + abs(i % 3);
                break;
        }
    }
    return res;
}

int bfs() {
    int dx[4] = {-1, 0, 1, 0}, dy[4] = {0, 1, 0, -1};
    q.push((STATE) {f(st), st});
    dist[st] = 0;
    while (!q.empty()) {
        STATE s = q.top();
        q.pop();
        if (s.second == ed) return dist[s.second];
        int idxx = 0, idxy = 0;
        for (int i = 0; i < 9; i++) {
            if (s.second[i] == '0') {
                idxx = i / 3, idxy = i % 3;
                break;
            }
        }
        string src = s.second;
        string tmp = s.second;
        for (int i = 0; i < 4; i++) {
            int nx = idxx + dx[i], ny = idxy + dy[i];
            if (nx < 0 || nx > 2 || ny < 0 || ny > 2) continue;
            tmp = src;
            swap(tmp[idxx * 3 + idxy], tmp[nx * 3 + ny]);
            if (!dist.count(tmp) || dist[tmp] > dist[src] + 1) {
                dist[tmp] = dist[src] + 1;
                q.push((STATE) {f(tmp) + dist[tmp], tmp});
            }
        }
    }
    return -1;
}

int main() {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.tie(nullptr);

    cin >> st;
    cout << bfs() << endl;

    return 0;
}
```

总用时：$117ms$ [记录](https://www.luogu.com.cn/record/157877038)

#### 洛谷 P2901 [USACO08MAR] Cow Jogging G

题目传送门：[这里](https://www.luogu.com.cn/problem/P2901)

题目难度：<span data-luogu data-blue>提高+/省选-</span>

题目来源：<span data-luogu data-source>USACO</span>&nbsp;&nbsp;<span data-luogu data-date>2008</span>

> 贝西终于尝到了懒惰的后果，决定每周从谷仓到池塘慢跑几次来健身。当然，她不想跑得太累，所以她只打算从谷仓慢跑下山到池塘，然后悠闲地散步回谷仓。
>
> 同时，贝西不想跑得太远，所以她只想沿着通向池塘的最短路径跑步。一共有 $M$ 条道路，其中每一条都连接了两个牧场。这些牧场从 $1$ 到 $N$ 编号，如果 $X>Y$，则说明牧场 $X$ 的地势高于牧场 $Y$，即下坡的道路是从 $X$ 通向 $Y$ 的，$N$ 为贝西所在的牛棚（最高点），$1$ 为池塘（最低点）。
>
> 然而，一周之后，贝西开始对单调的路线感到厌烦，她希望可以跑不同的路线。比如说，她希望能有 $K$ 种不同的路线。同时，为了避免跑得太累，她希望这 $K$ 条路线是从牛棚到池塘的路线中最短的 $K$ 条。如果两条路线包含的道路组成的序列不同，则这两条路线被认为是不同的。
>
> 请帮助贝西算算她的训练强度，即将牧场网络里最短的 $K$ 条路径的长度分别算出来。你将会被提供一份牧场间路线的列表，每条道路用 $(X_i, Y_i, D_i)$ 表示，意为从 $X_i$ 到 $Y_i$ 有一条长度为 $D_i$ 的下坡道路。
>
> ---
>
> **输入**
>
> 第一行三个用空格分开的整数 $N,M,K$，其中 。
>
> 第二行到第 $M+1$ 行每行有三个用空格分开的整数 $X_i,Y_i,D_i$，描述一条下坡的道路。
>
> **输出**
>
> 共 $K$ 行，在第 $i$ 行输出第 $i$ 短的路线长度，如果不存在则输出 $-1$。如果出现多种有相同长度的路线，务必将其全部输出。
>
> ---
>
> **数据范围**
>
> 对于全部的测试点，保证 $1 \le N \le 1,000$，$1 \le M \le 1\times10^4$，$1 \le K \le 100$，$1 \le Y_i < X_i\le N$，$1 \le D_i \le 1\times 10^6$，

**题意简化**：给定一张图，分别求从点 $n$ 到点 $1$ 的第 $1,2,\dots,k$ 短路的长度。

要想求这个问题，需要先明确下边的一条性质：

> 在 A* 算法中，当终点出队 $k$ 次时，此时经过的总距离就是第 $k$ 短路的距离。

因而我们设置一个 $[1,k]$ 的循环，分别求出对应情况的 $k$ 短路。需要注意的是，当此时的循环变量已经大于从起点到终点的总路径数时，自然就无需重复计算后面的情况，直接输出 $-1$ 就好。对于估价函数，我们在反图上跑一遍最短路即可。

代码：

```cpp
#include <bits/stdc++.h>

#define N 10010
using namespace std;

typedef long long ll;
typedef pair<ll, int> Point;
typedef pair<ll, Point> Star;

struct Edge {
    int ne, to;
    ll w;
} edges[N << 2];

int h[N], rh[N];
bool st[N];

priority_queue<Point, vector<Point>, greater<>> q;
priority_queue<Star, vector<Star>, greater<>> heap;
int astar_cnt = 0;
ll dist[N];
int idx = 0;
int n, m;

void add(int he[], int u, int v, ll w) {
    idx++;
    edges[idx].to = v;
    edges[idx].ne = he[u];
    edges[idx].w = w;
    he[u] = idx;
}

void dijkstra() {
    q.push((Point) {0, 1});
    dist[1] = 0;
    while (!q.empty()) {
        Point p = q.top();
        q.pop();
        int id = p.second;
        if (st[id]) continue;
        st[id] = true;
        for (int i = rh[id]; ~i; i = edges[i].ne) {
            int j = edges[i].to;
            if (dist[j] > dist[id] + edges[i].w) {
                dist[j] = dist[id] + edges[i].w;
                q.push((Point) {dist[j], j});
            }
        }
    }
}

ll a_star(int k) {
    heap.push((Star) {dist[n], (Point) {0, n}});
    while (!heap.empty()) {
        Star p = heap.top();
        heap.pop();
        if (p.second.second == 1) astar_cnt++;
        if (astar_cnt == k) return p.second.first;
        for (int i = h[p.second.second]; ~i; i = edges[i].ne) {
            int j = edges[i].to;
            heap.push((Star) {dist[j] + edges[i].w + p.second.first, (Point) {p.second.first + edges[i].w, j}});
        }
    }
    return -1;
}

void restore() {
    astar_cnt = 0;
    heap = priority_queue<Star, vector<Star>, greater<>>();
}

int main() {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.tie(nullptr);

    memset(h, -1, sizeof h);
    memset(rh, -1, sizeof rh);
    memset(dist, 0x3f, sizeof dist);

    int k;
    cin >> n >> m >> k;
    for (int i = 1; i <= m; i++) {
        int x, y;
        ll d;
        cin >> x >> y >> d;
        add(h, x, y, d);
        add(rh, y, x, d);
    }

    dijkstra();

    bool flag = false;
    for (int i = 1; i <= k; i++) {
        if (flag) cout << -1 << endl;
        else {
            restore();
            ll res = a_star(i);
            cout << res << endl;
            flag = (res == -1);
        }
    }

    return 0;
}
```
