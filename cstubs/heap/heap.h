#ifndef HEAP_H_
#define HEAP_H_

struct voidheap {
  void **vals;
  // return nonzero if a and b are in-order (a before b)
  int (*inorder)(const void *a, const void *b);
  int len;
  int size;
};

struct voidheap *mkheap(int size);
void heapinsert(struct voidheap *heap, void *val);
void *popheap(struct voidheap *heap);
void *popheapindex(struct voidheap *heap, int index);
void freeheap(struct voidheap *heap);
int heaplen(struct voidheap *heap);

#endif // HEAP_H_
