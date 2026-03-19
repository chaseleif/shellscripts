#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include "heap.h"

typedef struct voidheap intheap;

int maxorder(const void *a, const void *b) {
  return (*(int*)a >= *(int*)b)?1:0;
}
int minorder(const void *a, const void *b) {
  return (*(int*)a <= *(int*)b)?1:0;
}

int main(int argc,char **argv) {
  srand(time(NULL));
  intheap *heap = mkheap(256);
  heap->inorder = maxorder;
  for (int i=0;i<20;++i) {
    int *value = malloc(sizeof(int));
    *value = rand()%1000;
    heapinsert(heap, value);
  }
  printf("In-memory order:\n");
  printf("[");
  for (int i=0;i<heaplen(heap);++i) {
    if (i) printf(",");
    printf("%d",*(int*)heap->vals[i]);
  }
  printf("]\n");
  printf("Value order:\n");
  int *value = popheap(heap);
  printf("[%d", *value);
  free(value);
  while (heaplen(heap)) {
    value = popheap(heap);
    printf(",%d", *value);
    free(value);
  }
  printf("]\n");
  freeheap(heap);
  return EXIT_SUCCESS;
}
