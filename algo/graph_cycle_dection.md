# Cycle Detection

* [Detect Cycle in a Directed Graph](http://www.geeksforgeeks.org/detect-cycle-in-a-graph/)

DFS for a connected graph produces a tree. There is a cycle in a graph only if there is a back edge present in the graph.

* [Using Union-Find to detect cycle](http://www.geeksforgeeks.org/union-find/)

```python
def containCycles():
  # Init: Every vertices is in its own set
  for edge in edgs:
    a, b = edge
    if find(a) == find(b):
      return True
    join(a, b)
  return false
```

* [Detect cycle in an undirected graph](http://www.geeksforgeeks.org/detect-cycle-undirected-graph/): Same as directed graph
