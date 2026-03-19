#include <stdlib.h>
#include <stdio.h>
#include "heap.h"

#define PARENTOF(child) ((child-1)>>1)
#define LEFTCHILD(parent) ((parent<<1)+1)
#define RIGHTCHILD(parent) ((parent<<1)+2)

static void pushup(struct voidheap *heap) {
  int child = heap->len - 1;
  while (child) {
    const int parent = PARENTOF(child);
    if (heap->inorder(heap->vals[parent], heap->vals[child]))
      break;
    void *swap = heap->vals[parent];
    heap->vals[parent] = heap->vals[child];
    heap->vals[child] = swap;
    child = parent;
  }
}
static void pushdown(struct voidheap *heap, int parent) {
  int left;
  while ((left=LEFTCHILD(parent))<heap->len) {
    const int right=RIGHTCHILD(parent);
    if (right<heap->len) {
      const int child =
        (heap->inorder(heap->vals[left], heap->vals[right]))
          ? left : right;
      if (heap->inorder(heap->vals[parent], heap->vals[child]))
        break;
      void *swap = heap->vals[parent];
      heap->vals[parent] = heap->vals[child];
      heap->vals[child] = swap;
      parent = child;
    }
    else {
      if (!heap->inorder(heap->vals[parent], heap->vals[left])) {
        void *swap = heap->vals[parent];
        heap->vals[parent] = heap->vals[left];
        heap->vals[left] = swap;
      }
      break;
    }
  }
}
struct voidheap *mkheap(int size) {
  if (size < 1) size = 256;
  struct voidheap *heap = malloc(sizeof(struct voidheap));
  heap->len = 0;
  heap->size = size;
  heap->vals = malloc(sizeof(void*)*heap->size);
  return heap;
}
void heapinsert(struct voidheap *heap, void *val) {
  if (heap->len == heap->size) {
    heap->size += 256;
    void **newvals = realloc(heap->vals, sizeof(void*)*heap->size);
    if (!newvals) {
      newvals = malloc(sizeof(void*)*heap->size);
      if (!newvals) {
        fprintf(stderr,"Unable to insert value in heapinsert\n");
        return;
      }
      for (int i=0;i<heap->len;++i) {
        newvals[i] = heap->vals[i];
      }
      free(heap->vals);
      heap->vals = newvals;
    }
  }
  heap->vals[heap->len++] = val;
  pushup(heap);
}
void *popheap(struct voidheap *heap) {
  if (!heap->len) return NULL;
  void *pop = heap->vals[0];
  heap->vals[0] = heap->vals[--heap->len];
  pushdown(heap, 0);
  return pop;
}
void *popheapindex(struct voidheap *heap, int index) {
  if (index < 0 || index >= heap->len) return NULL;
  if (!index) return popheap(heap);
  if (index == --heap->len) return heap->vals[heap->len];
  void *pop = heap->vals[index];
  heap->vals[index] = heap->vals[heap->len];
  pushdown(heap, index);
  return pop;
}
void freeheap(struct voidheap *heap) {
  free(heap->vals);
  free(heap);
}
int heaplen(struct voidheap *heap) {
  return heap->len;
}
