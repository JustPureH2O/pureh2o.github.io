---
abbrlink: ''
categories:
- - oi算法
date: '2024-04-10T16:50:51.506545+08:00'
headimg: https://pic.imgdb.cn/item/6616567c68eb9357136382a9.jpg
keywords:
- Flood Fill
- 洪水填充算法
- Flood Fill C++
- 洪水搜索算法
seo_title: Flood Fill 洪水填充算法
tags:
- oi
- 算法
- 搜索算法
title: Flood Fill 算法——大自然的智慧
updated: '2024-04-24T15:52:19.632+08:00'
---
头图为成都锦城湖畔，与本文内容无关。

---

### Flood Fill 算法——大自然的智慧

$Once~upon~a~time$，在这个世界的某个角落，生活这一个人。祂喜欢田园般宁静的生活、还有OI。每至假期，祂便会扳着自己的小笔记本回到乡下老家，开始祂的内卷生活。

这天，下起了大雨，祂一如既往的坐在屋中刷题。这是一道搜索题，要求求出地图中连通块的个数。可是祂没学过BFS和DFS，冥思苦想了一会，祂变得比较烦躁。一缕阳光透过窗帘，照在祂紧握鼠标的右手上——雨停了，此时祂意识到，是时候放松一下自我，出门去转悠转悠了……

雨后的田地无比清香，雨珠垂挂在苇叶上，倒映着绿草蓝天……但是此时，祂一脚踩进了盛满泥水的土坑里，原本愉悦的心情瞬间化为乌有。泥水泼溅出去，流进了祂方才踩出的泥脚印里。看到这一幕，祂陷入了沉思，短短的两分钟后，祂似乎想到了什么，冲进屋里、打开电脑，又开始码起字来了……

---

~~以上纯属虚构~~

这段故事从某种角度上揭示了Flood Fill算法的基本工作原理——将深度相同的节点染上相同颜色。如同自然界中的洪水，总是从始发地开始，优先向海拔低于始发地的地点扩散，因此更高的地方就不会被淹没，自然也就不会被染色。在扫雷游戏中，消除无地雷的连通块也是基于这个原理实现的；而在画图软件中，填充颜色桶的实现也是这个原理（它甚至还是C语言中的一个函数）。

#### Flood Fill 算法实现

对于连通块的处理，分两种情况——四连通和八连通。前者将斜方向的四个方块判定为不连通、后者则是将某方块周围围绕的八个方块全部看作连通。如下图所示：

![](https://cdn.luogu.com.cn/upload/image_hosting/li8k6xtd.png)

（其中判定为与棕色方块连通的方块用绿色标出）

实现细节就是：在搜索下一个方块时，先判断是否连通，若连通则在该点进行 Flood Fill 算法。用DFS（递归）和BFS（队列）均可实现该算法。

**DFS版：**

```cpp
int matrix[N][N];
bool vis[N][N];
int n;

void floodfill(int x, int y, int color, int old_color) {
    if (1 <= x <= n && 1 <= y <= n && !vis[x][y] && matrix[x][y] == old_color) {
        vis[x][y] = true;
        matrix[x][y] = color;
        // 四连通
        floodfill(x + 1, y, color, old_color);
        floodfill(x, y + 1, color, old_color);
        floodfill(x - 1, y, color, old_color);
        floodfill(x, y - 1, color, old_color);
        // 八连通
//        floodfill(x + 1, y + 1, color, old_color);
//        floodfill(x + 1, y - 1, color, old_color);
//        floodfill(x - 1, y + 1, color, old_color);
//        floodfill(x - 1, y - 1, color, old_color);
    }
}
```

**BFS版：**

```cpp
struct Point {
    int x, y, color;
};

int matrix[N][N];
bool vis[N][N];
queue<Point> q;
int n;

void floodfill(int x, int y, int color, int old_color) {
    while (!q.empty()) {
        Point p = q.front();
        q.pop();
        if (1 <= p.x <= n && 1 <= p.y <= n && !vis[p.x][p.y] && p.color == old_color) {
            vis[p.x][p.y] = true;
            matrix[p.x][p.y] = color;
            // 四连通
            q.push((Point) {x + 1, y, matrix[x + 1][y]});
            q.push((Point) {x, y + 1, matrix[x][y + 1]});
            q.push((Point) {x - 1, y, matrix[x - 1][y]});
            q.push((Point) {x, y - 1, matrix[x][y - 1]});
            // 八连通
//            q.push((Point) {x + 1, y + 1, matrix[x + 1][y + 1]});
//            q.push((Point) {x + 1, y - 1, matrix[x + 1][y - 1]});
//            q.push((Point) {x - 1, y + 1, matrix[x - 1][y + 1]});
//            q.push((Point) {x - 1, y - 1, matrix[x - 1][y - 1]});
        }
    }
}
```

两端代码均实现将连通块内的数字更改为另一个数字的功能。

#### 洛谷 P1596 [USACO10OCT] Lake Counting S

题目传送门：[P1596](https://luogu.com.cn/problem/p1596)

题目难度：<span data-luogu data-orange>普及-</span>

题目来源：<span data-luogu data-source>USACO</span>&nbsp;&nbsp;<span data-luogu data-date>2010</span>

> 由于近期的降雨，雨水汇集在农民约翰的田地不同的地方。我们用一个 $N\times M(1\leq N\leq 100, 1\leq M\leq 100)$ 的网格图表示。每个网格中有水（`W`） 或是旱地（`.`）。一个网格与其周围的八个网格相连，而一组相连的网格视为一个水坑。约翰想弄清楚他的田地已经形成了多少水坑。给出约翰田地的示意图，确定当中有多少水坑。
>
> ---
>
> **输入输出：**
>
> 输入第 $1$ 行：两个空格隔开的整数： 和 。
>
> 第 $2$ 行到第  行：每行  个字符，每个字符是 W 或 .，它们表示网格图中的一排。字符之间没有空格。
>
> 输出一行，表示水坑的数量。
>
> ---
>
> **样例输入 #1**
>
> ```
> 10 12
> W........WW.
> .WWW.....WWW
> ....WW...WW.
> .........WW.
> .........W..
> ..W......W..
> .W.W.....WW.
> W.W.W.....W.
> .W.W......W.
> ..W.......W.
> ```
>
> **样例输出 #1**
>
> ```
> 3
> ```

Flood Fill 裸题，题目要求简化为输出由字符 $W$ 组成的连通块的总数，即可套用模板求解。

代码：

```cpp
#include <bits/stdc++.h>

#define N 110
using namespace std;

struct Point {
    int x, y;
};

int n, m;
char matrix[N][N];
bool vis[N][N];
queue<Point> q;

void floodfill(char color, char old_color) {
    while (!q.empty()) {
        Point p = q.front();
        q.pop();
        if (!vis[p.x][p.y] && 1 <= p.x <= n && 1 <= p.y <= m && matrix[p.x][p.y] == old_color) {
            vis[p.x][p.y] = true;
            matrix[p.x][p.y] = color;
            for (int i = p.x - 1; i <= p.x + 1; i++) {
                for (int j = p.y - 1; j <= p.y + 1; j++) {
                    q.push((Point) {i, j});
                }
            }
        }
    }
}

int main() {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.tie(nullptr);

    cin >> n >> m;
    for (int i = 1; i <= n; i++) {
        for (int j = 1; j <= m; j++) {
            cin >> matrix[i][j];
        }
    }
    int ans = 0;
    for (int i = 1; i <= n; i++) {
        for (int j = 1; j <= m; j++) {
            if (matrix[i][j] == 'W' && !vis[i][j]) {
                q.push((Point) {i, j});
                floodfill('.', 'W');
                ans++;
            }
        }
    }
    cout << ans << endl;
    return 0;
}
```

总用时：${34ms}$ [记录](https://www.luogu.com.cn/record/155237824)

#### 洛谷 P3456 [POI 2007] GRZ-Ridges and Valleys

题目传送门：[P3456](https://www.luogu.com.cn/problem/P3456)

题目难度：<span data-luogu data-green>普及+/提高</span>

题目来源：<span data-luogu data-source>POI</span>&nbsp;&nbsp;<span data-luogu data-date>2007</span>

> 给定一个地图，为小朋友想要旅行的区域，地图被分为n*n的网格，每个格子(i,j) 的高度w(i,j)是给定的。若两个格子有公共顶点，那么他们就是相邻的格子。（所以与(i,j)相邻的格子有(i-1, j-1),(i-1,j),(i-1,j+1),(i,j-1),(i,j+1),(i+1,j-1),(i+1,j),(i+1,j+1)）。我们定义一个格子的集合S为山峰（山谷）当且仅当：
>
> 1.S的所有格子都有相同的高度。
>
> 2.S的所有格子都联通3.对于s属于S，与s相邻的s’不属于S。都有ws > ws’（山峰），或者ws < ws’（山谷）。
>
> 你的任务是，对于给定的地图，求出山峰和山谷的数量，如果所有格子都有相同的高度，那么整个地图即是山峰，又是山谷。
>
> 输入 第一行包含一个正整数n，表示地图的大小（1<=n<=1000）。接下来一个n*n的矩阵，表示地图上每个格子的高度。(0<=w<=1000000000)
>
> 输出 应包含两个数，分别表示山峰和山谷的数量。
>
> 感谢@Blizzard 提供的翻译
>
> ---
>
> **输入输出：**
>
> 输入的第一行，为一个整数 $n$（${2\leq n\leq1000}$）。
>
> 接下来 $n$ 行，每行 $n$ 个数字，为高程图
>
> 输出仅一行，分别是地图中山峰和山谷的总数，用空格分开。
>
> ---
>
> **样例输入 #1：**
>
> ```
> 5
> 8 8 8 7 7
> 7 7 8 8 7
> 7 7 7 7 7
> 7 8 8 7 8
> 7 8 8 8 8
> ```
>
> **样例输出 #1**
>
> ```
> 2 1
> ```

显然山峰山谷只能是在同一高度上的连通块，在输入里体现为由同一数字组成的连通块。不难发现，这个题目是一个八连通问题。

整体思路架构在 Flood Fill 算法的基础上，只是我们需要对当前方块的连通方块进行高度判断，以确定该高度上的连通块是否是山峰或者山谷。考虑当 BFS 扫到的点的高度与当前连通块高度不同时，进行判断——如果周边存在一个连通方块，并且这个扩展方块的高度高于当前的方块，那么当前连通块显然不可能是山峰，反之亦然。

代码（这个题卡 `queue`，建议手写队列）：

```cpp
#include <bits/stdc++.h>
#define N 3010
#define x first
#define y second
using namespace std;

typedef long long ll;

typedef pair<int, int> Point;
int n;
int g[N][N];
bool vis[N][N];
Point q[N * N];

void floodfill(int x, int y, bool &not_peak, bool &not_valley) {
	q[0] = (Point) {x, y};
	int hh = 0, tt = 0;
	while (hh <= tt) {
		Point p = q[hh++];
		vis[p.x][p.y] = true;
		for (int i = p.x - 1; i <= p.x + 1; i++) {
			for (int j = p.y - 1; j <= p.y + 1; j++) {
				if (i == p.x && j == p.y) continue; 
				if (0 <= i && i < n && 0 <= j && j < n) {
					if (g[i][j] != g[p.x][p.y]) {
						if (g[i][j] < g[p.x][p.y]) not_valley = true;
						else not_peak = true;
					} else if (!vis[i][j]) {
						//q.push((Point) {i, j});
						q[++tt] = (Point) {i, j};
					}
				}
			}
		}
	}
}

int main() {
	ios::sync_with_stdio(false);
	cin.tie(nullptr);
	cout.tie(nullptr);

	cin >> n;
	for (int i = 0; i < n; i++) {
		for (int j = 0; j < n; j++) {
			cin >> g[i][j];
		}
	}

	int peak = 0, valley = 0;
	for (int i = 0; i < n; i++) {
		for (int j = 0; j < n; j++) {
			if (!vis[i][j]) {
				bool npeak = false, nvalley = false;
				floodfill(i, j, npeak, nvalley);
				if (!npeak) peak++;
				if (!nvalley) valley++;
			}
		}
	}

	cout << peak << ' ' << valley << endl;
	return 0;
}
```

总用时：${386ms}$ [记录](https://www.luogu.com.cn/record/155470579)
